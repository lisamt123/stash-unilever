/******************************************** 
@Author: Cognizant
@name: IPM_ProjectCountryDetails_Test
@CreateDate: 01/02/2015
@Description: Test class to test IPM_CountryDetails Class for updation of country market type and delete country.
@Version: 1.0
@reference: 
*********************************************/

@isTest
private class IPM_ProjectCountryDetails_Test {
    public static List<IPM_Project_Resource__c> projectResList;
    public static List<IPM_Project__c> projectlist;
    public static List<User> userList;
    public static User platformUser;
    public static List<IPM_Company_Card__c> companyCardList; 
    public static String COUNTRY_FRANCE = 'France';
    public static String PROJ_STRATEGIC_INTENT = 'test1';
    
    @testSetup static void projectSetUpData() 
     {
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser('');
            
        }
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        
        companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        
         IPM_TestFactory_Helper.getProjectMasterData();
         
         projectList = IPM_TestFactory_Helper.projectSetUp(8,platformUser);

         System.runAs(platformUser)
         {
           for(IPM_Project__c proj : projectList){
            proj.First_Sync_To_EcoDesign__c = true;
            proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            proj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            proj.IPM_CompanyCardText__c = 'Global Company Card';
            proj.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
          }
           insert projectList;
         }  
         system.assertEquals(projectList.size(),8,'Projects are not created');

