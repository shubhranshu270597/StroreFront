/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 11-09-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   11-09-2020   shubhranshu   Initial Version
**/
@isTest
public class OrderStatusAPITracker {
    
    @testSetup
    public static void setUpData(){
        Account acc = new Account();
        acc.Name = 'test test';
        acc.ShippingStreet = 'tst tststts test';
        acc.ShippingCity = 'Mumbai';
        acc.ShippingState = 'Maharashtra';
        acc.ShippingPostalCode = '400001';
        acc.ShippingCountry = 'India';
        acc.User_Name__c ='test@gmail.com';
        acc.Password__c = '123';
        acc.Email_Id__c ='test@gmail.com';
        acc.MobilePhone__c ='8888123456';
        acc.Country__c = 'India';
        insert acc;
        
        Contract contract = new Contract();
        contract.AccountId = acc.Id;
        contract.BillingCity = acc.ShippingCity;
        contract.BillingCountry = acc.ShippingCountry;
        contract.BillingState = acc.ShippingState;
        contract.BillingStreet = acc.ShippingStreet;
        contract.BillingPostalCode = acc.ShippingPostalCode;
        contract.StartDate = date.today();
        contract.ContractTerm = 12;
        insert contract;

        Order o = new Order();
        o.Order_Name__c = 'Mobile Service';
        o.AccountId = acc.Id;
        o.EffectiveDate = Date.today();
        o.Status = 'Active';
        o.ContractId  = contract.Id;
        o.ShippingStreet = contract.BillingStreet;
        o.ShippingCity = contract.BillingCity;
        o.ShippingState	= contract.BillingState;
        o.ShippingPostalCode = contract.BillingPostalCode;
        o.ShippingCountry = contract.BillingCountry;
        insert o;
        
    }

    static testMethod void testgetOrderStatus(){
        Opportunity opp = [Select Id,Name,AccountId,Type,LeadSource,Order__c,Order_Status__c,PriceBook_Id__c,Order_Name__c,Product_Quantity__c,User_Email__c,
            OrderNumber__c,DeliveryInstallationStatus__c,Probability,StageName,CloseDate,ExpectedRevenue,Amount from Opportunity LIMIT 1];

        Test.startTest();     
        RequestData(opp.OrderNumber__c,'POST');
		OrderStatusAPI.getOrderStatus();
		Test.stopTest();
    }

    static testMethod void testgetOrderStatus1(){
        Test.startTest();     
        RequestData('0000','POST');
		OrderStatusAPI.getOrderStatus();
		Test.stopTest();
    }

    static testMethod void testgetOrderStatus2(){
        Test.startTest();     
        RequestData('','POST');
		OrderStatusAPI.getOrderStatus();
		Test.stopTest();
    }

    public static void RequestData(String orderId,String requestMethod) {
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest();
        request.requestURI = 'https://storefront-developer-edition.ap18.force.com/StoreFront/services/apexrest/getMyOrdersStatus/V.1.0';
        request.httpMethod=requestMethod;
        request.params.put('orderId',orderId);
        RestContext.request = request;
		RestContext.response = response;
    }
}