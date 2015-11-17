/******************************************** 
*@Author:Cognizant
*@Date:01/02/2015
*@Description : Test class for ipmRolloutPlansTableController class functionalities
*********************************************/

@isTest
public class IPM_RolloutPlansTableController_Test{
     
    /*
    * @description For Running Test Script
    */ 
    public static User platformUser;
    public static final String CANCEL_REDIRECT ='cancelRedirect' ;
    public static final String TESTPROJECT = 'TestComments1';
    public static String cancelRedirect;    
    public static String editMode='';
    public static List<IPM_Project__c> globalProjectList;
    public static List<IPM_Project__c> lstRegionalProjects;
    public static List<IPM_Project__c> projectListObj = new List<IPM_Project__c>();
    private static List<IPM_Project_Document__c> currDocuments;
    private static List<IPM_Project_Document__c> updatedDocument;
    public static List<IPM_Project__c> projectList;
   
    //public static selectProjectleader
  
    public static final String ID_PARAMETER = 'Id';
    @testSetup static void projectSetUp()  
    {
        
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
        }
        
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
        
        IPM_TestFactory_Helper.getProjectMasterData();
         
        projectList = IPM_TestFactory_Helper.projectSetUp(1,platformUser);
        System.runAs(platformUser)
        {
           insert projectList;
        } 
        
    }
    
    public static testMethod void  testCreateRollout(){ 
        
        
         User globalUsr = [Select Id,Name,LastName from User where LastName='PLATFORM_USER' limit 1];  
         projectListObj = IPM_TestFactory_Helper.projectSetUp(1,globalUsr);
         System.runAs(globalUsr)
         {
            
            
                    
            
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectListObj,new List<User>{globalUsr,globalUsr});
            insert regionalRolloutList; // this will give me all regional rollout
            System.assertEquals(regionalRolloutList.size(),1);
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
            
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{globalUsr});  
            insert localRolloutList; 
            System.assertEquals(localRolloutList.size(),1);
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
               insert mdo; // we need an external id for geo insertion which is fetched on the basis of localrollout list so cant write outside.
                
               IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo.id,
               IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
               countryList.add(tempCountry);
            }
            
            insert countryList;
            System.assertEquals(countryList.size(),1);
        }
    }
     
     /** Create project 
        *  Used for Testing Global Project Creation. 
        *  @name projectSetUp
     */
    public static testMethod void testProjectPhaseChange()
     {
        Set<String> projectNameSet = new Set<String>{TESTPROJECT};
        List<IPM_Project__c> updateRegionalProject = new List<IPM_Project__c>(); 
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser)
        { 
            IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
            
            Test.startTest();
            List<IPM_Project__c> projectListNew = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,(Select Id from Project_Documents__r)
                from IPM_Project__c where Name in:projectNameSet];
            System.assertEquals(projectListNew[0].Name,TESTPROJECT,'project not created');
            for(IPM_Project__c project : projectListNew)
            {
                //System.assertEquals(project.Project_Documents__r.size(),1);
                System.assertEquals(project.IPM_Phase__c,'Ideas'); // One for Global consolidated and 2 for Regional Consolidated.
                updateRegionalProject.add(project);
            }
            
            update updateRegionalProject;
           
            globalProjectList = [Select Id,IPM_Company_Card__c,Name,IPM_Phase__c,(Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet];
            
            List<Id> globalProjectIdList = new List<Id>();
            
            for(IPM_Project__c projecttemp : globalProjectList)
            {
                globalProjectIdList.add(projecttemp.Id);
            }
            
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalUser); 
            
            update projectListPhaseChange;
           
            Test.stopTest();
           
            Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);  
            
            lstRegionalProjects = new List<IPM_Project__c>();
            
            for(Id gbProjectId : globalToRegionalMap.keySet())
            {
               lstRegionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
            }

            List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :lstRegionalProjects];
            
            updatedDocument = new List<IPM_Project_Document__c>();
            currDocuments= [Select IPM_GateDocuments__c,IPM_Document_Status__c from IPM_Project_Document__c limit 1000];
            for(IPM_Project_Document__c currDoc:currDocuments)
            {
                if(currDoc.IPM_GateDocuments__c == IPM_ConstantUtils.CHARTER_GATE)
                currDoc.IPM_Document_Status__c =IPM_ConstantUtils.DOCUMENT_STATUS_APPROVEDWITHEDITS;
                updatedDocument.add(currDoc);
            }
            update updatedDocument;
         
           irp.isEditMode = true;
           irp.isEditable = true;
           irp.isStatusEditable = true;     
           irp.editRollout();
           irp.cancelRollout();
           irp.checkRollouts();
           irp.addRollout();
           irp.saveRollout();
           irp.deleteMCORollout(); 
           
           
          }
     }
     
     public static testmethod void testRolloutProject()
     {
        Set<String> projectNameSet = new Set<String>{TESTPROJECT};
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        
        // Create Regional Projects.
        System.runAs(globalUser)
        {
            Test.startTest();
            projectList = [Select Id,Name,IPM_Phase__c,(Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet for update];
            
            
            System.assertEquals(projectList[0].IPM_Phase__c,'Ideas');
           
            PageReference pageRef = new PageReference('/apex/ipm_rolloutplansadd?id='+projectList[0].Id);
            Test.setCurrentPage(pageRef); 
            IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
            irp.addRollout();
            irp.saveRollout();
            
            List<IPM_Project_Rollout__c> projectRolloutList = new List<IPM_Project_Rollout__c>();
            Set<Id> projectDocumentSet = new Set<Id>();
                     
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
                
                for(IPM_Project_Document__c projectDocument : project.Project_Documents__r)
                {
                    projectDocumentSet.add(projectDocument.Id);
                }
           
            }
           update projectRolloutList;
                  
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
            System.assertEquals('true', bool);
            
            String ChkRollout =IPM_RolloutPlansTableController.CHECK_ROLLOUTS ;
            System.assertEquals('checkRollouts', ChkRollout);
            
            String idParam = IPM_RolloutPlansTableController.ID_PARAMETER ;
            System.assertEquals('Id', idParam);
            
            String addRollout = IPM_RolloutPlansTableController.ADD_ROLLOUT;
            System.assertEquals('addRollout', addRollout);
            
            String saveRollout =IPM_RolloutPlansTableController.SAVE_ROLLOUT;
            System.assertEquals('saveRollout', saveRollout);
            
            String cancelRedrct = IPM_RolloutPlansTableController.CANCEL_REDIRECT;
            System.assertEquals('cancelRedirect', cancelRedrct);
            
            projectList = [Select Id, Name from IPM_Project__c where Name in:projectNameSet];
       
            PageReference pageRef = new PageReference('/apex/ipm_rolloutplansadd?id='+projectList[0].Id);
            Test.setCurrentPage(pageRef);
            IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
            irp.isEditMode = true;
            irp.isEditable = true;
            irp.isStatusEditable = true;  
            irp.doShowPLName = true;
            irp.doShowFLName = true;
            
            
            editMode=''; 
             
            system.currentPageReference().getParameters().put(CANCEL_REDIRECT, 'cancelRedirect');
            
            cancelRedirect = ApexPages.currentPage().getParameters().get(CANCEL_REDIRECT);
            irp.checkRollouts();
            system.currentPageReference().getParameters().put(IPM_ConstantUtils.EDITMODE,IPM_ConstantUtils.EDITMODE_TRUE);
            editMode = ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.EDITMODE);
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
              
           PageReference pageRef = new PageReference('/apex/ipm_rolloutplansadd?id='+regionalProjectList[0].Id);
           Test.setCurrentPageReference(pageRef); 
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
           System.assertEquals(proRoll.size(),0,'rollout deleted');
         
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
       
            PageReference pageRef = new PageReference('/apex/ipm_rolloutplansadd?id='+projectList[0].Id);
            Test.setCurrentPage(pageRef);
            IPM_RolloutPlansTableController irp= new IPM_RolloutPlansTableController();
            
            irp.editRollout();
            irp.cancelRollout();
            irp.checkRollouts();
            irp.addRollout();
            irp.saveRollout();
            irp.deleteMCORollout();
            List<IPM_Project_Rollout__c>proRoll=[select Id,IPM_Project__c from IPM_Project_Rollout__c where Id=:irp.selectedMCORollout];
           System.assertEquals(proRoll.size(),0,'rollout deleted');
           
           Test.stopTest();
       
        }
     
    }
 
 }