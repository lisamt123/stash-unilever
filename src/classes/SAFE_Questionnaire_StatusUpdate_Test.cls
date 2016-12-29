/**
 * Name:        -   SAFE_Questionnaire_StatusUpdate_Test
 * @description -   This is the test class for SAFE_Questionnaire_StatusUpdate_Test Trigger to verify the code  while SAFE status as 'Published' in SAFE Questionnaire record. 
 * @Author      -   ChandraSekaran, Mindtree Ltd     
 */

@isTest
public class SAFE_Questionnaire_StatusUpdate_Test {

static testMethod void myStatusTest() {
    SAFE_Risk_Assessment_Questionnaire__c questionnaire = new SAFE_Risk_Assessment_Questionnaire__c();
        questionnaire.Name = 'Test';
        questionnaire.SAFE_Description__c = 'Test';
        questionnaire.SAFE_Status__c    = 'Published';
        test.startTest(); 
        insert questionnaire;
        test.stopTest();
    Integer count;
    count=0;
    List<SAFE_Risk_Assessment_Questionnaire__c> statusList = [SELECT id, SAFE_Status__c FROM SAFE_Risk_Assessment_Questionnaire__c WHERE Name != 'Test'];
    for(SAFE_Risk_Assessment_Questionnaire__c ra:statusList){
        if (ra.SAFE_Status__c == 'Not Published'){
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