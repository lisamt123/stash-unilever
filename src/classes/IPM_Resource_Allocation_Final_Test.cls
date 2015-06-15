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
            
            List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
            
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
            
           //List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
            IPM_Bosscard__c bosscard3=new IPM_Bosscard__c();
        bosscard3.Name='Test Data03';
        bosscard3.IPM_IsSaved__c=true;
        insert bosscard3;
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(bosscard3.Id);
                    
 
            
                    
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
            //List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
            IPM_Bosscard__c bosscard2=new IPM_Bosscard__c();
        bosscard2.Name='Test Data02';
        bosscard2.IPM_IsSaved__c=true;
        insert bosscard2;
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(bosscard2.Id);
                    
 
                    
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
    
    static testMethod  void testGetIpmuserType(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();  
            
           //List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
           
             IPM_Bosscard__c bosscard1=new IPM_Bosscard__c();
        bosscard1.Name='Test Data01';
        bosscard1.IPM_IsSaved__c=true;
        insert bosscard1;
            
            //List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(listBosscard[0].Id);
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(bosscard1.Id);
                    
                
            try{   
                testdata.createIPMProjectResource('BD',ipmProjects[0]);     
                sic.getIpmuserType(); 
            }
            
            catch(Exception e){
                Test.stopTest();  
            }
            
            
    }
    
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
    

   
   static  List<IPM_Bosscard__c> createIPMBosscard(){     
        
       List<IPM_Bosscard__c> bosscard= [SELECT IPM_BosscardName__c,IPM_IsSaved__c  from IPM_Bosscard__c where IPM_BosscardName__c  ='Testcd1' ];
       List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
       
       IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
           
       if(bosscard.size()==0){
                  

           ipmBosscard .IPM_BosscardName__c ='Testcd1';
           ipmBosscard.IPM_Assumptions__c = 'LOjjiihishfifhsifTestcd1';
           ipmBosscard.IPM_Background__c= 'LOjjiihishfifhsifhifhTestcd1';
           ipmBosscard.IPM_Constraints__c= 'LOjjiihishfifhsifhTestcd1';
           ipmBosscard.IPM_Consumer_Need__c= 'LOjjiihishfifhsiTestcd1';
           ipmBosscard.IPM_Deliverables__c= 'LOjjiihishfifhsifhTestcd1';
           ipmBosscard.IPM_Potential_Business_Opportunity__c= 'LOjjiihisTestcd1';
           ipmBosscard.IPM_Resources__c= 'LOjjiihishfifhsifTestcd1';
           ipmBosscard.IPM_Scope__c= 'LOjjiihishfifhsifhiTestcd1';
           ipmBosscard.IPM_IsSaved__c = true;
          // ipmBosscard.IPM_Brand__c= 'LOjjii';
           //ipmBosscard.IPM_Category__c= 'LOjjii';
           ipmBosscard.IPM_Brand_Positioning__c= 'Testcd1';
           //ipmBosscard.IPM_Gate_Keeper__c= 'LOjjii';
           ipmBosscard.IPM_Target_Launch_Date__c= 'LOjjii';
           ipmBosscard.IPM_Is_Archived__c= false;
           
           insert ipmBosscard;
           ipmBosscards.add(ipmBosscard);  
           
       }
       
       else{
           
                ipmBosscards= bosscard;  
           
       }
       
           
                  
       return ipmBosscards ;
       
       
   }



}