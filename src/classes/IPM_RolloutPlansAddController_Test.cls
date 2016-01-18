@isTest
public class IPM_RolloutPlansAddController_Test{
    //public static IPM_Project__c project;
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
            globalProjectLeader.lastname = 'GLOBAL_PL';
            regionalProjectLeader.lastname = 'REGIONAL_PL';
            localProjectLeader.lastname = 'LOCAL_PL'; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
         
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            goegraphiesCluster = new MDO_Geography__c();
            goegraphiesCluster.Name = 'African';
            goegraphiesCluster.parent_L2__c =goegraphiesCluster.id;
            goegraphiesCluster.geography_type__c = 'Unilever Cluster';
            goegraphiesCluster.Status__c = 'Active';
            goegraphiesCluster.mdm_id__c='GEO0060';
            insert goegraphiesCluster;
           
              
            goegraphiesMCO = new MDO_Geography__c();
            goegraphiesMCO.Name = 'Africa Emerging Markets';
            //goegraphiesMCO.mdm_id__c=goegraphiesCluster.Id;
            goegraphiesMCO.parent_L2__c =goegraphiesCluster.id;
            goegraphiesMCO.geography_type__c = 'Country Group';
            goegraphiesMCO.mdm_id__c='LV4_GEO0085';
            goegraphiesMCO.Status__c = 'Active';
            insert goegraphiesMCO;
            
            mdoAFR = new MDO_Geography__c(ISO_3166_1_Code__c = 'AG',Name = 'Africa',mdm_id__c=goegraphiesMCO.Id,parent_L2__c =goegraphiesMCO.id, geography_type__c = 'Country',Status__c = 'Active');
            insert mdoAFR;
            
            mdoLA = new MDO_Geography__c(ISO_3166_1_Code__c = 'BR',Name = 'Angola',mdm_id__c=goegraphiesMCO.Id,parent_L2__c =goegraphiesMCO.id, geography_type__c = 'Country',Status__c = 'Active');
            insert mdoLA;
            
            shortName = new IPM_MCO_Short_Names__c();
            shortName.Name='LV4_GEO0085';
            shortName.Country_Group__c = 'Africa Emerging Markets';
            shortName.Short_Name__c = 'UMCA';
            insert  shortName;
          
        
          
         
          
          mcoShortName = new IPM_Market_Cluster_Short_Names__c();
          mcoShortName.Name= 'GEO0060';
          mcoShortName.Unilever_Cluster__c = 'African';
          mcoShortName.Short_Name__c ='AF';
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
  
  public static testmethod void createProject()
  {
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp2= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp3= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp4= new IPM_RolloutPlansAddController();
       
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
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
          Test.startTest();
            projectList = [Select Id,IPM_Phase__c,IPMProject_Span__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
           
            for(IPM_Project__c proj : projectList)
            {
                projectMap.put(proj.Id,proj);
            }
           
             //Test.startTest();    
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
            List<MDO_Geography__c> mdoCountryList = [select id,ISO_3166_1_Code__c,Name,parent_L2__c,geography_type__c,mdm_id__c,Status__c from MDO_Geography__c where Name in ('Africa','Angola') ];
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                //String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AF'))
                {
                    //geoExternalId = 'AG'; //object its declare as 2 length
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    //geoExternalId = 'BR';
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');
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
                project.Market_Cluster__c = 'GEO0060'; 
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
               System.assertEquals(regionalProject.Project_Documents__r.size(),1);
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size());
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
                System.assert(regionalProject.Tasks__r.size()>0);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,IPM_ConstantUtils.FEASIBILITY_PHASE); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put('id',projectList[0].Id);
          PageReference pRef = new PageReference('/apex/ipmrolloutplansadd?id='+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get('id');
          
         
          irp.project=projectList[0];
          irp.globalCountries='AG,BR';
          irp.regionalMco='Africa Emerging Markets,Other South Asia';
          irp.regionalCountry='Africa,Angola';
          irp.regionalNoRoll='Congo,Chad';
          irp.globalUnselectedCountries = 'KW,NB';
          irp.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp.regionalUnselectedNoRoll = 'CB,KB';
          irp.selectedCountry = 'Africa';
          irp.errorMessage='plz enter tld';
          
           irp.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
          geoWrp.key=true;
          geoWrp.selected=true;
          geoWrp.clusterDisabled=true;
          geoWrp.mcoDisabled=true;
          geoWrp.countryDisabled =true;
          geoWrp.noRolloutDisabled=true;
          
          
          MDO_Geography__c geo1 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'BR');
          insert geo1;
          
          MDO_Geography__c geo2 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'FR');
          insert geo2;
          
