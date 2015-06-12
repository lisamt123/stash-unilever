@isTest

private class IPM_BosscardController_Test{
    static testMethod void testIpmBosscardController_Constructor(){
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        testData.createUserBosscard1(); 
        
        testData.testRunAsBosscard();       
        IPM_User_Profile__c  ipmUserProfile= testData.createIpmUserProfileBosscard();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
        
        List<IPM_Bosscard__c> listBosscard= new List<IPM_Bosscard__c> ();
        IPM_Bosscard__c bosscard1=new IPM_Bosscard__c();
        bosscard1.Name='Test Data';
        bosscard1.IPM_IsSaved__c=true;
        insert bosscard1;
        listBosscard.add(bosscard1);
      

        ApexPages.CurrentPage().getparameters().put('id', listBosscard[0].id);
        ApexPages.CurrentPage().getparameters().put('image', listBosscard[0].id);
        
        

        List<IPM_Project__c> ipmProjects= createIPMProjects(bosscard1.Id);
        
        
        ApexPages.StandardController sc = new ApexPages.standardController(listBosscard[0]);
        
        Ipm_BosscardController sic = new Ipm_BosscardController (sc);
  
        
    
    }
    
    public Ipm_BosscardController ipmBosscardControllerRevampConstructor(){

        IPM_TestDataUtils testData = new IPM_TestDataUtils();    
        
        testData.createUserBosscard1(); 
        
        testData.testRunAsBosscard(); 
        IPM_User_Profile__c  ipmUserProfile= testData.createIpmUserProfileBosscard();
                 
        
        List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
        ApexPages.CurrentPage().getparameters().put('id', listBosscard[0].id);
        ApexPages.CurrentPage().getparameters().put('image', listBosscard[0].id);
        
        ApexPages.StandardController sc = new ApexPages.standardController(listBosscard[0]);
        
        //List<IPM_Project__c> ipmProjects= createIPMProjects(listBosscard[0].Id);
        
        //added by Dimple
       IPM_Bosscard__c bosscard1=new IPM_Bosscard__c();
        bosscard1.Name='Test Data';
        bosscard1.IPM_IsSaved__c=true;
        insert bosscard1;
        //List<IPM_Project__c> ipmProjects= createIPMProjects(bosscard1.Id);

        
        
        
        Ipm_BosscardController sic = new Ipm_BosscardController (sc);

        return sic;
    }
    
    
    
    static testMethod void testGetStatusValue(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        sic.getStatusValue();
        Test.stopTest();  
        
    }
    
    static testMethod void testGetListOfQuarter(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        sic.getListOfQuarter();
        Test.stopTest();  
        
    }
    
    static testMethod void testGetBrands(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        sic.getBrands();
        Test.stopTest();  
        
    }  
    
    static testMethod void testGetBrandPos(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        sic.getBrandPos();
        Test.stopTest();  
        
    }  
    
    static testMethod void testGetGates(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        sic.getGates();
        Test.stopTest();  
        
    }
   
    static testMethod void testGetCategory(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        sic.getCategory();
        Test.stopTest();  
        
    } 
   
    static testMethod void testGetSubCategory(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        sic.getSubCategory();
        Test.stopTest();  
        
    } 
    
    
    static testMethod void testSave(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        //sic.bosscard.ImageId ='test';       
        
        
       
        
        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        
        sic.bosscard.IPM_Assumptions__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Background__c ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Constraints__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Consumer_Need__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Deliverables__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Potential_Business_Opportunity__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Resources__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Scope__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Sustainibility__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        //sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrandPos ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.expectedTLD ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        sic.save();

        sic.bosscard.IPM_BosscardName__c = '99999';
        sic.save();
        
        sic.bosscard.IPM_BosscardName__c = '';
        sic.save();
        
        sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.save();
        Test.stopTest();  
    } 
    
    
    static testMethod void testExportToPdf(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
       
                
        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        sic.bosscard.IPM_Assumptions__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Background__c ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Constraints__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Consumer_Need__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Deliverables__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Potential_Business_Opportunity__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Resources__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Scope__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Sustainibility__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        //sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrandPos ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.expectedTLD ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        IPM_TestDataUtils testdata = new   IPM_TestDataUtils();      
        List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();

        ApexPages.CurrentPage().getparameters().put('id', listBosscard[0].id);
        
        sic.bosscard.Id = listBosscard[0].id; 
        sic.BossCUrl_ID =listBosscard[0].id; 
        
        sic.exportToPdf();
        
        sic.bosscard.IPM_BosscardName__c = '99999';
        sic.exportToPdf();
        
        
        sic.ImageId = 'Test'; 
        sic.exportToPdf();
        
        
        
        sic.bosscard.IPM_BosscardName__c = '';
        sic.exportToPdf();
        
        sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.save();
        Test.stopTest();  
        
    } 
    
