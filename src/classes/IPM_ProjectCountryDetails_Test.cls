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
    
    public static List<IPM_Project__c> ipmProjectList;
    public static List<IPM_Country__c> ipmCountryList;
    public static List<IPM_Project_Resource__c> projectResList;
    public static User adminUser;
    public static User standardUser;
    public static MDO_Geography__c geography, geography1;
    public static mdm_Geography__c mdm, mdm1;
    private static final String INSERT_EVENT = 'Insert';
    public static IPM_Project__c ipmProject ;
    public static List<IPM_Project__c> projectlist;
    public static List<User> userList;
    public static List<MDO_Geography__c> mdo_geoList;
    public static User platformUser;
    public static List<IPM_Company_Card__c> companyCardList; 
    public static List<IPM_Project_Document__c> projDocList;
    public static IPM_Project_Document_Section__c projDocSec;
   
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
            proj.Synced_From_EcoDesign_TimeStamp__c = System.now().addMinutes(15);
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

      }   
     

    /***********************************
      Description of the purpose of the method. 
      @name: testProjectCountryDetails
      @Description: To test various methods in ProjectCountryDetails
      @param: none
      @return: none
      @throws: none
    ***********************************/
    /*
    static testMethod void testProjectCountryDetails(){
        //createData();
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser){
            String countryField = 'Country_Code__c';
            projectlist = [SELECT Id,Name,IPM_Market_Type__c, IPM_Project_Type__c, IPMProject_Span__c FROM IPM_Project__c limit 1];
            projectResList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 5);
            for(Integer i = 0; i < projectResList.size(); i++){
                projectResList[i].IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_FINANCE;
                projectResList[i].IPM_Project_Role_Owner__c = true;
                projectResList[i].IPM_Project__c = projectlist[0].Id;
            }
            insert projectResList;
            
            //projectlist = [SELECT Id,Name,IPM_Market_Type__c, IPM_Project_Type__c, IPMProject_Span__c FROM IPM_Project__c limit 1]; 
            //system.assertEquals(projectlist[0].Id,ipmProjectList[0].Id);
            
            Set<Id> projIdSet = new Set<Id>();
            Map<Id,IPM_Project__c> projIdAffectedProjMap = new Map<Id,IPM_Project__c>();
            for(IPM_Project__c ipm:projectlist){
                projIdSet.add(ipm.Id);
                projIdAffectedProjMap.put(ipm.Id,ipm);
            }
                    
            Map<Id,List<IPM_Country__c>> projIdCountryListMap = new Map<Id,List<IPM_Country__c>>();
            projIdCountryListMap.put(projectlist[0].Id,ipmCountryList);
    
            IPM_ProjectCountryDetails.setSyncProjAftInsert(ipmCountryList);
            IPM_ProjectCountryDetails.notifyLeadRnD(ipmCountryList, INSERT_EVENT);
            IPM_ProjectCountryDetails.checkAtLeastOneAssmntPerEICountry(projIdCountryListMap.keySet());
            IPM_ProjectCountryDetails.checkIsEICountry(ipmCountryList);
            IPM_ProjectCountryDetails.getProjectIdCountryListMap(projIdSet);
            IPM_ProjectCountryDetails.getProjectIdToSyncMap(projIdSet);
            IPM_ProjectCountryDetails.getProjectMembersNames(projectResList);
            IPM_ProjectCountryDetails.isProjectReadyToSyncToEcoDesign(projectlist[0]);
            IPM_ProjectCountryDetails.getProjectIdCountriesMap(projIdCountryListMap, countryField);
            IPM_ProjectCountryDetails.fetchProjIdAffectedCountriesMap(ipmCountryList, projIdAffectedProjMap);
            IPM_ProjectCountryDetails.fetchProjIdAffectedProjMap(ipmCountryList);
            IPM_ProjectCountryDetails.updateCountriesToFinancials(ipmCountryList,false);
            //IPM_ProjectCountryDetails.getGlobalProjectIdFromCountries(ipmCountryList);
            //IPM_ProjectCountryDetails.getRegionalProjectIdFromCountries(ipmCountryList);
            //IPM_ProjectCountryDetails.getLocalProjectIdFromCountries(ipmCountryList);
            //IPM_ProjectCountryDetails.getAllProjectIdFromCountries(ipmCountryList);
    
            delete ipmCountryList[2];
            IPM_ProjectCountryDetails.setSyncProjectAftDelete(ipmCountryList);
        }
        

    }
    */
    /***********************************
      Description of the purpose of the method. 
      @name: testCountryUpdate
      @Description: Method to check that sync project flag is set when the project lookup on the country changes
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
                proj.IPM_Strategic_Intent__c = 'test1';
            }
            
            update toUpdateProjList;
            
            IPM_Project__c globalProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            globalProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            globalProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            globalProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
            globalProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            globalProjNew.IPM_Exists_AtLeast_OneAssmntPerEICountry__c = true;
            globalProjNew.IPM_Strategic_Intent__c = 'test1';
            insert globalProjNew;
                    
            IPM_Project__c regionalProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            regionalProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            regionalProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            regionalProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            regionalProjNew.IPM_Parent_Project__c = globalProjNew.Id;
            regionalProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            regionalProjNew.IPM_Strategic_Intent__c = 'test1';
            insert regionalProjNew;
            
            IPM_Project__c localProjNew = IPM_TestFactory_Helper.createIPMProject(false);
            localProjNew.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
            localProjNew.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
            localProjNew.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
            localProjNew.IPM_Parent_Project__c = regionalProjNew.Id;
            localProjNew.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
            localProjNew.IPM_Strategic_Intent__c = 'test1';
            insert localProjNew;
            
            mdm_Geography__c geo = new mdm_Geography__c(name = 'France');
                insert geo;      
            List<IPM_Country__c> countryList = new List<IPM_Country__c>();
                for(integer i=0; i<4 ; i++) {
                    IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = geo.Id,
                    IPM_Project__c = toUpdateProjList[i].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                    IS_EI_Country__c = true);    
                
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
               
            IPM_Project__c updatedCountry = [Select Id,First_Sync_To_EcoDesign__c,EcoDesign_Sync_Status__c from IPM_Project__c Limit 1][0];
            System.assertEquals('Ready',updatedCountry.EcoDesign_Sync_Status__c);
                
        }
    }
    
    
    /***********************************
      Description of the purpose of the method. 
      @name: testCountryUpdate
      @Description: Method to check that sync project flag is set when the project lookup on the country changes
      @param: none
      @return: none
      @throws: none
    ***********************************/
   
    static testMethod void testAtLeastOneAssmnt(){
        
        User globalUser = [Select Id,LastName from User where LastName='PLATFORM_USER' limit 1];
        System.runAs(globalUser){
            
            IPM_Project__c projToUpdate = [Select id, IPM_Exists_AtLeast_OneAssmntPerEICountry__c from IPM_Project__c limit 50000][0];
            projectList = [Select id, IPM_Exists_AtLeast_OneAssmntPerEICountry__c from IPM_Project__c limit 50000];
            projToUpdate.IPM_Exists_AtLeast_OneAssmntPerEICountry__c = true;
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
                  IS_EI_Country__c = true);
            insert tempCountry;
            
            IPM_Assessment__c assessment1 = IPM_TestFactory_Helper.createAssessments(false, projToUpdate.id, tempCountry.id,IPM_ConstantUtils.PHASE_IDEAS );      

            insert assessment1;
            delete assessment1;
            
            
            IPM_Country__c tempCountry2 = new  IPM_Country__c(
                  IPM_Project__c = projectList[0].id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO,
                  IS_EI_Country__c = false);
           insert tempCountry2;
           
           IPM_Project__c projToCheck = [Select id, IPM_Exists_AtLeast_OneAssmntPerEICountry__c from IPM_Project__c Where Id =:projectList[0].Id limit 1][0];
           System.assertEquals(false,projToCheck.IPM_Exists_AtLeast_OneAssmntPerEICountry__c);
        }
        
            
    }
    
    /*

    public static testmethod void countrySetUp() 
     {
        
         userList = IPM_TestFactory_Helper.createUserList();
            
         IPM_TestFactory_Helper.getProjectMasterData();
         List<IPM_Country__c> countryList;  
         projectList = IPM_TestFactory_Helper.projectSetUp(3,userList[0]);
         System.runAs(userList[0])
         {
           insert projectList;
         }
         
         
         System.runAs(userList[0])
         {   
            
            
           
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
                
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = IPM_ConstantUtils.ROLLOUT_STATUS_WITH_MCO);    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
             
             IPM_ProjectCountryDetails.updateCountriesToFinancials(countryList,false);
          
         
           List<IPM_Project__c> regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(1,UserList[1]);
         
           System.runAs(userList[1])
           {
            insert regionalProjectList;
           }
   
    }
    
    */
 }