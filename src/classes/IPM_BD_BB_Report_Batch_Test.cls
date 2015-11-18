/**
 * IPM_BD_BB_Reportbatch_Test : This Test class for IPM_BD_BB_Report_Batch Batch apex class
 * @author - Cognizant
 *
 */
 
@isTest
private class IPM_BD_BB_Report_Batch_Test {
    
    public static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static List<IPM_Financial_Year__c> lstFinancialYear=new List<IPM_Financial_Year__c>();
    public static List<IPM_Milestone__c> ipmMileStoneTestList=new List<IPM_Milestone__c>();
    public static List<IPM_Country__c> ipmcountrylist = new List<IPM_Country__c>();
    public static IPM_Reporting__c reportParameter;
    public static User testUser;
    public static set<id> projidset = new set<id>();
    
    /**********************************************************************
    *  @Description: Test Method to initialize data for the other test methods
    *  @name : initializeData
    *  @param : none
    *  @return : none
    *************************************************************************/
    static void initializeData(){
        test.startTest(); 
              
            Profile u = [SELECT Id FROM Profile WHERE Name='IPM NG Basic']; 
            testUser = IPM_TestFactory_Helper.createUser(FALSE);
            testUser.profileId = u.Id;
            insert testUser;
            
            List<User>lstUser=[SELECT ProfileId FROM USER WHERE ProfileId=:u.id];
        	system.assertEquals(lstUser[0].ProfileId,u.id,'User profile id is:'+lstUser[0].ProfileId);//positive test
            
            //Insert data for Custom setting
        	reportParameter = IPM_TestFactory_Helper.createIPMReportingCustomSetting();
        	List<IPM_Reporting__c>reportParameterlist=[SELECT Id FROM IPM_Reporting__c WHERE Id=:reportParameter.Id limit 1];
        	system.assert(reportParameterlist[0].Id != null); //positive test
        	
       		Id projid;
       		id localid;
       		
            system.runAs(testUser){
            
            //Test project creation
            projectList = IPM_TestFactory_Helper.insertIPMProjectList();
            
            for(IPM_Project__c p:projectList){
            	if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
            		p.IPM_Project_Type__c = IPM_Utils.Original;
            		p.IPM_Category_Text__c = IPM_ConstantUtils.HHC_CONSTANT;
            		p.IPM_Project_Leader__c = testUser.Id;
            		projid = p.Id;            		
            	}
            	if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
            		p.IPM_Project_Type__c = IPM_Utils.Rollout; 
            		
            	}
            	if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
            		p.IPM_Project_Type__c = IPM_Utils.Rollout;
            		localid = p.Id; 
            	}
            	
