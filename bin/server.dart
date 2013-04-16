
import 'dart:io';
import "package:rikulo_commons/io.dart";
import 'dart:async';
import 'classes/credential.dart';
import 'classes/account.dart';
import 'classes/user.dart';
import 'package:json_object/json_object.dart';

Map sfdcCredentials;

main() {
  // Compute base path for the request based on the location of the
  // script and then start the server.
  File script = new File(new Options().script);
  script.directory().then((Directory d) {
    startServer(d.path.substring(0, d.path.lastIndexOf('bin')) + 'web');
  });
}

startServer(String basePath) {

  HttpServer.bind('127.0.0.1', 9090).then((server) {
    
    print('Server started, Port 9090');
    print('Basepath for content is: ' + basePath);
    
    server.listen((HttpRequest request) {
      print("Received " + request.method + " request, url is: " + request.uri.path);
      
      switch (request.method) {
        case "GET": 
          if (request.uri.path.contains('api'))
            handleApi(request, basePath); 
          else
            handleGet(request, basePath);
          break;
        case "POST": 
          //handlePost(request); not yet implemente
          break;
        case "OPTIONS": 
          handleOptions(request);
          break;
      }  
    });
  });
}

handleApi  (HttpRequest request, String basePath) {
  
  HttpResponse res = request.response;
  addCorsHeaders(request, res);
  
  _getSessionId().then((Map credentials) {
    sfdcCredentials = credentials;
    
    switch (request.uri.path) {
      case '/api/accounts':
          Future<JsonObject> accnts = Account.getAllAccounts(sfdcCredentials['access_token'], sfdcCredentials['instance_url']);
          
          accnts.then((JsonObject jsonObj) {
            res.write(jsonObj.toString());
            res.close();
          });
          break;
      case '/api/users':          
          Future<JsonObject> orders = User.getAllUsers(sfdcCredentials['access_token'], sfdcCredentials['instance_url']);
          
          orders.then((JsonObject jsonObj) {
            res.write(jsonObj.toString());
            res.close();
          });
          break;
      }
  });  
}

/*
 * For production use, this would need to be modified to account for when the sessionid/token expires. A timer could be
 * used to automatically refresh it every 2 hrs.
 */
Future<Map> _getSessionId() {
    
  Completer<Map> respBody = new Completer<Map>();
  
  // if we already have an access token, don't bother refecthing call
  if (sfdcCredentials != null) {
    print ('reusing sfdc credentials');
 
    respBody.complete(sfdcCredentials);
    return respBody.future;
  }
  
  Future<JsonObject> url = Credential.getCredentials();
  
  url.then((JsonObject obj) {
    
    respBody.complete({ 'access_token' : obj.access_token, 'instance_url' : obj.instance_url });
  });
  
  return respBody.future;
}

handleGet (HttpRequest request, String basePath) {
  HttpResponse res = request.response;
  addCorsHeaders(request, res);
  
  switch (request.uri.path) {
    case '/':     
      // uncomment the following when not using dartium
      //sendFile(request, 'out/sfdcdemo.html', basePath);
      sendFile(request, 'sfdcdemo.html', basePath);
      break;
      
    default:
      // uncomment the following when not using dartium
      //sendFile(request, 'out/' + uriPath, basePath);
      sendFile(request, request.uri.path, basePath);
  }
}

void sendFile(HttpRequest request, String fileToServe, String basePath) {

  print("basepath is: " + '${basePath}' + fileToServe);
  
  final File file = new File('${basePath}' + fileToServe);
  
  file.exists().then((bool found) {
    if (found) {
      file.fullPath().then((String fullPath) {
        file.openRead()
        .pipe(request.response)
        .catchError((e) { });
      });
    } else {
      print("No matching file found for " + fileToServe);
      _sendNotFound(request.response);
    }
  });
}

void addCorsHeaders(HttpRequest request, HttpResponse res) {

  /*
   * For some reason, request.connectionInfo.remotePort doesn't return the correct port
   * when running through dartium, so I'm hardcoding to 3030 for now.
   */
  String allow = 'http://' + request.connectionInfo.remoteHost + ':' + '3030';
  
  res.headers.add("Access-Control-Allow-Origin", allow);
  res.headers.add("Access-Control-Allow-Methods", "OPTIONS, GET, PUT, POST, DELETE");
  res.headers.add("Access-Control-Allow-Credentials", "true");
  res.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  res.headers.add("Access-Control-Max-Age", "86400");
}

void handleOptions(HttpRequest req) {
  
  HttpResponse res = req.response;
  addCorsHeaders(req, res);
  print("${req.method}: ${req.uri.path}");
  res.statusCode = HttpStatus.NO_CONTENT;
  res.close();
}

_sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}
