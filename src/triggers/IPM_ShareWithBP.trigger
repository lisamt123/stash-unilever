/*Created by:Rajesh Kumar
Description:share all object records to business partner user related with same company
Date-29-01-2015
*/
trigger IPM_ShareWithBP on IPM_User_Profile__c (after insert) {
    List<IPM_Project_Resource__Share> ProResShrs  = new List<IPM_Project_Resource__Share>();
    List<IPM_Project__Share> ProjectShrs  = new List<IPM_Project__Share>();
    List<IPM_Project_Document__Share>ProDocuments=new list<IPM_Project_Document__Share>();
    List<IPM_Task__Share>ProTaskShare=new list<IPM_Task__Share>();
    List<IPM_Project_Document_Section__Share>ProDocSec=new list<IPM_Project_Document_Section__Share>();
    List<IPM_Project_Document_Section_Content__Share>ProDocContent=new list<IPM_Project_Document_Section_Content__Share>();
    List<IPM_Milestone__Share>ProMiles=new list<IPM_Milestone__Share>();
    List<IPM_Questionnaire__Share>IpmQuests=new list<IPM_Questionnaire__Share>();
    List<IPM_Bosscard__Share>IpmBossShare=new list<IPM_Bosscard__Share>();
    
    IPM_Bosscard__Share Bossshare;
    IPM_Project_Document__Share ProDocShr;
    IPM_Project__Share ipmProshr;
    IPM_Project_Document_Section__Share ProSec;
    IPM_Task__Share ProTskShare;
    IPM_Project_Document_Section_Content__Share IpmDocContent;
    IPM_Milestone__Share IpmMilesShr;
    IPM_Project_Resource__Share rsShr;
    IPM_Questionnaire__Share IPMQuestshr;
set<id>UserSet=new set<id>();
if(trigger.isInsert){
    for(IPM_User_Profile__c Uprofile:trigger.new){
        if(Uprofile.IPM_Business_Partner__c==true || Uprofile.IPM_Deputy_Business_Partner__c==true){
            UserSet.add(Uprofile.IPM_User__c);
        }
    }
//Query user object to get category
map<id,string>UserMapCat=new map<id,String>();
set<string>UserCategory=new set<string>();
list<user>lstuser=[select id,IPM_Category__c from user where id=:UserSet];
if(lstuser.size()>0){
    for(User UBP:lstuser){
        if(UBP.IPM_Category__c !=null){
        UserMapCat.put(UBP.id,UBP.IPM_Category__c);
        UserCategory.add(UBP.IPM_Category__c);
        }
    }
}
set<id>BPuser=UserMapCat.keyset();
list<IPM_Project__c>lstproject=[select id,IPM_Bosscard__c from IPM_Project__c where IPM_Category_Text__c IN:UserCategory];

set<id>IPMProId=(new Map<id,IPM_Project__c>([select id from IPM_Project__c where IPM_Category_Text__c IN:UserCategory])).keyset();
set<id>ResId=(new map<id,IPM_Project_Resource__c>([Select id from IPM_Project_Resource__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>ProDocSecid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:IPMProId])).keyset();
set<id>Tskid=(new map<id,IPM_Task__c>([Select id from IPM_Task__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>Milesid=(new map<id,IPM_Milestone__c>([Select id from IPM_Milestone__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>setProDocContent=(new map<id,IPM_Project_Document_Section_Content__c>([select id from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:ProDocSecid])).keyset();
set<id>setQuests=(new map<id,IPM_Questionnaire__c>([select id from IPM_Questionnaire__c where IPM_Project__c IN:IPMProId])).keyset();
if(BPuser.size()>0){
  for(id BPUPermission:BPuser){
  //Sharing Ipm project and booscard records
   for(IPM_Project__c Proids:lstproject){
       ipmProshr=new IPM_Project__Share();
       ipmProshr.parentId=Proids.id;
       ipmProshr.AccessLevel='Edit';
       ipmProshr.UserOrGroupId=BPUPermission;
       ProjectShrs.add(ipmProshr);
       
       if(Proids.IPM_Bosscard__c !=null){
       Bossshare=new IPM_Bosscard__Share();
       Bossshare.parentId=Proids.IPM_Bosscard__c ;
       Bossshare.AccessLevel='Edit';
       Bossshare.UserOrGroupId=BPUPermission;
       IpmBossShare.add(Bossshare);
       }
    }
   //Sharing IPM Resource records
   for(id Resourceid:ResId){
       rsShr=new IPM_Project_Resource__Share();
       rsShr.parentId=Resourceid;
       rsShr.AccessLevel='Edit';
       rsShr.UserOrGroupId=BPUPermission;
       ProResShrs.add(rsShr);  
    }
  //Sharing Project Document records
  for(id Docid:ProDocid){
      ProDocShr=new IPM_Project_Document__Share();
      ProDocShr.parentId=Docid;
      ProDocShr.AccessLevel='Edit';
      ProDocShr.UserOrGroupId=BPUPermission;
      ProDocuments.add(ProDocShr);  
  }
  //Sharing Project Document Section records
  for(id secid:ProDocSecid){
      ProSec=new IPM_Project_Document_Section__Share();
      ProSec.parentId=secid;
      ProSec.AccessLevel='Edit';
      ProSec.UserOrGroupId=BPUPermission;
      ProDocSec.add(ProSec);  
  }
  //Sharing Task records
  for(id taskid:Tskid){
     ProTskShare=new IPM_Task__Share ();  
     ProTskShare.parentId=taskid;
     ProTskShare.AccessLevel='Edit';
     ProTskShare.UserOrGroupId=BPUPermission;
     ProTaskShare.add(ProTskShare);  
  }
  //Sharing Milestone records
  for(id Mid:Milesid){
      IpmMilesShr=new IPM_Milestone__Share ();
      IpmMilesShr.parentId=Mid;
      IpmMilesShr.AccessLevel='Edit';
      IpmMilesShr.UserOrGroupId=BPUPermission;
      ProMiles.add(IpmMilesShr); 
  }
  //Sharing project document content records
  
  for(id DocCont:setProDocContent){
     IpmDocContent=new IPM_Project_Document_Section_Content__Share();
     IpmDocContent.parentId=DocCont;
     IpmDocContent.AccessLevel='Edit';
     IpmDocContent.UserOrGroupId=BPUPermission;
     ProDocContent.add(IpmDocContent);   
  }
  //Sharing Questionnaires records
  for(id QuesId:setQuests){
     IPMQuestshr=new IPM_Questionnaire__Share();
     IPMQuestshr.parentId=QuesId;
     IPMQuestshr.AccessLevel='Edit';
     IPMQuestshr.UserOrGroupId=BPUPermission;
     IpmQuests.add(IPMQuestshr);   
  }
  }  
       system.debug('ProjectShrs......'+ProjectShrs[262]);
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

}