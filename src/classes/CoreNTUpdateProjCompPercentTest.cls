@isTest
private class CoreNTUpdateProjCompPercentTest {
   
  static testMethod void testMethodToUpdateProjectCompletionPercentage(){
    CORE_NT_Project__C ntpObject=new CORE_NT_Project__C();
    ntpObject.Name='Project 1';
    ntpObject.PercentComplete__c=0;
    insert ntpObject;
    
    CORE_NT_Task__C newTaskObjectForTest1=new CORE_NT_Task__C(Due_Date__c=Date.today().addDays(7),ProjectId__c=ntpObject.Id,Complete__c=false);
    insert newTaskObjectForTest1;
    
    List<CORE_NT_Task__C> lstTasks=[select Complete__c,Id from CORE_NT_Task__C where Id =: newTaskObjectForTest1.Id];
    CORE_NT_Task__C newTaskObjectForTest2=lstTasks[0];
    newTaskObjectForTest2.Complete__c=true;
    update newTaskObjectForTest2;
  } 
 }