/**
   @Author Cognizant Techinology Solutions
   @name IPM_ProjectPrototype_Test
   @CreateDate 8/20/2015
   @Description Test Class for testing project specific helpers.
   @Version 1.0
   @reference Project Creation and Phase Change
  */
  
@isTest
private with sharing class IPM_RolloutPlansAddLocalController_Test {
    public static final String ASSERT_ERROR_STR = 'Projects not Created Properly.';
    public static final String EMPTY_STRING=''; 
    private static final string GEO0060 = 'GEO0060';
    private static final string LV4_GEO0085 = 'LV4_GEO0085';
    private static final string STATUS_ACTIVE = 'Active';
    private static final String COUNTRY = 'Country';
    private static  PageReference pageRef = Page.IPM_RolloutPlansLocalOriginal ;
    /**
        *  Used for Setting test Data for Project Creation . 
        *  @name projectSetUp
    */
    
    @testSetup static void projectSetUp(){
         // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
         User globalProjectLeader = null;
         User regionalProjectLeader = null;
         User localProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser){   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(EMPTY_STRING);
            regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(EMPTY_STRING);
            localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(EMPTY_STRING);
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = 'GLOBAL_PL';
            regionalProjectLeader.lastname = 'REGIONAL_PL';
            localProjectLeader.lastname = 'LOCAL_PL'; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;         
            List<User> dbUserList =  [Select Id from User where id in :userList];
            
            
            System.assertEquals(dbUserList.size(),userList.size(),'Users not Created Properly.Actual no of Users should be'+userList.size());
            
            MDO_Geography__c  goegraphiesCluster = new MDO_Geography__c();
            goegraphiesCluster.Name = 'SEAA';
            goegraphiesCluster.geography_type__c = 'Unilever Cluster';
            goegraphiesCluster.Status__c = STATUS_ACTIVE;
            goegraphiesCluster.mdm_id__c = GEO0060;
            insert goegraphiesCluster;
              
            MDO_Geography__c goegraphiesMCO1 = new MDO_Geography__c();
            goegraphiesMCO1.Name = 'ANZ';
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
			
            MDO_Geography__c mdoAFR = new MDO_Geography__c( ISO_3166_1_Code__c = 'AO', Name = 'Angola', mdm_id__c = 'AO', parent_L2__c = geoMCOList[0].id,  geography_type__c = COUNTRY, Status__c = STATUS_ACTIVE );
            
            MDO_Geography__c mdoLA = new MDO_Geography__c(ISO_3166_1_Code__c = 'CM',Name = 'Cameroon',mdm_id__c = 'CM',parent_L2__c = geoMCOList[0].id,geography_type__c = COUNTRY,Status__c = STATUS_ACTIVE);
            
            MDO_Geography__c mdoCongo = new MDO_Geography__c(ISO_3166_1_Code__c = 'CG',Name = 'Congo',mdm_id__c = 'CG',parent_L2__c = geoMCOList[0].id,geography_type__c = COUNTRY,Status__c = STATUS_ACTIVE);
            
           
           	MDO_Geography__c mdoNigeria = new MDO_Geography__c(ISO_3166_1_Code__c = 'NG',Name = 'Nigeria',mdm_id__c = 'NG',parent_L2__c = geoMCOList[1].id,geography_type__c = COUNTRY,Status__c = STATUS_ACTIVE);
           	 
			insert new List<MDO_Geography__c>{mdoAFR,mdoLA,mdoNigeria,mdoCongo};
            
            // Loading Master Data from static resource    
            IPM_TestFactory_Helper.loadMasterData();
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader});              
        } 
        
        System.RunAs(localProjectLeader){
        
        	Map<String,List<Object>> projectFieldToValueMap = New Map<String,List<Object>>();

            List<String> lstGKMs = new List<String> {'GKM8'};
            List<IPM_Project__c> projectList = IPM_TestFactory_Helper.genericProjectSetUp(1,localProjectLeader, lstGKMs, projectFieldToValueMap);
            insert projectList;
            
            List<IPM_Country__c> countryList = IPM_TestFactory_Helper.createIPMCountryList(false,1);
            countryList[0].IPM_Local_Project__c = projectList[0].Id;
            insert countryList[0];
			
			
         }
     }
     
     public static testmethod void createGKM8Project(){
     	
        
        // Get the list of user's for project leaders.
        List<User> userList = [Select Id,Name,lastName from User where LastName in('LOCAL_PL')];
        
        // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
        IPM_TestFactory_Helper.shareMasterProject(userList); 
     
       
        List<IPM_Project__c> lstProjects= [select id, name, (select id, name FROM IPM_Questionnaires__r), 
                                            (select id, name FROM IPM_Milestones__r),
                                            (Select Id from Project_Documents__r)
                                            FROM IPM_Project__c Where Name != 'IPM_MasterProject'];
        
        System.assert(lstProjects.size()>0, ASSERT_ERROR_STR );
            
        for(IPM_Project__c pr: lstProjects){
            System.assert(!pr.IPM_Questionnaires__r.isEmpty(),'Questionnaires not Created Properly.' );
            System.assert(!pr.IPM_Milestones__r.isEmpty(),'Milestones not Created Properly.');
            System.assert(!pr.Project_Documents__r.isEmpty(),'ProjectDocuments not Created Properly.');
        }
        List<String> projectIdList = new List<String>();
        for(IPM_Project__c project : lstProjects){
            projectIdList.add(project.Id);    
        } 
        Test.startTest();
         
	        Test.setCurrentPage(pageRef); 
	        ApexPages.currentPage().getParameters().put('id',lstProjects[0].id);
	        IPM_RolloutPlansAddLocalController objRollAddLoCont = new IPM_RolloutPlansAddLocalController();
	        
	        objRollAddLoCont.globalCountries = 'AO';
	        objRollAddLoCont.globalUnselectedCountries = 'CP'; 
	        objRollAddLoCont.generateRollouts();
	        
	        objRollAddLoCont.searchCountry = 'ANZ'; 
	        objRollAddLoCont.searchRolloutCountry();
	        
	        objRollAddLoCont.globalCountries = ''; 
	        objRollAddLoCont.generateRollouts();
	        
	        objRollAddLoCont.searchCountry = 'Africa'; 
	        objRollAddLoCont.searchRolloutCountry();  
	        
	        objRollAddLoCont.cancel();
        
        Test.stopTest();   
         
    } 
   
}