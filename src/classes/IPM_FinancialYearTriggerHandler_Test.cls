/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FinancialYearTriggerHandler class 
*/
@isTest
public class IPM_FinancialYearTriggerHandler_Test {
    public static IPM_Project__c project;
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static Map<Id, IPM_Financial_Year__c> mapNewFinancials=new Map<Id, IPM_Financial_Year__c>();
    public static Map<Id, IPM_Financial_Year__c> mapOldFinancials=new Map<Id, IPM_Financial_Year__c>();    
    public static IPM_FinancialWrapper financialsInnovation;
    public static IPM_FinancialWrapper financialsCalendar;
    public static String volumeUnit;
    public static Id currentFinancialId;
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    public static String VOLUME_UNIT_TONS = 'Total Tons';
    public static String DEFAULT_FINANCIAL_RECORDTYPE;
    public static String CONSOLIDATED_FINANCIAL_RECORDTYPE;
    public static Map<String, List<IPM_Financial__c>> mapAllConsolidatedFinancials;
    public static Map<String, IPM_Financial_Year__c> mapUpdateConsolidatedFinancialYears;
    public static Map<String, IPM_Financial_Year__c> mapAllFinancialYears;
    public static IPM_Financial_Year__c financialYear=new IPM_Financial_Year__c();
    
    /*******************************************************************************************************
    * @description  Test Method to initialize data for the other test methods
    */
    static testMethod void initializeData(){
        project=IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.IPM_GateKeeping_Model__c='Both'; 
        project.Sustainability_Period__c='3';
        project.IPMProject_Span__c='Global';
        insert project;
        system.assertNotEquals(project.id, null);
                
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        system.assertNotEquals(strRecordTypeId, null);
        proRoll=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        proRoll.Name='TEST FINANCE D_EUR';
        proRoll.IPM_Project__c=project.ID;
        proRoll.Market_Cluster_Name__c='market';
        proRoll.MCO_Name__c='mco';
        proRoll.IPM_Status__c='Leader';
        proRoll.Market_Cluster__c='cluster';        
        proRoll.Local_Project__c=project.Id;
        proRoll.Regional_Project__c=project.Id;
        proRoll.IPM_Rollout_Project__c='TEST FINANCE D_EUR';
        insert proRoll;       
        system.assertNotEquals(proRoll.id, null);
        
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        system.assertNotEquals(strRecordTypeId1, null);
        finCon = IPM_TestFactory_Helper.createIPMFinancial(FALSE);
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Project_Sustainability_Period__c='3';
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Charter_Approved__c=true;
        finCon.Contract_Approved__c=true;
        finCon.MD_Approved__c=true;
        finCon.Copy_Global_to_Local__c=true;
        finCon.Copy_Global_to_Regional__c=true;
        finCon.Copy_Local_to_Regional__c=true;
        finCon.Copy_Regional_to_Local__c=true;
        insert finCon;
        system.assertNotEquals(finCon.id, null);    
       
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        finYear = IPM_TestFactory_Helper.createIPMFinancialYear(FALSE);
        finYear.IPM_Financial__c=finCon.Id;
        finCon.Charter_Approved__c=true;
        finYear.Contract_Approved__c=true;
        finYear.MD_Approved__c=true;
        finYear.MD_Approved__c=true;
        finYear.Copy_Global_to_Local__c=true;
        finYear.Copy_Global_to_Regional__c=true;
        finYear.Copy_Local_to_Regional__c=true;
        finYear.Copy_Regional_to_Local__c=true;       
        insert finYear;        
        system.assertNotEquals(finYear.id, null);   
        financialYear=finYear;    
    }
    
    /*******************************************************************************************************
    * @description  Test Method to test the onAfterUpdate functionality of IPM_FinancialYearTrigger events
    */
    static testMethod void testIPM_FinancialYearTrigger ()
    {
        Test.startTest();  
        initializeData();
        //PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        //There is no page IPMFinancialController exists
        PageReference pRef = Page.IPM_Financial;
        pRef.getParameters().put('id', project.Id);
        Test.setCurrentPage(pRef);  
        system.assertNotEquals(pRef, null);
        system.assert(CONSOLIDATED_FINANCIAL_RECORDTYPE.length() != 0, 'Consolidated record type is blank');
        
        finYear.Name='Y1';
        finYear.Year__c='1';
        Update finYear;
        system.assertEquals(finYear.Name, 'Y1','Financial Year Not same');
        delete finYear; 
        system.assertEquals(finYear.Regional_External_Id__c, null,'External Id Mismatch Error');       
        Test.stopTest();
    }
}