/*******************************************************
 * @Description: Test class for IPMRolloutTriggerHandler
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/
@isTest
 private class IPM_RolloutTriggerHandler_Test {
    
    private static List<IPM_Project_Rollout__c> regionalRolloutList = new List<IPM_Project_Rollout__c>();
    private static Map<Id, IPM_Project_Rollout__c> mapNewProjectRollouts=new Map<Id, IPM_Project_Rollout__c>();
    
    /***********************************
    * @Description: Test Data Creation
    * *********************************/
      @testSetup static void projectSetUp() 
     {
     
        List<User> userList = IPM_TestFactory_Helper.createUserList();
        
        
         
        List<IPM_Project__c> projectList = IPM_TestFactory_Helper.projectSetUp(3,userList[0]);
        
        System.runAs(userList[0])
        {
            insert projectList;
        }   
        
        
        
        
        IPM_TestFactory_Helper.getProjectMasterData();
        System.runAs(userList[0])
        {
            // Create Regional Rollouts for Created Global project.
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{userList[1],userList[1],userList[1]});
            insert regionalRolloutList;
            
            List<IPM_Project_Rollout__c> assertRolloutList = [select id from IPM_Project_Rollout__c where IPM_Rollout_Span__c = :IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL];
            system.assertEquals(6,assertRolloutList.size(),'Regional Rollout not created');
            
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
            insert localRolloutList; 
            
            List<IPM_Project_Rollout__c> assertLocalRolloutList = [select id from IPM_Project_Rollout__c where IPM_Rollout_Span__c = :IPM_ConstantUtils.ROLLOUT_SPAN_LOCAL ];
            system.assertEquals(6,assertLocalRolloutList.size(),'Local Rollout not created');
            
            
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
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
                
                //MDO_Geography__c mdo = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId);
               
                // Here for geography we creat entry in country objects
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
       
        }
     }
     
 
    /***********************************
    * @Description: Test method invoke
    * *********************************/
   
     static testMethod void dotestRegional(){
        test.startTest();
        //initializeData();
        //lstProjectRollouts.add(proRollRegional);
       
        set<Id> rolloutId = new Set<Id>();
        IPM_RolloutTriggerHandler ipmRollHand=new IPM_RolloutTriggerHandler();
        ipmRollHand.processUpdate(mapNewProjectRollouts,mapNewProjectRollouts);
        for(IPM_Project_Rollout__c rollout : regionalRolloutList)
        {
            rolloutId.add(rollout.id);
        }
        
        ipmRollHand.processInsert(regionalRolloutList);
        ipmRollHand.processDelete(regionalRolloutList);
       
        List<IPM_Project_Rollout__c> projRollOutList=[SELECT ID FROM IPM_Project_Rollout__c where id in :rolloutId];
        System.assertEquals(0,projRollOutList.size(),'no rollout deleted');
        test.stopTest(); 
    }
    
    
    
}