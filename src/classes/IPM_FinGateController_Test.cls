/**
* @author       Cognizant 
* @date         15/04/2015
* @description  This class is used to test the functionality of IPM_FileUploadController class 
*/
@isTest
public class IPM_FinGateController_Test {
    
    public static IPM_Project__c project;
    public static IPM_Financial_File__c finFile;
    private static user testUser;
    private static List<IPM_Project__c>projectList=new list<IPM_Project__c>();
    private static string projectId;
    private static List<user>userList=new List<user>();
    public static IPM_Financial__c financial;
    
    
    //public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static List<IPM_Financial_Year__c> lstFinancialYear=new List<IPM_Financial_Year__c>();
    
    private static string RECORD_TYPE_ID = 'RecordTypeId';
    private static string IPM_ROLLOUT_PROJECT = 'IPM_Rollout_Project__c';
    private static string IPM_PROJECT = 'IPM_Project__c';
    private static string IPM_REGIONAL_PL = 'IPM_Regional_PL__c';
    private static string MARKET_CLUSTER_NAME = 'Market_Cluster_Name__c';
    private static string MARKET_CLUSTER = 'Market_Cluster__c';
    private static string TARGET_LAUNCH_DATE = 'Target_Launch_Date__c';
    /*******************************************************************************************************
    * @description  Test Method to initialize data for test methods
    */
    public static void initializeData(){
         //test.startTest(); 
        Profile p = [SELECT Id FROM Profile WHERE Name='IPM NG Basic']; 
        
        testUser=IPM_TestFactory_Helper.createUser(false);
        testUser.profileId = p.id;
        insert testUser;
        userList.add(testUser);
        List<User>userLists=[SELECT id FROM user WHERE id=:testUser.id LIMIT 1];
        System.AssertEquals(userLists[0].id, testUser.id,'User not found');
        system.runAs(testUser){
        IPM_Project__c projectRecord = IPM_TestFactory_Helper.createIPMProject(FALSE);
        projectRecord.Name = 'DEF1153BLOC';
        projectRecord.IPM_Project_Name__c = 'DEF1153BLOC';
        projectRecord.Sustainability_Period__c = '3';
        projectRecord.IPMProject_Span__c = 'Global';
        projectRecord.IPM_Project_Type__c = 'Original';
        projectRecord.IPM_Target_Launch_Dates__c = Date.newInstance(2020, 04, 07);
        projectRecord.IPM_Project_Leader__c = testUser.Id;
        projectRecord.IPM_Phase__c = 'Ideas';
        insert projectRecord;
        projectList.add(projectRecord);
        List<IPM_Project__c> projlList=[SELECT ID,Name,IPM_Phase__c,IPM_Project_Name__c,IPM_Complexity__c,IPM_GateKeeping_Model__c, IPM_SourceProjectType__c, IPM_Project_Type__c FROM IPM_Project__c WHERE ID=:projectRecord.ID LIMIT 1];
        project=projlList[0];
        projectId=projlList[0].Id;
        System.assertEquals(projlList[0].id,projectRecord.id);//positive test
        
        /*financial = IPM_TestFactory_Helper.createIPMFinancial(false);
        financial.Financial_External_ID__c = projlList[0].IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
        insert financial;*/
        projectList = IPM_TestFactory_Helper.insertIPMProjectList();
        lstFinancial = IPM_TestFactory_Helper.insertIPMFinancialList();
        //for(integer i=0; i<lstFinancial.size(); i++){
        	lstFinancial[0].Financial_External_ID__c = project.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
        	update lstFinancial[0];
        //}
        lstFinancialYear = IPM_TestFactory_Helper.insertIPMFinancialYearList();
        
        for(integer i=0; i<lstFinancialYear.size(); i++){
        	lstFinancialYear[i].year__c = string.valueOf(i);
        }
        update lstFinancialYear;
        /*List<IPM_Project__Share>projectShareList=IPM_TestFactory_Helper.shareIPMProject(projectList,userList);
        insert projectShareList;
        list<IPM_Project__Share>shareList=[SELECT ParentId,UserOrGroupId FROM IPM_Project__Share WHERE ParentId=:projectRecord.id AND UserOrGroupId=:testUser.id LIMIT 1];
        system.assertEquals(shareList[0].UserOrGroupId,testUser.id,testUser.id+'User should have edit access to project');//positive test*/
        
        /*if(projectId.length() > 15)
            projectId = projectId.subString(0,15);
        IPM_ProcessFinancials.processProjectFinancials(new Set<String>{projectId}, new Set<String>{projectId + '_3_3'});*/
        
        //financial = IPM_TestFactory_Helper.createIPMFinancial(true);
                                
        String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();
        String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();
        
        List<IPM_Project_Rollout__c> lstInsertRegionalRollouts = new List<IPM_Project_Rollout__c>();
        List<IPM_Project_Rollout__c> lstInsertLocalRollouts = new List<IPM_Project_Rollout__c>();
        
        Map<String,List<Object>> InsertRegionalRolloutsMap =  new Map<String,List<Object>>{
        RECORD_TYPE_ID => new List<Object>{REGIONAL_ROLLOUT_RECORDTYPE,REGIONAL_ROLLOUT_RECORDTYPE},
        IPM_ROLLOUT_PROJECT => new List<Object>{'DEF1153BLOC_SEAA','DEF1153BLOC_EUR'},
        IPM_PROJECT => new List<Object>{project.ID,project.ID},
        IPM_REGIONAL_PL => new List<Object>{testUser.Id,testUser.Id},
        MARKET_CLUSTER_NAME => new List<Object> {'SEAA','Europe'},
        MARKET_CLUSTER => new List<Object>{'GEO0022','GEO0069'},
        TARGET_LAUNCH_DATE => new List<Object>{Date.newInstance(2020, 04, 07),Date.newInstance(2020, 04, 07)}
        };

        lstInsertRegionalRollouts= (List<IPM_Project_Rollout__c>)IPM_TestFactory.createSObjectList('IPM_Project_Rollout__c',InsertRegionalRolloutsMap,true);
        insert lstInsertRegionalRollouts;
        
        Map<String,List<Object>> InsertLocalRolloutsMap =  new Map<String,List<Object>>{
        RECORD_TYPE_ID => new List<Object>{LOCAL_ROLLOUT_RECORDTYPE,LOCAL_ROLLOUT_RECORDTYPE},
        IPM_ROLLOUT_PROJECT => new List<Object>{'DEF1153BLOC_SEAA_ANZ','DEF1153BLOC_EUR_DACH'},
        'Regional_Rollout__r' => new List<Object>{new IPM_Project_Rollout__c(IPM_Rollout_Project__c = 'DEF1153BLOC_SEAA'),new IPM_Project_Rollout__c(IPM_Rollout_Project__c = 'DEF1153BLOC_EUR')},
        IPM_PROJECT => new List<Object>{project.ID,project.ID},
        'Type__c' => new List<Object>{'MCO','MCO'},
        'KeyMCO__c' => new List<Object>{true,false},
        MARKET_CLUSTER_NAME => new List<Object> {'SEAA','EUR'},
        MARKET_CLUSTER => new List<Object> {'GEO0022','GEO0069'},
        'MCO__c' => new List<Object>{'LV4_GEO0041','LV4_GEO0029'},
        'MCO_Name__c' => new List<Object>{'ANZ','DACH'},
        TARGET_LAUNCH_DATE => new List<Object>{Date.newInstance(2020, 04, 07),Date.newInstance(2020, 04, 07)}
        };

        lstInsertLocalRollouts= (List<IPM_Project_Rollout__c>)IPM_TestFactory.createSObjectList('IPM_Project_Rollout__c',InsertLocalRolloutsMap,true);
        insert lstInsertLocalRollouts;
        }
        /*Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = IPM_TestFactory_Helper.createUser(FALSE);
        testUser.ProfileId = p.Id; 
       
        
        project= IPM_TestFactory_Helper.createIPMProject(FALSE);
        project.Name = 'DEF1153BLOC';
        project.IPM_Project_Name__c = 'DEF1153BLOC';
        project.Sustainability_Period__c = '3';
        project.IPMProject_Span__c = 'Global';
        project.IPM_Project_Type__c = 'Original';
        project.IPM_Target_Launch_Dates__c = Date.newInstance(2020, 04, 07);
        project.IPM_Project_Leader__c = testUser.Id;
        project.IPM_Phase__c = 'Ideas';
        insert project;
        String projectId = project.Id;
        if(projectId.length() > 15)
            projectId = projectId.subString(0,15);
        IPM_ProcessFinancials.processProjectFinancials(new Set<String>{projectId}, new Set<String>{projectId + '_3_3'});
                                
        String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();
        String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();
        
        List<IPM_Project_Rollout__c> lstInsertRegionalRollouts = new List<IPM_Project_Rollout__c>();
        List<IPM_Project_Rollout__c> lstInsertLocalRollouts = new List<IPM_Project_Rollout__c>();
        
        
        Map<String,List<Object>> InsertRegionalRolloutsMap =  new Map<String,List<Object>>{
        'RecordTypeId' => new List<Object>{REGIONAL_ROLLOUT_RECORDTYPE,REGIONAL_ROLLOUT_RECORDTYPE},
        'IPM_Rollout_Project__c' => new List<Object>{'DEF1153BLOC_SEAA','DEF1153BLOC_EUR'},
        'IPM_Project__c' => new List<Object>{project.ID,project.ID},
        'IPM_Regional_PL__c' => new List<Object>{testUser.Id,testUser.Id},
        'Market_Cluster_Name__c' => new List<Object> {'SEAA','Europe'},
        'Market_Cluster__c' => new List<Object>{'GEO0022','GEO0069'},
        'Target_Launch_Date__c' => new List<Object>{Date.newInstance(2020, 04, 07),Date.newInstance(2020, 04, 07)}
        };

        lstInsertRegionalRollouts= (List<IPM_Project_Rollout__c>)IPM_TestFactory.createSObjectList('IPM_Project_Rollout__c',InsertRegionalRolloutsMap,true);
        
        insert lstInsertRegionalRollouts;
        
        Map<String,List<Object>> InsertLocalRolloutsMap =  new Map<String,List<Object>>{
        'RecordTypeId' => new List<Object>{LOCAL_ROLLOUT_RECORDTYPE,LOCAL_ROLLOUT_RECORDTYPE},
        'IPM_Rollout_Project__c' => new List<Object>{'DEF1153BLOC_SEAA_ANZ','DEF1153BLOC_EUR_DACH'},
        'Regional_Rollout__r' => new List<Object>{new IPM_Project_Rollout__c(IPM_Rollout_Project__c = 'DEF1153BLOC_SEAA'),new IPM_Project_Rollout__c(IPM_Rollout_Project__c = 'DEF1153BLOC_EUR')},
        'IPM_Project__c' => new List<Object>{project.ID,project.ID},
        'Type__c' => new List<Object>{'MCO','MCO'},
        'KeyMCO__c' => new List<Object>{true,false},
        'Market_Cluster_Name__c' => new List<Object> {'SEAA','EUR'},
        'Market_Cluster__c' => new List<Object> {'GEO0022','GEO0069'},
        'MCO__c' => new List<Object>{'LV4_GEO0041','LV4_GEO0029'},
        'MCO_Name__c' => new List<Object>{'ANZ','DACH'},
        'Target_Launch_Date__c' => new List<Object>{Date.newInstance(2020, 04, 07),Date.newInstance(2020, 04, 07)}
        };

        lstInsertLocalRollouts= (List<IPM_Project_Rollout__c>)IPM_TestFactory.createSObjectList('IPM_Project_Rollout__c',InsertLocalRolloutsMap,true);
        
        insert lstInsertLocalRollouts;*/
        //test.stopTest(); 
        
    }
    /*******************************************************************************************************
    * @description  Test Method to test IPM_FinGateController methods
    */
    static testMethod void runFinGateTest(){
        initializeData();
        system.runAs(testUser){
            IPM_FinGateController finGate=new IPM_FinGateController();
            system.debug('project --> ' + project);
            //finGate.project=project;
            finGate.projectId=project.ID;
            
            finGate.financialsCalendar= new IPM_FinancialWrapper();
            finGate.financialsInnovation= new IPM_FinancialWrapper();
            system.debug('project --> ' + project.Id);
            finGate.setprojectId(project.ID);
            finGate.getprojectId();
            system.assert(finGate.sustainabilityPeriod == 3, 'sustainabilityPeriod is set as wrong'); 
            system.assert(finGate.colSpan == 7, 'colSpan is set as wrong');         
            system.assert(finGate.fieldSuffix == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, 'fieldSuffix is set as wrong');
            List<IPM_Financial__c> lstConsolidatedFinancial = [SELECT Id FROM IPM_Financial__c WHERE Financial_External_Id__c = 'DEF1153BLOC_CONSOLIDATED' LIMIT 1];
            System.assertEquals(lstConsolidatedFinancial.size(), 1, 'Financial not generated properly');
        }
    }
    
