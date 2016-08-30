/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class for ipmRolloutPlansTableController class functionalities
*********************************************/

@isTest
private class IPM_RolloutPlansTableController_Test{
     
    /*
    * @description For Running Test Script
    */ 
    private static User stdUserForRollout;
    private static List<IPM_Project__c > projectList;
    private static List<IPM_Project_Rollout__c> localRolloutList;
    private static Map<Id, IPM_Project_Rollout__c> mapNewProjectRollouts=new Map<Id, IPM_Project_Rollout__c>();
    //public static Map<Id, IPM_Project_Rollout__c> mapOldProjectRollouts=new Map<Id, IPM_Project_Rollout__c>();
  
    private static List<IPM_Project_Rollout__c> regionalRolloutList;
    private static final String CANCEL_REDIRECT ='cancelRedirect' ;
    private static final String TESTPROJECT = 'TestComments1';
   
    
    private static final String ID_PARAMETER = 'Id';
    private static  PageReference pageRef = Page.ipm_rolloutplansadd;
    //PageReference pageRef = new PageReference('/apex/ipm_rolloutplansadd?id='+projectList[0].Id);
    
    @testSetup static void projectSetUp()  
    {
      System.runAs(IPM_TestFactory_Helper.createUserAdmin(true))
        {
          // user has to be created as system admin 
           stdUserForRollout = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }   
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        Test.startTest();
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
       
        List<IPM_Company_Card__c> companyCardAssertList = [select id from IPM_Company_Card__c where id in : companyCardList];
        system.assertEquals(3,companyCardAssertList.size(),'Number of company card inserted is not 3 ');
       
        
        IPM_TestFactory_Helper.getProjectMasterData();

        System.runAs(stdUserForRollout)
        {
           
            projectList = IPM_TestFactory_Helper.projectSetUp(1, stdUserForRollout);
            insert projectList;
           
            set<Id> projId = new set<Id>();
            for(IPM_Project__c proj : projectList)
            {
               projId.add(proj.id); 
            }
            
            List<IPM_Project__c> projectAssertList = [select Name from IPM_Project__c where id in : projId];
            system.assertEquals(1,projectAssertList.size(),'No project created');
            
           
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{stdUserForRollout,stdUserForRollout});
            insert regionalRolloutList; // this will give me all regional rollout
            
            
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
             }
            
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
            
            insert countryList;
            Test.stopTest();
            IPM_RolloutTriggerHandler handler = new IPM_RolloutTriggerHandler();
            handler.processInsert(localRolloutList);
            //handler.processUpdate(mapNewProjectRollouts,mapNewProjectRollouts);
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
            
            
            System.assertEquals(projectList[0].IPM_Phase__c,'Ideas','Project Phase is not ideas');
           
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put(ID_PARAMETER,projectList[0].Id);
           
            
            IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
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
           
