@isTest
public class ipmRolloutPlansAddControllerTests{
    public static IPM_Project__c project;
    public static IPM_Project_Rollout__c proRoll;
    public static String projectId;
    public static  List<String> lstTemp=new  List<String>();
    public static  IPM_Country__c ipmCountry = new IPM_Country__c();
    
    static testMethod void initializeData(){
        project=new IPM_Project__c();
        project.Name='Test Finanace D';
        project.IPM_Phase__c='Feasibility';
        project.Sustainability_Period__c='3';
        project.IPMProject_Span__c ='PROJECT_SPAN_REGIONAL';
        insert project;

        ApexPages.CurrentPage().getparameters().put('id', project.id);
         
        String strRecordTypeId=[Select Id From RecordType Where SobjectType='IPM_Project_Rollout__c' and Name='Regional Rollout'].Id;
        proRoll=new IPM_Project_Rollout__c();
        proRoll.Name='TEST FINANCE D_EUR';
        proRoll.RecordTypeId=strRecordTypeId;
        proRoll.IPM_Project__c=project.ID;
        proRoll.Target_Launch_Date__c=System.today();
        insert proRoll;
        
        mdm_Geography__c mdmGeography = new mdm_Geography__c();
        mdmGeography.Unilever_Cluster__c = 'Africa';
        mdmGeography.Country_Group__c = 'Africa Emerging Markets';
        mdmGeography.ISO_3166_1_Alpha_Code__c= 'AGO';
        mdmGeography.Region__c ='Asia/RAM';
        mdmGeography.Region_Code__c ='GEO0003';
        mdmGeography.Country_Sub_Group_Code__c = 'LV5_GEO0085';
        mdmGeography.Country_Sub_Group_Name__c = 'Africa Emerging Markets';
        mdmGeography.Unilever_Cluster_Code__c = 'GEO0060';
        mdmGeography.ISO_Country_Dependency_Code__c = 'UIM00015';
        mdmGeography.Country_Cluster__c = 'Africa Emerging Markets';
        mdmGeography.ISO_Country_Dependency_Medium_Name__c = 'Angola';
        mdmGeography.Country_Cluster_Code__c = 'GEO0085';
        mdmGeography.ISO_Country_Dependency_Short_Name__c = 'Angola';
        mdmGeography.Country_Group__c = 'Africa Emerging Markets';
        mdmGeography.ISO_Country_Dependency_Office_EN_Name__c = 'ANGOLA';
        mdmGeography.Country_Group_Code__c = 'LV4_GEO0085';
        mdmGeography.Market_Type__c = 'Developing & Emerging';
        mdmGeography.ISO_Country_Dependency_Name__c = 'Angola';
        mdmGeography.Market_Type_Code__c='D002';
        mdmGeography.ISO_3166_1_Num_Code__c ='024';
        mdmGeography.UN_Independent_Country__c ='Angola';
        mdmGeography.ISO_3166_1_Code__c = 'AO';
        mdmGeography.World__c = 'World';
        mdmGeography.World_Code__c='GEO0001';

        
        mdmGeography.ISO_Country_Dependency_Name__c = 'Angola';
        insert mdmGeography;
        
       
        ipmCountry.IPM_Project__c = project.Id;
        ipmCountry.Geography__c = mdmGeography.Id;
        insert ipmCountry;
        
      
              
    }


    static testMethod void testChangeCluster() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        ipmRolloutPlansAddControllerTests thisTestClass= new ipmRolloutPlansAddControllerTests();
        ipmRolloutPlansAddController irp= new ipmRolloutPlansAddController();
        String str=ipmCountry.Id;
       // irp.mapIPMCountries.put(str,ipmCountry);
        irp.project=project;
         irp.globalCountries='abc,abc';
     irp.regionalMco='abc,abc';
   irp.regionalCountry='abc,abc';
     irp.regionalNoRoll='abc,abc';
        
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        
        
        //irp.selectAllCountries=true;
        //irp.deselectAllCountries=true;
        //irp.selectedMCO='Africa Emerging Markets';
        //irp.selectedCountry = 'Angola';
        irp.changeCluster();
        
