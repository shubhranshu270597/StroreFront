/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 12-08-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   12-08-2020   shubhranshu   Initial Version
**/
@isTest
public without sharing class StoreFrontPaymentWebhookAPITracker {
    @testSetup
    public static void setUpData(){
        Account acc = new Account();
        acc.Name = 'Test User';
        acc.Email_Id__c = 'test@gmail.com';
        acc.MobilePhone__c = '9990001234';
        acc.User_Name__c = 'test@gmail.com';
        acc.Password__c = 'test123';
        acc.Country__c = 'India';
        acc.ShippingCity = 'test';
        acc.ShippingCountry = 'India';
        acc.ShippingState = 'test';
        acc.ShippingStreet = 'test';
        acc.ShippingPostalCode = '000000';
        insert acc;

    }

    static testMethod void testcaptureLeadStatus(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Test.startTest();     
        RequestData(acc.Email_Id__c,acc.MobilePhone__c,'POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    static testMethod void testcaptureLeadStatus2(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Test.startTest();     
        RequestData(acc.Email_Id__c,'test','POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    static testMethod void testcaptureLeadStatus3(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Payment__c pay = new Payment__c();
        pay.Account__c = acc.Id;
        pay.Payment_Id__c = 'MOJO279572330104488';
        pay.Payment_request_id__c = 'c6abfacb4f32404e800ff2bae6546038';
        pay.Payment_Status__c = 'Paymet Made';
        pay.Status__c = 'Credit';
        insert pay;
        Test.startTest();     
        RequestData(acc.Email_Id__c,acc.MobilePhone__c,'POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    static testMethod void testcaptureLeadStatus4(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Payment__c pay = new Payment__c();
        pay.Account__c = acc.Id;
        pay.Payment_Id__c = 'MOJO279572330104488';
        pay.Payment_request_id__c = 'c6abfacb4f32404e800ff2bae6546038';
        pay.Payment_Status__c = 'Paymet Made';
        pay.Status__c = 'Credit';
        insert pay;
        Test.startTest();     
        RequestData2(acc.Email_Id__c,acc.MobilePhone__c,'POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    static testMethod void testcaptureLeadStatus5(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Payment__c pay = new Payment__c();
        pay.Account__c = acc.Id;
        pay.Payment_Id__c = 'MOJO279572330104488';
        pay.Payment_request_id__c = 'c6abfacb4f32404e800ff2bae6546038';
        pay.Payment_Status__c = 'Paymet Made';
        pay.Status__c = 'Credit';
        insert pay;
        Test.startTest();     
        RequestData3(acc.Email_Id__c,acc.MobilePhone__c,'POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    static testMethod void testcaptureLeadStatus6(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Payment__c pay = new Payment__c();
        pay.Account__c = acc.Id;
        pay.Payment_Id__c = 'MOJO279572330104488';
        pay.Payment_request_id__c = 'c6abfacb4f32404e800ff2bae6546038';
        pay.Payment_Status__c = 'Paymet Made';
        pay.Status__c = 'Credit';
        insert pay;
        Test.startTest();     
        RequestData4(acc.Email_Id__c,acc.MobilePhone__c,'POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    static testMethod void testcaptureLeadStatus7(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Payment__c pay = new Payment__c();
        pay.Account__c = acc.Id;
        pay.Payment_Id__c = 'MOJO279572330104488';
        pay.Payment_request_id__c = 'c6abfacb4f32404e800ff2bae6546038';
        pay.Payment_Status__c = 'Paymet Made';
        pay.Status__c = 'Credit';
        insert pay;
        Test.startTest();     
        RequestData5(acc.Email_Id__c,acc.MobilePhone__c,'POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    static testMethod void testcaptureLeadStatus8(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Payment__c pay = new Payment__c();
        pay.Account__c = acc.Id;
        pay.Payment_Id__c = 'MOJO279572330104488';
        pay.Payment_request_id__c = 'c6abfacb4f32404e800ff2bae6546038';
        pay.Payment_Status__c = 'Paymet Made';
        pay.Status__c = 'Credit';
        insert pay;
        Test.startTest();     
        RequestData6(acc.Email_Id__c,acc.MobilePhone__c,'POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    static testMethod void testcaptureLeadStatus9(){
        Account acc =[Select Id, Name,Email_Id__c,MobilePhone__c, User_Name__c,Country__c,Password__c FROM Account LIMIT 1];
        Payment__c pay = new Payment__c();
        pay.Account__c = acc.Id;
        pay.Payment_Id__c = 'MOJO279572330104488';
        pay.Payment_request_id__c = 'c6abfacb4f32404e800ff2bae6546038';
        pay.Payment_Status__c = 'Paymet Made';
        pay.Status__c = 'Credit';
        insert pay;
        Test.startTest();     
        RequestData7(acc.Email_Id__c,acc.MobilePhone__c,'POST');
		StoreFrontPaymentWebhookAPI.getPaymentStatus();
		Test.stopTest();
    }

    public static void RequestData(String EmailId,String MobilePhone,String requestMethod) {
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getPaymentStatus/V.1.0/';
        request.httpMethod= requestMethod;
        request.params.put('amount','2562.45');
        request.params.put('buyer',EmailId);
        request.params.put('buyer_name','Test User');
        request.params.put('buyer_phone',MobilePhone);
        request.params.put('currency','INR');
        request.params.put('fees','0.48');
        request.params.put('longurl','https://test.instamojo.com/@shuboypanda/c6abfacb4f32404e800ff2bae6546038');
        request.params.put('payment_id','MOJO279572330104488');
        request.params.put('payment_request_id','c6abfacb4f32404e800ff2bae6546038');
        request.params.put('purpose','Mobile Service');
        request.params.put('shorturl','');
        request.params.put('status','Credit');
        request.params.put('mac','cab305526418e0ecd9ec366027bea534204538a5');
        RestContext.request = request;
		RestContext.response = response;
    }

    public static void RequestData2(String EmailId,String MobilePhone,String requestMethod) {
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getPaymentStatus/V.1.0/';
        request.httpMethod= requestMethod;
        request.params.put('amount','');
        request.params.put('buyer',EmailId);
        request.params.put('buyer_name','Test User');
        request.params.put('buyer_phone',MobilePhone);
        request.params.put('currency','INR');
        request.params.put('fees','0.48');
        request.params.put('longurl','https://test.instamojo.com/@shuboypanda/c6abfacb4f32404e800ff2bae6546038');
        request.params.put('payment_id','MOJO279572330104488');
        request.params.put('payment_request_id','c6abfacb4f32404e800ff2bae6546038');
        request.params.put('purpose','Mobile Service');
        request.params.put('shorturl','');
        request.params.put('status','Credit');
        request.params.put('mac','cab305526418e0ecd9ec366027bea534204538a5');
        RestContext.request = request;
		RestContext.response = response;
    }

    public static void RequestData3(String EmailId,String MobilePhone,String requestMethod) {
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getPaymentStatus/V.1.0/';
        request.httpMethod= requestMethod;
        request.params.put('amount','2562.45');
        request.params.put('buyer','');
        request.params.put('buyer_name','Test User');
        request.params.put('buyer_phone',MobilePhone);
        request.params.put('currency','INR');
        request.params.put('fees','0.48');
        request.params.put('longurl','https://test.instamojo.com/@shuboypanda/c6abfacb4f32404e800ff2bae6546038');
        request.params.put('payment_id','MOJO279572330104488');
        request.params.put('payment_request_id','c6abfacb4f32404e800ff2bae6546038');
        request.params.put('purpose','Mobile Service');
        request.params.put('shorturl','');
        request.params.put('status','Credit');
        request.params.put('mac','cab305526418e0ecd9ec366027bea534204538a5');
        RestContext.request = request;
		RestContext.response = response;
    }

    public static void RequestData4(String EmailId,String MobilePhone,String requestMethod) {
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getPaymentStatus/V.1.0/';
        request.httpMethod= requestMethod;
        request.params.put('amount','2564.25');
        request.params.put('buyer',EmailId);
        request.params.put('buyer_name','');
        request.params.put('buyer_phone',MobilePhone);
        request.params.put('currency','INR');
        request.params.put('fees','0.48');
        request.params.put('longurl','https://test.instamojo.com/@shuboypanda/c6abfacb4f32404e800ff2bae6546038');
        request.params.put('payment_id','MOJO279572330104488');
        request.params.put('payment_request_id','c6abfacb4f32404e800ff2bae6546038');
        request.params.put('purpose','Mobile Service');
        request.params.put('shorturl','');
        request.params.put('status','Credit');
        request.params.put('mac','cab305526418e0ecd9ec366027bea534204538a5');
        RestContext.request = request;
		RestContext.response = response;
    }

    public static void RequestData5(String EmailId,String MobilePhone,String requestMethod) {
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getPaymentStatus/V.1.0/';
        request.httpMethod= requestMethod;
        request.params.put('amount','2562.45');
        request.params.put('buyer',EmailId);
        request.params.put('buyer_name','Test User');
        request.params.put('buyer_phone','');
        request.params.put('currency','INR');
        request.params.put('fees','0.48');
        request.params.put('longurl','https://test.instamojo.com/@shuboypanda/c6abfacb4f32404e800ff2bae6546038');
        request.params.put('payment_id','MOJO279572330104488');
        request.params.put('payment_request_id','c6abfacb4f32404e800ff2bae6546038');
        request.params.put('purpose','Mobile Service');
        request.params.put('shorturl','');
        request.params.put('status','Credit');
        request.params.put('mac','cab305526418e0ecd9ec366027bea534204538a5');
        RestContext.request = request;
		RestContext.response = response;
    }

    public static void RequestData6(String EmailId,String MobilePhone,String requestMethod) {
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getPaymentStatus/V.1.0/';
        request.httpMethod= requestMethod;
        request.params.put('amount','25645.25');
        request.params.put('buyer',EmailId);
        request.params.put('buyer_name','Test User');
        request.params.put('buyer_phone',MobilePhone);
        request.params.put('currency','INR');
        request.params.put('fees','0.48');
        request.params.put('longurl','');
        request.params.put('payment_id','MOJO279572330104488');
        request.params.put('payment_request_id','c6abfacb4f32404e800ff2bae6546038');
        request.params.put('purpose','Mobile Service');
        request.params.put('shorturl','');
        request.params.put('status','Credit');
        request.params.put('mac','cab305526418e0ecd9ec366027bea534204538a5');
        RestContext.request = request;
		RestContext.response = response;
    }

    public static void RequestData7(String EmailId,String MobilePhone,String requestMethod) {
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getPaymentStatus/V.1.0/';
        request.httpMethod= requestMethod;
        request.params.put('amount','2562.45');
        request.params.put('buyer','');
        request.params.put('buyer_name','Test User');
        request.params.put('buyer_phone',MobilePhone);
        request.params.put('currency','INR');
        request.params.put('fees','0.48');
        request.params.put('longurl','https://test.instamojo.com/@shuboypanda/c6abfacb4f32404e800ff2bae6546038');
        request.params.put('payment_id','MOJO279572330104488');
        request.params.put('payment_request_id','c6abfacb4f32404e800ff2bae6546038');
        request.params.put('purpose','');
        request.params.put('shorturl','');
        request.params.put('status','Credit');
        request.params.put('mac','cab305526418e0ecd9ec366027bea534204538a5');
        RestContext.request = request;
		RestContext.response = response;
    }

}
