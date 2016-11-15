trigger AF_OopsPOreport_Delete on AF_OOPS_Actual__c (before delete) {
    Set<String> OopsActualids = new Set<String>();
    List<AF_OOPS_Estimate__c> oopsEstRecordList = new List<AF_OOPS_Estimate__c>();
    List<AF_OOPS_Actual__c> oopsActualRecordList = new List<AF_OOPS_Actual__c>();
    if(Trigger.isDelete){
        for(AF_OOPS_Actual__c  eachRecord:Trigger.old){
            OopsActualids.add(eachRecord.Id);
        }
        system.debug('OopsActualids....'+OopsActualids);
        if(!OopsActualids.isEmpty()){
            try{
            oopsEstRecordList = [select Id from AF_OOPS_Estimate__c where AF_OOPS_Actual__c IN :OopsActualids];
            }
            catch(Exception e){
                system.debug(e);
            }
        }
        if(!oopsEstRecordList.isEmpty()){
            system.debug('oopsEstRecordList....'+oopsEstRecordList);
            delete oopsEstRecordList;
        }
    }
}