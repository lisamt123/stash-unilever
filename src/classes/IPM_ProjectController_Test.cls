@isTest
private class IPM_ProjectController_Test{
public static IPM_Project__c project;
    public static IPM_Project__c childProject;
    public static IPM_Project_Rollout__c proRoll=new IPM_Project_Rollout__c();
    public static List<IPM_Financial__c> lstFinancial=new List<IPM_Financial__c>();
    public static Id currentFinancialId;
    public static IPM_Financial__c finCon=new IPM_Financial__c();
    public static IPM_Financial__c finDef=new IPM_Financial__c();
    public static IPM_Financial_Year__c finYear=new IPM_Financial_Year__c();
    //public static  List<RolloutWrapper> lstRolloutWrappers=new  List<RolloutWrapper>();
   public static Map<String, IPM_Financial_Year__c> mapFinancialYearRecords=new Map<String, IPM_Financial_Year__c>();


   static testMethod void testIpmProjectController_Constructor(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
        createUserBosscard(); 
        IPM_ProjectController_Test ipmProjectControllerRevampClassTest = new IPM_ProjectController_Test();
        testRunAsBosscard();       
        IPM_User_Profile__c  ipmUserProfile= createIpmUserProfileBosscard();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
        List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);

        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
        ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        //createIpmUserProfileBosscard();
        
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        
         sic = new IPM_ProjectController (sc);
         Test.stopTest(); 
    
    }
    
  static testMethod void TestGetCompanyCard(){
       IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
        createUserBosscard(); 
        IPM_ProjectController_Test ipmProjectControllerRevampClassTest = new IPM_ProjectController_Test();
        //testRunAsBosscard1();       
        IPM_User_Profile__c  ipmUserProfile= createIpmUserProfileBosscard();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();


        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
        ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        //createIpmUserProfileBosscard();
        
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.getCompanyCard();
        Test.stopTest(); 
        
  }
  
   
   
   static testMethod void TestGetCategory(){
      IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
        createUserBosscard(); 
        IPM_ProjectController_Test ipmProjectControllerRevampClassTest = new IPM_ProjectController_Test();
        //testRunAsBosscard1();       
        IPM_User_Profile__c  ipmUserProfile= createIpmUserProfileBosscard();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();


        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        //createIpmUserProfileBosscard();
        
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.getCategory();
        Test.stopTest(); 
   
   
   }
   
      static testMethod void TestGetListOfQuarter(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();


        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.getListOfQuarter();
        Test.stopTest(); 
   
   
   }
   
   static testMethod void TestGetBrands(){
      IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
        createUserBosscard(); 
        IPM_ProjectController_Test ipmProjectControllerRevampClassTest = new IPM_ProjectController_Test();
        //testRunAsBosscard1();       
        IPM_User_Profile__c  ipmUserProfile= createIpmUserProfileBosscard();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();

        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        //createIpmUserProfileBosscard();
        
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.getBrands();
        Test.stopTest(); 
   
   
   }
  
     static testMethod void TestGetBrandPos(){
      IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
        createUserBosscard(); 
        IPM_ProjectController_Test ipmProjectControllerRevampClassTest = new IPM_ProjectController_Test();
        //testRunAsBosscard1();       
        IPM_User_Profile__c  ipmUserProfile= createIpmUserProfileBosscard();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        //createIpmUserProfileBosscard();
        
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        sic.selCat ='HHC';
        
        sic.getBrandPos();
        Test.stopTest(); 
   
   
   }
   
   static testMethod void TestGetCharterApprovers(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();

        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.getCharterApprovers();
        Test.stopTest(); 
   
   }
    
   
   static testMethod void TestGetContractApprovers(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();

        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.getContractApprovers();
        Test.stopTest(); 
   
   }
   
      
   static testMethod void TestSave(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
              
                
        
        List<IPM_Project__c> ipmProjects= listIPMProjects;
        sic.project = ipmProjects[0];
        
        sic.project.IPM_Project_Name__c = 'Test';
        sic.selBrand = 'Test'; 
        sic.ImageId = 'Test'; 
        
        sic.save();
        
        sic.project.IPM_Project_Name__c = '99999';
        sic.save();
        
        
        sic.save();
        
        sic.project.IPM_Project_Name__c = '';
        sic.proId = ipmProjects[0].Id;
        sic.save();
        
        sic.proId = 'jjijd';
        sic.save();
        Test.stopTest();         
        
        
   
   }
   
   static  void TestAutosave(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();

        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        sic.proId = 'jjijd';
        sic.project = listIPMProjects[0];
        sic.autosave();
        Test.stopTest(); 

   }
   
   static  void TestSavetabname(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();

        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        sic.proId = 'jjijd';
        sic.project = listIPMProjects[0];
        sic.Savetabname();
        Test.stopTest(); 

   }
   
   static  void TestSearchbrandPos(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();

        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        sic.proId = 'jjijd';
        sic.project = listIPMProjects[0];
        sic.SearchbrandPos();
        Test.stopTest(); 

   }
   
   static testMethod void TestSaveProceed(){
   /*
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        //List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);
        
          
        List<IPM_Project__c> listIPMProjects = new List<IPM_Project__c>();
       
           IPM_Project__c ipmProject = new IPM_Project__c();
           ipmProject.IPM_Project_Name__c ='test';
           ipmProject.Sustainability_Period__c = '3';
           ipmProject.Sustainability_Period_Changed__c = true;
           

           ipmProject.IPM_Complexity__c = 'Full';
           ipmProject.IPM_Project_Leader__c=Userinfo.getUserId();
           insert ipmProject;
           
           ipmProject.IPM_Project_Name__c ='test1';
           listIPMProjects.add(ipmProject);
           
           ipmProject = new IPM_Project__c();
           insert ipmProject;
           listIPMProjects.add(ipmProject);
     


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        //sic.saveProceed();
        
        sic.project = listIPMProjects[0];
        sic.project.IPM_Project_Name__c='';
        sic.project.Sustainability_Period__c = '3';
        sic.project.Sustainability_Period_Changed__c = true;
        //update sic.project;


        childProject=new IPM_Project__c();
        childProject.Name='TESTAPPROVERCL_SEAA';
        childProject.IPM_Phase__c='Feasibility';
        childProject.IPM_Complexity__c='Full';
        childProject.IPM_GateKeeping_Model__c='RCLT'; 
        childProject.Sustainability_Period__c='3';
        insert childProject;

        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TESTAPPROVERCL_SEAA';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=sic.project.ID;
        
        proRoll.Target_Launch_Date__c=System.today();
        proRoll.Market_Cluster_Name__c='SEAA';
        proRoll.Market_Cluster__c='GEO0022';
        proRoll.Local_Project__c=sic.project.Id;
        proRoll.Regional_Project__c=sic.project.Id;
        insert proRoll;
        
        String strRecordTypeId1=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Consolidated'].Id;
        finCon.RecordTypeId=strRecordTypeId1;
        finCon.Volume_Unit__c='Total Tons';
        finCon.Financial_External_ID__c='TESTAPPROVERCL_CONSOLIDATED';
        finCon.Target_Launch_Date__c=System.today();
        finCon.Status__c='Not Started';
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        finCon.Parent_Project__c=sic.project.Id;
        finCon.IPM_Project_Rollout__c=proRoll.Id;
        insert finCon;
         
        String strRecordTypeId2=[Select Id From RecordType Where SobjectType='IPM_Financial__c' and Name='Default'].Id;
        finDef.RecordTypeId=strRecordTypeId2;
        finDef.Volume_Unit__c='Total Tons';
        finDef.Financial_External_ID__c='external11';
        finDef.Target_Launch_Date__c=System.today();
        finDef.Status__c='Not Started';
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        finDef.Parent_Project__c=sic.project.Id;
        finDef.IPM_Project_Rollout__c=proRoll.Id;
        insert finDef;
        
        currentFinancialId=finDef.Id;
         
        finYear.IPM_Financial__c=finCon.Id;
        finYear.Name='Y0';
        finYear.Year__c='0';
        finYear.Year_Type__c='Innovation';
        insert finYear;  




        
        sic.project.IPM_Project_Name__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.project.IPM_Project_Description__c ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selCat = 'test';
        sic.selBrandPos  = 'test';
        date myDate = date.newInstance(1990, 11, 21);
        date newDate = myDate.addMonths(3);
        
        sic.project.IPM_Target_Launch_Dates__c = newDate ;
        
        //sic.saveProceed();
        
        sic.project.IPM_Project_Description__c ='9999';
        //sic.saveProceed();
        
        sic.project.IPM_Project_Description__c ='$$$$$$';
        //sic.saveProceed();
        
        sic.project.IPM_Project_Name__c=null;
        //sic.saveProceed();
        
        sic.project.IPM_Project_Name__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.project.IPM_Project_Description__c =null;
        //sic.saveProceed();
        
        sic.project.IPM_Project_Name__c='aaaaaaa55';
        sic.project.IPM_Project_Description__c ='fdfdf';
        //sic.saveProceed();
        
        sic.proId= listIPMProjects[0].Id;
        //sic.saveProceed();
        Test.stopTest(); 
        

       */ 
   }
   
      
   static testMethod void TestSaveRecords(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.SaveRecords();
        
        sic.project = listIPMProjects[0];
        sic.project.IPM_Project_Name__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.proId= listIPMProjects[0].Id;
        sic.SaveRecords();
        Test.stopTest(); 
   
   }
   
   
   static testMethod void TestProjectIdGeneration(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();

        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        sic.project = listIPMProjects[0];
        
        sic.proId = listIPMProjects[0].Id;
        
        sic.ProjectIdGeneration();
        Test.stopTest(); 
   
   }
   
   
   static testMethod void TestCreateproject(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.createproject();
        Test.stopTest(); 
   
   }
   
   static testMethod void TestCorerefresh(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.corerefresh();
        Test.stopTest(); 
   
   }
   
   
   static testMethod void TestGetAllcompanycard(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.getAllcompanycard();
        Test.stopTest(); 
   
   }
   
   static testMethod void TestSearchprojectpahse(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);


        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.searchprojectpahse();
        Test.stopTest(); 
   
   }
   

   static void TestgetMilesTaskIpmuserType(){
       IPM_TestDataUtils testData = new IPM_TestDataUtils();
       Test.startTest();
               List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);

        
        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
       
       createIPMProjectResource('Guest',listIPMProjects[0]);

        
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        
        sic.getMilesTaskIpmuserType();
        
        createIPMProjectResource('BD Marketing',listIPMProjects[0]);
        sic.getMilesTaskIpmuserType();
        
        createIPMProjectResource('BD',listIPMProjects[0]);
        sic.getMilesTaskIpmuserType();
        
        createIPMProjectResource('CMI',listIPMProjects[0]);
        sic.getMilesTaskIpmuserType();
        
        createIPMProjectResource('Finance',listIPMProjects[0]);
        sic.getMilesTaskIpmuserType();
        
        createIPMProjectResource('R&D',listIPMProjects[0]);
        sic.getMilesTaskIpmuserType();
        
        createIPMProjectResource('CD',listIPMProjects[0]);
        sic.getMilesTaskIpmuserType();
       
       Test.stopTest(); 
   
   }
    
   static testMethod void TestSaveComplexityType (){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);

        
        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
                
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        sic.ComplexityType = 'Test';
        sic.project=listIPMProjects[0];
        sic.SaveComplexityType ();
        Test.stopTest(); 
   
   }  
   
   static testMethod void TestNone (){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);

        
        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
                
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        sic.none();
        Test.stopTest(); 
   
   }
   
   static testMethod void TestSaveIPMApproach (){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        Test.startTest();
                List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
        
        List<IPM_Project__c> listIPMProjects= createIPMProjects(listBosscard[0].id);

        
        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
                ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
                
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        IPM_ProjectController  sic = new IPM_ProjectController (sc);
        sic.project = listIPMProjects[0];
        sic.project.IPM_PM_Approach__c ='External';
        sic.SaveIPMApproach();
        
        sic.project.IPM_PM_Approach__c ='Internal';
        sic.SaveIPMApproach();
        Test.stopTest(); 
   
   }
   
   
   static User createUserBosscard(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 

        User u = new User();

        
             u = new User(Alias = 'teyd012', Email='newuser@testorgbosscard1.com', 
             EmailEncodingKey='UTF-8', LastName='teyd012', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@teyd012.com', 
             IPM_Category__c = 'teyd012'  , IPM_Brand_Positioning__c= 'teyd012',IPM_Brand_Name__c ='teyd012',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;

         return u;
    }
   static User  testRunAsBosscard() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              User u = new User(Alias = 'teyd0121', Email='standarduser@teyd0121.com', 
              EmailEncodingKey='UTF-8', LastName='testorgbosscrdaa', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@teyd0121.com', 
              IPM_Category__c = 'teyd0121'  , IPM_Brand_Positioning__c= 'teyd0121',IPM_Brand_Name__c ='teyd0121',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='teyd0121', isActive =true);
              insert u;
              
              
              
              System.runAs(u) {
                 // The following code runs as user 'u' 
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
              }

      return u ;
   }
   
   static IPM_User_Profile__c  createIpmUserProfileBosscard(){
       
      User u =  testRunAsBosscard1();
      User u1 =   createUserBosscard1();
      
     /* List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
      PermissionSet Fps=new PermissionSet();
      Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_ProjectLeader'];
      */
       
      IPM_User_Profile__c ipmUserProfile = new IPM_User_Profile__c();
      //IPM_Company_Card__c  ipmCompanyCard = createIpmCompanyCard();
      
      //ipmUserProfile.IPM_Company_Card__c = ipmCompanyCard.Id ;
      //ipmUserProfile.IPM_Business_Partner__c = true;
      //ipmUserProfile.IPM_Deputy_Business_Partner__c = true;
      ipmUserProfile.IPM_user__c =  u1.id;
      
      
     /* PermissionSetAssignment Fps1= new PermissionSetAssignment(); 

              
                 Fps1.PermissionSetId = Fps.id; //set the permission set Id
                 Fps1.AssigneeId = u1.Id; //set the User Id
                 newPermissionSetAccess.add(Fps1); 
      //insert newPermissionSetAccess;
      */
      
      
      //insert ipmUserProfile;
      
      return ipmUserProfile ;
   
   
   }
   
      
   static User  testRunAsBosscard1() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              User u = new User(Alias = 'b11111', Email='standarduser@b11111.com', 
              EmailEncodingKey='UTF-8', LastName='b11111', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@b11111.com', 
              IPM_Category__c = 'b11111'  , IPM_Brand_Positioning__c= 'b11111',IPM_Brand_Name__c ='b11111',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='b11111', isActive =true);
              insert u;
              
              
              
              System.runAs(u) {
                 // The following code runs as user 'u' 
                 System.debug('Current User: ' + UserInfo.getUserName());
                 System.debug('Current Profile: ' + UserInfo.getProfileId()); 
              }

      return u ;
   }
    
    static User createUserBosscard1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 

        User u = new User();

             u = new User(Alias = 'b11112', Email='newuser@b11112.com', 
             EmailEncodingKey='UTF-8', LastName='b11112', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@b11112.com', 
             IPM_Category__c = 'b11112'  , IPM_Brand_Positioning__c= 'b11112',IPM_Brand_Name__c ='b11112',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;

         return u;
    }
    
   static List<IPM_Project__c> createIPMProjects(Id bosscard){
       
       List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
       
           IPM_Project__c ipmProject = new IPM_Project__c();
           ipmProject.IPM_Project_Name__c ='test';
           
           if(bosscard !=  null){
               ipmProject.IPM_Bosscard__c = bosscard;
               
           }
           ipmProject.IPM_Complexity__c = 'Full';
           ipmProject.IPM_Project_Leader__c=Userinfo.getUserId();
           insert ipmProject;
           
           ipmProject.IPM_Project_Name__c ='test1';
           ipmProjects.add(ipmProject);
           
           ipmProject = new IPM_Project__c();
           insert ipmProject;
           ipmProjects.add(ipmProject);
     
       
       return ipmProjects;
       
       
   }
   
   
   static  List<IPM_Bosscard__c> createIPMBosscard(){     
        
       List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
       
       IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
           

           ipmBosscard .IPM_BosscardName__c ='Te2112';
           ipmBosscard.IPM_Assumptions__c = 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Background__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Constraints__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Consumer_Need__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Deliverables__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Potential_Business_Opportunity__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Resources__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Scope__c= 'LOjjiihishfifhsifhifhihfishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_IsSaved__c = true;
          // ipmBosscard.IPM_Brand__c= 'LOjjii';
           //ipmBosscard.IPM_Category__c= 'LOjjii';
           ipmBosscard.IPM_Brand_Positioning__c= 'LOjjii';
           //ipmBosscard.IPM_Gate_Keeper__c= 'LOjjii';
           ipmBosscard.IPM_Target_Launch_Date__c= 'LOjjii';
           ipmBosscard.IPM_Is_Archived__c= false;
           
           insert ipmBosscard;
           ipmBosscards.add(ipmBosscard);  
           
      
  
                  
       return ipmBosscards ;
       
       
   }
   
   static IPM_Project_Resource__c  createIPMProjectResource(String ipmRole, IPM_Project__c ipmProject){
        User u2 = new User(); 
              Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              u2 = new User(Alias = 'te343', Email='standarduser@te343.com', 
              EmailEncodingKey='UTF-8', LastName='Testing4', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@te343.com', 
              IPM_Category__c = 'te343'  , IPM_Brand_Positioning__c= 'te343',IPM_Brand_Name__c ='te343',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test', isActive =true);
              insert u2;
       List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
       PermissionSet Fps=new PermissionSet();
       PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
       system.runAs(u2){
       
       Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
      
       assignpermission.AssigneeId =u2.id;
       assignpermission.PermissionSetId=Fps.id;
       insert assignpermission;
      }
       IPM_Project_Resource__c  ipmProjectResource = new IPM_Project_Resource__c();
       //User u = testRunAsRole(ipmRole);
       
       ipmProjectResource.IPM_Role_Type__c = ipmRole;
       ipmProjectResource.IPM_Project__c = ipmProject.Id ;
       ipmProjectResource.IPM_User__c = assignpermission.AssigneeId;
       insert ipmProjectResource;
       
       return ipmProjectResource; 
   
   }   

   
   
}