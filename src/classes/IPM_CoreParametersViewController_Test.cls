@isTest
private class IPM_CoreParametersViewController_Test{

       static testmethod  void ipmCoreParametersViewController_TestConstructor(){
          
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        
        testData.createUser(); 
        testData.testRunAs();     
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_User_Profile__c  ipmUserProfile= testData.createIpmUserProfile();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
        List<IPM_Project__c> listIPMProjects= testdata.createIPMProjects(null);

        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        testdata.createIpmUserProfile();   
        
        IPM_CoreParametersViewController sic = new IPM_CoreParametersViewController();       
       
    }
            

       static testmethod   void testQuestionOne(){
            Test.startTest();
            ipmCoreParametersViewController_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            testData.createIPMCoreParameterStrategicHelpContent();  
            testData.createIPMCoreParameterCustomSettings();
    
            IPM_CoreParametersViewController  sic = new IPM_CoreParametersViewController ();          
            sic.QuestionOne(); 
            Test.stopTest();  
    
    }
    

       static testmethod   void testQuestionTwo(){
            Test.startTest();
            ipmCoreParametersViewController_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            testData.createIPMCoreParameterStrategicHelpContent();  
            testData.createIPMCoreParameterCustomSettings();
    
            IPM_CoreParametersViewController  sic = new IPM_CoreParametersViewController ();          
            sic.QuestionTwo(); 
            Test.stopTest();  
    
    }
    

    static testmethod   void testQuestionThree(){
            Test.startTest();
            ipmCoreParametersViewController_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            testData.createIPMCoreParameterStrategicHelpContent();  
            testData.createIPMCoreParameterCustomSettings();
            IPM_CoreParametersViewController  sic = new IPM_CoreParametersViewController ();          
            sic.QuestionThree(); 
            Test.stopTest();  
    
    }
    

       static testmethod   void testBackToProjectIntermediate(){
            Test.startTest();
            ipmCoreParametersViewController_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            testData.createIPMCoreParameterStrategicHelpContent();  
            testData.createIPMCoreParameterCustomSettings();
    
            IPM_CoreParametersViewController  sic = new IPM_CoreParametersViewController ();          
            sic.BackToProjectIntermediate(); 
            Test.stopTest();  
    
    }
    

       static testmethod   void testProjectIntermediate(){
            Test.startTest();
            ipmCoreParametersViewController_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            testData.createIPMCoreParameterStrategicHelpContent();  
            testData.createIPMCoreParameterCustomSettings();
    
            IPM_CoreParametersViewController  sic = new IPM_CoreParametersViewController ();          
            sic.ProjectIntermediate(); 
            Test.stopTest();  
    
    }
        

}