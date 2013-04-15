library sfdc.account;

import 'dart:async';
import 'dart:io';
import 'package:json_object/json_object.dart';
import "dart:uri";
import 'constants.dart';
import 'sfdcUtils.dart';
import 'credential.dart';
import 'package:unittest/unittest.dart';

class Account {
  
   static Future<JsonObject> getAllAccounts(String sessionId, String host) {
     
     Completer<JsonObject> accntResponse = new Completer<JsonObject>();
     
     Future<JsonObject> reply = SFDCUtils.getRequest('${host}${Constants.QUERY}${Constants.QUERY_ACCOUNT_ALL}', sessionId);
 
     reply.then( (JsonObject response) {
       accntResponse.complete(response);
     });
     
     return accntResponse.future;
   }
   
}

main () {

  test('Account', () {
    Future<JsonObject> url = Credential.getCredentials();
    
    url.then((JsonObject obj) {
      
      String tokenId = obj.access_token;
      String host = obj.instance_url;
      
      
      Future<JsonObject> accnts = Account.getAllAccounts(tokenId, host);
      
      accnts.then((JsonObject jsonObj) {
        expect(jsonObj.totalSize > 0, true);
      });
    });
  });  
  
}

