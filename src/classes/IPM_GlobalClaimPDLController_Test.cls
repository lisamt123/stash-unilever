/******************************************** 
*@Author:Cognizant
*@Date:14/10/2016
*@Description : Test class to test of IPM_GlobalClaimPDLController
**/
@isTest
private class IPM_GlobalClaimPDLController_Test{
    private static final string GLOBAL_PL_EMAIL_ID = 'globalProjectLeader@unilever.com.test';
    private static final string REGIONAL_PL_EMAIL_ID = 'regionalProjectLeader@unilever.com.test';
    private static final string LOCAL_PL_EMAIL_ID = 'localProjectLeader@unilever.com.test';
    private static Set<String> projectNameSet = new Set<String>{'GKM3TestComments1'};
    
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    * @name : initializeData
    * @param : void
    * @return :void
    */
    @testSetup public static void initializeData()
    {   
        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        List<User> userList = new List<User>();
        System.runAs(adminUser)
        {   
            User globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            globalProjectLeader.email = GLOBAL_PL_EMAIL_ID;

            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            regionalProjectLeader.email = REGIONAL_PL_EMAIL_ID;

            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
            localProjectLeader.email = LOCAL_PL_EMAIL_ID;

            userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};

            update userList;
        } 
        Test.startTest();
        List<String> emailList = new List<String>{GLOBAL_PL_EMAIL_ID,REGIONAL_PL_EMAIL_ID,LOCAL_PL_EMAIL_ID}; 
        User globalProjectLeader =null; User regionalProjectLeader =null;  User localProjectLeader =null;
        
