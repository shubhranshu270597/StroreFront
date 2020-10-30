/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 10-29-2020
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