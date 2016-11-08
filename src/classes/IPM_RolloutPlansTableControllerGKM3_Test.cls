/******************************************** 
*@Author:Cognizant
*@Date:10/10/2016
*@Description : Test class for ipmRolloutPlansTableController class functionalities
*********************************************/
@isTest
public class IPM_RolloutPlansTableControllerGKM3_Test {
    private static User stdUserforRollout;
    private static List<IPM_Project__c > projectList;
    private static List<IPM_Project_Rollout__c> localRolloutList;
    private static Map<Id, IPM_Project_Rollout__c> mapNewProjectRollouts=new Map<Id, IPM_Project_Rollout__c>();
    public static Map<Id, IPM_Project_Rollout__c> mapOldProjectRollouts=new Map<Id, IPM_Project_Rollout__c>();
    
    private static List<IPM_Project_Rollout__c> regionalRolloutList;
    private static final String TESTPROJECT = 'GKM3TestComments1';
  
    private static Set<Id> regRolloutIds = New Set<Id>();
    private static final String ID_PARAMETER = 'Id';
    private static  PageReference pageRef = Page.ipm_rolloutplansadd;
    
    @testSetup static void projectSetUp()  
    {
        test.startTest();
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
            // user has to be created as system admin 
            stdUserForRollout = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }   
       // Create Company Card information For GKM3
        IPM_Company_Card__c globalCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3GlobalCompanyCard(false);
        IPM_Company_Card__c localCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3LocalCompanyCard(false);
       
        List<IPM_Company_Card__c> companyCardListGKM3 = new List<IPM_Company_Card__c>{globalCompanyCardGKM3,localCompanyCardGKM3};
        insert companyCardListGKM3;
        
        IPM_TestFactory_Helper.getProjectMasterDataForGKM3();
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{stdUserForRollout}); 
        
        List<IPM_Company_Card__c> companyCardAssertListGKM3 = [select id from IPM_Company_Card__c where id in : companyCardListGKM3];
        system.assertEquals(2,companyCardAssertListGKM3.size(),'Number of company card inserted is not 2 ');

        
        System.runAs(stdUserForRollout)
        {
            // Inserting GKM3 project
            projectList = IPM_TestFactory_Helper.projectSetUpGKM3(1,stdUserForRollout);
            insert projectList;

            Test.stopTest();
                       
            set<Id> projId = new set<Id>();
            for(IPM_Project__c proj : projectList)
            {
                projId.add(proj.id); 
            }
            List<IPM_Project__c> projectAssertList = [select Name from IPM_Project__c where id in : projId];
            system.assertEquals(1,projectAssertList.size(),'No project created');
            
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForRollout,stdUserForRollout});
            
            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = TRUE;
            insert regionalRolloutList; // this will give me all regional rollout
            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = FALSE;
            System.debug('@@@@regionalRolloutList  =>  '+ regionalRolloutList);
            
          
            Map<Id,List<IPM_Project_Rollout__c>> projectToRolloutMap = new Map<Id,List<IPM_Project_Rollout__c>>();
            for(IPM_Project_Rollout__c projectRollout : regionalRolloutList)
            {
                List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
                if(projectToRolloutMap.containsKey(projectRollout.IPM_Project__c))
                {
                    projectRolloutList = projectToRolloutMap.get(projectRollout.IPM_Project__c);
                }
                projectRolloutList.add(projectRollout);
                projectToRolloutMap.put(projectRollout.IPM_Project__c,projectRolloutList);
                mapNewProjectRollouts.put(projectRollout.IPM_Project__c,projectRollout);
                regRolloutIds.add(projectRollout.Id);
            }
           
            System.debug('@@@@regRolloutIds  =>  '+ regRolloutIds);
            // Create local Rollouts for Created regional Rollouts.
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{stdUserForRollout});  
            insert localRolloutList;
 
            // Create Country specific information.
            List <IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AG';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BR';
                }
                
                MDO_Geography__c mdo = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId);
                //insert mdo;
                
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo.id,
                                                                 IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            IPM_ProjectCountryDetails.SKIP_TRIGGER_EXECUTION = TRUE;
            insert countryList;
            IPM_ProjectCountryDetails.SKIP_TRIGGER_EXECUTION = FALSE;
            
            IPM_RolloutTriggerHandler handler = new IPM_RolloutTriggerHandler();
            handler.processInsert(localRolloutList);
            handler.processDelete(localRolloutList);
            
        }
     
    } 
    
    
    public static testmethod void testRolloutProject()
    {
        Set<String> projectNameSet = new Set<String>{TESTPROJECT};
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        
        // Create Regional Projects.
        System.runAs(globalUser)
        {
            
            projectList = [Select Id,Name,IPM_Phase__c,(Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet for update];
            IPM_Milestone__c milestone = new IPM_Milestone__c();
            milestone.IPM_Active__c = TRUE;
            milestone.IPM_Due_Date__c = System.today().addDays(2);
            milestone.IPM_Project__c = projectList[0].Id;
            milestone.IPM_Name__c = IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE;
            IPM_MilestoneHelper.SKIP_TRIGGER_EXECUTION = TRUE;
            insert milestone;
            IPM_MilestoneHelper.SKIP_TRIGGER_EXECUTION = FALSE;
            
            List<String> milestoneNames = new List<String>{IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE,IPM_ConstantUtils.CONTRACT_GATE_APPROVAL_MILESTONE,IPM_ConstantUtils.MARKET_READY_GATE_APPROVAL_MILESTONE};
            List<IPM_Milestone__c> milestones = [Select Id,IPM_Active__c, IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c =: projectList[0].Id and IPM_Active__c = true and IPM_Due_Date_isNull__c = :IPM_ConstantUtils.IPM_false and IPM_Name__c in: milestoneNames limit 50000];
            System.assert(milestones.size()>0,'Milestone not Created');
            
            System.assertEquals(projectList[0].IPM_Phase__c,'Ideas','Project Phase is not ideas');
            
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put(ID_PARAMETER,projectList[0].Id);
            
            Test.startTest();
            IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
            irp.isPLallocated = TRUE;
            irp.isEditMode = TRUE;
            irp.isFLAllocated = TRUE;

            irp.addRollout();
            
            irp.saveRollout();
            
            List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
            
            
            for(IPM_Project__c project : projectList)
            {
                project.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
                
                for(IPM_Project_Rollout__c rollout : project.IPM_Project_Rollout__r)
                {
                    if(rollout.recordTypeId == IPM_TestFactory_Helper.REGIONAL_ROLLOUT_RECTYPE)
                    {
                        rollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                        projectRolloutList.add(rollout);
                    }
                }
            }
            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = TRUE;
			update projectRolloutList;
            IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = FALSE;
            Test.stopTest();
            List<IPM_Project_Rollout__c> rolloutAssertList = [Select Id from IPM_Project_Rollout__c where IPM_Project_Job_Status__c =:IPM_ConstantUtils.JOB_STATUS_ELIGIBLE];
            system.assertEquals(2,rolloutAssertList.size(),'Rollout is not eligible for job run');

        }
    }  

}