         IPM_USLP_Country__c uslpCountry = new IPM_USLP_Country__c(Name=COUNTRY_FRANCE,USLPCountryISCode__c='FR');
         insert uslpCountry;
      }   

    /***********************************
      Description of the purpose of the method. 
      @name: testCountryUpdate
      @Description: Method to check that sync status is set when the project lookup on the country changes
      @param: none
      @return: none
      @throws: none
    ***********************************/
    
    static testMethod void testCountryUpdate(){
        
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser){
            List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();
            toUpdateProjList = [Select Id,IPM_Strategic_Intent__c from IPM_Project__c where IPM_Project_Type__c =:IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL limit 50000];
            for(IPM_Project__c proj:toUpdateProjList){
                proj.IPM_Strategic_Intent__c = PROJ_STRATEGIC_INTENT;
            }
            
            update toUpdateProjList;
            
            IPM_Project__c globalProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            globalProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            globalProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            globalProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            globalProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            globalProjNew.IPM_Exists_AtLeast_OneAssmntPerEICountry__c = true;
            globalProjNew.IPM_Strategic_Intent__c = PROJ_STRATEGIC_INTENT;
            insert globalProjNew;
                    
            IPM_Project__c regionalProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            regionalProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            regionalProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            regionalProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            regionalProjNew.IPM_Parent_Project__c = globalProjNew.Id;
            regionalProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            regionalProjNew.IPM_Strategic_Intent__c = PROJ_STRATEGIC_INTENT;
            insert regionalProjNew;
            
            IPM_Project__c localProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            localProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            localProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            localProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            localProjNew.IPM_Parent_Project__c = regionalProjNew.Id;
            localProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            localProjNew.IPM_Strategic_Intent__c = PROJ_STRATEGIC_INTENT;
            insert localProjNew;

            MDO_Geography__c geo = new MDO_Geography__c(Name= 'TESTGEO', Status__c = 'Active');
            	insert geo;     
            MDO_Market__c market = new MDO_Market__c(Type__c=IPM_ConstantUtils.IPM_PROJECT_MARKET_TYPE_DEVELOPED);
            	insert market;
            MDO_MarketGeographys__c marketGeo = new MDO_MarketGeographys__c(Geography_ID__c=geo.id,Market_ID__c=market.id);   
            	insert marketGeo;      
            List<IPM_Country__c> countryList = new List<IPM_Country__c>();
                for(integer i=0; i<4 ; i++) {
                    IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = geo.Id,
                    IPM_Project__c = toUpdateProjList[i].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    IS_EI_Country__c = true, isActive__c = true);    
                
                    countryList.add(tempCountry);
            }
                
            insert countryList;
            test.startTest();   
            IPM_Country__c toUpdateCountry = [Select Id,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c from IPM_Country__c where IS_EI_Country__c = true limit 50000][0];
                
            toUpdateCountry.IPM_Project__c = globalProjNew.Id ;
            update toUpdateCountry;
                
            IPM_Country__c toUpdateCountry1 = [Select Id,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c from IPM_Country__c where IS_EI_Country__c = true limit 50000][0];
            
            toUpdateCountry1.IPM_Regional_Project__c = regionalProjNew.Id ;
            update toUpdateCountry1;
                
            IPM_Country__c toUpdateCountry2 = [Select Id,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c from IPM_Country__c where IS_EI_Country__c = true limit 50000][0];
            toUpdateCountry2.IPM_Local_Project__c = localProjNew.Id ;
            update toUpdateCountry2;
    
            //to check for instance variables
            IPM_ProjectCountryDetails ipcd = new IPM_ProjectCountryDetails();
            System.assertEquals(false,ipcd.isGlobalDeveloped);
            test.stopTest();
               
            IPM_Project__c updatedproj = [Select Id,First_Sync_To_EcoDesign__c,EcoDesign_Sync_Status__c from IPM_Project__c Limit 1][0];
            System.assertEquals('Ready',updatedproj.EcoDesign_Sync_Status__c);
                
        }
    }
    
    
    /***********************************
      Description of the purpose of the method. 
      @name: testCountryUpdate
      @Description: to test is existsAtleastIOneAssmntEICountry flag is set
      @param: none
      @return: none
      @throws: none
    ***********************************/
   
    static testMethod void testAtLeastOneAssmnt(){
        
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser){
            test.startTest();
            IPM_Project__c projToUpdate = [Select id,IPM_Project_Name__c,CreatedDate, IPM_Exists_AtLeast_OneAssmntPerEICountry__c from IPM_Project__c limit 50000][0];
            projectList = [Select id, IPM_Exists_AtLeast_OneAssmntPerEICountry__c from IPM_Project__c limit 50000];
            projToUpdate.IPM_Exists_AtLeast_OneAssmntPerEICountry__c = true;
            projToUpdate.IPM_Project_Name__c = 'testProject01';
            update projToUpdate;
            
            projectResList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 5);
            for(Integer i = 0; i < projectResList.size(); i++){
                projectResList[i].IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_FINANCE;
                projectResList[i].IPM_Project_Role_Owner__c = true;
                projectResList[i].IPM_Project__c = projectList[i].Id;
            }
            insert projectResList;
            Set<Id> projIdSet = new Set<Id>();
            for(IPM_Project__c proj : projectList){
                projIdSet.add(proj.Id);
            }
            Map<Id,List<IPM_Project_Resource__c>> projMembersmap = IPM_ProjectCountryDetails.getProjectIdMembersListMap(projIdSet, 'All');
            for(Id projId: projIdSet){
                IPM_ProjectCountryDetails.getProjectMembersNames(projMembersmap.get(projId));
            }
            
            
            List<IPM_Country__c> countries = [Select Id from IPM_Country__c where IPM_Project__c =:projectList[0].Id limit 50000];
            delete countries;
            
            IPM_Country__c tempCountry = new  IPM_Country__c(
                  IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                  IS_EI_Country__c = true, isActive__c = true);
            insert tempCountry;
            
            IPM_Assessment__c assessment1 = IPM_TestFactory_Helper.createAssessments(false, projToUpdate.id, tempCountry.id,IPM_ConstantUtils.PHASE_IDEAS );      

            insert assessment1;
            delete assessment1;
            
            
            IPM_Country__c tempCountry2 = new  IPM_Country__c(
                  IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                  IS_EI_Country__c = false, isActive__c = true);
           insert tempCountry2;
           
           IPM_Project__c projToCheck = [Select id, IPM_Exists_AtLeast_OneAssmntPerEICountry__c from IPM_Project__c Where Id =:projectList[0].Id limit 1][0];
           System.assertEquals(false,projToCheck.IPM_Exists_AtLeast_OneAssmntPerEICountry__c);
           test.stopTest();
        }    
    }
    
    /***********************************
      Description of the purpose of the method. 
      @name: testCountryUpdate
      @Description: to test project update with sync status when country is deleted
      @param: none
      @return: none
      @throws: none
    ***********************************/
    static testMethod void testCountryDeletion(){
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser){
            test.startTest();
            List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();
            toUpdateProjList = [Select Id,IPM_Strategic_Intent__c from IPM_Project__c where IPM_Project_Type__c =:IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL limit 50000];

			MDO_Geography__c geo = new MDO_Geography__c(Name= 'TESTGEO', Status__c = 'Active');
            	insert geo;     
            MDO_Market__c market = new MDO_Market__c(Type__c=IPM_ConstantUtils.IPM_PROJECT_MARKET_TYPE_DEVELOPED);
            	insert market;
            MDO_MarketGeographys__c marketGeo = new MDO_MarketGeographys__c(Geography_ID__c=geo.id,Market_ID__c=market.id);   
            	insert marketGeo;      
            List<IPM_Country__c> countryList = new List<IPM_Country__c>();
                for(integer i=0; i<4 ; i++) {
                    IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = geo.Id,
                    IPM_Project__c = toUpdateProjList[i].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    IS_EI_Country__c = true, isActive__c = true);    
                
                    countryList.add(tempCountry);
            }
                
            insert countryList;
            
            delete countryList[0];
            
            IPM_Project__c updatedproj = [Select Id,First_Sync_To_EcoDesign__c,EcoDesign_Sync_Status__c from IPM_Project__c Where Id =:toUpdateProjList[0].Id limit 1][0];
            System.assertEquals('Ready',updatedproj.EcoDesign_Sync_Status__c);
            test.stopTest();
            
        }
    }
    
    /***********************************
      Description of the purpose of the method. 
      @name: testCountryUpdate
      @Description: to test project update when countries with regional or local projects is inserted
      @param: none
      @return: none
      @throws: none
    ***********************************/
     static testMethod void testCountryInsertWithRegionalLocalProj(){
        
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser){
            test.startTest();
            List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();
            toUpdateProjList = [Select Id,IPM_Strategic_Intent__c from IPM_Project__c where IPM_Project_Type__c =:IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL limit 50000];
            for(IPM_Project__c proj:toUpdateProjList){
                proj.IPM_Strategic_Intent__c = PROJ_STRATEGIC_INTENT;
            }
            
            update toUpdateProjList;
            
            IPM_Project__c globalProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            globalProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            globalProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            globalProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            globalProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            globalProjNew.IPM_Exists_AtLeast_OneAssmntPerEICountry__c = true;
            globalProjNew.IPM_Strategic_Intent__c = PROJ_STRATEGIC_INTENT;
            insert globalProjNew;
                    
            IPM_Project__c regionalProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            regionalProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            regionalProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            regionalProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            regionalProjNew.IPM_Parent_Project__c = globalProjNew.Id;
            regionalProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            regionalProjNew.IPM_Strategic_Intent__c = PROJ_STRATEGIC_INTENT;
            insert regionalProjNew;
            
            IPM_Project__c localProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            localProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            localProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            localProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            localProjNew.IPM_Parent_Project__c = regionalProjNew.Id;
            localProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            localProjNew.IPM_Strategic_Intent__c = PROJ_STRATEGIC_INTENT;
            insert localProjNew;
            
    		MDO_Geography__c geo = new MDO_Geography__c(Name= 'TESTGEO', Status__c = 'Active');
            	insert geo;     
            MDO_Market__c market = new MDO_Market__c(Type__c=IPM_ConstantUtils.IPM_PROJECT_MARKET_TYPE_DEVELOPED);
            	insert market;
            MDO_MarketGeographys__c marketGeo = new MDO_MarketGeographys__c(Geography_ID__c=geo.id,Market_ID__c=market.id);   
            	insert marketGeo;      
            	
            List<IPM_Country__c> countryList = new List<IPM_Country__c>();
                for(integer i=0; i<4 ; i++) {
                    IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = geo.Id,
                    IPM_Regional_Project__c = toUpdateProjList[i].id,IPM_local_Project__c =toUpdateProjList[i+1].id, IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    IS_EI_Country__c = true , isActive__c = true);    
                    countryList.add(tempCountry);
            }
                
            insert countryList;
            IPM_Project__c updatedproj = [Select Id,First_Sync_To_EcoDesign__c,EcoDesign_Sync_Status__c from IPM_Project__c Where Id =:toUpdateProjList[0].Id limit 1][0];
            System.assertEquals('Ready',updatedproj.EcoDesign_Sync_Status__c);
            test.stopTest();
        }
    }
    
 
    /***********************************
      Description of the purpose of the method. 
      @name: testupdateCountriesToFinancials
      @Description: to test financials
      @param: none
      @return: none
      @throws: none
    ***********************************/
    public static testmethod void testupdateCountriesToFinancials() 
     {
         userList = [Select Id,Name,LastName from User limit 1000];
         User globalUser = [Select Id,Name,LastName from User where LastName='PLATFORM_USER' limit 1];
         System.runAs(globalUser)
         {   
            test.startTest();
            projectList = [Select Id,IPM_Strategic_Intent__c,IPM_Project_Name__c from IPM_Project__c where IPM_Project_Type__c =:IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL limit 3];
           
            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectList,new List<User>{userList[1],userList[1],userList[1]});
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
                
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO, isActive__c = true);    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
             
            IPM_ProjectCountryDetails.updateCountriesToFinancials(countryList,false);
          
         
         
           
           List<IPM_Project_Rollout__c> projRollOutList = [Select Id from IPM_Project_Rollout__c where IPM_Project__c in :projectList limit 1000];
           System.debug(LoggingLevel.Error,'projRollOutListprojRollOutListprojRollOutList::'+projRollOutList);
           System.assertEquals(12,projRollOutList.size()); 
           test.stopTest();
         }
    }
 }