           Test.startTest();
           update projectRolloutList;
           List<IPM_Project_Rollout__c> rolloutAssertList = [Select Id from IPM_Project_Rollout__c where IPM_Project_Job_Status__c =:IPM_ConstantUtils.JOB_STATUS_ELIGIBLE];
           system.assertEquals(2,rolloutAssertList.size(),'Rollout is not eligible for job run');
           Test.stopTest();
                  
        }
     }  

    /********************************************************************
    * @Description: This method is used to add method of the main class           
    * *******************************************************************/
   static testMethod void RolloutMethodTest()
   {
    
    
    Set<String> projectNameSet = new Set<String>{TESTPROJECT};
    
    User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser)
        {
            Test.startTest();
            
            String bool  = IPM_RolloutPlansTableController.BOOLEAN_TRUE;
            System.assertEquals('true', bool,'It is false');
            
            String ChkRollout =IPM_RolloutPlansTableController.CHECK_ROLLOUTS ;
            System.assertEquals('checkRollouts', ChkRollout,'CheckRollout not called');
            
            String idParam = IPM_RolloutPlansTableController.ID_PARAMETER ;
            System.assertEquals('Id', idParam,'Id not matched');
            
            String addRollout = IPM_RolloutPlansTableController.ADD_ROLLOUT;
            System.assertEquals('addRollout', addRollout,'Add Rollout not called');
            
            String saveRollout =IPM_RolloutPlansTableController.SAVE_ROLLOUT;
            System.assertEquals('saveRollout', saveRollout,'Save Rollout not called');
            
            String cancelRedrct = IPM_RolloutPlansTableController.CANCEL_REDIRECT;
            System.assertEquals('cancelRedirect', cancelRedrct,'Cancel Redirect not called');
            
            projectList = [Select Id, Name from IPM_Project__c where Name in:projectNameSet];
       
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put(ID_PARAMETER,projectList[0].Id);
            
            
            
            IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
            irp.isEditMode = true;
            irp.isEditable = true;
            irp.isStatusEditable = true;  
            irp.doShowPLName = true;
            irp.doShowFLName = true;
            
             
            system.currentPageReference().getParameters().put(CANCEL_REDIRECT, 'cancelRedirect');
            
            irp.checkRollouts();
            system.currentPageReference().getParameters().put(IPM_ConstantUtils.EDITMODE,IPM_ConstantUtils.EDITMODE_TRUE);
            irp.editRollout();
            irp.cancelRollout();
            system.currentPageReference().getParameters().put(ID_PARAMETER , projectList[0].Id);
           
            irp.addRollout();
            irp.saveRollout();
            irp.deleteMCORollout();
            PageReference pRef = new PageReference(IPM_ConstantUtils.REDIRECT_URL_FOR_ROLLOUT_REDIRECT);
            Test.setCurrentPageReference(pRef);
            
            pageReference pRefRedirect = new PageReference(IPM_ConstantUtils.REDIRECT_URL_FOR_ROLLOUT_REDIRECT);
            Test.setCurrentPageReference(pRefRedirect);
            
            Test.stopTest();
        }
  }
    
 
static testMethod void RegionalOrignalTest()
     {    
        User regionalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(regionalUser)
        {
            Test.startTest();
            
           List<IPM_Project__c> regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(1,regionalUser); //create a regional project
           insert regionalProjectList;
              
           Test.setCurrentPage(pageRef);
           ApexPages.currentPage().getParameters().put(ID_PARAMETER,regionalProjectList[0].Id);
           
           
           IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
           irp.isEditMode = true;
           irp.isEditable = true;
           irp.isStatusEditable = true;  
           irp.editRollout();
           irp.cancelRollout();
           irp.checkRollouts();
           irp.addRollout();
           irp.saveRollout();
           irp.deleteMCORollout();
           List<IPM_Project_Rollout__c>proRoll=[select Id,IPM_Project__c from IPM_Project_Rollout__c where Id=:irp.selectedMCORollout];
           System.assertEquals(proRoll.size(),0,'rollout not deleted');
           irp.holdLocalRolloutBrandVal();
           Test.stopTest();
         }
     }

 public static testMethod void testException()
 {  
    
    Set<String> projectNameSet = new Set<String>{TESTPROJECT};
    User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
     
        System.runAs(globalUser)
        {
            Test.startTest();
            
            projectList = [Select Id, Name from IPM_Project__c where Name in:projectNameSet];
           
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put(ID_PARAMETER,projectList[0].Id);
           
            
            IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
            
            irp.editRollout();
            irp.cancelRollout();
            irp.checkRollouts();
            irp.addRollout();
            irp.saveRollout();
            irp.deleteMCORollout();
            List<IPM_Project_Rollout__c>proRoll=[select Id,IPM_Project__c from IPM_Project_Rollout__c where Id=:irp.selectedMCORollout];
            System.assertEquals(proRoll.size(),0,'rollout not deleted');
           
            Test.stopTest();
       
        }
     
    }
 
 }