    static testMethod void runFinGateTest1(){
        initializeData();
        system.runAs(testUser){
            IPM_FinGateController finGate=new IPM_FinGateController();
            finGate.project=project;
            finGate.projectId=project.ID;
            
            finGate.financialsCalendar= new IPM_FinancialWrapper();
            finGate.financialsInnovation= new IPM_FinancialWrapper();
            finGate.getprojectId();
            ApexPages.currentPage().getParameters().put('printDoc', IPM_ConstantUtils.CHARTER_GATE);
            finGate.setprojectId(project.ID);
            system.assert(finGate.sustainabilityPeriod == 3, 'sustainabilityPeriod is set as wrong'); 
            system.assert(finGate.colSpan == 7, 'colSpan is set as wrong');         
            system.assert(finGate.fieldSuffix == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, 'fieldSuffix is set as wrong');
            List<IPM_Financial__c> lstConsolidatedFinancial = [SELECT Id FROM IPM_Financial__c WHERE Financial_External_Id__c = 'DEF1153BLOC_CONSOLIDATED' LIMIT 1];
            System.assertEquals(lstConsolidatedFinancial.size(), 1, 'Financial not generated properly');
            
            //test IPM_FunnelController
            
            /*IPM_FunnelController funnelController = new IPM_FunnelController ();
            funnelController.project = project;
            List<string> a = funnelController.getAssociatedProjectPhases();
            system.debug(logginglevel.error, 'a--> ' + a);*/
        }
    }
}