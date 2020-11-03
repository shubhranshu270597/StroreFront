/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 11-01-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   10-31-2020   shubhranshu   Initial Version
**/
public without sharing class OrderTriggerHandler {
    public static Boolean isFirstTime = true;
    public void BeforeInsert(List<Order> triggerNew, map<id, Order> NewMap) {
        // addPriceBookandProduct(triggerNew,NewMap);
    }

    public void AfterInsert(List<Order> triggerNew, map<id, Order> NewMap) {
        addOpportunties(triggerNew,NewMap);
    }

    public void BeforeUpdate(List<Order> triggerNew, map<id, Order> OldMap){

    }

    public void AfterUpdate(List<Order> triggerNew, map<id, Order> oldMap){
        addOpportunties(triggerNew,oldMap);
    }

    public void addOpportunties(List<Order> lstOrder, Map<Id, Order> mapOfOldOpp){
        
        Set<String> setOfOrderIds = new Set<String>();
        
        if(lstOrder.size() > 0){
            for(Order ord:lstOrder){
                setOfOrderIds.add(ord.id);
            }
        }
        System.debug('setOfOrderIds '+setOfOrderIds);
        if(setOfOrderIds.size()>0){
            List<Order> lst = [SELECT Id,Name,OrderNumber,ContractId,AccountId,Account.Name,Account.Email_Id__c,Order_Name__c,EffectiveDate,ShippingStreet,ShippingCity,ShippingState,
                                ShippingPostalCode,ShippingCountry from Order Where Id in:setOfOrderIds ];
            
            List<Opportunity> lstopp = new List<Opportunity>();

            if(lst.size()>0){
                for(Order ord:lst){
                    Opportunity op = new Opportunity();
                    op.Name = ord.Account.Name+' - '+ord.Order_Name__c	;
                    op.AccountId = ord.AccountId;
                    op.Type	= 'New Customer';
                    op.LeadSource = 'Web';
                    op.CloseDate = ord.EffectiveDate.addDays(180);
                    op.StageName = 'Prospecting';
                    op.DeliveryInstallationStatus__c = 'In Progress';
                    op.Order__c	= ord.Id;
                    op.OrderNumber__c = ord.OrderNumber;
                    op.Product_Quantity__c	= 1;
                    op.User_Email__c = ord.Account.Email_Id__c;
                    lstopp.add(op);
                }

                if(lstOpp.size()>0){
                    try {
                        insert lstOpp;
                    } catch (DMLException e) {
                        System.debug('error '+e.getMessage());
                    }
                }
            }
        }
    }
}