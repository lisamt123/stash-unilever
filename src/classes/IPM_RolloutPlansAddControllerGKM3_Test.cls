/**
* This class contains unit tests for validating the behavior of Apex classes
* and triggers.
*

*/
@isTest
private class IPM_RolloutPlansAddControllerGKM3_Test {
    private static  List<User> userList;
	private static list<IPM_Company_Card__c> companyCardList;
	private static PageReference pageRef= Page.ipm_rolloutplansadd;
    private static final string GLOBAL_PL = 'GLOBAL_PL';
    private static final string REGIONAL_PL = 'REGIONAL_PL';
    private static final string LOCAL_PL = 'LOCAL_PL';
    private static final string AFRICA = 'Africa';
    private static final string GEO0060 = 'GEO0060';
    private static final string AFRICA_EMERGING_MARKETS = 'Africa Emerging Markets'; 
    private static final string LV4_GEO0085 = 'LV4_GEO0085';
    private static final string STATUS_ACTIVE = 'Active';
    private static final string ID = 'id';
    private static Id REGIONAL_ROLLOUT_RECTYPE = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.REGIONAL_ROLLOUT_RT).RecordTypeId;
    
    
         /*************************************************************************************
 * @Description :This is to set up test  data which can be  queried in test methods. 
 * @name :  projectSetUp
 ***************************************************************************************/
     @testSetup static void projectSetUp() 
     {    
     	  
         // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
	
         User globalProjectLeader = null; 
         User regionalProjectLeader = null;
         User localProjectLeader =  null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         
         Test.StartTest();
         
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = GLOBAL_PL;
            regionalProjectLeader.lastname = REGIONAL_PL;
            localProjectLeader.lastname = LOCAL_PL; 
            
            List<User> DBuserList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update DBuserList;
            
            List<User> assertUsrList = [select Id from User where lastname =: GLOBAL_PL];
            system.assertEquals(1,assertUsrList.size(),'Global User not created');
			 
			// Create Company Card information 
			IPM_Company_Card__c globalCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3GlobalCompanyCard(false);
			IPM_Company_Card__c localCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3LocalCompanyCard(false);
			
			companyCardList = new List<IPM_Company_Card__c>{globalCompanyCardGKM3,localCompanyCardGKM3};
			insert companyCardList;
			
            MDO_Geography__c  goegraphiesCluster = new MDO_Geography__c();
            goegraphiesCluster.Name = AFRICA;
            goegraphiesCluster.geography_type__c = 'Unilever Cluster';
            goegraphiesCluster.Status__c = STATUS_ACTIVE;
            goegraphiesCluster.mdm_id__c = GEO0060;
            insert goegraphiesCluster;
              
            MDO_Geography__c goegraphiesMCO1 = new MDO_Geography__c();
            goegraphiesMCO1.Name = AFRICA_EMERGING_MARKETS;
            goegraphiesMCO1.parent_L2__c = goegraphiesCluster.id;
            goegraphiesMCO1.geography_type__c = 'country group';
            goegraphiesMCO1.mdm_id__c=LV4_GEO0085;
            goegraphiesMCO1.Status__c = STATUS_ACTIVE;
            
            
            MDO_Geography__c goegraphiesMCO2 = new MDO_Geography__c();
            goegraphiesMCO2.Name = 'Nigeria';
            goegraphiesMCO2.parent_L2__c = goegraphiesCluster.id;
            goegraphiesMCO2.geography_type__c = 'country group';
            goegraphiesMCO2.mdm_id__c = 'LV4_NG';
            goegraphiesMCO2.Status__c = STATUS_ACTIVE;
			
			List<MDO_Geography__c> geoMCOList = new List<MDO_Geography__c>{goegraphiesMCO1,goegraphiesMCO2};
			insert geoMCOList;
			
            MDO_Geography__c mdoAFR = new MDO_Geography__c( ISO_3166_1_Code__c = 'AO', Name = 'Angola', mdm_id__c = 'AO', parent_L2__c = geoMCOList[0].id,  geography_type__c = 'Country', Status__c = STATUS_ACTIVE );
            
            MDO_Geography__c mdoLA = new MDO_Geography__c(ISO_3166_1_Code__c = 'CM',Name = 'Cameroon',mdm_id__c = 'CM',parent_L2__c = geoMCOList[0].id,geography_type__c = 'Country',Status__c = STATUS_ACTIVE);
            
            MDO_Geography__c mdoCongo = new MDO_Geography__c(ISO_3166_1_Code__c = 'CG',Name = 'Congo',mdm_id__c = 'CG',parent_L2__c = geoMCOList[0].id,geography_type__c = 'Country',Status__c = STATUS_ACTIVE);
            
           
           	MDO_Geography__c mdoNigeria = new MDO_Geography__c(ISO_3166_1_Code__c = 'NG',Name = 'Nigeria',mdm_id__c = 'NG',parent_L2__c = geoMCOList[1].id,geography_type__c = 'Country',Status__c = STATUS_ACTIVE);
           	 
			insert new List<MDO_Geography__c>{mdoAFR,mdoLA,mdoNigeria,mdoCongo};
            
            IPM_Market_Cluster_Short_Names__c marketCluster = new IPM_Market_Cluster_Short_Names__c();
            marketCluster.Name = GEO0060;
            marketCluster.Unilever_Cluster__c = AFRICA;
            marketCluster.Short_Name__c = 'AFR';
            insert marketCluster; 
            
            IPM_MCO_Short_Names__c mcoShortName1 = new IPM_MCO_Short_Names__c();
            mcoShortName1.Name = LV4_GEO0085;
            mcoShortName1.Country_Group__c = AFRICA_EMERGING_MARKETS;
            mcoShortName1.Short_Name__c = 'UMCA';
            
            IPM_MCO_Short_Names__c mcoShortName2 = new IPM_MCO_Short_Names__c();
            mcoShortName2.Name = 'LV4_NG';
            mcoShortName2.Country_Group__c = 'Nigeria';
            mcoShortName2.Short_Name__c = 'NG';
            
            insert new List<IPM_MCO_Short_Names__c>{mcoShortName1,mcoShortName2};
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
            IPM_MilestoneHelper.SKIP_TRIGGER_EXECUTION = true;
            IPM_TaskHelper.SKIP_TRIGGER_EXECUTION = true;

 			IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
            IPM_MilestoneHelper.SKIP_TRIGGER_EXECUTION = false; 
            IPM_TaskHelper.SKIP_TRIGGER_EXECUTION = false;
            
			IPM_TestFactory_Helper.getProjectMasterDataForGKM3();
			
			IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader});
            
        	
		}   
		
		
		List<IPM_Project__c> projectList = new List<IPM_Project__c>();
		
		System.runAs(globalProjectLeader)
		{   
			List<IPM_Project__c> globalprojectList = IPM_TestFactory_Helper.projectSetUpGKM3(1,globalProjectLeader);
			
			projectList.addAll(globalprojectList);
		}
		
		insert projectList;
		
		List<IPM_Project__c> projectAssertList = [Select Id,Name from IPM_Project__c where id in : projectList];
		system.assert(projectAssertList.size() > 0 ,'Projects not Inserted Successfully');
		
		Test.stopTest();  
     }
     
     
     /*
         Test Method to test the logic of global project rollout for GKM3 gatekeeping Model
     */
     
             private static  testmethod void globalProjRolloutAdd() 
        {             
        	List<IPM_Project__c> projectAssertList = [Select Id,Name,IPM_Project_Type__c,IPM_Project_Name__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_ProjectGKM__c,IPM_CompanyCardText__c from IPM_Project__c where IPM_Project_Name__c != 'IPM_MasterProject' AND IPMProject_Span__c ='Global' LIMIT 10 ];
			
			// setting values of GeographyWrapper parameters
			User globalProjectLeader = null;
			User regionalProjectLeader = null;  
		
			// getting project leaders  for global ,local and regional
			userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
		
			for(User lUser  :userList)
			{
				if(lUser.lastName == GLOBAL_PL)
				{
					globalProjectLeader = lUser;
				}
				if(lUser.lastName == REGIONAL_PL)
				{
					regionalProjectLeader = lUser;
				}
			}

			system.RunAs(globalProjectLeader)
     		{
     			Test.StartTest();
     			
	        	Test.setCurrentPageReference(pageRef);
				ApexPages.currentPage().getParameters().put(ID,projectAssertList[0].Id); 
			   	
           		IPM_RolloutPlansAddController irp = new IPM_RolloutPlansAddController(); 
 				
 				irp.redirectPage();
 				irp.cancel();

           		irp.globalCountries = 'AO,NG,CM,CG'; 
           		irp.generateRollouts(); 
				
				List<IPM_Project_Rollout__c> projectRolloutList = [SELECT Id,IPM_Rollout_Project__c,IPM_Rollout_Span__c,IPM_Regional_PL__c,IPM_Regional_PL_Text__c,isActive__c,(SELECT ID FROM IPM_Countries_Local__r)  from IPM_Project_Rollout__c where IPM_Project__c =:projectAssertList[0].Id];
				
	
            	System.assertEquals(projectRolloutList.size(),3,'Rollouts Creation Failed.');
            	
            	System.debug(LoggingLevel.ERROR,'projectRolloutList-->>'+projectRolloutList);
            	
            	IPM_Project_Rollout__c regionalRollout = null;
            	for(IPM_Project_Rollout__c projectRollout : projectRolloutList)
            	{
            		if( projectRollout.IPM_Rollout_Span__c == 'Local')
            		{
            			if(projectRollout.IPM_Rollout_Project__c.contains('NG'))
	            		{
	            			System.assertEquals(projectRollout.IPM_Countries_Local__r.size(),1,'Countries association Failed.');		
	            		}
	            		else if(projectRollout.IPM_Rollout_Project__c.contains('UMCA'))
	            		{
	            			System.assertEquals(projectRollout.IPM_Countries_Local__r.size(),3,'Countries association Failed.');	
	            		}	
            		}
            		else
            		{
            			regionalRollout = projectRollout;
            		}
            	} 
            	
            	irp.changeCluster();
           	
           		irp.changeMCO();
           		
           		
           		irp.searchCountry = 'Africa'; 
           		irp.searchRolloutCountry();
           		
           		irp.checkLocalProjectAssociatedOrNot();
           		
            	regionalRollout.IPM_Regional_PL__c = regionalProjectLeader.Id;
        		regionalRollout.IPM_Regional_PL_Text__c = regionalProjectLeader.Name;
        		regionalRollout.isActive__c = true;
        		regionalRollout.recordTypeId = REGIONAL_ROLLOUT_RECTYPE;
        		
        		IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true;
        		update regionalRollout;
        		IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
            
	         	List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(new List<Id>{projectAssertList[0].Id},globalProjectLeader); 
         	    update projectListPhaseChange;
         	    
	         	Test.StopTest();

     			Test.setCurrentPageReference(pageRef);
				ApexPages.currentPage().getParameters().put(ID,projectListPhaseChange[0].Id); 
	
	       		IPM_RolloutPlansAddController irpRegional = new IPM_RolloutPlansAddController(); 
				
	       		irpRegional.regionalMco = 'AO,CM,NG,CG';
	       		irpRegional.regionalUnselectedMco = 'CM';
	       		irpRegional.regionalCountry = 'CG';
	       		irpRegional.regionalNoRoll = 'NG';	
	       		irpRegional.generateRollouts();
	       		
	       		irpRegional.checkLocalProjectAssociatedOrNot();
	       		System.debug(LoggingLevel.ERROR,'Queries 3 ---->>'+Limits.getQueries());
     		}
      	} 

}