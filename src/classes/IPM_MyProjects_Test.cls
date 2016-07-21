/**
* IPM_MyProjectsTest: This Test class for IPM_MyProjects apex class
* @author 
*
*/
@istest
public class IPM_MyProjects_Test{
    
    public static User platformUser;
    public static User BDUser;
    public static list<IPM_Project__c> projectList;
    public static list<IPM_Project__c> updateProjectList;
    public static list<IPM_Project__c> projectDetailList;
    public static list<IPM_Project_Document__c> ipmProjDocumentTestList;
    
    @testSetup static void projectSetUpData() 
     {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            BDUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('BD');
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
         IPM_TestFactory_Helper.getProjectMasterData();
         
         projectList = IPM_TestFactory_Helper.projectSetUp(5,platformUser);
         
         updateProjectList =  NEW list<IPM_Project__c> ();
         
         System.runAs(platformUser)
         {
            for(Integer i = 0; i < projectList.size(); i++)
            {
                IPM_Project__c proj = projectList[i];
                proj.IPM_Market_Type__c = IPM_ConstantUtils.MARKETTYPE_DEVELOPED;
                proj.IPM_Fast_Track_Project__c = false;
                proj.IPM_Target_Launch_Dates__c = system.today().addMonths(6+i);
                updateProjectList.add(proj);
            }
           insert updateProjectList;
         }  
         system.assertEquals(5, [Select Id from IPM_Project__c limit 5].size(),'Projects are created');
         
      }
    
    public static void createTestData(){
        set<string> projIdSet = new set<string>();
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3','TestComments4','TestComments5'};
        projectDetailList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,
                                                    (Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),
                                                    (Select Id,Name,IPM_Task_Complexity__c,IPM_Project__c,IPM_Function__c,IPM_Section__c from Tasks__r),
                                                    (Select Id,Name,IPM_Phase__c from IPM_Milestones__r)
                                                  from IPM_Project__c where Name in:projectNameSet];
        
        list<IPM_Bosscard__c> ipmBosscardTestList = IPM_TestFactory_Helper.createIPMBosscardList(false, 5);
        
        for(Integer i = 0; i < ipmBosscardTestList.size(); i++){
            ipmBosscardTestList[i].IPM_Bosscard_Status__c = IPM_ConstantUtils.STATUS_IN_PROGRESS;
            ipmBosscardTestList[i].OwnerId = UserInfo.getUserId();
        }
        insert ipmBosscardTestList;
        
        System.Assert(ipmBosscardTestList[0].IPM_Bosscard_Status__c == IPM_ConstantUtils.STATUS_IN_PROGRESS, IPM_ConstantUtils.MSG_SHOULD_BE_SAME);
        
        
        ipmProjDocumentTestList = new list<IPM_Project_Document__c>();
        for(IPM_Project__c project : projectDetailList)
        {
            projIdSet.add(project.id);
            for(IPM_Project_Document__c  projDoc : project.Project_Documents__r)
            {
                ipmProjDocumentTestList.add(projDoc);       
            }
        }
        // Test Data
        Id mileMRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
        
        List<IPM_Milestone__c> ipmMileStoneTestList = IPM_TestFactory_Helper.createIPMMilestoneList(false, 5);
        
        for(Integer i = 0; i < ipmMileStoneTestList.size(); i++){
            ipmMileStoneTestList[i].IPM_No_Of_Days_for_Developing__c = '2' + i;
            ipmMileStoneTestList[i].IPM_Due_Date__c = system.today() + i;
            ipmMileStoneTestList[i].IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
            ipmMileStoneTestList[i].IPM_Name__c = 'Market Ready Gate Approval';
            ipmMileStoneTestList[i].recordtypeid = mileMRecordType;
            ipmMileStoneTestList[i].IPM_Project__c = projectDetailList[i].Id;
            ipmMileStoneTestList[i].IPM_Phase__c = projectDetailList[i].IPM_Phase__c;
        }
        insert ipmMileStoneTestList;
        system.assertEquals(5, [Select Id from IPM_Milestone__c limit 5].size(),'Milestones are created');
        
    }
    
    /***
    * @Description: Running Test Method
    */
    public static testmethod void IPM_MyProjectsTest()
    {
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        system.runAs(globalUser)
        {
            Test.startTest();
                createTestData();
                IPM_MyProjects ipmp = new IPM_MyProjects();
                new IPM_MyProjects(new IPM_HomePageController());
                ipmp.getProjects();
                System.Assert(ipmp.getProjects() != null,'Should not be null');
                new ApexPages.StandardController(ipmProjDocumentTestList[0]);
            Test.stopTest();
        }
      
    }
}