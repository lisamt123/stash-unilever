Public class IPM_PermissionSet{
    Public id UProfileId{get;set;}
    public id UserId {set; get;}
    public string userRole{get;set;}
    public string userFunction{get;set;}
    public boolean isCentralTeam{get;set;}
    public boolean isReporting{get;set;}
    public IPM_PermissionSet(ID Pid,Id Uid,String UseR,String UserF,boolean isCTeam,boolean isRpt) {
        UProfileId = Pid;
        UserId = Uid;
        userRole=UseR;
        userFunction=UserF;
        isCentralTeam=isCTeam;
        isReporting=isRpt;
    }


@future(callout=true)
public static void addPermissionToUser(List<String> lstUserProfile){
    List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
        
    PermissionSet Fps=new PermissionSet();
    Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Finance_Team'];
    PermissionSet PLps=new PermissionSet();
    PLps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_ProjectLeader'];
    PermissionSet BPps=new PermissionSet();
    BPps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Business_Partners'];
    PermissionSet Reportingps=new PermissionSet();
    Reportingps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Reporting'];
    PermissionSet DeputyBPps=new PermissionSet();
    DeputyBPps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Business_Partners'];
    PermissionSet IPMNGBasic=new PermissionSet();
    IPMNGBasic=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
    PermissionSet centralteam=new PermissionSet();
    centralteam=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Central_Team'];
    PermissionSet Gatek=new PermissionSet();
    Gatek=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Gatekeeper']; 
               
    IPM_PermissionSet curruser =null;
    map<string,String>userPerMap=new map<string,String>();
    for(string udetails:lstUserProfile){
        curruser = (IPM_PermissionSet) JSON.deserialize(udetails, IPM_PermissionSet.class);
        system.debug('user........'+curruser.UserId);
         system.debug('user........'+curruser.userFunction);
         system.debug('user........'+curruser.userRole);
        if(curruser.userRole!=null){
          userPerMap.put(curruser.userRole,curruser.UserId);
        }
        if(curruser.userFunction!=null){
         userPerMap.put(curruser.userFunction,curruser.UserId);
        }
        if(curruser.isCentralTeam==true){
        userPerMap.put('Central Team',curruser.UserId);
        }
        if(curruser.isReporting==true){
        userPerMap.put('Reporting',curruser.UserId);
        }
        if(curruser.userRole==null && curruser.userFunction==null && curruser.isCentralTeam==false && curruser.isReporting==false){
        userPerMap.put('None',curruser.UserId);
        }
       
    }
   system.debug('hhhhh......'+userPerMap);
   list<string>ToUpdateuserPer1=userPerMap.values();
   set<string>ToUpdateuserPer=new set<string>();
   for(string s:ToUpdateuserPer1){
       ToUpdateuserPer.add(s);
   }
   if(ToUpdateuserPer.size()>0){
     for(string addper:ToUpdateuserPer){
          //PermissionSetAssignment sobject
         boolean isIPNGBasic=false;
         if(userPerMap.containskey('BD')  || userPerMap.containskey('CD') || userPerMap.containskey('BB') || userPerMap.containskey('CMI') || userPerMap.containskey('Supply Chain') || userPerMap.containskey('R&D')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = IPMNGBasic.id; //set the permission set Id
         newPSA.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA); 
         isIPNGBasic=true;
         }
         if(userPerMap.containskey('Gatekeeper')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = Gatek.id; //set the permission set Id
         newPSA.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA); 
         if(isIPNGBasic==false){
         PermissionSetAssignment newPSA1 = new PermissionSetAssignment();
         newPSA1.PermissionSetId = IPMNGBasic.id; //set the permission set Id
         newPSA1.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA1);
         isIPNGBasic=true;
         }
         }
         if(userPerMap.containskey('Finance')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = Fps.id; //set the permission set Id
         newPSA.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA); 
         if(isIPNGBasic==false){
         PermissionSetAssignment newPSA1 = new PermissionSetAssignment();
         newPSA1.PermissionSetId = IPMNGBasic.id; //set the permission set Id
         newPSA1.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA1);
         isIPNGBasic=true;
         }
         }
         if(userPerMap.containskey('Project Leader')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = PLps.id; //set the permission set Id
         newPSA.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA); 
         if(isIPNGBasic==false){
         PermissionSetAssignment newPSA1 = new PermissionSetAssignment();
         newPSA1.PermissionSetId = IPMNGBasic.id; //set the permission set Id
         newPSA1.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA1);
         isIPNGBasic=true;
         }
         }
         if(userPerMap.containskey('Business Partner')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = BPps.id; //set the permission set Id
         newPSA.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA); 
         if(isIPNGBasic==false){
         PermissionSetAssignment newPSA1 = new PermissionSetAssignment();
         newPSA1.PermissionSetId = IPMNGBasic.id; //set the permission set Id
         newPSA1.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA1);
         isIPNGBasic=true;
         }
         }
         if(userPerMap.containskey('Reporting')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = Reportingps.id; //set the permission set Id
         newPSA.AssigneeId = addper;//set the User Id
         newPermissionSetAccess.add(newPSA); 
         }
         if(userPerMap.containskey('Deputy Business Partner')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = DeputyBPps.id; //set the permission set Id
         newPSA.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA); 
         if(isIPNGBasic==false){
         PermissionSetAssignment newPSA1 = new PermissionSetAssignment();
         newPSA1.PermissionSetId = IPMNGBasic.id; //set the permission set Id
         newPSA1.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA1);
         isIPNGBasic=true;
         }
         }
         if(userPerMap.containskey('Central Team')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = centralteam.id; //set the permission set Id
         newPSA.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA); 
         if(isIPNGBasic==false){
         PermissionSetAssignment newPSA1 = new PermissionSetAssignment();
         newPSA1.PermissionSetId = IPMNGBasic.id; //set the permission set Id
         newPSA1.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA1);
         isIPNGBasic=true;
         }
         }
         if(userPerMap.containskey('None')){
         PermissionSetAssignment newPSA = new PermissionSetAssignment();
         newPSA.PermissionSetId = IPMNGBasic.id; //set the permission set Id
         newPSA.AssigneeId = addper; //set the User Id
         newPermissionSetAccess.add(newPSA); 
         }
     }  
   }
   upsert newPermissionSetAccess; 
}
@future(callout=true)
public static void DeletePermissionToUser(List<String> lstUserProfile){
    List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
        
    PermissionSet Fps=new PermissionSet();
    Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Finance_Team'];
    PermissionSet PLps=new PermissionSet();
    PLps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_ProjectLeader'];
    PermissionSet BPps=new PermissionSet();
    BPps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Business_Partners'];
    PermissionSet Reportingps=new PermissionSet();
    Reportingps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Reporting'];
    PermissionSet DeputyBPps=new PermissionSet();
    DeputyBPps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Business_Partners'];
    PermissionSet IPMNGBasic=new PermissionSet();
    IPMNGBasic=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
    PermissionSet centralteam=new PermissionSet();
    centralteam=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Central_Team'];
    PermissionSet Gatek=new PermissionSet();
    Gatek=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Gatekeeper']; 
    IPM_PermissionSet curruser =null;
    map<string,String>userPerMap=new map<string,String>();
    for(string udetails:lstUserProfile){
        curruser = (IPM_PermissionSet) JSON.deserialize(udetails, IPM_PermissionSet.class);
        system.debug('user........'+curruser.UserId);
      if(curruser.userRole!=null){
          userPerMap.put(curruser.userRole,curruser.UserId);
        }
        if(curruser.userFunction!=null){
         userPerMap.put(curruser.userFunction,curruser.UserId);
        }
        if(curruser.isCentralTeam==true){
        userPerMap.put('Central Team',curruser.UserId);
        }
        if(curruser.isReporting==true){
        userPerMap.put('Reporting',curruser.UserId);
        }
        if(curruser.userRole==null && curruser.userFunction==null && curruser.isCentralTeam==false && curruser.isReporting==false){
        userPerMap.put('None',curruser.UserId);
        }
       
    }
   system.debug('hhhhh......'+userPerMap);
   list<string>ToUpdateuserPer1=userPerMap.values();
   set<string>ToUpdateuserPer=new set<string>();
   for(string s:ToUpdateuserPer1){
       ToUpdateuserPer.add(s);
   }
  
   if(ToUpdateuserPer.size()>0){
   
     for(string addper:ToUpdateuserPer){
            boolean isipmngbasic=false;
            if(userPerMap.containskey('BD')  || userPerMap.containskey('CD') || userPerMap.containskey('BB') || userPerMap.containskey('CMI') || userPerMap.containskey('Supply Chain') || userPerMap.containskey('R&D')){
                 PermissionSetAssignment delPSA = new PermissionSetAssignment();
                 delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA );
                 isipmngbasic=true;
             }
             if(userPerMap.containskey('Gatekeeper')){
                 PermissionSetAssignment delPSA = new PermissionSetAssignment();
                 delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :Fps.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA );
                 if(isipmngbasic==false){
                 PermissionSetAssignment delPSA1 = new PermissionSetAssignment();
                 delPSA1 =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA1 );
                 isipmngbasic=true;
                 }
             }
             if(userPerMap.containskey('Finance')){
                 PermissionSetAssignment delPSA = new PermissionSetAssignment();
                 delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :Fps.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA );
                 if(isipmngbasic==false){
                 PermissionSetAssignment delPSA1 = new PermissionSetAssignment();
                 delPSA1 =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA1 );
                 isipmngbasic=true;
                 }
             }
            if(userPerMap.containskey('Project Leader')){
                  PermissionSetAssignment delPSA = new PermissionSetAssignment();
                  delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :PLps.Id and AssigneeId=:addper];
                  newPermissionSetAccess.add(delPSA );
                  if(isipmngbasic==false){
                 PermissionSetAssignment delPSA1 = new PermissionSetAssignment();
                 delPSA1 =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA1 );
                 isipmngbasic=true;
                 }
             }
            if(userPerMap.containskey('Business Partner')){
                   PermissionSetAssignment delPSA = new PermissionSetAssignment();
                   delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :BPps.Id and AssigneeId=:addper];
                   newPermissionSetAccess.add(delPSA );
                   if(isipmngbasic==false){
                 PermissionSetAssignment delPSA1 = new PermissionSetAssignment();
                 delPSA1 =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA1 );
                 isipmngbasic=true;
                 }
             }
             if(userPerMap.containskey('Reporting')){
                  PermissionSetAssignment delPSA = new PermissionSetAssignment();
                  delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :Reportingps.Id and AssigneeId=:addper];
                  newPermissionSetAccess.add(delPSA );
             }
             if(userPerMap.containskey('Deputy Business Partner')){
                  PermissionSetAssignment delPSA = new PermissionSetAssignment();
                  delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :centralteam.Id and AssigneeId=:addper];
                  newPermissionSetAccess.add(delPSA );
                  if(isipmngbasic==false){
                 PermissionSetAssignment delPSA1 = new PermissionSetAssignment();
                 delPSA1 =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA1 );
                 isipmngbasic=true;
                 }
             }
             if(userPerMap.containskey('None')){
                  PermissionSetAssignment delPSA = new PermissionSetAssignment();
                  delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:addper];
                  newPermissionSetAccess.add(delPSA );
             }
             if(userPerMap.containskey('Central Team')){
                  PermissionSetAssignment delPSA = new PermissionSetAssignment();
                  delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :centralteam.Id and AssigneeId=:addper];
                  newPermissionSetAccess.add(delPSA );
                  if(isipmngbasic==false){
                 PermissionSetAssignment delPSA1 = new PermissionSetAssignment();
                 delPSA1 =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:addper];
                 newPermissionSetAccess.add(delPSA1 );
                 isipmngbasic=true;
                 }
             }
             
   }
   delete newPermissionSetAccess; 
}
}

