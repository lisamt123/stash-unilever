/*******************************************************
* @Author:Cognizant  
* @Name: IPM_EcoDesignSection_Test
* @Description: Test class for IPM_EcoDesignSection
* @Author:Cognizant
* @Date:04/22/2015
* *****************************************************/


@isTest
private class IPM_FinancialControllerSoftVldtns_Test
{
  
  //private static List<IPM_Assessment__c> finalAssessmentList = new List<IPM_Assessment__c>();
  private static List<IPM_Company_Card__c> companyCardList; 
  //private static List<IPM_Country__c> countryList= new List<IPM_Country__c>();
  private static List<IPM_Project__c> projectList = new List<IPM_Project__c>();
  //private static List<IPM_Project__c> projectListPhaseChange;
  //private static final String ENVIRONMENTAL_IMPACT = 'Environmental_Impact';
  //private static final String WITH_MCO = 'With MCO';
  private static final String ORIGINAL = 'Original';
  //private static final String REGIONAL = 'Regional';
  //private static final String REGIONAL_COMPANY_CARD = 'Regional Company Card';
  //private static final String PROJ_DOC_SEC_Id = 'ProjDocSecId';
  //private static final String ID = 'Id';
  //private static final String TESTSTR = 'Test';
  //private static final String PRINTDOC = 'printDoc';
  private static final String GLOBAL_PL = 'GLOBAL_PL';
  private static final String REGIONAL_PL = 'REGIONAL_PL';
  private static final String LOCAL_PL = 'LOCAL_PL';
  private static final String GLOBAL_COMPANY_CARD = 'Global Company Card';
  //private static final String EICOUNTRIES_NOT_MATCHED = 'EICountries size not matched';
  //private static final String NON_EICOUNTRIES_NOT_MATCHED = 'NonEICountries size not matched';
  //private static final String DOCUMENT_NOT_CREATED = 'Document not created';
  //private static final String ASSESSMENT_NOT_CREATED = 'Assessments are not created';
  //private static final String COUNTRIES_NOT_CREATED = 'Countries not created';
  //private static final String GEOGRAPHY_NOT_CREATED = 'Geography not created';
  private static final String PROJECTS_NOT_CREATED = 'Projects not created';
  //private static final String PROJECT_PHASE_INCORRECT = 'Project phase is not correct';
  //private static final String TESTCOMMENT_1 = 'TestComments1';
  //private static final String TESTCOMMENT_2 = 'TestComments2';
  //private static final String TESTCOMMENT_3 = 'TestComments3';
  //private static final String AF = 'AF';
  //private static final String AG = 'AG';
  //private static final String LA = 'LA';
  //private static final String BR = 'BR';
  
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
      
      List<IPM_Project__c> projectListTemp = [Select id From IPM_Project__c Where id IN : projectList ];
      system.assert(projectListTemp.size() > 0,PROJECTS_NOT_CREATED);
      
      List<IPM_Financial__c> consolidatedFinLst = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c Where Financial_external_Id__c like '%CONSOLIDATED']);
      
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
      
      List<IPM_Project__c> lstProjectsAndRollout = [Select id, (Select Id, name,IPM_Rollout_Project__c,Market_Cluster__c,IPM_Rollout_Type__c,Target_Launch_Date__c from IPM_Project_Rollout__r) from IPM_Project__c where Id IN :projectIdset];
      
      Map<Id, List<IPM_Project_Rollout__c>> projIdTORegRolloutMap =  new Map<Id, List<IPM_Project_Rollout__c>>();
      
      for(IPM_Project__c proj : lstProjectsAndRollout ){
        projIdTORegRolloutMap.put(proj.id, proj.IPM_Project_Rollout__r);
      }
      
      IPM_TestFactory_Helper.createLocalRolloutsList(true,projIdTORegRolloutMap,new List<User>{globalProjectLeader,globalProjectLeader,globalProjectLeader,globalProjectLeader});
      
      //creating local financials Ends
      
      List<IPM_Financial__c> NonConsolidatedFinLst = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c Where Financial_external_Id__c like 'TestComments1%']);
      
      System.assert(NonConsolidatedFinLst.size()>1,'No Non consolidated business created');
      
      Test.stopTest();
      
      
    }
  }
  
  
  public static testmethod void testBelowThresholdSoftValidation(){
      
      User globalProjectLeader = [Select Id,Name,lastName from User where LastName =:GLOBAL_PL];
      
      List<IPM_Financial__c> lstFin = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c]);
      List<IPM_Financial__c> consolidatedFinLst = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c Where Financial_external_Id__c like '%CONSOLIDATED']);
      List<IPM_Project__c> lstProjects = [Select id, name, IPM_Phase__c, IPM_ProjectGKM__c,IPM_SourceProjectType__c from IPM_Project__c Where Name != 'IPM_MasterProject'];
      
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
      
      User globalProjectLeader = [Select Id,Name,lastName from User where LastName =:GLOBAL_PL];
      
      List<IPM_Financial__c> lstFin = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c]);
      //List<IPM_Financial__c> consolidatedFinLst = new List <IPM_Financial__c>([Select Id, Financial_external_Id__c,Red_Validation_Cells__c,Yellow_Validation_Cells__c from IPM_Financial__c Where Financial_external_Id__c like '%CONSOLIDATED']);
      List<IPM_Project__c> lstProjects = [Select id, name, IPM_Phase__c, IPM_ProjectGKM__c,IPM_SourceProjectType__c from IPM_Project__c Where Name != 'IPM_MasterProject'];
      
     
      
      //Id defaultRecordTypeId = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT).getRecordTypeId();
      

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

}