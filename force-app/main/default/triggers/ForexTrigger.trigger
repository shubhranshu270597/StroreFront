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
trigger ForexTrigger on Forex_rate__c (before insert, before update, after insert, after update) {

    if(trigger.isAfter && trigger.isInsert){
        if(ForexTriggerHandler.isFirstTime){
            ForexTriggerHandler.isFirstTime = false;
            ForexTriggerHandler obj = new ForexTriggerHandler();
            obj.AfterInsert(trigger.new, trigger.newmap);
        }
    }
    
    if(trigger.isBefore && trigger.isInsert){
        ForexTriggerHandler obj = new ForexTriggerHandler();
        obj.BeforeInsert(trigger.new, trigger.newmap);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        ForexTriggerHandler obj = new ForexTriggerHandler();
        obj.BeforeUpdate(trigger.New, trigger.oldMap);
    }
    
    if(trigger.isafter && trigger.isupdate){    
        if(ForexTriggerHandler.isFirstTime){
            ForexTriggerHandler.isFirstTime = false;              
            ForexTriggerHandler obj = new ForexTriggerHandler();
            obj.AfterUpdate(trigger.new, trigger.oldMap);
        }
    }
    
}