trigger IPM_ProjectShare on IPM_Project_Resource__c (after insert,after delete) {
IPM_ProjectShare handler=new IPM_ProjectShare();
if(trigger.isInsert){
        handler.ShareWithLocalMember(trigger.newmap);
        List<IPM_Project_Resource__Share> ProResShrs  = new List<IPM_Project_Resource__Share>();
        List<IPM_Project__Share> ProjectShrs  = new List<IPM_Project__Share>();
        List<IPM_Project_Document__Share>ProDocuments=new list<IPM_Project_Document__Share>();
        List<IPM_Task__Share>ProTaskShare=new list<IPM_Task__Share>();
        List<IPM_Project_Document_Section__Share>ProDocSec=new list<IPM_Project_Document_Section__Share>();
        List<IPM_Project_Document_Section_Content__Share>ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
        List<IPM_Milestone__Share>ProMiles=new list<IPM_Milestone__Share>();
        List<IPM_Questionnaire__Share>IpmQuests=new list<IPM_Questionnaire__Share>();
        List<IPM_Bosscard__Share>IpmBossShare=new list<IPM_Bosscard__Share>();
        list<IPM_Financial__Share>lstFinShr=new list<IPM_Financial__Share>();
        list<IPM_Project_Rollout__Share>lstProRollShr=new list<IPM_Project_Rollout__Share>();
        IPM_Bosscard__Share Bossshare;
        IPM_Project_Document__Share ProDocShr;
        IPM_Project__Share ipmProshr;
        IPM_Project_Resource__Share DPLrsShr;
        IPM_Project_Resource__Share GatekrsShr;
        IPM_Project_Resource__Share TPLrsShr;
        IPM_Project_Document_Section__Share ProSec;
        IPM_Task__Share ProTskShare;
        IPM_Project_Document_Section_Content__Share IpmDocContent;
        IPM_Milestone__Share IpmMilesShr;
        IPM_Questionnaire__Share IPMQuestshr;
        set<id>proId=new set<id>();
        set<id>DupUser=new set<id>();
        for(IPM_Project_Resource__c  ipmrsource : trigger.new){
            proId.add(ipmrsource.IPM_Project__c);
        }
        list<IPM_Milestone__c>lstmiles=[select id,IPM_Type_of_Milestone__c from IPM_Milestone__c where IPM_Project__c IN:proId];
        list<IPM_Task__c>IPMTask=[select id,IPM_Assignee__c,IPM_Function__c from IPM_Task__c where IPM_Project__c IN:proId];
        list<IPM_Project__c> IPMPro=[select IPM_Company_Card__c,IPM_Bosscard__c,Deputy_Project_Leader__c,IPM_Project_Leader__c,IPM_Technical_Project_Leader__c,IPM_Project_Gatekeeper__c from IPM_Project__c where id IN:proId limit 1];
        list<IPM_Project_Resource__c>Resourcetoshare=[select id,IPM_User__c ,CreatedBy.id,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c  where IPM_Project__c IN:proId and IPM_User__c !=:userinfo.getuserid()] ;    
        list<IPM_Project_Resource__c>Resourcetoshare1=[select id,CreatedBy.id,IPM_Project_Role_Owner__c,IPM_Role_Type__c,IPM_User__c from IPM_Project_Resource__c  where IPM_Project__c IN:proId and IPM_User__c !=:userinfo.getuserid()] ;
        list<IPM_Project_Resource__c>Resourcetoshare3=[select id,CreatedBy.id,IPM_User__c ,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resource__c  where IPM_Project__c IN:proId  and IPM_User__c !=:userinfo.getuserid()] ;
        list<IPM_Project_Resource__c>Resourcetoshare2=[select id,CreatedBy.id,IPM_Project_Role_Owner__c,IPM_Role_Type__c,IPM_User__c from IPM_Project_Resource__c  where IPM_Project__c IN:proId and IPM_User__c !=:userinfo.getuserid()] ;
        list<IPM_Company_Card__c>lstCC=[Select IPM_Business_Partner__c,IPM_Managed_category__c from IPM_Company_Card__c where id=:IPMPro[0].IPM_Company_Card__c]; 
        list<IPM_Financial__c>lstFin=[select id from IPM_Financial__c where (Parent_Project__c IN:proId or Regional_Project__c IN:proId or Local_Project__c IN:proId)];
        list<IPM_Project_Rollout__c>lstRollouts=[select id,IPM_Project__c,Regional_Project__c from IPM_Project_Rollout__c where (IPM_Project__c IN:proId or Regional_Project__c IN:proId)];
        set<id>GRollid=new set<id>();
        for(IPM_Project_Rollout__c rout:lstRollouts){
            if(rout.IPM_Project__c!=null){
                GRollid.add(rout.IPM_Project__c);
            }
            if(rout.Regional_Project__c!=null){
                GRollid.add(rout.Regional_Project__c);
            }
        }
        list<IPM_Project_Rollout__c>lstRollout=[select id,IPM_Project__c,Regional_Project__c from IPM_Project_Rollout__c where (IPM_Project__c IN:GRollid or Regional_Project__c IN:GRollid)];
        DupUser.add(IPMPro[0].IPM_Project_Leader__c);
        DupUser.add(IPMPro[0].IPM_Technical_Project_Leader__c);
        DupUser.add(IPMPro[0].Deputy_Project_Leader__c);
        DupUser.add(IPMPro[0].IPM_Project_Gatekeeper__c);
        for(IPM_Project_Resource__c  ipmrsource : trigger.new){
           // Instantiate the sharing objects
            //IPM_Project_Resource__Share rsShr;
           DupUser.add(ipmrsource.IPM_User__c);
           if(lstCC.size()>0){
            for(IPM_Company_Card__c cc:lstCC){
                if(cc.IPM_Business_Partner__c!=null && cc.IPM_Business_Partner__c!=userinfo.getuserid()){
                  IPM_Project_Resource__Share Resshare=  new IPM_Project_Resource__Share();
                  Resshare.parentid=ipmrsource.id;
                  Resshare.accesslevel='Edit';
                  Resshare.UserOrGroupId=cc.IPM_Business_Partner__c;
                  ProResShrs.add(Resshare);
                }
            }
         }   
            ipmProshr=new IPM_Project__Share();
            for(IPM_Project__c ipmUDetails:IPMPro){
                if(ipmUDetails.id==ipmrsource.IPM_Project__c){
                    DPLrsShr=new IPM_Project_Resource__Share(); 
                    GatekrsShr=new IPM_Project_Resource__Share(); 
                    TPLrsShr=new IPM_Project_Resource__Share(); 
                    DPLrsShr.ParentId=ipmrsource.Id;
                    GatekrsShr.ParentId=ipmrsource.Id;
                    TPLrsShr.ParentId=ipmrsource.Id;
                    DPLrsShr.AccessLevel='edit';
                    GatekrsShr.AccessLevel='read';
                    TPLrsShr.AccessLevel='read';
                    id DPLid=ipmUDetails.Deputy_Project_Leader__c;
                    id GateKid=ipmUDetails.IPM_Project_Gatekeeper__c;
                    id TPLid=ipmUDetails.IPM_Technical_Project_Leader__c;
                if(ipmUDetails.IPM_Bosscard__c !=null && ipmrsource.IPM_Role_Type__c !='Guest'){
                     Bossshare=new IPM_Bosscard__Share();
                     Bossshare.parentid=ipmUDetails.IPM_Bosscard__c;
                     Bossshare.UserOrGroupId=ipmrsource.IPM_User__c;
                     Bossshare.AccessLevel='edit';
                     IpmBossShare.add(Bossshare);
                    }
                if(userinfo.getuserid()==DPLid)
                    DPLrsShr.UserOrGroupId=ipmUDetails.IPM_Project_Leader__c;
                if(userinfo.getuserid()!=DPLid && userinfo.getuserid()!=ipmUDetails.IPM_Project_Leader__c)
                    DPLrsShr.UserOrGroupId=ipmUDetails.Deputy_Project_Leader__c;    
                if(userinfo.getuserid()==ipmUDetails.IPM_Project_Leader__c)
                    DPLrsShr.UserOrGroupId=DPLid;
                    GatekrsShr.UserOrGroupId=GateKid;
                    TPLrsShr.UserOrGroupId=TPLid;
                    system.debug('TPLid.....'+TPLid);
                            
                if(ipmUDetails.Deputy_Project_Leader__c!=ipmUDetails.IPM_Project_Leader__c && ipmUDetails.Deputy_Project_Leader__c!=null){
                    ProResShrs.add(DPLrsShr);
                    system.debug('inside.....'+ProResShrs);
                    }
                if(ipmUDetails.IPM_Project_Gatekeeper__c!=ipmUDetails.IPM_Project_Leader__c && ipmUDetails.IPM_Project_Gatekeeper__c!=null)
                    {
                    ProResShrs.add(GatekrsShr);
                    system.debug('IPM_Project_Gatekeeper__c.....'+ProResShrs);
                    }
                if(ipmUDetails.IPM_Technical_Project_Leader__c!=ipmUDetails.IPM_Project_Leader__c && TPLid!=null)
                   { 
                     ProResShrs.add(TPLrsShr);
                     system.debug('IPM_Project_Gatekeeper__c.....'+TPLrsShr);
                     }
                   
                }
                
            }
            //rsShr = new IPM_Project_Resource__Share();
             
            
            // Set the ID of record being shared
            ipmProshr.ParentId=ipmrsource.IPM_Project__c;
            //rsShr.ParentId = ipmrsource.Id;
            
           // Set the ID of user or group being granted access
            ipmProshr.UserOrGroupId = ipmrsource.IPM_User__c;
            ipmProshr.AccessLevel='Edit';
            ProjectShrs.add(ipmProshr);
            
            if(lstmiles.size()>0){
               for(IPM_Milestone__c ipmmiles:lstmiles){
                IpmMilesShr=new IPM_Milestone__Share();
                IpmMilesShr.ParentId=ipmmiles.id;
                
                IpmMilesShr.UserOrGroupId=ipmrsource.IPM_User__c;
                if(ipmmiles.IPM_Type_of_Milestone__c=='Standard' && ipmrsource.IPM_Role_Type__c=='CMI'){
                IpmMilesShr.AccessLevel='Read';
                }
                else if (ipmmiles.IPM_Type_of_Milestone__c=='Standard' && ipmrsource.IPM_Role_Type__c=='Finance'){
                IpmMilesShr.AccessLevel='Read';
                }
                else if(ipmmiles.IPM_Type_of_Milestone__c=='Standard' && ipmrsource.IPM_Role_Type__c=='CD'){
               
                IpmMilesShr.AccessLevel='Read';
                }
                else if (ipmmiles.IPM_Type_of_Milestone__c=='Standard' && ipmrsource.IPM_Role_Type__c=='Guest'){
                IpmMilesShr.AccessLevel='Read';
                }else{
                 IpmMilesShr.AccessLevel='Edit';
                }
               if(IpmMilesShr.AccessLevel ==''){ 
               if(ipmmiles.IPM_Type_of_Milestone__c==null && ipmrsource.IPM_Role_Type__c!='Guest'){
                  IpmMilesShr.AccessLevel='Edit';
               }else{
                IpmMilesShr.AccessLevel='Read';
               }
              }
               ProMiles.add(IpmMilesShr);
            }
           }
            
            if(IPMTask.size()>0){
                for(IPM_Task__c IPMtsk:IPMTask){
                ProTskShare=new IPM_Task__Share();
                ProTskShare.ParentId=IPMtsk.id;
                ProTskShare.UserOrGroupId=ipmrsource.IPM_User__c;
                if(IPMtsk.IPM_Function__c==ipmrsource.IPM_Role_Type__c ){
                ProTskShare.AccessLevel='edit';
                }else if(ipmrsource.IPM_Role_Type__c=='Supply Chain'){
                ProTskShare.AccessLevel='Edit';
                 }else{
                 ProTskShare.AccessLevel='read';
                 }
                ProTaskShare.add(ProTskShare); 
                }
            }
            

            
           // rsShr.UserOrGroupId = ipmrsource.IPM_User__c;
          
            // Set the access level
            //rsShr.AccessLevel = 'read';
      if(Resourcetoshare.size()>0){
          for(IPM_Project_Resource__c ProRes:Resourcetoshare){
          // Instantiate the sharing objects
            if(ProRes.IPM_Role_Type__c==ipmrsource.IPM_Role_Type__c)
            {
            IPM_Project_Resource__Share rsShr1;
            rsShr1 = new IPM_Project_Resource__Share();
                        
            // Set the ID of record being shared
            rsShr1.ParentId = ProRes.Id;
           // Set the ID of user or group being granted access
            rsShr1.UserOrGroupId = ipmrsource.IPM_User__c;
           // Set the access level
           /*
           if(ProRes.IPM_Project_Role_Owner__c==true){ 
           if (ProRes.IPM_Role_Type__c=='BB'){
           rsShr1.AccessLevel = 'Read';
           }else{
           rsShr1.AccessLevel = 'edit';
           }
           }else{
           
           } */
           rsShr1.AccessLevel = 'Read';        
          // Add objects to list for insert
           ProResShrs.add(rsShr1);
            }
          }
          }
         
          if(Resourcetoshare.size()>0){
          for(IPM_Project_Resource__c ProRes:Resourcetoshare){
          // Instantiate the sharing objects
            if(ProRes.IPM_Role_Type__c==ipmrsource.IPM_Role_Type__c && ProRes.id !=ipmrsource.id){
            IPM_Project_Resource__Share rsShr2;
            rsShr2 = new IPM_Project_Resource__Share();
                        
            // Set the ID of record being shared
            rsShr2.ParentId = ipmrsource.Id;
           // Set the ID of user or group being granted access
            rsShr2.UserOrGroupId = ProRes.IPM_User__c;
           // Set the access level
           if(ProRes.IPM_Project_Role_Owner__c==true && ProRes.createdby.id!=userinfo.getuserid()){ 
           if (ProRes.IPM_Role_Type__c=='BB'){
           rsShr2.AccessLevel = 'Read';
           }else{
           rsShr2.AccessLevel = 'read';
           }
           }else{
           rsShr2.AccessLevel = 'Read';
           } 
                   
          // Add objects to list for insert
            ProResShrs.add(rsShr2);
            system.debug('here......'+rsShr2);
            }
          }
         }
         
          if(Resourcetoshare.size()>0){
          for(IPM_Project_Resource__c ProRes:Resourcetoshare){
          if(ProRes.IPM_Role_Type__c !=ipmrsource.IPM_Role_Type__c){
          // Instantiate the sharing objects
            IPM_Project_Resource__Share rsShr4;
            rsShr4 = new IPM_Project_Resource__Share();
                        
            // Set the ID of record being shared
            rsShr4.ParentId = ProRes.Id;
           // Set the ID of user or group being granted access
            rsShr4.UserOrGroupId = ProRes.IPM_User__c;
           // Set the access level
          rsShr4.AccessLevel = 'Read';
          
                   
          // Add objects to list for insert
            ProResShrs.add(rsShr4);
            }
          }
          }
         
          if(Resourcetoshare.size()>0){
          for(IPM_Project_Resource__c ProRes:Resourcetoshare){
          if(ProRes.IPM_Role_Type__c !=ipmrsource.IPM_Role_Type__c){
          // Instantiate the sharing objects
            IPM_Project_Resource__Share rsShr3;
            rsShr3 = new IPM_Project_Resource__Share();
                        
            // Set the ID of record being shared
            rsShr3.ParentId = ipmrsource.Id;
           // Set the ID of user or group being granted access
            rsShr3.UserOrGroupId = ProRes.IPM_User__c;
           // Set the access level
          
           rsShr3.AccessLevel = 'Read';
                              
          // Add objects to list for insert
            ProResShrs.add(rsShr3);
          }
         }
         }  
        }
        //document section
            list<IPM_User_Profile__c>lstUProfile=[Select IPM_User__c,IPM_User_Category__c,IPM_Company_Card__c,IPM_Work_Level__c from IPM_User_Profile__c where IPM_Work_Level__c='WL2+' and IPM_Company_Card__c=:IPMPro[0].IPM_Company_Card__c and IPM_User__c Not IN:DupUser and IPM_User__r.IsActive=true];
            list<IPM_Project_Document__c> ProDocs= [SELECT IPM_Project__c FROM IPM_Project_Document__c where IPM_Project__c IN:proId];
            set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:proId])).keyset();
            list<IPM_Project_Document_Section__c>lstsection =[select id,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c IN:ProDocid ];
            set<id>Sectionid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:proId])).keyset();
            list<IPM_Project_Document_Section_Content__c>lstProDocContent=[select IPM_Project_Document_Section__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:Sectionid];
            map<id,string>sectionmap=new map<id,string>(); 
            for(IPM_Project_Resource__c ipmre:trigger.new){
               for(IPM_Company_Card__c cc:lstCC){
                for(IPM_User_Profile__c up:lstUProfile){
                    if(cc.IPM_Managed_Category__c.contains(up.IPM_User_Category__c) && up.IPM_User__c!=userinfo.getuserid()){
                      IPM_Project_Resource__Share Resshr=  new IPM_Project_Resource__Share();
                      Resshr.parentid=ipmre.id;
                      Resshr.accesslevel='Read';
                      Resshr.UserOrGroupId=up.IPM_User__c;
                      ProResShrs.add(Resshr);
                    }
                }
             }
               for(id docid:ProDocid){
                ProDocShr=new IPM_Project_Document__Share();
                ProDocShr.ParentId=docid;
                ProDocShr.UserOrGroupId=ipmre.IPM_User__c;
                if(ipmre.IPM_Role_Type__c=='Guest'){
                ProDocShr.AccessLevel='read';
                }else{
                ProDocShr.AccessLevel='edit';
                }
               ProDocuments.add(ProDocShr);
               }
               if(lstsection.size()>0){

                for(IPM_Project_Document_Section__c prosecs: lstsection){
                ProSec=new IPM_Project_Document_Section__Share ();
                sectionmap.put(prosecs.id,prosecs.IPM_FunctionalRole__c);
                if(prosecs.IPM_FunctionalRole__c==ipmre.IPM_Role_Type__c){
                ProSec.ParentId=prosecs.id;
                ProSec.UserOrGroupId=ipmre.IPM_User__c;
                ProSec.AccessLevel='edit';
                ProDocSec.add(ProSec);
                }
                else if(ipmre.IPM_Role_Type__c=='Guest'){
                ProSec.ParentId=prosecs.id;
                ProSec.UserOrGroupId=ipmre.IPM_User__c;
                ProSec.AccessLevel='read';
                ProDocSec.add(ProSec);
                }else{
                ProSec.ParentId=prosecs.id;
                ProSec.UserOrGroupId=ipmre.IPM_User__c;
                ProSec.AccessLevel='read';
                ProDocSec.add(ProSec);
                }
              } 
            }
         if(lstProDocContent.size()>0){
           
           for(IPM_Project_Document_Section_Content__c IPMDoccon:lstProDocContent){
            IpmDocContent=new IPM_Project_Document_Section_Content__Share();
            if(sectionmap.get(IPMDoccon.IPM_Project_Document_Section__c)==ipmre.IPM_Role_Type__c){
                IpmDocContent.ParentId=IPMDoccon.Id;
                IpmDocContent.UserOrGroupId=ipmre.IPM_User__c;
                IpmDocContent.AccessLevel='Edit';
            }else{
                IpmDocContent.ParentId=IPMDoccon.Id;
                IpmDocContent.UserOrGroupId=ipmre.IPM_User__c;
                IpmDocContent.AccessLevel='Read';
            }
            ProDocContent.add(IpmDocContent);
           }
          }
        for(IPM_Financial__c fin:lstFin){
          IPM_Financial__Share  ipmfinshr=new IPM_Financial__Share();
          ipmfinshr.ParentId=fin.id;
          ipmfinshr.userorgroupid=ipmre.IPM_User__c;
          if(ipmre.IPM_Role_Type__c=='Finance'){
          ipmfinshr.accesslevel='Edit';
          }else{
          ipmfinshr.accesslevel='Read';
          }
          lstFinShr.add(ipmfinshr);
        }
        for(IPM_Project_Rollout__c rt:lstRollout){
          IPM_Project_Rollout__Share  IpmRollhr=new IPM_Project_Rollout__Share();
          IpmRollhr.ParentId=rt.id;
          IpmRollhr.userorgroupid=ipmre.IPM_User__c;
          IpmRollhr.accesslevel='Read';
          lstProRollShr.add(IpmRollhr);
        }
        }
 //end document 
        list<IPM_Questionnaire__c>lstQuests=[select id from IPM_Questionnaire__c where IPM_Project__c IN:ProId];
        if(lstQuests.size()>0){
            for(IPM_Project_Resource__c res:trigger.new){
                IPMQuestshr=new IPM_Questionnaire__Share();
                for(IPM_Questionnaire__c Quest:lstQuests){
                    IPMQuestshr.ParentId=Quest.id;
                    IPMQuestshr.UserOrGroupId=res.IPM_User__c;
                    if(res.IPM_Role_Type__c!='Guest'){
                    IPMQuestshr.AccessLevel='Edit';
                    }else{
                    IPMQuestshr.AccessLevel='Read';
                    }
                    IpmQuests.add(IPMQuestshr);
                }
            }
        }
        system.debug('ProResShrs....'+ProResShrs);
        
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
        if(lstFinShr.size()>0)
        insert lstFinShr;
        if(lstProRollShr.size()>0)
        insert lstProRollShr;
       //if(IpmQuests.size()>0)
       // insert IpmQuests;
    } 
