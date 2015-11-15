/**
* @author       Cognizant 
* @date         12/03/2015
* @description  This class is used to test the functionality of IPM_DownloadTemplateController class 
*/
@isTest
public class IPM_DownloadTemplateController_Test {
    public static IPM_Project__c project;
    public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
    public static Map<Id, IPM_Project_Document__c> newPDocumentsMap=new Map<Id, IPM_Project_Document__c>();
    public static IPM_Financial_File__c finFile=new IPM_Financial_File__c();
    public static Attachment attach=new Attachment();
    public static Attachment attach1=new Attachment();
    
    /*******************************************************************************************************
    * @description  Test Method to initialize data for the other test methods
    */
    static testMethod void initializeData(){
        Test.startTest();
		project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.IPM_GateKeeping_Model__c='Both'; 
        insert project;
        system.assertNotEquals(project.Id, null);
        
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial_File__c' and Name='Default'].Id;
		finFile=IPM_TestFactory_Helper.createIPMFinancialFile(project.Id,FALSE);
        finFile.RecordTypeId=strRecordTypeId1;
        finFile.IPM_Project__c=project.Id;
        insert finFile;
        system.assertNotEquals(finFile.Id, null);
        
        attach.Name='path';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.ParentId=finFile.Id;
        insert attach;
        Test.stopTest();
        system.assertNotEquals(attach.Id, null);
    }
        
    /*******************************************************************************************************
    * @description  Test Method to test IPM_DownloadTemplateController functionality
    */
    static testMethod void dotest()
    {
        initializeData();
        PageReference pRef = Page.IPM_DownloadTemplate;
        pRef.getParameters().put('Id', project.Id);
        pRef.getParameters().put('fileId', finFile.Id);
        
        Test.setCurrentPage(pRef);
        IPM_DownloadTemplateController downTemp=new IPM_DownloadTemplateController();
        String paramId = ApexPages.currentPage().getParameters().get('Id');
        system.assertEquals(paramId , project.Id); 
        paramId = ApexPages.currentPage().getParameters().get('fileId');
        system.assertEquals(paramId, finFile.Id); 
        downTemp.receiveZipFile();
        String str=IPM_DownloadTemplateController.getZipFileEntry(attach.Name,attach.ParentId);   
        system.assertNotEquals(str, Null);     
    }
}