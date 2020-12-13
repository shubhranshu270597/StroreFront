/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 12-11-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   11-09-2020   shubhranshu   Initial Version
**/
@isTest
public class StoreFrontControllerTracker {
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
        
        Case caseobj = new Case();
        caseobj.AccountId = acc.Id;
        caseobj.Status = 'New';
        caseobj.Origin = 'Web';
        caseobj.Subject = 'test';
        caseobj.Description = 'test for dummy test for dummy test for dummy';
        caseobj.Priority = 'Medium';
        insert caseobj;

        Referral__c ref = new Referral__c ();
        ref.Name = 'test';
        ref.Account__c = acc.Id;
        ref.Email_Id__c = 'tesststsst1222@gmail.com';
        ref.MobileNumber__c = '9999000111';
        ref.Name__c = 'test';
        insert ref;

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

        Product_Bundle__c pbundle = new Product_Bundle__c();
        pbundle.Name = 'test';
        pbundle.Active__c = true;
        pbundle.Expire_Date__c = Date.today().addYears(1);
        pbundle.Products__c = 'test for dummy test for dummy test for dummy test for dummy test for dummy ';
        insert pbundle;

        Payment__c payment = new Payment__c();
        payment.Account__c = acc.Id;
        payment.User_Email__c = acc.Email_Id__c;
        payment.Amount__c = '2520.23';
        payment.Currency__c = 'INR';
        payment.fees__c = '0.25';
        payment.Longurl__c = 'https://test.instamojo.com/getpay/01545154sdvfsgvsjfas8dsa';
        payment.Payment_For__c = 'Anti virus App';
        payment.Payment_Id__c = 'MOJO0c10J05A80855523';
        payment.Payment_request_id__c = '01545154sdvfsgvsjfas8dsa';
        payment.Payment_Status__c = 'Payment Made'; 
        payment.Status__c = 'Credit';
        
        insert payment;
    }

    private class getPaymentsMock implements HttpCalloutMock {
        public Integer statusCode;
        getPaymentsMock(){
            statusCode = 200;
        }
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"success":true,"payment":{"payment_id":"MOJO0c10J05A80855523","status":"Credit","currency":"INR","amount":"7312.00","buyer_name":"Shubhranshu Panda","buyer_phone":"+919967780904","buyer_email":"shuboy345@gmail.com","shipping_address":null,"shipping_city":null,"shipping_state":null,"shipping_zip":null,"shipping_country":null,"quantity":1,"unit_price":"7312.00","fees":"138.93","variants":[],"custom_fields":{},"affiliate_commission":"0","payment_request":"https://test.instamojo.com/api/1.1/payment-requests/12e623c60d1d4d5c847e629c2fc2fd08/","instrument_type":"CARD","billing_instrument":"International Regular Credit Card (Visa/Mastercard)","tax_invoice_id":"","failure":null,"payout":null,"created_at":"2020-12-10T08:19:53.941915Z"}}';
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }

    static testMethod void testgetCustomerData(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();
        StoreFrontController.getCustomerData(acc.Id);
        Test.stopTest();
    }
    
    static testMethod void testgetCustomerData1(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();
        StoreFrontController.getCustomerDetails(acc.Id);
        Test.stopTest();
    }

    static testMethod void testgetProductsData(){
        PricebookEntry pentry = [Select Id,PriceBook2.Name,Product2Id,Product2.Name,Product2.ProductCode,Product2.Price_Type__c,
                                    Product2.Product_Quantity__c,UnitPrice From PricebookEntry LIMIT 1];
        Test.startTest();
        StoreFrontController.getProductsData(pentry.PriceBook2.Name);
        Test.stopTest();                                   
    }

    static testMethod void testgetProductBundlesData(){
        Product_Bundle__c bundle = [SELECT Id,Name,Active__c,Expire_Date__c,Products__c from Product_Bundle__c LIMIT 1];
        Test.startTest();
        StoreFrontController.getProductBundlesData();
        Test.stopTest();
    }

    static testMethod void testgetOpportunities(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();     
        StoreFrontController.getOpportunities(acc.Id);
		Test.stopTest();
    }

    static testMethod void testgetCases(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();     
        StoreFrontController.getCases(acc.Id);
        Test.stopTest();
    }

    static testMethod void testsaveComplaints(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Case caseobj = new Case();
        caseobj.Subject = 'test';
        caseobj.Description = 'test for dummy test for dummy test for dummy';
        caseobj.Priority = 'Medium';
        Test.startTest();     
        StoreFrontController.saveComplaints(caseobj,acc.Id);
        Test.stopTest();
    }

    static testMethod void testsaveReferral(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Referral__c ref = new Referral__c ();
        ref.Name = 'test';
        ref.Account__c = acc.Id;
        ref.Email_Id__c = 'tesststsst1222@gmail.com';
        ref.MobileNumber__c = '9999000111';
        ref.Name__c = 'test';
        Test.startTest();     
        StoreFrontController.saveReferral(ref,acc.Id);
        Test.stopTest();
    }

    static testMethod void testgetOpportunitiesWithoutWarrantySupport(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();     
        StoreFrontController.getOpportunitiesWithoutWarrantySupport(acc.Id);
		Test.stopTest();
    }

    static testMethod void testgetReferrals(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();     
        StoreFrontController.getReferrals(acc.Id);
        Test.stopTest();
    }

    static testMethod void testaddForWarrantySupport(){
        Opportunity opp = [SELECT Id,Warranty_Support__c,Warranty_Support_Start_Date__c, Warranty_Support_End_Date__c From Opportunity LIMIT 1];
        Test.startTest();
        StoreFrontController.addForWarrantySupport(opp.Id);
        Test.stopTest();
    }

    static testMethod void testaddOrdersAndChecout(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        List<String> lst = new List<String>();
        lst.add('Mobile Service');
        Test.startTest();     
        StoreFrontController.addOrdersAndChecout(acc.Id,lst);
        Test.stopTest();
    }

    static testMethod void testsaveProductBundle(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Product_Bundle__c prodBundle = [Select Id,Products__c from Product_Bundle__c LIMIT 1];
        Test.startTest();     
        StoreFrontController.saveProductBundle(prodBundle.Id,acc.Id);
        Test.stopTest();
    }

    static testMethod void testgetPayments(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();     
        StoreFrontController.getPayments(acc.Id);
        Test.stopTest();
    }
    static testMethod void testupdateCutsomerDetails(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Test.startTest();     
        StoreFrontController.updateCutsomerDetails(acc.Id,'test@gmail.com','888000001');
        Test.stopTest();
    }

    static testmethod void testsavePayment(){
        Account acc = [Select Id,User_Name__c,Password__c from Account LIMIT 1];
        Payment__c pay = [Select Id,Payment_Id__c,Payment_request_id__c from Payment__c LIMIT 1];
        Test.startTest();
        getPaymentsMock rest = new getPaymentsMock();
        Test.setMock(HttpCalloutMock.class,rest );
        StoreFrontController.savePayment('test', 'test',acc.Id);
        Test.stopTest();
    }
}