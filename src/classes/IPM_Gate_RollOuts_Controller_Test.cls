/*******************************************************
 * @Description: Test class for IPM_Gate_RollOuts_Controller
 * @Author:Cognizant
 * @Date:05/08/2015
 * *****************************************************/

@isTest
public class IPM_Gate_RollOuts_Controller_Test{

	private static User platformUser;
	private static List<IPM_Project__c> globalProjectList;
	private static List<IPM_Project_Rollout__c> regionalRolloutList;
	private static List<IPM_Project_Rollout__c> localRolloutList;
	private static final String PROJ_CREATED='Projects are created';
	private static Set<Id> iDs ;
    public static list<IPM_Country__c> countryList;
    
    /*******************************************************
     * @Description: Method to initilize data
     * *****************************************************/
     @testSetup static void projectSetUp() 
     {
         iDs = new Set<Id>();
        
         //Creation test user
         platformUser =IPM_TestFactory_Helper.returnPlatformUser();
          
         // Create Company Card information 
         IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
         IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
         IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
         List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
         insert companyCardList;
         for(IPM_Company_Card__c eachCompanyCard : companyCardList) {
            iDs.add(eachCompanyCard.Id);
         }
     	 System.assertEquals(3, [Select count() from IPM_Company_Card__c where id in:iDs],'company cards are created');
          
         IPM_TestFactory_Helper.getProjectMasterData();
         
         globalProjectList = IPM_TestFactory_Helper.projectSetUp(1,platformUser);
         System.runAs(platformUser)
         {
         	insert globalProjectList;
         	iDs.clear();
       	 	for(IPM_Project__c eachProj : globalProjectList) {
             iDs.add(eachProj.Id);
         	}
     	 	System.assertEquals(1, [Select count() from IPM_Project__c where id in:iDs],PROJ_CREATED);
         
            // Create Regional Rollouts for Created Global project.
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalProjectList,new List<User>{platformUser,platformUser,platformUser});
            insert regionalRolloutList;
            iDs.clear();
       	 	for(IPM_Project_Rollout__c eachRollout : regionalRolloutList) {
             iDs.add(eachRollout.Id);
         	}
     	 	System.assertEquals(2, [Select count() from IPM_Project_Rollout__c where id in:iDs],'Regional Rollouts created');
            
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
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{platformUser});  
             
            insert localRolloutList;
             
            iDs.clear();
       	 	for(IPM_Project_Rollout__c eachRollout : localRolloutList) {
             iDs.add(eachRollout.Id);
         	}
     	 	System.assertEquals(2, [Select count() from IPM_Project_Rollout__c where id in:iDs],'Local rollouts created');
           
            // Create Country specific information.
            countryList= new List<IPM_Country__c>();
            
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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',
                OwnerId=UserInfo.getUserId());    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
            iDs.clear();
       	 	for(IPM_Country__c eachCountry : countryList) {
             iDs.add(eachCountry.Id);
         	}
     	 	System.assertEquals(2, [Select count() from IPM_Country__c where id in:iDs],'Countries added');
          
            List<IPM_Gate_RollOuts_Controller.LocalRolloutWrapper> lstLocalWrapper = new List<IPM_Gate_RollOuts_Controller.LocalRolloutWrapper>();
            IPM_Gate_RollOuts_Controller.LocalRolloutWrapper localRolloutWrapper = new IPM_Gate_RollOuts_Controller.LocalRolloutWrapper(localRolloutList[0],countryList);
            lstLocalWrapper.add(localRolloutWrapper);
            new IPM_Gate_RollOuts_Controller.RegionalRollOutWrapper(regionalRolloutList[0].Name,lstLocalWrapper); // NO SONAR used to cover the test coverage of constructor  
            IPM_Gate_RollOuts_Controller gateController = new IPM_Gate_RollOuts_Controller(); 
            gateController.proId = globalProjectList[0].Id;     
        
        
        }
        
     } 
     
<<<<<<< HEAD
=======
     public static testmethod void initiate()
     {
         
	         Test.startTest();
	         List<IPM_Project__c> projectList = [Select Id from IPM_Project__c where Name = 'TestComments1'];
	         
	         IPM_Gate_RollOuts_Controller gateController = new IPM_Gate_RollOuts_Controller();
	         gateController.proId = projectList[0].Id;
	         gateController.prepareIPMLocalToCountryWrapper();
	         
	         System.assertEquals(gateController.regionalRollOutWrapperList.size(),2, 'Regional Rollouts list result size is more or leass than 2 records');
	         
	         System.assertEquals(gateController.regionalRollOutWrapperList[0].regionalRollOutName,'TestComments1_AFR', REGIONAL_ROLLOUT_NAME_FAIL);
	         System.assertEquals(gateController.regionalRollOutWrapperList[1].regionalRollOutName,'TestComments1_LA', REGIONAL_ROLLOUT_NAME_FAIL);
	         Test.stopTest();
      
     } 
     
     public static testmethod void testPrepareIPMLocalToCountryWrapperForRegionalOriginal()
     {
     		List<IPM_Project__c> regionalProjectList;
     		countryList= new List<IPM_Country__c>();
     		iDs = new Set<Id>();
     		
     		Test.startTest();
     		System.debug('platformUser==>'+platformUser);
     		platformUser = [Select Id, Name from User where LastName = 'PLATFORM_USER' limit 1];
     		System.debug('platformUser after==>'+platformUser);
     		System.runAs(platformUser)
     		{
         	 		regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(5,platformUser);
         	 		insert regionalProjectList;
         	 		
         	 		// Create local Rollouts for Created regional Rollouts.
            		localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsOriginalList(false,regionalProjectList,new List<User>{platformUser});  
            		insert localRolloutList;
            		
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
	                																IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',
	                																OwnerId=UserInfo.getUserId());    
	                
	                		countryList.add(tempCountry);
            		}
            
            		insert countryList;
            		
            		for(IPM_Country__c eachCountry : countryList) {
             			iDs.add(eachCountry.Id);
            		}
            		System.assertEquals(5, [Select count() from IPM_Country__c where id in:iDs],'Countries insertion fails');
            		
			         IPM_Gate_RollOuts_Controller gateController = new IPM_Gate_RollOuts_Controller();
	    		     gateController.proId = regionalProjectList[0].Id;
	         		gateController.prepareIPMLocalToCountryWrapper();
	         
	         		System.assertEquals(gateController.regionalRollOutWrapperList.size(),1, 'Regional Rollouts list wrapper is not constructed properly.');
	         
	         		System.assertEquals(gateController.regionalRollOutWrapperList[0].regionalRollOutName,'TestRegionalComments1', REGIONAL_ROLLOUT_NAME_FAIL);
	         
     		}
     		Test.stopTest();
      
     } 
     
>>>>>>> 5e95981f5bdc62ad3a9ade30654a859661cab86b
    }