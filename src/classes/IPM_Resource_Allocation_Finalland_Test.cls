@isTest
private class IPM_Resource_Allocation_Finalland_Test{

       static testMethod  void ipm_Resource_Allocation_Final_TestConstructor(){
          
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        
        User u= testData.createUser(); 
        testData.testRunAs();       
        IPM_User_Profile__c  ipmUserProfile= testData.createIpmUserProfile();
        
        PageReference pageRef = Page.ipmProjectSetup;
        Test.setCurrentPageReference(pageRef);
        
        List<IPM_Project__c> listIPMProjects= testdata.createIPMProjects(null);

        ApexPages.CurrentPage().getparameters().put('id', listIPMProjects[0].id);
        ApexPages.StandardController sc = new ApexPages.standardController(listIPMProjects[0]);
        
        testdata.createIpmUserProfile();    
        
        
        IPM_Resource_Allocation_Finallanding  sic = new IPM_Resource_Allocation_Finallanding (); 

       
    }
    
    static testMethod  void testIpm_Resource_Allocation_FinalRevamp_TestConstructor(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
    
            IPM_Resource_Allocation_FinalRevamp   sic = new IPM_Resource_Allocation_FinalRevamp  ();          
            try{
                sic.Initialise();
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
    }

    static testMethod   void testGetGuestUser(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding  sic = new IPM_Resource_Allocation_Finallanding  ();          
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
            IPM_Resource_Allocation_Finallanding  sic = new IPM_Resource_Allocation_Finallanding  ();          
            try{    
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
            IPM_Resource_Allocation_Finallanding   sic = new IPM_Resource_Allocation_Finallanding  ();          
            try{
                sic.getPreviousProject(); 
                
            }
            
            catch(Exception e){
                Test.stopTest(); 
            } 
    }
    
    static testMethod  void testAddAllPreviousProMembers(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding   ();          
            try{    
                sic.AddAllPreviousProMembers(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
    }
    
   static testMethod  void testGetItemsPL(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    ();          
            try{    
                sic.getItemsPL(); 
              
              }
            
            catch(Exception e){
                Test.stopTest(); 
            }
    }
    
   static testMethod  void testGetItemsGK(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    ();          
            try{
                sic.getItemsGK(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }    
            Test.stopTest(); 
    }
    
    static testMethod  void testGetItemsTL(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    ();          
            try{
                sic.getItemsTL(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
            Test.stopTest(); 
    }
    
    static testMethod  void testGetItemsDPL(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    ();          
            try{
                sic.getItemsDPL(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
            Test.stopTest(); 
    }
    
    static testMethod  void testDPLImage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    ();     
            sic.selectedDPL='test';
            try{ 
                sic.DPLImage(); 
            }
            
            catch(Exception e){
                
            }
            
            finally{
                Test.stopTest(); 
            }
    }
    
    
    static testMethod  void testTLImage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    ();       
            
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
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    (); 
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
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    ();  
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
            IPM_Resource_Allocation_Finallanding      sic = new IPM_Resource_Allocation_Finallanding    ();       
            sic.GateKeeperName='test';
            try{
                sic.GKImageNew(); 
            }
            catch(Exception e){
                
            }
            
            finally{
                Test.stopTest(); 
            }
            

    }
    
    static testMethod  void testDPLImageNew(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding     sic = new IPM_Resource_Allocation_Finallanding    ();  
            sic.DPLName= 'test';  
            try{   
                sic.DPLImageNew(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }    
                
            Test.stopTest(); 
    }
    
    static testMethod  void testTLImageNew(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding     sic = new IPM_Resource_Allocation_Finallanding    ();   
            sic.TPLName  = 'test';     
            try{   
                sic.TLImageNew(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
            
            
    }
    
    static testMethod  void testPLImage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding    ();   
            sic.selectedPL= 'test';    
            try{    
                sic.PLImage(); 
            }
            
            catch(Exception e)
            {
                Test.stopTest(); 
            }
            
            
    }
    
    static testMethod  void testSelectImage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding     sic = new IPM_Resource_Allocation_Finallanding(); 
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
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding();          
            try{
                sic.closePopup(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
    }
    
    static testMethod  void testShowPopup(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding     sic = new IPM_Resource_Allocation_Finallanding();          
            try{
                sic.showPopup(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
    }
    
    static testMethod  void testSaveTeamMembers(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding    sic = new IPM_Resource_Allocation_Finallanding();          
            sic.SaveTeamMembers(); 
            
            sic.PL_ids = 'test';
            try{
                sic.SaveTeamMembers();
            
            
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
            
    }
    
    static testMethod  void testSaveTeamMembers_Nextpage(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding sic = new IPM_Resource_Allocation_Finallanding();          
            try{   
                sic.SaveTeamMembers_Nextpage(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
    }
    
    static testMethod  void testBacktohomepg(){
            Test.startTest();
            ipm_Resource_Allocation_Final_TestConstructor();
            IPM_TestDataUtils testData = new IPM_TestDataUtils();
            IPM_Resource_Allocation_Finallanding sic = new IPM_Resource_Allocation_Finallanding();          
            try{
                sic.backtohomepg(); 
            }
            
            catch(Exception e){
                Test.stopTest(); 
            }
    }
    
    

}