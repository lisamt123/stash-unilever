Public Class FA_addTasksToOccMembers{

        public static void FA_associateTaskToOccMemAfterTaskInsert(FA_Pre_Work_Task_Assignment__c newTask,List<FA_Occurence_Member__c> listOffAssociatedMems) {
             
             List<FA_Pre_Work_Task__c> listOfNewPreWorkTask=new List<FA_Pre_Work_Task__c>();
             
             for(FA_Occurence_Member__c oms:listOffAssociatedMems){
             
                     FA_Pre_Work_Task__c newPreWorkTask=new FA_Pre_Work_Task__c();
                     
                     newPreWorkTask.FA_OccurenceOM__c=newTask.FA_Occurence__c;
                     newPreWorkTask.FA_Due_Date__c=newTask.FA_Due_Date__c; 
                     newPreWorkTask.FA_OccMember__c=oms.Id;
                     newPreWorkTask.FA_Occurence_Task__c=newTask.Id;
                     newPreWorkTask.FA_Task_Description__c=newTask.FA_Task_Description_PWTA__c;
                     newPreWorkTask.FA_Task_Name__c=newTask.FA_Task_Name_PWTA__c;
                     
                     listOfNewPreWorkTask.add(newPreWorkTask);
             }
             try{
                 insert listOfNewPreWorkTask;
             }
             catch(DMLException de){
                    
                       string message= FA_ErrorLogHandler.errorMethod('FA_Pre_Work_Task__c','FA_addTasksToOccMembers','FA_associateTaskToOccMemAfterTaskInsert','FATAL',de);
                       listOfNewPreWorkTask[0].addError(message);    
              }
        }

        public static void FA_associateTaskToOccMemAfterTaskUpdate(FA_Pre_Work_Task_Assignment__c updateTask,List<FA_Occurence_Member__c> listOffAssociatedMemsforUpdate) {
             
             List<FA_Pre_Work_Task__c> listOfupdatePreWorkTask=new List<FA_Pre_Work_Task__c>();
             set<Id> occMemIds=new set<Id>();
             
             for(FA_Occurence_Member__c omsup:listOffAssociatedMemsforUpdate){
                     
                     occMemIds.add(omsup.Id);
             }
             
             List<FA_Pre_Work_Task__c> listOfUpdatePreWorkTasks=[select id,FA_OccMember__c,FA_OccurenceOM__c,FA_Occurence_Task__c from FA_Pre_Work_Task__c where FA_OccMember__c in :occMemIds and FA_OccurenceOM__c=:updateTask.FA_Occurence__c and FA_Occurence_Task__c=:updateTask.Id ];
             
             for(FA_Pre_Work_Task__c temp:listOfUpdatePreWorkTasks){
                    
                     FA_Pre_Work_Task__c updatePreWorkTask=new FA_Pre_Work_Task__c();
                     updatePreWorkTask.Id=temp.Id;
                     updatePreWorkTask.FA_Due_Date__c=updateTask.FA_Due_Date__c; 
                     updatePreWorkTask.FA_Task_Description__c=updateTask.FA_Task_Description_PWTA__c;
                     updatePreWorkTask.FA_Task_Name__c=updateTask.FA_Task_Name_PWTA__c;
                     
                     listOfupdatePreWorkTask.add(updatePreWorkTask);
             }
             try{
                     
             update listOfupdatePreWorkTask;
             }
             catch(DMLException de){
                    
                       string message= FA_ErrorLogHandler.errorMethod('FA_Pre_Work_Task__c','FA_addTasksToOccMembers','FA_associateTaskToOccMemAfterTaskUpdate','FATAL',de);
                       listOfupdatePreWorkTask[0].addError(message);    
              }
        }
    
        public static void FA_deleteTasksAtMemAfterPWAsmntDelete(FA_Pre_Work_Task_Assignment__c deletedTask,List<FA_Occurence_Member__c> listOffAssociatedMemsforDeletOfTasks) {
             
             set<Id> setOfOccMemIds=new set<Id>();
             
             for(FA_Occurence_Member__c omsup:listOffAssociatedMemsforDeletOfTasks){
                     setOfOccMemIds.add(omsup.Id);
                     
             }
             
             List<FA_Pre_Work_Task__c> listOfTobeDeletedPreWorkTask=[select id,FA_OccMember__c,FA_OccurenceOM__c,FA_Occurence_Task__c from FA_Pre_Work_Task__c where FA_OccMember__c in :setOfOccMemIds and FA_OccurenceOM__c=:deletedTask.FA_Occurence__c and FA_Occurence_Task__c=:deletedTask.Id ];
             
             try{
             delete listOfTobeDeletedPreWorkTask;
             }
             catch(DMLException de){
                    
                       string message= FA_ErrorLogHandler.errorMethod('FA_Pre_Work_Task__c','FA_addTasksToOccMembers','FA_deleteTasksAtMemAfterPWAsmntDelete','FATAL',de);
                       listOfTobeDeletedPreWorkTask[0].addError(message);    
              }
        }

}