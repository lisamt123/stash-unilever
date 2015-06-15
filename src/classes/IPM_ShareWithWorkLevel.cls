/*
Created by:Rajesh(Cognizant)
Created date:10/03/2015
Description:Share all records to same company card and same category
*/

public class IPM_ShareWithWorkLevel{

public void ShareRecords(list<IPM_User_Profile__c>newprofile){
set<id>companyid=new set<id>();
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
list<IPM_Financial_File__Share>lstFinfileShr=new list<IPM_Financial_File__Share>();
for(IPM_User_Profile__c nprofile:newprofile){
    if(nprofile.IPM_Company_Card__c !=null && nprofile.IPM_Work_Level__c=='WL2+'){
           companyid.add(nprofile.IPM_Company_Card__c);
           system.debug('hi.......'+companyid);
   }
}

if(companyid.size()>0){

list<IPM_Company_Card__c>lstcc=[select IPM_Managed_Category__c from IPM_Company_Card__c where id IN:companyid];
list<IPM_Project__c>prolist=[Select IPM_Company_Card__c,IPM_Bosscard__c from IPM_Project__c where IPM_Company_Card__c IN:companyid];
set<id>Project_id=(new map<id,IPM_Project__c>([Select id from IPM_Project__c where IPM_Company_Card__c IN:companyid])).keyset();
set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:Project_id])).keyset();
set<id>ProDocSecid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:Project_id])).keyset();
set<id>Tskid=(new map<id,IPM_Task__c>([Select id from IPM_Task__c where IPM_Project__c IN:Project_id])).keyset();
set<id>Milesid=(new map<id,IPM_Milestone__c>([Select id from IPM_Milestone__c where IPM_Project__c IN:Project_id])).keyset();
//set<id>Bossid=(new map<id,IPM_Project__c>([Select IPM_Bosscard__c from IPM_Project__c where id IN:Project_id])).keyset();
set<id>ProResShrs1=(new map<id,IPM_Project_Resource__c>([select id from IPM_Project_Resource__c where IPM_Project__c IN:Project_id])).keyset();
list<IPM_Project_Document_Section_Content__c>lstProDocContent=[select IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:ProDocSecid];
list<IPM_Project_Rollout__c>lstRollOut=[select id from IPM_Project_Rollout__c where (Local_Project__c IN:Project_id or IPM_Project__c IN:Project_id)];
list<IPM_Financial__c>lstFinancial=[select id from IPM_Financial__c where (Local_Project__c IN:Project_id or Parent_Project__c IN:Project_id or Regional_Project__c IN:Project_id)];
list<IPM_Financial_File__c>lstFinFile=[select id from IPM_Financial_File__c where IPM_Project__c IN:Project_id];
for(IPM_User_Profile__c nprofile:newprofile){
   for(IPM_Company_Card__c cc:lstcc){
    
    if(nprofile.IPM_Company_Card__c !=null && nprofile.IPM_Work_Level__c=='WL2+' && nprofile.IPM_Company_Card__c==cc.id){
        if(cc.IPM_Managed_Category__c.Contains(nprofile.IPM_User_Category__c)){
        for(IPM_Project__c proid:prolist){
            IPM_Project__Share proshr=new IPM_Project__Share();
            proshr.Parentid=proid.id;
            proshr.AccessLevel='Read';
            proshr.UserOrGroupid=nprofile.IPM_User__c;
            ProjectShrs.add(proshr);
            if(proid.IPM_Bosscard__c!=null){
                IPM_Bosscard__Share bosshare=new IPM_Bosscard__Share();
                bosshare.Parentid=proid.IPM_Bosscard__c;
                bosshare.AccessLevel='Read';
                bosshare.UserOrGroupid=nprofile.IPM_User__c;
                IpmBossShare.add(bosshare);
            }
        }
        for(id docid:ProDocid){
            IPM_Project_Document__Share prodocshr=new IPM_Project_Document__Share();
            prodocshr.Parentid=docid;
            prodocshr.AccessLevel='Read';
            prodocshr.UserOrGroupid=nprofile.IPM_User__c;
            ProDocuments.add(prodocshr);
        }
       for(id docsecid:ProDocSecid){
            IPM_Project_Document_Section__Share prodocsecshr=new IPM_Project_Document_Section__Share();
            prodocsecshr.Parentid=docsecid;
            prodocsecshr.AccessLevel='Read';
            prodocsecshr.UserOrGroupid=nprofile.IPM_User__c;
            ProDocSec.add(prodocsecshr);
       }
       for(id Tid:Tskid){
            IPM_Task__Share tskshr=new IPM_Task__Share();
            tskshr.Parentid=Tid;
            tskshr.AccessLevel='Read';
            tskshr.UserOrGroupid=nprofile.IPM_User__c;
            ProTaskShare.add(tskshr);
       }
       for(id mid:Milesid){
            IPM_Milestone__Share Milessshr=new IPM_Milestone__Share();
            Milessshr.Parentid=mid;
            Milessshr.AccessLevel='Read';
            Milessshr.UserOrGroupid=nprofile.IPM_User__c;
            ProMiles.add(Milessshr);
       }
       for(id Resid:ProResShrs1){
            IPM_Project_Resource__Share Ressourceshr=new IPM_Project_Resource__Share();
            Ressourceshr.Parentid=Resid;
            Ressourceshr.AccessLevel='Read';
            Ressourceshr.UserOrGroupid=nprofile.IPM_User__c;
            ProResShrs.add(Ressourceshr);
       }
      for(IPM_Project_Document_Section_Content__c  dcontent:lstProDocContent){
            IPM_Project_Document_Section_Content__Share contshr=new IPM_Project_Document_Section_Content__Share();
            contshr.Parentid=dcontent.id;
            contshr.AccessLevel='Read';
            contshr.UserOrGroupid=nprofile.IPM_User__c;
            ProDocContent.add(contshr);
      }
      for(IPM_Project_Rollout__c  rollo:lstRollOut){
            IPM_Project_Rollout__Share rollshr=new IPM_Project_Rollout__Share();
            rollshr.Parentid=rollo.id;
            rollshr.AccessLevel='Read';
            rollshr.UserOrGroupid=nprofile.IPM_User__c;
            lstProRollShr.add(rollshr);
      }
      for(IPM_Financial__c  fin:lstFinancial){
            IPM_Financial__Share finshr=new IPM_Financial__Share();
            finshr.Parentid=fin.id;
            finshr.AccessLevel='Read';
            finshr.UserOrGroupid=nprofile.IPM_User__c;
            lstFinShr.add(finshr);
      }
      for(IPM_Financial_File__c  finfile:lstFinFile){
            IPM_Financial_File__Share finfileshr=new IPM_Financial_File__Share();
            finfileshr.Parentid=finfile.id;
            finfileshr.AccessLevel='Read';
            finfileshr.UserOrGroupid=nprofile.IPM_User__c;
            lstFinfileShr.add(finfileshr);
      }
    }else{
        nprofile.IPM_User_Category__c.adderror('Selected category is not matching with company card category');
    }
    }
   } 
}   

}
if(ProjectShrs.size()>0){
upsert ProjectShrs;
}
if(IpmBossShare.size()>0){
upsert IpmBossShare;
}
if(ProDocuments.size()>0){
upsert ProDocuments;
}
if(ProDocSec.size()>0){
upsert ProDocSec;
}
if(ProTaskShare.size()>0){
upsert ProTaskShare;
}
if(ProMiles.size()>0){
upsert ProMiles;
}
if(ProResShrs.size()>0){
upsert ProResShrs;
}
if(ProDocContent.size()>0){
upsert ProDocContent;
}
if(lstProRollShr.size()>0){
upsert lstProRollShr;
}
if(lstFinShr.size()>0){
upsert lstFinShr;
}
if(lstFinfileShr.size()>0){
upsert lstFinfileShr;
}
}
}