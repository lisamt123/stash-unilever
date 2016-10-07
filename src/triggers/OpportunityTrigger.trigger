trigger OpportunityTrigger on Opportunity (after insert, after update, before insert, before update) {

   FS_OpportunityHandler handler = new FS_OpportunityHandler();
       if(trigger.isBefore && trigger.isUpdate){      
        }
        if(trigger.isAfter){
            if(trigger.isInsert){
                system.debug('ISINSERT Call------------');                
                system.debug('Before onafterinsert Call');
                handler.onAfterInsert(trigger.newMap,trigger.new);
              
            }
            else if(trigger.isUpdate){
                handler.onAfterUpdate(trigger.newMap,Trigger.OldMap,trigger.new);
            }
        }
        if(trigger.isBefore){
            if(trigger.isInsert){
                handler.onBeforeInsert(trigger.new);              
            }
        }
        
  
}