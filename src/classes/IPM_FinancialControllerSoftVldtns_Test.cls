/*******************************************************
* @Author:Cognizant  
* @Name: IPM_FinancialControllerSoftVldtns_Test.cls
* @Description: Test class for Soft validations of financials
* @Author:Cognizant
* @Date:08/02/2016
* *****************************************************/


@isTest
private class IPM_FinancialControllerSoftVldtns_Test
{
  
  private static List<IPM_Company_Card__c> companyCardList; 
  private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
  private static final String ORIGINAL = 'Original';
  private static final String GLOBAL_PL = 'GLOBAL_PL';
  private static final String REGIONAL_PL = 'REGIONAL_PL';
  private static final String LOCAL_PL = 'LOCAL_PL';
  private static final String GLOBAL_COMPANY_CARD = 'Global Company Card';
  private static final String PROJECTS_NOT_CREATED = 'Projects not created';
  private static final string TEST_STR = 'test';

  
  /***********************************
  Description of the purpose of the method. 
  @name: projectSetUp
  @Description: To test insertAssessments method
  ***********************************/
  @testSetup static void projectSetUp() 
  {
    // Create an instance of admin user.
    User adminUser = IPM_TestFactory_Helper.createUserAdmin(false);
    insert adminUser;
    User globalProjectLeader = null;
    // Create an instances of standard Users for Allocation to Project Leaders.
    System.runAs(adminUser)
    {   
      globalProjectLeader = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
      User regionalProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
      User localProjectLeader =IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
      
      // Update LastNames to match functionalRoles
      globalProjectLeader.lastname = GLOBAL_PL;
      regionalProjectLeader.lastname = REGIONAL_PL;
      localProjectLeader.lastname = LOCAL_PL; 
      
      List<User> userList = new List<User>{globalProjectLeader,regionalProjectLeader,localProjectLeader};
      update userList;
    } 
    
    // Create Company Card information(Master Data)
    IPM_Company_Card__c globalCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
    IPM_Company_Card__c regionalCompanyCard = IPM_TestFactory_Helper.createRegionalCompanyCard(false);
    IPM_Company_Card__c localCompanyCard = IPM_TestFactory_Helper.createLocalCompanyCard(false);
    
    companyCardList = new List<IPM_Company_Card__c>{globalCompanyCard,regionalCompanyCard,localCompanyCard};
    insert companyCardList;
    
    // Inserting Master Data whose OWD are set to readOnly/View All    
    IPM_TestFactory_Helper.getProjectMasterData();
    
    // Insert the project as a Global project Leader.
    projectList = IPM_TestFactory_Helper.projectSetUp(4,globalProjectLeader);
    
    System.runAs(globalProjectLeader)
    {   
      
      for(IPM_Project__c proj : projectList)
      {
        proj.First_Sync_To_EcoDesign__c = true;
        proj.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
        proj.IPMProject_Span__c = IPM_ConstantUtils.PROJECT_SPAN_GLOBAL;
        proj.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        proj.IPM_CompanyCardText__c = GLOBAL_COMPANY_CARD;
        proj.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;
        proj.IPM_Company_Card__c = companyCardList[0].Id;
        proj.IPM_Project_Gatekeeper__c = UserInfo.getUserId();
        proj.IPM_Project_Leader__c = UserInfo.getUserId();
        proj.IPM_SourceProjectType__c = ORIGINAL;
        proj.Success_Timestamp_EcoDesign__c = System.now().addHours(2);
        proj.IPM_Category_Group__c = 'Home Care';

      }
      insert projectList;
      
      IPM_TestFactory_Helper.createRegionalRolloutList(true,projectList,new List<User>{globalProjectLeader,globalProjectLeader,globalProjectLeader,globalProjectLeader});
      
      List<IPM_Project__c> projectListTemp = [Select id From IPM_Project__c Where id IN : projectList limit 1000 ];
      system.assert(projectListTemp.size() > 0,PROJECTS_NOT_CREATED);
      
      List<IPM_Financial__c> consolidatedFinLst = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c Where Financial_external_Id__c like '%CONSOLIDATED' limit 1000]);
      
      Test.startTest();
     
      //creating local financials starts
      List<IPM_Financial_year__c> finYearLst = new List<IPM_Financial_year__c>();
      IPM_Financial_year__c finTemp;
      
