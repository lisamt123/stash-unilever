@isTest
public class IPM_FinGateController_Test {
    
    public static IPM_Project__c project;
    public static IPM_Financial_File__c finFile;
   // public static IPMFinancialWrapper;
    
    static testMethod void initializeData()
    {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User testUser = new User(
            Alias = 'standt4', 
            Email='standarduser@testorg4.com', 
            EmailEncodingKey='UTF-8', 
            LastName='Testing4', 
            LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='standarduser@testorg4.com', 
            IPM_Category__c = 'test4', 
            IPM_Brand_Positioning__c= 'test4',
            IPM_Brand_Name__c ='test1',
            IPM_Role__c='Gate Keeper',
            IPM_Sub_Category__c='test', 
            isActive =true
        );
        insert testUser;

        project=new IPM_Project__c(
            Name = 'DEF1153BLOC',
            IPM_Project_Name__c = 'DEF1153BLOC',
            IPM_Phase__c = 'Ideas',
            IPM_Complexity__c = 'Full',
            IPM_GateKeeping_Model__c = 'GCLT & RCLT',
            Sustainability_Period__c = '3',
            IPMProject_Span__c = 'Global',
            IPM_Project_Type__c = 'Original',
            IPM_Target_Launch_Dates__c = Date.newInstance(2020, 04, 07),
            IPM_Project_Leader__c = testUser.Id
        );

        Test.startTest();
        insert project;
        String projectId = project.Id;
        if(projectId.length() > 15)
            projectId = projectId.subString(0,15);
        IPMProcessFinancials.processProjectFinancials(new Set<String>{projectId}, new Set<String>{projectId + '_3_3'});
        Test.stopTest();

        List<IPM_Financial__c> lstConsolidatedFinancial = [SELECT Id FROM IPM_Financial__c WHERE Financial_External_Id__c = 'DEF1153BLOC_CONSOLIDATED' LIMIT 1];
        System.assertEquals(lstConsolidatedFinancial.size(), 1);
        

        String REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();
        String LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();

        List<IPM_Project_Rollout__c> lstInsertRegionalRollouts = new List<IPM_Project_Rollout__c>();
        List<IPM_Project_Rollout__c> lstInsertLocalRollouts = new List<IPM_Project_Rollout__c>();

        lstInsertRegionalRollouts.add(
            new IPM_Project_Rollout__c(
                RecordTypeId = REGIONAL_ROLLOUT_RECORDTYPE,
                IPM_Rollout_Project__c = 'DEF1153BLOC_SEAA',
                IPM_Project__c = project.ID,
                IPM_Regional_PL__c = testUser.Id,
                Market_Cluster_Name__c = 'SEAA',
                Market_Cluster__c = 'GEO0022',
                Target_Launch_Date__c = Date.newInstance(2020, 04, 07)
            )
        );

        lstInsertRegionalRollouts.add(
            new IPM_Project_Rollout__c(
                RecordTypeId = REGIONAL_ROLLOUT_RECORDTYPE,
                IPM_Rollout_Project__c = 'DEF1153BLOC_EUR',
                IPM_Project__c = project.ID,
                IPM_Regional_PL__c = testUser.Id,
                Market_Cluster_Name__c = 'Europe',
                Market_Cluster__c = 'GEO0069',
                Target_Launch_Date__c = Date.newInstance(2020, 04, 07)
            )
        );

        insert lstInsertRegionalRollouts;

        lstInsertLocalRollouts.add(
            new IPM_Project_Rollout__c(
                RecordTypeId = LOCAL_ROLLOUT_RECORDTYPE,
                IPM_Rollout_Project__c = 'DEF1153BLOC_SEAA_ANZ',
                Regional_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = 'DEF1153BLOC_SEAA'),
                IPM_Project__c = project.ID,
                Type__c = 'MCO',
                KeyMCO__c = true,
                Market_Cluster_Name__c = 'SEAA',
                Market_Cluster__c = 'GEO0022',
                MCO__c = 'LV4_GEO0041',
                MCO_Name__c = 'ANZ',
                Target_Launch_Date__c = Date.newInstance(2020, 04, 07)
            )
        );

        lstInsertLocalRollouts.add(
            new IPM_Project_Rollout__c(
                RecordTypeId = LOCAL_ROLLOUT_RECORDTYPE,
                IPM_Rollout_Project__c = 'DEF1153BLOC_EUR_DACH',
                Regional_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = 'DEF1153BLOC_EUR'),
                IPM_Project__c = project.ID,
                Type__c = 'MCO',
                KeyMCO__c = false,
                Market_Cluster_Name__c = 'EUR',
                Market_Cluster__c = 'GEO0069',
                MCO__c = 'LV4_GEO0029',
                MCO_Name__c = 'DACH',
                Target_Launch_Date__c = Date.newInstance(2020, 04, 07)
            )
        );

        insert lstInsertLocalRollouts;

        
        
    }
    
    static testMethod void runFinGateTest()
    {
        initializeData();
        IPM_FinGateController finGate=new IPM_FinGateController();
        finGate.project=project;
        finGate.projectId=project.ID;
        
        finGate.financialsCalendar= new IPMFinancialWrapper();
        finGate.financialsInnovation= new IPMFinancialWrapper();
        finGate.getprojectId();
        finGate.setprojectId(project.ID);
      //  finGate.
        
    }

}