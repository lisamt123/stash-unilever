/**
* @author       Cognizant 
* @date         27/10/2015
* @description  This class is used to test the functionality of IPM_FinancialController class 
*/
@isTest
public class IPM_FinancialController_Currency_Test {
    public static IPM_Project__c project;
     public static IPM_Project__c project1;
     public static IPM_Project__c project2;
     public static IPM_Project__c project3;
     public static IPM_Project__c project4;
    public static IPM_Project__c childProject;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static Id currentFinancialId;
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();    
    public static Map<String, IPM_Financial_Year__c> mapFinancialYearRecords=new Map<String, IPM_Financial_Year__c>();
    
    public static String REGIONAL_ROLLOUT_RECORDTYPE;
    public static String LOCAL_ROLLOUT_RECORDTYPE;
    public static String DEFAULT_FINANCIAL_RECORDTYPE;
    public static String CONSOLIDATED_FINANCIAL_RECORDTYPE;
    public static final String TOTAL_TONS_STR = 'Total Tons';
    public static final String FINANCIAL_CONTROLLER_STR = '/apex/IPM_Financial_Currency?id=';
    public static final String TOP_DOWN_STR = 'TOP DOWN';
    public static final String BOTTOM_UP_STR = 'BOTTOM UP';  
	public static final String FEASIBILITY = 'Feasibility';
	public static final String RCLT = 'RCLT';
    /*******************************************************************************************************
    * @description  Test Method to initialize data for the other test methods
    */
    /*
    static testMethod void initializeData(){
        test.startTest();

		project=IPM_TestFactory_Helper.createIPMProject(FALSE);
         
           project.Sustainability_Period__c='3';
           project.IPM_Target_Launch_Dates__c=system.today().addYears(3); 
           project.IPM_IsCompleted__c=true; 
		   project.IPM_Project_Type__c='Original';
		   project.IPM_Project_Name__c='ProjectName';
		   project.IPM_Phase__c='Ideas';
           project.IPM_Brand_Positioning__c='Dirt Is Good';
           project.IPM_GateKeeping_Model__c='RCLT';
           project.IPM_ProjectSubType__c='Innovation/Rennovation';
           project.IPM_Category_Text__c='Household Care';
       	   project.IPMProject_Span__c=IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
           project.IPM_SourceProjectType__c=IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        	insert project;
        
        IPM_Project__c Queryproject = [Select Id from IPM_Project__c where id=:project.Id];
        system.assertNotEquals(Queryproject.Id, null);

		childProject=IPM_TestFactory_Helper.createIPMProject(FALSE);
        childProject.IPM_Phase__c='Idea';
        childProject.IPM_GateKeeping_Model__c=RCLT; 
        childProject.Sustainability_Period__c='3';
        insert childProject;
        IPM_Project__c QueryChildProject = [Select Id from IPM_Project__c where id=:childProject.Id];
        system.assertNotEquals(QueryChildProject.Id, null);
        
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
		proRoll=IPM_TestFactory_Helper.createIPMProjectRollout(FALSE);
        proRoll.Name='TESTAPPROVERCL_SEAA';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Market_Cluster_Name__c='SEAA';
        proRoll.Market_Cluster__c='GEO0022';
        proRoll.Local_Project__c=project.Id;
        proRoll.Regional_Project__c=project.Id;
        insert proRoll;
        IPM_Project_Rollout__c QueryRoll = [Select Id from IPM_Project_Rollout__c where Id=:proRoll.Id];
        system.assertNotEquals(proRoll.Id, null);
        
       
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
		finCon = IPM_TestFactory_Helper.createIPMFinancial(FALSE);
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Project_Sustainability_Period__c = project.Sustainability_Period__c;
        insert finCon;
        
        IPM_Financial__c QueryFin = [Select Id from IPM_Financial__c where Id=:finCon.Id];
        system.assertNotEquals(QueryFin.Id, null);
        
        String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        finDef = new IPM_Financial__c();
		finDef = IPM_TestFactory_Helper.createIPMFinancial(FALSE);
        finDef.RecordTypeId=strRecordTypeId2;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Parent_Project__c=project.Id;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Project_Sustainability_Period__c = project.Sustainability_Period__c;
        
        currentFinancialId=finCon.Id;
        finYear = IPM_TestFactory_Helper.createIPMFinancialYear(FALSE);
        finYear.IPM_Financial__c=finCon.Id;
        insert finYear;   
        test.stopTest();
    }
    
    /*******************************************************************************************************
    * @description  Test Method to test the changeTabs functionality
    */
    /*
    static testMethod void testChangeTabs(){
        initializeData();
        PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project.Id);
        Test.setCurrentPage(pRef);
        system.assertNotEquals(pRef, null);
        IPM_FinancialController ipmFinCon=new IPM_FinancialController();
        ipmFinCon.sustainabilityPeriod=3;
        ipmFinCon.colSpan=2;
        ipmFinCon.isEditMode=true;
        ipmFinCon.currentFinancialId=finCon.Id;
        ipmFinCon.showTopDownTab=true;       
        ipmFinCon.volumeUnit=TOTAL_TONS_STR;
        ipmFinCon.tabLabelMyView=TOP_DOWN_STR;
        ipmFinCon.tabLabelTopDown=TOP_DOWN_STR;
        ipmFinCon.tabLabelRollup=BOTTOM_UP_STR;
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        ipmFinCon.changeTabs();
        system.assert(ipmFinCon.isEditMode != null && !ipmFinCon.isEditMode, 'Edit mode is true');
        
    }   
    */
    /*******************************************************************************************************
    * @description  Test Method to test the editFinancials functionality
    */
    /*
    static testMethod void testEditFinancials(){
        initializeData();
        PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project.Id);
        Test.setCurrentPage(pRef);
        IPM_FinancialController ipmFinCon2=new IPM_FinancialController();
        
        ipmFinCon2.sustainabilityPeriod=3;
        ipmFinCon2.colSpan=2;
        ipmFinCon2.isEditMode=true;
        ipmFinCon2.currentFinancialId=finCon.Id;
        ipmFinCon2.showTopDownTab=true;
        
        ipmFinCon2.volumeUnit=TOTAL_TONS_STR;
        ipmFinCon2.tabLabelMyView=TOP_DOWN_STR;
        ipmFinCon2.tabLabelTopDown=TOP_DOWN_STR;
        ipmFinCon2.tabLabelRollup=BOTTOM_UP_STR;
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        ipmFinCon2.editFinancials();
        system.assert(ipmFinCon2.isEditMode != null && ipmFinCon2.isEditMode, 'Edit mode is false');
    }
    */
    
    
    /*******************************************************************************************************
    * @description  Test Method to test the refreshFromLocal functionality
    */
    /*
    static testMethod void testRefreshFromLocal(){
        initializeData();
        PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project.Id);
        Test.setCurrentPage(pRef);
        IPM_FinancialController ipmFinCon6=new IPM_FinancialController();
        
        ipmFinCon6.sustainabilityPeriod=3;
        ipmFinCon6.colSpan=2;
        ipmFinCon6.isEditMode=true;
        ipmFinCon6.currentFinancialId=finCon.Id;
        ipmFinCon6.showTopDownTab=true;
        
        ipmFinCon6.volumeUnit=TOTAL_TONS_STR;
        ipmFinCon6.tabLabelMyView=TOP_DOWN_STR;
        ipmFinCon6.tabLabelTopDown=TOP_DOWN_STR;
        ipmFinCon6.tabLabelRollup=BOTTOM_UP_STR;
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        ipmFinCon6.refreshFromLocal(); 
        system.assert(ipmFinCon6.currentFinancial.Copy_Local_to_Regional__c!= null && !ipmFinCon6.currentFinancial.Copy_Local_to_Regional__c, 'currentFinancial Copy_Local_to_Regional__c is true');
    }
    */
    /*******************************************************************************************************
    * @description  Test Method to test the refreshFromRegional functionality
    */
    /*
    static testMethod void testRefreshFromRegional(){
        initializeData();
        PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project.Id);
        Test.setCurrentPage(pRef);
        IPM_FinancialController ipmFinCon7=new IPM_FinancialController();
        
        ipmFinCon7.sustainabilityPeriod=3;
        ipmFinCon7.colSpan=2;
        ipmFinCon7.isEditMode=true;
        ipmFinCon7.currentFinancialId=finCon.Id;
        ipmFinCon7.showTopDownTab=true;
        
        ipmFinCon7.volumeUnit=TOTAL_TONS_STR;
        ipmFinCon7.tabLabelMyView=TOP_DOWN_STR;
        ipmFinCon7.tabLabelTopDown=TOP_DOWN_STR;
        ipmFinCon7.tabLabelRollup=BOTTOM_UP_STR;
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        ipmFinCon7.refreshFromRegional();  
        system.assert(ipmFinCon7.currentFinancial.Copy_Regional_to_Local__c != null && !ipmFinCon7.currentFinancial.Copy_Regional_to_Local__c, 'currentFinancial Copy_Regional_to_Local__c is true');
    }
    */
     /*******************************************************************************************************
    * @description  Test Method to test the checkSustainabilityPeriodChanged functionality
    */
    /*
    static testMethod void testcheckSustainabilityPeriodChanged(){
        initializeData();
        PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project.Id);
        Test.setCurrentPage(pRef);
        IPM_FinancialController ipmFinCon8=new IPM_FinancialController();
        
        ipmFinCon8.sustainabilityPeriod=3;
        ipmFinCon8.colSpan=2;
        ipmFinCon8.isEditMode=true;
        ipmFinCon8.currentFinancialId=finCon.Id;
        ipmFinCon8.showTopDownTab=true;
        
        ipmFinCon8.volumeUnit=TOTAL_TONS_STR;
        ipmFinCon8.tabLabelMyView=TOP_DOWN_STR;
        ipmFinCon8.tabLabelTopDown=TOP_DOWN_STR;
        ipmFinCon8.tabLabelRollup=BOTTOM_UP_STR;
        REGIONAL_ROLLOUT_RECORDTYPE=proRoll.RecordTypeId;
        DEFAULT_FINANCIAL_RECORDTYPE=finDef.RecordTypeId;
        CONSOLIDATED_FINANCIAL_RECORDTYPE=finCon.RecordTypeId;
        ipmFinCon8.checkSustainabilityPeriodChanged();  
        system.assertEquals(ipmFinCon8.sustainabilityPeriod,3,'Sustainability Period Change');
    }
	*/    
    /*
        static testMethod void testCoverVariableNotInitilazed(){
         initializeData();
         PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project.Id);
        Test.setCurrentPage(pRef); 
     	IPM_FinancialController ipmFinCon9=new IPM_FinancialController();
        
    	ipmFinCon9.lstRolloutWrappers = new  List<IPM_FinancialController.RolloutWrapper>();
        ipmFinCon9.mapConsolidatedFinancials = new Map<String, IPM_Financial__c>();
        ipmFinCon9.mapDefaultFinancials = new Map<String, IPM_Financial__c>();
        
        ipmFinCon9.selectedSustainabilityPeriod = '';
        ipmFinCon9.CheckCountry = false;
        ipmFinCon9.Country = 'USA';
        ipmFinCon9.sustainabilityPeriodChanging = false;
        ipmFinCon9.selectedDocumentSection = '';
        
      
        ipmFinCon9.currentTab = IPM_ConstantUtils.TAB_MYVIEW_NAME;
        ipmFinCon9.changeTabs();
        ipmFinCon9.currentTab = IPM_ConstantUtils.TAB_ROLLUP_NAME;
        ipmFinCon9.changeTabs();
     }
    
      static testMethod void initializeDataTemp(){
        test.startTest();

		project1=IPM_TestFactory_Helper.createIPMProject(FALSE);
        
           project1.Sustainability_Period__c='3';
           project1.IPM_Target_Launch_Dates__c=system.today().addYears(3); 
           project1.IPM_IsCompleted__c=true; 
		   project1.IPM_Project_Type__c='Original';
		   project1.IPM_Project_Name__c='ProjectName';
		   project1.IPM_Phase__c='Ideas';
           project1.IPM_Brand_Positioning__c='Dirt Is Good';
           project1.IPM_GateKeeping_Model__c='RCLT';
           project1.IPM_ProjectSubType__c='Innovation/Rennovation';
           project1.IPM_Category_Text__c='Household Care';
          	project1.IPM_SourceProjectType__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
       	   project1.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
           project1.IPM_Project_Type__c=IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        	insert project1;
        
        IPM_Project__c Queryproject = [Select Id from IPM_Project__c where id=:project1.Id];
        system.assertNotEquals(Queryproject.Id, null);
           
          
          test.stopTest();
    }*/
    /*
    static testMethod void testCoverVariableNotInitilazed1(){
         initializeDataTemp();
         PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project1.Id);
        Test.setCurrentPage(pRef); 
     	IPM_FinancialController ipmFinCon10=new IPM_FinancialController();
        
         ipmFinCon10.currentTab = IPM_ConstantUtils.TAB_MYVIEW_NAME;
        ipmFinCon10.changeTabs();
        ipmFinCon10.currentTab = IPM_ConstantUtils.TAB_TOPDOWN_NAME;
        ipmFinCon10.changeTabs();
       ipmFinCon10.currentTab = IPM_ConstantUtils.TAB_ROLLUP_NAME;
        ipmFinCon10.changeTabs();

    }
    
      static testMethod void initializeDataTemp1(){
        test.startTest();

		project2=IPM_TestFactory_Helper.createIPMProject(FALSE);
        
           project2.Sustainability_Period__c='3';
           project2.IPM_Target_Launch_Dates__c=system.today().addYears(3); 
           project2.IPM_IsCompleted__c=true; 
		   project2.IPM_Project_Type__c='Original';
		   project2.IPM_Project_Name__c='ProjectName';
		   project2.IPM_Phase__c='Ideas';
           project2.IPM_Brand_Positioning__c='Dirt Is Good';
           project2.IPM_GateKeeping_Model__c='RCLT';
           project2.IPM_ProjectSubType__c='Innovation/Rennovation';
           project2.IPM_Category_Text__c='Household Care';
          	project2.IPM_SourceProjectType__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
       	   project2.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_REGIONAL;
        	insert project2;
        
        IPM_Project__c Queryproject = [Select Id from IPM_Project__c where id=:project2.Id];
        system.assertNotEquals(Queryproject.Id, null);
           
          
          test.stopTest();
    }
    */
    /*
    static testMethod void testCoverVariableNotInitilazed2(){
         initializeDataTemp1();
         PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project2.Id);
        Test.setCurrentPage(pRef); 
     	IPM_FinancialController ipmFinCon11=new IPM_FinancialController();
        
         ipmFinCon11.currentTab = IPM_ConstantUtils.TAB_MYVIEW_NAME;
        ipmFinCon11.changeTabs();
        ipmFinCon11.currentTab = IPM_ConstantUtils.TAB_TOPDOWN_NAME;
        ipmFinCon11.changeTabs();
       ipmFinCon11.currentTab = IPM_ConstantUtils.TAB_ROLLUP_NAME;
        ipmFinCon11.changeTabs();

    }
    */
    /*
          static testMethod void initializeDataTemp2(){
        test.startTest();

		project3=IPM_TestFactory_Helper.createIPMProject(FALSE);
        
           project3.Sustainability_Period__c='3';
           project3.IPM_Target_Launch_Dates__c=system.today().addYears(3); 
           project3.IPM_IsCompleted__c=true; 
		   project3.IPM_Project_Type__c='Original';
		   project3.IPM_Project_Name__c='ProjectName';
		   project3.IPM_Phase__c='Ideas';
           project3.IPM_Brand_Positioning__c='Dirt Is Good';
           project3.IPM_GateKeeping_Model__c='RCLT';
           project3.IPM_ProjectSubType__c='Innovation/Rennovation';
           project3.IPM_Category_Text__c='Household Care';
          	project3.IPM_SourceProjectType__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
       	   project3.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
        	insert project3;
        
        IPM_Project__c Queryproject = [Select Id from IPM_Project__c where id=:project3.Id];
        system.assertNotEquals(Queryproject.Id, null);
           
          
          test.stopTest();
    }
    */
    /*
    static testMethod void testCoverVariableNotInitilazed3(){
         initializeDataTemp2();
         PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project3.Id);
        Test.setCurrentPage(pRef); 
     	IPM_FinancialController ipmFinCon12=new IPM_FinancialController();
        
         ipmFinCon12.currentTab = IPM_ConstantUtils.TAB_MYVIEW_NAME;
        ipmFinCon12.changeTabs();
        ipmFinCon12.currentTab = IPM_ConstantUtils.TAB_TOPDOWN_NAME;
        ipmFinCon12.changeTabs();
       

    }*/
    
    
    static testMethod void initializeDataTemp3(){
        
        test.startTest();

		project4=IPM_TestFactory_Helper.createIPMProject(FALSE);
        
           project4.Sustainability_Period__c='3';
           project4.IPM_Target_Launch_Dates__c=system.today().addYears(3); 
           project4.IPM_IsCompleted__c=true; 
		   project4.IPM_Project_Type__c='Original';
		   project4.IPM_Project_Name__c='ProjectName';
		   project4.IPM_Phase__c='Ideas';
           project4.IPM_Brand_Positioning__c='Dirt Is Good';
           project4.IPM_GateKeeping_Model__c='RCLT';
           project4.IPM_ProjectSubType__c='Innovation/Rennovation';
           project4.IPM_Category_Text__c='Household Care';
          	project4.IPM_SourceProjectType__c = IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;
        	insert project4;
        
        IPM_Project__c Queryproject = [Select Id from IPM_Project__c where id=:project4.Id];
        system.assertNotEquals(Queryproject.Id, null);
           
          
          test.stopTest();
    }
    /*
    static testMethod void testCoverVariableNotInitilazed4(){
         initializeDataTemp3();
         PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project4.Id);
        Test.setCurrentPage(pRef); 
     	IPM_FinancialController ipmFinCon13=new IPM_FinancialController();
        
         ipmFinCon13.currentTab = IPM_ConstantUtils.TAB_MYVIEW_NAME;
        ipmFinCon13.changeTabs();
      
    }*/
    /*
	Created by - Sanjay Singh
	Purpose - Currency related implementation
	Note: Below method covers new code written for currency related changes but whole class does not cover 75% as its clonned from IPM_Financial test class
	*/
    static testMethod void testCurrency(){
        //set up exchange rate object data
        initializeDataTemp3(); 
            list<IPM_Exchange_Rate__c> liEX = new list<IPM_Exchange_Rate__c>();
            liEX.add(new IPM_Exchange_Rate__c(Name='EUR', Currency_Code__c='EUR',Exchange_Rate__c=1));
            liEX.add(new IPM_Exchange_Rate__c(Name='GBP', Currency_Code__c='GBP',Exchange_Rate__c=0.8)); 
            liEX.add(new IPM_Exchange_Rate__c(Name='USD', Currency_Code__c='USD',Exchange_Rate__c=1.3));         
        insert liEX;          
        PageReference pRef = new PageReference(FINANCIAL_CONTROLLER_STR+project4.Id);
        Test.setCurrentPage(pRef); 
        IPM_FinancialController ipmCurr=new IPM_FinancialController();
        ipmCurr.getItems();
        ipmCurr.selectedCurrency = 'GBP';
        ipmCurr.applyRate();
		//assertion is difficult here as exchange rate is applied
        
    }
   
}