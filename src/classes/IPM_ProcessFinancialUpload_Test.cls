/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class to test IPMProcessFinancialUpload class functionalities
*********************************************/
@isTest
public class IPM_ProcessFinancialUpload_Test {
    public static IPM_Project__c project;
    public static IPM_Project__c childProject;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static Id currentFinancialId;
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    public static Attachment attach1 = new Attachment();
    public static Attachment attach2 = new Attachment();
    public static Attachment sharedStringAttachment= new Attachment();
    public static String xmlContent;
    public static String ipmFinancialFileId;
    public static Map<String, Attachment> mapAttachments=new Map<String, Attachment>();
    public static Map<String, IPM_Financial__c> mapFinancials=new Map<String, IPM_Financial__c>();
    public static Map<String, IPM_Financial_Year__c> mapFinancialYears=new Map<String, IPM_Financial_Year__c>();
    public static string proId;
    public static IPM_Financial_File__c finFile=new IPM_Financial_File__c(); 
    public static string SHARED_STRINGS='ABCDEF.xlsx';
    /*******************************************************************************************************
    * @description: testMethod to initialize Data(create project,rollout,financial)
    */
    static testMethod void initializeData(){
		project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.IPM_Complexity__c='Lite';
        project.Sustainability_Period__c='3';
        insert project;
        System.assertNotEquals(project.id,null);
    
    	proRoll=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        proRoll.IPM_Project__c=project.ID;
        proRoll.Market_Cluster__c='GEO0022';
        proRoll.Local_Project__c=project.Id;
        proRoll.Regional_Project__c=project.Id;
        insert proRoll;
        System.assertNotEquals(proRoll.RecordTypeId,null);
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
		finCon=IPM_TestFactory_Helper.createIPMFinancial(FALSE);
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        insert finCon;
        System.assertEquals(finCon.Status__c,'Not Started');
        String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
		finDef=IPM_TestFactory_Helper.createIPMFinancial(FALSE);
        finDef.RecordTypeId=strRecordTypeId2;
        finDef.Financial_External_ID__c='external11';
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Parent_Project__c=project.Id;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        insert finDef;
        System.assertNotEquals(finDef.Target_Launch_Date__c,null);
        
        currentFinancialId=finDef.Id;
        
		finYear=IPM_TestFactory_Helper.createIPMFinancialYear(FALSE);
        finYear.IPM_Financial__c=finCon.Id;
        insert finYear;  
        System.assertNotEquals(finYear.IPM_Financial__c,null);
        String strRecordTypeId3=[Select Id From RecordType Where SobjectType='IPM_Financial_File__c' and Name='Default'].Id;
		finFile=IPM_TestFactory_Helper.createIPMFinancialFile(project.Id,FALSE);
        finFile.RecordTypeId=strRecordTypeId3;
        insert finFile; 
        System.assertNotEquals(finFile.IPM_Project__c,null);
        Blob b = Blob.valueOf('est Data');  
        attach1.ParentId = finCon.Id;  
        attach1.Name = 'xl/sharedStrings.xml';  
        attach1.Body = b; 
        insert attach1;
        System.assertNotEquals(attach1.Body,null);
    }
    /*******************************************************************************************************
    * @description: testMethod to test upload financial file
    */
    static testMethod void dotest(){
        initializeData();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        System.assertNotEquals(pRef,null);
        mapFinancials.put(finCon.Id,finCon);
        mapFinancialYears.put(finYear.Id,finYear);
        ipmFinancialFileId=finCon.Id;
        System.assertNotEquals(ipmFinancialFileId,null);
        system.assert(mapFinancials != null && !mapFinancials.isEmpty());
        system.assert(mapFinancialYears != null && !mapFinancialYears.isEmpty());
        new IPM_ProcessFinancialUpload();   
    }
}