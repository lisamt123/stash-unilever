@isTest
private class IPM_Resource_Allocation_FinalRevamp_Test{

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
            
            List<IPM_Project__c> ipmProjects= createIPMProjects(listBosscard[0].Id);
                    
            //testdata.createIPMProjectResource('BD',ipmProjects[0]);      
            sic.selectedProject = ipmProjects[0].Id;
            sic.AddAllPreviousProMembers(); 
            
            
            
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
            
           List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
            IPM_Bosscard__c bosscard3=new IPM_Bosscard__c();
        bosscard3.Name='Test Data03';
        bosscard3.IPM_IsSaved__c=true;
        insert bosscard3;
            List<IPM_Project__c> ipmProjects= createIPMProjects(bosscard3.Id);
                    
 
            
                    
            try{
                //testdata.createIPMProjectResource('BD',ipmProjects[0]); 
                User u= testData.testRunAs();  
                sic.selectedPL = u.Id;
                sic.selectedDPL= u.Id;
                sic.selectedTL= u.Id;
                sic.selectedGK = u.Id;
                sic.SaveTeamMembers(); 
             }
            
            catch(Exception e){
                Test.stopTest();  
            }    
            
            Test.stopTest();  
            sic.PL_ids = 'test';
            sic.SaveTeamMembers();
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
            List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
            IPM_Bosscard__c bosscard2=new IPM_Bosscard__c();
        bosscard2.Name='Test Data02';
        bosscard2.IPM_IsSaved__c=true;
        insert bosscard2;
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(bosscard2.Id);
                    
 
                    
            try{  
                //testdata.createIPMProjectResource('BD',ipmProjects[0]); 
                User u= testData.testRunAs();     
                sic.selectedPL = u.Id;
                sic.selectedDPL= u.Id;
                sic.selectedTL= u.Id;
                sic.selectedGK = u.Id;
                
                sic.SaveCoreMembers();
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
            
            List<IPM_Bosscard__c> listBosscard= createIPMBosscard();
           
             IPM_Bosscard__c bosscard1=new IPM_Bosscard__c();
        bosscard1.Name='Test Data01';
        bosscard1.IPM_IsSaved__c=true;
        insert bosscard1;
            
            List<IPM_Project__c> ipmProjects= createIPMProjects(listBosscard[0].Id);
            //List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(bosscard1.Id);
                    
                
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
        
       List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
       
       IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();

           ipmBosscard .IPM_BosscardName__c ='Teste82449';
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
           
                  
       return ipmBosscards ;
       
       
   }



  static User createUserBosscard(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 

        User u = new User();

        
             u = new User(Alias = 'te82449', Email='newuser@tete82449rd1.com', 
             EmailEncodingKey='UTF-8', LastName='te82449', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@te82449.com', 
             IPM_Category__c = 'te82449'  , IPM_Brand_Positioning__c= 'te82449',IPM_Brand_Name__c ='te82449',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='test' , isActive =true);
             insert u;

         return u;
    }
   static User  testRunAsBosscard() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 
              User u = new User(Alias = 'te82319', Email='standarduser@te82319.com', 
              EmailEncodingKey='UTF-8', LastName='testorgbte82319rdaa', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@teyd0121.com', 
              IPM_Category__c = 'te82319'  , IPM_Brand_Positioning__c= 'te82319',IPM_Brand_Name__c ='te82319',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='te82319', isActive =true);
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
      IPM_User_Profile__c ipmUserProfile = new IPM_User_Profile__c();
      ipmUserProfile.IPM_user__c =  u1.id;
      
      return ipmUserProfile ;
   
   
   }
   
      
   static User  testRunAsBosscard1() {

              Profile p = [SELECT Id FROM Profile WHERE Name='Standard user']; 


              
              User u = new User(Alias = 'te59919', Email='standarduser@te59919.com', 
              EmailEncodingKey='UTF-8', LastName='b11111', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@te59919.com', 
              IPM_Category__c = 'te59919'  , IPM_Brand_Positioning__c= 'te59919',IPM_Brand_Name__c ='te59919',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='te59919', isActive =true);
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

             u = new User(Alias = 'te5919', Email='newuser@te5919.com', 
             EmailEncodingKey='UTF-8', LastName='te5919', LanguageLocaleKey='en_US', 
             LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@te5919.com', 
             IPM_Category__c = 'te5919'  , IPM_Brand_Positioning__c= 'te5919',IPM_Brand_Name__c ='te5919',
             IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='te5919' , isActive =true);
             insert u;

         return u;
    }
    
   static List<IPM_Project__c> createIPMProjects(Id bosscard){
       
       List<IPM_Project__c> ipmProjects = new List<IPM_Project__c>();
       
           IPM_Project__c ipmProject = new IPM_Project__c();
           ipmProject.IPM_Project_Name__c ='test76';
           
           if(bosscard !=  null){
               ipmProject.IPM_Bosscard__c = bosscard;
               
           }
           ipmProject.IPM_Complexity__c = 'Full';
           ipmProject.IPM_Project_Leader__c=Userinfo.getUserId();
           insert ipmProject;
           
           ipmProject.IPM_Project_Name__c ='test89';
           ipmProjects.add(ipmProject);
           
           ipmProject = new IPM_Project__c();
           insert ipmProject;
           ipmProjects.add(ipmProject);
     
       
       return ipmProjects;
       
       
   }
   
   
   static  List<IPM_Bosscard__c> createIPMBosscard1(){     
        
       List<IPM_Bosscard__c> ipmBosscards = new List<IPM_Bosscard__c>();
       
       IPM_Bosscard__c ipmBosscard  = new IPM_Bosscard__c();
           

           ipmBosscard .IPM_BosscardName__c ='te5934';
           ipmBosscard.IPM_Assumptions__c = 'LOjjiihishfifhsifhte5934ishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Background__c= 'LOjjiihishfifhsifhifte5934hfsihsifhfihfihsihish';
           ipmBosscard.IPM_Constraints__c= 'LOjjiihishfte5934shfsihsifhfihfihsihish';
           ipmBosscard.IPM_Consumer_Need__c= 'LOjjiihishte5934fishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Deliverables__c= 'LOjjiihishfifhte5934fsihsifhfihfihsihish';
           ipmBosscard.IPM_Potential_Business_Opportunity__c= 'LOjjiihishfifhsifhifhihte5934fishisfishfsihsifhfihfihsihish';
           ipmBosscard.IPM_Resources__c= 'LOjjiihishfifhsifhifte5934hsihish';
           ipmBosscard.IPM_Scope__c= 'LOjjiihishfite5934ihsifhfihfihsihish';
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


              
              u2 = new User(Alias = 'te593', Email='standarduser@te593.com', 
              EmailEncodingKey='UTF-8', LastName='te593', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, 
              TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@te593.com', 
              IPM_Category__c = 'te593'  , IPM_Brand_Positioning__c= 'te593',IPM_Brand_Name__c ='te593',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='te593', isActive =true);
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