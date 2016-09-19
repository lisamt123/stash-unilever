@IsTest 
Public class KUN_Profile_CC_Test
{
  
    @testSetup
    static void UserProfileSetup() {
        KUNDataFactory.createTestUserRecords();
    }
    public static testmethod void Test_AllContructors(){
        test.StartTest();
        User u2 = [Select Id ,Name ,UserName, Email FROM User WHERE UserName='standarduser1@kunorg.com' LIMIT 1];
        System.runAs(u2) {
            PageReference pageRef = Page.KUN_Profile_VF; 
            Test.setCurrentPage(pageRef); 
            KUN_Profile_CC instance = new KUN_Profile_CC();            
            System.Assert(instance.Profile!= null);        
        }
        test.StopTest();
    }
   
}