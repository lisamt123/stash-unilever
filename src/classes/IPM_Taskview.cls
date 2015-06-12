public class IPM_Taskview {
        
        public IPM_Project__c IPM{set;get;}
        public List<SelectOption> options{set;get;}
        public id selectedpid{set;get;}
        public map<id,IPM_Project__c> pmap{set;get;}
        public String adhoc{get;set;}
        public Boolean pmApproachMessage{get;set;}
        //public list<projecttaskwrapper> projecttasks{set;get;}
        //public IPM_Project_Task__c ipt{set;get;}
        public Boolean isTaskeditable{get;set;}
        public Boolean isAllTask{get;set;}
        public Boolean isMilestoneEditable{get;set;}
        public Boolean isBDuser{get;set;}
        public Boolean isupdateDates{get;set;}
        public string FunctionRole{get;set;}      
        public boolean isvisible{get;set;}
        public id projectId{get;set;}
    public Ipm_Taskview (ApexPages.StandardController controller) {
        isupdateDates=true;
        isvisible=true;
        FunctionRole='';
        pmap=new map<id,IPM_Project__c>();
        //ipt=new IPM_Project_Task__c();
        //projecttasks=new list<projecttaskwrapper>();
        options = new List<SelectOption>();
        id fpid;
        integer cou=0;
       getIpmuserType();
        for (IPM_Project__c ip:[select id,IPM_Project_Name__c,IPM_Project_Description__c,IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Complexity__c from IPM_Project__c where IPM_Project_Name__c!=:null and Id =: apexpages.currentpage().getparameters().get('Id') limit 50000]) 
        {
            if(cou==0)
            {
            fpid=ip.id;
            cou=1;
            }
            pmap.put(ip.id,ip);
            
            options.add(new SelectOption(ip.id, ip.IPM_Project_Name__c));
        }
        set<id> temp=pmap.keyset();
        IPM=pmap.get(fpid);
        
    /*if(apexpages.currentpage().getparameters().get('adhoc') == 'true'){
        adhoc='&adhoc=true';
        for(IPM_Project_Task__c ipt:[select id,IPM_Task_Status__c,IPM_Task_Name__c,IPM_Task_Role__c,IPM_Project_Status_Icon__c,IPM_Project_Section__c,IPM_Task_Type__c,IPM_Project__c,IPM_Date__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Adhoc__c = true and IPM_Project__c=:apexpages.currentpage().getparameters().get('Id')])
            projecttasks.add(new projecttaskwrapper(ipt));
    }
    else{
        adhoc='';
        for(IPM_Project_Task__c ipt:[select id,IPM_Task_Status__c,IPM_Task_Name__c,IPM_Task_Role__c,IPM_Project_Status_Icon__c,IPM_Project_Section__c,IPM_Task_Type__c,IPM_Project__c,IPM_Date__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Project__c=:apexpages.currentpage().getparameters().get('Id') order By IPM_Task_Role__c  limit 50000])
            projecttasks.add(new projecttaskwrapper(ipt));
    }*/
  
    }
    
    
    public String getMileStoneAlerts(){
        String mileStoneName;
        IPM_Project__c proj=[select id,IPM_PM_Approach__c,IPM_Market_Type__c,IPM_Project_Name__c,IPM_Target_Launch_Dates__c,IPM_Fast_Track_Project__c,IPM_Project_Description__c,IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,IPM_Complexity__c from IPM_Project__c where Id =: apexpages.currentpage().getparameters().get('Id')];
        if(proj.IPM_PM_Approach__c == 'External'){
            pmApproachMessage=true;
        }
        if(!proj.IPM_Fast_Track_Project__c){
          List<IPM_Milestone__c> lstMileStones= [SELECT Id,IPM_Due_Date__c,IPM_Milestone__c,IPM_Name__c,IPM_Phase__c,IPM_Project__c FROM IPM_Milestone__c WHERE IPM_Project__c =: proj.Id and IPM_Phase__c = 'Capability' ];
          if(!lstMileStones.isEmpty()){
              for(IPM_Milestone__c mile:lstMileStones){
                  if(proj.IPM_Market_Type__c=='Developing'){
                      if(mile.IPM_Due_Date__c!=null){
                      if(mile.IPM_Due_Date__c.daysBetween(proj.IPM_Target_Launch_Dates__c) < 120){
                          mileStoneName='4 months';
                      }
                     } 
                  }else if(proj.IPM_Market_Type__c=='Developing & Emerging'){
                      if(mile.IPM_Due_Date__c!=null){
                      if(mile.IPM_Due_Date__c.daysBetween(proj.IPM_Target_Launch_Dates__c) < 180){
                          mileStoneName='6 months';
                      }
                     }
                  }
              }
          }
        }
        return mileStoneName;
    }
   /* public void projectchange()
    {
        projecttasks=new list<projecttaskwrapper>();
    IPM=pmap.get(selectedpid);
    
    if(apexpages.currentpage().getparameters().get('adhoc') == 'true'){
        for(IPM_Project_Task__c ipt:[select id,IPM_Task_Name__c,IPM_Task_Role__c,IPM_Project_Status_Icon__c,IPM_Project_Section__c,IPM_Task_Type__c,IPM_Project__c,IPM_Date__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Adhoc__c = true and IPM_Project__c=:apexpages.currentpage().getparameters().get('Id')])
            projecttasks.add(new projecttaskwrapper(ipt));
        }
    else{
        for(IPM_Project_Task__c ipt:[select id,IPM_Task_Name__c,IPM_Task_Role__c,IPM_Project_Status_Icon__c,IPM_Project_Section__c,IPM_Task_Type__c,IPM_Project__c,IPM_Date__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Project__c=:apexpages.currentpage().getparameters().get('Id') order By IPM_Task_Role__c  limit 50000])
            projecttasks.add(new projecttaskwrapper(ipt));
        }
    }*/
    
 public void getIpmuserType(){
 
 projectId=apexpages.currentpage().getparameters().get('Id');
 system.debug('id.......'+projectId);
// system.debug('function role.....'+Frole);
 list<IPM_Project_Resource__c>CountTaskSCUser=[select IPM_Role_Type__c,IPM_Project_Role_Owner__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid() and IPM_Role_Type__c='Supply Chain' limit 1];
 if(CountTaskSCUser.size()>0){
 isTaskeditable=true;
 isAllTask=true; 
 }                                        
 list<IPM_Project_Resource__c>lstProuser=[select IPM_Role_Type__c,IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c from IPM_Project_Resource__c where 
                                         IPM_Project__c=:projectId and IPM_User__c=:userinfo.getuserid()  limit 1];
 
 if(lstProuser.size()>0){
    
    if(lstProuser[0].IPM_Role_Type__c!='Guest'){
    isMilestoneEditable=true;
    isTaskeditable=true;
    FunctionRole=lstProuser[0].IPM_Role_Type__c;
    if(lstProuser[0].IPM_Role_Type__c=='BD Marketing')
    FunctionRole='BD';
    }
    else {
    isMilestoneEditable=false;
    isTaskeditable=false;
    }
   if(lstProuser[0].IPM_Role_Type__c=='BD' || lstProuser[0].IPM_Role_Type__c=='BD Marketing'){
    isBDuser=true;
    }
    if(lstProuser[0].IPM_Role_Type__c=='CMI' || lstProuser[0].IPM_Role_Type__c=='CD' || lstProuser[0].IPM_Role_Type__c=='Finance' || lstProuser[0].IPM_Role_Type__c=='Guest'){
    isupdateDates=false;
    }
  } 
 list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c from IPM_Project__c where 
                                         id=:projectId limit 1];
 system.debug('size................'+lstofuser.size());
 if(lstofuser.size()>0){
    if(lstofuser[0].IPM_Project_Leader__c==userinfo.getuserid()){
    isMilestoneEditable=true;
    isTaskeditable=true;
    isAllTask=true;  
    }else if(lstofuser[0].IPM_Project_Gatekeeper__c==userinfo.getuserid()){
    isMilestoneEditable=false;
    isTaskeditable=false;
    isupdateDates=false;
    isAllTask=false;
    isvisible=false;  
    }else if(lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid()){
    isMilestoneEditable=true;
    isTaskeditable=true;
    isAllTask=true;    
    }else if(lstofuser[0].IPM_Technical_Project_Leader__c==userinfo.getuserid()){
    isMilestoneEditable=true;
    isTaskeditable=true;
    isAllTask=true;  
    }
   }
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
 isMilestoneEditable=true;
 isTaskeditable=true;
 isAllTask=true; 
 }                                       
}    
 
   /* public void rolechange()
    {
        projecttasks=new list<projecttaskwrapper>();
        System.debug('\n Task Name:'+ipt.IPM_Task_Role__c);
        if(ipt.IPM_Task_Role__c != null){
            for(IPM_Project_Task__c ipt:[select id,IPM_Task_Name__c,IPM_Task_Role__c,IPM_Task_Status__c,IPM_Project_Section__c,IPM_Project_Status_Icon__c,IPM_Task_Type__c,IPM_Project__c,IPM_Date__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Project__c=:IPM.id and IPM_Task_Role__c=:ipt.IPM_Task_Role__c order By IPM_Task_Role__c  limit 50000])
            projecttasks.add(new projecttaskwrapper(ipt));
        }else{
            for(IPM_Project_Task__c ipt:[select id,IPM_Task_Name__c,IPM_Task_Role__c,IPM_Task_Status__c,IPM_Project_Section__c,IPM_Project_Status_Icon__c,IPM_Task_Type__c,IPM_Project__c,IPM_Date__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Project__c=:IPM.id order By IPM_Task_Role__c  limit 50000])
            projecttasks.add(new projecttaskwrapper(ipt));
        }
        
        
    }*/
     /*public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                     [select id,IPM_Task_Name__c,IPM_Task_Role__c,IPM_Date__c,IPM_Task_Type__c,IPM_Project_Section__c,IPM_Project_Status_Icon__c,IPM_Project__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Project__c=:apexpages.currentpage().getparameters().get('Id') and IPM_Task_Role__c=:ipt.IPM_Task_Role__c order By IPM_Task_Role__c  limit 50000]));
            }
            return setCon;
        }
        set;
    }*/
    /*public List<IPM_Project_Task__c> getprojecttasks() {
        List<IPM_Project_Task__c> lstTasks;
        

         if(apexpages.currentpage().getparameters().get('adhoc') == 'true'){
             lstTasks=[select id,IPM_Task_Name__c,IPM_Project__c,IPM_Project_Section__c,IPM_Project_Status_Icon__c,IPM_Task_Role__c,IPM_Date__c,IPM_Task_Type__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Project__c=:apexpages.currentpage().getparameters().get('Id') and IPM_Adhoc__c = true];
         }else{
             lstTasks=[select id,IPM_Task_Name__c,IPM_Project__c,IPM_Project_Section__c,IPM_Project_Status_Icon__c,IPM_Task_Role__c,IPM_Date__c,IPM_Task_Type__c,IPM_Assigned_To__c from IPM_Project_Task__c where IPM_Project__c=:apexpages.currentpage().getparameters().get('Id')];
         }
         System.debug('\n lstTasks:'+lstTasks);
         return lstTasks;
    }*/
    
    /* public void deletetasks()
        {
            list<projecttaskwrapper> newlist=new list<projecttaskwrapper>();
            list<IPM_Project_Task__c> dellist=new list<IPM_Project_Task__c>();
            for(projecttaskwrapper ptw:projecttasks)
            {
                if(ptw.delcheck==true)
                    dellist.add(ptw.ipt);
                else
                    newlist.add(ptw);
            }
            if(dellist.size()>0){
                delete dellist;
            }
            projecttasks=newlist;
        }*/
    
   /* public class projecttaskwrapper
    {
        
            public boolean delcheck{set;get;}
            public IPM_Project_Task__c IPT{set;get;}
            
            public projecttaskwrapper(){
                IPT = new IPM_Project_Task__c();
                delcheck = false;
            }
            
            public projecttaskwrapper(IPM_Project_Task__c task){
            IPT = task;
            delcheck = false;
        }
            
    }*/
}