/**
 * @description       : 
 * @author            : shubhranshu
 * @group             : 
 * @last modified on  : 10-31-2020
 * @last modified by  : shubhranshu
 * Modifications Log 
 * Ver   Date         Author        Modification
 * 1.0   10-31-2020   shubhranshu   Initial Version
**/
trigger OrderTrigger on Order (before insert, before update, after insert, after update) {

    if(trigger.isAfter && trigger.isInsert){
        if(OrderTriggerHandler.isFirstTime){
            OrderTriggerHandler.isFirstTime = false;
            OrderTriggerHandler obj = new OrderTriggerHandler();
            obj.AfterInsert(trigger.new, trigger.newmap);
        }
    }
    
    if(trigger.isBefore && trigger.isInsert){
        OrderTriggerHandler obj = new OrderTriggerHandler();
        obj.BeforeInsert(trigger.new, trigger.newmap);
    }
    
    if(trigger.isBefore && trigger.isUpdate){
        OrderTriggerHandler obj = new OrderTriggerHandler();
        obj.BeforeUpdate(trigger.New, trigger.oldMap);
    }
    
    if(trigger.isafter && trigger.isupdate){    
        if(OrderTriggerHandler.isFirstTime){
            OrderTriggerHandler.isFirstTime = false;              
            OrderTriggerHandler obj = new OrderTriggerHandler();
            obj.AfterUpdate(trigger.new, trigger.oldMap);
        }
    }
}