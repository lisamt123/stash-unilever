/*************************************************************************************************************
* @author:Cognizant
* @date: 19/01/2016
* @description: The Test class to test functionality in IPM_SyncFinanceTableTLD. 
    IPM_SyncFinanceTableTLDLocal_Test has Methods to update relative financial records when enver there is updates in Rollouts and Projects TLDs
*/
@isTest(SeeAllData=false)
private class IPM_SyncFinanceTableTLDLocal_Test {
    
    private static final String MARKET_CLUSTER='GEO0060';
    private static final String PROJ_SIZE_MSG='Project(s) size should be 1';
    private static final String FIN_YEAR_MSG='Financial Year Mismatch';
    private static final String ROLLOUT_MSG='Rollout should be present';
    private static final String TESTCOMMENTS1_REG_LOC1 = 'TestComments1_REG_LOC1';
    private static final String TESTCOMMENTS1_REG_LOC2 = 'TestComments1_REG_LOC2';
    private static final String TESTCOMMENTS1_REG_LOC_K = 'TestComments1_REG_LOC_K';
    private static final String TESTCOMMENTS1_REG = 'TestComments1_REG';
    private static final String GLOBAL_PL = 'GLOBAL_PL';
    private static final String REGIONAL_PL = 'REGIONAL_PL';
    private static final String LOCAL_PL = 'LOCAL_PL';
    private static final String BLANK = '';
    private static User globalProjectLeader=null;
    
   
    