    static testMethod void testArchive(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        
                
        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        sic.bosscard.IPM_Assumptions__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        sic.bosscard.IPM_Background__c ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Constraints__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Consumer_Need__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Deliverables__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Potential_Business_Opportunity__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Resources__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Scope__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Sustainibility__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        //sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrandPos ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.expectedTLD ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        IPM_TestDataUtils testdata = new   IPM_TestDataUtils();      
        List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
        
        
        List<IPM_Project__c> ipmProjects= createIPMProjects(listBosscard[0].Id);
        sic.project = ipmProjects[0];
        sic.selBrand = 'Test'; 
        sic.ImageId = 'Test'; 
        sic.BossCUrl_ID =listBosscard[0].id; 
        sic.archive();
        
        
        //ipmProjects= createIPMProjects(listBosscard[0].Id);
        sic.project = ipmProjects[0];
        sic.ProjectId = ''+ipmProjects[0].Id;
        sic.selBrand = 'Test'; 
        sic.ImageId = 'Test'; 
        sic.BossCUrl_ID = null; 
        sic.archive();
                      
                
        sic.bosscard.IPM_BosscardName__c = '99999';
        sic.archive();
        
        
        sic.archive();
        
        sic.bosscard.IPM_BosscardName__c = '';
        sic.archive();
        
        sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.archive();
        Test.stopTest();  

        
        
    } 

    static testMethod void testShareViaChatter(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        
        IPM_TestDataUtils testdata = new   IPM_TestDataUtils();      
        List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();

        ApexPages.CurrentPage().getparameters().put('id', listBosscard[0].id);
        
        
        sic.BossCUrl_ID =listBosscard[0].id; 
                
        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        sic.bosscard.IPM_Assumptions__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        sic.bosscard.IPM_Background__c ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Constraints__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Consumer_Need__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Deliverables__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Potential_Business_Opportunity__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Resources__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Scope__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Sustainibility__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.ImageId = 'Test';
        
        //sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrandPos ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.expectedTLD ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        sic.bosscard.IPM_Is_Accepted__c = false;
        sic.isSave = true;
        
        sic.shareViaChatter();
        
        List<IPM_Project__c> ipmProjects= createIPMProjects(listBosscard[0].Id);
        sic.project = ipmProjects[0];
        sic.ProjectId = ''+ipmProjects[0].Id;
        sic.selBrand = 'Test'; 
        sic.ImageId = 'Test'; 
        sic.BossCUrl_ID = listBosscard[0].id; 
        sic.bosscard.Id = listBosscard[0].id; 
        sic.shareViaChatter();
        
        
        sic.bosscard.IPM_BosscardName__c = '99999';
        sic.shareViaChatter();
        
        sic.bosscard.IPM_BosscardName__c = '';
        sic.shareViaChatter();
        
        sic.bosscard.IPM_Assumptions__c = null;
        sic.shareViaChatter();
        
        sic.isSave = false;
        sic.shareViaChatter();
        Test.stopTest();  
               
    } 

    static testMethod void testBeforeAccept(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        
        sic.bosscard.IPM_BosscardName__c = '';
        sic.beforeAccept();
        
        
        sic.bosscard.IPM_BosscardName__c = '99999';
        sic.beforeAccept();
        Test.stopTest();  
        
        
        
    } 
    
    static void testAccept(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        
        
        IPM_TestDataUtils testdata = new   IPM_TestDataUtils();      
        List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
        
        
        List<IPM_Project__c> ipmProjects= createIPMProjects(listBosscard[0].Id);
        sic.project = ipmProjects[0];
        
        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        sic.bosscard.IPM_Assumptions__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Background__c ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Constraints__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Consumer_Need__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Deliverables__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Potential_Business_Opportunity__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Resources__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Scope__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Sustainibility__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

        //sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrandPos ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.expectedTLD ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.BossCUrl_ID =listBosscard[0].id; 

        sic.selBrand = 'Test'; 
        sic.ImageId = 'Test'; 
        sic.accept();
        
        ipmProjects= createIPMProjects(listBosscard[0].Id);
        sic.project = ipmProjects[0];
        sic.ProjectId = ''+ipmProjects[0].Id;
        sic.selBrand = 'Test'; 
        sic.ImageId = 'Test'; 
        sic.BossCUrl_ID = null; 
        sic.accept();
        
        sic.bosscard.IPM_BosscardName__c = '99999';
        sic.accept();
        
        sic.ImageId = 'Test';
        
        sic.bosscard.IPM_BosscardName__c = '';
        sic.accept();
        
        sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.accept();
        Test.stopTest();  
        
        
        
    }
    
    
    static testMethod void testProjectIdGeneration(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        
        IPM_TestDataUtils testdata = new   IPM_TestDataUtils();      

        
        
        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        
        sic.selBrand = 'Test'; 
        sic.ImageId = 'Test';
        sic.selBrandPos = 'Test';
        sic.expectedTLD = 'Test';
        
        
        
     
        List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
        //sic.BossCUrl_ID =listBosscard[0].id; 
        
        List<IPM_Project__c> ipmProjects= createIPMProjects(listBosscard[0].Id);
        sic.project = ipmProjects[0];
        
        
        sic.ProjectIdGeneration();
        
        //ipmProjects= createIPMProjects(listBosscard[0].Id);
        sic.project = ipmProjects[0];
        sic.ProjectId = ''+ipmProjects[0].Id;
        sic.selBrand = 'Test'; 
        sic.ImageId = 'Test'; 
        sic.BossCUrl_ID = null; 
        sic.bosscard.Id = listBosscard[0].Id;
        sic.ProjectIdGeneration();
        
        
        //sic.BossCUrl_ID ='sdsd';
        
        sic.ProjectIdGeneration();
        
        Test.stopTest();  
        
    }
    
