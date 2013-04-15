library sfdc;

import 'dart:async';
import 'credential.dart';
import 'dart:io';
import 'package:rikulo_commons/io.dart';
import "dart:uri";
import 'package:json_object/json_object.dart';
import 'constants.dart';

class SFDCUtils {
 
  static Future<JsonObject> postRequest(String url, String postData, [String contentType = Constants.CT_JSON]) {
    
    HttpClient client = new HttpClient();
    
    print('request url is: ' + url);
    
    Completer<JsonObject> respBody = new Completer<JsonObject>();
    
    var requestUri = new Uri.fromString(url);
    
    var conn = client.postUrl(requestUri); 
    
    conn.then ((HttpClientRequest request) {
      request.headers.add(HttpHeaders.CONTENT_TYPE, contentType);
      request.write(postData);
      request.close(); 
      request.response.then( (response) {
        
        IOUtil.readAsString(response, onError: null).then((body) {         
          print('response body is: ' + body);
          
          respBody.complete(new JsonObject.fromJsonString(body));
        
          client.close();
        });
        
      });
      
    });
    
    return respBody.future;
  }
  
  static Future<JsonObject> getRequest(String url, String sessionId, [String contentType = Constants.CT_JSON]) {
    
    HttpClient client = new HttpClient();
    
    Completer<JsonObject> respBody = new Completer<JsonObject>();
    
    print('getURL is: ' + url);
    
    var requestUri = new Uri.fromString(url);
    
    var conn = client.getUrl(requestUri);
    
    conn.then ((HttpClientRequest request) {
      request.headers.add(HttpHeaders.CONTENT_TYPE, contentType);
      request.headers.add('Authorization', 'Bearer ${sessionId}');
      request.close(); 
      request.response.then( (response) {
        
        IOUtil.readAsString(response, onError: null).then((body) {         
          print('response body is: ' + body);
          
          respBody.complete(new JsonObject.fromJsonString(body));
        
          client.close();
        });        
      });      
    });    
    return respBody.future;
  }
}

main () {
  
 
}

