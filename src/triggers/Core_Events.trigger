trigger Core_Events on Core_Events__c (before insert) 

{

    for(Core_Events__c eventRec:Trigger.New)
    {
    eventRec.RecordType = [select Id from RecordType where Name = 'Core_Edit_Other' and SobjectType = 'Core_Events__c'];
    }
}