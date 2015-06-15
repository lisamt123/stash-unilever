trigger IPM_CompanyCShare on IPM_Company_Card__c (after insert,after update,before delete) {

map<id,id>BPtoCCuser=new map<id,id>();
map<id,id>oldBPuser=new map<id,id>();
map<id,id>delBPuser=new map<id,id>();
if(trigger.Isinsert){
 List<IPM_Company_Card__Share> IPMCCard  = new List<IPM_Company_Card__Share>();
 IPM_Company_Card__Share CCard;
 
 for(IPM_Company_Card__c ipmCard:trigger.new){
     if(ipmCard.IPM_Business_Partner__c !=null){
     CCard=new IPM_Company_Card__Share();
     CCard.parentid=ipmCard.id;
     CCard.UserOrGroupid=ipmCard.IPM_Business_Partner__c;
     CCard.Accesslevel='Read';
     IPMCCard.add(CCard);
     BPtoCCuser.put(ipmCard.id,ipmCard.IPM_Business_Partner__c);
     }
 }
 if(BPtoCCuser.size()>0){
     IPM_PermissionSet.addPermissionToBP(BPtoCCuser);
     IPM_PermissionSet.ShareWithBP(BPtoCCuser);
 }
if(IPMCCard.size()>0)
insert IPMCCard;
}

if(trigger.isUpdate){
 List<IPM_Company_Card__Share> IPMCCard  = new List<IPM_Company_Card__Share>();
 List<IPM_Company_Card__Share> IPMCCardDelete  = new List<IPM_Company_Card__Share>();
 set<id>changedBP=new set<id>();
 IPM_Company_Card__Share CCard;
 for(IPM_Company_Card__c ipmCard:trigger.new){
    if(ipmCard.IPM_Business_Partner__c !=null){
       if(trigger.oldmap.get(ipmCard.id).IPM_Business_Partner__c !=ipmCard.IPM_Business_Partner__c ){
             string BPuser=trigger.oldmap.get(ipmCard.id).IPM_Business_Partner__c ;
             changedBP.add(BPuser);
             CCard=new IPM_Company_Card__Share();
             CCard.parentid=ipmCard.id;
             CCard.UserOrGroupid=ipmCard.IPM_Business_Partner__c ;
             CCard.Accesslevel='Read';
             IPMCCard.add(CCard);
             BPtoCCuser.put(ipmCard.id,ipmCard.IPM_Business_Partner__c);
             oldBPuser.put(ipmCard.id,trigger.oldmap.get(ipmCard.id).IPM_Business_Partner__c);
             if(trigger.oldmap.get(ipmCard.id).IPM_Business_Partner__c!=null)
             delBPuser.put(ipmCard.id,trigger.oldmap.get(ipmCard.id).IPM_Business_Partner__c);
         }
    }
}
if(BPtoCCuser.size()>0){
     IPM_PermissionSet.addPermissionToBP(BPtoCCuser);
     IPM_PermissionSet.DeleteBPPermission(delBPuser);
     IPM_PermissionSet.ShareWithBP(BPtoCCuser);
     IPM_PermissionSet.DeleteShareWithBP(delBPuser);
 }
if(IPMCCard.size()>0)
insert IPMCCard;

if(changedBP.size()>0){
    IPMCCardDelete=[select id from IPM_Company_Card__Share where UserOrGroupid IN:changedBP];
    if(IPMCCardDelete.size()>0){
        delete IPMCCardDelete;
    }
}

}

if(trigger.isDelete){
List<IPM_Company_Card__Share> IPMCCardDelete  = new List<IPM_Company_Card__Share>();
set<id>changedBP=new set<id>();
   for(IPM_Company_Card__c ipmCard:trigger.old){
    if(ipmCard.IPM_Business_Partner__c !=null){
        changedBP.add(ipmCard.IPM_Business_Partner__c );
        BPtoCCuser.put(ipmCard.id,ipmCard.IPM_Business_Partner__c);
     }   
   }
if(BPtoCCuser.size()>0){
     IPM_PermissionSet.DeleteBPPermission(BPtoCCuser);
     IPM_PermissionSet.DeleteShareWithBP(BPtoCCuser);
 }
if(changedBP.size()>0){
    IPMCCardDelete=[select id from IPM_Company_Card__Share where UserOrGroupid IN:changedBP];
    if(IPMCCardDelete.size()>0){
        delete IPMCCardDelete;
    }
}  
} 

}