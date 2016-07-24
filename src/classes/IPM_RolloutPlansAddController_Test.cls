/**
@Author Cognizant 
@Name IPM_RolloutPlansAddController_Test
@CreateDate 15/01/2016
@Description    This class is used for testing functionality of adding new rollouts to the project. (It is used for displaying MDO Specific Geographies and Countries. 
                User selects MCO and Countries from the Page and are send for rollout Processing.
                Handles building of core Rollout Data, creating relationships between rollouts, countries and regional Rollouts.
                Adds and removes Rollouts/Countries based on user selection.
                Switching of rolloutType is tested in this class.)
@Version 1.0
@reference IPM_RolloutPlansAdd VF page, IPM_RolloutPlansRegional VF page
*/
@isTest
private class IPM_RolloutPlansAddController_Test
{
    private static list<IPM_Project_Rollout__c> regionalRolloutList;
    private static list<IPM_Project_Rollout__c> localRolloutList;
    private static  String projectId;
   
    private static MDO_Geography__c goegraphiesCluster;
    private static MDO_Geography__c goegraphiesMCO;
    
    private static list<IPM_Project__c> projectList;
    
    private static IPM_Country__c tempCountry;
    private static list<IPM_Company_Card__c> companyCardList;
  
    private static integer dmlLimit;
    private static MDO_Geography__c mdoAFR;
    private static MDO_Geography__c mdoLA;
    private static IPM_MCO_Short_Names__c shortName;
    private static IPM_Market_Cluster_Short_Names__c mcoShortName;
    private static List<IPM_Project__c> regionalProjectsFR;
    private static List<IPM_Project__c> regionalProjects;
    private static ApexPages.Message[] pageMessages;
    private static PageReference pageRef= Page.ipm_rolloutplansadd;
    private static PageReference pageRefRegional= Page.ipm_rolloutplansregional;
    private static PageReference expectedPageRef ;
	private static PageReference actualPageRef;   
    
    private static final string GLOBAL_PL = 'GLOBAL_PL';
    private static final string REGIONAL_PL = 'REGIONAL_PL';
    private static final string LOCAL_PL = 'LOCAL_PL';
    private static final string AFRICAN = 'African';
    private static final string GEO0060 = 'GEO0060';
    private static final string AFRICA_EMERGING_MARKETS = 'Africa Emerging Markets'; 
    private static final string LV4_GEO0085 = 'LV4_GEO0085';
    private static final string AFRICA = 'Africa';
    private static final string ANGOLA = 'Angola';
    private static final string Congo = 'Congo';
    private static final string CHAD = 'Chad';
    private static final string ASIA = 'ASIA';
    private static final string FRANCE = 'France';
    private static final string EUROPE = 'EUROPE';
    private static final string SOUTH_AFRICA = 'South Africa';
    private static final string OTHER_SOUTH_ASIA = 'Other South Asia'; 
    private static final string STATUS_ACTIVE = 'Active';
    private static final string With_MCO = 'With MCO';
    private static final string GLOBAL_COUNTRIES='AG,BR';
    private static final string REGIONAL_MCO='Africa Emerging Markets,Other South Asia';
    private static final string REGIONAL_COUNTRY='Africa,Angola';
    private static final string REGIONAL_NOROLL='Congo,Chad';
    private static final string GLOBAL_UNSELECTED_COUNTRIES = 'KW,NB';
    private static final string REGIONAL_UNSELECTED_MCO = 'IN,CL,CP,JS'; //unselected mco country code
    private static final string REGIONAL_UNSELECTED_NOROLL = 'CB,KB';
    private static final string ERROR_MESSAGE='plz enter tld'; 
    private static final string AG_BR_AO = 'AG,BR,AO';
    private static final string KW = 'KW';
    private static final string NB = 'NB';
    private static final string CB = 'CB';
    private static final string BR = 'BR';
    private static final string FR = 'FR';
    private static final string SA = 'SA';
    private static final string AF = 'AF';
    private static final string TestComments1 = 'TestComments1';   
    private static final string TestComments2 = 'TestComments2';
    private static final string TestComments3 = 'TestComments3';
    private static final string ID = 'id';
    private static final string TASK_NOT_CREATED='tasks not created';
    private static final string TASK_COMPLEXITY_DOESNOT_MATCH='task complexity does not match regional project complexity';
    private static final string MILESTONES_NOT_CREATED='milestones not crerated';
    private static final string FINANCIAL_NOT_CREATED='financial not created';
    private static final string PHASE_NOT_FEASIBILITY='project phase is not feasibility'; 
    private static final string FAILED_ASSERT_MSG = 'Url is not as expected and failed processsing .' ;
    private static final String WRAPPER_NOT_CREATED = 'Market Cluster/MCO wrapper not created successfully.';
    
