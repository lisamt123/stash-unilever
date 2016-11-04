@isTest(SeeAllData=false)
private class UL_ApprovalThresholdHandler_Test{

//Test Data Setup
@testSetup
    private static void CreateTestData(){
//Creating Sales Org 
ACSFUL001__Sales_Organization__c SalesOrganization1 = new ACSFUL001__Sales_Organization__c();
    SalesOrganization1.Name='UK SO';
    SalesOrganization1.ACSFUL001__Currency__c='GBP';
    SalesOrganization1.ACSFUL001__Description_Language_1__c='United Kingdom';
    SalesOrganization1.ACSFUL001__Language_1__c='en';
    SalesOrganization1.ACSFUL001__First_Week_Of_Year__c='0';
    SalesOrganization1.ACSFUL001__First_Day_Of_Week__c='2';
    SalesOrganization1.ACSFUL001__Call_Start_Time__c='9:00';
    insert SalesOrganization1;

}

//Test trigger
@isTest
   private static void ThresholdTriggerTest(){
   
ACSFUL001__Sales_Organization__c SO=[Select id, Name from ACSFUL001__Sales_Organization__c where Name='UK SO'];  

UL_Approval_Threshold__c AT1= new UL_Approval_Threshold__c();
AT1.UL_Sales_Organization__c=SO.id;
AT1.UL_Career_Level__c='CAM WL2-A';
AT1.UL_Threshold_Level__c=1000;
insert AT1;

UL_Approval_Threshold__c AT2= new UL_Approval_Threshold__c();
AT2.UL_Sales_Organization__c=SO.id;
AT2.UL_Career_Level__c='CAM WL2-A';
AT2.UL_Threshold_Level__c=1000;
try{
insert AT2;
}
catch(Exception e){
Boolean expectedExceptionThrown =  e.getMessage().contains('The Career Level for this Sales Org already Exists') ? true : false;
System.AssertEquals(expectedExceptionThrown, true);

}
}
}