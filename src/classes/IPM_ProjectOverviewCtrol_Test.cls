@isTest(SeeAllData=false)
public class IPM_ProjectOverviewCtrol_Test {
    private static Set<Id> iDs ;
    private static final String MILESTONE_CREATED='Milestone is created';
    private static final String PROJ_CREATED='Projects are created';
    private static String sPageRefURL = 'apex/IPM_ProjectOverview?Id=';
    /***********************************
    * @Description: Test Data Creation
    * *********************************/
   
     /**
        *  Used for Setting test Data for Project Creation . 
        *  @name projectSetUp
    */
    
        @testSetup static void projectSetUp() 
     {
         // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         iDs = new Set<ID>();
         
         User globalProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = 'GLOBAL_PL';
            regionalProjectLeader.lastname = 'REGIONAL_PL';
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader};
            update userList;
         
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard};
            insert companyCardList;
            for(IPM_Company_Card__c eachCompanyCard : companyCardList) {
              iDs.add(eachCompanyCard.Id);
            }
            System.assertEquals(2, [Select count() from IPM_Company_Card__c where id in:iDs],'Company Cards are created');
          
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader}); 
        }   
        
        // Insert the project as a Global project Leader.
        System.runAs(globalProjectLeader)
        {   
            
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList;
            iDs.clear();
            for(IPM_Project__c eachProj : projectList) {
             iDs.add(eachProj.Id);
            }
            System.assertEquals(3, [Select count() from IPM_Project__c where id in:iDs],PROJ_CREATED);
          
        }
     }    
     
     /**
        *  Used for Testing home page alerts
        *  @name projectSetUp
        In this method for Global project, regional rollouts are created, after phase changes regional rollouts gets converted to regional project.
        this whole logic need to be in the same method to test child project's status alert.
     */
     public static testmethod void testChildProjectsIncompleteAlert()
     {
        iDs = new Set<ID>();
        // Get the newly created Projects from Database. 
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        
        User globalProjectLeader = null;
        User regionalProjectLeader = null;
        
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL')];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == 'GLOBAL_PL')
            {
                globalProjectLeader = lUser;
            }
            if(lUser.lastName == 'REGIONAL_PL')
            {
                regionalProjectLeader = lUser;
            }
        } 
        
        System.RunAs(globalProjectLeader)
        {
            
            List<IPM_Project__c> projectList = [Select Id,IPM_Phase__c,Name,IPM_GateKeeping_Model__c,IPM_Complexity__c,IPM_Project_Name__c
                                                    from IPM_Project__c where Name in:projectNameSet];
            for(IPM_Project__c project : projectList)
            {
                projectMap.put(project.Id,project);
            }
             
           /******************************** Create Regional Rollouts for Created Global project ****************************************/
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            insert regionalRolloutList;
            iDs.clear();
            for(IPM_Project_Rollout__c eachRollout : regionalRolloutList) {
             iDs.add(eachRollout.Id);
            }
            System.assertEquals(6, [Select count() from IPM_Project_Rollout__c where id in:iDs],'Regional Rollouts created');
            
            
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
            }
            
            /******************************** Initiate Phase Change and Regional Project Creation  ****************************************/
            Test.startTest();
            
             // Set GateKeeping Model as RCLT and start with Regional Project Creation.
            for(IPM_Project__c project : projectList)
            {
                project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            }  
            
            update projectList;
            
            for(IPM_Project__c project : projectList)
            {
                globalProjectIdList.add(project.Id);    
            }
            
            // Initiate Phase Change would result in Rollout Project Creation.
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
            
            update projectListPhaseChange;
            
            Test.stopTest();
            
            Map<Id,IPM_Milestone__c>  mileStoneMap = new Map<Id,IPM_Milestone__c>([Select IPM_Project__r.BET_MS_First_Release_Date__c,RecordTypeId,Id,Name,IPM_Type_of_Milestone__c from IPM_Milestone__c limit 1000] );
            
            Id recordtypeid= null;
            if(Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId() != null){
                recordtypeid=Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get(IPM_Utils.IPMProjectMilestones).getRecordTypeId();
            }
             
            List<IPM_Milestone__c> updateMilestoneList = new List<IPM_Milestone__c>();
            List<IPM_Milestone__c> ipmMileStoneList = new List<IPM_Milestone__c>();
            
            for(IPM_Milestone__c eachMilestone: mileStoneMap.values())
            {
                if(eachMilestone.IPM_Type_of_Milestone__c == IPM_Utils.Standard && eachMilestone.RecordTypeId == recordtypeid)
                {
                    eachMilestone.IPM_Planned_Date__c=System.today()+5;
                    eachMilestone.IPM_Due_Date__c =  System.today()+5;
                    updateMilestoneList.add(eachMilestone);
                }
             }  
                
            update updateMilestoneList;
            
            IPM_Milestone__c dueDateTodayMilestone = IPM_TestFactory_Helper.createIPMMilestone(projectList[0].Id, false);
            dueDateTodayMilestone.RecordTypeId = recordtypeid;    
            dueDateTodayMilestone.IPM_Due_Date__c =  System.today();
            dueDateTodayMilestone.IPM_Planned_Date__c=System.today() ;
            dueDateTodayMilestone.IPM_Type_of_Milestone__c = IPM_Utils.Standard;
            dueDateTodayMilestone.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
            ipmMileStoneList.add(dueDateTodayMilestone);
            
            IPM_Milestone__c pastMilestone = IPM_TestFactory_Helper.createIPMMilestone(projectList[0].Id, false);
            pastMilestone.RecordTypeId = recordtypeid;
            pastMilestone.IPM_Type_of_Milestone__c = IPM_Utils.Standard;
            pastMilestone.IPM_Planned_Date__c=System.today() - 4 ;
            pastMilestone.IPM_Due_Date__c = System.today() - 4 ;
            pastMilestone.IPM_Phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
            ipmMileStoneList.add(pastMilestone);
             
            insert ipmMileStoneList;
            iDs.clear();
            for(IPM_Milestone__c eachMilestone : ipmMileStoneList) {
                iDs.add(eachMilestone.id);
            }
            System.assertEquals(2, [Select count() from IPM_Milestone__c where id IN: iDs],MILESTONE_CREATED);
            
            List<IPM_Project_Document__c>  documentList  = [Select IPM_Document_Status__c from IPM_Project_Document__c 
            where IPM_Project__c =: projectList[0].Id limit 1000];
            documentList[0].IPM_Document_Status__c= IPM_ConstantUtils.DOCUMENT_STATUS_PROPOSED;
            update documentList; 
            
            
            PageReference pRef1 = new PageReference(sPageRefURL+projectList[0].Id);
        	Test.setCurrentPage(pRef1);
        
        	IPM_ProjDocumentSectionHstryController hstryControl=new IPM_ProjDocumentSectionHstryController();
        	IPM_ProjectOverviewCtrl overCtrl1=new IPM_ProjectOverviewCtrl(hstryControl);
        	system.assert(overCtrl1.childProjectsIncompleteAlert != null);
       }
     }      
 }