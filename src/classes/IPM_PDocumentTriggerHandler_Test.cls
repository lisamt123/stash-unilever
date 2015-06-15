@isTest
public class IPM_PDocumentTriggerHandler_Test {
public static IPM_Project__c project;
public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
public static IPM_Project_Document__c proDoc1=new IPM_Project_Document__c();
public static Map<Id, IPM_Project_Document__c> newPDocumentsMap=new Map<Id, IPM_Project_Document__c>();
public static Id projectIds;
static testMethod void initializeData(){
project=new IPM_Project__c();


project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;


        proDoc.IPM_GateDocuments__c='Charter'; 
        proDoc.IPM_Project__c=project.ID;
        //proDoc.IPM_Project_Template__c=projTemp.Id;
        proDoc.IPM_Document_Status__c='Stopped';
        insert proDoc;    
 
  proDoc1.IPM_GateDocuments__c='Charter'; 
        proDoc1.IPM_Project__c=project.ID;
        //proDoc.IPM_Project_Template__c=projTemp.Id;
        proDoc1.IPM_Document_Status__c='Approved';
        insert proDoc1;  

}


 
     
     static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/IPM_PDocumentTriggerHandler?id='+project.Id);
         Test.setCurrentPage(pRef);
         
           //ApexPages.StandardController sc1 = new ApexPages.StandardController(proTask1);
         IPM_PDocumentTriggerHandler ipmPD=new IPM_PDocumentTriggerHandler(true);
         projectIds=project.Id;
         IPM_Project_Document__c[] newPDocuments= new List<IPM_Project_Document__c>();
         newPDocuments.add(proDoc);
         
        newPDocumentsMap.put(proDoc.Id,proDoc);
        newPDocumentsMap.put(proDoc1.Id,proDoc1);
         ipmPD.onAfterUpdate(newPDocuments,newPDocumentsMap);
       
     
         
     }
}