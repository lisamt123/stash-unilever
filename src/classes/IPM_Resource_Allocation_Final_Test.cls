@isTest
private class IPM_Resource_Allocation_Final_Test{

       static testMethod  void ipm_Resource_Allocation_Final_TestConstructor(){
          
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        
        User u= testData.createUser(); 
        testData.testRunAs();       
        IPM_User_Profile__c  ipmUserProfile= testData.createIpmUserProfile();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
        List<IPM_Project__c> listIPMProjects= testdata.createIPMProjects(null);

        ApexPages.CurrentPage().getparameters().put('Pid', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        testdata.createIpmUserProfile();   
        
        IPM_Resource_Allocation_FinalRevamp  sic = new IPM_Resource_Allocation_FinalRevamp (); 
        sic.userID = u.Id;      
        
        sic.ProjectName  = listIPMProjects[0].id;
       
    }
    
    static testMethod  void testIpm_Resource_Allocation_FinalRevamp_TestConstructor(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
    
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.Initialise(); 
            Test.stopTest();  
    
    }

    static testMethod   void testCountProjectMembers(){
    
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            
            try{
                //sic.CountProjectMembers(); 
            }
            
            catch(Exception e){
                Test.stopTest();  
            }    
             
    }

    static testMethod  void testGetGuestUser(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            try{
                sic.GetGuestUser(); 
            }
            catch(Exception e){
                Test.stopTest();  
            }    
            
    
    }

    static testMethod  void testGetAssignedMember(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();  
            

            
            try{  
                List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
            
                List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(listBosscard[0].Id);
                        
                testdata.createIPMProjectResource('BD',ipmProjects[0]);      
                sic.ProjectName= ipmProjects[0].Id;      
                sic.GetAssignedMember(); 
            }
            catch(Exception e){
                Test.stopTest();  
            }
            
    
    }
    
    static testMethod  void testGetPreviousProject(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.getPreviousProject(); 
            Test.stopTest();  
    }
    
    static testMethod  void testAddAllPreviousProMembers(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();   
            
            List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
            
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(listBosscard[0].Id);
                    
            //testdata.createIPMProjectResource('BD',ipmProjects[0]);      
            //sic.selectedProject = ipmProjects[0].Id;
            //sic.AddAllPreviousProMembers(); 
            
            
            
            Test.stopTest();  
    }
    
   static testMethod  void testGetItemsPL(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.getItemsPL(); 
            Test.stopTest();  
    }
    
   static testMethod  void testGetItemsGK(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.getItemsGK(); 
            Test.stopTest();  
    }
    
    static testMethod  void testGetItemsTL(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.getItemsTL(); 
            Test.stopTest();  
    }
    
    static testMethod  void testGetItemsDPL(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.getItemsDPL(); 
            Test.stopTest();  
    }
    
    static testMethod  void testDPLImage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();     
            sic.selectedDPL='test'; 
            try{
             
                sic.DPLImage(); 
            
            }
            
            catch(Exception e){
                Test.stopTest();  
            }    
           
    }
    
    
    static testMethod  void testTLImage(){
            Test.startTest();
            
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();       
            
            sic.selectedTL = 'test';
            try{
                sic.TLImage(); 
            
             }
            
            catch(Exception e){
                Test.stopTest();  
            }    
             
            
    }
    
   static testMethod  void testGKImage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  (); 
            sic.selectedGK = 'test';         
             try{
                sic.GKImage(); 
            
             }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
    }
    
    
   static testMethod  void testPLImageNew(){
            Test.startTest();
        
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();  
            sic.PLName = 'test';
            
            try{        
            sic.PLImageNew(); 
            }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
    }
    
    
   static testMethod  void testGKImageNew(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();       
            sic.GateKeeperName='test';
            try{
                sic.GKImageNew(); 
            }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
    }
    
    static testMethod  void testDPLImageNew(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();  
            sic.DPLName= 'test';     
            sic.DPLImageNew(); 
            Test.stopTest();  
    }
    
    static testMethod  void testTLImageNew(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();   
            sic.TPLName  = 'test';        
            sic.TLImageNew(); 
            Test.stopTest();  
    }
    
    static testMethod  void testPLImage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();   
            sic.selectedPL= 'test';    
            try{
                sic.PLImage(); 
            
            }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
    }
    
    static testMethod  void testSelectImage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();       
            try{
            sic.SelectImage(sic.userID,true); 
            
            }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
    }
    
    static testMethod  void testClosePopup(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.closePopup(); 
            Test.stopTest();  
    }
    
    static testMethod  void testShowPopup(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.showPopup(); 
            Test.stopTest();  
    }
    
    static testMethod  void testSaveTeamMembers(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();  
            
            List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
            
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(listBosscard[0].Id);
                    
 
            
                    
            try{
                //testdata.createIPMProjectResource('BD',ipmProjects[0]); 
                //User u= testData.testRunAs();  
                //sic.selectedPL = u.Id;
                //sic.selectedDPL= u.Id;
                //sic.selectedTL= u.Id;
                //sic.selectedGK = u.Id;
                //sic.SaveTeamMembers(); 
             }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
            Test.stopTest();  
            sic.PL_ids = 'test';
            //sic.SaveTeamMembers();
    }
    
    static testMethod  void testSaveTeamMembers_Nextpage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.SaveTeamMembers_Nextpage(); 
            Test.stopTest();  
    }
    
    static testMethod  void testHodingSelecteOwnerId(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            try{
                sic.HodingSelecteOwnerId(); 
            }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
    }
    
    static testMethod   void testSaveCoreMembers(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();  
            List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
            
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(listBosscard[0].Id);
                    
 
                    
            try{  
                //testdata.createIPMProjectResource('BD',ipmProjects[0]); 
                //User u= testData.testRunAs();     
                //sic.selectedPL = u.Id;
                //sic.selectedDPL= u.Id;
                //sic.selectedTL= u.Id;
                //sic.selectedGK = u.Id;
                
                //sic.SaveCoreMembers();
            }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
    }
    
    static testMethod   void testShowGateKlist(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.showGateKlist(); 
            Test.stopTest();  
    }
    
    static testMethod  void testShowTPLlist(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.showTPLlist(); 
            Test.stopTest();  
    }
    
    static testMethod  void testShowPLlist(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.showPLlist(); 
            Test.stopTest();  
    }
    
    static testMethod  void testShowDPLlist(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.showDPLlist();
            Test.stopTest();   
    }
    
   
    static testMethod  void testDeleteAssignedmembers(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            sic.DeleteAssignedmembers(); 
            Test.stopTest();  
    }
    
   /* static testMethod  void testGetIpmuserType(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();  
            
            List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
            
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(listBosscard[0].Id);
                    
                
            try{   
                testdata.createIPMProjectResource('BD',ipmProjects[0]);     
                sic.getIpmuserType(); 
            }
            
            catch(Exception e){
                Test.stopTest();  
            }
            
            
    }*/
    
   static testMethod  void testShowEditTeam(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();      
            sic.isShowEditmode =false;
            sic.ShowEditTeam(); 
            sic.isShowEditmode =true;
            sic.ShowEditTeam(); 
            
            Test.stopTest();  
    }
    

}