    static testMethod void testBosscardData(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
         
        IPM_Bosscard__c   ipmBosscard = [Select Id,IPM_BosscardName__c,IPM_Bosscard_Status__c,IPM_Bosscard_Approver_Comments__c,IPM_Filled_In_Percent__c,IPM_Bosscard_Logo_Id__c,IPM_Target_Launch_Date__c,IPM_Bosscard_Logo__c,IPM_BosscardIdea__c,IPM_Gate_Keeper__c,IPM_Gate_Keeper__r.Name,IPM_Brand__c,IPM_Assumptions__c,IPM_Background__c,IPM_Constraints__c,IPM_Deliverables__c,IPM_Opportunity__c,IPM_Potential_Business_Opportunity__c,IPM_Consumer_Need__c,IPM_Resources__c,IPM_Brand_Positioning__c,IPM_Scope__c,IPM_Sustainibility__c from IPM_Bosscard__c limit 1];
        sic.bosscardData(ipmBosscard.Id);
        
        sic.initialised = false;
        
        sic.BossCUrl_ID = '';
        sic.bosscardData(ipmBosscard.Id);
        Test.stopTest();  
        
    }
    
    static testMethod void testShowMsg(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        
        sic.bossId='';
        sic.showMsg();
        Test.stopTest();  
        
    }
    
    

    
    
    
    static testMethod void testCreateBossCAndproject(){
    
        /*
        Test.startTest();
        
        
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        Ipm_BosscardController bosCon=new Ipm_BosscardController();
        
        IPM_Bosscard__c bosscard1=new IPM_Bosscard__c();
        bosscard1.Name='Test Data1';
        bosscard1.IPM_IsSaved__c=true;
        insert bosscard1;
        
        sic.BossCUrl_ID=bosscard1.Id;
        bosCon.BossCUrl_ID=sic.bosscard1.Id;
        
         IPM_Bosscard__c bosscard2=new IPM_Bosscard__c();
        bosscard2.Name='Test Data02';
        bosscard2.IPM_IsSaved__c=true;
        insert bosscard2;
        bosCon.BossCUrl_ID=bosscard2.Id;
        
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        List<IPM_Bosscard__c> listIPMBosscard = createIPMBosscard();
        
        createIPMProjects(listIPMBosscard[0].Id);
        sic.initialised = false;
        
        //sic.createBossCAndproject();
        
        sic.initialised = false;
        sic.BossCUrl_ID ='';
        
        ApexPages.CurrentPage().getparameters().put('id', listIPMBosscard [0].id);
        //sic.createBossCAndproject();
        
        sic.initialised = true;
        sic.BossCUrl_ID ='';
        
        
       // sic.createBossCAndproject();
        
        Test.stopTest();  
        */
    }
    
    static testMethod void testPrintBosscard(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor(); 

        sic.bosscard.IPM_BosscardName__c = '##%$%#$^^#$^$^$#^#$$%#%$#%%@%@%#%@#%@#%@%@#';
        sic.bosscard.IPM_Assumptions__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Background__c ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Constraints__c = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Consumer_Need__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Deliverables__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Potential_Business_Opportunity__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Resources__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Scope__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.bosscard.IPM_Sustainibility__c='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        //sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrandPos ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        //sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.expectedTLD ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        
        IPM_TestDataUtils testdata = new   IPM_TestDataUtils();      
        List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();

        ApexPages.CurrentPage().getparameters().put('id', listBosscard[0].id);
        
        
        sic.BossCUrl_ID =listBosscard[0].id; 
        
        sic.printBosscard();
        
        sic.bosscard.IPM_BosscardName__c = '99999';
        sic.printBosscard();
        
        
        sic.ImageId = 'Test'; 
        sic.printBosscard();
        
        
        
        sic.bosscard.IPM_BosscardName__c = '';
        sic.printBosscard();
        
        sic.selGate ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selBrand='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.selCat ='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
        sic.printBosscard();
        Test.stopTest();  
        
        
        
    }
    
