/*** Author      : Pratyusha Penugondla
**** Description : The OWD for IPM Tasks is Public ReadOnly
**** To give edit access to other than owners we are creating a share record
updated by-Rajesh(9/01/2015)
**/


trigger IPM_TaskShare on IPM_Task__c (after insert) {
List<IPM_Task__Share> ITS = new List<IPM_Task__Share>();
List<IPM_Task__Share> ProResShrs  = new List<IPM_Task__Share>();
IPM_Task__Share PL; // Consider at permission set level we will provide ViewAll and Modify All
IPM_Task__Share DPL;
IPM_Task__Share TPL;
IPM_Task__Share SL;
IPM_Task__Share ProResShr;
IPM_Task__Share CT;// Consider at permission set level we will provide ViewAll and Modify All
Map<id,string>resourcemap=new map<id,string>();
id recType =Schema.SObjectType.IPM_Task__c.RecordTypeInfosByName.get('IPM Project Tasks').RecordTypeId;
set<id>projectid=new set<id>();
set<id>DupUser=new set<id>();
if(trigger.isInsert) {

for(IPM_Task__c ipmtsk:trigger.new){
if(ipmtsk.RecordTypeId==recType){
if(ipmtsk.IPM_Project__c!=null){
resourcemap.put(ipmtsk.id,ipmtsk.IPM_Function__c);
projectid.add(ipmtsk.IPM_Project__c);
}else{
ipmtsk.IPM_Project__c.adderror('please select project id');
}
}
}
// Assiging the parent Id to Share record
if(projectid.size()>0){
list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c,IPM_User__c from IPM_Project_Resource__c
                                              where IPM_Project__c IN:projectid and IPM_User__c !=:userinfo.getuserid()] ;

list<IPM_Project__c>prolst=[select IPM_Company_Card__c,IPM_Project_Leader__c,IPM_Technical_Project_Leader__c,Deputy_Project_Leader__c
                            ,IPM_Project_Gatekeeper__c from IPM_Project__c where id IN:projectid limit 1];
list<IPM_Company_Card__c>lstCC=[Select IPM_Business_Partner__c,IPM_Managed_Category__c from IPM_Company_Card__c where id=:prolst[0].IPM_Company_Card__c];                                                       
set<id>taskid=resourcemap.keyset();
DupUser.add(prolst[0].IPM_Project_Leader__c);
DupUser.add(prolst[0].IPM_Technical_Project_Leader__c);
DupUser.add(prolst[0].Deputy_Project_Leader__c);
DupUser.add(prolst[0].IPM_Project_Gatekeeper__c);
for(id tid:taskid){
if(Resourcetoshare.size()>0){
 for(IPM_Project_Resource__c ProRe:Resourcetoshare){
     DupUser.add(ProRe.IPM_User__c);
     if(ProRe.IPM_Role_Type__c==resourcemap.get(Tid)){
     ProResShr=new IPM_Task__Share ();
     ProResShr.ParentId=tid;
     ProResShr.UserOrGroupId=ProRe.IPM_User__c ;
     ProResShr.AccessLevel='Edit';
     ProResShrs.add(ProResShr);
     }else if(ProRe.IPM_Role_Type__c=='Supply Chain'){
     ProResShr=new IPM_Task__Share ();
     ProResShr.ParentId=tid;
     ProResShr.UserOrGroupId=ProRe.IPM_User__c ;
     ProResShr.AccessLevel='Edit';
     ProResShrs.add(ProResShr);
     }else{
    ProResShr=new IPM_Task__Share ();
     ProResShr.ParentId=tid;
     ProResShr.UserOrGroupId=ProRe.IPM_User__c ;
     ProResShr.AccessLevel='read';
     ProResShrs.add(ProResShr);
    }
     
    }
}
if(prolst.size()>0){
PL=new IPM_Task__Share (); 
DPL=new IPM_Task__Share ();
TPL=new IPM_Task__Share() ;
SL=new IPM_Task__Share();
if(lstCC.size()>0){
    for(IPM_Company_Card__c cc:lstCC ){
        if(cc.IPM_Business_Partner__c!=null && cc.IPM_Business_Partner__c!=userinfo.getuserid()){
          IPM_Task__Share taskshare=  new IPM_Task__Share();
          taskshare.parentid=TId;
          taskshare.accesslevel='Edit';
          taskshare.UserOrGroupId=cc.IPM_Business_Partner__c;
          ITS.add(taskshare);
        }
    }
}   
if(userinfo.getuserid()!=prolst[0].Deputy_Project_Leader__c && prolst[0].Deputy_Project_Leader__c !=null && prolst[0].Deputy_Project_Leader__c!=prolst[0].IPM_Project_Leader__c){
DPL.ParentId =TId;
DPL.UserOrGroupId=prolst[0].Deputy_Project_Leader__c;
DPL.AccessLevel='edit';
ITS.add(DPL);
    }
if(userinfo.getuserid()!=prolst[0].IPM_Technical_Project_Leader__c && prolst[0].IPM_Technical_Project_Leader__c !=null && prolst[0].IPM_Technical_Project_Leader__c!=prolst[0].IPM_Project_Leader__c){
TPL.ParentId =TId;
TPL.UserOrGroupId=prolst[0].IPM_Technical_Project_Leader__c;
TPL.AccessLevel='edit';
ITS.add(TPL);
    }
/*if(userinfo.getuserid()!=prolst[0].Deputy_Project_Leader__c && prolst[0].Deputy_Project_Leader__c !=null && prolst[0].Deputy_Project_Leader__c!=prolst[0].IPM_Project_Leader__c){
SL.ParentId =TId;
SL.UserOrGroupId=prolst[0].Deputy_Project_Leader__c;
SL.AccessLevel='edit';
ITS.add(SL);
    }*/
if(userinfo.getuserid()!=prolst[0].IPM_Project_Leader__c){
PL.ParentId =TId;
PL.UserOrGroupId=prolst[0].IPM_Project_Leader__c;
PL.AccessLevel='Edit';
ITS.add(PL);
    }    
} 
   
}

list<IPM_User_Profile__c>lstUProfile=[Select IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c from IPM_User_Profile__c where IPM_Work_Level__c='WL2+' and IPM_Company_Card__c=:prolst[0].IPM_Company_Card__c and IPM_User__c Not IN:DupUser];

   for(id tid:taskid){
     for(IPM_Company_Card__c cc:lstCC){
        for(IPM_User_Profile__c up:lstUProfile){
            if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=userinfo.getuserid()){
              IPM_Task__Share tkshr=  new IPM_Task__Share();
              tkshr.parentid=tid;
              tkshr.accesslevel='Read';
              tkshr.UserOrGroupId=up.IPM_User__c;
              ITS.add(tkshr);
            }
        }
      }     
    }
            
}
}
if(ITS.size()>0)
insert ITS;
if(ProResShrs.size()>0)
insert ProResShrs;
}