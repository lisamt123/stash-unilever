/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FileUploadController class 
*/
@isTest
public with sharing class IPM_FunnelController_Test {
    public static IPM_Project__c project;
    private static user testUser;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static List<user>userList=new List<user>();
    private static string projectId;
    
    private static void initializeData(){
        testUser=IPM_TestFactory_Helper.createUser(false);
        insert testUser;
        userList.add(testUser);
        List<User>userLists=[SELECT id FROM user WHERE id=:testUser.id LIMIT 1];
        System.AssertEquals(userLists[0].id, testUser.id,'User not found');
        
        IPM_Project__c projectRecord = IPM_TestFactory_Helper.createIPMProject(FALSE);
        projectRecord.Name = 'DEF1153BLOC';
        projectRecord.IPM_Project_Name__c = 'DEF1153BLOC';
        projectRecord.Sustainability_Period__c = '3';
        projectRecord.IPMProject_Span__c = 'Global';
        projectRecord.IPM_Project_Type__c = 'Original';
        projectRecord.IPM_Target_Launch_Dates__c = Date.newInstance(2020, 04, 07);
        projectRecord.IPM_Project_Leader__c = testUser.Id;
        projectRecord.IPM_Phase__c = 'Ideas';
        insert projectRecord;
        projectList.add(projectRecord);
        List<IPM_Project__c> projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Project_Name__c,IPM_Complexity__c,IPM_GateKeeping_Model__c, IPM_SourceProjectType__c, IPM_Project_Type__c FROM IPM_Project__c WHERE ID=:projectRecord.ID LIMIT 1];
        project=projlList[0];
        projectId=projlList[0].Id;
        System.assertEquals(projlList[0].id,projectRecord.id);
    }
    
    static testmethod void testGetAssociatedProjectPhases(){
        initializeData();
        test.startTest();
        system.runAs(testUser){
            IPM_FunnelController funnelController = new IPM_FunnelController ();
            funnelController.project = project;
            List<string> projectPhases = funnelController.getAssociatedProjectPhases();
            system.assertEquals(funnelController.project, project, 'project record should be same');
        }
        test.stopTest();
    } 
}