        List<User> lstUsers = [Select Id,email from User where email in :emailList];
        for(User linkedUser : lstUsers){
            if(linkedUser.email == GLOBAL_PL_EMAIL_ID){
                globalProjectLeader = linkedUser;
            }else if(linkedUser.email == REGIONAL_PL_EMAIL_ID){
                regionalProjectLeader = linkedUser;
            }else{
                localProjectLeader = linkedUser;
            }
        }   
        // Create Company Card information 
        IPM_Company_Card__c globalCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3GlobalCompanyCard(false);
        IPM_Company_Card__c localCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3LocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCardGKM3,localCompanyCardGKM3};
        insert companyCardList;
         
        IPM_TestFactory_Helper.getProjectMasterDataForGKM3();
        
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader}); 
        
        
        System.runAs(globalProjectLeader){
            List<IPM_Project__c> projectListGKM3 = IPM_TestFactory_Helper.projectSetUpGKM3(1,globalProjectLeader);
            insert projectListGKM3;
            
            
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,projectListGKM3,new List<User>{userList[1],userList[1],userList[1]});
            
            insert regionalRolloutList;

            system.assert(regionalRolloutList.size()>0, 'project rollout cannot be created'); //names cannot be asserted as project name set in helper class
            
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

            set<Id> setIds = new set<Id>();  
 
            // Create local Rollouts for Created regional Rollouts.
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{localProjectLeader});  
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
                localRollout.IPM_Regional_PL__c = localProjectLeader.Id;
                localRollout.Target_Launch_Date__c = System.today().addMonths(10); //To cover 2523 line
                localRollout.Previous_Target_Launch_Date__c = System.today().addMonths(9); //To cover 2523 line
                setIds.add(localRollout.id);
            } 

            insert localRolloutList; 

            system.assertEquals(localRolloutList.size(), 2,'project rollout map cannot be created'); //names cannot be asserted as project and rollout map set in helper class
            test.stopTest();
            //assert preparation
            list<IPM_Project_Rollout__c> selRolloutList = [select KeyMCO__c, IPM_Regional_PL__c, IPM_Project_Job_Status__c, IPM_RolloutJobType__c, Target_Launch_Date__c, Previous_Target_Launch_Date__c from IPM_Project_Rollout__c where id in :setIds];
            for(IPM_Project_Rollout__c localRollout : selRolloutList)
            {
                system.assertEquals(localRollout.KeyMCO__c, true, 'Key MCO  is false');
                system.assertEquals(localRollout.IPM_Regional_PL__c, localProjectLeader.Id, 'Regional PL is null');
                system.assertEquals(localRollout.IPM_Project_Job_Status__c, IPM_ConstantUtils.JOB_STATUS_ELIGIBLE, 'Job Status not eligible found');
                system.assertEquals(localRollout.Previous_Target_Launch_Date__c, System.today(), 'target lanuch date is not today'); //To cover 2523 line
            }

            // Create Country specific information.
            insertCountry(localRolloutList, projectListGKM3);       
        }        
    }
    private static void insertCountry(List<IPM_Project_Rollout__c>  localRolloutList, List<IPM_Project__c> projectListGKM3){
            List<IPM_Country__c> countryList= new List<IPM_Country__c>(); 
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = IPM_ConstantUtils.BLANK; 
                if(localRollout.IPM_Rollout_Project__c.contains('AFR'))
                {
                    geoExternalId = 'AGO';
                }
                else if(localRollout.IPM_Rollout_Project__c.contains('LA'))
                {
                    geoExternalId = 'BRA';
                }
                
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new mdm_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
                
                countryList.add(tempCountry);
            }
            
            insert countryList;
            
            List<IPM_Project_Claim__c> lstProClaim = New List<IPM_Project_Claim__c>();
            for(IPM_Project__c pro : projectListGKM3 ){
                IPM_Project_Claim__c proClaim = New IPM_Project_Claim__c(IPM_Claim__c = 'test claim', IPM_Project__c = pro.Id);
                lstProClaim.add(proClaim );                
            }
            insert lstProClaim;
            
            List<IPM_Country_Level_Claim__c> lstCounrtyLevel = New List<IPM_Country_Level_Claim__c>();
        IPM_Country_Level_Claim__c ctryLvl = new IPM_Country_Level_Claim__c();
            for(IPM_Country__c cntry: countryList){
            
                for(IPM_Project_Claim__c pClaim : lstProClaim){
                    ctryLvl = New IPM_Country_Level_Claim__c(IPM_Claim__c = 'test claim', IPM_Country__c = cntry.Id, IPM_Project_Claim__c = pClaim.Id);                    
                }
                lstCounrtyLevel.add(ctryLvl );
            }
            
            insert lstCounrtyLevel;
            IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new mdm_Geography__c(ISO_3166_1_Code__c = 'BRA').Id,
                							IPM_Project__c = localRolloutList[0].IPM_Project__c,local_Rollout__c = localRolloutList[0].Id,IPM_Rollout_Status__c = 'With MCO');
            
            insert tempCountry;
            //assert on counti is sufficient, additional soql can be a risk for SOQL gov limit as this method has loads of queries.
            system.assert(countryList.size()>0, 'country records not created');
             
            
     
    }
    
    public static testMethod void prepareCountryClaimDetails(){
        
        List<String> emailList = new List<String>{GLOBAL_PL_EMAIL_ID,REGIONAL_PL_EMAIL_ID,LOCAL_PL_EMAIL_ID};
            
        User globalProjectLeader =null; User regionalProjectLeader =null;  User localProjectLeader =null;
        
        List<User> lstUsers = [Select Id,email from User where email in :emailList];
        for(User linkedUser : lstUsers)
        {
            if(linkedUser.email == GLOBAL_PL_EMAIL_ID)
            {
                globalProjectLeader = linkedUser;
            }
            else if(linkedUser.email == REGIONAL_PL_EMAIL_ID)
            {
                regionalProjectLeader = linkedUser;
            }
            else
            {
                localProjectLeader = linkedUser;
            }
        }          
        
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader}); 
         
        System.runAs(globalProjectLeader){       
            Test.startTest();
            
            Id locallRecordType = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).RecordTypeId;
            IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, 
                IPM_Target_Launch_Dates__c, IPM_Phase__c, IPM_ProjectGKM__c, IPM_GateKeeping_Model__c, IPM_CompanyCardText__c,
                (Select Id,Name,recordTypeId, IPM_Regional_PL__c,IPM_Project_Job_Status__c, IPM_RolloutJobType__c from IPM_Project_Rollout__r where recordTypeId =:locallRecordType )  
                FROM IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original' and Name='GKM3TestComments1' limit 1];

            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChangeForGKM3(new List<Id>{globalOriginal.Id},globalProjectLeader); 
              
            update projectListPhaseChange;
            Test.stopTest(); 
            List<IPM_Project__c> project = [Select Id, Name, IPM_Phase__c, IPM_Project_Job_Status__c, (Select Id from Project_Documents__r),
                                           (Select Id from IPM_Financials_Consolidated__r) from IPM_Project__c WHERE name in :projectNameSet Limit 1];
            
            
            System.assertEquals(project[0].IPM_Phase__c, 'Feasibility','Phase not changed');
            System.assertEquals(project[0].IPM_Project_Job_Status__c, 'Completed','Job not Completed');
            System.assertEquals(project[0].Project_Documents__r.size(), 3,'Documents not created');
            System.assertEquals(project[0].IPM_Financials_Consolidated__r.size(), 3,'Financial not created');            
            
            Apexpages.currentPage().getParameters().put('id',globalOriginal.Id);
            IPM_GlobalClaimPDLController GCPDLC = New IPM_GlobalClaimPDLController();
            GCPDLC.addProjectClaimsToAllCountries();
            GCPDLC.addProjectClaims();
            GCPDLC.doneEventHandling();
            GCPDLC.resetEventHandling();
            GCPDLC.autoSave();
            
            List<IPM_Project_Claim__c> lstProClaim = [SELECT Id FROM IPM_Project_Claim__c WHERE IPM_Project__c =: globalOriginal.Id];
            System.AssertNotEquals(lstProClaim.size(),0); 

            
            
        }        
    }
    
    public static testMethod void prepareCountryClaimDetailsLocalProject(){
        
        List<String> emailList = new List<String>{GLOBAL_PL_EMAIL_ID,REGIONAL_PL_EMAIL_ID,LOCAL_PL_EMAIL_ID};
            
        User globalProjectLeader =null; User regionalProjectLeader =null;  User localProjectLeader =null;
        List<User> lstUsers = [Select Id,email from User where email in :emailList];
        for(User linkedUser : lstUsers)
        {        
            if(linkedUser.email == GLOBAL_PL_EMAIL_ID)
            {
                globalProjectLeader = linkedUser;
            }
            else if(linkedUser.email == REGIONAL_PL_EMAIL_ID)
            {
                regionalProjectLeader = linkedUser;
            }
            else
            {
                localProjectLeader = linkedUser;
            }
        }          
        
        IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader}); 
         
        System.runAs(globalProjectLeader){       
            Test.startTest();
            
            Id locallRecordType = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get(IPM_ConstantUtils.LOCAL_ROLLOUT_RT).RecordTypeId;
            IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, 
                IPM_Target_Launch_Dates__c, IPM_Phase__c, IPM_ProjectGKM__c, IPM_GateKeeping_Model__c, IPM_CompanyCardText__c,
                (Select Id,Name, IPM_Regional_PL__c,Regional_Rollout__c,IPM_Project_Job_Status__c, IPM_RolloutJobType__c from IPM_Project_Rollout__r where recordTypeId =:locallRecordType )  
                FROM IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original' and Name='GKM3TestComments1' limit 1];

            List<IPM_Project__c> projectListPhaseChange = IPM_TestFactory_Helper.initiateProjectPhaseChangeForGKM3(new List<Id>{globalOriginal.Id},globalProjectLeader); 
              
            update projectListPhaseChange;
            Test.stopTest(); 
            List<IPM_Project__c> project = [Select Id, Name, IPM_Phase__c, IPM_Project_Job_Status__c, (Select Id from Project_Documents__r),
                                           (Select Id, Display_Name__c from IPM_Financials_Consolidated__r) from IPM_Project__c WHERE name in :projectNameSet Limit 1];
            
            
            System.assertEquals(project[0].IPM_Phase__c, 'Feasibility','Phase not changed');
            System.assertEquals(project[0].IPM_Project_Job_Status__c, 'Completed','Job not Completed');
            System.assertEquals(project[0].Project_Documents__r.size(), 3,'Documents not created');
            System.assertEquals(project[0].IPM_Financials_Consolidated__r.size(), 3,'Financial not created');   
            
            IPM_Project__c localPro = New IPM_Project__c ( Name = 'GKM3TestComments1_LA', IPM_Project_Name__c = 'GKM3TestComments1_LA',
            	IPM_Target_Launch_Dates__c = System.today().addMonths(6), IPMProject_Span__c ='Local' , IPM_Project_Leader__c =UserInfo.getUserId(),
            	IPM_Phase__c ='Feasibility',  IPM_Gatekeeping_model__c='GKM3',IPM_Category_Group__c = 'Personal Care',IPM_Project_Gatekeeper__c = UserInfo.getUserId()
            
            );
            
            insert localPro;
            
            IPM_Project_Rollout__c localRollout = globalOriginal.IPM_Project_Rollout__r[0];
            localRollout.Local_Project__c = localPro.Id;
            update localRollout;
            
            IPM_Financial__c localFin = New IPM_Financial__c(); 
            for(IPM_Financial__c fin : project[0].IPM_Financials_Consolidated__r){
            	if(fin.Display_Name__c.contains('GKM3TestComments1_LA')){
            		localFin = fin;
            		break;
            	}
            }
            if(localFin != NULL){
            	localFin.Local_Project__c= localPro.Id;
            	update localFin;
            }
            
            Apexpages.currentPage().getParameters().put('id',localPro.Id);
            IPM_GlobalClaimPDLController GCPDLC = New IPM_GlobalClaimPDLController();
            GCPDLC.addProjectClaims();
            List<IPM_Project_Claim__c> lstProClaim = [SELECT Id FROM IPM_Project_Claim__c WHERE IPM_Project__c =: globalOriginal.Id];
			GCPDLC.projClaimId = lstProClaim[0].Id;
            GCPDLC.deleteClaim();
        }        
    }
    
}