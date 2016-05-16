/*************************************************************************************************
*@Author:Cognizant
*@Created Date:15/03/2016
*@Description:this test class is used to take input's from Finance/CMI/PD/DPL/Cental Team/Business Partner user
*for market performance break down.this is editable on Market Ready phase.Market performance data is coming
*from capability phase of regional rollout project.
**************************************************************************************************/


@isTest
private with sharing class IPM_PerformanceBreakdownController_Test {
    static List<IPM_Project__c> regionalProjectList;
    static List<IPM_Project__c> projectList;
    static List<IPM_Project_Rollout__c> localRolloutList; 
    static List<User> userList;
    static final String TEST_USER_EMAIL = 'globalUser@unilever.test.com';
	
//This method creates required global, regional and local projects and rollouts, also related financials. These records are then accessed across the testmethods.
    @testSetup static void financialSetUp() 
     {
         userList = IPM_TestFactory_Helper.createUserList();
         system.assertNotEquals(userList[0],null,'User not created');
         //asserts based on Hard coded names from helper can be a risk, if helper changes then assert will fail.
          
         IPM_TestFactory_Helper.getProjectMasterData();
         
         List<IPM_Project__c> globalProjectList = IPM_TestFactory_Helper.projectSetUp(1,userList[0]);
         system.assertNotEquals(globalProjectList,null, 'Global projects not created');
         //User at index 0 is Global Project Leader and hence assert is not done based on hard coded names
         
         System.runAs(userList[0])
         {
            insert globalProjectList;
         }
         createRegionalAndLocalRollouts(globalProjectList);
         //This creates Regional original project. But we need rollout projects also and financial
         createRegionalOriginalProjects();
     }
     
     static void createRegionalAndLocalRollouts(List<IPM_Project__c>globalProjectList)	
	 {
		 Test.startTest();
	        System.runAs(userList[0])
	        {
	            // Create Regional Rollouts for Created Global project.
	            List<IPM_Project_Rollout__c> regionalRolloutList = IPM_TestFactory_Helper.createRegionalRolloutList(false,globalProjectList,new List<User>{userList[1],userList[1],userList[1]});
	            insert regionalRolloutList;
	            system.assert(!regionalRolloutList.isEmpty(), 'project rollout cannot be created'); //names cannot be asserted as project name set in helper class
	            
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
	            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsList(false,projectToRolloutMap,new List<User>{userList[2]});  
	            insert localRolloutList; 
	            system.assert(!localRolloutList.isEmpty(), 'project rollout map cannot be created'); //names cannot be asserted as project and rollout map set in helper class
	            
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
	                
	                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new mdm_Geography__c(ISO_3166_1_Code__c = geoExternalId).Id,
	                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO');    
	                
	                countryList.add(tempCountry);
	            }
	            
	            insert countryList;
	            //assert on counti is sufficient, additional soql can be a risk for SOQL gov limit as this method has loads of queries.
	            system.assert(!countryList.isEmpty(), 'country records not created');
	        }
	        
	        Set<Id> setIds = new set<Id>();
	        System.runAs(userList[1])
	        {
	            for(IPM_Project_Rollout__c localRollout : localRolloutList)
	            {
	                localRollout.KeyMCO__c = true;
	                localRollout.IPM_Regional_PL__c = userList[2].Id;
	                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
	                localRollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE; 
	                localRollout.Target_Launch_Date__c = System.today().addMonths(10); //To cover 2523 line
	                localRollout.Previous_Target_Launch_Date__c = System.today().addMonths(9); //To cover 2523 line
	                setIds.add(localRollout.id);
	            }
	            update localRolloutList;
	            
	        }
	        
	     
	      //Create id set from projectlist
        list<id> liGlobIds = new list<id>();
        
        for(IPM_project__c g: globalProjectList){
            liGlobIds.add(g.id);
        }
        IPM_TestFactory_Helper.initiateProjectPhaseChange(liGlobIds,userList[0]);
        
        //assert preparation
        list<IPM_Project_Rollout__c> selRolloutList = [select KeyMCO__c, IPM_Regional_PL__c, IPM_Project_Job_Status__c, IPM_RolloutJobType__c, Target_Launch_Date__c, Previous_Target_Launch_Date__c from IPM_Project_Rollout__c where id in :setIds];
        for(IPM_Project_Rollout__c localRollout : selRolloutList)
        {
            system.assertEquals(localRollout.KeyMCO__c, true,'MCO not updated');
            system.assertEquals(localRollout.IPM_Regional_PL__c, userList[2].Id, 'regional PL not updated');
        }
        Test.stopTest(); 
	 }


	static void createRegionalOriginalProjects(){
		regionalProjectList = IPM_TestFactory_Helper.projectSetUpRegional(5,UserList[1]);
        System.runAs(userList[1])
        {
            insert regionalProjectList;
            /******************************** Create Local Rollouts for Created Regional Original project ****************************************/
            
            projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c from IPM_Project__c where IPMProject_Span__c =: IPM_ConstantUtils.PROJECT_SPAN_REGIONAL];
            
            // Create local Rollouts for Created regional Rollouts.
            localRolloutList = IPM_TestFactory_Helper.createLocalRolloutsOriginalList(false,projectList,new List<User>{userList[1]});  
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
                localRollout.Regional_Project__c = projectList[0].Id;            }
             
            insert localRolloutList; 
            //assert is done on size. Avoding SOQLs here as this method has lots of queries and can hit gov limit.
            system.assert(!localRolloutList.isEmpty(), 'local rollouts not created');
           
            // Create Country specific information.
            List<IPM_Country__c> countryList= new List<IPM_Country__c>();
            
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                IPM_Country__c tempCountry = new  IPM_Country__c(Geography__c = new MDO_Geography__c(ISO_3166_1_Code__c = 'AG').Id,
                IPM_Project__c = localRollout.IPM_Project__c,local_Rollout__c = localRollout.Id,IPM_Rollout_Status__c = 'With MCO',isActive__c = true);                    
                countryList.add(tempCountry);
            }
            insert countryList;  
            system.assert(!countryList.isEmpty(),'countries record not created');//Avoiding SOQL for further asserts
            
            // initiate the phase change of the project 
            for(IPM_Project_Rollout__c localRollout : localRolloutList)
            {
                localRollout.KeyMCO__c = true;
                localRollout.IPM_Regional_PL__c = userList[1].Id;
                localRollout.IPM_Project_Job_Status__c = IPM_ConstantUtils.JOB_STATUS_ELIGIBLE;
                localRollout.IPM_RolloutJobType__c = IPM_ConstantUtils.JOBTYPE_PROJECTCREATION_PHASECHANGE;  
            }
            update localRolloutList;
            projectList[0].IPM_Phase__c = IPM_ConstantUtils.PHASE_FEASIBILITY;
            update projectList[0];
            
            
            ipm_project__c selP = [select IPM_Phase__c from ipm_project__c where id=:projectList[0].id];
            system.assert(selP!=null,'project did not update properly');
            IPM_TestFactory_Helper.createIPMCountryList(true,1);
            
            //Finance record for global project which is NON consolidate             
             IPM_Financial__c localRolloutFin = [select id, Financial_External_ID__c, Target_Launch_Date__c, RecordTypeId, Regional_External_Id__c, 
             Project_Sustainability_Period__c, Status__c, isGateSubmissionDue__c from IPM_Financial__c where Financial_External_ID__c='TestRegionalComments1_UMCA'];
             system.assert(localRolloutFin!=null, 'Finance record for Local rollout project is not created.');
            
            list<IPM_Exchange_Rate__c> liEX = new list<IPM_Exchange_Rate__c>();
            liEX.add(new IPM_Exchange_Rate__c(Name='EUR', Currency_Code__c='EUR',Exchange_Rate__c=1));
            liEX.add(new IPM_Exchange_Rate__c(Name='GBP', Currency_Code__c='GBP',Exchange_Rate__c=0.8)); 
            liEX.add(new IPM_Exchange_Rate__c(Name='USD', Currency_Code__c='USD',Exchange_Rate__c=1.3));         
            insert liEX;   
            system.assertEquals(3, [Select count() from IPM_Exchange_Rate__c limit 100] , 'Exchange rates are not added.');
            
        }
	}
     //Use case: Local Rollout project in market ready phase 
     static testMethod void testMarketPerformanceBreakDown(){
        System.runAs([Select Id from User where email =: TEST_USER_EMAIL limit 1][0])
        {
	         Test.startTest();
             //Name hard coded as we know it from nameset. It will be hard to make it dynamic.
             IPM_Project__c localRollout = [select id, name, IPMProject_Span__c, IPM_SourceProjectType__c, IPM_Project_Type__c, BI__c, IPM_Target_Launch_Dates__c  from IPM_Project__c where IPMProject_Span__c='Local' and IPM_Project_Type__c='Rollout' and Name='TestRegionalComments1_UMCA' limit 1];
             system.assert(localRollout!=null,'Local rollout type project not created.');
             localRollout.IPM_Phase__c = IPM_ConstantUtils.PHASE_CAPABILITY;
             update localRollout;
	        
	        PageReference pageRef = Page.ipm_projectdocumentsectioneditor;
	        Test.setCurrentPageReference(pageRef);  
	        ApexPages.CurrentPage().getparameters().put(IPM_ConstantUtils.SF_ID, localRollout.id);
	        IPM_PerformanceBreakdownController sic = new IPM_PerformanceBreakdownController (); 
	        sic.selectedCurrency=null;
	        List<SelectOption>lstOptions=sic.getItems();
	        system.assertEquals(lstOptions.isEmpty(),false,'selelct option list is not empty');
	        sic.applyRate();
	        system.assertEquals(sic.appliedRate,true,'exchange rate is not applied to EUR');
	        sic.selectedCurrency='BOB';
	        sic.applyRate();
	        system.assertEquals(sic.appliedRate,true,'exchange rate is not applied to BOB');
	        sic.marketPerformanceBreakdownList[0].GrossTurnover__c=2;
	        sic.marketPerformanceBreakdownList[0].Gross_AP__c=2;
	        sic.marketPerformanceBreakdownList[0].GrossPBO__c=2;
	        sic.marketPerformanceBreakdownList[0].AverageRetailPrice__c=101;
	        sic.marketPerformanceBreakdownList[0].MediaSpend__c=101;
	        sic.saveRecords();
	        List<IPM_MarketPerformanceBreakdown__c> marketPerformanceBreakdownList=[SELECT GrossTurnover__c,Gross_AP__c FROM IPM_MarketPerformanceBreakdown__c WHERE ID=:sic.marketPerformanceBreakdownList[0].ID LIMIT 1];
	        system.assertEquals(marketPerformanceBreakdownList[0].GrossTurnover__c,2,'gross turnover is not saved');//Negative test
	        system.assertEquals(marketPerformanceBreakdownList[0].Gross_AP__c,2,'gross AP is not saved');//positive test
	        
	        sic.marketPerformanceBreakdownList[0].Name='invalid charinvalid charinvalid charinvalid charinvalid charinvalid charinvalid charinvalid charinvalid charinvalid charinvalid charinvalid charinvalid charinvalid char';
	        sic.saveRecords();
	        List<IPM_MarketPerformanceBreakdown__c> marketPerforBreakdownList=[SELECT Name FROM IPM_MarketPerformanceBreakdown__c WHERE ID=:sic.marketPerformanceBreakdownList[0].ID LIMIT 1];
	        system.assertNotEquals(marketPerforBreakdownList[0].Name,sic.marketPerformanceBreakdownList[0].Name,'Name is saved');//negative test
	        
	        sic.marketPerformanceBreakdownList[0].Name=sic.marketPerformanceBreakdownList[0].id;
	        sic.marketPerformanceBreakdownList[0].InnovationValueShare__c=101;
	        sic.marketPerformanceBreakdownList[0].InnovationVolumeShare__c=101;
	        sic.marketPerformanceBreakdownList[0].Penetrationcum__c=101;
	        sic.marketPerformanceBreakdownList[0].RepeatRate__c=101;
	        sic.marketPerformanceBreakdownList[0].WeightedDistribution__c=101;
	        sic.saveRecords();
	        List<IPM_MarketPerformanceBreakdown__c> marketPerformanceBkList=[SELECT InnovationValueShare__c,InnovationVolumeShare__c FROM IPM_MarketPerformanceBreakdown__c WHERE ID=:sic.marketPerformanceBreakdownList[0].ID LIMIT 1];
	        system.assertNotEquals(marketPerformanceBkList[0].InnovationValueShare__c,101,'innovation value share is saved');//positive test
	        system.assertNotEquals(marketPerformanceBkList[0].InnovationVolumeShare__c,101,'innovation volume share is saved');//positive test
	        Test.stopTest();
		       
        }
        
    } 
    
    //This testmethod is used to test 6.5 market performance data created in system, when local rollouts are created in testsetup method.
    static testMethod void testMarketPerformaceDataCreated()
    {
        System.runAs([Select Id from User where email =: TEST_USER_EMAIL limit 1][0])
        {
            Test.startTest();
            Test.setCurrentPageReference(Page.IPM_ProjectDocumentSectionEditor);
            projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c from IPM_Project__c where IPMProject_Span__c =: IPM_ConstantUtils.PROJECT_SPAN_REGIONAL limit 1];
            Apexpages.currentpage().getparameters().put(IPM_ConstantUtils.SF_ID,projectList[0].Id);
            IPM_MarketPerformaceController marketPerformanceController = new IPM_MarketPerformaceController();
            List<IPM_MarketPerformance__c> lstMarketPerformance = [Select Id, IPMProjectRollout__r.Regional_Project__c from IPM_MarketPerformance__c where IPMProjectRollout__r.Regional_Project__c =:projectList[0].Id limit 1000];
            System.assertEquals(marketPerformanceController.lstMarketPerformaceData.size() , lstMarketPerformance.size() , 'Market performance data created do not match.');
            Test.stopTest();
        }
    }
    
    //This testmethod is used to test validations set on 6.5 data, that they can not be greater than 100%
    static testMethod void testMarketPerformaceDataUpdatedNegativeTest()
    {
        System.runAs([Select Id from User where email =: TEST_USER_EMAIL limit 1][0])
        {
            Test.startTest();
            Test.setCurrentPageReference(Page.IPM_ProjectDocumentSectionEditor);
            projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c from IPM_Project__c where IPMProject_Span__c =: IPM_ConstantUtils.PROJECT_SPAN_REGIONAL limit 1];
            Apexpages.currentpage().getparameters().put(IPM_ConstantUtils.SF_ID,projectList[0].Id);
            IPM_MarketPerformaceController marketPerformanceController = new IPM_MarketPerformaceController();
            for(IPM_MarketPerformance__c marketPerformance : marketPerformanceController.lstMarketPerformaceData)
            {
            	marketPerformance.InnovationVolumeShare__c = 200;
            	marketPerformance.Penetrationcum__c = 200;
            	marketPerformance.RepeatRate__c = 200;
            	marketPerformance.WeightedDistribution__c = 200;
            }
            marketPerformanceController.save();
            
            System.assert(marketPerformanceController.sErrorMessage.contains(Label.IPM_6_5_Performance_Table_Fields_Can_not_be_greater_than_100), 'Market performance data is not updated successfully.');
            Test.stopTest();
        }
    }
    
    //This testmethod is used to test save functionality of 6.5 records when valid data is entered.
    static testMethod void testMarketPerformaceDataUpdatedPositiveTest()
    {
    	Set<Id> setMarketPerformanceId = new Set<Id>();
        System.runAs([Select Id from User where email =: TEST_USER_EMAIL limit 1][0])
        {
            Test.startTest();
            Test.setCurrentPageReference(Page.IPM_ProjectDocumentSectionEditor);
            projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c from IPM_Project__c where IPMProject_Span__c =: IPM_ConstantUtils.PROJECT_SPAN_REGIONAL];
            Apexpages.currentpage().getparameters().put(IPM_ConstantUtils.SF_ID,projectList[0].Id);
            IPM_MarketPerformaceController marketPerformanceController = new IPM_MarketPerformaceController();
            for(IPM_MarketPerformance__c marketPerformance : marketPerformanceController.lstMarketPerformaceData)
            {
              marketPerformance.InnovationVolumeShare__c = 80.63;
              marketPerformance.Penetrationcum__c = 84.25;
              marketPerformance.RepeatRate__c = 70.26;
              marketPerformance.WeightedDistribution__c = 10.26;
              setMarketPerformanceId.add(marketPerformance.Id);
            }
            marketPerformanceController.save();
            for(IPM_MarketPerformance__c marketPerformance : [Select Id, InnovationVolumeShare__c, Penetrationcum__c, RepeatRate__c, WeightedDistribution__c, IPMProjectRollout__r.Regional_Project__c from IPM_MarketPerformance__c where Id IN :setMarketPerformanceId limit 1000])
            {
            	System.assertEquals(80.63 , marketPerformance.InnovationVolumeShare__c, 'Innovation volume share is not updated successfully.');
            	System.assertEquals(84.25 , marketPerformance.Penetrationcum__c, 'Penetration Cum is not updated successfully.');
            	System.assertEquals(70.26 , marketPerformance.RepeatRate__c, 'Repeat rate is not updated successfully.');
            	System.assertEquals(10.26 , marketPerformance.WeightedDistribution__c, 'Weighted distribution is not updated successfully.');
            }
            
            Test.stopTest();
        }
    }
    
    //This testmethod is used to fire the exception in order to cover the catch block.
    static testMethod void testMarketPerformaceDataUpdatedCatchBlock()
    {
        System.runAs([Select Id from User where email =: TEST_USER_EMAIL limit 1][0])
        {
            Test.startTest();
            Test.setCurrentPageReference(Page.IPM_ProjectDocumentSectionEditor);
            projectList = [Select Id,IPM_Phase__c,Name,IPM_Complexity__c,IPM_Project_Name__c from IPM_Project__c where IPMProject_Span__c =: IPM_ConstantUtils.PROJECT_SPAN_REGIONAL];
            Apexpages.currentpage().getparameters().put(IPM_ConstantUtils.SF_ID,projectList[0].Id);
            IPM_MarketPerformaceController marketPerformanceController = new IPM_MarketPerformaceController();
            for(IPM_MarketPerformance__c marketPerformance : marketPerformanceController.lstMarketPerformaceData)
            {
            	marketPerformance.External_Id__c = 'Test External Id';
            }
            marketPerformanceController.save();
            System.assertEquals('' , marketPerformanceController.sErrorMessage , 'Market performance data is not updated successfully.');
            Test.stopTest();
        }
    }
    

}