@future(callout=true)
public static void addPermissionToBP(map<id,id> lstCC){
List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
PermissionSet BPps=new PermissionSet();
BPps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Business_Partners'];
PermissionSet Reportingps=new PermissionSet();
PermissionSet IPMNGBasic=new PermissionSet();
IPMNGBasic=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
map<id,id>BPtoCC=new map<id,id>();
for(id udetails:lstCC.values()){
     PermissionSetAssignment newPSA = new PermissionSetAssignment();
     newPSA.PermissionSetId = BPps.id; //set the permission set Id
     newPSA.AssigneeId = udetails; //set the User Id
     newPermissionSetAccess.add(newPSA); 
     
     PermissionSetAssignment newPSA1 = new PermissionSetAssignment();
     newPSA1.PermissionSetId = IPMNGBasic.id; //set the permission set Id
     newPSA1.AssigneeId = udetails; //set the User Id
     newPermissionSetAccess.add(newPSA1);
 }
if(newPermissionSetAccess.size()>0){
insert newPermissionSetAccess;
}
}
@future(callout=true)
public static void DeleteBPPermission(map<id,id> lstCC){
List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
PermissionSet BPps=new PermissionSet();
BPps=[SELECT Id FROM PermissionSet WHERE Name = 'IPM_Business_Partners'];
PermissionSet Reportingps=new PermissionSet();
PermissionSet IPMNGBasic=new PermissionSet();
IPMNGBasic=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic'];
map<id,id>BPtoCC=new map<id,id>();
for(id udetails:lstCC.values()){
      PermissionSetAssignment delPSA = new PermissionSetAssignment();
      delPSA =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :BPps.Id and AssigneeId=:udetails];
      newPermissionSetAccess.add(delPSA );
      PermissionSetAssignment delPSA1 = new PermissionSetAssignment();
      delPSA1 =[SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId= :IPMNGBasic.Id and AssigneeId=:udetails];
      newPermissionSetAccess.add(delPSA1 );
 }
