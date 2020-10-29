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
trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {

    if(trigger.isAfter && trigger.isInsert){
        if(OpportunityTriggerHandler.isFirstTime){
            OpportunityTriggerHandler.isFirstTime = false;
            OpportunityTriggerHandler obj = new OpportunityTriggerHandler();
            obj.AfterInsert(trigger.new, trigger.newmap);
        }
    }
    
    if(trigger.isBefore && trigger.isInsert){
        OpportunityTriggerHandler obj = new OpportunityTriggerHandler();
        obj.BeforeInsert(trigger.new, trigger.newmap);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        OpportunityTriggerHandler obj = new OpportunityTriggerHandler();
        obj.BeforeUpdate(trigger.New, trigger.oldMap);
    }
    
    if(trigger.isafter && trigger.isupdate){    
        if(OpportunityTriggerHandler.isFirstTime){
            OpportunityTriggerHandler.isFirstTime = false;              
            OpportunityTriggerHandler obj = new OpportunityTriggerHandler();
            obj.AfterUpdate(trigger.new, trigger.oldMap);
        }
    }
}