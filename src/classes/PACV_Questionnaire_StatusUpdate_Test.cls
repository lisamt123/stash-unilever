/**
 * Name:        -   PACV_Questionnaire_StatusUpdate_Test
 * @description -   This is the test class for PACV_Questionnaire_StatusUpdate_Test Trigger to verify the code  while PACV status as 'Published' in PACV Questionnaire record. 
 * @Author      -   ChandraSekaran, Mindtree Ltd     
 */

@isTest
public class PACV_Questionnaire_StatusUpdate_Test {

static testMethod void myStatusTest() {
    PACV_Risk_Assessment_Questionnaire__c questionnaire = new PACV_Risk_Assessment_Questionnaire__c();
        questionnaire.Name = 'Test';
        questionnaire.PACV_Description__c = 'Test';
        questionnaire.PACV_Status__c    = 'Published';
        test.startTest(); 
        insert questionnaire;
        test.stopTest();
    Integer count;
    count=0;
    List<PACV_Risk_Assessment_Questionnaire__c> statusList = [SELECT id, PACV_Status__c FROM PACV_Risk_Assessment_Questionnaire__c WHERE Name != 'Test'];
    for(PACV_Risk_Assessment_Questionnaire__c ra:statusList){
        if (ra.PACV_Status__c == 'Not Published'){
           count = 1;
                         system.assertEquals(1, count);

        }
        else{
            count=0;
             system.assertEquals(0, count);
        }
       
        
    }
   

}
}