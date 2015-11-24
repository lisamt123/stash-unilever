trigger IPM_AssignPermission on IPM_User_Profile__c (before insert,before update,before delete) {
if(trigger.isinsert || trigger.isupdate){
boolean isPL;
boolean isFinance;
boolean isPLDelete;
Boolean isFinDelete;
list<id> createPLPermissioset=new list<id>();
list<id> createFinancePermissioset=new list<id>();
list<id>deletePLPermission=new list<id>();
list<id>deleteFinance=new list<id>();
List<String> userdetails = new List<String>();
set<id>CheckForUser=new set<id>();

for(IPM_User_Profile__c userPro:trigger.new){
        //if(trigger.oldmap.get(userPro.id).IPM_User__c !=userPro.IPM_User__c)
       // CheckForUser.add(userPro.IPM_User__c);
        IPM_PermissionSet Permis=new IPM_PermissionSet(userPro.id,userPro.IPM_User__c,userPro.IPM_User_Role__c,userPro.IPM_User_Function__c,userPro.IPM_Central_Team__c,userPro.Export_Porfolio_Data__c);
        userdetails .add(JSON.serialize(Permis));
       
       /* if(userPro.IPM_Project_Leader__c==true){
        isPL=true;
        createPLPermissioset.add(userPro.IPM_User__c);
        }else{
        isPLDelete=true;
        deletePLPermission.add(userPro.IPM_User__c);
        }
        if(userPro.IPM_Finance_Member__c==true){
        isFinance=true;
        createFinancePermissioset.add(userPro.IPM_User__c);
        }else{
        isFinDelete=true;
        deleteFinance.add(userPro.IPM_User__c);
        }*/
       }
list<user>lstuser=[Select id from user where IsActive=true and User_License__c='Salesforce' and id IN:CheckForUser];
list<IPM_User_Profile__c>lstvaliduser=[select id from IPM_User_Profile__c where IPM_User__c IN:CheckForUser];

if(lstuser.size()>0){
    if(lstvaliduser.size()>0){
    Trigger.New[0].IPM_User__c.adderror('This user is already assigned in user profile');
    }else{
    IPM_PermissionSet.addPermissionToUser(userdetails);
    }
}else{
//Trigger.New[0].IPM_User__c.adderror('In valid user');
}

IPM_PermissionSet.addPermissionToUser(userdetails);     
/*if(isPL==true)
IPM_PermissionSet.addPermission(createPLPermissioset);
if(isFinance==true)
IPM_PermissionSet.addFinancePermission(createFinancePermissioset);
if(isPLDelete==true)
IPM_PermissionSet.deletePermission(deletePLPermission);
if(isFinDelete==true)
IPM_PermissionSet.deleteFinPermission(deletePLPermission);
*/
}

if(trigger.isdelete){
List<String> userdetails = new List<String>();
    for(IPM_User_Profile__c userPro:trigger.old){
        IPM_PermissionSet Permis=new IPM_PermissionSet(userPro.id,userPro.IPM_User__c,userPro.IPM_User_Role__c,userPro.IPM_User_Function__c,userPro.IPM_Central_Team__c,userPro.Export_Porfolio_Data__c);
        userdetails .add(JSON.serialize(Permis));
    }
IPM_PermissionSet.DeletePermissionToUser(userdetails);
}

}