    /******************************************************************************************************************************************
    * @description: Used for Creating IPM Project data for Rollout flow test  .This is used in test methods to create data specifc to use cases.
    * Constructor logic for the controller is tested for  projects (Searching rollouts, Adding rollouts, Processing rollouts). 
    * Used for testing  regional and local rollouts creation, change of project phase and subsequent creation of regional Projects                            
    ********************************************************************************************************************************************/
    private static  void GlobalProjRolloutAdd(Boolean isActive ,Boolean isRegionalProj ,Boolean isFeasibilityProject) 
    {
       IPM_RolloutPlansAddController irp = new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp2 ;

       
	   if(!isRegionalProj)  
        { 
          // creating multiple instances of   IPM_RolloutPlansAddController
          irp2= new IPM_RolloutPlansAddController();
        } 
       
       // setting values of GeographyWrapper parameters
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
       Set<String> projectNameSet = new Set<String>{TestComments1,TestComments2,TestComments3};
       List<Id> globalProjectIdList = new List<Id>();
       Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
       User globalProjectLeader = null;
       User regionalProjectLeader = null;  
        
       // getting project leaders  for global ,local and regional
       List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
        
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
        Test.startTest(); 
        System.RunAs(globalProjectLeader)
        {
          
            if(isRegionalProj)
            {
            	// creating projects as a global project leader
            	projectList=IPM_TestFactory_Helper.projectSetUpRegional(2,regionalProjectLeader);
            	if(isFeasibilityProject)
            	{
            	   for(IPM_Project__c proj : projectList )
            	    {
                        proj.IPM_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
                    } 
            	}
            	
            	insert  projectList;
            	projectMap = new Map<Id,IPM_Project__c>(projectList);  
            }
            else 
            {
			    projectMap =  new Map<Id,IPM_Project__c>([Select Id,IPM_Phase__c,IPMProject_Span__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet]);
                projectList=projectMap.values();
            
            }
            
            regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{regionalProjectLeader,regionalProjectLeader,regionalProjectLeader});
            insert regionalRolloutList;
            
            dmlLimit = Limits.getDMLStatements();

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
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>());  
            insert localRolloutList; 
   