            	p.Project_External_ID__c = p.id + p.IPMProject_Span__c;
            	projidset.add(p.id);            	
            }
            update projectList;
            list<IPM_Project__c> projectListtest = new list<IPM_Project__c>([SELECT id FROM IPM_Project__c WHERE id IN:projectList Limit 100]);
            system.assertEquals(projectList.size(),projectListtest.size());            
 			
 			//Test Finance data creation            
            lstFinancial = IPM_TestFactory_Helper.insertIPMFinancialList(true);

            //Test Financial Year Data creation/update
            lstFinancialYear = IPM_TestFactory_Helper.insertIPMFinancialYearList();
            
            //Test Milestone Data Creation/Update
            Id mileMRecordType=Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
            ipmMileStoneTestList = IPM_TestFactory_Helper.createIPMMilestoneList(false, 7);
                          
            for(Integer i = 0; i < ipmMileStoneTestList.size(); i++){
                
                ipmMileStoneTestList[i].IPM_Due_Date__c = system.today() + i;                
                ipmMileStoneTestList[i].IPM_Type_of_Milestone__c = IPM_ConstantUtils.STANDARD;
                ipmMileStoneTestList[i].recordtypeid = mileMRecordType;
                ipmMileStoneTestList[i].IPM_Project__c = projid;
                ipmMileStoneTestList[i].IPM_Due_Date__c = system.today() + 30;          
                ipmMileStoneTestList[i].IPM_Proposed_Date__c = system.today() + 60;
                ipmMileStoneTestList[i].IPM_Completed_on__c = system.today() + 90;
                ipmMileStoneTestList[i].IPM_Name__c = projid + string.valueof(i); 
                                          
                if(i==0) ipmMileStoneTestList[0].IPM_Type_of_gate__c = IPM_Utils.Charter;           
                if(i==1) ipmMileStoneTestList[1].IPM_Type_of_gate__c = IPM_Utils.Contract;
                if(i==2) ipmMileStoneTestList[2].IPM_Type_of_gate__c = IPM_Utils.MarketReady;
                if(i==3) ipmMileStoneTestList[3].IPM_Type_of_gate__c = IPM_Utils.MarketDeployment;
                if(i==4) ipmMileStoneTestList[4].IPM_Name__c = IPM_Utils.ShiptoTrade;
                if(i==5) ipmMileStoneTestList[5].IPM_Name__c = IPM_ConstantUtils.BET_MS_FIRST_RELEASE;
                if(i==6) ipmMileStoneTestList[6].IPM_Name__c = IPM_ConstantUtils.BET_MS_FINAL_RELEASE;
            }

            insert ipmMileStoneTestList;
            List<IPM_Milestone__c> ipmMileStoneTestListtest = new List<IPM_Milestone__c>([SELECT Id FROM IPM_Milestone__c where id IN:ipmMileStoneTestList limit 100]);
            system.assert(ipmMileStoneTestListtest.size() == 7); //positive test 
            
            //Test Country Data Creation/Update    
        	//Insert Geography
       		MDO_Geography__c geo = IPM_TestFactory_Helper.createMDOGeography(false);
        	geo.Name='TestRegion';
        	geo.geography_type__c='Cluster';
        	Insert geo;
        	List<MDO_Geography__c> geolist = new List<MDO_Geography__c>([SELECT Id FROM MDO_Geography__c where id =: geo.id limit 1]);
            system.assertEquals(geolist[0].id, geo.id, 'Error in Geography Creation'); //positive test

        }  
        test.stopTest();
    }
    
    static testMethod void testBDBBreport() { 
        initializeData();       	 
       	system.runAs(testUser){
            string query = 'SELECT Id,IPM_Global_ProjectId__c,Project_External_ID__c,Name,IPM_Parent_Project__r.Name,IPM_Parent_Project__r.Id,IPM_Project_Leader__r.Name,Deputy_Project_Leader__r.Name,IPM_Technical_Project_Leader__r.Name,IPM_Finance_Member__r.Name,IPM_Rollout_Status__c,IPM_Category_Group__c,IPM_Category_Text__c,IPM_Phase__c,IPM_Brand_Positioning__c,IPMProject_Span__c, IPMProject_Type__c,Project_Countries__c,IPM_No_of_Country_Rollouts__c,IPM_Threshold_Value__c,IPM_Company_Card__r.Name,IPM_Cluster__c,Market_Cluster__c,Market_Cluster_Name__c,IPM_Clustering__c,IPM_Clusters__c,IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, Exempt_from_Threshold__c, IPM_Answer_of_Q3__c,IPM_Strategic_Intent__c,IPM_Target_Launch_Year__c,IPM_Target_Launch_Month__c,IPM_Actual_Launch_Date__c, IPM_Actual_Launch_Month__c,IPM_Actual_Launch_Year__c,IPMPlatform__c,IPM_Project_Type__c,IPM_Project_Description__c, CreatedDate FROM IPM_Project__c WHERE Is_Archieved__c = false'; 
       		IPM_BD_BB_Report_Batch  b = new IPM_BD_BB_Report_Batch(query); 
            database.executebatch(b,100);
       	}   
       	system.assertequals(system.now().day(),reportParameter.Last_Batch_RunDate__c.day(),'Error in Batch Last run date update');       	  
    }
    
    
}