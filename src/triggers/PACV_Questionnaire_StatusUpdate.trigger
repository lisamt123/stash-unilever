trigger PACV_Questionnaire_StatusUpdate on PACV_Risk_Assessment_Questionnaire__c (after insert, after update) {
 if(Label.PACV_Trigger_Switch.equalsIgnoreCase('True') ||  trigger.isInsert)
    {
    for(PACV_Risk_Assessment_Questionnaire__c a : Trigger.new){
    if(a.PACV_Status__c == 'Published' ){
             List<PACV_Risk_Assessment_Questionnaire__c> statusList = [SELECT id, PACV_Status__c FROM PACV_Risk_Assessment_Questionnaire__c WHERE id NOT IN :Trigger.new];
       for(integer i = 0 ; i < statusList.size(); i++){
        statusList[i].PACV_Status__c = 'Not Published'; 
  }
        update statusList;
    }
 }
}
}