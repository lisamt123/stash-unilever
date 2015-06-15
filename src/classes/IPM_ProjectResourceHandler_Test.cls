@isTest
public class IPM_ProjectResourceHandler_Test {
public static IPM_Project__c project;

static testMethod void initializeData(){
project=new IPM_Project__c();


project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;



}


 
     
     static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_ProjectResourceHandler?id='+project.Id);
         Test.setCurrentPage(pRef);
         
          
         
     IPM_ProjectResourceHandler ipmPR=new IPM_ProjectResourceHandler(true);
       IPM_Project_Resource__c[] newProjectResources= new List<IPM_Project_Resource__c>();
       Map<Id, IPM_Project_Resource__c> newProjectResourcesMap=new Map<Id, IPM_Project_Resource__c>();
       Map<Id, IPM_Project_Resource__c> oldProjectResources=new Map<Id, IPM_Project_Resource__c>();
     ipmPR.OnAfterUpdate(newProjectResources,newProjectResourcesMap,oldProjectResources);
         
     }
}