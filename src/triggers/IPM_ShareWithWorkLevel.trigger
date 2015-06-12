trigger IPM_ShareWithWorkLevel on IPM_User_Profile__c (after Insert) {
IPM_ShareWithWorkLevel Sharedata=new IPM_ShareWithWorkLevel();
if(trigger.isInsert){
    Sharedata.ShareRecords(trigger.new);
}
}