        Test.stopTest();  
    } 
     
    
    static testMethod void testChangeMCO() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        ipmRolloutPlansAddControllerTests thisTestClass= new ipmRolloutPlansAddControllerTests();
        
        ipmRolloutPlansAddController irp= new ipmRolloutPlansAddController();
      irp.project=project;
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        
        //irp.selectAllCountries=true;
        //irp.deselectAllCountries=true;
        //irp.selectedMCO='Africa Emerging Markets';
        //irp.selectedCountry = 'Angola';
        try{
            irp.changeMCO();
        }
        catch(Exception e){
            Test.stopTest();  
        }
        
    } 
    
    static testMethod void testDoNothing() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        ipmRolloutPlansAddControllerTests thisTestClass= new ipmRolloutPlansAddControllerTests();
        ipmRolloutPlansAddController irp= new ipmRolloutPlansAddController();
        irp.project=project;
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        
        //irp.selectAllCountries=true;
        //irp.deselectAllCountries=true;
        //irp.selectedMCO='Africa Emerging Markets';
        //irp.selectedCountry = 'Angola';
        //irp.doNothing();
        
        Test.stopTest();  
    } 
    
    static testMethod void testSelectAllCountry() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        ipmRolloutPlansAddControllerTests thisTestClass= new ipmRolloutPlansAddControllerTests();
        ipmRolloutPlansAddController irp= new ipmRolloutPlansAddController();
        irp.project=project;
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);
        
        //irp.selectAllCountries=true;
        //irp.deselectAllCountries=true;
        //irp.selectedMCO='Africa Emerging Markets';
        //irp.selectedCountry = 'Angola';
        try{
            //irp.selectAllCountry();
        }
        catch(Exception e){
            Test.stopTest();  
        }
    } 
    
    static testMethod void testSelectCountries() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        ipmRolloutPlansAddControllerTests thisTestClass= new ipmRolloutPlansAddControllerTests();
        ipmRolloutPlansAddController irp= new ipmRolloutPlansAddController();
        irp.project=project;
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);

        //irp.selectAllCountries=true;
        //irp.deselectAllCountries=true;
        //irp.selectedMCO='Africa Emerging Markets';
        try{
            //irp.selectCountries();
        }
        catch(Exception e){
            Test.stopTest(); 
        }
        
        //irp.selectAllCountries = false;
        //irp.deselectAllCountries = false;
        //irp.selectedCountry = 'Angola';
        //try{
        //  irp.selectCountries();
        // }
        //catch(Exception e){
        //    Test.stopTest(); 
        //}
         
    }
    
    static testMethod void testCancel() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        ipmRolloutPlansAddControllerTests thisTestClass= new ipmRolloutPlansAddControllerTests();
        ipmRolloutPlansAddController irp= new ipmRolloutPlansAddController();
        irp.project=project;
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);
                   irp.globalCountries='abc';
     irp.regionalMco='abc,abc';
   irp.regionalCountry='abc,abc';
     irp.regionalNoRoll='abc,abc';
        //irp.selectAllCountries=true;
        //irp.deselectAllCountries=true;
        //irp.selectedMCO='Africa Emerging Markets';
        //irp.selectedCountry = 'Angola';

        irp.cancel();
        
        Test.stopTest();  
    }
    
    static testMethod void testGenerateRolloutPlans() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        ipmRolloutPlansAddControllerTests thisTestClass= new ipmRolloutPlansAddControllerTests();
        ipmRolloutPlansAddController irp= new ipmRolloutPlansAddController();
        irp.project=project;
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);

        //irp.selectAllCountries=true;
        //irp.deselectAllCountries=true;
        //irp.selectedMCO='Africa Emerging Markets';
        //irp.selectedCountry = 'Angola';
        try{
            //irp.generateRolloutPlans();
        }
        
        catch(Exception e){
            Test.stopTest();  
        }
        
    }

    
    
    static testMethod void testGenerateRollouts() {
        Test.startTest();
        initializeData();
        String selectedMCORollout=project.ID;
        projectId = ApexPages.currentPage().getParameters().get('proRoll.Id');
        ipmRolloutPlansAddControllerTests thisTestClass= new ipmRolloutPlansAddControllerTests();
        ipmRolloutPlansAddController irp= new ipmRolloutPlansAddController();
        irp.project=project;
        PageReference pRef = new PageReference('apex/ipmrolloutplansadd?id='+proRoll.ID);
        Test.setCurrentPageReference(pRef);
     // irp.globalCountries='abc,abc';
    // irp.regionalMco='abc,abc';
  // irp.regionalCountry='abc,abc';
   //  irp.regionalNoRoll='abc,abc';
        //irp.selectAllCountries=true;
        //irp.deselectAllCountries=true;
        //irp.selectedMCO='Africa Emerging Markets';
        //irp.selectedCountry = 'Angola';
        //project.IPMProject_Span__c = 'REGIONAL';
       // update project;
        irp.project=project;
        irp.generateRollouts();
        
        
        Test.stopTest();  
    }
    
    
    
 }