if(newPermissionSetAccess.size()>0){
delete newPermissionSetAccess;
}
}
@future(callout=true)
public static void ShareWithBP(map<id,id> lstCC){
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
list<IPM_Project__c>lstproject=[select id,IPM_Bosscard__c from IPM_Project__c where IPM_Company_Card__c IN:lstCC.keyset()];
set<id>IPMProId=(new Map<id,IPM_Project__c>([select id from IPM_Project__c where IPM_Company_Card__c IN:lstCC.keyset()])).keyset();
set<id>ResId=(new map<id,IPM_Project_Resource__c>([Select id from IPM_Project_Resource__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>ProDocSecid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:IPMProId])).keyset();
set<id>Tskid=(new map<id,IPM_Task__c>([Select id from IPM_Task__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>Milesid=(new map<id,IPM_Milestone__c>([Select id from IPM_Milestone__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>setProDocContent=(new map<id,IPM_Project_Document_Section_Content__c>([select id from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:ProDocSecid])).keyset();
set<id>setQuests=(new map<id,IPM_Questionnaire__c>([select id from IPM_Questionnaire__c where IPM_Project__c IN:IPMProId])).keyset();

for(id BPUPermission:lstCC.values()){
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
@future(callout=true)
public static void DeleteShareWithBP(map<id,id> lstCC){
List<IPM_Project_Resource__Share> ProResShrs  = new List<IPM_Project_Resource__Share>();
List<IPM_Project__Share> ProjectShrs  = new List<IPM_Project__Share>();
List<IPM_Project_Document__Share>ProDocuments=new list<IPM_Project_Document__Share>();
List<IPM_Task__Share>ProTaskShare=new list<IPM_Task__Share>();
List<IPM_Project_Document_Section__Share>ProDocSec=new list<IPM_Project_Document_Section__Share>();
List<IPM_Milestone__Share>mileshare=new list<IPM_Milestone__Share>();
List<IPM_Bosscard__Share>IpmBossShare=new list<IPM_Bosscard__Share>();
    
set<id>IPMProId=(new Map<id,IPM_Project__c>([select id from IPM_Project__c where IPM_Company_Card__c IN:lstCC.keyset()])).keyset();
set<id>ResId=(new map<id,IPM_Project_Resource__c>([Select id from IPM_Project_Resource__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>ProDocid=(new map<id,IPM_Project_Document__c>([Select id from IPM_Project_Document__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>ProDocSecid=(new map<id,IPM_Project_Document_Section__c>([Select id from IPM_Project_Document_Section__c where IPM_Project_ID__c IN:IPMProId])).keyset();
set<id>Tskid=(new map<id,IPM_Task__c>([Select id from IPM_Task__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>Milesid=(new map<id,IPM_Milestone__c>([Select id from IPM_Milestone__c where IPM_Project__c IN:IPMProId])).keyset();
set<id>setProDocContent=(new map<id,IPM_Project_Document_Section_Content__c>([select id from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c IN:ProDocSecid])).keyset();
set<id>setQuests=(new map<id,IPM_Questionnaire__c>([select id from IPM_Questionnaire__c where IPM_Project__c IN:IPMProId])).keyset();

set<id>Bossid=(new map<id,IPM_Project__c>([Select IPM_Bosscard__c from IPM_Project__c where id IN:IPMProId])).keyset();
ProResShrs=[select id from IPM_Project_Resource__Share where ParentId IN:ResId and UserOrGroupId IN:lstCC.values()];
ProjectShrs=[select id from IPM_Project__Share where ParentId IN:IPMProId and UserOrGroupId IN:lstCC.values()];
ProDocuments=[select id from IPM_Project_Document__Share where ParentId IN:ProDocid and UserOrGroupId IN:lstCC.values()];
ProTaskShare=[select id from IPM_Task__Share where ParentId IN:Tskid and UserOrGroupId IN:lstCC.values()];
ProDocSec=[select id from IPM_Project_Document_Section__Share where ParentId IN:ProDocSecid and UserOrGroupId IN:lstCC.values()];
mileshare=[select id from IPM_Milestone__Share where ParentId IN:Milesid and UserOrGroupId IN:lstCC.values()];
IpmBossShare=[select id from IPM_Bosscard__Share where ParentId IN:Bossid and UserOrGroupId IN:lstCC.values()];
    
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
}
}