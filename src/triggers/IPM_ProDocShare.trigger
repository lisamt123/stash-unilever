trigger IPM_ProDocShare on IPM_Project_Document__c (after insert) {

if(trigger.isinsert){
List<IPM_Project_Document__Share>ProDocuments=new list<IPM_Project_Document__Share>();
set<id>ProDocID=new set<id>();
set<id>ProID=new set<id>();
set<id>DupUser=new set<id>();
    for(IPM_Project_Document__c prodoc:trigger.new){
    ProID.add(prodoc.IPM_Project__c);
    ProDocID.add(prodoc.id);
    }
list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_Project_Role_Owner__c,IPM_Role_Type__c,IPM_User__c from IPM_Project_Resource__c
                                              where IPM_Project__c IN:ProID] ;

list<IPM_Project__c>prolst=[select IPM_Company_Card__c,IPM_Project_Leader__c,IPM_Technical_Project_Leader__c,Deputy_Project_Leader__c,IPM_Project_Gatekeeper__c
                            from IPM_Project__c where id IN:ProID limit 1];

list<IPM_Company_Card__c>lstCC=[Select IPM_Business_Partner__c,ipm_managed_category__c from IPM_Company_Card__c where id=:prolst[0].IPM_Company_Card__c];
DupUser.add(prolst[0].IPM_Project_Leader__c);
DupUser.add(prolst[0].IPM_Technical_Project_Leader__c);
DupUser.add(prolst[0].Deputy_Project_Leader__c);
DupUser.add(prolst[0].IPM_Project_Gatekeeper__c);
IPM_Project_Document__Share ProDocShr;
IPM_Project_Document__Share DPL;
IPM_Project_Document__Share TPL;
IPM_Project_Document__Share Gk;
IPM_Project_Document__Share PL;
if(Resourcetoshare.size()>0){
    for(id docid:ProDocID){
       
        for(IPM_Project_Resource__c proRes:Resourcetoshare){
            ProDocShr=new IPM_Project_Document__Share ();
            ProDocShr.ParentId=docid;
            ProDocShr.UserOrGroupid=proRes.IPM_User__c;
            if(proRes.IPM_Role_Type__c=='Guest'){
            ProDocShr.AccessLevel='Read';
            }else{
             ProDocShr.AccessLevel='Edit';
            }
           ProDocuments.add(ProDocShr);
        DupUser.add(proRes.IPM_User__c);
        }
   } 
 }  
if(prolst.size()>0){
for(id docid:ProDocID){
DPL=new IPM_Project_Document__Share();
TPL=new IPM_Project_Document__Share();
Gk=new IPM_Project_Document__Share();
PL=new IPM_Project_Document__Share();
/*if(prolst[0].Deputy_Project_Leader__c !=null && prolst[0].Deputy_Project_Leader__c!=prolst[0].IPM_Project_Leader__c){
DPL.ParentId =docid;
DPL.UserOrGroupId=prolst[0].Deputy_Project_Leader__c;
DPL.AccessLevel='edit';
ProDocuments.add(DPL);
    }*/

if(lstCC.size()>0){
    for(IPM_Company_Card__c cc:lstCC){
        if(cc.IPM_Business_Partner__c!=null && cc.IPM_Business_Partner__c!=userinfo.getuserid()){
          IPM_Project_Document__Share docshr=  new IPM_Project_Document__Share();
          docshr.parentid=docid;
          docshr.accesslevel='Edit';
          docshr.UserOrGroupId=cc.IPM_Business_Partner__c;
          ProDocuments.add(docshr);
        }
    }
}

if(userinfo.getuserid()!=prolst[0].Deputy_Project_Leader__c && prolst[0].Deputy_Project_Leader__c !=null && prolst[0].Deputy_Project_Leader__c!=prolst[0].IPM_Project_Leader__c){
DPL.ParentId =docid;
DPL.UserOrGroupId=prolst[0].Deputy_Project_Leader__c;
DPL.AccessLevel='edit';
ProDocuments.add(DPL);
    } 
if(prolst[0].IPM_Project_Gatekeeper__c!=null && prolst[0].Deputy_Project_Leader__c!=prolst[0].IPM_Project_Leader__c && userinfo.getuserid()!=prolst[0].IPM_Project_Gatekeeper__c ){
Gk.ParentId =docid;
Gk.UserOrGroupId=prolst[0].IPM_Project_Gatekeeper__c;
Gk.AccessLevel='edit';
ProDocuments.add(Gk);
    }    
if(prolst[0].IPM_Technical_Project_Leader__c !=null && prolst[0].IPM_Technical_Project_Leader__c!=prolst[0].IPM_Project_Leader__c){
TPL.ParentId =docid;
TPL.UserOrGroupId=prolst[0].IPM_Technical_Project_Leader__c;
TPL.AccessLevel='Read';
ProDocuments.add(TPL);
    }


string PLuser=prolst[0].IPM_Project_Leader__c;  
if(userinfo.getuserid()!=prolst[0].IPM_Project_Leader__c && PLuser!=null){
PL.ParentId =docid;
PL.UserOrGroupId=PLuser;
PL.AccessLevel='edit';
ProDocuments.add(PL);
    }    
    }
 } 
list<IPM_User_Profile__c>lstUProfile=[Select IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c from IPM_User_Profile__c where IPM_Work_Level__c='WL2+' and IPM_Company_Card__c=:prolst[0].IPM_Company_Card__c and IPM_User__c Not IN:DupUser];

    for(id docid:ProDocID){
     for(IPM_Company_Card__c cc:lstCC){
        for(IPM_User_Profile__c up:lstUProfile){
            if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=userinfo.getuserid()){
              IPM_Project_Document__Share docshr=  new IPM_Project_Document__Share();
              docshr.parentid=docid;
              docshr.accesslevel='Read';
              docshr.UserOrGroupId=up.IPM_User__c;
              ProDocuments.add(docshr);
            }
        }
     }  
    }
                         
if(ProDocuments.size()>0)
upsert ProDocuments;

}

}