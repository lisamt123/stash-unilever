@isTest(SeeAllData=false)
private class UL_User_Extention_Controller_test{

static user sysuser = new User(Id=Userinfo.getUserId());
 
@testSetup
//Data Setup

private static void CreateTestData(){

 //creating user
    Profile p = [SELECT Id FROM Profile WHERE Name = 'SoCo-Finance Admin'];
    UserRole R = [SELECT Id FROM UserRole Where Name = 'COO'];
    user testuser = new user();
    testuser.firstname = 'User1';
    testuser.lastName = 'Test1';
    testuser.email = 'User1.Test1@testorg.com';
    testuser.Username = 'User1.Test1@testorg1.com';
    testuser.EmailEncodingKey = 'ISO-8859-1';
    testuser.Alias = 'utest';
    testuser.CommunityNickname = 'User1.Test1';
    testuser.TimeZoneSidKey = 'America/Los_Angeles';
    testuser.LocaleSidKey = 'en_US';
    testuser.LanguageLocaleKey = 'en_US';
    testuser.ProfileId = p.id;
    testuser.UserRoleid = R.id;
    testuser.ACSFUL001__Sales_Organization__c = 'UK SO';
    testuser.UL_Career_Level__c = 'CAM WL2-A';
    system.runAs(sysuser){
    insert testuser;
    }
    
 //creating Sales Organization records
    ACSFUL001__Sales_Organization__c SalesOrganization1 = new ACSFUL001__Sales_Organization__c();
    SalesOrganization1.Name='UK SO';
    SalesOrganization1.ACSFUL001__Currency__c='GBP';
    SalesOrganization1.ACSFUL001__Description_Language_1__c='United Kingdom';
    SalesOrganization1.ACSFUL001__Language_1__c='en';
    SalesOrganization1.ACSFUL001__First_Week_Of_Year__c='0';
    SalesOrganization1.ACSFUL001__First_Day_Of_Week__c='2';
    SalesOrganization1.ACSFUL001__Call_Start_Time__c='9:00';
    insert SalesOrganization1;
    
 //creating approval theshold record
    ACSFUL001__Sales_Organization__c SO = [Select id from ACSFUL001__Sales_Organization__c where Name='UK SO'];
    
    UL_Approval_Threshold__c ApprovalThreshold1 = new UL_Approval_Threshold__c();
    ApprovalThreshold1.UL_Sales_Organization__c=SO.id;
    ApprovalThreshold1.UL_Career_Level__c='CAM WL2-A';
    ApprovalThreshold1.UL_Threshold_Level__c=50000;
    insert ApprovalThreshold1;
}
//test Controller class
@isTest
private static void ControllerTest(){

   PageReference pageRef = Page.UL_User_Career_Level;
   Test.setCurrentPage(pageRef);

ACSFUL001__Sales_Organization__c SalesOrg = [Select id, Name from ACSFUL001__Sales_Organization__c where Name='UK SO'];
UL_Approval_Threshold__c AT=[select Name, UL_Career_Level__c, UL_Sales_Organization__c, UL_Threshold_Level__c From UL_Approval_Threshold__c Where UL_Career_Level__c='CAM WL2-A' And UL_Sales_Organization__c=:SalesOrg.id];
//ApexPages.currentPage().getParameters().put('ATId', AT.id);
ApexPages.currentPage().getParameters().put('CareerLevel', AT.UL_Career_Level__c);
ApexPages.currentPage().getParameters().put('OrgName', SalesOrg.Name);
ApexPages.StandardController stdThreshold = new ApexPages.StandardController(AT);
UL_User_Extention_Controller ThresholdUser = new UL_User_Extention_Controller(stdThreshold);

system.debug('userids '+ThresholdUser.userlist);
 
system.assert(ThresholdUser.userlist.size() > 0 ? true : false) ;
}

}