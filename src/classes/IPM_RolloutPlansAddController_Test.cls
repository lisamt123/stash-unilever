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
public class IPM_RolloutPlansAddController_Test{
    public static list<IPM_Project_Rollout__c> regionalRolloutList;
    public static list<IPM_Project_Rollout__c> localRolloutList;
    public static  String projectId;
   
    public static MDO_Geography__c goegraphiesCluster;
    public static MDO_Geography__c goegraphiesMCO;
    
    public static list<IPM_Project__c> projectList;
    
    public static boolean geoExternal;
    public static IPM_Country__c tempCountry;
    public static list<IPM_Company_Card__c> companyCardList;
  
    public static integer dmlLimit;
    public static MDO_Geography__c mdoAFR;
    public static MDO_Geography__c mdoLA;
    public static IPM_MCO_Short_Names__c shortName;
    public static IPM_Market_Cluster_Short_Names__c mcoShortName;
    public static List<IPM_Project__c> regionalProjectsFR;
    public static List<IPM_Project__c> regionalProjects;
    public static  ApexPages.Message[] pageMessages;
    
    //Literals
    public static string GLOBAL_PL = 'GLOBAL_PL';
    public static string REGIONAL_PL = 'REGIONAL_PL';
    public static string LOCAL_PL = 'LOCAL_PL';
    public static string AFRICAN = 'African';
    public static string GEO0060 = 'GEO0060';
    public static string AFRICA_EMERGING_MARKETS = 'Africa Emerging Markets'; 
    public static string LV4_GEO0085 = 'LV4_GEO0085';
    public static string AFRICA = 'Africa';
    public static string ANGOLA = 'Angola';
    public static string Congo = 'Congo';
    public static string CHAD = 'Chad';
    public static string ASIA = 'ASIA';
    public static string FRANCE = 'France';
    public static string EUROPE = 'EUROPE';
    public static string SOUTH_AFRICA = 'South Africa';
    public static string OTHER_SOUTH_ASIA = 'Other South Asia'; 
    public static string STATUS_ACTIVE = 'Active';
    public static string With_MCO = 'With MCO';
    public static string IPMROLLOUTPLANSADD_PAGE_URL = '/apex/ipm_rolloutplansadd?id='; 
    public static string IPMROLLOUTPLANSREGIONAL_PAGE_URL = '/apex/ipm_rolloutplansregional?id=';
    public static string GLOBAL_COUNTRIES='AG,BR';
    public static string REGIONAL_MCO='Africa Emerging Markets,Other South Asia';
    public static string REGIONAL_COUNTRY='Africa,Angola';
    public static string REGIONAL_NOROLL='Congo,Chad';
    public static string GLOBAL_UNSELECTED_COUNTRIES = 'KW,NB';
    public static string REGIONAL_UNSELECTED_MCO = 'IN,CL,CP,JS'; //unselected mco country code
    public static string REGIONAL_UNSELECTED_NOROLL = 'CB,KB';
    public static string ERROR_MESSAGE='plz enter tld'; 
    public static string AG_BR_AO = 'AG,BR,AO';
    public static string KW = 'KW';
    public static string NB = 'NB';
    public static string CB = 'CB';
    public static string BR = 'BR';
    public static string FR = 'FR';
    public static string SA = 'SA';
    public static string AF = 'AF';
    public static string LA = 'LA';
    public static string TestComments1 = 'TestComments1';
    public static string TestComments2 = 'TestComments2';
    public static string TestComments3 = 'TestComments3';
    public static string ID = 'id';
    public static string TEST_STR = 'test';
    private static string TASK_NOT_CREATED='tasks not created';
    private static string TASK_COMPLEXITY_DOESNOT_MATCH='task complexity does not match regional project complexity';
    private static string MILESTONES_NOT_CREATED='milestones not crerated';
    private static string FINANCIAL_NOT_CREATED='financial not created';
    private static string PHASE_NOT_FEASIBILITY='project phase is not feasibility';
    
    /**************************************************************
    * @description: Used for Creating IPM Project data for Rollout flow test          
    */

