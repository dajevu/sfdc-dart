library sfdc.credential;

import 'dart:async';
import 'dart:io';
import 'package:json_object/json_object.dart';
import "dart:uri";
import 'constants.dart';
import 'sfdcUtils.dart';
import 'package:unittest/unittest.dart';

class Credential {
  
  Credential();
  
  static Future<JsonObject> getCredentials() {
    Completer<JsonObject> credResponse = new Completer<JsonObject>();
    
    Future<JsonObject> reply = SFDCUtils.postRequest(Constants.LOGIN, Constants.LOGIN_CREDENTIALS, Constants.CT_FORM_POST); 
  
    reply.then( (JsonObject response) {
      credResponse.complete(response);
    });
    
    return credResponse.future;
  }
}

main () {
  
  test('Credential', () {
      Future<JsonObject> url = Credential.getCredentials();
      
      url.then((JsonObject obj) {
        expect (obj.instance_url, 'https://cs15.salesforce.com');
      });
  });
}

