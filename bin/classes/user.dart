library sfdc.user;

import 'dart:async';
import 'dart:io';
import 'package:json_object/json_object.dart';
import "dart:uri";
import 'constants.dart';
import 'sfdcUtils.dart';
import 'credential.dart';
import 'package:unittest/unittest.dart';

class User {
  
  static Future<JsonObject> getAllUsers(String sessionId, String host) {
    
    Completer<JsonObject> userResponse = new Completer<JsonObject>();
    
    Future<JsonObject> reply = SFDCUtils.getRequest('${host}${Constants.QUERY}${Constants.QUERY_USER_ALL}', sessionId);
    
    reply.then( (JsonObject response) {
      userResponse.complete(response);
    });
    
    return userResponse.future;
  }
  
}

main () {

  test('User', () {
    
    // First thing we do is get our session/token id 
    Future<JsonObject> url = Credential.getCredentials();
    
    url.then((JsonObject obj) {
      
      String tokenId = obj.access_token;
      String host = obj.instance_url;
      
      // Now, perform the query
      Future<JsonObject> users = User.getAllUsers(tokenId, host);
      
      users.then((JsonObject jsonObj) {
        expect(jsonObj.totalSize > 0, true);
      });
    });
  });  
  
}

