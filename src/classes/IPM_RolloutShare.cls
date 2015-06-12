/* Created by:Rajesh(Cognizant)
   Created date:9/03/2015
   Description:Share rollout records with users
*/
Public Class IPM_RolloutShare{

public void Sharerecords(map<id,IPM_Project_Rollout__c>NewRollout){
set<id>proid=new set<id>();
list<IPM_Project_Rollout__Share>lstProRollShr=new list<IPM_Project_Rollout__Share>();
set<id>DupUser=new set<id>();
  for(IPM_Project_Rollout__c ipmrollid:NewRollout.values()){
      if(ipmrollid.IPM_Project__c!=null){
        proid.add(ipmrollid.IPM_Project__c);
      }else if(ipmrollid.Regional_Project__c!=null){
      proid.add(ipmrollid.Regional_Project__c);
      }
  }
if(proid.size()>0){  
list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c,IPM_User__c from IPM_Project_Resource__c
                                              where IPM_Project__c IN:proid and IPM_User__c !=:userinfo.getuserid()] ;

list<IPM_Project__c>prolst=[select IPM_Company_Card__c,IPM_Project_Leader__c,IPM_Technical_Project_Leader__c,Deputy_Project_Leader__c
                            ,IPM_Project_Gatekeeper__c from IPM_Project__c where id IN:proid limit 1];
                            
list<IPM_Company_Card__c>lstCC=new list<IPM_Company_Card__c>();
if(prolst.size()>0){ 
if(prolst[0].IPM_Company_Card__c!=null)                           
lstCC=[Select IPM_Business_Partner__c,ipm_managed_category__c from IPM_Company_Card__c where id=:prolst[0].IPM_Company_Card__c];                                                       
}
for(IPM_Project_Rollout__c ipmrollid:NewRollout.values()){
     if(Resourcetoshare.size()>0){
          for(IPM_Project_Resource__c ipmprores:Resourcetoshare){
          DupUser.add(ipmprores.IPM_User__c);
          IPM_Project_Rollout__Share  IpmRollhr=new IPM_Project_Rollout__Share();
          IpmRollhr.ParentId=ipmrollid.id;
          IpmRollhr.userorgroupid=ipmprores.IPM_User__c;
          IpmRollhr.accesslevel='Read';
          lstProRollShr.add(IpmRollhr);
          
          
     } 
    }
   if(ipmrollid.IPM_Regional_PL__c!=null){
              IPM_Project_Rollout__Share  IpmRollhr1=new IPM_Project_Rollout__Share();
              IpmRollhr1.ParentId=ipmrollid.id;
              IpmRollhr1.userorgroupid=ipmrollid.IPM_Regional_PL__c;
              IpmRollhr1.accesslevel='Edit';
              lstProRollShr.add(IpmRollhr1);
          } 
   if(lstCC.size()>0){
            for(IPM_Company_Card__c cc:lstCC){
                if(cc.IPM_Business_Partner__c!=null && cc.IPM_Business_Partner__c!=userinfo.getuserid()){
                  IPM_Project_Rollout__Share  IpmRollhr=new IPM_Project_Rollout__Share();
                  IpmRollhr.parentid=ipmrollid.id;
                  IpmRollhr.accesslevel='Edit';
                  IpmRollhr.UserOrGroupId=cc.IPM_Business_Partner__c;
                  lstProRollShr.add(IpmRollhr);
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
       IPM_Project_Rollout__Share  IpmRollhr=new IPM_Project_Rollout__Share();
       IpmRollhr.parentid=ipmrollid.id;
       IpmRollhr.userorgroupid=ipmpro.IPM_Technical_Project_Leader__c;
       IpmRollhr.AccessLevel='Read';
       lstProRollShr.add(IpmRollhr);
       }
       if(ipmpro.IPM_Project_Leader__c!=userinfo.getuserid() && ipmpro.IPM_Project_Leader__c!=null){
       IPM_Project_Rollout__Share  IpmRollhr=new IPM_Project_Rollout__Share();
       IpmRollhr.parentid=ipmrollid.id;
       IpmRollhr.userorgroupid=ipmpro.IPM_Project_Leader__c;
       IpmRollhr.AccessLevel='Edit';
       lstProRollShr.add(IpmRollhr);
       }
       if(ipmpro.Deputy_Project_Leader__c!=userinfo.getuserid() && ipmpro.Deputy_Project_Leader__c!=null){
       IPM_Project_Rollout__Share  IpmRollhr=new IPM_Project_Rollout__Share();
       IpmRollhr.parentid=ipmrollid.id;
       IpmRollhr.userorgroupid=ipmpro.Deputy_Project_Leader__c;
       IpmRollhr.AccessLevel='Edit';
       lstProRollShr.add(IpmRollhr);
       }
       if(ipmpro.IPM_Project_Gatekeeper__c!=null && ipmpro.IPM_Project_Gatekeeper__c!=userinfo.getuserid()){
       IPM_Project_Rollout__Share  IpmRollhr=new IPM_Project_Rollout__Share();
       IpmRollhr.parentid=ipmrollid.id;
       IpmRollhr.userorgroupid=ipmpro.IPM_Project_Gatekeeper__c;
       IpmRollhr.AccessLevel='Read';
       lstProRollShr.add(IpmRollhr);
       }
     }
 }           
}
list<IPM_User_Profile__c>lstUProfile=[Select IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c from IPM_User_Profile__c where IPM_Work_Level__c='WL2+' and IPM_Company_Card__c=:prolst[0].IPM_Company_Card__c and IPM_User__c Not IN:DupUser];

  for(IPM_Project_Rollout__c ipmrollid:NewRollout.values()){
     for(IPM_Company_Card__c cc:lstCC){
        for(IPM_User_Profile__c up:lstUProfile){
            if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=userinfo.getuserid()){
              IPM_Project_Rollout__Share Rolloshr=  new IPM_Project_Rollout__Share();
              Rolloshr.parentid=ipmrollid.id;
              Rolloshr.accesslevel='Read';
              Rolloshr.UserOrGroupId=up.IPM_User__c;
              lstProRollShr.add(Rolloshr);
            }
        }
      }     
    }
if(lstProRollShr.size()>0){
insert lstProRollShr;
}
}
}
public void UpdateSharerecords(map<id,IPM_Project_Rollout__c>NewRollout){
list<IPM_Project_Rollout__Share>lstProRollShr=new list<IPM_Project_Rollout__Share>();
set<id>Proid=new set<id>();
set<id>RollPL=new set<id>();
 for(IPM_Project_Rollout__c ipmrollid:NewRollout.values()){
      if(ipmrollid.IPM_Project__c!=null){
        proid.add(ipmrollid.IPM_Project__c);
       }else if(ipmrollid.Regional_Project__c!=null){
        proid.add(ipmrollid.Regional_Project__c);
      }
      if(ipmrollid.IPM_Regional_PL__c!=null && ipmrollid.IPM_Regional_PL__c!=userinfo.getuserid()){
      RollPL.add(ipmrollid.IPM_Regional_PL__c);
      }
 }
if(proid.size()>0){
list<IPM_Project_Rollout__c> lstroll=[select id,IPM_Regional_PL__c from IPM_Project_Rollout__c where (IPM_Project__c IN:proid or Regional_Project__c IN:proid)];

for(id PLid:RollPL){
 for(IPM_Project_Rollout__c rolllst:lstroll){
    //if(rolllst.IPM_Regional_PL__c!=null && rolllst.IPM_Regional_PL__c!=userinfo.getuserid()){
       IPM_Project_Rollout__Share rollshr=new IPM_Project_Rollout__Share();
       rollshr.parentid=rolllst.id;
       rollshr.accesslevel='Edit';
       rollshr.UserOrGroupId=PLid;
       lstProRollShr.add(rollshr);
      //}
 }
}
if(lstProRollShr.size()>0){
insert lstProRollShr;
}
}
}
}