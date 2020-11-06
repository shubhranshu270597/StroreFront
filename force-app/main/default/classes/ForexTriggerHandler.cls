/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 11-05-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   11-05-2020   shubhranshu   Initial Version
**/
public without sharing class ForexTriggerHandler {
    public static Boolean isFirstTime = true;
    public void BeforeInsert(List<Forex_rate__c> triggerNew, map<id, Forex_rate__c> NewMap) {
        // addPriceBookandProduct(triggerNew,NewMap);
    }

    public void AfterInsert(List<Forex_rate__c> triggerNew, map<id, Forex_rate__c> NewMap) {
        changeProductPrice(triggerNew,NewMap);
    }

    public void BeforeUpdate(List<Forex_rate__c> triggerNew, map<id, Forex_rate__c> OldMap){

    }

    public void AfterUpdate(List<Forex_rate__c> triggerNew, map<id, Forex_rate__c> oldMap){
        changeProductPrice(triggerNew,oldMap);
    }

    public void changeProductPrice(List<Forex_rate__c> lstForexrate, Map<Id, Forex_rate__c> mapOfOldOpp){
        List<PricebookEntry>  lstentriesind = [Select Id,PriceBook2.Name,Product2Id,Product2.Name,Product2.ProductCode,Product2.Price_Type__c,
                                            Product2.Product_Quantity__c,UnitPrice From PricebookEntry
                                            Where  PriceBook2.Name != 'Standard' and PriceBook2.Name != 'Standard Price Book' and 
                                            PriceBook2.Name = 'Indian Price Book' and IsActive = true];
        List<PricebookEntry>  lstentriesusd = [Select Id,PriceBook2.Name,Product2Id,Product2.Name,Product2.ProductCode,Product2.Price_Type__c,
                                            Product2.Product_Quantity__c,UnitPrice From PricebookEntry
                                            Where  PriceBook2.Name != 'Standard' and PriceBook2.Name != 'Standard Price Book' and 
                                            PriceBook2.Name = 'United State Price Book' and IsActive = true];
        List<PricebookEntry>  lstentrieseur = [Select Id,PriceBook2.Name,Product2Id,Product2.Name,Product2.ProductCode,Product2.Price_Type__c,
                                            Product2.Product_Quantity__c,UnitPrice From PricebookEntry
                                            Where  PriceBook2.Name != 'Standard' and PriceBook2.Name != 'Standard Price Book' and 
                                            PriceBook2.Name = 'Netherlands Price Book' and IsActive = true];
                                                                                        
        List<Forex_rate__c> lst = [SELECT Id,Name,EUR__c,INR__c,USD__c from Forex_rate__c Where Name ='Exchange Rates' 
                                    ORDER BY CreatedDate desc LIMIT 1];
        if(lst.size()>0 && lstentriesusd.size() >0){
            if(lstentriesind.size()>0){
                for(PricebookEntry priceUsd: lstentriesusd){
                    for(PricebookEntry priceentry: lstentriesind){
                        if(priceUsd.Product2.Name == priceentry.Product2.Name){
                            priceentry.UnitPrice = priceUsd.UnitPrice * lst[0].INR__c;
                        }
                    }   
                }
            }
            if(lstentrieseur.size()>0){
                for(PricebookEntry priceUsd: lstentriesusd){
                    for(PricebookEntry priceentry: lstentrieseur){
                        if(priceUsd.Product2.Name == priceentry.Product2.Name){
                            priceentry.UnitPrice = priceUsd.UnitPrice * lst[0].EUR__c;
                        }
                    }   
                }
            }

            try {
                System.debug('lstentriesind '+lstentriesind);
                update lstentriesind;
                System.debug('lstentrieseur'+lstentrieseur);
                update lstentrieseur;
                
            } catch (DMLException e) {
                System.debug('Error '+e.getMessage());
            }
        }
    }
}