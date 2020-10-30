/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 10-29-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   10-28-2020   shubhranshu   Initial Version
**/
public without sharing class StoreFrontLoginController {
    
    @AuraEnabled
    public static Account saveCustomerDetails(Account account){
        System.debug('account '+account);
        Map<String,String> mapofPriceBookIds = new Map<String,String>();
        for(Pricebook2 pb:[SELECT IsActive ,Description, IsStandard, Id, Name, SystemModstamp FROM Pricebook2 WHERE IsActive=True]){
            if(pb.NAME.contains('Germany')){
                mapofPriceBookIds.put('Germany',pb.Id);
            }
            if(pb.NAME.contains('Indian')){
                mapofPriceBookIds.put('India',pb.Id);
            }
            if(pb.NAME.contains('United State')){
                mapofPriceBookIds.put('United State',pb.Id);
            }
        }
        System.debug('mapofPriceBookIds '+mapofPriceBookIds);

        if(account != null){
            try{    
                insert account;
                System.debug('Account is inserted successfully...');
                Contract contract = new Contract();
                contract.AccountId = account.Id;
                contract.BillingCity = account.ShippingCity;
                contract.BillingCountry = account.ShippingCountry;
                contract.BillingState = account.ShippingState;
                contract.BillingStreet = account.ShippingStreet;
                contract.BillingPostalCode = account.ShippingPostalCode;
                contract.StartDate = date.today();
                contract.ContractTerm = 12;
                if(account.ShippingCountry == 'Germany'){
                    contract.Pricebook2Id = mapofPriceBookIds.get('Germany');
                }else if(account.ShippingCountry == 'India'){
                    contract.Pricebook2Id = mapofPriceBookIds.get('India');
                }else if(account.ShippingCountry == 'United State'){
                    contract.Pricebook2Id = mapofPriceBookIds.get('United State');
                }
                
                System.debug('contract '+contract);
                insert contract;
                System.debug('contract inserted successfully...');
            }catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
        }
        return account;
    }

    @AuraEnabled
    public static String authenticateLogin(String username,String password){
        String result = '';
        if(String.isNotBlank(username) && String.isNotBlank(password)){
            List<Account> lst = [SELECT Id,Name,User_Name__c,Password__c,Country__c from Account WHERE User_Name__c=:username and Password__c =:password LIMIT 1];
            System.debug('lst '+lst);
            if(lst.size() >0){
                result = lst[0].Id;
            }else{
                result = 'error';
            }
        }else{
            result = 'User Name or Password can not be empty...';
        }
        return result;
    }
}