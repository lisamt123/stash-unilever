trigger FA_Trigger_addTasksToOccMembers on FA_Pre_Work_Task_Assignment__c (after insert,after Update,before delete) {

     if(trigger.isInsert){
         List<FA_Pre_Work_Task_Assignment__c> tempPWTA=trigger.new;
         
         List<FA_Occurence_Member__c> listOfExistingOccMems=[select id,name,FA_Role__c,FA_Course_Occurence__c from FA_Occurence_Member__c where FA_Course_Occurence__c=:tempPWTA[0].FA_Occurence__c and FA_Role__c='Participant'];
         FA_addTasksToOccMembers.FA_associateTaskToOccMemAfterTaskInsert(tempPWTA[0],listOfExistingOccMems);
     }
 
     if(trigger.isUpdate){
         List<FA_Pre_Work_Task_Assignment__c> tempPWTAforUpdate=trigger.new;
         
         List<FA_Occurence_Member__c> listOfExistingOccMemsforUpdate=[select id,name,FA_Role__c,FA_Course_Occurence__c from FA_Occurence_Member__c where FA_Course_Occurence__c=:tempPWTAforUpdate[0].FA_Occurence__c and FA_Role__c='Participant'];
         FA_addTasksToOccMembers.FA_associateTaskToOccMemAfterTaskUpdate(tempPWTAforUpdate[0],listOfExistingOccMemsforUpdate);
     }
  
     if(trigger.isDelete){
     
     List<FA_Pre_Work_Task_Assignment__c> tempPWTAdeleted=trigger.old;
     system.debug('tempPWTAdeleted'+ tempPWTAdeleted);
     List<FA_Occurence_Member__c> listOfExistingOccMemsforDeleteOfTasks=[select id,name,FA_Role__c,FA_Course_Occurence__c from FA_Occurence_Member__c where FA_Course_Occurence__c=:tempPWTAdeleted[0].FA_Occurence__c and FA_Role__c='Participant'];
     FA_addTasksToOccMembers.FA_deleteTasksAtMemAfterPWAsmntDelete(tempPWTAdeleted[0],listOfExistingOccMemsforDeleteOfTasks);
     
     }
}