trigger IPM_UniqueUP on IPM_User_Profile__c (before insert,before update) {

if(trigger.isinsert){
Set <String>Uname  = new Set<String>();
map<id,id>mapUPtoCC=new map<id,id>();
for (IPM_User_Profile__c UP:Trigger.new)
{
    if(UP.IPM_User__c!=null && UP.IPM_Company_Card__c!=null){
     Uname.add(up.IPM_User__c);
     mapUPtoCC.put(up.IPM_User__c,UP.IPM_Company_Card__c);
    }
}
List <IPM_User_Profile__c> lstCCs = [SELECT Id, IPM_User__c,IPM_Company_Card__c FROM IPM_User_Profile__c where IPM_User__c in :mapUPtoCC.keyset() and IPM_Company_Card__c IN:mapUPtoCC.values()];
Map <String,string > NameToCompanyC = new Map<String,string>(); 

for (IPM_User_Profile__c up:lstCCs )
{
    NameToCompanyC.put(up.IPM_User__c,up.IPM_Company_Card__c);
}
for (IPM_User_Profile__c up:Trigger.New)
{
    if (NameToCompanyC.containskey(up.IPM_User__c))
    {
       up.IPM_User__c.addError('Cureent user is allready assigned to selected company card'); 
    } 
}
}

if(trigger.isupdate){
Set <String>Uname  = new Set<String>();
map<id,id>mapUPtoCC=new map<id,id>();
for (IPM_User_Profile__c UP:Trigger.new)
{
    if(UP.IPM_User__c!=null && UP.IPM_Company_Card__c!=null && trigger.oldmap.get(UP.id).IPM_User__c!=UP.IPM_User__c){
     Uname.add(up.IPM_User__c);
     mapUPtoCC.put(up.IPM_User__c,UP.IPM_Company_Card__c);
    }
}
List <IPM_User_Profile__c> lstCCs = [SELECT Id, IPM_User__c,IPM_Company_Card__c FROM IPM_User_Profile__c where IPM_User__c in :mapUPtoCC.keyset() and IPM_Company_Card__c IN:mapUPtoCC.values()];
Map <String,string > NameToCompanyC = new Map<String,string>(); 

for (IPM_User_Profile__c up:lstCCs )
{
    NameToCompanyC.put(up.IPM_User__c,up.IPM_Company_Card__c);
}
for (IPM_User_Profile__c up:Trigger.New)
{
    if (NameToCompanyC.containskey(up.IPM_User__c))
    {
       up.IPM_User__c.addError('Cureent user is allready assigned to selected company card'); 
    } 
}
}
}