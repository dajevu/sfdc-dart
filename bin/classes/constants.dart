library sfdc_constants;

class Constants {
  
  static const HOST = 'https://test.salesforce.com/';
  
  // URLs
  static const LOGIN = '${Constants.HOST}/services/oauth2/token';
  static const QUERY = '/services/data/v27.0/query?q=';
  static const FIND = '/services/data/v27.0/search?q='; 
  
  // following just illustrates how to invoke custom apex restful classes
  static const APPLICANT_CUSTOM = '/services/apexrest/Applicant/';
  
  // Content Types
  static const CT_FORM_POST = 'application/x-www-form-urlencoded';
  static const CT_JSON = 'application/json';
  
  // SFDC Queries
  static const QUERY_ACCOUNT_ALL = 'SELECT+id,name,type,description,industry+FROM+account+ORDER+BY+name';
  static const QUERY_USER_ALL = 'SELECT+id,username,firstname,lastname,companyname+FROM+user+ORDER+BY+username';
  
  // Login - you must configure remote access in salesforce using Setup->Develop->Remote Access. This will provide
  // you the values required to populate the client_id and client_secret fields below (replace what's inside the [] including the brackets).
  static const LOGIN_CREDENTIALS = 'grant_type=password&client_id=[enter-your-client-id]&client_secret=[enter-your-client-secret]&username=[your-sfdc-email-address]&password=[your-sfdc-password+sfdc-security-token]';

}

