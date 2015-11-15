/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_ProcessFinancials class 
*/
@isTest
public class  IPM_ProcessFinancials_Test {
    public static IPM_Project__c project;
    
    public static IPM_User_Profile__c us=new IPM_User_Profile__c();
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static IPM_Project_Document__c proDoc=new IPM_Project_Document__c();
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Project_Template__c proTemp=new IPM_Project_Template__c();
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    public static Set<Id> setProjectDocumentIds=new Set<Id>();
    public static List<IPM_Project_Document__c> lstProjectDocuments=new List<IPM_Project_Document__c>();
    public static Set<Id> localRolloutIDs=new Set<Id>();
    public static Set<String> setSustainabilityPeriod=new Set<String>();
    public static Set<String> setTrimmedProjectIds=new Set<String>();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    public static IPM_Financial_File__c finFile=new IPM_Financial_File__c();
    
    /*******************************************************************************************************
    * @description  Test Method to initialize data for the other test methods
    */
    static testMethod void initializeData(){  
        test.startTest();
        project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.IPM_GateKeeping_Model__c='RCLT'; 
        project.Sustainability_Period__c='3';
        project.IPM_Target_Launch_Dates__c=system.today();
        insert project;
        system.assertNotEquals(project.Id, null);
  
        proRoll=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        proRoll.IPM_Project__c=project.ID;
        proRoll.Market_Cluster__c='GEO0022';
        proRoll.Local_Project__c=project.Id;
        proRoll.Regional_Project__c=project.Id;
        insert proRoll;
        system.assertNotEquals(proRoll.Id, null);        
        proTemp=IPM_TestFactory_Helper.createIPMProjectTemplate(FALSE);
        proTemp.IPM_Category__c='Household Care';
        proTemp.IPM_Project__c=project.Id;
        insert proTemp;
        system.assertNotEquals(proTemp.Id, null);
        
        proDoc = IPM_TestFactory_Helper.createIPMProjectDocument(FALSE);
        proDoc.Name='TESTAPPROVERCL-Charter';
        proDoc.IPM_Project__c=project.Id;
        proDoc.IPM_Project_Template__c=proTemp.Id;
        proDoc.IPM_Document_Status__c='Approved';
        proDoc.IPM_Approval_Date__c=System.today();
        proDoc.IPM_Approved_Comments__c='RCLT will work';
        
        setProjectDocumentIds.add(proDoc.Id);
        
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        finCon = IPM_TestFactory_Helper.createIPMFinancial(FALSE);
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;        
        insert finCon;
        system.assertNotEquals(finCon.Id, null);
        
        String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        finDef = IPM_TestFactory_Helper.createIPMFinancial(FALSE);
        finDef.RecordTypeId=strRecordTypeId2;
        finDef.Financial_External_ID__c='external11';
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Parent_Project__c=project.Id;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        insert finDef;
        system.assertNotEquals(finDef.Id, null);
        
        String strRecordTypeId3=[Select Id From RecordType Where SobjectType='IPM_Financial_File__c' and Name='Default'].Id;
        finFile = IPM_TestFactory_Helper.createIPMFinancialFile(project.Id,FALSE);
        finFile.RecordTypeId=strRecordTypeId3;  
        insert finFile; 
        system.assertNotEquals(finFile.Id, null);
        test.stopTest();
    }
    
    /*******************************************************************************************************
    * @description  Test Method to test processDocumentApprovalFinancials, updateProjectFinancials 
    * and updateProjectDocumentFinancials functionlity
    */
    static testMethod void dotest(){
        initializeData();
        //PageReference pRef = new PageReference('/apex/IPM_ProcessFinancials?id='+project.Id);
        //There is no page IPM_ProcessFinancials exists
        PageReference pRef = Page.IPM_Financial;
        pRef.getParameters().put('id', project.Id);
        Test.setCurrentPage(pRef);
        system.assertNotEquals(pRef, null);
        
        setSustainabilityPeriod.add(project.Id+'_3_3');
        setTrimmedProjectIds.add(project.Id);
        setProjectDocumentIds.add(proDoc.Id);
        
        IPM_ProcessFinancials ipmProFin=new IPM_ProcessFinancials();
        IPM_ProcessFinancials.processDocumentApprovalFinancials(setProjectDocumentIds);
        ipmProFin.updateProjectDocumentFinancials(lstProjectDocuments);
        
        List<IPM_Project_Document__c> ProjectDocuments = [Select Id, Name, IPM_GateDocuments__c from IPM_Project_Document__c where Id IN:setProjectDocumentIds];
        for(IPM_Project_Document__c projDoc: ProjectDocuments){
            system.assert(projDoc.IPM_GateDocuments__c== IPM_ConstantUtils.CHARTER_GATE, 'Project document is not a Gate Document');
        }
        
        IPM_ProcessFinancials.processProjectFinancials(setTrimmedProjectIds,setSustainabilityPeriod);
        ipmProFin.updateProjectFinancials(setTrimmedProjectIds,setSustainabilityPeriod);
        
        List<IPM_Financial__c> lstExistingFinancial = new List<IPM_Financial__c>();
        lstExistingFinancial = [SELECT Id, Financial_External_Id__c, Global_Project_Id__c, Regional_Project__c, Project_Sustainability_Period__c
                                                  FROM IPM_Financial__c
                                                  WHERE Global_Project_Id__c IN: setTrimmedProjectIds 
                                                  OR Regional_Project__c IN: setTrimmedProjectIds];
        For(IPM_Financial__c existingFinancial : lstExistingFinancial){
                                                      system.assert(existingFinancial != Null, 'existingFinancial is null');                                                    
                                                  }
    }
}