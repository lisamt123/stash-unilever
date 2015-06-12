public class IPM_ProjectShare{
    List<IPM_Project_Resource__Share> ProResShrs  = new List<IPM_Project_Resource__Share>();
    List<IPM_Project__Share> ProjectShrs  = new List<IPM_Project__Share>();
    List<IPM_Project_Document__Share>ProDocuments=new list<IPM_Project_Document__Share>();
    List<IPM_Task__Share>ProTaskShare=new list<IPM_Task__Share>();
    List<IPM_Project_Document_Section__Share>ProDocSec=new list<IPM_Project_Document_Section__Share>();
    List<IPM_Project_Document_Section_Content__Share>ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
    List<IPM_Milestone__Share>ProMiles=new list<IPM_Milestone__Share>();
    List<IPM_Questionnaire__Share>IpmQuests=new list<IPM_Questionnaire__Share>();
    List<IPM_Bosscard__Share>IpmBossShare=new list<IPM_Bosscard__Share>();
    list<IPM_Project_Rollout__Share>lstProRollShr=new list<IPM_Project_Rollout__Share>();
    list<IPM_Financial__Share>lstFinShr=new list<IPM_Financial__Share>();
    IPM_Bosscard__Share Bossshare;
    IPM_Project_Document__Share ProDocShr;
    IPM_Project__Share ipmProshr;
    IPM_Project_Resource__Share DPLrsShr;
    IPM_Project_Resource__Share GatekrsShr;
    IPM_Project_Resource__Share TPLrsShr;
    IPM_Project_Document_Section__Share ProSec;
    IPM_Task__Share ProTskShare;
    IPM_Project_Document_Section_Content__Share IpmDocContent;
    IPM_Milestone__Share PLIpmMilesShr;
    IPM_Milestone__Share DPLIpmMilesShr;
    IPM_Milestone__Share TPLIpmMilesShr;
    IPM_Milestone__Share GatepmMilesShr;
    IPM_Project_Resource__Share rsShr1;
    IPM_Questionnaire__Share IPMQuestshr;
    set<id>proId=new set<id>();
    set<id>ChangedUserid=new set<id>();
    set<id>proidtoshare=new set<id>();
public void Sharerecords(map<id,IPM_Project__c>Newproject,map<id,IPM_Project__c>oldproject){
      for(IPM_Project__c ipmproid:Newproject.values()){
        if(ipmproid.IPM_Project_Leader__c!=oldproject.get(ipmproid.id).IPM_Project_Leader__c && ipmproid.IPM_Project_Leader__c!=null && ipmproid.OwnerId !=ipmproid.IPM_Project_Leader__c){
         proId.add(ipmproid.id);
         }
         else if(ipmproid.IPM_Project_Leader__c!=ipmproid.Deputy_Project_Leader__c && ipmproid.Deputy_Project_Leader__c!=oldproject.get(ipmproid.id).Deputy_Project_Leader__c && ipmproid.Deputy_Project_Leader__c!=null){
          proId.add(ipmproid.id);
         }
         else  if(ipmproid.IPM_Project_Leader__c!=ipmproid.IPM_Technical_Project_Leader__c && ipmproid.IPM_Technical_Project_Leader__c!=oldproject.get(ipmproid.id).IPM_Technical_Project_Leader__c && ipmproid.IPM_Technical_Project_Leader__c!=null){
         proId.add(ipmproid.id);
         }
         else if(ipmproid.IPM_Project_Leader__c!=ipmproid.IPM_Project_Gatekeeper__c && ipmproid.IPM_Project_Gatekeeper__c!=oldproject.get(ipmproid.id).IPM_Project_Gatekeeper__c && ipmproid.IPM_Project_Gatekeeper__c!=null){
        proId.add(ipmproid.id);
        }  
     } 
 map<id,id>companyNCCid=new map<id,id>();
for(IPM_Project__c ipmpr:Newproject.values()){
    if(oldproject.get(ipmpr.id).IPM_Company_Card__c!=ipmpr.IPM_Company_Card__c && ipmpr.IPM_Company_Card__c!=null){
        companyNCCid.put(ipmpr.id,ipmpr.IPM_Company_Card__c);
    }
}
set<id>ProjectIds=new set<id>();
ProjectIds=companyNCCid.keyset();

if(ProjectIds.size()>0){
list<IPM_Project__share>lstproshare=new list<IPM_Project__share>();
list<IPM_Milestone__share>lstmileshare=new list<IPM_Milestone__share>();
list<IPM_Task__Share>lsttaskshare=new list<IPM_Task__Share>();
list<IPM_Project_Resource__Share>lstresshare=new list<IPM_Project_Resource__Share>();
list<IPM_Project_Document__Share>lstProdocshare=new list<IPM_Project_Document__Share>();
list<IPM_Project_Document_Section__Share>lstProDocSec=new list<IPM_Project_Document_Section__Share>();
list<IPM_Project_Document_Section_Content__Share>lstProDocContentshr=new list<IPM_Project_Document_Section_Content__Share>();
list<IPM_Questionnaire__Share>lstQshare=new list<IPM_Questionnaire__Share>();
list<IPM_Company_Card__c>lstcc=[select IPM_Business_Partner__c,IPM_Managed_Category__c from IPM_Company_Card__c where id IN:companyNCCid.values()];
list<IPM_Milestone__c>lstmiles=[select id,IPM_Type_of_Milestone__c,IPM_Project__c from IPM_Milestone__c where IPM_Project__c IN:companyNCCid.keyset()];
list<IPM_Task__c>IPMTask=[select id,IPM_Assignee__c,IPM_Function__c,IPM_Project__c from IPM_Task__c where IPM_Project__c IN:companyNCCid.keyset()];
list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c,IPM_Project__c from IPM_Project_Resource__c  where IPM_Project__c IN:companyNCCid.keyset() ] ;
list<IPM_Project_Document__c> ProDocs= [SELECT IPM_Project__c FROM IPM_Project_Document__c where IPM_Project__c IN:companyNCCid.keyset()];
set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:companyNCCid.keyset()])).keyset();
list<IPM_Project_Document_Section__c>lstsection =[select id,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c IN:ProDocid ];
set<id>Sectionid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:companyNCCid.keyset()])).keyset();
list<IPM_Project_Document_Section_Content__c>lstProDocContent=[select IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:Sectionid];
map<id,string>sectionmap=new map<id,string>(); 
list<IPM_Questionnaire__c>lstQuests=[select id from IPM_Questionnaire__c where IPM_Project__c IN:companyNCCid.keyset()];
list<IPM_User_Profile__c>lstUProfile=[Select IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c from IPM_User_Profile__c where IPM_Work_Level__c='WL2+' and IPM_Company_Card__c=:lstcc[0].id];
    for(IPM_Company_Card__c cc:lstcc){
        if(cc.IPM_Business_Partner__c!=userinfo.getuserid() && cc.IPM_Business_Partner__c!=null){
        for(IPM_Project__c ipmpr1:Newproject.values()){
            if(companyNCCid.get(ipmpr1.id)==cc.id){
                IPM_Project__share ipmproshare=new IPM_Project__share();
                ipmproshare.parentid=ipmpr1.id;
                ipmproshare.accesslevel='Edit';
                ipmproshare.UserOrGroupID=cc.IPM_Business_Partner__c;
                lstproshare.add(ipmproshare);
            for(id docid:ProDocid){
            IPM_Project_Document__Share ProDocShr=new IPM_Project_Document__Share();
            ProDocShr.ParentId=docid;
            ProDocShr.UserOrGroupId=cc.IPM_Business_Partner__c;
            ProDocShr.AccessLevel='edit';
            lstProdocshare.add(ProDocShr);
           }
        for(IPM_Project_Document_Section__c prosecs: lstsection){
                IPM_Project_Document_Section__Share ProSec=new IPM_Project_Document_Section__Share ();
                ProSec.ParentId=prosecs.id;
                ProSec.UserOrGroupId=cc.IPM_Business_Partner__c;
                ProSec.AccessLevel='edit';
                lstProDocSec.add(ProSec);
                
        }
        for(IPM_Project_Document_Section_Content__c IPMDoccon:lstProDocContent){
                IPM_Project_Document_Section_Content__Share IpmDocContent=new IPM_Project_Document_Section_Content__Share();
                IpmDocContent.ParentId=IPMDoccon.Id;
                IpmDocContent.UserOrGroupId=cc.IPM_Business_Partner__c;
                IpmDocContent.AccessLevel='Edit';
                lstProDocContentshr.add(IpmDocContent);
        }
        for(IPM_Questionnaire__c Quest:lstQuests){
                IPM_Questionnaire__Share IPMQuestshr=new IPM_Questionnaire__Share();
                IPMQuestshr.ParentId=Quest.id;
                IPMQuestshr.UserOrGroupId=cc.IPM_Business_Partner__c;
                IPMQuestshr.AccessLevel='Edit';
                lstQshare.add(IPMQuestshr);
        } 
            
        for(IPM_User_Profile__c up:lstUProfile){
system.debug('cc.IPM_Managed_Category__c'+cc.IPM_Managed_Category__c+'...'+up.IPM_User_Category__c) ;       
            if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=userinfo.getuserid()){
              IPM_Project__share ipmproshare1=new IPM_Project__share();
              ipmproshare1.parentid=ipmpr1.id;
              ipmproshare1.accesslevel='Read';
              ipmproshare1.UserOrGroupId=up.IPM_User__c;
              lstproshare.add(ipmproshare1);
           
        for(IPM_Milestone__c ipmmiles:lstmiles){
                if(companyNCCid.get(ipmmiles.IPM_Project__c)==cc.id){
                IPM_Milestone__Share BPMilesShr=new IPM_Milestone__Share();
                BPMilesShr.parentId=ipmmiles.id;
                BPMilesShr.accesslevel='Read';
                BPMilesShr.userorgroupid=up.IPM_User__c;
                lstmileshare.add(BPMilesShr);
                }
          }
             }
        }
        }
            
        }
        for(IPM_Milestone__c ipmmiles:lstmiles){
                if(companyNCCid.get(ipmmiles.IPM_Project__c)==cc.id){
                IPM_Milestone__Share BPMilesShr=new IPM_Milestone__Share();
                BPMilesShr.parentId=ipmmiles.id;
                BPMilesShr.accesslevel='Edit';
                BPMilesShr.userorgroupid=cc.IPM_Business_Partner__c;
                lstmileshare.add(BPMilesShr);
                }
        }
         for(IPM_Task__c IPMtsk:IPMTask){
               if(companyNCCid.get(IPMtsk.IPM_Project__c)==cc.id){
                IPM_Task__Share ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=cc.IPM_Business_Partner__c;
                ProTskShare.AccessLevel='edit';
                lsttaskshare.add(ProTskShare);
                }
            }
        for(IPM_Project_Resource__c ipmres:Resourcetoshare){
            if(companyNCCid.get(ipmres.IPM_Project__c)==cc.id){
            IPM_Project_Resource__Share rsShr = new IPM_Project_Resource__Share();
            rsShr.ParentId = ipmres.Id;
            rsShr.UserOrGroupId = cc.IPM_Business_Partner__c;
            rsShr.AccessLevel = 'edit';
            lstresshare.add(rsShr);
            }
        }
      }              
            
    }
