/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 11-10-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   11-09-2020   shubhranshu   Initial Version
**/
@isTest(seeAllData=true)
public class ForexTriggerHandlerTracker {
    
    public static testMethod void testChangeProductPrice(){
        Test.startTest();
        Product2 producto =new Product2();
        producto.Name='Mobile Service';
        producto.productCode='1234';
        producto.isActive = true;
        
        insert producto;
        
        Pricebook2 standard = [Select Id, Name, IsActive From Pricebook2 where IsStandard = true LIMIT 1];
        
        PriceBook2 pb2=new PriceBook2();
        pb2.Name = 'Indian Price Book';
        pb2.IsActive = true;
      	
        insert pb2;
        
        PricebookEntry pbe = createPricebookEntry(standard,pb2,producto);
            
        Forex_rate__c forex = new Forex_rate__c();
        forex.Name = 'Exchange Rates';
        forex.USD__c = 1.0;
        forex.INR__c = 73.12;
        forex.EUR__c = 0.82;
        insert forex;

        Forex_rate__c rate = [Select Id,INR__c from Forex_rate__c Where Id=:forex.Id];
        rate.INR__c = 73.14;
        update rate;
        Test.stopTest();
    }

    public static PricebookEntry createPricebookEntry (Pricebook2 standard, Pricebook2 newPricebook, Product2 prod) {
	    System.debug('***** starting one');
	    PricebookEntry one = new PricebookEntry();
	    one.pricebook2Id = standard.id;
	    one.product2id = prod.id;
	    one.unitprice = 1249.0;
	    one.isactive = true;
	    insert one;
	    System.debug('***** one complete, ret next');
	    PricebookEntry ret = new PricebookEntry();
	    ret.pricebook2Id = newPricebook.id;
	    ret.product2id = prod.id;
	    ret.unitprice = 1250.0;
	    ret.isactive = true;
	    insert ret;
	    return ret;
	}
}
