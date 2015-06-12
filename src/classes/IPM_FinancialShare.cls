/* Created by:Rajesh(Cognizant)
   Created date:9/03/2015
   Description:Share Finance records with users
*/
Public Class IPM_FinancialShare{

public void Sharerecords(map<id,IPM_Financial__c>NewFin){
set<id>proid=new set<id>();
list<IPM_Financial__Share>lstFinShr=new list<IPM_Financial__Share>();
set<id>DupUser=new set<id>();
set<id>Rollid=new set<id>();
  for(IPM_Financial__c ipmfinid:NewFin.values()){
      if(ipmfinid.Regional_Project__c==null && ipmfinid.Local_Project__c==null && ipmfinid.Parent_Project__c!=null){
        proid.add(ipmfinid.Parent_Project__c);
      }
      else if(ipmfinid.Regional_Project__c!=null && ipmfinid.Local_Project__c==null && ipmfinid.Parent_Project__c!=null){
        proid.add(ipmfinid.Regional_Project__c);
      }
      else if( ipmfinid.Local_Project__c!=null){
        proid.add(ipmfinid.Local_Project__c);
      }
      if(ipmfinid.IPM_Project_Rollout__c!=null){
       Rollid.add(ipmfinid.IPM_Project_Rollout__c);
      }
  }
if(proid.size()==0 && Rollid.size()>0){
list<IPM_Project_Rollout__c>lstrollout=[select id,IPM_Project__c,Regional_Project__c,Local_Project__c from IPM_Project_Rollout__c where id IN:Rollid];
for(IPM_Project_Rollout__c roll:lstrollout){
    if(roll.IPM_Project__c!=null){
        proid.add(roll.IPM_Project__c);
    }else if(roll.Regional_Project__c!=null){
       proid.add(roll.Regional_Project__c);
    }else if(roll.Local_Project__c!=null){
       proid.add(roll.Local_Project__c);
    }
}
}
if(proid.size()>0){
list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c,IPM_User__c from IPM_Project_Resource__c
                                              where IPM_Project__c IN:proid and IPM_User__c !=:userinfo.getuserid()] ;

list<IPM_Project__c>prolst=[select IPM_Company_Card__c,IPM_Project_Leader__c,IPM_Technical_Project_Leader__c,Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c
                            from IPM_Project__c where id IN:proid limit 1];
list<IPM_Company_Card__c>lstCC=new list<IPM_Company_Card__c>();
if(prolst.size()>0){ 
if(prolst[0].IPM_Company_Card__c!=null)                           
lstCC=[Select IPM_Business_Partner__c,ipm_managed_category__c from IPM_Company_Card__c where id=:prolst[0].IPM_Company_Card__c];                                                       
}
for(IPM_Financial__c ipmfinid:NewFin.values()){
     if(Resourcetoshare.size()>0){
         for(IPM_Project_Resource__c ipmprores:Resourcetoshare){
          DupUser.add(ipmprores.IPM_User__c);
          IPM_Financial__Share  ipmfinshr=new IPM_Financial__Share();
          ipmfinshr.ParentId=ipmfinid.id;
          ipmfinshr.userorgroupid=ipmprores.IPM_User__c;
          if(ipmprores.IPM_Role_Type__c=='Finance'){
          ipmfinshr.accesslevel='Edit';
          }else{
          ipmfinshr.accesslevel='Read';
          }
          lstFinShr.add(ipmfinshr);
     } 
    }
   if(lstCC.size()>0){
            for(IPM_Company_Card__c cc:lstCC){
                if(cc.IPM_Business_Partner__c!=null && cc.IPM_Business_Partner__c!=userinfo.getuserid()){
                  IPM_Financial__Share  ipmfinshr=new IPM_Financial__Share();
                  ipmfinshr.parentid=ipmfinid.id;
                  ipmfinshr.accesslevel='Edit';
                  ipmfinshr.UserOrGroupId=cc.IPM_Business_Partner__c;
                  lstFinShr.add(ipmfinshr);
                }
            }
        } 
 if(prolst.size()>0){
     for(IPM_Project__c ipmpro:prolst){
       DupUser.add(ipmpro.IPM_Technical_Project_Leader__c);
       DupUser.add(ipmpro.IPM_Project_Leader__c);
       DupUser.add(ipmpro.Deputy_Project_Leader__c);
       DupUser.add(ipmpro.IPM_Project_Gatekeeper__c);
       if(ipmpro.IPM_Technical_Project_Leader__c!=userinfo.getuserid() && ipmpro.IPM_Technical_Project_Leader__c!=null){
       IPM_Financial__Share  ipmfinshr=new IPM_Financial__Share();
       ipmfinshr.parentid=ipmfinid.id;
       ipmfinshr.userorgroupid=ipmpro.IPM_Technical_Project_Leader__c;
       ipmfinshr.AccessLevel='Read';
       lstFinShr.add(ipmfinshr);
       }
       if(ipmpro.IPM_Project_Leader__c!=userinfo.getuserid() && ipmpro.IPM_Project_Leader__c!=null){
       IPM_Financial__Share  ipmfinshr=new IPM_Financial__Share();
       ipmfinshr.parentid=ipmfinid.id;
       ipmfinshr.userorgroupid=ipmpro.IPM_Project_Leader__c;
       ipmfinshr.AccessLevel='Edit';
       lstFinShr.add(ipmfinshr);
       }
       if(ipmpro.Deputy_Project_Leader__c!=userinfo.getuserid() && ipmpro.Deputy_Project_Leader__c!=null){
       IPM_Financial__Share  ipmfinshr=new IPM_Financial__Share();
       ipmfinshr.parentid=ipmfinid.id;
       ipmfinshr.userorgroupid=ipmpro.Deputy_Project_Leader__c;
       ipmfinshr.AccessLevel='Edit';
       lstFinShr.add(ipmfinshr);
       }
       if(ipmpro.IPM_Project_Gatekeeper__c!=null && ipmpro.IPM_Project_Gatekeeper__c!=userinfo.getuserid()){
       IPM_Financial__Share  ipmfinshr=new IPM_Financial__Share();
       ipmfinshr.parentid=ipmfinid.id;
       ipmfinshr.userorgroupid=ipmpro.IPM_Project_Gatekeeper__c;
       ipmfinshr.AccessLevel='Read';
       lstFinShr.add(ipmfinshr);
       }
     }
 }           
}
system.debug('prolst....'+prolst);
list<IPM_User_Profile__c>lstUProfile=[Select IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c from IPM_User_Profile__c where IPM_Work_Level__c='WL2+' and IPM_Company_Card__c=:prolst[0].IPM_Company_Card__c and IPM_User__c Not IN:DupUser];

 for(IPM_Financial__c ipmfinid:NewFin.values()){
     for(IPM_Company_Card__c cc:lstCC){
        for(IPM_User_Profile__c up:lstUProfile){
            if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=userinfo.getuserid()){
              IPM_Financial__Share fshr=  new IPM_Financial__Share();
              fshr.parentid=ipmfinid.id;
              fshr.accesslevel='Read';
              fshr.UserOrGroupId=up.IPM_User__c;
              lstFinShr.add(fshr);
            }
        }
      }     
    }
if(lstFinShr.size()>0){
insert lstFinShr;
}
}
}
}