if(lstproshare.size()>0){
insert lstproshare;
}
if(lstmileshare.size()>0){
insert lstmileshare;
}
if(lsttaskshare.size()>0){
insert lsttaskshare;
}
if(lstresshare.size()>0){
insert lstresshare;
}
if(lstProdocshare.size()>0){
insert lstProdocshare;
}
if(lstProDocSec.size()>0){
insert lstProDocSec;
}
if(lstProDocContentshr.size()>0){
insert lstProDocContentshr;
}
if(lstQshare.size()>0){
insert lstQshare;
}

} 
  
   if(proId.size()>0){       
    
    list<IPM_Milestone__c>lstmiles=[select id,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Project__c IN:proId];
    list<IPM_Task__c>IPMTask=[select id,IPM_Assignee__c,IPM_Function__c from IPM_Task__c where IPM_Project__c IN:proId];
   // IPM_Project__c IPMPro=[select Deputy_Project_Leader__c,IPM_Project_Leader__c,IPM_Technical_Project_Leader__c,IPM_Project_Gatekeeper__c from IPM_Project__c where id IN:proId];
    list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c  where IPM_Project__c IN:proId ] ;
    list<IPM_Project_Document__c> ProDocs= [SELECT IPM_Project__c FROM IPM_Project_Document__c where IPM_Project__c IN:proId];
    set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:proId])).keyset();
    list<IPM_Project_Document_Section__c>lstsection =[select id,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c IN:ProDocid ];
    set<id>Sectionid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:proId])).keyset();
    list<IPM_Project_Document_Section_Content__c>lstProDocContent=[select IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:Sectionid];
    map<id,string>sectionmap=new map<id,string>(); 
    list<IPM_Questionnaire__c>lstQuests=[select id from IPM_Questionnaire__c where IPM_Project__c IN:ProId];
    Boolean isUserChanged;  

    
  for(IPM_Project__c ipmproject:newproject.values()){
      string PLid='';
      string DPLid='';
      string TPLid='';
      string Gatekid='';
      
      
      if(ipmproject.IPM_Project_Leader__c!=oldproject.get(ipmproject.id).IPM_Project_Leader__c && ipmproject.IPM_Project_Leader__c!=null && ipmproject.OwnerId !=ipmproject.IPM_Project_Leader__c){
      if(oldproject.get(ipmproject.id).IPM_Project_Leader__c!=ipmproject.IPM_Project_Leader__c)
      isUserChanged=true;
      ChangedUserid.add(oldproject.get(ipmproject.id).IPM_Project_Leader__c);
     // isUserChanged=true;
      ipmProshr=new IPM_Project__Share();
      PLid=ipmproject.IPM_Project_Leader__c;
      ipmProshr.parentId=ipmproject.id;
      ipmProshr.accesslevel='edit';
      ipmProshr.userorgroupid=ipmproject.IPM_Project_Leader__c;
      
      ProjectShrs.add(ipmProshr);
      if(ipmproject.IPM_Bosscard__c !=null){
      Bossshare=new IPM_Bosscard__Share();
      Bossshare.parentid=ipmproject.IPM_Bosscard__c;
      Bossshare.accesslevel='edit';
      Bossshare.userorgroupid=ipmproject.IPM_Project_Leader__c;
      IpmBossShare.add(Bossshare);
      }
      }
      if(ipmproject.IPM_Project_Leader__c!=ipmproject.Deputy_Project_Leader__c && ipmproject.Deputy_Project_Leader__c!=oldproject.get(ipmproject.id).Deputy_Project_Leader__c && ipmproject.Deputy_Project_Leader__c!=null){
      if(oldproject.get(ipmproject.id).Deputy_Project_Leader__c !=ipmproject.IPM_Project_Leader__c)
      isUserChanged=true;
      ChangedUserid.add(oldproject.get(ipmproject.id).Deputy_Project_Leader__c );
      //isUserChanged=true;
      ipmProshr=new IPM_Project__Share();
      DPLid=ipmproject.Deputy_Project_Leader__c;
      ipmProshr.parentId=ipmproject.id;
      ipmProshr.accesslevel='edit';
      ipmProshr.userorgroupid=ipmproject.Deputy_Project_Leader__c;
      ProjectShrs.add(ipmProshr);
      if(ipmproject.IPM_Bosscard__c !=null){
      Bossshare=new IPM_Bosscard__Share();
      Bossshare.parentid=ipmproject.IPM_Bosscard__c;
      Bossshare.accesslevel='edit';
      Bossshare.userorgroupid=ipmproject.Deputy_Project_Leader__c;
      IpmBossShare.add(Bossshare);
      }
      }
      if(ipmproject.IPM_Project_Leader__c!=ipmproject.IPM_Technical_Project_Leader__c && ipmproject.IPM_Technical_Project_Leader__c!=oldproject.get(ipmproject.id).IPM_Technical_Project_Leader__c && ipmproject.IPM_Technical_Project_Leader__c!=null){
      if(oldproject.get(ipmproject.id).IPM_Technical_Project_Leader__c !=ipmproject.IPM_Project_Leader__c)
      isUserChanged=true;
      ChangedUserid.add(oldproject.get(ipmproject.id).IPM_Technical_Project_Leader__c );
      ipmProshr=new IPM_Project__Share();
      TPLid=ipmproject.IPM_Technical_Project_Leader__c;
      ipmProshr.parentId=ipmproject.id;
      ipmProshr.accesslevel='edit';
      ipmProshr.userorgroupid=ipmproject.IPM_Technical_Project_Leader__c;
      ProjectShrs.add(ipmProshr);
      if(ipmproject.IPM_Bosscard__c !=null){
      Bossshare=new IPM_Bosscard__Share();
      Bossshare.parentid=ipmproject.IPM_Bosscard__c;
      Bossshare.accesslevel='edit';
      Bossshare.userorgroupid=ipmproject.IPM_Technical_Project_Leader__c;
      IpmBossShare.add(Bossshare);
      }
      }
      if(ipmproject.IPM_Project_Leader__c!=ipmproject.IPM_Project_Gatekeeper__c && ipmproject.IPM_Project_Gatekeeper__c!=oldproject.get(ipmproject.id).IPM_Project_Gatekeeper__c && ipmproject.IPM_Project_Gatekeeper__c!=null){
      if(oldproject.get(ipmproject.id).IPM_Project_Gatekeeper__c !=ipmproject.IPM_Project_Leader__c)
      isUserChanged=true;
      ChangedUserid.add(oldproject.get(ipmproject.id).IPM_Project_Gatekeeper__c);
     
      ipmProshr=new IPM_Project__Share();
      Gatekid=ipmproject.IPM_Project_Gatekeeper__c;
      ipmProshr.parentId=ipmproject.id;
      ipmProshr.accesslevel='read';
      ipmProshr.userorgroupid=ipmproject.IPM_Project_Gatekeeper__c;
      ProjectShrs.add(ipmProshr);
      if(ipmproject.IPM_Bosscard__c !=null){
      Bossshare=new IPM_Bosscard__Share();
      Bossshare.parentid=ipmproject.IPM_Bosscard__c;
      Bossshare.accesslevel='Edit';
      Bossshare.userorgroupid=ipmproject.IPM_Project_Gatekeeper__c;
      IpmBossShare.add(Bossshare);
      }
      }
      system.debug('ids.......'+PLid+DPLid+TPLid+Gatekid);
     if(PLid !='' || DPLid !='' || TPLid !='' || Gatekid !=''){ 
     if(lstmiles.size()>0) {
             //Share milestone records
               for(IPM_Milestone__c ipmmiles:lstmiles){
                PLIpmMilesShr=new IPM_Milestone__Share();
                DPLIpmMilesShr=new IPM_Milestone__Share();
                TPLIpmMilesShr=new IPM_Milestone__Share();
                GatepmMilesShr=new IPM_Milestone__Share();
                if(PLid !=''){
                PLIpmMilesShr.parentid=ipmmiles.id;
                PLIpmMilesShr.UserOrGroupId=PLid;
                if(ipmmiles.IPM_Type_of_Milestone__c=='Standard'){
                PLIpmMilesShr.AccessLevel='Edit';
                }
                if(ipmmiles.IPM_Type_of_Milestone__c==null ){
                  PLIpmMilesShr.AccessLevel='Edit';
                }
                ProMiles.add(PLIpmMilesShr);
               }
               
                if(DPLid !=''){
                DPLIpmMilesShr.parentid=ipmmiles.id;
                DPLIpmMilesShr.UserOrGroupId=DPLid;
                if(ipmmiles.IPM_Type_of_Milestone__c=='Standard'){
                DPLIpmMilesShr.AccessLevel='Edit';
                }
                if(ipmmiles.IPM_Type_of_Milestone__c==null ){
                  DPLIpmMilesShr.AccessLevel='Edit';
                }
                ProMiles.add(DPLIpmMilesShr);
               } 
               if(TPLid !=''){
                TPLIpmMilesShr.parentid=ipmmiles.id;
                TPLIpmMilesShr.UserOrGroupId=TPLid;
                if(ipmmiles.IPM_Type_of_Milestone__c=='Standard'){
                TPLIpmMilesShr.AccessLevel='Edit';
                }
                if(ipmmiles.IPM_Type_of_Milestone__c==null ){
                  TPLIpmMilesShr.AccessLevel='Edit';
                }
                ProMiles.add(TPLIpmMilesShr);
               } 
                if(Gatekid !=''){
                GatepmMilesShr.parentid=ipmmiles.id;
                GatepmMilesShr.UserOrGroupId=Gatekid;
                if(ipmmiles.IPM_Type_of_Milestone__c=='Standard'){
                GatepmMilesShr.AccessLevel='Edit';
                }
                if(ipmmiles.IPM_Type_of_Milestone__c==null ){
                  GatepmMilesShr.AccessLevel='Edit';
                }
                ProMiles.add(GatepmMilesShr);
               }       
                          
             }
            } 
            
         if(IPMTask.size()>0){
             //Share task records
                for(IPM_Task__c IPMtsk:IPMTask){
                if(PLid !=''){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=PLid;
                ProTskShare.AccessLevel='edit';
                ProTaskShare.add(ProTskShare);
                }
                
                if(DPLid !=''){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=DPLid;
                ProTskShare.AccessLevel='edit';
                ProTaskShare.add(ProTskShare);
                }
                if(TPLid !=''){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=TPLid;
                ProTskShare.AccessLevel='edit';
                ProTaskShare.add(ProTskShare);
                }
             }
         }   
      if(Resourcetoshare.size()>0){
          //Share team member records
          for(IPM_Project_Resource__c ProRes:Resourcetoshare){
          
           if(Plid !=''){
            rsShr1 = new IPM_Project_Resource__Share();
            rsShr1.ParentId = ProRes.Id;
            rsShr1.UserOrGroupId = Plid;
            rsShr1.AccessLevel = 'edit';
            ProResShrs.add(rsShr1);
           }
           if(DPlid !=''){
            rsShr1 = new IPM_Project_Resource__Share();
            rsShr1.ParentId = ProRes.Id;
            rsShr1.UserOrGroupId = DPlid;
            rsShr1.AccessLevel = 'edit';
            ProResShrs.add(rsShr1);
           }
           if(TPlid !=''){
            rsShr1 = new IPM_Project_Resource__Share();
            rsShr1.ParentId = ProRes.Id;
            rsShr1.UserOrGroupId = TPlid;
            rsShr1.AccessLevel = 'edit';
            ProResShrs.add(rsShr1);
           }
           if(Gatekid !=''){
            rsShr1 = new IPM_Project_Resource__Share();
            rsShr1.ParentId = ProRes.Id;
            rsShr1.UserOrGroupId = Gatekid;
            rsShr1.AccessLevel = 'read';
            ProResShrs.add(rsShr1);
           }
          }
        }
      //share gate document share
      for(id docid:ProDocid){
           if(Plid !=''){    
            ProDocShr=new IPM_Project_Document__Share();
            ProDocShr.ParentId=docid;
            ProDocShr.UserOrGroupId=Plid;
            ProDocShr.AccessLevel='edit';
            ProDocuments.add(ProDocShr);
           }
           if(DPlid !=''){    
            ProDocShr=new IPM_Project_Document__Share();
            ProDocShr.ParentId=docid;
            ProDocShr.UserOrGroupId=DPlid;
            ProDocShr.AccessLevel='edit';
            ProDocuments.add(ProDocShr);
           }
           if(TPlid !=''){    
            ProDocShr=new IPM_Project_Document__Share();
            ProDocShr.ParentId=docid;
            ProDocShr.UserOrGroupId=TPlid;
            ProDocShr.AccessLevel='edit';
            ProDocuments.add(ProDocShr);
           }
           if(Gatekid !=''){    
            ProDocShr=new IPM_Project_Document__Share();
            ProDocShr.ParentId=docid;
            ProDocShr.UserOrGroupId=Gatekid;
            ProDocShr.AccessLevel='edit';
            ProDocuments.add(ProDocShr);
           }
        }
      //Share gate document section
      if(lstsection.size()>0){

                for(IPM_Project_Document_Section__c prosecs: lstsection){
                sectionmap.put(prosecs.id,prosecs.IPM_FunctionalRole__c);
                if(Plid !=''){
                ProSec=new IPM_Project_Document_Section__Share ();
                ProSec.ParentId=prosecs.id;
                ProSec.UserOrGroupId=Plid;
                ProSec.AccessLevel='edit';
                ProDocSec.add(ProSec);
                }
                if(TPLid !=''){
                ProSec=new IPM_Project_Document_Section__Share ();
                
                ProSec.ParentId=prosecs.id;
                ProSec.UserOrGroupId=TPlid;
                ProSec.AccessLevel='edit';
                ProDocSec.add(ProSec);
                }
                if(DPlid !=''){
                ProSec=new IPM_Project_Document_Section__Share ();
                ProSec.ParentId=prosecs.id;
                ProSec.UserOrGroupId=DPlid;
                ProSec.AccessLevel='edit';
                ProDocSec.add(ProSec);
                }
                if(Gatekid !=''){
                ProSec=new IPM_Project_Document_Section__Share ();
                ProSec.ParentId=prosecs.id;
                ProSec.UserOrGroupId=Gatekid;
                ProSec.AccessLevel='read';
                ProDocSec.add(ProSec);
                }
              }
            } 
         //share content records
         
         if(lstProDocContent.size()>0){
           
           for(IPM_Project_Document_Section_Content__c IPMDoccon:lstProDocContent){
                if(Plid !=''){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share();
                IpmDocContent.ParentId=IPMDoccon.Id;
                IpmDocContent.UserOrGroupId=Plid;
                IpmDocContent.AccessLevel='Edit';
                ProDocContent.add(IpmDocContent);
                }
                if(DPlid !=''){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share();
                IpmDocContent.ParentId=IPMDoccon.Id;
                IpmDocContent.UserOrGroupId=DPlid;
                IpmDocContent.AccessLevel='Edit';
                ProDocContent.add(IpmDocContent);
                }
                if(TPlid !=''){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share();
                IpmDocContent.ParentId=IPMDoccon.Id;
                IpmDocContent.UserOrGroupId=TPlid;
                IpmDocContent.AccessLevel='Edit';
                ProDocContent.add(IpmDocContent);
                }
                if(GateKid !=''){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share();
                IpmDocContent.ParentId=IPMDoccon.Id;
                IpmDocContent.UserOrGroupId=Plid;
                IpmDocContent.AccessLevel='Read';
                ProDocContent.add(IpmDocContent);
                }
             }
           } 
         //Share Questionnaire records
         
         if(lstQuests.size()>0){
           
               
                for(IPM_Questionnaire__c Quest:lstQuests){
                    if(PLid !=''){
                    IPMQuestshr=new IPM_Questionnaire__Share();
                    IPMQuestshr.ParentId=Quest.id;
                    IPMQuestshr.UserOrGroupId=PLid;
                    IPMQuestshr.AccessLevel='Edit';
                    IpmQuests.add(IPMQuestshr);
                    }
                    if(DPLid !=''){
                    IPMQuestshr=new IPM_Questionnaire__Share();
                    IPMQuestshr.ParentId=Quest.id;
                    IPMQuestshr.UserOrGroupId=DPLid;
                    IPMQuestshr.AccessLevel='Edit';
                    IpmQuests.add(IPMQuestshr);
                    }
                    if(TPLid !=''){
                    IPMQuestshr=new IPM_Questionnaire__Share();
                    IPMQuestshr.ParentId=Quest.id;
                    IPMQuestshr.UserOrGroupId=TPLid;
                    IPMQuestshr.AccessLevel='Edit';
                    IpmQuests.add(IPMQuestshr);
                    }
                    if(Gatekid !=''){
                    IPMQuestshr=new IPM_Questionnaire__Share();
                    IPMQuestshr.ParentId=Quest.id;
                    IPMQuestshr.UserOrGroupId=Gatekid;
                    IPMQuestshr.AccessLevel='read';
                    IpmQuests.add(IPMQuestshr);
                    }
                }
           }
        //    
      
      }
  }  
        
   if( isUserChanged==true){
    List<IPM_Project_Resource__Share> ProResShrs1  = new List<IPM_Project_Resource__Share>();
    List<IPM_Project__Share> ProjectShrs1  = new List<IPM_Project__Share>();
    List<IPM_Project_Document__Share>ProDocuments1=new list<IPM_Project_Document__Share>();
    List<IPM_Task__Share>ProTaskShare1=new list<IPM_Task__Share>();
    List<IPM_Project_Document_Section__Share>ProDocSec1=new list<IPM_Project_Document_Section__Share>();
    List<IPM_Milestone__Share>mileshare1=new list<IPM_Milestone__Share>();
    List<IPM_Bosscard__Share>IpmBossShare1=new list<IPM_Bosscard__Share>();
    
   
    ProResShrs1  = new List<IPM_Project_Resource__Share>();
    ProjectShrs1  = new List<IPM_Project__Share>();
    ProDocuments1=new list<IPM_Project_Document__Share>();
    ProTaskShare1=new list<IPM_Task__Share>();
    ProDocSec1=new list<IPM_Project_Document_Section__Share>();
    mileshare1=new list<IPM_Milestone__Share>();
    
    set<id>ResId=new set<id>();
    set<id>Bossid=new set<id>();
    
    ResId=(new map<id,IPM_Project_Resource__c>([Select id from IPM_Project_Resource__c where IPM_Project__c IN:proId])).keyset();
    set<id>ProDocid1=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:proId])).keyset();
    set<id>ProDocSecid1=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:proId])).keyset();
    set<id>Tskid=(new map<id,IPM_Task__c>([Select id from IPM_Task__c where IPM_Project__c IN:proId])).keyset();
    set<id>Milesid=(new map<id,IPM_Milestone__c>([Select id from IPM_Milestone__c where IPM_Project__c IN:proId])).keyset();
    Bossid=(new map<id,IPM_Project__c>([Select IPM_Bosscard__c from IPM_Project__c where id IN:proId])).keyset();
    ProResShrs1=[select id from IPM_Project_Resource__Share where ParentId IN:ResId and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    ProjectShrs1=[select id from IPM_Project__Share where ParentId IN:proId and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    ProDocuments1=[select id from IPM_Project_Document__Share where ParentId IN:ProDocid1 and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    ProTaskShare1=[select id from IPM_Task__Share where ParentId IN:Tskid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    ProDocSec1=[select id from IPM_Project_Document_Section__Share where ParentId IN:ProDocSecid1 and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    mileshare1=[select id from IPM_Milestone__Share where ParentId IN:Milesid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    IpmBossShare1=[select id from IPM_Bosscard__Share where ParentId IN:Bossid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    
    if(ProResShrs1.size()>0)
    delete ProResShrs1;
    if(ProjectShrs1.size()>0)
    delete ProjectShrs1;
    if(ProDocuments1.size()>0)
    delete ProDocuments1;
    if(ProTaskShare1.size()>0)
    delete ProTaskShare1;
    if(ProDocSec1.size()>0)
    delete ProDocSec1;
    if(mileshare1.size()>0)
    delete mileshare1;
    if(IpmBossShare1.size()>0)
    delete IpmBossShare1;
    }
            
        if(ProjectShrs.size()>0)
        insert ProjectShrs;
        if(ProResShrs.size()>0)
        insert ProResShrs;
        if(ProDocuments.size()>0)
        insert ProDocuments;
        if(ProDocSec.size()>0)
        upsert ProDocSec;
        if(ProTaskShare.size()>0)
        insert ProTaskShare;
        if(ProDocContent.size()>0)
        insert ProDocContent;
        if(ProMiles.size()>0)
        insert ProMiles;
        if(IpmBossShare.size()>0)
        insert IpmBossShare;
       // if(IpmQuests.size()>0)
       // insert IpmQuests;
}
}
public void SharerecordswithRPL(map<id,IPM_Project__c>Newproject,map<id,IPM_Project__c>oldproject){
     List<IPM_Project__Share> ProjShare  = new List<IPM_Project__Share>();
     IPM_Project__Share shareproject=new IPM_Project__Share();
     List<IPM_Project_Document__Share>ProDocuments=new list<IPM_Project_Document__Share>();
     IPM_Project_Document__Share ProDocShr=new IPM_Project_Document__Share();
     List<IPM_Project_Document_Section__Share>ProDocSec=new list<IPM_Project_Document_Section__share>();
     IPM_Project_Document_Section__share ProDocSecShr=new IPM_Project_Document_Section__share();
     set<id>lstprojectids=new set<id>();
     system.debug('Newproject.values()....'+Newproject.values());
     for(IPM_Project__c proval:Newproject.values()){
        // if(proval.IPM_Clustering__c!=null){
             lstprojectids.add(proval.id);
             SYSTEM.DEBUG('lstprojectids......'+lstprojectids);
         // }
     }
   if(lstprojectids.size()>0){
       list<IPM_Project__c>lstproject=[select id,IPM_Company_Card__c,IPM_Parent_Project__r.IPM_Company_Card__c,IPM_Project_Leader__c,IPM_Parent_Project__c from IPM_Project__c where id IN:lstprojectids];
       list<IPM_Company_Card__c>lstcc=new list<IPM_Company_Card__c>();
       list<IPM_User_Profile__c>lstUProfile=new list<IPM_User_Profile__c>();
       if(lstproject.size()>0){
       if(lstproject[0].IPM_Company_Card__c!=null){
           lstcc=[select IPM_Business_Partner__c,IPM_Managed_Category__c from IPM_Company_Card__c where id =:lstproject[0].IPM_Parent_Project__r.IPM_Company_Card__c];
           lstUProfile=[Select IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c from IPM_User_Profile__c where IPM_Work_Level__c='WL2+' and IPM_Company_Card__c=:lstproject[0].IPM_Company_Card__c];
       }
      }
   for(IPM_Project__c prolst:lstproject){
        if(prolst.IPM_Parent_Project__c!=null){
        if(prolst.IPM_Project_Leader__c!=null && prolst.IPM_Project_Leader__c!=userinfo.getuserId())
        {
        shareproject=new IPM_Project__Share();
        shareproject.parentid=prolst.id;
        shareproject.userorgroupid=prolst.IPM_Project_Leader__c;
        shareproject.accesslevel='Edit';
        ProjShare.add(shareproject);
       
        shareproject=new IPM_Project__Share();
        shareproject.parentid=prolst.IPM_Parent_Project__c ;
        shareproject.userorgroupid=prolst.IPM_Project_Leader__c;
        shareproject.accesslevel='read';
        ProjShare.add(shareproject);
        }
        for(IPM_Company_Card__c cc:lstcc){
            if(cc.IPM_Business_Partner__c !=null){
            IPM_Project__share ipmproshare=new IPM_Project__share();
            ipmproshare.parentid=prolst.id;
            ipmproshare.accesslevel='Edit';
            ipmproshare.UserOrGroupID=cc.IPM_Business_Partner__c;
            ProjShare.add(ipmproshare);
            }
         
        }       
      /* if(prolst.IPM_Company_Card__c!=null){
        if(prolst.IPM_Business_Partner_User_Name__c!=null){
        shareproject=new IPM_Project__Share();
        shareproject.parentid=prolst.IPM_Parent_Project__c ;
        shareproject.userorgroupid=prolst.IPM_Business_Partner_User_Name__c;
        shareproject.accesslevel='read';
        ProjShare.add(shareproject);
        }
        }*/
      
       for(IPM_Company_Card__c cc:lstcc){
        for(IPM_User_Profile__c up:lstUProfile){
            if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=userinfo.getuserid() && prolst.IPM_Project_Leader__c!=up.IPM_User__c){
            IPM_Project__share ipmproshare=new IPM_Project__share();
            ipmproshare.parentid=prolst.id;
            ipmproshare.accesslevel='read';
            ipmproshare.UserOrGroupID=up.IPM_User__c;
            ProjShare.add(ipmproshare);
            }
        }
      }
    }
   }
  
  if(ProjShare.size()>0){
  System.debug(ProjShare+'ProjShare');
      insert ProjShare;
  }

  }
}
//share Regional project records with local project member on update of local project
public void ShareWithLocalMember(map<id,IPM_Project__c>Newproject,map<id,IPM_Project__c>oldproject){
    ProResShrs  = new List<IPM_Project_Resource__Share>();
    ProjectShrs  = new List<IPM_Project__Share>();
    ProDocuments=new list<IPM_Project_Document__Share>();
    ProTaskShare=new list<IPM_Task__Share>();
    ProDocSec=new list<IPM_Project_Document_Section__Share>();
    ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
    ProMiles=new list<IPM_Milestone__Share>();
    IpmQuests=new list<IPM_Questionnaire__Share>();
    IpmBossShare=new list<IPM_Bosscard__Share>();
    lstProRollShr=new list<IPM_Project_Rollout__Share>();
    lstFinShr=new list<IPM_Financial__Share>();
    set<id>changeduser=new set<id>();
    boolean isUserChanged=false;
    for(IPM_Project__c ipmproid:Newproject.values()){
        if(ipmproid.IPM_Project_Leader__c!=oldproject.get(ipmproid.id).IPM_Project_Leader__c && ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.IPM_Project_Leader__c!=null && ipmproid.OwnerId !=ipmproid.IPM_Project_Leader__c){
         proId.add(ipmproid.IPM_Parent_Project__c);
         changeduser.add(oldproject.get(ipmproid.id).IPM_Project_Leader__c);
         isUserChanged=true;
         }
         if(ipmproid.IPM_Project_Leader__c!=ipmproid.Deputy_Project_Leader__c && ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.Deputy_Project_Leader__c!=oldproject.get(ipmproid.id).Deputy_Project_Leader__c && ipmproid.Deputy_Project_Leader__c!=null){
           proId.add(ipmproid.IPM_Parent_Project__c);
           changeduser.add(oldproject.get(ipmproid.id).Deputy_Project_Leader__c);
           isUserChanged=true;
         }
         if(ipmproid.IPM_Project_Leader__c!=ipmproid.IPM_Technical_Project_Leader__c && ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.IPM_Technical_Project_Leader__c!=oldproject.get(ipmproid.id).IPM_Technical_Project_Leader__c && ipmproid.IPM_Technical_Project_Leader__c!=null){
          proId.add(ipmproid.IPM_Parent_Project__c);
          changeduser.add(oldproject.get(ipmproid.id).IPM_Technical_Project_Leader__c);
          isUserChanged=true;
         }
         if(ipmproid.IPM_Project_Leader__c!=ipmproid.IPM_Project_Gatekeeper__c && ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.IPM_Project_Gatekeeper__c!=oldproject.get(ipmproid.id).IPM_Project_Gatekeeper__c && ipmproid.IPM_Project_Gatekeeper__c!=null){
          proId.add(ipmproid.IPM_Parent_Project__c);
          changeduser.add(oldproject.get(ipmproid.id).IPM_Project_Gatekeeper__c);
          isUserChanged=true;
        }  
     } 
    IPM_Milestone__Share IpmMilesShr;
    IPM_Questionnaire__Share IPMQuestshr;    
    if(proId.size()>0){
        set<id>SetRegionalproject=(new map<id,IPM_Project__c>([select id from IPM_Project__c where id IN:proId])).keyset();
        list<IPM_Milestone__c>lstmiles=[select id,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Task__c>IPMTask=[select id,IPM_Assignee__c,IPM_Function__c from IPM_Task__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c  where IPM_Project__c IN:proId ] ;
        list<IPM_Project_Document__c> ProDocs= [SELECT IPM_Project__c FROM IPM_Project_Document__c where IPM_Project__c IN:SetRegionalproject];
        set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:SetRegionalproject])).keyset();
        list<IPM_Project_Document_Section__c>lstsection =[select id,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c IN:ProDocid ];
        set<id>Sectionid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:SetRegionalproject])).keyset();
        list<IPM_Project_Document_Section_Content__c>lstProDocContent=[select IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:Sectionid];
        list<IPM_Questionnaire__c>lstQuests=[select id from IPM_Questionnaire__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Project_Rollout__c>lstRollOut=[select id from IPM_Project_Rollout__c where Regional_Project__c IN:proId];
        list<IPM_Financial__c>lstFinancial=[select id from IPM_Financial__c where Regional_Project__c IN:proId];
       for (IPM_Project__c ipmproid:Newproject.values()){
        if(ipmproid.IPM_Project_Leader__c!=oldproject.get(ipmproid.id).IPM_Project_Leader__c && ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.IPM_Project_Leader__c!=null && ipmproid.OwnerId !=ipmproid.IPM_Project_Leader__c){
           for(id projID:SetRegionalproject){
                ipmProshr=new IPM_Project__Share();
                ipmProshr.accesslevel='Read';
                ipmProshr.parentId=projID;
                ipmProshr.userorgroupid=ipmproid.IPM_Project_Leader__c;
                ProjectShrs.add(ipmProshr);
            }
            for(IPM_Milestone__c ipmmiles:lstmiles){
                IpmMilesShr=new IPM_Milestone__Share();
                IpmMilesShr.accesslevel='Read';
                IpmMilesShr.userorgroupid=ipmproid.IPM_Project_Leader__c;
                IpmMilesShr.parentId=ipmmiles.id;
                ProMiles.add(IpmMilesShr);
            }
            for(IPM_Task__c IPMtsk:IPMTask){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=ipmproid.IPM_Project_Leader__c;
                ProTskShare.AccessLevel='read';
                ProTaskShare.add(ProTskShare);
            }
            for(IPM_Project_Resource__c ProRes:Resourcetoshare){
                IPM_Project_Resource__Share rsShr1 = new IPM_Project_Resource__Share();
                rsShr1.ParentId = ProRes.Id;
                rsShr1.UserOrGroupId = ipmproid.IPM_Project_Leader__c;
                rsShr1.AccessLevel = 'read';
                ProResShrs.add(rsShr1);
            }
            for(id prodoc:ProDocid){
                ProDocShr=new IPM_Project_Document__Share();
                ProDocShr.parentId=prodoc;
                ProDocShr.accesslevel='Read';
                ProDocShr.userorgroupid=ipmproid.IPM_Project_Leader__c;
                ProDocuments.add(ProDocShr);
            }
            for(id secid:Sectionid){
                ProSec=new IPM_Project_Document_Section__Share();
                ProSec.parentId=secid;
                ProSec.accesslevel='Read';
                ProSec.userorgroupid=ipmproid.IPM_Project_Leader__c;
                ProDocSec.add(ProSec);
            }
            for(IPM_Project_Document_Section_Content__c secCont:lstProDocContent){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share ();
                IpmDocContent.accesslevel='Read';
                IpmDocContent.userorgroupid=ipmproid.IPM_Project_Leader__c;
                IpmDocContent.parentId=secCont.id;
                ProDocContent.add(IpmDocContent);
            }
            for(IPM_Project_Rollout__c rollPro:lstRollOut){
                IPM_Project_Rollout__share RolloutShare=new IPM_Project_Rollout__share();
                RolloutShare.accesslevel='Read';
                RolloutShare.userorgroupid=ipmproid.IPM_Project_Leader__c;
                RolloutShare.parentId=rollPro.id;
                lstProRollShr.add(RolloutShare);
            }
            for(IPM_Financial__c fin:lstFinancial){
                IPM_Financial__share FinShare=new IPM_Financial__share();
                FinShare.accesslevel='Read';
                FinShare.userorgroupid=ipmproid.IPM_Project_Leader__c;
                FinShare.parentId=fin.id;
                lstFinShr.add(FinShare);
            }
        }
        if(ipmproid.IPM_Project_Leader__c!=ipmproid.Deputy_Project_Leader__c && ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.Deputy_Project_Leader__c!=oldproject.get(ipmproid.id).Deputy_Project_Leader__c && ipmproid.Deputy_Project_Leader__c!=null){
           for(id projID:SetRegionalproject){
                ipmProshr=new IPM_Project__Share();
                ipmProshr.accesslevel='Read';
                ipmProshr.parentId=projID;
                ipmProshr.userorgroupid=ipmproid.Deputy_Project_Leader__c;
                ProjectShrs.add(ipmProshr);
            }
            for(IPM_Milestone__c ipmmiles:lstmiles){
                IpmMilesShr=new IPM_Milestone__Share();
                IpmMilesShr.accesslevel='Read';
                IpmMilesShr.userorgroupid=ipmproid.Deputy_Project_Leader__c;
                IpmMilesShr.parentId=ipmmiles.id;
                ProMiles.add(IpmMilesShr);
            }
            for(IPM_Task__c IPMtsk:IPMTask){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=ipmproid.Deputy_Project_Leader__c;
                ProTskShare.AccessLevel='read';
                ProTaskShare.add(ProTskShare);
            }
            for(IPM_Project_Resource__c ProRes:Resourcetoshare){
                IPM_Project_Resource__Share rsShr1 = new IPM_Project_Resource__Share();
                rsShr1.ParentId = ProRes.Id;
                rsShr1.UserOrGroupId = ipmproid.Deputy_Project_Leader__c;
                rsShr1.AccessLevel = 'read';
                ProResShrs.add(rsShr1);
            }
            for(id prodoc:ProDocid){
                ProDocShr=new IPM_Project_Document__Share();
                ProDocShr.parentId=prodoc;
                ProDocShr.accesslevel='Read';
                ProDocShr.userorgroupid=ipmproid.Deputy_Project_Leader__c;
                ProDocuments.add(ProDocShr);
            }
            for(id secid:Sectionid){
                ProSec=new IPM_Project_Document_Section__Share();
                ProSec.parentId=secid;
                ProSec.accesslevel='Read';
                ProSec.userorgroupid=ipmproid.Deputy_Project_Leader__c;
                ProDocSec.add(ProSec);
            }
            for(IPM_Project_Document_Section_Content__c secCont:lstProDocContent){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share ();
                IpmDocContent.accesslevel='Read';
                IpmDocContent.userorgroupid=ipmproid.Deputy_Project_Leader__c;
                IpmDocContent.parentId=secCont.id;
                ProDocContent.add(IpmDocContent);
            }
            for(IPM_Project_Rollout__c rollPro:lstRollOut){
                IPM_Project_Rollout__share RolloutShare=new IPM_Project_Rollout__share();
                RolloutShare.accesslevel='Read';
                RolloutShare.userorgroupid=ipmproid.Deputy_Project_Leader__c;
                RolloutShare.parentId=rollPro.id;
                lstProRollShr.add(RolloutShare);
            }
            for(IPM_Financial__c fin:lstFinancial){
                IPM_Financial__share FinShare=new IPM_Financial__share();
                FinShare.accesslevel='Read';
                FinShare.userorgroupid=ipmproid.Deputy_Project_Leader__c;
                FinShare.parentId=fin.id;
                lstFinShr.add(FinShare);
            }
        }
        if(ipmproid.IPM_Project_Leader__c!=ipmproid.IPM_Technical_Project_Leader__c && ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.IPM_Technical_Project_Leader__c!=oldproject.get(ipmproid.id).IPM_Technical_Project_Leader__c && ipmproid.IPM_Technical_Project_Leader__c!=null){
           for(id projID:SetRegionalproject){
                ipmProshr=new IPM_Project__Share();
                ipmProshr.accesslevel='Read';
                ipmProshr.parentId=projID;
                ipmProshr.userorgroupid=ipmproid.IPM_Technical_Project_Leader__c;
                ProjectShrs.add(ipmProshr);
            }
            for(IPM_Milestone__c ipmmiles:lstmiles){
                IpmMilesShr=new IPM_Milestone__Share();
                IpmMilesShr.accesslevel='Read';
                IpmMilesShr.userorgroupid=ipmproid.IPM_Technical_Project_Leader__c;
                IpmMilesShr.parentId=ipmmiles.id;
                ProMiles.add(IpmMilesShr);
            }
            for(IPM_Task__c IPMtsk:IPMTask){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=ipmproid.IPM_Technical_Project_Leader__c;
                ProTskShare.AccessLevel='read';
                ProTaskShare.add(ProTskShare);
            }
            for(IPM_Project_Resource__c ProRes:Resourcetoshare){
                IPM_Project_Resource__Share rsShr1 = new IPM_Project_Resource__Share();
                rsShr1.ParentId = ProRes.Id;
                rsShr1.UserOrGroupId = ipmproid.IPM_Technical_Project_Leader__c;
                rsShr1.AccessLevel = 'read';
                ProResShrs.add(rsShr1);
            }
            for(id prodoc:ProDocid){
                ProDocShr=new IPM_Project_Document__Share();
                ProDocShr.parentId=prodoc;
                ProDocShr.accesslevel='Read';
                ProDocShr.userorgroupid=ipmproid.IPM_Technical_Project_Leader__c;
                ProDocuments.add(ProDocShr);
            }
            for(id secid:Sectionid){
                ProSec=new IPM_Project_Document_Section__Share();
                ProSec.parentId=secid;
                ProSec.accesslevel='Read';
                ProSec.userorgroupid=ipmproid.IPM_Technical_Project_Leader__c;
                ProDocSec.add(ProSec);
            }
            for(IPM_Project_Document_Section_Content__c secCont:lstProDocContent){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share ();
                IpmDocContent.accesslevel='Read';
                IpmDocContent.userorgroupid=ipmproid.IPM_Technical_Project_Leader__c;
                IpmDocContent.parentId=secCont.id;
                ProDocContent.add(IpmDocContent);
            }
            for(IPM_Project_Rollout__c rollPro:lstRollOut){
                IPM_Project_Rollout__share RolloutShare=new IPM_Project_Rollout__share();
                RolloutShare.accesslevel='Read';
                RolloutShare.userorgroupid=ipmproid.IPM_Technical_Project_Leader__c;
                RolloutShare.parentId=rollPro.id;
                lstProRollShr.add(RolloutShare);
            }
            for(IPM_Financial__c fin:lstFinancial){
                IPM_Financial__share FinShare=new IPM_Financial__share();
                FinShare.accesslevel='Read';
                FinShare.userorgroupid=ipmproid.IPM_Technical_Project_Leader__c;
                FinShare.parentId=fin.id;
                lstFinShr.add(FinShare);
            }
        }
        if(ipmproid.IPM_Project_Leader__c!=ipmproid.IPM_Project_Gatekeeper__c && ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.IPM_Project_Gatekeeper__c!=oldproject.get(ipmproid.id).IPM_Project_Gatekeeper__c && ipmproid.IPM_Project_Gatekeeper__c!=null){
           for(id projID:SetRegionalproject){
                ipmProshr=new IPM_Project__Share();
                ipmProshr.accesslevel='Read';
                ipmProshr.parentId=projID;
                ipmProshr.userorgroupid=ipmproid.IPM_Project_Gatekeeper__c;
                ProjectShrs.add(ipmProshr);
            }
            for(IPM_Milestone__c ipmmiles:lstmiles){
                IpmMilesShr=new IPM_Milestone__Share();
                IpmMilesShr.accesslevel='Read';
                IpmMilesShr.userorgroupid=ipmproid.IPM_Project_Gatekeeper__c;
                IpmMilesShr.parentId=ipmmiles.id;
                ProMiles.add(IpmMilesShr);
            }
            for(IPM_Task__c IPMtsk:IPMTask){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=ipmproid.IPM_Project_Gatekeeper__c;
                ProTskShare.AccessLevel='read';
                ProTaskShare.add(ProTskShare);
            }
            for(IPM_Project_Resource__c ProRes:Resourcetoshare){
                IPM_Project_Resource__Share rsShr1 = new IPM_Project_Resource__Share();
                rsShr1.ParentId = ProRes.Id;
                rsShr1.UserOrGroupId = ipmproid.IPM_Project_Gatekeeper__c;
                rsShr1.AccessLevel = 'read';
                ProResShrs.add(rsShr1);
            }
            for(id prodoc:ProDocid){
                ProDocShr=new IPM_Project_Document__Share();
                ProDocShr.parentId=prodoc;
                ProDocShr.accesslevel='Read';
                ProDocShr.userorgroupid=ipmproid.IPM_Project_Gatekeeper__c;
                ProDocuments.add(ProDocShr);
            }
            for(id secid:Sectionid){
                ProSec=new IPM_Project_Document_Section__Share();
                ProSec.parentId=secid;
                ProSec.accesslevel='Read';
                ProSec.userorgroupid=ipmproid.IPM_Project_Gatekeeper__c;
                ProDocSec.add(ProSec);
            }
            for(IPM_Project_Document_Section_Content__c secCont:lstProDocContent){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share ();
                IpmDocContent.accesslevel='Read';
                IpmDocContent.userorgroupid=ipmproid.IPM_Project_Gatekeeper__c;
                IpmDocContent.parentId=secCont.id;
                ProDocContent.add(IpmDocContent);
            }
            for(IPM_Project_Rollout__c rollPro:lstRollOut){
                IPM_Project_Rollout__share RolloutShare=new IPM_Project_Rollout__share();
                RolloutShare.accesslevel='Read';
                RolloutShare.userorgroupid=ipmproid.IPM_Project_Gatekeeper__c;
                RolloutShare.parentId=rollPro.id;
                lstProRollShr.add(RolloutShare);
            }
            for(IPM_Financial__c fin:lstFinancial){
                IPM_Financial__share FinShare=new IPM_Financial__share();
                FinShare.accesslevel='Read';
                FinShare.userorgroupid=ipmproid.IPM_Project_Gatekeeper__c;
                FinShare.parentId=fin.id;
                lstFinShr.add(FinShare);
            }
        }
       }
    if( isUserChanged==true){
    List<IPM_Project_Resource__Share> ProResShrs1  = new List<IPM_Project_Resource__Share>();
    List<IPM_Project__Share> ProjectShrs1  = new List<IPM_Project__Share>();
    List<IPM_Project_Document__Share>ProDocuments1=new list<IPM_Project_Document__Share>();
    List<IPM_Task__Share>ProTaskShare1=new list<IPM_Task__Share>();
    List<IPM_Project_Document_Section__Share>ProDocSec1=new list<IPM_Project_Document_Section__Share>();
    List<IPM_Milestone__Share>mileshare1=new list<IPM_Milestone__Share>();
    List<IPM_Bosscard__Share>IpmBossShare1=new list<IPM_Bosscard__Share>();
    ProResShrs1  = new List<IPM_Project_Resource__Share>();
    ProjectShrs1  = new List<IPM_Project__Share>();
    ProDocuments1=new list<IPM_Project_Document__Share>();
    ProTaskShare1=new list<IPM_Task__Share>();
    ProDocSec1=new list<IPM_Project_Document_Section__Share>();
    mileshare1=new list<IPM_Milestone__Share>();
    list<IPM_Project_Rollout__Share>lstProRollShr1=new list<IPM_Project_Rollout__Share>();
    list<IPM_Financial__Share>lstProFinShr=new list<IPM_Financial__Share>();
    set<id>ResId=new set<id>();
    ResId=(new map<id,IPM_Project_Resource__c>([Select id from IPM_Project_Resource__c where IPM_Project__c IN:proId])).keyset();
    set<id>ProDocid1=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:proId])).keyset();
    set<id>ProDocSecid1=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:proId])).keyset();
    set<id>Tskid=(new map<id,IPM_Task__c>([Select id from IPM_Task__c where IPM_Project__c IN:proId])).keyset();
    set<id>Milesid=(new map<id,IPM_Milestone__c>([Select id from IPM_Milestone__c where IPM_Project__c IN:proId])).keyset();
    set<id>Rolloutid=(new map<id,IPM_Project_Rollout__c>([select id from IPM_Project_Rollout__c where Regional_Project__c IN:proId])).keyset();
    set<id>Financialid=(new map<id,IPM_Financial__c>([select id from IPM_Financial__c where Regional_Project__c IN:proId])).keyset();
    ProResShrs1=[select id from IPM_Project_Resource__Share where ParentId IN:ResId and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    ProjectShrs1=[select id from IPM_Project__Share where ParentId IN:proId and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    ProDocuments1=[select id from IPM_Project_Document__Share where ParentId IN:ProDocid1 and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    ProTaskShare1=[select id from IPM_Task__Share where ParentId IN:Tskid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    ProDocSec1=[select id from IPM_Project_Document_Section__Share where ParentId IN:ProDocSecid1 and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    mileshare1=[select id from IPM_Milestone__Share where ParentId IN:Milesid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    lstProRollShr1=[select id from IPM_Project_Rollout__share where ParentId IN:Rolloutid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    lstProFinShr=[select id from IPM_Financial__Share where ParentId IN:Financialid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    if(ProResShrs1.size()>0)
    delete ProResShrs1;
    if(ProjectShrs1.size()>0)
    delete ProjectShrs1;
    if(ProDocuments1.size()>0)
    delete ProDocuments1;
    if(ProTaskShare1.size()>0)
    delete ProTaskShare1;
    if(ProDocSec1.size()>0)
    delete ProDocSec1;
    if(mileshare1.size()>0)
    delete mileshare1;
    if(lstProRollShr1.size()>0)
    delete lstProRollShr1;
    if(lstProFinShr.size()>0)
    delete lstProFinShr;
   
    }
       system.debug('ProjectShrs.....'+ProjectShrs);
       if(ProjectShrs.size()>0)
        insert ProjectShrs;
        if(ProResShrs.size()>0)
        insert ProResShrs;
        if(ProDocuments.size()>0)
        insert ProDocuments;
        if(ProDocSec.size()>0)
        upsert ProDocSec;
        if(ProTaskShare.size()>0)
        insert ProTaskShare;
        if(ProDocContent.size()>0)
        insert ProDocContent;
        if(ProMiles.size()>0)
        insert ProMiles;
        if(lstProRollShr.size()>0)
        insert lstProRollShr;
        if(lstFinShr.size()>0)
        insert lstFinShr;
    }
 }
//share Regional project records with local project member on update of local project
public void ShareWithLocalPL(map<id,IPM_Project__c>Newproject){
    ProResShrs  = new List<IPM_Project_Resource__Share>();
    ProjectShrs  = new List<IPM_Project__Share>();
    ProDocuments=new list<IPM_Project_Document__Share>();
    ProTaskShare=new list<IPM_Task__Share>();
    ProDocSec=new list<IPM_Project_Document_Section__Share>();
    ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
    ProMiles=new list<IPM_Milestone__Share>();
    IpmQuests=new list<IPM_Questionnaire__Share>();
    IpmBossShare=new list<IPM_Bosscard__Share>();
    lstProRollShr=new list<IPM_Project_Rollout__Share>();
    lstFinShr=new list<IPM_Financial__Share>();
    for(IPM_Project__c ipmproid:Newproject.values()){
        if(ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.IPM_Project_Leader__c!=null && ipmproid.OwnerId !=ipmproid.IPM_Project_Leader__c){
         proId.add(ipmproid.IPM_Parent_Project__c);
         }
     } 
     if(proId.size()>0){
        set<id>SetRegionalproject=(new map<id,IPM_Project__c>([select id from IPM_Project__c where id IN:proId])).keyset();
        list<IPM_Milestone__c>lstmiles=[select id,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Task__c>IPMTask=[select id,IPM_Assignee__c,IPM_Function__c from IPM_Task__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c  where IPM_Project__c IN:proId ] ;
        list<IPM_Project_Document__c> ProDocs= [SELECT IPM_Project__c FROM IPM_Project_Document__c where IPM_Project__c IN:SetRegionalproject];
        set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:SetRegionalproject])).keyset();
        list<IPM_Project_Document_Section__c>lstsection =[select id,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c IN:ProDocid ];
        set<id>Sectionid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:SetRegionalproject])).keyset();
        list<IPM_Project_Document_Section_Content__c>lstProDocContent=[select IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:Sectionid];
        list<IPM_Questionnaire__c>lstQuests=[select id from IPM_Questionnaire__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Project_Rollout__c>lstRollOut=[select id from IPM_Project_Rollout__c where Regional_Project__c IN:proId];
        list<IPM_Financial__c>lstFinancial=[select id from IPM_Financial__c where Regional_Project__c IN:proId];
        for(IPM_Project__c ipmproid:Newproject.values()){
         if(ipmproid.IPM_Parent_Project__c!=null && ipmproid.IPMProject_Span__c=='Local' && ipmproid.IPM_Project_Leader__c!=null && ipmproid.OwnerId !=ipmproid.IPM_Project_Leader__c){
           for(id projID:SetRegionalproject){
                ipmProshr=new IPM_Project__Share();
                ipmProshr.accesslevel='Read';
                ipmProshr.parentId=projID;
                ipmProshr.userorgroupid=ipmproid.IPM_Project_Leader__c;
                ProjectShrs.add(ipmProshr);
            }
            for(IPM_Milestone__c ipmmiles:lstmiles){
                IPM_Milestone__Share IpmMilesShr=new IPM_Milestone__Share();
                IpmMilesShr.accesslevel='Read';
                IpmMilesShr.userorgroupid=ipmproid.IPM_Project_Leader__c;
                IpmMilesShr.parentId=ipmmiles.id;
                ProMiles.add(IpmMilesShr);
            }
            for(IPM_Task__c IPMtsk:IPMTask){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=ipmproid.IPM_Project_Leader__c;
                ProTskShare.AccessLevel='read';
                ProTaskShare.add(ProTskShare);
            }
            for(IPM_Project_Resource__c ProRes:Resourcetoshare){
                IPM_Project_Resource__Share rsShr1 = new IPM_Project_Resource__Share();
                rsShr1.ParentId = ProRes.Id;
                rsShr1.UserOrGroupId = ipmproid.IPM_Project_Leader__c;
                rsShr1.AccessLevel = 'read';
                ProResShrs.add(rsShr1);
            }
            for(id prodoc:ProDocid){
                ProDocShr=new IPM_Project_Document__Share();
                ProDocShr.parentId=prodoc;
                ProDocShr.accesslevel='Read';
                ProDocShr.userorgroupid=ipmproid.IPM_Project_Leader__c;
                ProDocuments.add(ProDocShr);
            }
            for(id secid:Sectionid){
                ProSec=new IPM_Project_Document_Section__Share();
                ProSec.parentId=secid;
                ProSec.accesslevel='Read';
                ProSec.userorgroupid=ipmproid.IPM_Project_Leader__c;
                ProDocSec.add(ProSec);
            }
            for(IPM_Project_Document_Section_Content__c secCont:lstProDocContent){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share ();
                IpmDocContent.accesslevel='Read';
                IpmDocContent.userorgroupid=ipmproid.IPM_Project_Leader__c;
                IpmDocContent.parentId=secCont.id;
                ProDocContent.add(IpmDocContent);
            }
            for(IPM_Project_Rollout__c rollPro:lstRollOut){
                IPM_Project_Rollout__share RolloutShare=new IPM_Project_Rollout__share();
                RolloutShare.accesslevel='Read';
                RolloutShare.userorgroupid=ipmproid.IPM_Project_Leader__c;
                RolloutShare.parentId=rollPro.id;
                lstProRollShr.add(RolloutShare);
            }
            for(IPM_Financial__c fin:lstFinancial){
                IPM_Financial__share FinShare=new IPM_Financial__share();
                FinShare.accesslevel='Edit';
                FinShare.userorgroupid=ipmproid.IPM_Project_Leader__c;
                FinShare.parentId=fin.id;
                lstFinShr.add(FinShare);
            }
        }
      }
        if(ProjectShrs.size()>0)
        insert ProjectShrs;
        if(ProResShrs.size()>0)
        insert ProResShrs;
        if(ProDocuments.size()>0)
        insert ProDocuments;
        if(ProDocSec.size()>0)
        upsert ProDocSec;
        if(ProTaskShare.size()>0)
        insert ProTaskShare;
        if(ProDocContent.size()>0)
        insert ProDocContent;
        if(ProMiles.size()>0)
        insert ProMiles;
        if(lstProRollShr.size()>0)
        insert lstProRollShr;
        if(lstFinShr.size()>0)
        insert lstFinShr;
     }
 }
//share Regional project records with local project member on update of local project
public void ShareWithLocalMember(map<id,IPM_Project_Resource__c>NewProResource){
    ProResShrs  = new List<IPM_Project_Resource__Share>();
    ProjectShrs  = new List<IPM_Project__Share>();
    ProDocuments=new list<IPM_Project_Document__Share>();
    ProTaskShare=new list<IPM_Task__Share>();
    ProDocSec=new list<IPM_Project_Document_Section__Share>();
    ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
    ProMiles=new list<IPM_Milestone__Share>();
    IpmQuests=new list<IPM_Questionnaire__Share>();
    IpmBossShare=new list<IPM_Bosscard__Share>();
    lstProRollShr=new list<IPM_Project_Rollout__Share>();
    lstFinShr=new list<IPM_Financial__Share>();
    set<id>localPid=new set<id>();
    for(IPM_Project_Resource__c ipmproid:NewProResource.values()){
        if(ipmproid.IPM_Project__c!=null){
         localPid.add(ipmproid.IPM_Project__c);
        }
     }
    if(localPid.size()>0){
        //proId=(new map<id,IPM_Project__c>([select IPM_Parent_Project__C from IPM_Project__c where id IN:localPid and IPM_Parent_Project__c !=null and IPMProject_Span__c='Local'])).keyset();
        list<IPM_Project__c>lstproject=[select IPM_Parent_Project__C from IPM_Project__c where id IN:localPid and IPM_Parent_Project__c !=null and IPMProject_Span__c='Local'];
        for(IPM_Project__c pro:lstproject){
            proId.add(pro.IPM_Parent_Project__C );
        }
    }
    if(proId.size()>0){
        set<id>SetRegionalproject=(new map<id,IPM_Project__c>([select id from IPM_Project__c where id IN:proId])).keyset();
        list<IPM_Milestone__c>lstmiles=[select id,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Task__c>IPMTask=[select id,IPM_Assignee__c,IPM_Function__c from IPM_Task__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c  where IPM_Project__c IN:proId ] ;
        list<IPM_Project_Document__c> ProDocs= [SELECT IPM_Project__c FROM IPM_Project_Document__c where IPM_Project__c IN:SetRegionalproject];
        set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:SetRegionalproject])).keyset();
        list<IPM_Project_Document_Section__c>lstsection =[select id,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c IN:ProDocid ];
        set<id>Sectionid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:SetRegionalproject])).keyset();
        list<IPM_Project_Document_Section_Content__c>lstProDocContent=[select IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:Sectionid];
        list<IPM_Questionnaire__c>lstQuests=[select id from IPM_Questionnaire__c where IPM_Project__c IN:SetRegionalproject];
        list<IPM_Project_Rollout__c>lstRollOut=[select id from IPM_Project_Rollout__c where Regional_Project__c IN:proId];
        list<IPM_Financial__c>lstFinancial=[select id from IPM_Financial__c where Regional_Project__c IN:proId];
        for(IPM_Project_Resource__c ipmproid:NewProResource.values()){
           for(id projID:SetRegionalproject){
                ipmProshr=new IPM_Project__Share();
                ipmProshr.accesslevel='Read';
                ipmProshr.parentId=projID;
                ipmProshr.userorgroupid=ipmproid.IPM_User__c;
                ProjectShrs.add(ipmProshr);
            }
            for(IPM_Milestone__c ipmmiles:lstmiles){
                IPM_Milestone__Share IpmMilesShr=new IPM_Milestone__Share();
                IpmMilesShr.accesslevel='Read';
                IpmMilesShr.userorgroupid=ipmproid.IPM_User__c;
                IpmMilesShr.parentId=ipmmiles.id;
                ProMiles.add(IpmMilesShr);
            }
            for(IPM_Task__c IPMtsk:IPMTask){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=ipmproid.IPM_User__c;
                ProTskShare.AccessLevel='read';
                ProTaskShare.add(ProTskShare);
            }
            for(IPM_Project_Resource__c ProRes:Resourcetoshare){
                IPM_Project_Resource__Share rsShr1 = new IPM_Project_Resource__Share();
                rsShr1.ParentId = ProRes.Id;
                rsShr1.UserOrGroupId = ipmproid.IPM_User__c;
                rsShr1.AccessLevel = 'read';
                ProResShrs.add(rsShr1);
            }
            for(id prodoc:ProDocid){
                ProDocShr=new IPM_Project_Document__Share();
                ProDocShr.parentId=prodoc;
                ProDocShr.accesslevel='Read';
                ProDocShr.userorgroupid=ipmproid.IPM_User__c;
                ProDocuments.add(ProDocShr);
            }
            for(id secid:Sectionid){
                ProSec=new IPM_Project_Document_Section__Share();
                ProSec.parentId=secid;
                ProSec.accesslevel='Read';
                ProSec.userorgroupid=ipmproid.IPM_User__c;
                ProDocSec.add(ProSec);
            }
            for(IPM_Project_Document_Section_Content__c secCont:lstProDocContent){
                IpmDocContent=new IPM_Project_Document_Section_Content__Share ();
                IpmDocContent.accesslevel='Read';
                IpmDocContent.userorgroupid=ipmproid.IPM_User__c;
                IpmDocContent.parentId=secCont.id;
                ProDocContent.add(IpmDocContent);
            }
            for(IPM_Project_Rollout__c rollPro:lstRollOut){
                IPM_Project_Rollout__share RolloutShare=new IPM_Project_Rollout__share();
                RolloutShare.accesslevel='Read';
                RolloutShare.userorgroupid=ipmproid.IPM_User__c;
                RolloutShare.parentId=rollPro.id;
                lstProRollShr.add(RolloutShare);
            }
            for(IPM_Financial__c fin:lstFinancial){
                IPM_Financial__share FinShare=new IPM_Financial__share();
                FinShare.accesslevel='Read';
                FinShare.userorgroupid=ipmproid.IPM_User__c;
                FinShare.parentId=fin.id;
                lstFinShr.add(FinShare);
            }
     }
        if(ProjectShrs.size()>0)
        insert ProjectShrs;
        if(ProResShrs.size()>0)
        insert ProResShrs;
        if(ProDocuments.size()>0)
        insert ProDocuments;
        if(ProDocSec.size()>0)
        upsert ProDocSec;
        if(ProTaskShare.size()>0)
        insert ProTaskShare;
        if(ProDocContent.size()>0)
        insert ProDocContent;
        if(ProMiles.size()>0)
        insert ProMiles;
        if(lstProRollShr.size()>0)
        insert lstProRollShr;
        if(lstFinShr.size()>0)
        insert lstFinShr;
    }
}
//Delete share records which is already assigned to local project members
public void DeleteshareLocalMember(map<id,IPM_Project_Resource__c>oldProResource){
    ProResShrs  = new List<IPM_Project_Resource__Share>();
    ProjectShrs  = new List<IPM_Project__Share>();
    ProDocuments=new list<IPM_Project_Document__Share>();
    ProTaskShare=new list<IPM_Task__Share>();
    ProDocSec=new list<IPM_Project_Document_Section__Share>();
    ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
    ProMiles=new list<IPM_Milestone__Share>();
    IpmQuests=new list<IPM_Questionnaire__Share>();
    IpmBossShare=new list<IPM_Bosscard__Share>();
    lstProRollShr=new list<IPM_Project_Rollout__Share>();
    list<IPM_Financial__Share>lstProFinShr=new list<IPM_Financial__Share>();
    map<id,id>localPid=new map<id,id>();
    set<id>UsertoDelete=new set<id>();
    for(IPM_Project_Resource__c ipmproid:oldProResource.values()){
        if(ipmproid.IPM_Project__c!=null){
         localPid.put(ipmproid.IPM_Project__c,ipmproid.IPM_User__c);
        }
     }
    if(localPid.size()>0){
       // proId=(new map<id,IPM_Project__c>([select id from IPM_Project__c where id IN:localPid.keyset() and IPM_Parent_Project__c !=null and IPMProject_Span__c='Local'])).keyset();
       list<IPM_Project__c>lstproject=[select IPM_Parent_Project__C from IPM_Project__c where id IN:localPid.keyset() and IPM_Parent_Project__c !=null and IPMProject_Span__c='Local'];
        for(IPM_Project__c pro:lstproject){
            proId.add(pro.IPM_Parent_Project__C );
        }
        for(IPM_Project_Resource__c ipmproid:oldProResource.values()){
            
            if(localPid.get(ipmproid.IPM_Project__c)==ipmproid.IPM_User__c){
                UsertoDelete.add(ipmproid.IPM_User__c);
            }
           
        }
    }
    if(proId.size()>0){
    List<IPM_Project_Resource__Share> ProResShrs1  = new List<IPM_Project_Resource__Share>();
    List<IPM_Project__Share> ProjectShrs1  = new List<IPM_Project__Share>();
    List<IPM_Project_Document__Share>ProDocuments1=new list<IPM_Project_Document__Share>();
    List<IPM_Task__Share>ProTaskShare1=new list<IPM_Task__Share>();
    List<IPM_Project_Document_Section__Share>ProDocSec1=new list<IPM_Project_Document_Section__Share>();
    List<IPM_Milestone__Share>mileshare1=new list<IPM_Milestone__Share>();
    List<IPM_Bosscard__Share>IpmBossShare1=new list<IPM_Bosscard__Share>();
    ProResShrs1  = new List<IPM_Project_Resource__Share>();
    ProjectShrs1  = new List<IPM_Project__Share>();
    ProDocuments1=new list<IPM_Project_Document__Share>();
    ProTaskShare1=new list<IPM_Task__Share>();
    ProDocSec1=new list<IPM_Project_Document_Section__Share>();
    mileshare1=new list<IPM_Milestone__Share>();
    list<IPM_Project_Rollout__Share>lstProRollShr1=new list<IPM_Project_Rollout__Share>();
    set<id>ResId=new set<id>();
    ResId=(new map<id,IPM_Project_Resource__c>([Select id from IPM_Project_Resource__c where IPM_Project__c IN:proId])).keyset();
    set<id>ProDocid1=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:proId])).keyset();
    set<id>ProDocSecid1=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:proId])).keyset();
    set<id>Rolloutid=(new map<id,IPM_Project_Rollout__c>([select id from IPM_Project_Rollout__c where Regional_Project__c IN:proId])).keyset();
    set<id>Financialid=(new map<id,IPM_Financial__c>([select id from IPM_Financial__c where Regional_Project__c IN:proId])).keyset();
    set<id>Tskid=(new map<id,IPM_Task__c>([Select id from IPM_Task__c where IPM_Project__c IN:proId])).keyset();
    set<id>Milesid=(new map<id,IPM_Milestone__c>([Select id from IPM_Milestone__c where IPM_Project__c IN:proId])).keyset();
    ProResShrs1=[select id from IPM_Project_Resource__Share where ParentId IN:ResId and UserOrGroupId IN:UsertoDelete and RowCause !='Owner'];
    ProjectShrs1=[select id from IPM_Project__Share where ParentId IN:proId and UserOrGroupId IN:UsertoDelete and RowCause !='Owner'];
    ProDocuments1=[select id from IPM_Project_Document__Share where ParentId IN:ProDocid1 and UserOrGroupId IN:UsertoDelete and RowCause !='Owner'];
    ProTaskShare1=[select id from IPM_Task__Share where ParentId IN:Tskid and UserOrGroupId IN:UsertoDelete and RowCause !='Owner'];
    ProDocSec1=[select id from IPM_Project_Document_Section__Share where ParentId IN:ProDocSecid1 and UserOrGroupId IN:UsertoDelete and RowCause !='Owner'];
    mileshare1=[select id from IPM_Milestone__Share where ParentId IN:Milesid and UserOrGroupId IN:UsertoDelete and RowCause !='Owner'];
    lstProRollShr1=[select id from IPM_Project_Rollout__share where ParentId IN:Rolloutid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    lstProFinShr=[select id from IPM_Financial__Share where ParentId IN:Financialid and UserOrGroupId IN:ChangedUserid and RowCause !='Owner'];
    if(ProResShrs1.size()>0)
    delete ProResShrs1;
    if(ProjectShrs1.size()>0)
    delete ProjectShrs1;
    if(ProDocuments1.size()>0)
    delete ProDocuments1;
    if(ProTaskShare1.size()>0)
    delete ProTaskShare1;
    if(ProDocSec1.size()>0)
    delete ProDocSec1;
    if(mileshare1.size()>0)
    delete mileshare1;
    if(lstProRollShr1.size()>0)
    delete lstProRollShr1;
    if(lstProFinShr.size()>0)
    delete lstProFinShr;
   
    }
   
}
}