            dmlLimit = Limits.getDMLStatements();
          
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            List<MDO_Geography__c> mdoCountryList = [select id,ISO_3166_1_Code__c,Name,parent_L2__c,geography_type__c,mdm_id__c,Status__c from MDO_Geography__c where Name in (:AFRICA,:ANGOLA) ];
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            { 
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO); 
                  countryList.add(tempCountry);				  
               }
            
			}
         
           insert countryList;
                     
           countryList = [SELECT Id,Name,MDO_Geography__c,Country_Code__c,Country_Name__c,Local_Rollout__c,Market_Cluster_Code__c,
                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c
                FROM IPM_Country__c WHERE id IN : countryList];

            dmlLimit = Limits.getDMLStatements();
        
           //******************************** Initiate Phase Change and Regional Project Creation  ****************************************
           
             // Set GateKeeping Model as RCLT and start with Regional Project Creation.
            for(IPM_Project__c project : projectList)
            {
                project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_RCLT;
                project.Market_Cluster__c = GEO0060; 
                project.IPM_Target_Launch_Dates__c = system.today();
            }  

            update projectList;

            dmlLimit = Limits.getDMLStatements();

            for(IPM_Project__c project : projectList)
            {
                globalProjectIdList.add(project.Id);    
            }
            
            // Initiate Phase Change would result in Rollout Project Creation.
            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChange(globalProjectIdList,globalProjectLeader); 
            update projectListPhaseChange;
           
            Test.StopTest();

        }
        
        regionalProjects = new List<IPM_Project__c>();
        
        if(!isRegionalProj)
        {
          System.RunAs(globalProjectLeader) 
           {
             Map<Id,List<IPM_Project__c>> globalToRegionalMap = IPM_TestFactory_Helper.getRegionalProjects(globalProjectIdList);

             for(Id gbProjectId : globalToRegionalMap.keySet())
             {
               regionalProjects.addAll(globalToRegionalMap.get(gbProjectId)); 
             }
            
             List<IPM_Project__c> DBRegionalProjects = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];  
            
             dmlLimit = Limits.getDMLStatements();
            
               
             for(IPM_Project__c regionalProject : DBRegionalProjects) 
             {
               Id parentGlobalProjectId = regionalProject.IPM_Parent_Project__c;
                
               IPM_Project__c parentGlobalProject = projectMap.get(parentGlobalProjectId);
                
               // Only Contract document Available at Regional Level.
               System.assertEquals(regionalProject.Project_Documents__r.size(),1,'Project documents not generated');
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size(),'Regional project milestones are not same as parent project milestones');
              }
            
            }
        
		}
   
        dmlLimit = Limits.getDMLStatements();

        //******************************** Regional Project Leader View for Regional Projects  ****************************************
        System.RunAs(regionalProjectLeader)
        {
            // Update phase for Local Rollouts. 
            regionalProjectsFR = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id from Regional_Project_Rollout__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];
            
            for(IPM_Project__c regionalProject : regionalProjectsFR)
            {
                // Validate there is atleast one Task associated with Regional Project
                System.assert(!regionalProject.Tasks__r.isEmpty(),TASK_NOT_CREATED);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,TASK_COMPLEXITY_DOESNOT_MATCH);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(!regionalProject.IPM_Milestones__r.isEmpty(), MILESTONES_NOT_CREATED);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,FINANCIAL_NOT_CREATED); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,IPM_ConstantUtils.FEASIBILITY_PHASE,PHASE_NOT_FEASIBILITY); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        ////Test.stopTest();
        system.RunAs(globalProjectLeader)
         {
           
           Test.setCurrentPageReference(pageRef);
		   ApexPages.currentPage().getParameters().put(ID,projectList[0].Id); 
           projectId = ApexPages.currentPage().getParameters().get(ID);
          
           // setting controller parameters
           irp.project=projectList[0];
           irp.globalCountries=GLOBAL_COUNTRIES;
           irp.regionalMco=REGIONAL_MCO;
           irp.regionalCountry=REGIONAL_COUNTRY;
           irp.regionalNoRoll=REGIONAL_NOROLL;
           irp.globalUnselectedCountries = GLOBAL_UNSELECTED_COUNTRIES;
           irp.regionalUnselectedMco = REGIONAL_UNSELECTED_MCO; //unselected mco country code
           irp.regionalUnselectedNoRoll = REGIONAL_UNSELECTED_NOROLL;
           irp.selectedCountry = AFRICA;
           irp.errorMessage=ERROR_MESSAGE;
          
           irp.setCountryNoRolls = new Set<String>{CONGO,CHAD}; //it is made from  regionalNoRoll
           irp.setCountryCodesGlobal= new Set<String>{AG_BR_AO};  // country iso code is added in the controller
           irp.setCountryCodesGlobalUnselected= new Set<String>{KW,NB}; //globalUnselectedCountries is put into this
          
         
           irp.setCountryCodesMCOsUnselected = new Set<String>{ASIA,EUROPE}; //regionalUnselectedMco is put into this 
           irp.setCountryCodesMCOs =  new Set<string>{AFRICA_EMERGING_MARKETS,OTHER_SOUTH_ASIA}; // regionalMco is put into this
           irp.setCountryCodesUnselected = new Set<String>{KW,NB}; // regionalUselectedCountry is put into this
           irp.setCountryNoRollsUnselected = new Set<String>{CB}; //regionalUnselectedNoRoll is put into this
           irp.setCountryCodes = new Set<String>{AF}; //regionalCountry put into this 
         
         
           geoWrp.code=LV4_GEO0085;
           geoWrp.name=AFRICA_EMERGING_MARKETS;
           geoWrp.parentCode=GEO0060;
           geoWrp.rolloutStatus=With_MCO;
           geoWrp.key=true;
           geoWrp.selected=true;
           geoWrp.clusterDisabled=true;
           geoWrp.mcoDisabled=true;
           geoWrp.countryDisabled =true;
           geoWrp.noRolloutDisabled=true;
          
           // creating MDO Geography records
           MDO_Geography__c geo1 = new MDO_Geography__c(name = FRANCE,ISO_3166_1_code__c = BR);
           insert geo1;
          
           MDO_Geography__c geo2 = new MDO_Geography__c(name = FRANCE,ISO_3166_1_code__c = FR);
           insert geo2;
          
           MDO_Geography__c geo3 = new MDO_Geography__c(name = SOUTH_AFRICA,ISO_3166_1_code__c = SA);
           insert geo3;  
          
           List<IPM_Country__c> countryList = new List<IPM_Country__c>();
                for(integer i=0; i<3 ; i++) {
                    IPM_Country__c tmpCountry = new  IPM_Country__c(
                    IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    IS_EI_Country__c = true,Local_Rollout__c = regionalRolloutList[0].id, Local_Rollout_Charter__c = regionalRolloutList[0].id,isActive__c = isActive  );    //false at 179
                  if(i==0){
                    tmpCountry.MDO_Geography__c = geo1.Id;
                    
                  }
                  else if(i==1){
                    
                    tmpCountry.MDO_Geography__c = geo2.Id;
                  }
                  if(i==2){
                      tmpCountry.MDO_Geography__c = geo3.Id;
                  }
                    countryList.add(tmpCountry);
            }
          
          insert countryList;
          List<IPM_Project_Rollout__c> rollouLst = [Select id,IPM_Rollout_Project__c, (Select id,Country_Code__c,Project_Country__c,isActive__c from IPM_Countries_Local__r ) from IPM_Project_Rollout__c Where id =: regionalRolloutList[0].id];
          
          // setting controller parameters
          irp.searchCountry=AFRICA;
          irp.searchRolloutCountry();
          irp.lstClusterWrappers.add(geoWrp);
         
          irp.changeMCO();
          irp.generateRollouts();
          irp.changeCluster();
          irp.setCountryCodesMCOs =  new Set<string>{BR}; // regionalMco is put into this
          irp.processRegionalMCORollouts();
          Map<String,Set<String>>mcoMap=new Map<String,Set<String>>();
          mcoMap.put(rollouLst[0].IPM_Rollout_Project__c,irp.setCountryCodesMCOs);
          
          irp.removeReferences(mcoMap,rollouLst[0]);
          irp.setCountryCodesMCOs =  new Set<string>{AFRICA_EMERGING_MARKETS,OTHER_SOUTH_ASIA}; // regionalMco is put into this     
          irp.generateRollouts();
          
          irp.setCountryCodes = new Set<String>{BR}; //regionalCountry put into this 
          irp.processRegionalCountryRollouts();
          irp.setCountryCodes = new Set<String>{AF}; //regionalCountry put into this 
          
          dmlLimit = Limits.getDMLStatements();

          if(!isRegionalProj)
          {
			   // setting controller parameters
			  irp2.project=projectList[0];
			  irp2.globalCountries=GLOBAL_COUNTRIES;
			  irp2.regionalMco=REGIONAL_MCO;
			  irp2.regionalCountry=REGIONAL_COUNTRY;
			  irp2.regionalNoRoll=REGIONAL_NOROLL;
			  irp2.globalUnselectedCountries = GLOBAL_UNSELECTED_COUNTRIES;
			  irp2.regionalUnselectedMco = REGIONAL_UNSELECTED_MCO; //unselected mco country code
			  irp2.regionalUnselectedNoRoll = REGIONAL_UNSELECTED_NOROLL;
			  irp2.selectedCountry = AFRICA;
			  irp2.errorMessage=ERROR_MESSAGE;

			  irp2.setCountryNoRolls = new Set<String>{CONGO,CHAD}; //it is made from  regionalNoRoll
			  irp2.setCountryCodesGlobal= new Set<String>{AG_BR_AO};  // country iso code is added in the controller
			  irp2.setCountryCodesGlobalUnselected= new Set<String>{KW,NB}; //globalUnselectedCountries is put into this

			  irp2.setCountryCodesMCOsUnselected = new Set<String>{ASIA,EUROPE}; //regionalUnselectedMco is put into this 
			  irp2.setCountryCodesMCOs =  new Set<string>{AFRICA_EMERGING_MARKETS,OTHER_SOUTH_ASIA}; // regionalMco is put into this
			  irp2.setCountryCodesUnselected = new Set<String>{KW,NB}; // regionalUselectedCountry is put into this
			  irp2.setCountryNoRollsUnselected = new Set<String>{CB}; //regionalUnselectedNoRoll is put into this
			  irp2.setCountryCodes = new Set<String>{AF}; //regionalCountry put into this 
			 
			  geoWrp.code=LV4_GEO0085;
			  geoWrp.name=AFRICA_EMERGING_MARKETS;
			  geoWrp.parentCode=GEO0060;
			  geoWrp.rolloutStatus=With_MCO;
			  geoWrp.key=true;
			  geoWrp.selected=true;
			  geoWrp.clusterDisabled=true;
			  geoWrp.mcoDisabled=true;
			  geoWrp.countryDisabled =true;
			  geoWrp.noRolloutDisabled=true;
			  
			  irp2.searchCountry=null;
			  irp2.searchRolloutCountry();
			  
			  system.assert(irp2.updateRollouts, WRAPPER_NOT_CREATED);
			  system.assert(irp2.mapMCOWrappers.get(LV4_GEO0085).rolloutPresentAtMCO , WRAPPER_NOT_CREATED);
			  system.assert(irp2.mapClusterWrappers.get(GEO0060).rolloutPresentAtCluster, WRAPPER_NOT_CREATED);
			  
			  
			  irp2.lstClusterWrappers.add(geoWrp);
			}
			  
			  if(!regionalProjects.isEmpty()){
				Test.setCurrentPageReference(pageRefRegional);
                ApexPages.currentPage().getParameters().put(ID,regionalProjects[0].Id);
				
			  }
			  
			  dmlLimit = Limits.getDMLStatements();
			  
			  
			  PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
			  PageReference rolloutPlansActual = irp.redirectPage();
			  irp.cancel();
			  
			  // checking if  page redirection  is correct 
			  System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()),'Url is not as expected');
			  
			  expectedPageRef = rolloutPlansExpected;
			  actualPageRef= rolloutPlansActual ;
	
			  Test.setCurrentPageReference(pageRef);
			  ApexPages.currentPage().getParameters().put(ID,null);
			  irp.cancel();
			  irp.redirectPage();
			   
			  ApexPages.currentPage().getParameters().put(ID,null);
			  Test.setCurrentPageReference(pageRef);
			  irp.cancel();
			  irp.redirectPage();    
				
		  }
		   
      } 
 
 
     /*************************************************************************************
     * @Description :This is to set up test  data which can be  queried in test methods. 
     * @name :  projectSetUp
     ***************************************************************************************/
     @testSetup static void projectSetUp() 
     {   
     	 Test.StartTest(); 
         // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);

         User globalProjectLeader = null;
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = GLOBAL_PL;
            regionalProjectLeader.lastname = REGIONAL_PL;
            localProjectLeader.lastname = LOCAL_PL; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
            
            List<User> assertUsrList = [select Id from User where lastname =: GLOBAL_PL];
            system.assertEquals(1,assertUsrList.size(),'Global User not created');
         
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            goegraphiesCluster = new MDO_Geography__c();
            goegraphiesCluster.Name = AFRICAN;
            goegraphiesCluster.geography_type__c = 'Unilever Cluster';
            goegraphiesCluster.Status__c = STATUS_ACTIVE;
            goegraphiesCluster.mdm_id__c=GEO0060;
            insert goegraphiesCluster;
              
            goegraphiesMCO = new MDO_Geography__c();
            goegraphiesMCO.Name = AFRICA_EMERGING_MARKETS;
            goegraphiesMCO.parent_L2__c =goegraphiesCluster.id;
            goegraphiesMCO.geography_type__c = 'Country Group';
            goegraphiesMCO.mdm_id__c=LV4_GEO0085;
            goegraphiesMCO.Status__c = STATUS_ACTIVE;
            insert goegraphiesMCO;
            
            mdoAFR = new MDO_Geography__c(ISO_3166_1_Code__c = 'AG',Name = AFRICA,mdm_id__c=goegraphiesMCO.Id,parent_L2__c =goegraphiesMCO.id, geography_type__c = 'Country',Status__c = STATUS_ACTIVE);
            
            mdoLA = new MDO_Geography__c(ISO_3166_1_Code__c = BR,Name = ANGOLA,mdm_id__c=goegraphiesMCO.Id,parent_L2__c =goegraphiesMCO.id, geography_type__c = 'Country',Status__c = STATUS_ACTIVE);
			insert new List<MDO_Geography__c>{mdoAFR,mdoLA};
            
            shortName = new IPM_MCO_Short_Names__c();
            shortName.Name=LV4_GEO0085;
            shortName.Country_Group__c = AFRICA_EMERGING_MARKETS;
            shortName.Short_Name__c = 'UMCA';
            insert  shortName;
 
            mcoShortName = new IPM_Market_Cluster_Short_Names__c();
            mcoShortName.Name= GEO0060;
            mcoShortName.Unilever_Cluster__c = AFRICAN;
            mcoShortName.Short_Name__c =AF;
            insert mcoShortName; 
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_TestFactory_Helper.getProjectMasterData();
 
			IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader}); 
        
		}   
        
        System.runAs(globalProjectLeader)
        {   
            projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList;
            
            set<Id> projId = new set<Id>();
            for(IPM_Project__c proj : projectList)
            {
                projId.add(proj.id);   
            }
            List<IPM_Project__c> projectAssertList = [Select Id,Name from IPM_Project__c where id in : projId];
            system.assertEquals(3,projectAssertList.size(),'count of Project inserted is not 3'); 
        }
        
        Test.StopTest();  
    
	}
  



    /*************************************************************************************
    * @Description : Used for testing  regional and local rollouts creation,and removal of rollouts
    * Constructor logic for the controller is tested for regional projects (Searching rollouts, Adding rollouts, Processing rollouts, removing rollouts)
    * @name :  testRegionalProjRolloutAdd2
    ***************************************************************************************/
    private static testmethod void testRegionalProjRolloutAdd2()
    {
      GlobalProjRolloutAdd(true,true,false); 
      System.assert(actualPageRef.getURL().contains(expectedPageRef.getURL()),FAILED_ASSERT_MSG);
    }
    
    
    /*************************************************************************************
    * @Description : Used for testing  regional and local rollouts creation,and removal of rollouts
    * Constructor logic for the controller is tested for  regional projects (Searching rollouts, Adding rollouts, Processing rollouts, removing rollouts)
    * @name :  testRegionalProjRolloutAdd3
    ***************************************************************************************/
    private static testmethod void testRegionalProjRolloutAdd3()
    {
      GlobalProjRolloutAdd(true,true,true);
      System.assert(actualPageRef.getURL().contains(expectedPageRef.getURL()),FAILED_ASSERT_MSG);
    }
}