    private static final String DEFAULT_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
    
/*
    1.  All the individual tests need unique data setup. 
        Use of single setup method to set all the data will raise too many SOQL exception. 
        In order to avoid the exception the data setup has been into several methods so that the data setup methods get its own governor limits.
    
    2.  The data setup varies for test scenarios, looks like duplicate code block but not. 
        Pulling these code blocks into private methods will introduce n-path complexity and reduces code readability.
    */
    static void setupLocalRolloutData(){
        // Create an instance of admin user.
         User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
         
         // Create an instances of standard Users for Allocation to Project Leaders.
         System.runAs(adminUser)
         {   
            globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(BLANK);
            
            // Update LastNames to match functionalRoles
            globalProjectLeader.lastname = GLOBAL_PL;
            regionalProjectLeader.lastname = REGIONAL_PL;
            localProjectLeader.lastname = LOCAL_PL; 
            
            List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
            update userList;
            
            List<User> dbUserList =  [Select Id from User where id in :userList];
            
            System.assertEquals(dbUserList.size(),userList.size(),'Users not Created Properly.Actual no of Users should be'+userList.size());
            
            // Create Company Card information(Master Data)
            IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
            IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
            
            List<IPM_Company_Card__c> companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
            insert companyCardList;
            
            // Inserting Master Data whose OWD are set to readOnly/View All    
            IPM_TestFactory_Helper.getProjectMasterData();
            
            // Creating manual share records as Criteria based Sharing doesnt work for Test Classes.
            IPM_TestFactory_Helper.shareMasterProject(new List<User>{globalProjectLeader}); 
        } 
        List<IPM_Project__c> projectList = new List<IPM_Project__c>();
        Date targetLaunchDate = System.today().addYears(3);
        // Insert the project as a Global project Leader.
        System.runAs(globalProjectLeader)
        {   
            test.startTest();
            projectList = IPM_TestFactory_Helper.projectSetUp(3,globalProjectLeader);
            projectList[0].IPM_Target_Launch_Dates__c=targetLaunchDate;
            insert projectList;
            
            List<IPM_Project__c> dbProjectList =  [Select Id, name from IPM_Project__c where id in :projectList];
            
            System.assertEquals(dbProjectList.size(),projectList.size(),'Projects not Created Properly.Actual size should be '+projectList.size());
            
            // create region rollout
            String rolloutRegionlaRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.REGIONAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c regionalProjectRollout=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            regionalProjectRollout.Name= TESTCOMMENTS1_REG;
            regionalProjectRollout.IPM_Rollout_Project__c = TESTCOMMENTS1_REG;
            regionalProjectRollout.IPM_Project__c=projectList[0].ID;
            regionalProjectRollout.Market_Cluster__c=MARKET_CLUSTER;
            regionalProjectRollout.IPM_Rollout_Span__c=IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
            regionalProjectRollout.Target_Launch_Date__c = targetLaunchDate;
            regionalProjectRollout.External_Id__c= TESTCOMMENTS1_REG;
            regionalProjectRollout.RecordTypeId = rolloutRegionlaRecordTypeId;
            regionalProjectRollout.isActive__c=true;
            insert regionalProjectRollout;
            
            List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();
            String rolloutLocalRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name=:IPM_ConstantUtils.LOCAL_ROLLOUT_RT].Id;
            IPM_Project_Rollout__c localNonkeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout1.Name= TESTCOMMENTS1_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Rollout_Project__c = TESTCOMMENTS1_REG_LOC1;
            localNonkeyProjectRollout1.IPM_Project__c=projectList[0].ID;
            localNonkeyProjectRollout1.Regional_Rollout__c=regionalProjectRollout.id;
            localNonkeyProjectRollout1.Market_Cluster__c=MARKET_CLUSTER;
            localNonkeyProjectRollout1.IPM_Rollout_Span__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            localNonkeyProjectRollout1.Target_Launch_Date__c = targetLaunchDate;
            localNonkeyProjectRollout1.RecordTypeId = rolloutLocalRecordTypeId;
            localNonkeyProjectRollout1.KeyMCO__c = false;
            localNonkeyProjectRollout1.External_Id__c= TESTCOMMENTS1_REG_LOC1;
            localNonkeyProjectRollout1.isActive__c=true;
            rollouts.add(localNonkeyProjectRollout1);
            
            IPM_Project_Rollout__c localNonkeyProjectRollout2 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localNonkeyProjectRollout2.Name= TESTCOMMENTS1_REG_LOC2;
            localNonkeyProjectRollout2.IPM_Rollout_Project__c = TESTCOMMENTS1_REG_LOC2;
            localNonkeyProjectRollout2.IPM_Project__c=projectList[0].ID;
            localNonkeyProjectRollout2.Regional_Rollout__c=regionalProjectRollout.id;
            localNonkeyProjectRollout2.Market_Cluster__c=MARKET_CLUSTER;
            localNonkeyProjectRollout2.IPM_Rollout_Span__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            localNonkeyProjectRollout2.Target_Launch_Date__c = targetLaunchDate;
            localNonkeyProjectRollout2.RecordTypeId = rolloutLocalRecordTypeId;
            localNonkeyProjectRollout2.KeyMCO__c = false;
            localNonkeyProjectRollout2.External_Id__c= TESTCOMMENTS1_REG_LOC2;
            localNonkeyProjectRollout2.isActive__c=true;
            rollouts.add(localNonkeyProjectRollout2);
            
            IPM_Project_Rollout__c localKeyProjectRollout1 =IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
            localKeyProjectRollout1.Name= TESTCOMMENTS1_REG_LOC_K;
            localKeyProjectRollout1.IPM_Rollout_Project__c =  TESTCOMMENTS1_REG_LOC_K;
            localKeyProjectRollout1.IPM_Project__c=projectList[0].ID;
            localKeyProjectRollout1.Regional_Rollout__c=regionalProjectRollout.id;
            localKeyProjectRollout1.Market_Cluster__c=MARKET_CLUSTER;
            localKeyProjectRollout1.IPM_Rollout_Span__c=IPM_ConstantUtils.EMPTY_STRING_INITIAL;
            localKeyProjectRollout1.Target_Launch_Date__c = targetLaunchDate;
            localKeyProjectRollout1.RecordTypeId = rolloutLocalRecordTypeId;
            localKeyProjectRollout1.KeyMCO__c = true;
            localKeyProjectRollout1.External_Id__c= TESTCOMMENTS1_REG_LOC_K;
            localKeyProjectRollout1.isActive__c=true;
            rollouts.add(localKeyProjectRollout1);
            insert rollouts;
    
            test.stopTest();
        }
        List<IPM_Project__c> projlList=[SELECT Id, Name,IPM_Phase__c, IPM_Project_Job_Status__c,IPM_Target_Launch_Dates__c FROM IPM_Project__c WHERE name =: 'TestComments1' limit 1];
        System.assertEquals(projlList.size(), 1,PROJ_SIZE_MSG);
    }
    
    