          MDO_Geography__c geo3 = new MDO_Geography__c(name = 'South Africa',ISO_3166_1_code__c = 'SA');
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
                			//tmpCountry.isActive__c = false;
                			tmpCountry.MDO_Geography__c = geo3.Id;
                	}
                    countryList.add(tmpCountry);
          }
          
          insert countryList;
          List<IPM_Project_Rollout__c> rollouLst = [Select id,IPM_Rollout_Project__c, (Select id,Country_Code__c,Project_Country__c,isActive__c from IPM_Countries_Local__r ) from IPM_Project_Rollout__c Where id =: regionalRolloutList[0].id];
          
          irp.searchCountry='Africa';
          irp.searchRolloutCountry();
          irp.lstClusterWrappers.add(geoWrp);
          
         
          irp.changeMCO();
          irp.generateRollouts();
          irp.changeCluster();
          irp.setCountryCodesMCOs =  new Set<string>{'BR'}; // regionalMco is put into this
          irp.processRegionalMCORollouts();
          Map<String,Set<String>>mcoMap=new Map<String,Set<String>>();
          mcoMap.put(rollouLst[0].IPM_Rollout_Project__c,irp.setCountryCodesMCOs);
          
          irp.removeReferences(mcoMap,rollouLst[0]);
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this     
          irp.generateRollouts();
          
          irp.setCountryCodes = new Set<String>{'BR'}; //regionalCountry put into this 
          irp.processRegionalCountryRollouts();
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
          
          dmlLimit = Limits.getDMLStatements();
          
          //********************************************************************************  

          
          irp2.project=projectList[0];
          irp2.globalCountries='AG,BR';
          irp2.regionalMco='Africa Emerging Markets,Other South Asia';
          irp2.regionalCountry='Africa,Angola';
          irp2.regionalNoRoll='Congo,Chad';
          irp2.globalUnselectedCountries = 'KW,NB';
          irp2.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp2.regionalUnselectedNoRoll = 'CB,KB';
          irp2.selectedCountry = 'Africa';
          irp2.errorMessage='plz enter tld';
          
          irp2.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp2.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp2.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp2.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp2.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp2.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp2.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp2.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
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
          irp3.globalCountries='AG,BR';
          irp3.regionalMco='Africa Emerging Markets,Other South Asia';
          irp3.regionalCountry='Africa,Angola';
          irp3.regionalNoRoll='Congo,Chad';
          irp3.globalUnselectedCountries = 'KW,NB';
          irp3.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp3.regionalUnselectedNoRoll = 'CB,KB';
          irp3.selectedCountry = 'Africa';
          irp3.errorMessage='plz enter tld';
          
          irp3.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp3.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp3.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp3.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp3.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp3.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp3.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp3.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
          geoWrp.key=true;
          geoWrp.selected=true;
          geoWrp.clusterDisabled=true;
          geoWrp.mcoDisabled=true;
          geoWrp.countryDisabled =true;
          geoWrp.noRolloutDisabled=true;
          
          //irp3.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
          IPM_RolloutPlansAddController.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
          
          List<IPM_RolloutPlansAddController.GeographyWrapper> clusterWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          clusterWrapLst.add(geoWrp3);            
          List<IPM_RolloutPlansAddController.GeographyWrapper> mcoWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          mcoWrapLst.add(geoWrp3);
          List<IPM_RolloutPlansAddController.GeographyWrapper> countryWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          countryWrapLst.add(geoWrp3);
          
          irp3.lstClusterWrappers = clusterWrapLst;
          irp3.lstMCOWrappers = mcoWrapLst;
          irp3.lstCountryWrappers = countryWrapLst;
          
          irp3.searchCountry='test';

          irp3.searchRolloutCountry();

          
          //******************************************************************
          
          
          //********************************************************************************
          irp4.project=projectList[0];
          irp4.globalCountries='AG,BR';
          irp4.regionalMco='Africa Emerging Markets,Other South Asia';
          irp4.regionalCountry='Africa,Angola';
          irp4.regionalNoRoll='Congo,Chad';
          irp4.globalUnselectedCountries = 'KW,NB';
          irp4.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp4.regionalUnselectedNoRoll = 'CB,KB';
          irp4.selectedCountry = 'Africa';
          irp4.errorMessage='plz enter tld';
          
          irp4.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp4.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp4.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp4.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp4.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp4.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp4.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp4.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
 
          
          //irp3.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
          IPM_RolloutPlansAddController.GeographyWrapper geoWrp4=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
          
          List<IPM_RolloutPlansAddController.GeographyWrapper> clusterWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          clusterWrapLst.add(geoWrp4);            
          List<IPM_RolloutPlansAddController.GeographyWrapper> mcoWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          mcoWrapLst.add(geoWrp4);
          //List<IPM_RolloutPlansAddController.GeographyWrapper> countryWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          countryWrapLst.add(geoWrp4);
          
          irp4.lstClusterWrappers = clusterWrapLst4;
          irp4.lstMCOWrappers = mcoWrapLst4;
          //irp3.lstCountryWrappers = countryWrapLst4;
          
          //keeping lstCountryWrappers as null so that exception block is tested
          irp4.searchCountry='test';
          try{
              irp4.searchRolloutCountry();
          }
          catch(Exception e){
          	  System.assert(e.getMessage() != null,'Null record referenced lstCountryWrappers');
          }
          
          
          
          
          //******************************************************************
          
          
          if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference('/apex/ipmrolloutplansRegional?id='+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          
          
          //irp.generateRollouts();
          dmlLimit = Limits.getDMLStatements();
          
          
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
        ApexPages.currentPage().getParameters().put('id',null);
          //PageReference pRefGlobal = new PageReference('/apex/ipmrolloutplansadd?id='+null);
          Test.setCurrentPageReference(new PageReference('/apex/ipmrolloutplansadd?id='+null));
           irp.cancel();
           irp.redirectPage();
           
           ApexPages.currentPage().getParameters().put('id',null);
          PageReference pRefReg = new PageReference('/apex/ipmrolloutplansRegional?id='+null);
          Test.setCurrentPageReference(pRefReg);
           irp.cancel();
           irp.redirectPage();    
            
            
        
      
      }
       
      } 

 //****************************************************************************
 
 

   public static testmethod void regionalRolloutProject()
   {  
        IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
        IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
      
        //User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
        IPM_TestFactory_Helper.shareMasterProject(userList); 
        
        for(User lUser  :userList)
        {
            //if(lUser.lastName == 'GLOBAL_PL')
            //{
                //globalProjectLeader = lUser; 
            //}
            if(lUser.lastName == 'REGIONAL_PL')
            {
                regionalProjectLeader = lUser;
            }
        }
        test.StartTest();
        List<IPM_Country__c> countryList= new List<IPM_Country__c>(); 
        regionalProjects= IPM_TestFactory_Helper.projectSetUpRegional(2,regionalProjectLeader); 
        insert regionalProjects;
        // public static List<IPM_Project__c> initiateRegionalProjectPhaseChange(List<Id> listprojectId,User userObj)
        
        List<id> regionalProjId = new List<Id>();
        for(IPM_Project__c regionalProject : regionalProjects)
        {
          regionalProjId.add(regionalProject.id);
        }
        //regional to local phase change
       
        
      List<MDO_Geography__c> mdoCountryList = [select id,ISO_3166_1_Code__c,Name,parent_L2__c,geography_type__c,mdm_id__c,Status__c from MDO_Geography__c where Name in ('Africa','Angola') ];
      
      
             
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
          PageReference pRefRegional = new PageReference('/apex/ipmrolloutplansadd?id='+regionalProjects[0].Id);
          Test.setCurrentPageReference(pRefRegional);
          
          irp.globalCountries='KK,WW';
          irp.regionalMco='WESR EURO,SOUTH AMERICA';
          irp.regionalCountry='Africa,Angola';
          irp.regionalNoRoll='Congo,Chad';
          irp.globalUnselectedCountries = 'KW,NB';
          irp.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp.regionalUnselectedNoRoll = 'CB,KB';
          
          irp.errorMessage='plz enter tld';
          irp.isEditable=true;
          irp.disableMCO = true; //changed bhoopesh
          irp.selectedCountry = 'Australia';
         
         
          irp.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp.setCountryCodes = new Set<String>{'UV'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
          geoWrp.key=true;
          geoWrp.selected=true;
          geoWrp.clusterDisabled=true;
          geoWrp.mcoDisabled=true;
          geoWrp.countryDisabled =true;
          geoWrp.noRolloutDisabled=true;
          
          
          
          irp.changeMCO();
          irp.generateRollouts();
           
         
          dmlLimit = Limits.getDMLStatements();
          
          
          ApexPages.currentPage().getParameters().put('id',null);
          PageReference pRef = new PageReference('/apex/ipmrolloutplansadd?id='+null);
          Test.setCurrentPageReference(pRef);
           irp.cancel();
           irp.redirectPage();
           irp.changeMCO();
           //irp.changeCluster();
           //irp.generateRollouts();
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
          PageReference pRefreg = new PageReference('/apex/ipmrolloutplansRegional?id='+null);
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
          System.assertEquals(0, pageMessages.size());
          //Boolean messageFound = false; 
           
        }
        
        
        
    }
    
    
      public static testmethod void createProject2()
  	 {
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp2= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp3= new IPM_RolloutPlansAddController();
       IPM_RolloutPlansAddController irp4= new IPM_RolloutPlansAddController();
       
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
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
          Test.startTest();
            projectList = [Select Id,IPM_Phase__c,IPMProject_Span__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
           
            for(IPM_Project__c proj : projectList)
            {
                projectMap.put(proj.Id,proj);
            }
           
             //Test.startTest();    
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
            List<MDO_Geography__c> mdoCountryList = [select id,ISO_3166_1_Code__c,Name,parent_L2__c,geography_type__c,mdm_id__c,Status__c from MDO_Geography__c where Name in ('Africa','Angola') ];
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                //String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AF'))
                {
                    //geoExternalId = 'AG'; //object its declare as 2 length
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    //geoExternalId = 'BR';
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');
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
                project.Market_Cluster__c = 'GEO0060'; 
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
               System.assertEquals(regionalProject.Project_Documents__r.size(),1);
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size());
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
                System.assert(regionalProject.Tasks__r.size()>0);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,'Feasibility'); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put('id',projectList[0].Id);
          PageReference pRef = new PageReference('/apex/ipmrolloutplansadd?id='+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get('id');
          
         
          irp.project=projectList[0];
          irp.globalCountries='AG,BR';
          irp.regionalMco='Africa Emerging Markets,Other South Asia';
          irp.regionalCountry='Africa,Angola';
          irp.regionalNoRoll='Congo,Chad';
          irp.globalUnselectedCountries = 'KW,NB';
          irp.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp.regionalUnselectedNoRoll = 'CB,KB';
          irp.selectedCountry = 'Africa';
          irp.errorMessage='plz enter tld';
          
           irp.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
          geoWrp.key=true;
          geoWrp.selected=true;
          geoWrp.clusterDisabled=true;
          geoWrp.mcoDisabled=true;
          geoWrp.countryDisabled =true;
          geoWrp.noRolloutDisabled=true;
          
          
          MDO_Geography__c geo1 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'BR');
          insert geo1;
          
          MDO_Geography__c geo2 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'FR');
          insert geo2;
          
          MDO_Geography__c geo3 = new MDO_Geography__c(name = 'South Africa',ISO_3166_1_code__c = 'SA');
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
                			//tmpCountry.isActive__c = false;
                			tmpCountry.MDO_Geography__c = geo3.Id;
                	}
                    countryList.add(tmpCountry);
          }
          
          insert countryList;
          
          List<IPM_Project_Rollout__c> rollouLst = [Select id,IPM_Rollout_Project__c, (Select id,Country_Code__c,Project_Country__c,isActive__c from IPM_Countries_Local__r ) from IPM_Project_Rollout__c Where id =: regionalRolloutList[0].id];
          
          irp.searchCountry='Africa';
          irp.searchRolloutCountry();
          irp.lstClusterWrappers.add(geoWrp);
          
         
          irp.changeMCO();
          irp.generateRollouts();
          irp.changeCluster();
          irp.setCountryCodesMCOs =  new Set<string>{'BR'}; // regionalMco is put into this
          irp.processRegionalMCORollouts();
          Map<String,Set<String>>mcoMap=new Map<String,Set<String>>();
          mcoMap.put(rollouLst[0].IPM_Rollout_Project__c,irp.setCountryCodesMCOs);
          
          irp.removeReferences(mcoMap,rollouLst[0]);
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this     
          irp.generateRollouts();
          
          irp.setCountryCodes = new Set<String>{'BR'}; //regionalCountry put into this 
          irp.processRegionalCountryRollouts();
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
          
          dmlLimit = Limits.getDMLStatements();
          
          //********************************************************************************  

          
          irp2.project=projectList[0];
          irp2.globalCountries='AG,BR';
          irp2.regionalMco='Africa Emerging Markets,Other South Asia';
          irp2.regionalCountry='Africa,Angola';
          irp2.regionalNoRoll='Congo,Chad';
          irp2.globalUnselectedCountries = 'KW,NB';
          irp2.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp2.regionalUnselectedNoRoll = 'CB,KB';
          irp2.selectedCountry = 'Africa';
          irp2.errorMessage='plz enter tld';
          
          irp2.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp2.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp2.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp2.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp2.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp2.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp2.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp2.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
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
          irp3.globalCountries='AG,BR';
          irp3.regionalMco='Africa Emerging Markets,Other South Asia';
          irp3.regionalCountry='Africa,Angola';
          irp3.regionalNoRoll='Congo,Chad';
          irp3.globalUnselectedCountries = 'KW,NB';
          irp3.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp3.regionalUnselectedNoRoll = 'CB,KB';
          irp3.selectedCountry = 'Africa';
          irp3.errorMessage='plz enter tld';
          
          irp3.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp3.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp3.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp3.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp3.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp3.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp3.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp3.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
          geoWrp.key=true;
          geoWrp.selected=true;
          geoWrp.clusterDisabled=true;
          geoWrp.mcoDisabled=true;
          geoWrp.countryDisabled =true;
          geoWrp.noRolloutDisabled=true;
          
          //irp3.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
          IPM_RolloutPlansAddController.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
          
          List<IPM_RolloutPlansAddController.GeographyWrapper> clusterWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          clusterWrapLst.add(geoWrp3);            
          List<IPM_RolloutPlansAddController.GeographyWrapper> mcoWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          mcoWrapLst.add(geoWrp3);
          List<IPM_RolloutPlansAddController.GeographyWrapper> countryWrapLst =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          countryWrapLst.add(geoWrp3);
          
          irp3.lstClusterWrappers = clusterWrapLst;
          irp3.lstMCOWrappers = mcoWrapLst;
          irp3.lstCountryWrappers = countryWrapLst;
          
          irp3.searchCountry='test';

              irp3.searchRolloutCountry();

          //******************************************************************
          
          
          //********************************************************************************
          irp4.project=projectList[0];
          irp4.globalCountries='AG,BR';
          irp4.regionalMco='Africa Emerging Markets,Other South Asia';
          irp4.regionalCountry='Africa,Angola';
          irp4.regionalNoRoll='Congo,Chad';
          irp4.globalUnselectedCountries = 'KW,NB';
          irp4.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp4.regionalUnselectedNoRoll = 'CB,KB';
          irp4.selectedCountry = 'Africa';
          irp4.errorMessage='plz enter tld';
          
          irp4.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp4.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp4.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp4.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp4.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp4.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp4.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp4.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
 
          
          //irp3.GeographyWrapper geoWrp3=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
          IPM_RolloutPlansAddController.GeographyWrapper geoWrp4=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
          
          List<IPM_RolloutPlansAddController.GeographyWrapper> clusterWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          clusterWrapLst.add(geoWrp4);            
          List<IPM_RolloutPlansAddController.GeographyWrapper> mcoWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          mcoWrapLst.add(geoWrp4);
          List<IPM_RolloutPlansAddController.GeographyWrapper> countryWrapLst4 =  new List<IPM_RolloutPlansAddController.GeographyWrapper>();
          countryWrapLst4.add(geoWrp4);
          
          irp4.lstClusterWrappers = clusterWrapLst4;
          irp4.lstMCOWrappers = mcoWrapLst4;
          irp3.lstCountryWrappers = countryWrapLst4;
          
          irp4.searchCountry='test';

          irp4.searchRolloutCountry();

          
          //******************************************************************
          
          
          if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference('/apex/ipmrolloutplansRegional?id='+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          
          
          //irp.generateRollouts();
          dmlLimit = Limits.getDMLStatements();
          
          
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
        ApexPages.currentPage().getParameters().put('id',null);
          //PageReference pRefGlobal = new PageReference('/apex/ipmrolloutplansadd?id='+null);
          Test.setCurrentPageReference(new PageReference('/apex/ipmrolloutplansadd?id='+null));
           irp.cancel();
           irp.redirectPage();
           
           ApexPages.currentPage().getParameters().put('id',null);
          PageReference pRefReg = new PageReference('/apex/ipmrolloutplansRegional?id='+null);
          Test.setCurrentPageReference(pRefReg);
           irp.cancel();
           irp.redirectPage();    
            
            
        
      
      }
       
   }
   
    public static testmethod void createProject3()
  	{
  		
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();

       
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
        Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
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
          Test.startTest();
            projectList = [Select Id,IPM_Phase__c,IPMProject_Span__c,Name,IPM_Complexity__c,IPM_Project_Name__c,(Select Id from Project_Documents__r),
                                                    (Select Id from IPM_Financials_Consolidated__r ),(Select Id,Name,IPM_Task_Complexity__c from Tasks__r),
                                                    (Select Id,Name from IPM_Milestones__r) from IPM_Project__c where Name in:projectNameSet];
           
            for(IPM_Project__c proj : projectList)
            {
                projectMap.put(proj.Id,proj);
            }
           
             //Test.startTest();    
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
            List<MDO_Geography__c> mdoCountryList = [select id,ISO_3166_1_Code__c,Name,parent_L2__c,geography_type__c,mdm_id__c,Status__c from MDO_Geography__c where Name in ('Africa','Angola') ];
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                //String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AF'))
                {
                    //geoExternalId = 'AG'; //object its declare as 2 length
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    //geoExternalId = 'BR';
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');
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
                project.Market_Cluster__c = 'GEO0060'; 
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
               System.assertEquals(regionalProject.Project_Documents__r.size(),1);
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size());
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
                System.assert(regionalProject.Tasks__r.size()>0);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,'Feasibility'); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put('id',projectList[0].Id);
          PageReference pRef = new PageReference('/apex/ipmrolloutplansadd?id='+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get('id');
          
         
          irp.project=projectList[0];
          irp.globalCountries='AG,BR';
          irp.regionalMco='Africa Emerging Markets,Other South Asia';
          irp.regionalCountry='Africa,Angola';
          irp.regionalNoRoll='Congo,Chad';
          irp.globalUnselectedCountries = 'KW,NB';
          irp.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp.regionalUnselectedNoRoll = 'CB,KB';
          irp.selectedCountry = 'Africa';
          irp.errorMessage='plz enter tld';
          
           irp.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
          geoWrp.key=true;
          geoWrp.selected=true;
          geoWrp.clusterDisabled=true;
          geoWrp.mcoDisabled=true;
          geoWrp.countryDisabled =true;
          geoWrp.noRolloutDisabled=true;
          
          
          MDO_Geography__c geo1 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'BR');
          insert geo1;
          
          MDO_Geography__c geo2 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'FR');
          insert geo2;
          
          MDO_Geography__c geo3 = new MDO_Geography__c(name = 'South Africa',ISO_3166_1_code__c = 'SA');
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
          
          irp.searchCountry='Africa';
          irp.searchRolloutCountry();
          irp.lstClusterWrappers.add(geoWrp);
          
         
          irp.changeMCO();
          irp.generateRollouts();
          irp.changeCluster();
          irp.setCountryCodesMCOs =  new Set<string>{'BR'}; // regionalMco is put into this
          irp.processRegionalMCORollouts();
          Map<String,Set<String>>mcoMap=new Map<String,Set<String>>();
          mcoMap.put(rollouLst[0].IPM_Rollout_Project__c,irp.setCountryCodesMCOs);
          irp.removeReferences(mcoMap,rollouLst[0]);
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this     
          irp.generateRollouts();
          
          irp.setCountryCodes = new Set<String>{'BR'}; //regionalCountry put into this 
          irp.processRegionalCountryRollouts();
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
          
          dmlLimit = Limits.getDMLStatements();
          
          if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference('/apex/ipmrolloutplansRegional?id='+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          
          
          //irp.generateRollouts();
          dmlLimit = Limits.getDMLStatements();
          
          
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
        ApexPages.currentPage().getParameters().put('id',null);
          //PageReference pRefGlobal = new PageReference('/apex/ipmrolloutplansadd?id='+null);
          Test.setCurrentPageReference(new PageReference('/apex/ipmrolloutplansadd?id='+null));
           irp.cancel();
           irp.redirectPage();
           
           ApexPages.currentPage().getParameters().put('id',null);
          PageReference pRefReg = new PageReference('/apex/ipmrolloutplansRegional?id='+null);
          Test.setCurrentPageReference(pRefReg);
           irp.cancel();
           irp.redirectPage();    

      } 
   
  	}
  	
  	
  	public static testmethod void regionalProject2()
  	{
  		
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();
       
       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
        //Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
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
          Test.startTest();
          projectList = IPM_TestFactory_Helper.projectSetUpRegional(2,regionalProjectLeader); 
          insert projectList;
          for(IPM_Project__c proj : projectList)
          {
            projectMap.put(proj.Id,proj);
          }
           
             //Test.startTest();    
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
            List<MDO_Geography__c> mdoCountryList = [select id,ISO_3166_1_Code__c,Name,parent_L2__c,geography_type__c,mdm_id__c,Status__c from MDO_Geography__c where Name in ('Africa','Angola') ];
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                //String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AF'))
                {
                    //geoExternalId = 'AG'; //object its declare as 2 length
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    //geoExternalId = 'BR';
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');
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
                project.Market_Cluster__c = 'GEO0060'; 
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
               System.assertEquals(regionalProject.Project_Documents__r.size(),1);
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size());
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
                System.assert(regionalProject.Tasks__r.size()>0);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,'Feasibility'); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put('id',projectList[0].Id);
          PageReference pRef = new PageReference('/apex/ipmrolloutplansadd?id='+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get('id');
          
         
          irp.project=projectList[0];
          irp.globalCountries='AG,BR';
          irp.regionalMco='Africa Emerging Markets,Other South Asia';
          irp.regionalCountry='Africa,Angola';
          irp.regionalNoRoll='Congo,Chad';
          irp.globalUnselectedCountries = 'KW,NB';
          irp.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp.regionalUnselectedNoRoll = 'CB,KB';
          irp.selectedCountry = 'Africa';
          irp.errorMessage='plz enter tld';
          
          irp.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
          geoWrp.key=true;
          geoWrp.selected=true;
          geoWrp.clusterDisabled=true;
          geoWrp.mcoDisabled=true;
          geoWrp.countryDisabled =true;
          geoWrp.noRolloutDisabled=true;
          
          
          MDO_Geography__c geo1 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'BR');
          insert geo1;
          
          MDO_Geography__c geo2 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'FR');
          insert geo2;
          
          MDO_Geography__c geo3 = new MDO_Geography__c(name = 'South Africa',ISO_3166_1_code__c = 'SA');
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
          
          irp.searchCountry='Africa';
          irp.searchRolloutCountry();
          irp.lstClusterWrappers.add(geoWrp);
          
         
          irp.changeMCO();
          irp.generateRollouts();
          irp.changeCluster();
          irp.setCountryCodesMCOs =  new Set<string>{'BR'}; // regionalMco is put into this
          irp.processRegionalMCORollouts();
          Map<String,Set<String>>mcoMap=new Map<String,Set<String>>();
          mcoMap.put(rollouLst[0].IPM_Rollout_Project__c,irp.setCountryCodesMCOs);
          
          irp.removeReferences(mcoMap,rollouLst[0]);
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this     
          irp.generateRollouts();
           
          irp.setCountryCodes = new Set<String>{'BR'}; //regionalCountry put into this 
          irp.processRegionalCountryRollouts();
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
          
          dmlLimit = Limits.getDMLStatements();
		
		  if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference('/apex/ipmrolloutplansRegional?id='+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          
          
          //irp.generateRollouts();
          dmlLimit = Limits.getDMLStatements();
          
          
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
        ApexPages.currentPage().getParameters().put('id',null);
          //PageReference pRefGlobal = new PageReference('/apex/ipmrolloutplansadd?id='+null);
          Test.setCurrentPageReference(new PageReference('/apex/ipmrolloutplansadd?id='+null));
           irp.cancel();
           irp.redirectPage();
           
           ApexPages.currentPage().getParameters().put('id',null);
          PageReference pRefReg = new PageReference('/apex/ipmrolloutplansRegional?id='+null);
          Test.setCurrentPageReference(pRefReg);
           irp.cancel();
           irp.redirectPage();    

      } 
   
  	}
  	
  	public static testmethod void regionalProject3()
  	{
  		
       IPM_RolloutPlansAddController irp= new IPM_RolloutPlansAddController();

       IPM_RolloutPlansAddController.GeographyWrapper geoWrp=new IPM_RolloutPlansAddController.GeographyWrapper('AF','African','LV4_GEO0085');
        //Set<String> projectNameSet = new Set<String>{'TestComments1','TestComments2','TestComments3'};
        List<Id> globalProjectIdList = new List<Id>();
        Map<Id,IPM_Project__c> projectMap = new Map<Id,IPM_Project__c>();
        User globalProjectLeader = null;
        User regionalProjectLeader = null;  
        
        List<User> userList = [Select Id,Name,lastName from User where LastName in('GLOBAL_PL','REGIONAL_PL','LOCAL_PL')];
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
           
             //Test.startTest();    
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
            List<MDO_Geography__c> mdoCountryList = [select id,ISO_3166_1_Code__c,Name,parent_L2__c,geography_type__c,mdm_id__c,Status__c from MDO_Geography__c where Name in ('Africa','Angola') ];
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                //String geoExternalId = '';
                if(localRollout.IPM_Rollout_Project__c.contains('AF'))
                {
                    //geoExternalId = 'AG'; //object its declare as 2 length
                    geoExternal= true;
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    //geoExternalId = 'BR';
                    geoExternal= false;
                }
               
            
               
               
               
               for(MDO_Geography__c geoList : mdoCountryList)
               {
                 if(geoExternal)
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                 }
                 else
                 {
                  tempCountry = new  IPM_Country__c(MDO_Geography__c=geoList.Id,
                  IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');
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
                project.Market_Cluster__c = 'GEO0060'; 
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
               System.assertEquals(regionalProject.Project_Documents__r.size(),1);
   
               // MileStones would Copy from Parent Project. 
               System.assertEquals(regionalProject.IPM_Milestones__r.size(),parentGlobalProject.IPM_Milestones__r.size());
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
                System.assert(regionalProject.Tasks__r.size()>0);
                
                for(IPM_Task__c task : regionalProject.Tasks__r)
                {
                    System.assertEquals(task.IPM_Task_Complexity__c,regionalProject.IPM_Complexity__c);     
                }
                
                // Once project is created, associated Milestones should be same as Master milestones.
                System.assert(regionalProject.IPM_Milestones__r.size()>0);
                
                // Once project is created , Consolidated financials are getting generated.
                System.assertEquals(regionalProject.IPM_Financials_Consolidated__r.size(),3); // One for Global consolidated Financials and 2 for individual Rollouts
                
                // Project default phase would always be set as feasibility.
                System.assertEquals(regionalProject.IPM_Phase__c,'Feasibility'); // Phase would be feasibility for Regional Projects.
                
            }
        }
        dmlLimit = Limits.getDMLStatements();
        
        
        system.RunAs(globalProjectLeader)
      {
          ApexPages.currentPage().getParameters().put('id',projectList[0].Id);
          PageReference pRef = new PageReference('/apex/ipmrolloutplansadd?id='+projectList[0].Id);
          Test.setCurrentPageReference(pRef);
          projectId = ApexPages.currentPage().getParameters().get('id');
          
         
          irp.project=projectList[0];
          irp.globalCountries='AG,BR';
          irp.regionalMco='Africa Emerging Markets,Other South Asia';
          irp.regionalCountry='Africa,Angola';
          irp.regionalNoRoll='Congo,Chad';
          irp.globalUnselectedCountries = 'KW,NB';
          irp.regionalUnselectedMco = 'IN,CL,CP,JS'; //unselected mco country code
          irp.regionalUnselectedNoRoll = 'CB,KB';
          irp.selectedCountry = 'Africa';
          irp.errorMessage='plz enter tld';
          
          irp.setCountryNoRolls = new Set<String>{'Congo','Chad'}; //it is made from  regionalNoRoll
          irp.setCountryCodesGlobal= new Set<String>{'AG,BR,AO'};  // country iso code is added in the controller
          irp.setCountryCodesGlobalUnselected= new Set<String>{'KW','NB'}; //globalUnselectedCountries is put into this
          
         
          irp.setCountryCodesMCOsUnselected = new Set<String>{'ASIA','EUROPE'}; //regionalUnselectedMco is put into this 
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this
          irp.setCountryCodesUnselected = new Set<String>{'KW','NB'}; // regionalUselectedCountry is put into this
          irp.setCountryNoRollsUnselected = new Set<String>{'CB'}; //regionalUnselectedNoRoll is put into this
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
         
         
          geoWrp.code='LV4_GEO0085';
          geoWrp.name='Africa Emerging Markets';
          geoWrp.parentCode='GEO0060';
          geoWrp.rolloutStatus='With MCO';
          geoWrp.key=true;
          geoWrp.selected=true;
          geoWrp.clusterDisabled=true;
          geoWrp.mcoDisabled=true;
          geoWrp.countryDisabled =true;
          geoWrp.noRolloutDisabled=true;
          
          
          MDO_Geography__c geo1 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'BR');
          insert geo1;
          
          MDO_Geography__c geo2 = new MDO_Geography__c(name = 'France',ISO_3166_1_code__c = 'FR');
          insert geo2;
          
          MDO_Geography__c geo3 = new MDO_Geography__c(name = 'South Africa',ISO_3166_1_code__c = 'SA');
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
          
          irp.searchCountry='Africa';
          irp.searchRolloutCountry();
          irp.lstClusterWrappers.add(geoWrp);
          
         
          irp.changeMCO();
          irp.generateRollouts();
          irp.changeCluster();
          irp.setCountryCodesMCOs =  new Set<string>{'BR'}; // regionalMco is put into this
          irp.processRegionalMCORollouts();
          Map<String,Set<String>>mcoMap=new Map<String,Set<String>>();
          mcoMap.put(rollouLst[0].IPM_Rollout_Project__c,irp.setCountryCodesMCOs);
          irp.removeReferences(mcoMap,rollouLst[0]);
          irp.setCountryCodesMCOs =  new Set<string>{'Africa Emerging Markets','Other South Asia'}; // regionalMco is put into this     
          irp.generateRollouts();
           
          irp.setCountryCodes = new Set<String>{'BR'}; //regionalCountry put into this 
          irp.processRegionalCountryRollouts();
          irp.setCountryCodes = new Set<String>{'AF'}; //regionalCountry put into this 
          
          dmlLimit = Limits.getDMLStatements();
          
          if(regionalProjects.size()>0){
            PageReference pRefRegional = new PageReference('/apex/ipmrolloutplansRegional?id='+regionalProjects[0].Id);
            Test.setCurrentPageReference(pRefRegional); 
          }
          
          
          //irp.generateRollouts();
          dmlLimit = Limits.getDMLStatements();
          
          
          PageReference rolloutPlansExpected = Page.IPM_RolloutPlans; 
          PageReference rolloutPlansActual = irp.redirectPage();
          irp.cancel();
          
          System.assert(rolloutPlansActual.getURL().contains(rolloutPlansExpected.getURL()));
        
        ApexPages.currentPage().getParameters().put('id',null);
          //PageReference pRefGlobal = new PageReference('/apex/ipmrolloutplansadd?id='+null);
          Test.setCurrentPageReference(new PageReference('/apex/ipmrolloutplansadd?id='+null));
          irp.cancel();
          irp.redirectPage();
           
          ApexPages.currentPage().getParameters().put('id',null);
          PageReference pRefReg = new PageReference('/apex/ipmrolloutplansRegional?id='+null);
          Test.setCurrentPageReference(pRefReg);
          irp.cancel();
          irp.redirectPage();    

      } 
   
  	}
 
 	
    
}
