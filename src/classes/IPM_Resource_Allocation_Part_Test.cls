@isTest
private class IPM_Resource_Allocation_Part_Test{

       static testMethod  void ipm_Resource_Allocation_Part_TestConstructor(){
          
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        
        User user = testData.createUser(); 
        testData.testRunAs();       
        IPM_User_Profile__c  ipmUserProfile= testData.createIpmUserProfile();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
        List<IPM_Project__c> listIPMProjects= testdata.createIPMProjects(null);

        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
        ApexPages.CurrentPage().getparameters().put('RoleType', 'RND');
        ApexPages.CurrentPage().getparameters().put('Category', 'Test');
        ApexPages.CurrentPage().getparameters().put('ProjectLead', 'Test');
        ApexPages.CurrentPage().getparameters().put('CoreMember', 'Test');
        
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);    
        
           
        
        testdata.createIpmUserProfile();  
        
        
        IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp ();  
        ApexPages.CurrentPage().getparameters().put('RoleType', 'RND');    
        
        //sic = new IPM_Resource_Allocation_PartRevamp (); 
        ApexPages.CurrentPage().getparameters().put('RoleType', 'BD'); 
        //sic = new IPM_Resource_Allocation_PartRevamp (); 
        
        ApexPages.CurrentPage().getparameters().put('RoleType', 'CD'); 
        //sic = new IPM_Resource_Allocation_PartRevamp (); 
        
        ApexPages.CurrentPage().getparameters().put('RoleType', 'R&D'); 
        //sic = new IPM_Resource_Allocation_PartRevamp (); 
        
        ApexPages.CurrentPage().getparameters().put('RoleType', 'test'); 
        //sic = new IPM_Resource_Allocation_PartRevamp (); 
        
        ApexPages.CurrentPage().getparameters().put('RoleType', 'Guest'); 
        sic.Pre_UserId = user.Id;
        sic = new IPM_Resource_Allocation_PartRevamp (); 
        
       
    }

    static testMethod  void testGetSameCategory(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
    
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.getSameCategory(); 
            
            sic.SearchTeambyCat= 'allcategory'; 
            sic.RoleType ='Guest';
            sic.getSameCategory(); 
            
            sic.RoleType ='Test';
            sic.getSameCategory(); 
            Test.stopTest();  

    
    }

    static testMethod  void testFilterTeamMember(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
    
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.FilterTeamMember(); 
            
            sic.SearchTeambyCat= 'allcategory'; 
            sic.RoleType ='Guest';
            sic.FilterTeamMember(); 
            
            sic.RoleType ='Test';
            sic.FilterTeamMember(); 
            
            Test.stopTest(); 
    }
    

    static testMethod  void testAddMemberToWrapper(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
    
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();   
            //list<wrapperclass> teamMembers = new list<wrapperclass>();
            //IPM_Resource_Allocation_PartRevamp ipm_Resource_Allocation_PartRevamp  = new IPM_Resource_Allocation_PartRevamp ();
            //wrapperclass wrapperClass= new wrapperclass();
            //wrapperclass teamMember = new wrapperclass();
            
            //wAdd.checkboxuser = true;
            //sic.Teammembers = wAdd ;
            
                   
                   
            sic.AddMemberToWrapper(); 
            Test.stopTest(); 
    
    }

    static testMethod  void testGetUserdetails(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.getUserdetails(); 
            Test.stopTest(); 
    }
    
    static testMethod  void testGetTeamMember(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.getUserdetails(); 
            Test.stopTest(); 
    }
    
    static testMethod  void testGetPreviousProject(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.getPreviousProject(); 
            Test.stopTest(); 
    }
    
    static testMethod  void testSaveNewmember(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.SaveNewmember();
            Test.stopTest();  
    }
    
    static testMethod  void testGetAssignedTeamMember(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.getAssignedTeamMember(); 
            Test.stopTest(); 
    }
    
    static testMethod  void testDelResourceRecord(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.delResourceRecord();
            Test.stopTest();  
    }
    
    static testMethod  void testChangeOwner(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.changeOwner(); 
            Test.stopTest(); 
    }
    
    static testMethod  void testGetPreviousProMembers(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.getPreviousProMembers(); 
            Test.stopTest(); 
    }
    
    static testMethod  void testAddtoAssignedMem(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  (); 
            //added by Dimple
             IPM_Bosscard__c bosscard1=new IPM_Bosscard__c();
        bosscard1.Name='Test Data';
        bosscard1.IPM_IsSaved__c=true;
        insert bosscard1;
        
        
            //List<IPM_Bosscard__c> listBosscard= testdata.createIPMBosscard();
            //List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(listBosscard[0].Id);
            List<IPM_Project__c> ipmProjects= testdata.createIPMProjects(bosscard1.Id);
            List<IPM_Project_Resource__c> listIPMProjectResources= new List<IPM_Project_Resource__c>();
            
            //IPM_Project_Resource__c ipmProjRes =testdata.createIPMProjectResource('BD',ipmProjects[0]);   
            
            //listIPMProjectResources.add(ipmProjRes );
            //sic.AssignedMember =listIPMProjectResources ;
            //User u = testdata.testRunAs();
                  
            //sic.Pre_UserId = u.Id;         
            //sic.addtoAssignedMem(); 
            Test.stopTest(); 
    }
    
    
    static testMethod  void testAddPreviousProMembers(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.AddPreviousProMembers(); 
            Test.stopTest(); 
    }
    
    static testMethod  void testGetCoreMemberds(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.GetCoreMemberds(); 
            
            sic.CoreMembers = 'PL';
            sic.GetCoreMemberds(); 
            
            sic.CoreMembers = 'DPL';
            sic.GetCoreMemberds(); 
            
            sic.CoreMembers = 'GateK';
            sic.GetCoreMemberds(); 
            
            sic.CoreMembers = 'TPL';
            sic.GetCoreMemberds(); 
            
            Test.stopTest(); 
            
            
    }
    
    static testMethod  void testFilterCoreMember(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            sic.FilterCoreMember(); 
            
            sic.CoreMembers = 'PL';
            sic.FilterCoreMember(); 
            
            sic.CoreMembers = 'DPL';
            sic.FilterCoreMember(); 
            
            sic.CoreMembers = 'GateK';
            sic.FilterCoreMember(); 
            
            sic.CoreMembers = 'TPL';
            sic.FilterCoreMember(); 
            
            Test.stopTest(); 
            
    }
    
    
    static testMethod  void testUpdateCoreMember(){
            Test.startTest();
            ipm_Resource_Allocation_Part_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_PartRevamp  sic = new IPM_Resource_Allocation_PartRevamp  ();          
            
            try{
                //sic.UpdateCoreMember(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
    }

}