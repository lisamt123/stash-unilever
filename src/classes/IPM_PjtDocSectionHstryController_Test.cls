@isTest
public class IPM_PjtDocSectionHstryController_Test {
    
           static testMethod void testViewHistory()
           {
               //TestData testData= new TestData();
               IPM_Project__c project=new IPM_Project__c();
               project.Name='TestHistory';
               
               Test.startTest(); 
               project.IPM_Phase__c='Ideas';
               insert project;
               IPM_Project_Document__c projDoc=new IPM_Project_Document__c();
               projDoc.IPM_GateDocuments__c='Charter'; 
               projDoc.IPM_Project__c=project.ID;
               insert projDoc;
               
               
               
               PageReference pRef = new PageReference('apex/IpmProjectDocumentSectionHistory?id='+project.ID);
               Test.setCurrentPage(pRef);
               IPM_ProjDocumentSectionHstryController objHistory = new IPM_ProjDocumentSectionHstryController();
                              
               project.IPM_Phase__c='Feasibility';
               update project;
               projDoc.IPM_GateDocuments__c='Charter'; 
               update projDoc;
               IPM_Project_Document_Section__c projDocSec=new IPM_Project_Document_Section__c();
               projDocSec.IPM_Project_Document__c=projDoc.ID;
               insert projDocSec;
               PageReference pRef1 = new PageReference('apex/IpmProjectDocumentSectionHistory?id='+project.ID+'&projDocSecId='+projDocSec.Id);
               Test.setCurrentPage(pRef1);
               IPM_ProjDocumentSectionHstryController objHistory1 = new IPM_ProjDocumentSectionHstryController();
               Test.stopTest();
               
 }


}