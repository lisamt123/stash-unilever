/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FinancialController class 
*/
@isTest
public class IPM_FinancialController_Test {
    
    @testSetup static void financialSetUp() 
     {
         List<User> userList = IPM_TestFactory_Helper.createUserList();
         
         IPM_TestFactory_Helper.getProjectMasterData();
         
         List<IPM_Project__c> globalProjectList = IPM_TestFactory_Helper.projectSetUp(1,userList[0]);
         System.runAs(userList[0])
         {
            insert globalProjectList;
         }
         
        System.runAs(userList[0])
        {
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalProjectList,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
             
            insert localRolloutList; 
            
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AGO';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BRA';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new mdm_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
        }
        
        List<IPM_Project__c> regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(1,UserList[1]);
         
        System.runAs(userList[1])
        {
            insert regionalProjectList;
            System.debug('---regionalProjectList------>>'+regionalProjectList);
        }
     }
    
    static testMethod void financialGlobalOrignalTest()
    {       
        Set<String> projectNameSet = new Set<String>{'TestComments1'};

        User globalUser = [Select Id from User where Email ='globalUser@unilever.test.com' limit 1]; 
        System.runAs(globalUser)
        { 
            Test.startTest();
            
            List<IPM_Project__c>  projectList = [Select Id,Name,IPM_Phase__c,(Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet];
            
            PageReference pageRef = new PageReference('/apex/IPM_Financial?Id='+projectList[0].Id);
            system.debug('///'+projectList[0].Id);
            Test.setCurrentPageReference(pageRef); 
        
            IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            
            ipmFinCon.selectedSustainabilityPeriod = '5';
            ipmFinCon.changeSustainabilityPeriod();
            ipmFinCon.checkSustainabilityPeriodChanged();
            ipmFinCon.refreshFinancials();
            
            ipmFinCon.currentTab = 'rollup';
            ipmFinCon.changeTabs();
            List<IPM_Project__c>lstLocalProjects = [Select Id,IPM_Parent_Project__r.Name from IPM_Project__c WHERE IPM_Parent_Project__c = :projectList[0].Id AND IPMProject_Span__c = :IPM_ConstantUtils.PROJECT_SPAN_LOCAL LIMIT 1];     
            //System.assertEquals(lstLocalProjects[0].IPM_Parent_Project__r.Name,'TestComments1','function not call properly');
            List<Id> globalProjectIdList = new List<Id>();
            
            for(IPM_Project__c projecttemp : projectList)
            {
                globalProjectIdList.add(projecttemp.Id);
            }
            
            
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalUser); 
            
            update projectListPhaseChange;
            
            
            
            Test.stopTest();
            
            Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);  
            
            System.debug('---globalToRegionalMap-------->>'+globalToRegionalMap);
            // Validate that project has moved to feasibility Phase.
            for(Id globalProjectId : globalToRegionalMap.keySet())
            {
                List<IPM_Project__c> regionalProjects = globalToRegionalMap.get(globalProjectId); 
                
                pageRef = new PageReference('/apex/IPM_Financial?Id='+regionalProjects[0].Id); 
                Test.setCurrentPageReference(pageRef); 
                    
                ipmFinCon = new IPM_FinancialController();
                
                ipmFinCon.currentTab = 'topdown';
                ipmFinCon.changeTabs();
                
                ipmFinCon.currentTab = 'rollup';
                ipmFinCon.changeTabs();
                
                ipmFinCon.currentTab = 'myview';
            	ipmFinCon.changeTabs();
            
                break;
            }
        }
    } 
    
    /*
    static testMethod void financialRegionalOrignalTest()
    {       
        Set<String> projectNameSet = new Set<String>{'TestRegionalComments1'};
            
        List<User> userList = [Select Id from User where Email ='regionalUser@unilever.test.com' limit 1]; 
        
        System.runAs(userList[0])
        {
            List<IPM_Project__c>  projectList = [Select Id, Name, IPM_Phase__c, (Select Id from Project_Documents__r),(Select Id,Name,recordTypeId,IPM_Project_Job_Status__c from IPM_Project_Rollout__r) from IPM_Project__c where Name in:projectNameSet];
            
            for(IPM_Project__c ipmProj : projectList){
                ipmProj.IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            }
            ///update projectList;
            
            List<Id> regionalProjectIdList = new List<Id>();
            
            for(IPM_Project__c projecttemp : projectList)
            {
                System.debug('-------projecttemp------------------->'+projecttemp.IPM_Phase__c);
                regionalProjectIdList.add(projecttemp.Id);
            }
            ///
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateRegionalProjectPhaseChange(regionalProjectIdList,userList[0]);///
            ///
            //update projectListPhaseChange; 
            
            PageReference pageRef = new PageReference('/apex/IPM_Financial?Id='+projectList[0].Id);
            Test.setCurrentPageReference(pageRef); 
        
            IPM_FinancialController ipmFinCon = new IPM_FinancialController();
            
            ipmFinCon.currentTab = 'rollup';
            ipmFinCon.changeTabs();
            ipmFinCon.currentTab = 'myview';
            ipmFinCon.changeTabs();
            ipmFinCon.currentTab = 'topdown';
            ipmFinCon.changeTabs();
            
            
        }
    } 
    */
}