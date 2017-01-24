/******************************************** 
*@Author:Cognizant
*@Date:24/10/2016
*@Description : Test class to test of IPM_GlobalClaimPDLController
**/
@isTest
private class IPM_FinancialMisalignment_Test{
    private static final string GLOBAL_PL_EMAIL_ID = 'globalProjectLeader@unilever.com.test';
    private static final string REGIONAL_PL_EMAIL_ID = 'regionalProjectLeader@unilever.com.test';
    private static final string LOCAL_PL_EMAIL_ID = 'localProjectLeader@unilever.com.test';
    
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    * @name : initializeData
    * @param : void
    * @return :void
    */
    @testSetup public static void initializeData()
    {   
        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        Test.startTest();
        
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
            
            test.stopTest();
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
            
            //assert preparation
            list<IPM_Project_Rollout__c> selRolloutList = [select KeyMCO__c, IPM_Regional_PL__c, IPM_Project_Job_Status__c, IPM_RolloutJobType__c, Target_Launch_Date__c, Previous_Target_Launch_Date__c from IPM_Project_Rollout__c where id in :setIds];
            for(IPM_Project_Rollout__c localRollout : selRolloutList)
            {
                system.assertEquals(localRollout.KeyMCO__c, true, 'Key MCO  is false');
                system.assertEquals(localRollout.IPM_Regional_PL__c, localProjectLeader.Id, 'Regional PL is null');
                system.assertEquals(localRollout.IPM_Project_Job_Status__c, IPM_ConstantUtils.JOB_STATUS_ELIGIBLE, 'Job Status not eligible found');
                system.assertEquals(localRollout.Previous_Target_Launch_Date__c, System.today(), 'target lanuch date is not today'); //To cover 2523 line
            }
            
        }        
     
    }   
    
    public static testMethod void FinancialMisalignmentForGKM3(){
        
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
            IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_Project_Type__c, IPM_Phase__c, IPM_ProjectGKM__c, IPM_GateKeeping_Model__c,
							                (Select Id,Name, Regional_Rollout__c from IPM_Project_Rollout__r where recordTypeId =:locallRecordType )  
							                FROM IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original' and Name='GKM3TestComments1' limit 1];
			System.assertNotEquals(globalOriginal, Null, 'Project not created.');

            IPM_Project__c localPro = New IPM_Project__c ( Name = 'GKM3TestComments1_LA', IPM_Project_Name__c = 'GKM3TestComments1_LA',
                IPM_Target_Launch_Dates__c = System.today().addMonths(6), IPMProject_Span__c ='Local' , IPM_Project_Leader__c =UserInfo.getUserId(),
                IPM_Phase__c ='Feasibility',  IPM_Gatekeeping_model__c='GKM3',IPM_Category_Group__c = 'Personal Care',IPM_Project_Gatekeeper__c = UserInfo.getUserId()
            
            );
            
            insert localPro;
            
            IPM_Project_Rollout__c localRollout = globalOriginal.IPM_Project_Rollout__r[0];
            localRollout.Local_Project__c = localPro.Id;
            update localRollout;
            System.assertEquals(localRollout.Local_Project__c, localPro.Id, 'Rollout is not updated.');
            
            Id defaultFinlRecordType = Schema.SObjectType.IPM_Financial__c.RecordTypeInfosByName.get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).RecordTypeId;
            
            IPM_Financial__c defaultFin= IPM_TestFactory_Helper.createIPMFinancial(false);
            defaultFin.Local_Project__c= localPro.Id;
            defaultFin.recordTypeId = defaultFinlRecordType;
            defaultFin.Gate_Keeping_Model__c = IPM_ConstantUtils.GATE_KEEPING_MODEL_3;
            defaultFin.MisalignmentManual__c = true;
            defaultFin.IPM_Project_Rollout__c = localRollout.Regional_Rollout__c;
            
            IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION= true;
            insert defaultFin; 
            IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION =false; 
            
            IPM_FinancialMisalignment.postChatterIfLocalRegionalMisaligned(new List<Id> {localPro.Id});
            
        }        
    }
    
    public static testMethod void FinancialMisalignmentForNONGKM3(){
        
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
            IPM_Project__c globalOriginal = [select id, name, IPMProject_Span__c, IPM_Project_Type__c, IPM_Phase__c, IPM_ProjectGKM__c, IPM_GateKeeping_Model__c,
							                (Select Id,Name, Regional_Rollout__c from IPM_Project_Rollout__r where recordTypeId =:locallRecordType )  
							                FROM IPM_Project__c where IPMProject_Span__c='Global' and IPM_Project_Type__c='Original' and Name='GKM3TestComments1' limit 1];
			System.assertNotEquals(globalOriginal, Null, 'Project not created.');
			
            IPM_Project__c localPro = New IPM_Project__c ( Name = 'GKM3TestComments1_LA', IPM_Project_Name__c = 'GKM3TestComments1_LA',
                IPM_Target_Launch_Dates__c = System.today().addMonths(6), IPMProject_Span__c ='Local' , IPM_Project_Leader__c =UserInfo.getUserId(),
                IPM_Phase__c ='Feasibility',  IPM_Gatekeeping_model__c='GKM3',IPM_Category_Group__c = 'Personal Care',IPM_Project_Gatekeeper__c = UserInfo.getUserId()
            
            );            
            insert localPro;
            
            
            IPM_Project_Rollout__c localRollout = globalOriginal.IPM_Project_Rollout__r[0];
            localRollout.Local_Project__c = localPro.Id;
            update localRollout;
            System.assertEquals(localRollout.Local_Project__c, localPro.Id, 'Rollout is not updated.');
            
            Id defaultFinlRecordType = Schema.SObjectType.IPM_Financial__c.RecordTypeInfosByName.get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).RecordTypeId;
            
            IPM_Financial__c defaultFin= IPM_TestFactory_Helper.createIPMFinancial(false);
            defaultFin.Local_Project__c= localPro.Id;
            defaultFin.Regional_Project__c= localPro.Id;
            defaultFin.recordTypeId = defaultFinlRecordType;
            defaultFin.Gate_Keeping_Model__c = 'GKM1';
            defaultFin.MisalignmentManual__c = true;
            defaultFin.IPM_Project_Rollout__c = localRollout.Regional_Rollout__c;
            
            IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION= true;
            insert defaultFin; 
            IPM_FinancialHelper.SKIP_TRIGGER_EXECUTION =false; 
            
            
            
            IPM_FinancialMisalignment.postChatterIfLocalRegionalMisaligned(new List<Id> {localPro.Id});
            
        }        
    }
    
}