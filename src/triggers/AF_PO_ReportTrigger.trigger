trigger AF_PO_ReportTrigger on AF_PO_Report__c(after delete, after insert, after undelete,after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(AF_PO_Report__c.sObjectType);  
}