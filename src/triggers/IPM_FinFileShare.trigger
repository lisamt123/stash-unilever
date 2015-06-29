trigger IPM_FinFileShare on IPM_Financial_File__c (after insert) {
IPM_FinancialFileShare finfileshare=new IPM_FinancialFileShare();

if(trigger.isInsert){
finfileshare.Sharerecords(trigger.newMap);
}

}