     @testSetup static void projectSetUp() 
     {
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
         
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            goegraphiesCluster = new MDO_Geography__c();
            goegraphiesCluster.Name = AFRICAN;
            goegraphiesCluster.parent_L2__c =goegraphiesCluster.id;
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
            insert mdoAFR;
            
            mdoLA = new MDO_Geography__c(ISO_3166_1_Code__c = BR,Name = ANGOLA,mdm_id__c=goegraphiesMCO.Id,parent_L2__c =goegraphiesMCO.id, geography_type__c = 'Country',Status__c = STATUS_ACTIVE);
            insert mdoLA;
            
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
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader}); 
        }   
        
        System.runAs(globalProjectLeader)
        {   
            projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            insert projectList; 
      }
     }
  
    /*************************************************************************************
  * @Description : Used for testing  regional and local rollouts creation, change of project phase and subsequent creation of regional Projects
  * Constructor logic for the controller is tested for a global original project (Searching rollouts, Adding rollouts, Processing rollouts)
  * @name :  testGlobalProjRolloutAdd
  ***************************************************************************************/
    public static testmethod void testGlobalProjRolloutAdd()
    {
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp2= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp3= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp4= new IPM_RolloutPlansAddController();
       
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
        Set<String> projectNameSet = new Set<String>{TestComments1,TestComments2,TestComments3};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
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
        
        System.RunAs(globalProjectLeader)
        {
          Test.startTest();
            projectList = [Select Id,IPM_Phase__c,IPMProject_Span__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
           
            for(IPM_Project__c proj : projectList)
            {
                projectMap.put(proj.Id,proj);
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
                if(localRollout.IPM_Rollout_Project__c.contains(AF))
                {
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains(LA))
                {
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);
                 }
               }
               countryList.add(tempCountry);
            }
         
           insert countryList;
                     
           countryList = [SELECT Id,Name,MDO_Geography__c,Country_Code__c,Country_Name__c,Local_Rollout__c,Market_Cluster_Code__c,
                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c
                FROM IPM_Country__c WHERE id IN : countryList];
            
         
            update countryList;
            
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
          
            dmlLimit = Limits.getDMLStatements();
            
            
            
        }
        
        regionalProjects = new List<IPM_Project__c>();
        
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
        
        dmlLimit = Limits.getDMLStatements();
        
        
        //******************************** Regional Project Leader View for Regional Projects  ****************************************
        System.RunAs(regionalProjectLeader)
        {
            // Update phase for Local Rollouts. 
            regionalProjectsFR = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id from Regional_Project_Rollout__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];
            
            for(IPM_Project__c regionalProject : regionalProjectsFR)
            {
                // Validate there is atleast one Task associated with Regional Project
                System.assert(regionalProject.Tasks__r.size()>0,TASK_NOT_CREATED);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,TASK_COMPLEXITY_DOESNOT_MATCH);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0, MILESTONES_NOT_CREATED);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,FINANCIAL_NOT_CREATED); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,IPM_ConstantUtils.FEASIBILITY_PHASE,PHASE_NOT_FEASIBILITY); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put(ID,projectList[0].Id);
          PageReference pRef = new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get(ID);
          
         
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
                    IS_EI_Country__c = true,Local_Rollout__c = regionalRolloutList[0].id, Local_Rollout_Charter__c = regionalRolloutList[0].id );    
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
          
          //********************************************************************************  

          
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
          irp2.lstClusterWrappers.add(geoWrp);

          //******************************************************************
          
          //********************************All the wrappers are populated************************************************
          irp3.project=projectList[0];
          irp3.globalCountries=GLOBAL_COUNTRIES;
          irp3.regionalMco=REGIONAL_MCO;
          irp3.regionalCountry=REGIONAL_COUNTRY;
          irp3.regionalNoRoll=REGIONAL_NOROLL;
          irp3.globalUnselectedCountries = GLOBAL_UNSELECTED_COUNTRIES;
          irp3.regionalUnselectedMco = REGIONAL_UNSELECTED_MCO; //unselected mco country code
          irp3.regionalUnselectedNoRoll = REGIONAL_UNSELECTED_NOROLL;
          irp3.selectedCountry = AFRICA;
          irp3.errorMessage=ERROR_MESSAGE;
          
          irp3.setCountryNoRolls = new Set<String>{CONGO,CHAD}; //it is made from  regionalNoRoll
          irp3.setCountryCodesGlobal= new Set<String>{AG_BR_AO};  // country iso code is added in the controller
          irp3.setCountryCodesGlobalUnselected= new Set<String>{KW,NB}; //globalUnselectedCountries is put into this
          
         
          irp3.setCountryCodesMCOsUnselected = new Set<String>{ASIA,EUROPE}; //regionalUnselectedMco is put into this 
          irp3.setCountryCodesMCOs =  new Set<string>{AFRICA_EMERGING_MARKETS,OTHER_SOUTH_ASIA}; // regionalMco is put into this
          irp3.setCountryCodesUnselected = new Set<String>{KW,NB}; // regionalUselectedCountry is put into this
          irp3.setCountryNoRollsUnselected = new Set<String>{CB}; //regionalUnselectedNoRoll is put into this
          irp3.setCountryCodes = new Set<String>{AF}; //regionalCountry put into this 
         
         
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
          
          IPM_RolloutPlansAddController.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
          
          List<IPM_RolloutPlansAddController.GeographyWrapper> clusterWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          clusterWrapLst.add(geoWrp3);            
          List<IPM_RolloutPlansAddController.GeographyWrapper> mcoWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          mcoWrapLst.add(geoWrp3);
          List<IPM_RolloutPlansAddController.GeographyWrapper> countryWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          countryWrapLst.add(geoWrp3);
          
          irp3.lstClusterWrappers = clusterWrapLst;
          irp3.lstMCOWrappers = mcoWrapLst;
          irp3.lstCountryWrappers = countryWrapLst;
          
          irp3.searchCountry=TEST_STR;

          irp3.searchRolloutCountry();

          
          //******************************************************************
          
          
          //***********************************lstCountryWrappers is not populated so that exception part is covered*********************************************
          irp4.project=projectList[0];
          irp4.globalCountries=GLOBAL_COUNTRIES;
          irp4.regionalMco=REGIONAL_MCO;
          irp4.regionalCountry=REGIONAL_COUNTRY;
          irp4.regionalNoRoll=REGIONAL_NOROLL;
          irp4.globalUnselectedCountries = GLOBAL_UNSELECTED_COUNTRIES;
          irp4.regionalUnselectedMco = REGIONAL_UNSELECTED_MCO; //unselected mco country code
          irp4.regionalUnselectedNoRoll = REGIONAL_UNSELECTED_NOROLL;
          irp4.selectedCountry = AFRICA;
          irp4.errorMessage=ERROR_MESSAGE;
          
          irp4.setCountryNoRolls = new Set<String>{CONGO,CHAD}; //it is made from  regionalNoRoll
          irp4.setCountryCodesGlobal= new Set<String>{AG_BR_AO};  // country iso code is added in the controller
          irp4.setCountryCodesGlobalUnselected= new Set<String>{KW,NB}; //globalUnselectedCountries is put into this
          
         
          irp4.setCountryCodesMCOsUnselected = new Set<String>{ASIA,EUROPE}; //regionalUnselectedMco is put into this 
          irp4.setCountryCodesMCOs =  new Set<string>{AFRICA_EMERGING_MARKETS,OTHER_SOUTH_ASIA}; // regionalMco is put into this
          irp4.setCountryCodesUnselected = new Set<String>{KW,NB}; // regionalUselectedCountry is put into this
          irp4.setCountryNoRollsUnselected = new Set<String>{CB}; //regionalUnselectedNoRoll is put into this
          irp4.setCountryCodes = new Set<String>{AF}; //regionalCountry put into this 
 
          
          //irp3.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
          IPM_RolloutPlansAddController.GeographyWrapper geoWrp4=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
          
          List<IPM_RolloutPlansAddController.GeographyWrapper> clusterWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          clusterWrapLst.add(geoWrp4);            
          List<IPM_RolloutPlansAddController.GeographyWrapper> mcoWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          mcoWrapLst.add(geoWrp4);

          
          irp4.lstClusterWrappers = clusterWrapLst4;
          irp4.lstMCOWrappers = mcoWrapLst4;
          
          //keeping lstCountryWrappers as null so that exception block is tested
          irp4.searchCountry=TEST_STR;
          try{
              irp4.searchRolloutCountry();
          }
          catch(Exception e){
              System.assert(e.getMessage() != null,'Null record referenced lstCountryWrappers');
          }
          
          //******************************************************************
          
          
          if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          
          dmlLimit = Limits.getDMLStatements();
          
          
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()),'Url is not as expected');
        
          ApexPages.currentPage().getParameters().put(ID,null);
          Test.setCurrentPageReference(new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+null));
          irp.cancel();
          irp.redirectPage();
           
          ApexPages.currentPage().getParameters().put(ID,null);
          PageReference pRefReg = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+null);
          Test.setCurrentPageReference(pRefReg);
          irp.cancel();
          irp.redirectPage();    
            
      }
       
      } 
 

   /*************************************************************************************
  * @Description : Used for testing  regional and local rollouts creation for regional project
  * Constructor logic for the controller is tested for a global original project (Searching rollouts, Adding rollouts, Processing rollouts)
  * Parameters are set to null
  * @name :  testRegionalProjRolloutAddNullValues
  ***************************************************************************************/
   public static testmethod void testRegionalProjRolloutAddNullValues()
   {  
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
      
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            if(lUser.lastName == REGIONAL_PL)
            {
                regionalProjectLeader = lUser;
            }
        }
        test.StartTest();
        List<IPM_Country__c> countryList= new List<IPM_Country__c>(); 
        regionalProjects= IPM_TestFactory_Helper.projectSetUpRegional(2,regionalProjectLeader); 
        insert regionalProjects;
        
        List<id> regionalProjId = new List<Id>();
        for(IPM_Project__c regionalProject : regionalProjects)
        {
          regionalProjId.add(regionalProject.id);
        }
       
        
      List<MDO_Geography__c> mdoCountryList = [select id,ISO_3166_1_Code__c,Name,parent_L2__c,geography_type__c,mdm_id__c,Status__c from MDO_Geography__c where Name in (:AFRICA,:ANGOLA) ];
      
      
             
         for(MDO_Geography__c geoList : mdoCountryList)
         {
            tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,IPM_Regional_Project__c=regionalProjects[0].id);    
            countryList.add(tempCountry);
      }
       
      insert countryList;
      
       countryList = [SELECT Id,Name,MDO_Geography__c,Country_Code__c,Country_Name__c,Local_Rollout__c,Market_Cluster_Code__c,
                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c
                FROM IPM_Country__c WHERE id IN : countryList];
            
         
        update countryList;
        
        System.RunAs(regionalProjectLeader)
        {
          PageReference pRefRegional = new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+regionalProjects[0].Id);
          Test.setCurrentPageReference(pRefRegional);
          
          irp.globalCountries='KK,WW';
          irp.regionalMco='WESR EURO,SOUTH AMERICA';
          irp.regionalCountry=REGIONAL_COUNTRY;
          irp.regionalNoRoll=REGIONAL_NOROLL;
          irp.globalUnselectedCountries = GLOBAL_UNSELECTED_COUNTRIES;
          irp.regionalUnselectedMco = REGIONAL_UNSELECTED_MCO; //unselected mco country code
          irp.regionalUnselectedNoRoll = REGIONAL_UNSELECTED_NOROLL;
          
          irp.errorMessage=ERROR_MESSAGE;
          irp.isEditable=true;
          irp.disableMCO = true; 
          irp.selectedCountry = 'Australia';
         
         
          irp.setCountryNoRolls = new Set<String>{CONGO,CHAD}; //it is made from  regionalNoRoll
          irp.setCountryCodesGlobal= new Set<String>{AG_BR_AO};  // country iso code is added in the controller
          irp.setCountryCodesGlobalUnselected= new Set<String>{KW,NB}; //globalUnselectedCountries is put into this
          
         
          irp.setCountryCodesMCOsUnselected = new Set<String>{ASIA,EUROPE}; //regionalUnselectedMco is put into this 
          irp.setCountryCodesMCOs =  new Set<string>{AFRICA_EMERGING_MARKETS,OTHER_SOUTH_ASIA}; // regionalMco is put into this
          irp.setCountryCodesUnselected = new Set<String>{KW,NB}; // regionalUselectedCountry is put into this
          irp.setCountryNoRollsUnselected = new Set<String>{CB}; //regionalUnselectedNoRoll is put into this
          irp.setCountryCodes = new Set<String>{'UV'}; //regionalCountry put into this 
         
         
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
          
          
          
          irp.changeMCO();
          irp.generateRollouts();
           
         
          dmlLimit = Limits.getDMLStatements();
          
          
          ApexPages.currentPage().getParameters().put(ID,null);
          PageReference pRef = new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+null);
          Test.setCurrentPageReference(pRef);
           irp.cancel();
           irp.redirectPage();
           irp.changeMCO();
           irp.project=regionalProjects[0];
           irp.project.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
           irp.project.IPM_phase__c = IPM_ConstantUtils.FEASIBILITY_PHASE;
           irp.generateRollouts();
           
           irp.setCountryCodesGlobal=null;
           irp.setCountryCodesGlobalUnselected=null;
           irp.setCountryCodesMCOs= null;
           irp.setCountryCodesMCOsUnselected =null;
           irp.setCountryCodes = null;
           irp.setCountryCodesUnselected =null;
           irp.setCountryNoRolls =null;
           irp.setCountryNoRollsUnselected =null;
           irp.processCountryCodeLists();
          PageReference pRefreg = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+null);
          Test.setCurrentPageReference(pRefreg);
           
           PageReference rolloutPlans = Page.IPM_RolloutPlans;
           rolloutPlans.getParameters().put(IPM_ConstantUtils.SF_ID, null); 
            rolloutPlans.getParameters().put(IPM_ConstantUtils.EDITMODE, IPM_ConstantUtils.EDITMODE_FALSE );               
            irp.cancel();
           irp.redirectPage();
           
           PageReference pRefconst = new PageReference(IPM_ConstantUtils.REDIRECT_URL_FOR_ROLLOUT_REDIRECT);
          Test.setCurrentPageReference(pRefconst);
           
           List<IPM_Project__c> regionaToLocalProject = IPM_TestFactory_Helper.initiateRegionalProjectPhaseChange(regionalProjId,regionalProjectLeader);
          update regionaToLocalProject;
          
          
          test.StopTest();
          pageMessages = ApexPages.getMessages();
          System.assertEquals(0, pageMessages.size(),'Error messages generated');
           
        }
        
        
        
    }
    
     /*************************************************************************************
  * @Description : Used for testing  regional and local rollouts creation, change of project phase and subsequent creation of regional Projects and removal of rollouts
  * Constructor logic for the controller is tested for a global original project (Searching rollouts, Adding rollouts, Processing rollouts, removing rollouts)
  * @name :  testGlobalProjRolloutAdd2
  ***************************************************************************************/
     public static testmethod void testGlobalProjRolloutAdd2()
     {
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp2= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp3= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp4= new IPM_RolloutPlansAddController();
       
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
        Set<String> projectNameSet = new Set<String>{TestComments1,TestComments2,TestComments3};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
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
        
        System.RunAs(globalProjectLeader)
        {
          Test.startTest();
            projectList = [Select Id,IPM_Phase__c,IPMProject_Span__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
           
            for(IPM_Project__c proj : projectList)
            {
                projectMap.put(proj.Id,proj);
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
                if(localRollout.IPM_Rollout_Project__c.contains(AF))
                {
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains(LA))
                {
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);
                 }
               }
               countryList.add(tempCountry);
            }
         
           insert countryList;
                     
           countryList = [SELECT Id,Name,MDO_Geography__c,Country_Code__c,Country_Name__c,Local_Rollout__c,Market_Cluster_Code__c,
                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c
                FROM IPM_Country__c WHERE id IN : countryList];
            
         
            update countryList;
            
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
          
            dmlLimit = Limits.getDMLStatements();
            
            
            
        }
        
        regionalProjects = new List<IPM_Project__c>();
        
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
               System.assertEquals(regionalProject.Project_Documents__r.size(),1,'Project documents not created');
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size(),'Regional project milestones are not same as parent project milestones');
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
                System.assert(regionalProject.Tasks__r.size()>0,TASK_NOT_CREATED);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,TASK_COMPLEXITY_DOESNOT_MATCH);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0,MILESTONES_NOT_CREATED);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,FINANCIAL_NOT_CREATED); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,IPM_ConstantUtils.FEASIBILITY_PHASE,PHASE_NOT_FEASIBILITY); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put(ID,projectList[0].Id);
          PageReference pRef = new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get(ID);
          
         
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
          
          //In this scenario all the countries are made inactive
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
                    IS_EI_Country__c = true,Local_Rollout__c = regionalRolloutList[0].id, Local_Rollout_Charter__c = regionalRolloutList[0].id, isActive__c = false );    
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
          
          //********************************************************************************  

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
          irp2.lstClusterWrappers.add(geoWrp);

          //******************************************************************
          
          //********************************************************************************
          irp3.project=projectList[0];
          irp3.globalCountries=GLOBAL_COUNTRIES;
          irp3.regionalMco=REGIONAL_MCO;
          irp3.regionalCountry=REGIONAL_COUNTRY;
          irp3.regionalNoRoll=REGIONAL_NOROLL;
          irp3.globalUnselectedCountries = GLOBAL_UNSELECTED_COUNTRIES;
          irp3.regionalUnselectedMco = REGIONAL_UNSELECTED_MCO; //unselected mco country code
          irp3.regionalUnselectedNoRoll = REGIONAL_UNSELECTED_NOROLL;
          irp3.selectedCountry = AFRICA;
          irp3.errorMessage=ERROR_MESSAGE;
          
          irp3.setCountryNoRolls = new Set<String>{CONGO,CHAD}; //it is made from  regionalNoRoll
          irp3.setCountryCodesGlobal= new Set<String>{AG_BR_AO};  // country iso code is added in the controller
          irp3.setCountryCodesGlobalUnselected= new Set<String>{KW,NB}; //globalUnselectedCountries is put into this
          
         
          irp3.setCountryCodesMCOsUnselected = new Set<String>{ASIA,EUROPE}; //regionalUnselectedMco is put into this 
          irp3.setCountryCodesMCOs =  new Set<string>{AFRICA_EMERGING_MARKETS,OTHER_SOUTH_ASIA}; // regionalMco is put into this
          irp3.setCountryCodesUnselected = new Set<String>{KW,NB}; // regionalUselectedCountry is put into this
          irp3.setCountryNoRollsUnselected = new Set<String>{CB}; //regionalUnselectedNoRoll is put into this
          irp3.setCountryCodes = new Set<String>{AF}; //regionalCountry put into this 
         
         
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
          
          IPM_RolloutPlansAddController.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
          
          List<IPM_RolloutPlansAddController.GeographyWrapper> clusterWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          clusterWrapLst.add(geoWrp3);            
          List<IPM_RolloutPlansAddController.GeographyWrapper> mcoWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          mcoWrapLst.add(geoWrp3);
          List<IPM_RolloutPlansAddController.GeographyWrapper> countryWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          countryWrapLst.add(geoWrp3);
          
          irp3.lstClusterWrappers = clusterWrapLst;
          irp3.lstMCOWrappers = mcoWrapLst;
          irp3.lstCountryWrappers = countryWrapLst;
          
          irp3.searchCountry=TEST_STR;

          irp3.searchRolloutCountry();

          
          //******************************************************************
          
          
          //********************************************************************************
          irp4.project=projectList[0];
          irp4.globalCountries=GLOBAL_COUNTRIES;
          irp4.regionalMco=REGIONAL_MCO;
          irp4.regionalCountry=REGIONAL_COUNTRY;
          irp4.regionalNoRoll=REGIONAL_NOROLL;
          irp4.globalUnselectedCountries = GLOBAL_UNSELECTED_COUNTRIES;
          irp4.regionalUnselectedMco = REGIONAL_UNSELECTED_MCO; //unselected mco country code
          irp4.regionalUnselectedNoRoll = REGIONAL_UNSELECTED_NOROLL;
          irp4.selectedCountry = AFRICA;
          irp4.errorMessage=ERROR_MESSAGE;
          
          irp4.setCountryNoRolls = new Set<String>{CONGO,CHAD}; //it is made from  regionalNoRoll
          irp4.setCountryCodesGlobal= new Set<String>{AG_BR_AO};  // country iso code is added in the controller
          irp4.setCountryCodesGlobalUnselected= new Set<String>{KW,NB}; //globalUnselectedCountries is put into this
          
         
          irp4.setCountryCodesMCOsUnselected = new Set<String>{ASIA,EUROPE}; //regionalUnselectedMco is put into this 
          irp4.setCountryCodesMCOs =  new Set<string>{AFRICA_EMERGING_MARKETS,OTHER_SOUTH_ASIA}; // regionalMco is put into this
          irp4.setCountryCodesUnselected = new Set<String>{KW,NB}; // regionalUselectedCountry is put into this
          irp4.setCountryNoRollsUnselected = new Set<String>{CB}; //regionalUnselectedNoRoll is put into this
          irp4.setCountryCodes = new Set<String>{AF}; //regionalCountry put into this 
 
          IPM_RolloutPlansAddController.GeographyWrapper geoWrp4=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
          
          List<IPM_RolloutPlansAddController.GeographyWrapper> clusterWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          clusterWrapLst.add(geoWrp4);            
          List<IPM_RolloutPlansAddController.GeographyWrapper> mcoWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          mcoWrapLst.add(geoWrp4);
          List<IPM_RolloutPlansAddController.GeographyWrapper> countryWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          countryWrapLst4.add(geoWrp4);
          
          irp4.lstClusterWrappers = clusterWrapLst4;
          irp4.lstMCOWrappers = mcoWrapLst4;
          irp4.lstCountryWrappers = countryWrapLst4;
          
          irp4.searchCountry=TEST_STR;

          irp4.searchRolloutCountry();

          
          //******************************************************************

          if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          
          dmlLimit = Limits.getDMLStatements();
          
          
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
          ApexPages.currentPage().getParameters().put(ID,null);
          Test.setCurrentPageReference(new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+null));
          irp.cancel();
          irp.redirectPage();
           
          ApexPages.currentPage().getParameters().put(ID,null);
          PageReference pRefReg = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+null);
          Test.setCurrentPageReference(pRefReg);
          irp.cancel();
          irp.redirectPage();    
            
            
        
      
      }
       
   }
   
    /*************************************************************************************
  * @Description : Used for testing  regional and local rollouts creation, change of project phase and subsequent creation of regional Projects and removal of rollouts
  * Constructor logic for the controller is tested for a global original project (Searching rollouts, Adding rollouts, Processing rollouts, removing rollouts)
  * @name :  testGlobalProjRolloutAdd3
  ***************************************************************************************/
    public static testmethod void testGlobalProjRolloutAdd3()
    {
      
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();

       
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
        Set<String> projectNameSet = new Set<String>{TestComments1,TestComments2,TestComments3};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
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
        
        System.RunAs(globalProjectLeader)
        {
          Test.startTest();
            projectList = [Select Id,IPM_Phase__c,IPMProject_Span__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
           
            for(IPM_Project__c proj : projectList)
            {
                projectMap.put(proj.Id,proj);
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
                if(localRollout.IPM_Rollout_Project__c.contains(AF))
                {
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains(LA))
                {
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);
                 }
               }
               countryList.add(tempCountry);
            }
         
           insert countryList;
                     
           countryList = [SELECT Id,Name,MDO_Geography__c,Country_Code__c,Country_Name__c,Local_Rollout__c,Market_Cluster_Code__c,
                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c
                FROM IPM_Country__c WHERE id IN : countryList];
            
         
            update countryList;
            
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
          
            dmlLimit = Limits.getDMLStatements();
            
            
            
        }
        
        regionalProjects = new List<IPM_Project__c>();
        
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
               System.assertEquals(regionalProject.Project_Documents__r.size(),1,'Project documents not created');
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size(),'Regional project milestones are not same as parent project milestones');
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
                System.assert(regionalProject.Tasks__r.size()>0,TASK_NOT_CREATED);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,TASK_COMPLEXITY_DOESNOT_MATCH);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0,MILESTONES_NOT_CREATED);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,FINANCIAL_NOT_CREATED); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,IPM_ConstantUtils.FEASIBILITY_PHASE,PHASE_NOT_FEASIBILITY); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put(ID,projectList[0].Id);
          PageReference pRef = new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get(ID);
          
         
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
          
          // all there countries are associated with the same MDO_Geography__c object
          MDO_Geography__c geo1 = new MDO_Geography__c(name = FRANCE,ISO_3166_1_code__c = BR);
          insert geo1;

          List<IPM_Country__c> countryList = new List<IPM_Country__c>();
                for(integer i=0; i<3 ; i++) {
                    IPM_Country__c tmpCountry = new  IPM_Country__c(MDO_Geography__c = geo1.Id,
                    IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    IS_EI_Country__c = true,Local_Rollout__c = regionalRolloutList[0].id, Local_Rollout_Charter__c = regionalRolloutList[0].id);    
                  
                    countryList.add(tmpCountry);
          }
          
          insert countryList;

          List<IPM_Project_Rollout__c> rollouLst = [Select id,IPM_Rollout_Project__c, (Select id,Country_Code__c,Project_Country__c,isActive__c from IPM_Countries_Local__r ) from IPM_Project_Rollout__c Where id =: regionalRolloutList[0].id];
          
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
          
          if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }

          dmlLimit = Limits.getDMLStatements();
          
          
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
          ApexPages.currentPage().getParameters().put(ID,null);
          Test.setCurrentPageReference(new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+null));
          irp.cancel();
          irp.redirectPage();
           
          ApexPages.currentPage().getParameters().put(ID,null);
          PageReference pRefReg = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+null);
          Test.setCurrentPageReference(pRefReg);
          irp.cancel();
          irp.redirectPage();    

      } 
   
    }
    
    /*************************************************************************************
  * @Description : Used for testing  regional and local rollouts creation,and removal of rollouts
  * Constructor logic for the controller is tested for a global original project (Searching rollouts, Adding rollouts, Processing rollouts, removing rollouts)
  * @name :  testRegionalProjRolloutAdd2
  ***************************************************************************************/
    public static testmethod void testRegionalProjRolloutAdd2()
    {
      
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
       
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
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
        
        System.RunAs(globalProjectLeader)
        {
          Test.startTest();
          projectList = IPM_TestFactory_Helper.projectSetUpRegional(2,regionalProjectLeader); 
          insert projectList;
          for(IPM_Project__c proj : projectList)
          {
            projectMap.put(proj.Id,proj);
          } 
            // Create Regional Rollouts for Created Global project.
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
                if(localRollout.IPM_Rollout_Project__c.contains(AF))
                {
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains(LA))
                {
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);
                 }
               }
               countryList.add(tempCountry);
            }
         
           insert countryList;
                     
           countryList = [SELECT Id,Name,MDO_Geography__c,Country_Code__c,Country_Name__c,Local_Rollout__c,Market_Cluster_Code__c,
                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c
                FROM IPM_Country__c WHERE id IN : countryList];
            
         
            update countryList;
            
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
          
            dmlLimit = Limits.getDMLStatements();
            
            
            
        }
        
        regionalProjects = new List<IPM_Project__c>();
        
        
        //******************************** Regional Project Leader View for Regional Projects  ****************************************
        System.RunAs(regionalProjectLeader)
        {
            // Update phase for Local Rollouts. 
            regionalProjectsFR = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id from Regional_Project_Rollout__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];
            
            for(IPM_Project__c regionalProject : regionalProjectsFR)
            {
                // Validate there is atleast one Task associated with Regional Project
                System.assert(regionalProject.Tasks__r.size()>0,TASK_NOT_CREATED);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,TASK_COMPLEXITY_DOESNOT_MATCH);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0,MILESTONES_NOT_CREATED);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,FINANCIAL_NOT_CREATED); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,IPM_ConstantUtils.FEASIBILITY_PHASE,PHASE_NOT_FEASIBILITY); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put(ID,projectList[0].Id);
          PageReference pRef = new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get(ID);
          
         
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
          
          
          MDO_Geography__c geo1 = new MDO_Geography__c(name = FRANCE,ISO_3166_1_code__c = BR);
          insert geo1;
          
          MDO_Geography__c geo2 = new MDO_Geography__c(name = FRANCE,ISO_3166_1_code__c = FR);
          insert geo2;
          
          MDO_Geography__c geo3 = new MDO_Geography__c(name = SOUTH_AFRICA,ISO_3166_1_code__c = SA);
          insert geo3;  
          
          List<IPM_Country__c> countryList = new List<IPM_Country__c>();
                for(integer i=0; i<3 ; i++) {
                    IPM_Country__c tmpCountry = new  IPM_Country__c(MDO_Geography__c = geo1.Id,
                    IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    IS_EI_Country__c = true,Local_Rollout__c = regionalRolloutList[0].id, Local_Rollout_Charter__c = regionalRolloutList[0].id);    
                  
                    countryList.add(tmpCountry);
          }
          
          insert countryList;
         
          List<IPM_Project_Rollout__c> rollouLst = [Select id,IPM_Rollout_Project__c, (Select id,Country_Code__c,Project_Country__c,isActive__c from IPM_Countries_Local__r ) from IPM_Project_Rollout__c Where id =: regionalRolloutList[0].id];
          
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
    
      if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          dmlLimit = Limits.getDMLStatements();
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
        ApexPages.currentPage().getParameters().put(ID,null);
          Test.setCurrentPageReference(new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+null));
           irp.cancel();
           irp.redirectPage();
           
           ApexPages.currentPage().getParameters().put(ID,null);
          PageReference pRefReg = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+null);
          Test.setCurrentPageReference(pRefReg);
           irp.cancel();
           irp.redirectPage();    

      } 
   
    }
    
    
    /*************************************************************************************
  * @Description : Used for testing  regional and local rollouts creation,and removal of rollouts
  * Constructor logic for the controller is tested for a global original project (Searching rollouts, Adding rollouts, Processing rollouts, removing rollouts)
  * @name :  testRegionalProjRolloutAdd3
  ***************************************************************************************/
    public static testmethod void testRegionalProjRolloutAdd3()
    {
      
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();

       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper(AF,AFRICAN,LV4_GEO0085);
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in(:GLOBAL_PL,:REGIONAL_PL,:LOCAL_PL)];
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
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
        
        System.RunAs(globalProjectLeader)
        {
          Test.startTest();
          projectList = IPM_TestFactory_Helper.projectSetUpRegional(2,regionalProjectLeader);
          for(IPM_Project__c proj : projectList ){
            proj.IPM_phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
          } 
          insert projectList;
          for(IPM_Project__c proj : projectList)
          {
            projectMap.put(proj.Id,proj);
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
                if(localRollout.IPM_Rollout_Project__c.contains(AF))
                {
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains(LA))
                {
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = With_MCO);
                 }
               }
               countryList.add(tempCountry);
            }
         
           insert countryList;
                     
           countryList = [SELECT Id,Name,MDO_Geography__c,Country_Code__c,Country_Name__c,Local_Rollout__c,Market_Cluster_Code__c,
                Market_Cluster_Name__c,MCO_Code__c,MCO_Name__c,Project_Country__c,IPM_Project__c, IPM_Project__r.IPM_Market_Type__c, IPM_Regional_Project__c,
                IPM_Regional_Project__r.IPM_Market_Type__c, IPM_Local_Project__c, IPM_Local_Project__r.IPM_Market_Type__c
                FROM IPM_Country__c WHERE id IN : countryList];
            
         
            update countryList;
            
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
          
            dmlLimit = Limits.getDMLStatements();
            
            
            
        }
        
        regionalProjects = new List<IPM_Project__c>();

        
        //******************************** Regional Project Leader View for Regional Projects  ****************************************
        System.RunAs(regionalProjectLeader)
        {
            // Update phase for Local Rollouts. 
            regionalProjectsFR = [Select Id,Name,IPM_Phase__c,IPM_Parent_Project__c,(Select Id from Project_Documents__r),(Select Id from Regional_Project_Rollout__r),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),(Select Id,Name from IPM_Milestones__r) from IPM_Project__c where ID in :regionalProjects];
            
            for(IPM_Project__c regionalProject : regionalProjectsFR)
            {
                // Validate there is atleast one Task associated with Regional Project
                System.assert(regionalProject.Tasks__r.size()>0,TASK_NOT_CREATED);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c,TASK_COMPLEXITY_DOESNOT_MATCH);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0,MILESTONES_NOT_CREATED);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3,FINANCIAL_NOT_CREATED); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,IPM_ConstantUtils.FEASIBILITY_PHASE,PHASE_NOT_FEASIBILITY); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put(ID,projectList[0].Id);
          PageReference pRef = new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get(ID);
          
         
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
          
          
          MDO_Geography__c geo1 = new MDO_Geography__c(name = FRANCE,ISO_3166_1_code__c = BR);
          insert geo1;
          
          MDO_Geography__c geo2 = new MDO_Geography__c(name = FRANCE,ISO_3166_1_code__c = FR);
          insert geo2;
          
          MDO_Geography__c geo3 = new MDO_Geography__c(name = SOUTH_AFRICA,ISO_3166_1_code__c = SA);
          insert geo3;  
          
          List<IPM_Country__c> countryList = new List<IPM_Country__c>();
                for(integer i=0; i<3 ; i++) {
                    IPM_Country__c tmpCountry = new  IPM_Country__c(MDO_Geography__c = geo1.Id,
                    IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    IS_EI_Country__c = true,Local_Rollout__c = regionalRolloutList[0].id, Local_Rollout_Charter__c = regionalRolloutList[0].id);    
                  
                    countryList.add(tmpCountry);
          }
          
          insert countryList;
          
          List<IPM_Project_Rollout__c> rollouLst = [Select id,IPM_Rollout_Project__c, (Select id,Country_Code__c,Project_Country__c,isActive__c from IPM_Countries_Local__r ) from IPM_Project_Rollout__c Where id =: regionalRolloutList[0].id];
          
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
          
          if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          
          dmlLimit = Limits.getDMLStatements();
    
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
          ApexPages.currentPage().getParameters().put(ID,null);
          Test.setCurrentPageReference(new PageReference(IPMROLLOUTPLANSADD_PAGE_URL+null));
          irp.cancel();
          irp.redirectPage();
           
          ApexPages.currentPage().getParameters().put(ID,null);
          PageReference pRefReg = new PageReference(IPMROLLOUTPLANSREGIONAL_PAGE_URL+null);
          Test.setCurrentPageReference(pRefReg);
          irp.cancel();
          irp.redirectPage();    
      } 
    }
}