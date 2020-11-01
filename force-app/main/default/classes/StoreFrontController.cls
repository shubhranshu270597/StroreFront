/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 10-31-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   10-29-2020   shubhranshu   Initial Version
**/
public without sharing class StoreFrontController {
    
    @AuraEnabled(Cacheable = true)  
    public static Account getCustomerData(String recordId) {
    
        Account account = new Account();
        try{
            System.debug('recordId -->'+recordId);
            String query = getQueryAllFieldSql('Account','Id=:recordId',null);
            System.debug('query-->'+query);
            List<Account> lstacc = (List<Account>) DataBase.query(query);
            System.debug('lstacc-->'+lstacc);
                if(lstacc.size()>0){
                    account = lstacc[0];
                }else{
                    account = null;
                    System.debug('Record not found');
                }
            }catch(Exception e){
                System.debug('Exception '+e.getMessage());
            }   
        return account;
    }

    @AuraEnabled(Cacheable = true)  
    public static List<PricebookEntry> getProductsData(String PriceBookName) {
    
        List<PricebookEntry> entries = new List<PricebookEntry>();
        if(String.isNotBlank(PriceBookName)){
            entries = [Select Id,PriceBook2.Name,Product2Id,Product2.Name,Product2.ProductCode,Product2.Price_Type__c,
                        Product2.Product_Quantity__c,UnitPrice From PricebookEntry
                        Where PriceBook2.Name = :PriceBookName
                        and IsActive = true];
        }

        return entries;
    }


    @AuraEnabled
    public static String addOrdersAndChecout(String accountId,List<String> productsName){
        String result = '';
        System.debug('accountId -->'+accountId+ 'productsName '+productsName);
        String query = getQueryAllFieldSql('Contract','AccountId=:accountId LIMIT 1','Account.Name');
        System.debug('query-->'+query);
        List<Contract> lstcontr = (List<Contract>) DataBase.query(query);
        System.debug('lstcontr-->'+lstcontr);
        List<Order> lstorder = new List<Order>();
        if(lstcontr.size() > 0){
            for(String str:productsName){
                for(Contract contr:lstcontr){
                    Order order = new Order();
                    order.Order_Name__c = str;
                    order.AccountId = accountId;
                    order.ContractId = contr.Id;
                    order.EffectiveDate	= Date.today();
                    order.ShippingStreet = contr.BillingStreet;
                    order.ShippingCity = contr.BillingCity;
                    order.ShippingState	= contr.BillingState;
                    order.ShippingPostalCode = contr.BillingPostalCode;
                    order.ShippingCountry = contr.BillingCountry;
                    order.Status = 'Draft';
                    lstorder.add(order);
                }
            }

            try {
                insert lstorder;
                result='success';
            } catch (DMLException e) {
                System.debug('error '+e.getMessage());
                result = e.getMessage();
            }
        }
        return result;
    }

    @AuraEnabled
    public static String getQueryAllFieldSql(String SObjectAPIName,String conditionString,String relatedField){
        Map < String, schema.SObjectType > scemapMap = schema.getGlobalDescribe();
        Map < String, schema.SObjectField > fieldMap = scemapMap.get(SObjectAPIName).getDescribe().fields.getMap();
        List <String> fieldNames = new List <String> (fieldMap.keySet());
        if(relatedField !=null && relatedField !=''){
            fieldNames.add(relatedField);
        }
        String query = 'Select '+String.join( fieldNames, ',') +' from '+ SObjectAPIName +' where '+conditionString;
        return query;
    }
}