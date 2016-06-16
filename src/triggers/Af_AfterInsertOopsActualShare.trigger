trigger Af_AfterInsertOopsActualShare on AF_OOPS_Actual__c (after insert,after update) {
    AF_OopsActualHelper.shareRecordToUser(Trigger.new);
}