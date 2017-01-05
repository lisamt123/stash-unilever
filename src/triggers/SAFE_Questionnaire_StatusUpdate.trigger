/**
 * Name:        -   SAFE_Questions_AnswerCreation
 * @description -   This is the Trigger used for inserting SAFE_Questions__c and SAFE_Answers__c record when the Questionnaire SAFE_Status__c 'Published' . 
 * @Author      -   Chandrasekaran, Mindtree Ltd     
 */
trigger SAFE_Questionnaire_StatusUpdate on SAFE_Risk_Assessment_Questionnaire__c (after insert, after update) {
 if(Label.SAFE_Trigger_Switch.equalsIgnoreCase('True') ||  trigger.isInsert)
    {
    for(SAFE_Risk_Assessment_Questionnaire__c a : Trigger.new){
    if(a.SAFE_Status__c == 'Published' ){
             List<SAFE_Risk_Assessment_Questionnaire__c> statusList = [SELECT id, SAFE_Status__c FROM SAFE_Risk_Assessment_Questionnaire__c WHERE id NOT IN :Trigger.new];
       for(integer i = 0 ; i < statusList.size(); i++){
        statusList[i].SAFE_Status__c = 'Not Published'; 
       // statusList[i].RecordTypeId = Label.SAFE_Not_Published_RecTypeId;
         
  }
        update statusList;
    }
 }
}
}