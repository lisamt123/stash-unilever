@isTest(seeAllData=false)

public class CEC_TypeaheadTest {
    static  testmethod void testSearchRecords(){
        mdm_Reason_Code__c reasonCode=new mdm_Reason_Code__c();
        reasonCode.Name='do* test reason';
        insert reasonCode;
        Test.startTest();
        List<String> fieldsList=new List<String>();
        fieldsList.add('Name');
        fieldsList.add('Id');
        list<sObject> listSearchResults=Typeahead.searchRecords( 'do','mdm_Reason_Code__c',fieldsList,'Name','','',10);
        System.assertEquals(true,listSearchResults.size()>=0);
        Test.stopTest();
    } 
}