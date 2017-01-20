@isTest
public class IPM_ChangProjectDocStatusCntrlGKM3_Test {
     private static PageReference  pRef;
    private static final string GLOBAL_PL_EMAIL_ID = 'globalProjectLeader@unilever.com.test';
    private static final string REGIONAL_PL_EMAIL_ID = 'regionalProjectLeader@unilever.com.test';
    private static final string LOCAL_PL_EMAIL_ID = 'localProjectLeader@unilever.com.test';
    private static Set<String> projectNameSet = new Set<String>{'GKM3TestComments1'};
    /*************************************************************************************************************************
    * @description Test Data
    */
    @testSetup static void initializeData(){
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
        
        for(User linkedUser : [Select Id,email from User where email in :emailList]){
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

            system.assert(countryList.size()>0, 'country records not created');
             
            test.stopTest();
        }     
    }

    
    private static testmethod void testcheckPDLIsApproved(){
       List<String> emailList = new List<String>{GLOBAL_PL_EMAIL_ID,REGIONAL_PL_EMAIL_ID,LOCAL_PL_EMAIL_ID};
            
        User globalProjectLeader =null; User regionalProjectLeader =null;  User localProjectLeader =null;
        
        for(User linkedUser : [Select Id,email from User where email in :emailList])
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
            
            IPM_Milestone__c milestone = IPM_TestFactory_Helper.createIPMMilestone(project[0].Id, FALSE);
            milestone.IPM_Name__c = IPM_ConstantUtils.PRODUCT_DESIGN_LOCK_DOCUMENT;
            insert milestone;
            pRef = Page.IPM_ProjectDocumentSectionEditor;
            pRef.getParameters().put('id', project[0].Id);
            Test.setCurrentPage(pRef);
            IPM_ChangProjectDocumentStatusController chngPro=new IPM_ChangProjectDocumentStatusController();
            
            chngPro.milestoneList.add(milestone);
            chngPro.projSectionListUpdate.clear();
            chngPro.Status = IPM_ConstantUtils.STATUS_APPROVED;
            chngPro.checkPDLIsApproved();
       		chngPro.approvePDLDocument();
       		
       		System.assertEquals(chngPro.isPDLApproved, true,'PDLI Approved');
       		
       		
       	    pRef = Page.IPM_GateDocument;
            pRef.getParameters().put(IPM_ConstantUtils.SF_ID, project[0].Id);
            pRef.getParameters().put('printDoc', IPM_ConstantUtils.PRODUCT_DESIGN_LOCK);
            Test.setCurrentPage(pRef);
            
            IPM_GateDocumentController ipmGateDocCtrl=new IPM_GateDocumentController();
            ipmGateDocCtrl.isPDLApproved = true; 
            ipmGateDocCtrl.projectDoc.IPM_Document_Status__c = IPM_ConstantUtils.STATUS_APPROVED;            
            
        } 
       
    }
}