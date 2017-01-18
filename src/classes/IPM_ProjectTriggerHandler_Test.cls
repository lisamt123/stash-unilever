/*****************************************************************************
*@Author:Cognizant
*@Date:01/02/2015
*@Description : To test IPM_ProjectTriggerHandler class functionalities
*/
@isTest
public class IPM_ProjectTriggerHandler_Test {
    public static IPM_Project__c project;
    public static IPM_Project__c childProject;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    
    public static  Map<Id, IPM_Project__c> oldProjectsMap=new  Map<Id, IPM_Project__c>();
    /**************************************************************
    *@Description :create a user,project and rollout
    */
    static void initializeData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        system.assertNotEquals(p, null);
        User  u = new User(Alias = 'jtestrx', Email='jtestrr4@testorgx4.com', 
                           EmailEncodingKey='UTF-8', LastName='jTestingx4', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='jtestrr4@testorgx4.com', 
                           IPM_Category__c = 'jtestrx4'  , IPM_Brand_Positioning__c= 'jtestx4',IPM_Brand_Name__c ='jtestrx1',
                           IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='jtesrxt', isActive =true);
        insert u; 
        system.assertNotEquals(u.id, null);
        project = IPM_TestFactory_Helper.createIPMProject(False); 
        project.Sustainability_Period__c='3';
        project.IPM_Target_Launch_Dates__c=system.today();
        project.IPM_Project_Leader__c=u.Id;
        project.IPM_Technical_Project_Leader__c=u.Id;
        project.Deputy_Project_Leader__c=u.Id;
        project.IPM_Project_Gatekeeper__c=u.Id;
        project.IPM_Finance_Lead__c=u.Id;
        insert project;
        system.assertNotEquals(project.id, null);
        system.assertEquals(project.IPM_Finance_Lead__c, u.Id);
        
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll = IPM_TestFactory_Helper.createIPMProjectRollout(False);
        proRoll.Name='TESTAPPROVERCL_SEAA';
        proRoll.IPM_Project__c=project.ID;
        proRoll.Market_Cluster_Name__c='SEAA';
        proRoll.Local_Project__c=project.Id;
        proRoll.Regional_Project__c=project.Id;
        insert proRoll;
        system.assertNotEquals(strRecordTypeId, '');
        system.assertNotEquals(proRoll.id, null);
        
    }
    /**************************************************************
    *@Description :testmethod to test dotest method
    */
    static testMethod void dotest(){
        Test.startTest();
        initializeData();
        Test.stopTest();
        PageReference pRef = new PageReference('/apex/IPMFinancialController?id='+project.Id);
        Test.setCurrentPage(pRef);
        system.assertNotEquals(pRef, null);
        oldProjectsMap.put(project.Id,project);
        system.assert(oldProjectsMap != null && !oldProjectsMap.isEmpty(), 'oldProjectsMap map should contain atleat 1 item.');
        IPM_Project__c[] newProjects=new IPM_Project__c[]{project};
        system.assertNotEquals(newProjects, null);    
            
   }
}