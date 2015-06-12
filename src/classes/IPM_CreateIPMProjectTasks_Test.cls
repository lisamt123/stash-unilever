@isTest
public class IPM_CreateIPMProjectTasks_Test {
public static IPM_Project__c project;
public static Set<Id> ipmprojectIds=new Set<Id>();
public static IPM_Task__c tas=new IPM_Task__c();
static testMethod void initializeData(){
project=new IPM_Project__c();


project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;

//String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Task__c' and Name='IPM_Tasks'].Id;
tas.Name='csc';
tas.IPM_Project__c=project.Id;
insert tas;
  
}


 
     
     static testMethod void dotest1()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_CreateIPMProjectTasks?id='+project.Id);
         Test.setCurrentPage(pRef);
         ipmprojectIds.add(project.Id);
         IPM_CreateIPMProjectTasks crtPro=new IPM_CreateIPMProjectTasks();
         IPM_CreateIPMProjectTasks.createIPMTasks(ipmprojectIds);
         
       
     
         
     }
     /* static testMethod void dotest2()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_CreateIPMProjectTasks?id='+project.Id);
         Test.setCurrentPage(pRef);
        
         IPM_CreateIPMProjectTasks crtPro=new IPM_CreateIPMProjectTasks();
         
         project.IPM_Phase__c='Feasibility';
        update project;
         ipmprojectIds.add(project.Id);
        IPM_CreateIPMProjectTasks.createIPMTasks(ipmprojectIds);
        
       
     
         
     }
      static testMethod void dotest3()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_CreateIPMProjectTasks?id='+project.Id);
         Test.setCurrentPage(pRef);
         
         IPM_CreateIPMProjectTasks crtPro=new IPM_CreateIPMProjectTasks();
         
        
        
        IPM_CreateIPMProjectTasks.createIPMTasks(ipmprojectIds);
        project.IPM_Phase__c='Capability';
        update project;
        ipmprojectIds.add(project.Id);
        IPM_CreateIPMProjectTasks.createIPMTasks(ipmprojectIds);
        
       
     
         
     }
      static testMethod void dotest4()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_CreateIPMProjectTasks?id='+project.Id);
         Test.setCurrentPage(pRef);
        
         IPM_CreateIPMProjectTasks crtPro=new IPM_CreateIPMProjectTasks();
         
        project.IPM_Phase__c='Market Ready';
        update project;
         ipmprojectIds.add(project.Id);
        IPM_CreateIPMProjectTasks.createIPMTasks(ipmprojectIds);
       
     
         
     }*/
}