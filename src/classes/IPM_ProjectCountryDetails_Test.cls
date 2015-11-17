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
   
        
     /***********************************
      Description of the purpose of the method. 
      @name: createData
      @Description: Create a user,project,Country,geography and rollout
      @param: none
      @return: none
      @throws: none
    ***********************************/
    static void createData(){
        
     // Current running in Sharing mode with old sharing logic. Using System admin profile for time being.
        User globalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        globalUser.email = 'globalUser@unilever.test.com';
         
        User regionalUser = IPM_TestFactory_Helper.createUserAdmin(false);
        regionalUser.email = 'regionalUser@unilever.test.com';
        
        User localUser = IPM_TestFactory_Helper.createUserAdmin(false);
        localUser.email = 'localUser@unilever.test.com';
        
        userList = new List<User>{globalUser,regionalUser,localUser};
                
        List<IPM_Assessment__c> finalAssessmentList = new List<IPM_Assessment__c>();
        List<IPM_Company_Card__c> companyCardList ;
        
        
        System.runAs(userList[0]) {
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
        globalCompanyCard.IPM_TxtGeographical_Scope__c = 'TEST123';
        globalCompanyCard.IPM_Business_Partner__c = NULL;
        IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
        regionalCompanyCard.IPM_TxtGeographical_Scope__c = 'TEST123';
        regionalCompanyCard.IPM_Business_Partner__c = NULL;
        IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
        localCompanyCard.IPM_TxtGeographical_Scope__c = 'TEST123';
        localCompanyCard.IPM_Business_Partner__c = NULL;
        
        companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
        insert companyCardList;
        }
        Test.startTest();
        System.runAs(userList[1]) {
        //  Create User profile Information
        Map<String,List<Object>> IPMUserProfileMap =  new Map<String,List<Object>>{
        'IPM_Business_Partner__c' => new List<Object>{false,false,false},
        'IPM_Category__c' => new List<Object>{'','',''},
        'IPM_Central_Team__c' => new List<Object>{false,false,false},
        'IPM_Finance_Member__c' => new List<Object>{false,false,false},
        'IPM_GateKeeper__c' => new List<Object>{false,false,false},
        'IPM_Project_Leader__c' => new List<Object>{false,false,false},
        'IPM_User_Category__c' => new List<Object>{'HHC','HHC','HHC'},
        'IPM_User_Function__c' => new List<Object>{'Project Leader','Project Leader','Project Leader'},
        'IPM_User_Role__c' => new List<Object>{'MO','MO','MO'},
        'IPM_Work_Level__c' => new List<Object>{'WL1','WL2','WL3'},
        'IPM_Company_Card__c' => new List<Object>{companyCardList[0].Id,companyCardList[1].Id,companyCardList[2].Id},
        'IPM_User__c' => new List<Object>{userList[0].Id,userList[1].Id,userList[2].Id}
        };

        List<IPM_User_Profile__c> userProfileList = (List<IPM_User_Profile__c>)IPM_TestFactory.createSObjectList('IPM_User_Profile__c',IPMUserProfileMap,true);
        List<String> projectNames = new List<String>();
        
            // Get master data for the project including Templates,Documents,Section,Tasks and Milestones.
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Create project for assignment.
            ipmProjectList = IPM_TestFactory_Helper.createOriginalProjectList(false, 1);
            for(IPM_Project__c project : ipmProjectList) {
                project.IPM_Company_Card__c = companyCardList[0].Id;
                project.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
                project.IPM_Project_Leader__c = userList[0].Id;
                project.Success_Timestamp_EcoDesign__c = System.now().addMinutes(15);
                project.IPM_SourceProjectType__c = 'Original';
                projectNames.add(project.IPM_Project_Name__c); 
                //projectNames.IPM_Project_Resource__r.IPM_Role_Type__c = IPM_ConstantUtils.PROJECT_LEADER;
                
            }
        
            insert ipmProjectList;
        }
        Test.stopTest();      
        // At this point Async process kicks in and starts creating Related Object information.    
        // Create Country specific information.
        mdo_geoList = new List<MDO_Geography__c>();
        MDO_Geography__c geo;
        ipmCountryList= new List<IPM_Country__c>();
        System.runAs(userList[0]) {
      for(integer i=0 ;i<10 ;i++) {
        geo = new MDO_Geography__c(name = 'Test'+i);
        mdo_geoList.add(geo);  
      }
      
            
        insert mdo_geoList;      
            for(integer i=0; i<10 ; i++) {
              if(i < 7) {
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
                  IPM_Project__c = ipmProjectList[0].id,IPM_Rollout_Status__c = 'With MCO',
                  IS_EI_Country__c = true);    
                ipmCountryList.add(tempCountry);
              }
              else {
                IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[i].Id,
                  IPM_Project__c = ipmProjectList[0].id,IPM_Rollout_Status__c = 'With MCO',
                  IS_EI_Country__c = false);    
                ipmCountryList.add(tempCountry);
              }
            }
            
            insert ipmCountryList;
            
            MDO_Market__c mkt = new  MDO_Market__c(Type__c = 'Emerging');
       	    insert mkt;
     	    MDO_MarketGeographys__c mktGeo = new  MDO_MarketGeographys__c(Market_ID__c = mkt.Id, Geography_ID__c = mdo_geoList[0].Id);
		    insert mktGeo; 	
            
      integer cnt = 1;
      for(IPM_Country__c countryEle : ipmCountryList) {
              if((cnt < 3 && countryEle.IS_EI_Country__c) || (cnt > 6 && !countryEle.IS_EI_Country__c)) {
                    IPM_Assessment__c assessment = IPM_TestFactory_Helper.createAssessments(false, ipmProjectList[0].id, countryEle.id,IPM_ConstantUtils.PHASE_IDEAS );

		            if(cnt == 1 || cnt == 9) {
		              assessment.IPM_Is_Lead_Assessment__c = true;
		            }
		            else {
		              assessment.IPM_Is_Lead_Assessment__c = false;
		            }
		            finalAssessmentList.add(assessment);
              }
              cnt++;
          }    
      insert finalAssessmentList;
            
        }
    }
    
    /***********************************
      Description of the purpose of the method. 
      @name: testProjectCountryDetails
      @Description: To test various methods in ProjectCountryDetails
      @param: none
      @return: none
      @throws: none
    ***********************************/
    
    static testMethod void testProjectCountryDetails(){
        createData();

        String countryField = 'Country_Code__c';
        
        projectResList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 5);
        for(Integer i = 0; i < projectResList.size(); i++){
            projectResList[i].IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_FINANCE;
            projectResList[i].IPM_Project_Role_Owner__c = true;
            projectResList[i].IPM_Project__c = ipmProjectList[0].Id;
        }
        insert projectResList;
        
        projectlist = [SELECT Id,Name,IPM_Market_Type__c, IPM_Project_Type__c, IPMProject_Span__c FROM IPM_Project__c WHERE id =:ipmProjectList[0].Id limit 1]; 
        system.assertEquals(projectlist[0].Id,ipmProjectList[0].Id);
        
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
        IPM_ProjectCountryDetails.isProjectReadyToSyncToEcoDesign(ipmprojectlist[0]);
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
    
    /***********************************
      Description of the purpose of the method. 
      @name: testCountryUpdate
      @Description: Method to check that sync project flag is set when the project lookup on the country changes
      @param: none
      @return: none
      @throws: none
    ***********************************/
    static testMethod void testCountryUpdate(){
        
        createData();
        List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();
        toUpdateProjList = [Select Id,IPM_Strategic_Intent__c from IPM_Project__c where IPM_Project_Type__c =:IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL];
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
            
        IPM_Country__c toUpdateCountry = [Select Id,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c from IPM_Country__c where IS_EI_Country__c = true][0];
            
        toUpdateCountry.IPM_Project__c = globalProjNew.Id ;
        update toUpdateCountry;
            
        IPM_Country__c toUpdateCountry1 = [Select Id,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c from IPM_Country__c where IS_EI_Country__c = true][0];
        
        toUpdateCountry1.IPM_Regional_Project__c = regionalProjNew.Id ;
        update toUpdateCountry1;
            
        IPM_Country__c toUpdateCountry2 = [Select Id,IPM_Project__c,IPM_Regional_Project__c,IPM_Local_Project__c from IPM_Country__c where IS_EI_Country__c = true][0];
        toUpdateCountry2.IPM_Local_Project__c = localProjNew.Id ;
        update toUpdateCountry2;

        //to check for instance variables
        IPM_ProjectCountryDetails ipcd = new IPM_ProjectCountryDetails();
        System.assertEquals(false,ipcd.isGlobalDeveloped);
            
        IPM_Project__c updatedCountry = [Select Id,First_Sync_To_EcoDesign__c,EcoDesign_Sync_Status__c from IPM_Project__c where Id =:globalProjNew.Id][0];
        System.assertEquals('Ready',updatedCountry.EcoDesign_Sync_Status__c);
            
       
        delete toUpdateCountry;
            
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
        
        createData();
        System.runAs(userList[0]){
            
            IPM_Project__c projToUpdate = [Select id, IPM_Exists_AtLeast_OneAssmntPerEICountry__c from IPM_Project__c Where Id =:ipmProjectList[0].Id][0];
            
            projToUpdate.IPM_Exists_AtLeast_OneAssmntPerEICountry__c = true;
            update projToUpdate;
            
            projectResList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 5);
            for(Integer i = 0; i < projectResList.size(); i++){
                projectResList[i].IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_FINANCE;
                projectResList[i].IPM_Project_Role_Owner__c = true;
                projectResList[i].IPM_Project__c = ipmProjectList[0].Id;
            }
            insert projectResList;
            Set<Id> projIdSet = new Set<Id>();
            for(IPM_Project__c proj : ipmProjectList){
                projIdSet.add(proj.Id);
            }
            Map<Id,List<IPM_Project_Resource__c>> projMembersmap = IPM_ProjectCountryDetails.getProjectIdMembersListMap(projIdSet, 'All');
            for(Id projId: projIdSet){
                IPM_ProjectCountryDetails.getProjectMembersNames(projMembersmap.get(projId));
            }
            
            
            List<IPM_Country__c> countries = [Select Id from IPM_Country__c where IPM_Project__c =:ipmProjectList[0].Id];
            delete countries;
            
            IPM_Country__c tempCountry = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[0].Id,
                  IPM_Project__c = ipmProjectList[0].id,IPM_Rollout_Status__c = 'With MCO',
                  IS_EI_Country__c = true);
            insert tempCountry;
            
            IPM_Assessment__c assessment1 = IPM_TestFactory_Helper.createAssessments(false, projToUpdate.id, tempCountry.id,IPM_ConstantUtils.PHASE_IDEAS );      

            insert assessment1;
            delete assessment1;
            
            
            IPM_Country__c tempCountry2 = new  IPM_Country__c(MDO_Geography__c = mdo_geoList[0].Id,
                  IPM_Project__c = ipmProjectList[0].id,IPM_Rollout_Status__c = 'With MCO',
                  IS_EI_Country__c = false);
           insert tempCountry2;
           
           IPM_Project__c projToCheck = [Select id, IPM_Exists_AtLeast_OneAssmntPerEICountry__c from IPM_Project__c Where Id =:ipmProjectList[0].Id][0];
           System.assertEquals(true,projToCheck.IPM_Exists_AtLeast_OneAssmntPerEICountry__c);
        }
        
            
    }

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
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
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
 }  
   
  
   
   
   
   
   
   
   
   
   
   
   
   
   
    
}