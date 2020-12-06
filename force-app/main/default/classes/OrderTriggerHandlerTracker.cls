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
public class OrderTriggerHandlerTracker {
    static testMethod void testaddOpportunties(){
        Test.startTest();
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
        
        Order ord = [Select Id,EffectiveDate from Order Where Id=:o.Id];
        ord.EffectiveDate = Date.today().addDays(2);
        update ord;

        Test.stopTest();
        
    }
}