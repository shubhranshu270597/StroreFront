/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 10-27-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   10-27-2020   shubhranshu   Initial Version
**/
public without sharing class OpportunityTriggerHandler {
    public static Boolean isFirstTime = true;
    public void BeforeInsert(List<Opportunity> triggerNew, map<id, Opportunity> NewMap) {
        // addPriceBookandProduct(triggerNew,NewMap);
    }

    public void AfterInsert(List<Opportunity> triggerNew, map<id, Opportunity> NewMap) {
        addPriceBookandProduct(triggerNew,NewMap);
    }

    public void BeforeUpdate(List<Opportunity> triggerNew, map<id, Opportunity> OldMap){

    }

    public void AfterUpdate(List<Opportunity> triggerNew, map<id, Opportunity> oldMap){
        addPriceBookandProduct(triggerNew,oldMap);
    }

    public void addPriceBookandProduct(List<Opportunity> lstOpp, Map<Id, Opportunity> mapOfOldOpp){
        
        Set<String> setOfOppIds = new Set<String>();
        Set<String> setOfpriceBookIds = new Set<String>();
        Set<String> setOfOrderNames = new Set<String>();

        List<OpportunityLineItem> oppLineItemlst = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppLineItemDeletelst = new List<OpportunityLineItem>();
        
        if(lstOpp.size() > 0){
            for(Opportunity opp:lstOpp){
                setOfOppIds.add(opp.id);
                setOfpriceBookIds.add(opp.PriceBook_Id__c);
                setOfOrderNames.add(opp.Order_Name__c);
            }
        }
        System.debug('setOfOppIds '+setOfOppIds);
        if(setOfOppIds.size()>0){
            List<Opportunity> lst = [SELECT Id,Name,PriceBook_Id__c,Order_Name__c,AccountId,Order__c from Opportunity Where Id in:setOfOppIds ];
            List<PriceBookEntry> lstpbe = [SELECT Id,UnitPrice,UseStandardPrice,Product2.Id, Product2.Name
                                                FROM PriceBookEntry 
                                                WHERE Pricebook2Id IN :setOfpriceBookIds];
            // List<OpportunityLineItem> lstOfexistingOppLineItem= [Select Id,OpportunityId,PricebookEntryId,UnitPrice,Quantity from OpportunityLineItem where OpportunityId IN :setOfpriceBookIds and ];
            Map<String,OpportunityLineItem> mapOfexistingOppLineItem= new Map<String,OpportunityLineItem>();
            for(OpportunityLineItem olitem: [Select Id,Name,Opportunity.Name,OpportunityId,PricebookEntryId,UnitPrice,Quantity from OpportunityLineItem where OpportunityId IN :setOfOppIds]){
                mapOfexistingOppLineItem.put(olitem.Name,olitem);
            }

            System.debug('lst '+lst+' lstpbe '+lstpbe +' mapOfexistingOppLineItem '+mapOfexistingOppLineItem);

            if(lstpbe.size() >0 && lst.size()>0){
                for(Opportunity opp:lst){
                    for(PriceBookEntry pbe :lstpbe){
                        if(opp.Order_Name__c == pbe.Product2.Name && !mapOfexistingOppLineItem.containsKey(opp.Name+' '+pbe.Product2.Name)){
                            OpportunityLineItem oppLineItem = new OpportunityLineItem();
                            oppLineItem.OpportunityId = opp.Id;
                            oppLineItem.PricebookEntryId = pbe.Id;
                            oppLineItem.UnitPrice = pbe.UnitPrice;
                            oppLineItem.Quantity = 1;
                            oppLineItemlst.add(oppLineItem);
                        }
                        if(opp.Order_Name__c != pbe.Product2.Name && !mapOfexistingOppLineItem.isEmpty()){
                            if(mapOfexistingOppLineItem.containsKey(opp.Name+' '+pbe.Product2.Name)){
                                oppLineItemDeletelst.add(mapOfexistingOppLineItem.get(opp.Name+' '+pbe.Product2.Name));
                            }
                        }
                    }
                }
                
                if(oppLineItemlst.size()>0){
                    System.debug('oppLineItemlst '+oppLineItemlst);
                    try {
                        insert oppLineItemlst;
                    } catch (DMLException e) {
                        System.debug('Error '+e.getMessage());
                    }
                }


                if(oppLineItemDeletelst.size()>0){
                    System.debug('oppLineItemDeletelst '+oppLineItemDeletelst);
                    try {
                        delete oppLineItemDeletelst;
                    } catch (DMLException e) {
                        System.debug('error while delete ===>'+e.getMessage());
                    }
                }
            
            }
        }
    }

}