/*
    The datasetup method of this test has Test.startTest() and Test.stopTest(). 
    So cant have another set of Test.startTest() and Test.stopTest().
    */  
    static testMethod void testSyncFinanceTableTLD_When_KeyLocalRolloutTLD_Updated() {
        setupLocalRolloutData();


        Date targetLanchDate1 = System.today().addYears(4);
        System.runAs(globalProjectLeader) {
            // update rollout1 with targetLanchDate1
            IPM_Project_Rollout__c rollout1 = [SELECT ID, Name,IPM_Project__c,External_Id__c,Regional_Rollout__c,KeyMCO__c FROM IPM_Project_Rollout__c WHERE name=: TESTCOMMENTS1_REG_LOC_K limit 1];
            rollout1.Target_Launch_Date__c = targetLanchDate1;
            update rollout1;
    
            IPM_Project_Rollout__c reginolRollout = [SELECT ID, Name,IPM_Project__c FROM IPM_Project_Rollout__c WHERE name=: TESTCOMMENTS1_REG limit 1];
            System.assert(reginolRollout.id!=null,ROLLOUT_MSG);
            List<IPM_Financial__c> updatedFinancialList = [SELECT ID, Target_Launch_Date__c,Financial_External_ID__c,RecordType.Name FROM IPM_Financial__c WHERE IPM_Project_Rollout__c=:reginolRollout.id limit 2];
            List<ID> updatedFinancialIDList = new List<ID>();
            
            for(IPM_Financial__c updatedFinancial: updatedFinancialList) {
                if(updatedFinancial.Financial_External_ID__c== TESTCOMMENTS1_REG_LOC_K) {
                    updatedFinancialIDList.add(updatedFinancial.id);
                }
            }
                    List<IPM_Financial__c> retrievedFinancialList = [Select id, Target_Launch_Date__c, 
                                                                            (   Select 
                                                                                    Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                                                From 
                                                                                    IPM_Financial_Years__r 
                                                                                where 
                                                                                    Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                                                    ) 
                                                                         From 
                                                                            IPM_Financial__c 
                                                                                where id in : updatedFinancialIDList limit 5];
            
            for(IPM_Financial__c updatedFinancial:retrievedFinancialList) {
                for(IPM_Financial_Year__c financialYear:updatedFinancial.IPM_Financial_Years__r) {
                    if(financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS) {
                        // year 1
                        if( financialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                        //year 2
                        if( financialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                        //year 3
                        if( financialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                    }
                }
            }
        }
        
    }
    /*
    The datasetup method of this test has Test.startTest() and Test.stopTest(). 
    So cant have another set of Test.startTest() and Test.stopTest().
    */  
    static testMethod void testSyncFinanceTableTLD_When_NonkeyLocalRolloutsTLD_UpdatedToEarliest() {
        setupLocalRolloutData();
        List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();

        Date targetLanchDate1 = System.today().addYears(4);
        System.runAs(globalProjectLeader) {
            // update rollout1 with targetLanchDate1
            IPM_Project_Rollout__c rollout1 = [SELECT ID, Name,IPM_Project__c,External_Id__c,Regional_Rollout__c,KeyMCO__c FROM IPM_Project_Rollout__c WHERE name=: TESTCOMMENTS1_REG_LOC1 limit 1];
            rollout1.Target_Launch_Date__c = targetLanchDate1;
            rollouts.add(rollout1);
            
            
            Date targetLanchDate2 = System.today().addYears(5);
            IPM_Project_Rollout__c rollout2 = [SELECT ID, Name,IPM_Project__c,External_Id__c,Regional_Rollout__c,KeyMCO__c FROM IPM_Project_Rollout__c WHERE name=:TESTCOMMENTS1_REG_LOC2 limit 1];
            // update rollout2 with targetLanchDate2
            rollout2.Target_Launch_Date__c = targetLanchDate2;
            rollouts.add(rollout2);
            update rollouts;
    
            IPM_Project_Rollout__c reginolRollout = [SELECT ID, Name,IPM_Project__c FROM IPM_Project_Rollout__c WHERE name=: TESTCOMMENTS1_REG limit 1];
            System.assertEquals(reginolRollout.Name,TESTCOMMENTS1_REG,'Rollout name must be TestComments1_REG');
            List<IPM_Financial__c> updatedFinancialList = [SELECT ID, Target_Launch_Date__c,Financial_External_ID__c FROM IPM_Financial__c WHERE IPM_Project_Rollout__c=:reginolRollout.id limit 5];
            List<ID> updatedFinancialIDList = new List<ID>();
            
            for(IPM_Financial__c updatedFinancial: updatedFinancialList) {
                if(updatedFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY)) {
                    // NONKEY financial record TLD should be the earliast of local rollouts, which is targetLanchDate1
                    updatedFinancialIDList.add(updatedFinancial.id);
                }
            }
                    List<IPM_Financial__c> retrievedFinancialList = [Select id, Target_Launch_Date__c, 
                                                                            (   Select 
                                                                                    Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                                                From 
                                                                                    IPM_Financial_Years__r 
                                                                                where 
                                                                                    Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                                                    ) 
                                                                         From 
                                                                            IPM_Financial__c 
                                                                                where id in : updatedFinancialIDList and RecordTypeId = :DEFAULT_FINANCIAL_RECORDTYPE limit 5];
            
            for(IPM_Financial__c updatedFinancial:retrievedFinancialList) {
                for(IPM_Financial_Year__c financialYear:updatedFinancial.IPM_Financial_Years__r) {
                    if(financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS) {
                        // year 1
                        if( financialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                        //year 2
                        if( financialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                        //year 3
                        if( financialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                    }
                }
            }
        }
    }
    /*
    The datasetup method of this test has Test.startTest() and Test.stopTest(). 
    So cant have another set of Test.startTest() and Test.stopTest().
    */  
    static testMethod void testSyncFinanceTableTLD_When_NonkeyLocalRolloutsTLD_UpdatedToLatest() {
        setupLocalRolloutData();
        List<IPM_Project_Rollout__c> rollouts = new List<IPM_Project_Rollout__c>();

        Date targetLanchDate1 = System.today().addYears(4);
        System.runAs(globalProjectLeader) {
            // update rollout1 with targetLanchDate1
            IPM_Project_Rollout__c rollout1 = [SELECT ID, Name,IPM_Project__c,Regional_Rollout__c,KeyMCO__c FROM IPM_Project_Rollout__c WHERE name=: TESTCOMMENTS1_REG_LOC1 limit 1];
            rollout1.Target_Launch_Date__c = targetLanchDate1;
            rollouts.add(rollout1);
            
            
            Date targetLanchDate2 = System.today().addYears(5);
            IPM_Project_Rollout__c rollout2 = [SELECT ID, Name,IPM_Project__c,Regional_Rollout__c,KeyMCO__c FROM IPM_Project_Rollout__c WHERE name=:TESTCOMMENTS1_REG_LOC2 limit 1];
            // update rollout2 with targetLanchDate2
            rollout2.Target_Launch_Date__c = targetLanchDate2;
            rollouts.add(rollout2); 
            update rollouts; 
            
            IPM_Project_Rollout__c reginolRollout = [SELECT ID, Name,IPM_Project__c FROM IPM_Project_Rollout__c WHERE name=: TESTCOMMENTS1_REG limit 1];
            System.assertEquals(reginolRollout.Name,TESTCOMMENTS1_REG,'Rollout name must be TestComments1_REG');
            List<IPM_Financial__c> updatedFinancialList = [SELECT ID, Target_Launch_Date__c,Financial_External_ID__c FROM IPM_Financial__c WHERE IPM_Project_Rollout__c=:reginolRollout.id limit 5];
            List<ID> updatedFinancialIDList = new List<ID>();
            
            for(IPM_Financial__c updatedFinancial: updatedFinancialList) {
                if(updatedFinancial.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_NONKEY)) {
                    // NONKEY financial record TLD should be the earliast of local rollouts, which is targetLanchDate1
                    updatedFinancialIDList.add(updatedFinancial.id);
                }
            }
                    List<IPM_Financial__c> retrievedFinancialList = [Select id, Target_Launch_Date__c, 
                                                                            (   Select 
                                                                                    Year__c,Year_Type__c,Name, External_Id__c,Target_Launch_Date__c, PL_Type__c 
                                                                                From 
                                                                                    IPM_Financial_Years__r 
                                                                                where 
                                                                                    Year_Type__c=:IPM_ConstantUtils.YEAR_TYPE_CALENDAR 
                                                                                    ) 
                                                                         From 
                                                                            IPM_Financial__c 
                                                                                where id in : updatedFinancialIDList  and RecordTypeId = :DEFAULT_FINANCIAL_RECORDTYPE  limit 5];
            
            for(IPM_Financial__c updatedFinancial:retrievedFinancialList) {
                for(IPM_Financial_Year__c financialYear:updatedFinancial.IPM_Financial_Years__r) {
                    if(financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_INCREMENTAL||financialYear.PL_Type__c==IPM_ConstantUtils.PL_TYPE_GROSS) {
                        // year 1
                        if( financialYear.Year__c==IPM_ConstantUtils.Y1_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                        //year 2
                        if( financialYear.Year__c==IPM_ConstantUtils.Y2_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                        //year 3
                        if( financialYear.Year__c==IPM_ConstantUtils.Y3_YEARINDEX) {
                            System.assert(financialYear.Name != null,FIN_YEAR_MSG);
                        }
                    }
                }
            }
        }
    }     
}
