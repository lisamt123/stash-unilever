@isTest
public class IPM_FinancialUtils_Test{

    
    private static final string GLOBAL_PL_EMAIL_ID = 'globalProjectLeader@unilever.com.test';
    private static final string REGIONAL_PL_EMAIL_ID = 'regionalProjectLeader@unilever.com.test';
    private static final string LOCAL_PL_EMAIL_ID = 'localProjectLeader@unilever.com.test';
    private static final string BLANK_STRING = IPM_ConstantUtils.IPM_SPACE;  
    
    @testSetup static void ipm_FinancialUtilSetup() 
     {
        Test.startTest();  
        User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
        // Create an instances of standard Users for Allocation to Project Leaders.
        List<IPM_Project__c> globalProjectList = new List<IPM_Project__c>();

        List<User> userList = new List<User>();

        System.runAs(adminUser)
        {   
            User globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK_STRING);
            globalProjectLeader.email = GLOBAL_PL_EMAIL_ID;

            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK_STRING);
            regionalProjectLeader.email = REGIONAL_PL_EMAIL_ID;

            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK_STRING);
            localProjectLeader.email = LOCAL_PL_EMAIL_ID;

            userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};

            update userList;
        } 
        // Create Company Card information(Master Data)
        IPM_Company_Card__c globalCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3GlobalCompanyCard(false);
        IPM_Company_Card__c localCompanyCardGKM3 = IPM_TestFactory_Helper.createGKM3LocalCompanyCard(false);
        
        List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCardGKM3,localCompanyCardGKM3};
        insert companyCardList;
        
        IPM_TestFactory_Helper.getProjectMasterDataForGKM3();
        
        IPM_TestFactory_Helper.shareMasterProject(userList); 
         
         //User at index 0 is Global Project Leader and hence assert is not done based on hard coded names
         
        System.runAs(userList[0])
        {
 
            globalProjectList = IPM_TestFactory_Helper.projectSetUpGKM3(1,userList[0]);            
            system.assertNotEquals(globalProjectList,null, 'Global projects not created');
            for(IPM_Project__c p:globalProjectList){
                p.IPM_Answer_of_Q1__c='test question';
                p.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
                p.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
                p.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
                p.Success_Timestamp_EcoDesign__c = System.now().addHours(2);
            }
           
            insert globalProjectList;
            
            System.assertEquals(globalProjectList.size(),1);

            // Create Regional Rollouts for Created Global project.
            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalProjectList,new List<User>{userList[1],userList[1],userList[1]});
            
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
            List<IPM_Project_Rollout__c> localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
                localRollout.IPM_Regional_PL__c = userList[2].Id;
                localRollout.Target_Launch_Date__c = System.today().addMonths(10); //To cover 2523 line
                localRollout.Previous_Target_Launch_Date__c = System.today().addMonths(9); //To cover 2523 line
                setIds.add(localRollout.id);
            } 

            insert localRolloutList;               
                        
            system.assert(localRolloutList.size()>0, 'project rollout map cannot be created'); //names cannot be asserted as project and rollout map set in helper class
            
            Test.stopTest();
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>(); 
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                String geoExternalId = BLANK_STRING;
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

            //assert on counti is sufficient, additional soql can be a risk for SOQL gov limit as this method has loads of queries.
            system.assert(countryList.size()>0, 'country records not created');
          
        }
        }

        public static testMethod void IPM_FinancialUtilsTest(){
            
            List<User> globalProjectLeaderList = [Select Id,email from User where email =:GLOBAL_PL_EMAIL_ID]; 
            
            System.runAs(globalProjectLeaderList[0])
            {
                
             Test.StartTest();
                            
             IPM_Financial__c globFin = [select id,BIC_Global__c,Target_Launch_Date__c,CAPEX_Global__c,Financial_External_ID__c,RecordTypeId from IPM_Financial__c where RecordType.Name = 'Default' and Financial_External_ID__c = 'GKM3TestComments1_LA_BR'];
             
             system.assert(globFin!=null,'Finance record for global project not created.');
             system.assertEquals(globFin.Financial_External_ID__c, 'GKM3TestComments1_LA_BR','External Id not matched');
             
             List<IPM_Financial_Year__c> GlobFinYearsList = [select id ,Target_Launch_Date__c,Advertising_Promotions_Global__c,Profit_Before_Overheads_Global__c,Gross_Profit_Global__c,Turnover_Global__c,Volume_Global__c,Volume_Tons_Global__c from IPM_Financial_Year__c where Financial_External_ID__c = 'GKM3TestComments1_LA_BR'];
             System.assertEquals(GlobFinYearsList.size(), 14);

                 globFin.BIC_Global__c = 1;
                 globFin.CAPEX_Global__c = 1;
                 globFin.Target_Launch_Date__c=  System.today().addMonths(-15);
                 
                 update globFin;
                 
                 for(IPM_Financial_Year__c FinYears : GlobFinYearsList )
                 {
                     FinYears.Advertising_Promotions_Global__c = 1;
                     FinYears.Profit_Before_Overheads_Global__c= 1;
                     FinYears.Gross_Profit_Global__c= 1;
                     FinYears.Turnover_Global__c = 1;
                     FinYears.Volume_Global__c= 1;
                     FinYears.Volume_Tons_Global__c = 1;
                     
                 }
                 update GlobFinYearsList ;
                 
                 globFin.Target_Launch_Date__c=  System.today().addMonths(15);
                 
                 update globFin;
                 
            Test.StopTest();          
     } 
    }
}