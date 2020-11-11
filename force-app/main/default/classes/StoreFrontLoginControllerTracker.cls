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
public class StoreFrontLoginControllerTracker {
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

                    
        //Create Product
        Product2 pro = new Product2(Name = 'Mobile Service', Family = 'Mobile');
        Insert pro;
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        
        //Execute an update DML on the Pricebook2 record, to make IsStandard to true
        Update standardPricebook;
        
        //Query for the Pricebook2 record, to check IsStandard field
        standardPricebook = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook.Id];
        //It should return true
        System.assertEquals(true, standardPricebook.IsStandard);
        
        
        //Create the PricebookEntry
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        //Query the PricebookEntry record
        pbe = [SELECT Id, Pricebook2.IsStandard FROM PricebookEntry];
        //It should return true
        System.assertEquals(true, pbe.Pricebook2.IsStandard);
    }

    static testMethod void testSaveCustomerDetails(){
        Test.startTest();     
        Account acc = new Account();
        acc.Name = 'test test';
        acc.ShippingStreet = 'tst tststts test';
        acc.ShippingCity = 'Mumbai';
        acc.ShippingState = 'Maharashtra';
        acc.ShippingPostalCode = '400001';
        acc.ShippingCountry = 'India';
        acc.User_Name__c ='test123@gmail.com';
        acc.Password__c = '123';
        acc.Email_Id__c ='test123@gmail.com';
        acc.MobilePhone__c ='8888123456';
        acc.Country__c = 'India';
		StoreFrontLoginController.saveCustomerDetails(acc);
		Test.stopTest();
    }

    static testMethod void testAuthenticateLogin(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();
        StoreFrontLoginController.authenticateLogin(acc.User_Name__c,acc.Password__c);
        Test.stopTest();
    }
    
    static testMethod void testAuthenticateLogin1(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();
        StoreFrontLoginController.authenticateLogin(acc.User_Name__c,'1212121');
        Test.stopTest();
    }

    static testMethod void testAuthenticateLogin2(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();
        StoreFrontLoginController.authenticateLogin(acc.User_Name__c,'');
        Test.stopTest();
    }
}
