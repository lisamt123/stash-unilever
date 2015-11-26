trigger IPM_ShareMilestone on IPM_Milestone__c (before update,after insert,after update) {

/*if(trigger.isBefore){
    Set<String> mileNames=new Set<String>{'Charter Gate Approval','Contract Gate Approval','Market Ready Gate Approval','Market Deployment Gate Approval','Ship To Trade'};
    List<IPM_Milestone__c> lstMileStones=[select Id,IPM_Name__c,IPM_Due_Date__c from IPM_Milestone__c where IPM_Name__c IN : mileNames];
    Map<String,IPM_Milestone__c> mapmilestone=new Map<String,IPM_Milestone__c>();
    for(IPM_Milestone__c ipmmiles:lstMileStones){
        mapmilestone.put(ipmmiles.IPM_Name__c,ipmmiles); 
    }
    for(IPM_Milestone__c ipmmilestones:trigger.new){
        if(mileNames.contains(ipmmilestones.IPM_Name__c) && ipmmilestones.IPM_Name__c != 'Charter Gate Approval'){
            if(ipmmilestones.IPM_Name__c == 'Contract Gate Approval'){
                if(ipmmilestones.IPM_Due_Date__c < mapmilestone.get('Charter Gate Approval').IPM_Due_Date__c){
                    ipmmilestones.addError(ipmmilestones.Name +' Due Date cannot be less than Charter Gate Approval');
                    return;
                }
            }
            if(ipmmilestones.IPM_Name__c == 'Market Ready Gate Approval'){
                if(ipmmilestones.IPM_Due_Date__c < mapmilestone.get('Contract Gate Approval').IPM_Due_Date__c){
                    ipmmilestones.addError(ipmmilestones.Name +' Due Date cannot be less than Contract Gate Approval');
                    return;
                }
            }
            if(ipmmilestones.IPM_Name__c == 'Market Deployment Gate Approval'){
                if(ipmmilestones.IPM_Due_Date__c < mapmilestone.get('Market Ready Gate Approval').IPM_Due_Date__c){
                    ipmmilestones.addError(ipmmilestones.Name +' Due Date cannot be less than Market Ready Gate Approval');
                    return;
                }
            }
            if(ipmmilestones.IPM_Name__c == 'Ship To Trade'){
                if(ipmmilestones.IPM_Due_Date__c < mapmilestone.get('Market Deployment Gate Approval').IPM_Due_Date__c){
                    ipmmilestones.addError(ipmmilestones.Name +' Due Date cannot be less than Market Deployment Gate Approval');
                    return;
                }
            }
        }
    }
}*/

if(trigger.isUpdate && trigger.isAfter){
    List<IPM_Project__c> updprojects=new List<IPM_Project__c>();
    for(IPM_Milestone__c updMileStone:Trigger.new){
        if(updMileStone.Name.contains('Ship to Trade')){
            if(updMileStone.IPM_Project__c != null){
                IPM_Project__c proj=new IPM_Project__c(id=updMileStone.IPM_Project__c,IPM_Target_Launch_Dates__c=updMileStone.IPM_Due_Date__c);
                updprojects.add(proj);
            }
        }
    }
    if(!updprojects.isEmpty()){
        //UpdateChildIpmProjects.off_Trigger=true;
       // update updprojects;
    }
}



List<IPM_Milestone__Share>ProMiles=new list<IPM_Milestone__Share>();
IPM_Milestone__Share IpmMilesShr;
set<id>Proid=new set<id>();
set<id>DupUser=new set<id>();
if(trigger.isInsert){

for(IPM_Milestone__c IpmMile:trigger.new){
if(IpmMile.IPM_Project__c !=null)
Proid.add(IpmMile.IPM_Project__c);
}
if(Proid.size()>0){
list<IPM_Project_Resource__c>lstProRes=[select IPM_User__c,IPM_Role_Type__c,IPM_Project__c from IPM_Project_Resource__c where IPM_Project__c IN:Proid and IPM_User__c !=:userinfo.getuserid()];
list<IPM_Project__c>lstipmpro=[select IPM_Company_Card__c,IPM_Technical_Project_Leader__c,IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,
                                  Deputy_Project_Leader__c from IPM_Project__c where Id IN:Proid]; 
list<IPM_Company_Card__c>lstCC=[Select IPM_Business_Partner__c,IPM_Managed_category__c from IPM_Company_Card__c where id=:lstipmpro[0].IPM_Company_Card__c];                                                    
                                  
 for(IPM_Milestone__c IpmMiles:trigger.new){
    if(lstProRes.size()>0){
     for(IPM_Project_Resource__c ipmprores:lstProRes){
      IpmMilesShr=new IPM_Milestone__Share();
      IpmMilesShr.ParentId=IpmMiles.id;
      IpmMilesShr.userorgroupid=ipmprores.IPM_User__c;
         
          if(ipmmiles.IPM_Type_of_Milestone__c=='Standard' && ipmprores.IPM_Role_Type__c=='CMI'){
                IpmMilesShr.AccessLevel='Read';
                }
               else if (ipmmiles.IPM_Type_of_Milestone__c=='Standard' && ipmprores.IPM_Role_Type__c=='Finance'){
                IpmMilesShr.AccessLevel='Read';
                }
                else if(ipmmiles.IPM_Type_of_Milestone__c=='Standard' && ipmprores.IPM_Role_Type__c=='CD'){
               
                IpmMilesShr.AccessLevel='Read';
                }
                else if (ipmmiles.IPM_Type_of_Milestone__c=='Standard' && ipmprores.IPM_Role_Type__c=='Guest'){
                IpmMilesShr.AccessLevel='Read';
                }else{
                 IpmMilesShr.AccessLevel='Edit';
                }
               if(IpmMilesShr.AccessLevel ==''){ 
               if(ipmmiles.IPM_Type_of_Milestone__c==null && ipmprores.IPM_Role_Type__c!='Guest'){
                  IpmMilesShr.AccessLevel='Edit';
               }else{
                IpmMilesShr.AccessLevel='Read';
               }
              }
         ProMiles.add(IpmMilesShr);
         
        /* if(IpmMiles.IPM_Type_of_Milestone__c=='Standard' && (ipmprores.IPM_Role_Type__c!='CMI' || ipmprores.IPM_Role_Type__c!='Finance' || ipmprores.IPM_Role_Type__c!='CD' || ipmprores.IPM_Role_Type__c!='Guest')){
                  IpmMilesShr.AccessLevel='Edit';
         }else if(IpmMiles.IPM_Type_of_Milestone__c==null && ipmprores.IPM_Role_Type__c!='Guest'){
                  IpmMilesShr.AccessLevel='Edit';
         }else{
                IpmMilesShr.AccessLevel='Read';
               } */
        
        DupUser.add(ipmprores.IPM_User__c);
        }
      }
  
  if(lstipmpro.size()>0){
      for(IPM_Project__c ipmpro:lstipmpro){
       DupUser.add(ipmpro.IPM_Project_Leader__c);
       DupUser.add(ipmpro.IPM_Technical_Project_Leader__c);
       DupUser.add(ipmpro.Deputy_Project_Leader__c);
       DupUser.add(ipmpro.IPM_Project_Gatekeeper__c);
       
       if(lstCC.size()>0){
            for(IPM_Company_Card__c cc:lstCC){
                if(cc.IPM_Business_Partner__c!=null && cc.IPM_Business_Partner__c!=userinfo.getuserid()){
                  IPM_Milestone__Share milesshare=  new IPM_Milestone__Share();
                  milesshare.parentid=IpmMiles.id;
                  milesshare.accesslevel='Edit';
                  milesshare.UserOrGroupId=cc.IPM_Business_Partner__c;
                  ProMiles.add(milesshare);
                }
            }
        }   
       
       if(ipmpro.IPM_Technical_Project_Leader__c!=userinfo.getuserid() && ipmpro.IPM_Technical_Project_Leader__c!=null){
       IpmMilesShr=new IPM_Milestone__Share();
       IpmMilesShr.parentid=IpmMiles.id;
       IpmMilesShr.userorgroupid=ipmpro.IPM_Technical_Project_Leader__c;
       IpmMilesShr.AccessLevel='Edit';
       ProMiles.add(IpmMilesShr);
       }
       if(ipmpro.IPM_Project_Leader__c!=userinfo.getuserid() && ipmpro.IPM_Project_Leader__c!=null){
       IpmMilesShr=new IPM_Milestone__Share();
       IpmMilesShr.parentid=IpmMiles.id;
       IpmMilesShr.userorgroupid=ipmpro.IPM_Project_Leader__c;
       IpmMilesShr.AccessLevel='Edit';
       ProMiles.add(IpmMilesShr);
       }
       if(ipmpro.Deputy_Project_Leader__c!=userinfo.getuserid() && ipmpro.Deputy_Project_Leader__c!=null){
       IpmMilesShr=new IPM_Milestone__Share();
       IpmMilesShr.parentid=IpmMiles.id;
       IpmMilesShr.userorgroupid=ipmpro.Deputy_Project_Leader__c;
       IpmMilesShr.AccessLevel='Edit';
       ProMiles.add(IpmMilesShr);  
       }
       if(ipmpro.IPM_Project_Gatekeeper__c!=null && ipmpro.IPM_Project_Gatekeeper__c!=userinfo.getuserid()){
       IpmMilesShr=new IPM_Milestone__Share();
       IpmMilesShr.parentid=IpmMiles.id;
       IpmMilesShr.userorgroupid=ipmpro.IPM_Project_Gatekeeper__c;
       IpmMilesShr.AccessLevel='Read';
       ProMiles.add(IpmMilesShr);  
       }
      }
   }
  }
 list<IPM_User_Profile__c>lstUProfile=[Select IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c from IPM_User_Profile__c where IPM_Work_Level__c='WL2+' and IPM_Company_Card__c=:lstipmpro[0].IPM_Company_Card__c and IPM_User__c Not IN:DupUser and IPM_User__c !=:userinfo.getuserid()];

   for(IPM_Milestone__c IpmMiles:trigger.new){
     for(IPM_Company_Card__c cc:lstCC){
        for(IPM_User_Profile__c up:lstUProfile){
            if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=IpmMiles.CreatedBy.id && up.IPM_User__c!=IpmMiles.ownerid  && up.IPM_User__c!=userinfo.getuserid()){
              IPM_Milestone__Share mshr=  new IPM_Milestone__Share();
              mshr.parentid=IpmMiles.id;
              mshr.accesslevel='Read';
              mshr.UserOrGroupId=up.IPM_User__c;
              ProMiles.add(mshr);
            }
        }
     }  
    }
 }
}
system.debug('ProMiles....'+ProMiles);

if(ProMiles.size()>0)
  insert ProMiles;
}