      for(IPM_Financial__c fin : consolidatedFinLst){
            finTemp = IPM_TestFactory_Helper.createIPMFinancialYear(false);
            finTemp.IPM_Financial__c = fin.Id;
            finYearLst.add(finTemp);
      }
      
      insert finYearLst;
      
      
      Set<Id> projectIdset = new Set<Id>();
      
      for(IPM_Project__c proj : projectListTemp){
        projectIdset.add(proj.Id);
      }
      
      List<IPM_Project__c> lstProjectsAndRollout = [Select id, (Select Id, name,IPM_Rollout_Project__c,Market_Cluster__c,IPM_Rollout_Type__c,Target_Launch_Date__c from IPM_Project_Rollout__r limit 1000) from IPM_Project__c where Id IN :projectIdset limit 1000];
      
      Map<Id, List<IPM_Project_Rollout__c>> projIdTORegRolloutMap =  new Map<Id, List<IPM_Project_Rollout__c>>();
      
      for(IPM_Project__c proj : lstProjectsAndRollout ){
        projIdTORegRolloutMap.put(proj.id, proj.IPM_Project_Rollout__r);
      }
      
      IPM_TestFactory_Helper.createLocalRolloutsList(true,projIdTORegRolloutMap,new List<User>{globalProjectLeader,globalProjectLeader,globalProjectLeader,globalProjectLeader});
      
      //creating local financials Ends
      