    static testMethod void testCancel(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
        
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        List<IPM_Bosscard__c> listIPMBosscard = testData.createIPMBosscard();
        
        createIPMProjects(listIPMBosscard[0].Id);
        
        sic.bosscard.IPM_IsSaved__c  = false; 
        
        sic.bosscard= listIPMBosscard[0];
        sic.cancel();
        
        sic.bosscard.IPM_IsSaved__c  = true;
        sic.bosscardId = 'test';
        sic.bosscardId=listIPMBosscard[0].Id;
        sic.cancel();
        Test.stopTest();  
                
        
        
    }
    
    
    static testMethod void testUpdateStatus(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
         
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        List<IPM_Bosscard__c> listIPMBosscard = testData.createIPMBosscard();
        
        createIPMProjects(listIPMBosscard[0].Id);
               
        sic.bosscard= listIPMBosscard[0]; 
        sic.status = 'In Progress';
         
        sic.updateStatus();
        
        sic.status = 'Not Approved';
         
        sic.updateStatus();
        
        sic.status = 'Approved';
         
        sic.updateStatus();
        
        sic.status = 'Discard';
         
        sic.updateStatus();
        Test.stopTest();  
        
    }
    
    static testMethod void testDeleteBosscard(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
         
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        List<IPM_Bosscard__c> listIPMBosscard = testData.createIPMBosscard();
        
        List<IPM_Project__c> ipmProj= createIPMProjects(listIPMBosscard[0].Id); 
        
        sic.ProjectId =  ipmProj[0].Id;
        sic.DeleteBosscard();
        Test.stopTest();  
        
    }
    
    static testMethod void testGetIpmuserType(){
        Test.startTest();
        IPM_BosscardController_Test thisTestClass= new IPM_BosscardController_Test();
        Ipm_BosscardController    sic   = thisTestClass.ipmBosscardControllerRevampConstructor();
         
        sic.getIpmuserType();
        Test.stopTest();  
        
    }
   
      static User createUserBosscard(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 

        User u = new User();

        
             u = new User(Alias = 'teyd017', Email='newuser@testorgbosscard7.com', 
             EmailEncodingKey='UTF-8', LastName='teyd012', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@teyd017.com', 
             IPM_Category__c = 'teyd017'  , IPM_Brand_Positioning__c= 'teyd017',IPM_Brand_Name__c ='teyd017',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;

         return u;
    }
   static User  testRunAsBosscard() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              User u = new User(Alias = 'teyd0126', Email='standarduser@teyd0126.com', 
              EmailEncodingKey='UTF-8', LastName='testorgbosscrdaa', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@teyd0126.com', 
              IPM_Category__c = 'teyd0126'  , IPM_Brand_Positioning__c= 'teyd0126',IPM_Brand_Name__c ='teyd0126',
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


              
              User u = new User(Alias = 'b11115', Email='standarduser@b11115.com', 
              EmailEncodingKey='UTF-8', LastName='b11115', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@b11115.com', 
              IPM_Category__c = 'b11115'  , IPM_Brand_Positioning__c= 'b11115',IPM_Brand_Name__c ='b11115',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='b11115', isActive =true);
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

             u = new User(Alias = 'b11114', Email='newuser@b11112.com', 
             EmailEncodingKey='UTF-8', LastName='b11114', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@b11114.com', 
             IPM_Category__c = 'b11114'  , IPM_Brand_Positioning__c= 'b11114',IPM_Brand_Name__c ='b11114',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;

         return u;
    }
    
   static List<IPM_Project__c> createIPMProjects(Id bosscard){
       
       List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
       
           IPM_Project__c ipmProject = new IPM_Project__c();
           ipmProject.IPM_Project_Name__c ='tes5t';
           
           if(bosscard !=  null){
               ipmProject.IPM_Bosscard__c = bosscard;
               
           }
           ipmProject.IPM_Complexity__c = 'Full';
           ipmProject.IPM_Project_Leader__c=Userinfo.getUserId();
           insert ipmProject;
           
           ipmProject.IPM_Project_Name__c ='test4';
           ipmProjects.add(ipmProject);
           
           ipmProject = new IPM_Project__c();
           insert ipmProject;
           ipmProjects.add(ipmProject);
     
       
       return ipmProjects;
       
       
   }
   
   
   static  List<IPM_Bosscard__c> createIPMBosscard(){     
        
       List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
       
       IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
           

           ipmBosscard .IPM_BosscardName__c ='Te4112';
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
    
    

}