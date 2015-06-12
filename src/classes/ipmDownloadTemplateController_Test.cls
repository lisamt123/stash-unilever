@isTest
public class ipmDownloadTemplateController_Test {
public static IPM_Project__c project;
public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
public static Map<Id, IPM_Project_Document__c> newPDocumentsMap=new Map<Id, IPM_Project_Document__c>();
public static IPM_Financial_File__c finFile=new IPM_Financial_File__c();
public static Attachment attach=new Attachment();
public static Attachment attach1=new Attachment();
static testMethod void initializeData(){
project=new IPM_Project__c();


project.Name='TestComments';
project.IPM_Phase__c='Ideas';
project.IPM_Complexity__c='Full';
project.IPM_GateKeeping_Model__c='Both'; 
insert project;

String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial_File__c' and Name='Default'].Id;
finFile.RecordTypeId=strRecordTypeId1;
finFile.Name='abc';
finFile.IPM_Project__c=project.Id;
insert finFile;


    
attach.Name='path';
 Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');

        attach.body=bodyBlob;

attach.ParentId=project.Id;
insert attach;
}


 
     
     static testMethod void dotest()
     {
     initializeData();
          PageReference pRef = new PageReference('/apex/ipmDownloadTemplateController?id='+project.Id);
         Test.setCurrentPage(pRef);
         ipmDownloadTemplateController downTemp=new ipmDownloadTemplateController();
         downTemp.fileId=finFile.Id;
         //downTemp.receiveZipFile();
         String str;
         
         str=ipmDownloadTemplateController.getZipFileEntry(attach.Name,attach.ParentId);
       
     
         
     }
}