      List<IPM_Financial__c> NonConsolidatedFinLst = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c Where Financial_external_Id__c like 'TestComments1%' limit 1000]);
      
      System.assert(NonConsolidatedFinLst.size()>1,'No Non consolidated business created');
      
      Test.stopTest();
      
      
    }
  }
  
  
  public static testmethod void testBelowThresholdSoftValidation(){
      
      User globalProjectLeader = [Select Id,Name,lastName from User where LastName =:GLOBAL_PL limit 1000];
      
      List<IPM_Financial__c> lstFin = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c limit 1000]);
      List<IPM_Financial__c> consolidatedFinLst = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c Where Financial_external_Id__c like '%CONSOLIDATED' limit 1000]);
      List<IPM_Project__c> lstProjects = [Select id, name, IPM_Phase__c, IPM_ProjectGKM__c,IPM_SourceProjectType__c from IPM_Project__c Where Name != 'IPM_MasterProject' limit 1000];
      
      lstProjects[0].IPM_SourceProjectType__c = 'Original';
      lstProjects[0].IPM_ProjectGKM__c = 'GKM1';
      Update lstProjects[0];

      System.runAs(globalProjectLeader){
          //Id defaultRecordTypeId = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
      
          PageReference pageRef = Page.IPM_Financial;
          Test.setCurrentPage(pageRef);
         
          
            
          ApexPages.currentPage().getParameters().put('Id', lstProjects[0].Id);
          
          IPM_FinancialController finController =  new IPM_FinancialController();
          finController.currentFinancialId = lstFin[0].Id;
          finController.currentFinancial = lstFin[0];
          finController.setConsolidatedFinancialValidationCells();
          finController.getFinExtIdsForCurrentTab();
          finController.getExistingNonCurrentFinancialValues(consolidatedFinLst[0],'Red');
          finController.getExistingNonCurrentFinancialValues(consolidatedFinLst[0],'Yellow');
          
          finController.validateFinancialSummaryTable(lstFin[0]);
          finController.getCurrentFinancialType(lstFin[0]);
          finController.getConsolidatedValidationCells(lstFin[0]);
          finController.saveFinancials();
          System.assert(finController.currentFinancialType == IPM_ConstantUtils.CONSOLIDATED,'Non Consolidated project evaluated');
      }

  }
  
  
  public static testmethod void testAboveThresholdSoftValidation(){
      
      User globalProjectLeader = [Select Id,Name,lastName from User where LastName =:GLOBAL_PL limit 1000];
      
      List<IPM_Financial__c> lstFin = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c limit 1000]);
      List<IPM_Project__c> lstProjects = [Select id, name, IPM_Phase__c, IPM_ProjectGKM__c,IPM_SourceProjectType__c from IPM_Project__c Where Name != 'IPM_MasterProject' limit 1000];
      
      PageReference pageRef = Page.IPM_Financial;
      Test.setCurrentPage(pageRef);

      
      
      lstProjects[1].IPM_SourceProjectType__c = 'Original';
      lstProjects[1].IPM_ProjectGKM__c = 'GKM1';
      lstProjects[1].IPM_Project_Y3iTO__c  = 3000.00;
      Update lstProjects[1];
      
      Test.startTest();
      
      System.runAs(globalProjectLeader){
        ApexPages.currentPage().getParameters().put('Id', lstProjects[1].Id);
      
        IPM_FinancialController finController2 =  new IPM_FinancialController();
        finController2.currentFinancialId = lstFin[1].Id;
        finController2.currentFinancial = lstFin[1];
          
        finController2.setConsolidatedFinancialValidationCells();
          
        System.assertEquals(finController2.isNonkey,false,'Nonkey');
        System.assertEquals(finController2.isConsolidatedOrNonkey,true,'isconNonkey');
        System.assert(finController2.tldAcceptFromValue!=null,'tldaccept');
        System.assert(finController2.targetLaunchDateToDisplay!=null,'targetLaunchDateToDisplay');
        Test.stopTest();
      }

  }
  
  public static testmethod void test_CAPEX_IRR_NPV_PAYBACK(){
      
      User globalProjectLeader = [Select Id,Name,lastName from User where LastName =:GLOBAL_PL limit 1000];
      
      List<IPM_Financial__c> lstFin = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c limit 1000]);
	  List<IPM_Project__c> lstProjects = [Select id, name, IPM_Phase__c, IPM_ProjectGKM__c,IPM_SourceProjectType__c from IPM_Project__c Where Name != 'IPM_MasterProject' limit 1000];
      
      PageReference pageRef = Page.IPM_Financial;
      Test.setCurrentPage(pageRef);

      
      
      lstProjects[1].IPM_SourceProjectType__c = 'Original';
      lstProjects[1].IPM_ProjectGKM__c = 'GKM1';
      lstProjects[1].IPM_Project_Y3iTO__c  = 3000.00;
      Update lstProjects[1];
      
      Test.startTest();
      
      System.runAs(globalProjectLeader){
        ApexPages.currentPage().getParameters().put('Id', lstProjects[1].Id);
      	IPM_Financial__c currentFinancial = null;
      	for(IPM_Financial__c fin: lstFin){
      		if(!fin.Financial_External_ID__c.endsWith(IPM_ConstantUtils.FINANCIAL_CONSOLIDATE)){
      			currentFinancial = fin;
      			break;
      		}
      	}
      
        IPM_FinancialController finController2 =  new IPM_FinancialController();
        finController2.currentFinancialId = currentFinancial.Id;
        finController2.currentFinancial = currentFinancial;
        finController2.isFinacialConsolidated = false;
          

        List<IPM_FinancialValueWrapper> lstIncrementalPLProfit = new List<IPM_FinancialValueWrapper>();
        IPM_FinancialValueWrapper valueWrapper = new IPM_FinancialValueWrapper(0, IPM_ConstantUtils.INVALID_VALUE, 0,TEST_STR,currentFinancial,IPM_ConstantUtils.TAB_MYVIEW_NAME);
        lstIncrementalPLProfit.add(valueWrapper);
        boolean flag = finController2.validateGrossProfit(lstIncrementalPLProfit);
        system.assertEquals(flag, true, 'Gross profit validation failed');

        flag = finController2.validateGrossTurnover(lstIncrementalPLProfit);
        system.assertEquals(flag, true, 'Gross turnover cannot be validated');
                
        flag = finController2.validateIncrementalTurnover(lstIncrementalPLProfit);
        system.assertEquals(flag, true,'Incremental turnover cannot be validated');
                
        flag = finController2.validateIncrementalProfit(lstIncrementalPLProfit);    
        system.assertEquals(flag, true,'Incremental PL proft cannot be validated');
            
            
        flag = finController2.validateGrossPBO(lstIncrementalPLProfit);
		system.assertEquals(flag, true,'Gross PBO cannot be validated');
            
        flag = finController2.validateIncrementalPBO(lstIncrementalPLProfit);     
        system.assertEquals(flag, true,'Incremental PBO validation failed');
        
        flag = finController2.validateGrossProfit(lstIncrementalPLProfit);
        system.assertEquals(flag, true,'Gross profit validation failed');
        
        
        flag = finController2.validateGrossBMI(lstIncrementalPLProfit);
        system.assertEquals(flag, true,'Gross BMI validation failed');
        
        flag = finController2.validateIncrementalBMI(lstIncrementalPLProfit);     
        system.assertEquals(flag, true,'Incremental BMI validation failed');
        
        Test.stopTest();
      }

  }
  

}