if(trigger.isDelete){
    handler.DeleteshareLocalMember(trigger.oldmap);
    List<IPM_Project_Resource__Share> ProResShrs  = new List<IPM_Project_Resource__Share>();
    List<IPM_Project__Share> ProjectShrs  = new List<IPM_Project__Share>();
    List<IPM_Project_Document__Share>ProDocuments=new list<IPM_Project_Document__Share>();
    List<IPM_Task__Share>ProTaskShare=new list<IPM_Task__Share>();
    List<IPM_Project_Document_Section__Share>ProDocSec=new list<IPM_Project_Document_Section__Share>();
    List<IPM_Milestone__Share>mileshare=new list<IPM_Milestone__Share>();
    List<IPM_Bosscard__Share>IpmBossShare=new list<IPM_Bosscard__Share>();
    list<IPM_Project_Rollout__Share>lstProRollShr=new list<IPM_Project_Rollout__Share>();
   
    ProResShrs  = new List<IPM_Project_Resource__Share>();
    ProjectShrs  = new List<IPM_Project__Share>();
    ProDocuments=new list<IPM_Project_Document__Share>();
    ProTaskShare=new list<IPM_Task__Share>();
    ProDocSec=new list<IPM_Project_Document_Section__Share>();
    mileshare=new list<IPM_Milestone__Share>();
    list<IPM_Financial__Share>lstFinShr=new list<IPM_Financial__Share>();
    set<id>Project_id=new set<id>();
    set<id>UsersId=new set<id>();
    set<id>ResId=new set<id>();
    set<id>Bossid=new set<id>();
for(IPM_Project_Resource__c  ipmrsource : trigger.old){
 Project_id.add(ipmrsource.IPM_Project__c);
 UsersId.add(ipmrsource.IPM_User__c);
 ResId.add(ipmrsource .id);
}
        list<IPM_Project_Rollout__c>lstRollout=[select id,IPM_Project__c,Regional_Project__c from IPM_Project_Rollout__c where (IPM_Project__c IN:Project_id or Regional_Project__c IN:Project_id)];
        set<id>GRollid=new set<id>();
        for(IPM_Project_Rollout__c rout:lstRollout){
            if(rout.IPM_Project__c!=null){
                GRollid.add(rout.IPM_Project__c);
            }
            if(rout.Regional_Project__c!=null){
                GRollid.add(rout.Regional_Project__c);
            }
        }
    set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:Project_id])).keyset();
    set<id>ProDocSecid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:Project_id])).keyset();
    set<id>Tskid=(new map<id,IPM_Task__c>([Select id from IPM_Task__c where IPM_Project__c IN:Project_id])).keyset();
    set<id>Milesid=(new map<id,IPM_Milestone__c>([Select id from IPM_Milestone__c where IPM_Project__c IN:Project_id])).keyset();
    Bossid=(new map<id,IPM_Project__c>([Select IPM_Bosscard__c from IPM_Project__c where id IN:Project_id])).keyset();
    set<id>finid=(new map<id,IPM_Financial__c>([Select id from IPM_Financial__c where (Parent_Project__c IN:Project_id or Regional_Project__c IN:Project_id or Local_Project__c IN:Project_id)])).keyset();
    set<id>rollids=(new map<id,IPM_Project_Rollout__c>([Select id from IPM_Project_Rollout__c where (IPM_Project__c IN:GRollid or Regional_Project__c IN:GRollid)])).keyset();
    ProResShrs=[select id from IPM_Project_Resource__Share where ParentId IN:ResId and UserOrGroupId IN:UsersId];
    ProjectShrs=[select id from IPM_Project__Share where ParentId IN:Project_id and UserOrGroupId IN:UsersId];
    ProDocuments=[select id from IPM_Project_Document__Share where ParentId IN:ProDocid and UserOrGroupId IN:UsersId];
    ProTaskShare=[select id from IPM_Task__Share where ParentId IN:Tskid and UserOrGroupId IN:UsersId];
    ProDocSec=[select id from IPM_Project_Document_Section__Share where ParentId IN:ProDocSecid and UserOrGroupId IN:UsersId];
    mileshare=[select id from IPM_Milestone__Share where ParentId IN:Milesid and UserOrGroupId IN:UsersId];
    IpmBossShare=[select id from IPM_Bosscard__Share where ParentId IN:Bossid and UserOrGroupId IN:UsersId];
    lstFinShr=[select id from IPM_Financial__Share where ParentId IN:finid and UserOrGroupId IN:UsersId];
    lstProRollShr=[select id from IPM_Project_Rollout__Share where ParentId IN:rollids and UserOrGroupId IN:UsersId];
    if(ProResShrs.size()>0)
    delete ProResShrs;
    if(ProjectShrs.size()>0)
    delete ProjectShrs;
    if(ProDocuments.size()>0)
    delete ProDocuments;
    if(ProTaskShare.size()>0)
    delete ProTaskShare;
    if(ProDocSec.size()>0)
    delete ProDocSec;
    if(mileshare.size()>0)
    delete mileshare;
    if(IpmBossShare.size()>0)
    delete IpmBossShare;
    if(lstFinShr.size()>0)
    delete lstFinShr;
    if(lstProRollShr.size()>0)
    delete lstProRollShr;
}      
}