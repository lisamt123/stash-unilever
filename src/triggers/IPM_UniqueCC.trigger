trigger IPM_UniqueCC on IPM_Company_Card__c (before insert,before update) {
if(trigger.isinsert){
Set <String> ccid = new Set<String>();
for (IPM_Company_Card__c cc:Trigger.new)
{
    ccid .add(cc.name);
}
List <IPM_Company_Card__c > lstCCs = [SELECT Id, name FROM IPM_Company_Card__c where name in :ccid ];
Map <String,IPM_Company_Card__c > NameToCompanyC = new Map<String,IPM_Company_Card__c >(); 

for (IPM_Company_Card__c cc:lstCCs )
{
    NameToCompanyC.put(cc.name,cc);
}
for (IPM_Company_Card__c cc:Trigger.New)
{
    if (NameToCompanyC.containsKey(cc.name))
    {
         
        cc.name.addError('Duplicate company card name is not allowed'); 
    } 
}
}
if(trigger.isupdate){
Set <String> ccid = new Set<String>();
for (IPM_Company_Card__c cc:Trigger.new)
{
    if(trigger.oldmap.get(cc.id).name!=cc.name){
     ccid .add(cc.name);
    }
}
List <IPM_Company_Card__c > lstCCs = [SELECT Id, name FROM IPM_Company_Card__c where name in :ccid ];
Map <String,IPM_Company_Card__c > NameToCompanyC = new Map<String,IPM_Company_Card__c >(); 

for (IPM_Company_Card__c cc:lstCCs )
{
    NameToCompanyC.put(cc.name,cc);
}
for (IPM_Company_Card__c cc:Trigger.New)
{
    if (NameToCompanyC.containsKey(cc.name))
    {
         
        cc.name.addError('Duplicate company card name is not allowed'); 
    } 
}
}

}