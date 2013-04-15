import 'dart:html';
import 'package:web_ui/web_ui.dart';
import 'dart:async';
import 'package:json_object/json_object.dart';

void main() {
  // Enable this to use Shadow DOM in the browser.
  //useShadowDom = true;
  
  populateAccountsTable();
  
  populateUsersTable();

}

void populateAccountsTable() {
   
  HttpRequest.getString('http://localhost:9090/api/accounts').then( (String results ) {
    
    JsonObject rval = new JsonObject.fromJsonString(results);
    
    rval.records.forEach((accnt) {
      var tr = new Element.html('''
          <tr>
            <td>${accnt.Id}</td>
            <td>${accnt.Name}</td>
            <td>${accnt.Type}</td>
            <td>${accnt.Description}</td>
            <td>${accnt.Industry}</td>
          </tr>
      ''');
      
      query('#accounttable').nodes.add(tr);
    });    
  });
}

void populateUsersTable() {
  
  HttpRequest.getString('http://localhost:9090/api/users').then( (String results ) {
    
    JsonObject rval = new JsonObject.fromJsonString(results);
    
    rval.records.forEach((user) {
      var tr = new Element.html('''
          <tr>
            <td>${user.Username}</td>
            <td>${user.FirstName}</td>
            <td>${user.LastName}</td>
            <td>${user.CompanyName}</td>
            <td>${user.Id}</td>
          </tr>
      ''');
      
      query('#usertable').nodes.add(tr);
    });    
  });
}