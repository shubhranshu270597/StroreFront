/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 12-01-2020
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


    @AuraEnabled 
    public static List<Account> getCustomerDetails(String recordId) {
    
        List<Account> account = new List<Account>();
        try{
            System.debug('recordId -->'+recordId);
            String query = getQueryAllFieldSql('Account','Id=:recordId',null);
            System.debug('query-->'+query);
            List<Account> lstacc = (List<Account>) DataBase.query(query);
            System.debug('lstacc-->'+lstacc);
                if(lstacc.size()>0){
                    account = lstacc;
                }else{
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
                        Product2.Product_Quantity__c,UnitPrice,Product2.Image_URL__c From PricebookEntry
                        Where PriceBook2.Name = :PriceBookName
                        and IsActive = true];
        }

        return entries;
    }

    @AuraEnabled(Cacheable = true)  
    public static List<Product_Bundle__c> getProductBundlesData() {
    
        List<Product_Bundle__c> prodbundles = new List<Product_Bundle__c>();
        prodbundles = [Select Id,Name,Active__c,Expire_Date__c,Products__c,Image_URL__c From Product_Bundle__c Where Active__c = true and Expire_Date__c >: System.today()];

        return prodbundles;
    }

    @AuraEnabled
    public static List<Opportunity> getOpportunities(String recordId) {
    
        List<Opportunity> opplst = new List<Opportunity>();
        if(String.isNotBlank(recordId)){
            opplst = [Select Id,Name,AccountId,Type,LeadSource,Order__c,Order_Status__c,PriceBook_Id__c,Order_Name__c,Product_Quantity__c,User_Email__c,
                        OrderNumber__c,DeliveryInstallationStatus__c,Probability,StageName,CloseDate,ExpectedRevenue,Amount from Opportunity Where AccountId =: recordId];
        
        }
        return opplst;
    }

    @AuraEnabled
    public static List<Case> getCases(String recordId) {
    
        List<Case> caselst = new List<Case>();
        if(String.isNotBlank(recordId)){
            caselst = [Select Id,CaseNumber,AccountId,Account.Name,Type,Reason,CreatedDate,ClosedDate,Product__c,PotentialLiability__c,Subject,Description,
                       Status,Priority,ContactPhone,ContactEmail,Origin,EngineeringReqNumber__c,SLAViolation__c from Case Where AccountId =: recordId];
        
        }
        return caselst;
    }

    @AuraEnabled
    public static string saveComplaints(Case caseobj,String accountId){
        String result ='';
        if(String.isNotBlank(accountId) && caseobj != null){
            try {
                caseobj.AccountId = accountId;
                caseobj.Status = 'New';
                caseobj.Origin = 'Web';
                insert caseobj;
                result = 'success';

            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }else{
            result = 'Account Id can not be blank';
        }
        return result;
    }

    @AuraEnabled
    public static string saveReferral(Referral__c referral,String accountId){
        String result ='';
        if(String.isNotBlank(accountId) && referral != null){
            try {
                insert referral;
                Account acc = [Select Id, Referral_Points__c from Account Where Id=:accountId LIMIT 1];
                if(acc != null){
                    acc.Referral_Points__c = acc.Referral_Points__c > 0? acc.Referral_Points__c + 1 : 1;
                    update acc;
                }
                result = 'success';
            } catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }else{
            result = 'Account Id can not be blank';
        }
        return result;
    }    

    @AuraEnabled
    public static List<Opportunity> getOpportunitiesWithoutWarrantySupport(String recordId) {
    
        List<Opportunity> opplst = new List<Opportunity>();
        if(String.isNotBlank(recordId)){
            opplst = [Select Id,Name,AccountId,Type,LeadSource,Order__c,Order_Status__c,PriceBook_Id__c,Order_Name__c,Product_Quantity__c,User_Email__c,
                        OrderNumber__c,DeliveryInstallationStatus__c,Probability,StageName,CloseDate,ExpectedRevenue,Amount from Opportunity Where AccountId =: recordId and Warranty_Support__c = false];
        
        }
        return opplst;
    }

    @AuraEnabled
    public static List<Referral__c> getReferrals(String recordId) {
    
        List<Referral__c> reflst = new List<Referral__c>();
        if(String.isNotBlank(recordId)){
            reflst = [Select Id,Name,Name__c,Email_Id__c,MobileNumber__c,CreatedDate from Referral__c Where Account__c =: recordId];
        
        }
        return reflst;
    }

    @AuraEnabled
    public static string addForWarrantySupport(String recordId){
        String result = '';
        List<Opportunity> lst = [Select Id, Warranty_Support__c,Warranty_Support_Start_Date__c, Warranty_Support_End_Date__c from Opportunity Where Id =: recordId LIMIT 1];
        List<Opportunity> updatelst = new List<Opportunity>();

        if(lst.size()>0){
            
            for(Opportunity opp:lst){
                opp.Warranty_Support__c = true;
                opp.Warranty_Support_Start_Date__c = datetime.Now();
                opp.Warranty_Support_End_Date__c = datetime.Now().addYears(1);
                updatelst.add(opp);     
            }
            if(updatelst.size()>0){
                try {
                    update updatelst;
                    result = 'Warranty Support has been added successfully.';
                } catch (Exception e) {
                    throw new AuraHandledException(e.getMessage());
                }
            }else{
                result = 'Something went wrong';
            }
        }else{
            result = 'Product id not found';
        }
        return result;
    }
    
    @AuraEnabled
    public static List<Payment__c> getPayments(String recordId) {
    
        List<Payment__c> paylst = new List<Payment__c>();
        if(String.isNotBlank(recordId)){
            paylst = [Select Id,Account__c,Amount__c,Currency__c,fees__c,Instamojo_Refund_Response__c,Longurl__c,Mac_Id__c,Payment_For__c,Payment_Id__c,Payment_request_id__c,
                        Payment_Status__c,Refund_Amount_to_Proceed__c,Refunded__c,Refund_Status__c,Short_Url__c,Status__c,User_Email__c from Payment__c Where Account__c =: recordId];
        
        }
        return paylst;
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
                    order.Status = 'Active';
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
    public static string saveProductBundle(String prodId,String accountId){
        String result = '';
        try {
            List<Account> lstacc = [Select Id,Product_Bundle__c from Account Where Id=:accountId LIMIT 1];
            if(lstacc.size() >0 ){
                for(Account acc: lstacc){
                    if(acc.Product_Bundle__c == prodId){
                       return result = 'It seems to be this product bundle is already added in your cart';
                    }else{
                        acc.Product_Bundle__c = prodId;
                    }
                }
                update lstacc;
                result = 'success';
            }else{
                result = 'error';
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
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