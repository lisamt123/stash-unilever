@isTest
private class IPM_CoreParameterRevamp_Test{

   static testmethod void ipmCoreParameterClass_Test(){
        
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        
        testData.createUser(); 
        testData.testRunAs();       
        IPM_User_Profile__c  ipmUserProfile= testData.createIpmUserProfile();
        
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        
        List<IPM_Project__c> listIPMProjects= testdata.createIPMProjects(null);

        ApexPages.CurrentPage().getparameters().put('pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        testdata.createIpmUserProfile();

        
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();  
                
   }
   

   static testmethod   void testSearchprojectpahse(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.searchprojectpahse();
        Test.stopTest();  
        
   } 
  
    
    

   static testmethod  void testGetAllcompanycard(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.getAllcompanycard();
        Test.stopTest();  
        
   }  


   static testmethod  void testGetBETToolkit(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.getBETToolkit();
        Test.stopTest();  
        
   } 
   

   static testmethod  void testQuestionOne(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.QuestionOne();
        Test.stopTest();  
        
   } 

   static testmethod  void testQuestionTwo(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.QuestionTwo();
        Test.stopTest();  
        
   } 

   static testmethod  void testQuestionThree(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
         testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp (); 

        sic.QuestionThree();
        Test.stopTest();  
        
   } 
   

   static testmethod  void testPreviousQiestion(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();  
        
        sic.IsQuestionTwo = true;
        sic.PreviousQiestion();
        
        sic.IsQuestionTwo = false;
        sic.IsQuestionThree= true;       
        sic.PreviousQiestion();
        Test.stopTest();  
        
   } 
 
   static testmethod  void testNextQuestion(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();        
        
        sic.IsQuestionOne= true;       
        sic.NextQuestion();
        
        sic.IsQuestionOne= false; 
        sic.IsQuestionTwo= true;       
        sic.NextQuestion();
        Test.stopTest();  

        
   }
   

   static testmethod  void testSelectedAnswer(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.SelectedAnswer();
        Test.stopTest();  
        
   }
    

   static testmethod  void testProjectSpan(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.ProjectSpan();
        Test.stopTest();  
        
   }
   

   static testmethod  void testSaveMessage(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.SaveMessage();
        Test.stopTest();  
        
   }
   

   static testmethod  void testSaveMessageTwo(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.SaveMessageTwo();
        Test.stopTest();  
        
   }


   static testmethod  void testSaveMessageThree(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.SaveMessageThree();
        Test.stopTest();  
        
   }
   

   static testmethod  void testConfirm(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.confirm();  
        Test.stopTest();  
   }
   

   static testmethod  void testEditTargetLaunchDateValidationPopup(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp ();          
        sic.editTargetLaunchDateValidationPopup();
        Test.stopTest();  
        
   }
    
     

   static testmethod  void testSaveAndReturn(){
        Test.startTest();
        ipmCoreParameterClass_Test();
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createIPMCoreParameterStrategicHelpContent();  
        testData.createIPMCoreParameterCustomSettings();
        IPM_CoreParameterRevamp  sic = new IPM_CoreParameterRevamp (); 
        
        List<IPM_Project__c> listIPMProjects= testdata.createIPMProjects(null);
        //sic.IPMProjects.IPM_PM_Approach__c= null;
        //sic.IPMProjects.IPM_Complexity__c= null;
        //sic.IPMProjects.IPM_Target_Launch_Dates__c= null;                 
        sic.SaveAndReturn();
        
        sic.IPMProjects.IPM_PM_Approach__c= 'test';
        //sic.IPMProjects.IPM_Complexity__c= 'test';
        date myDate = date.newInstance(1990, 11, 21);
        sic.IPMProjects.IPM_Target_Launch_Dates__c= myDate ;    
        
                     
        sic.SaveAndReturn();  
        
        myDate = date.newInstance(2027, 11, 21);
        sic.IPMProjects.IPM_Target_Launch_Dates__c= myDate ;    
        //sic.SaveAndReturn(); 
        Test.stopTest();  
        
        
   }
   
      
}