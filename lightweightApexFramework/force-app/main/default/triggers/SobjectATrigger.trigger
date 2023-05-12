trigger SobjectTrigger on SObject (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    SObjectTriggerHandler handler = new SObjectTriggerHandler();
    
    if (Trigger.isBefore) {	

        handler.isBefore(Trigger.oldMap, Trigger.new);

        if (Trigger.isInsert){
            handler.isBeforeInsert(Trigger.new);
        } 
        else if (Trigger.isUpdate){
            handler.isBeforeUpdate(Trigger.oldMap, Trigger.new);
        } 
        else if (Trigger.isDelete){
            handler.isBeforeDelete(Trigger.oldMap);
        }
    }   
    else if (Trigger.isAfter) {

        handler.isAfter(Trigger.oldMap, Trigger.new);

        if (Trigger.isInsert){
            handler.isAfterInsert(Trigger.newMap);
        } 
        else if (Trigger.isUpdate){
            handler.isAfterUpdate(Trigger.oldMap, Trigger.new);
        } 
        else if (Trigger.isDelete) {
            handler.isAfterDelete(Trigger.oldMap);
        } 
        else if (Trigger.isUndelete) {
            handler.isAfterUnDelete(Trigger.newMap);
        }

        handler.doDML();

    } 
    
}