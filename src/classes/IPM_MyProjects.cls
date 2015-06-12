public with sharing class IPM_MyProjects
{
    
 public String projectId{get;set;}
 public integer projectcount {get;set;}
 public Map<String,integer> alertMessage {get;set;}
 
    public IPM_MyProjects(IPM_HomePageController controller) {
        alertMessage=new Map<String,integer>();
        getProjects();
    }
    
    
    public IPM_MyProjects() {
        alertMessage=new Map<String,integer>();
        
    }
    
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                projectId = ApexPages.currentPage().getParameters().get('id');
                con = new ApexPages.StandardSetController(Database.getQueryLocator(
                                        [SELECT IPM_Approval_Date__c,IPM_Project__r.IPMRegion__c,IPM_Project__r.IPM_Project_Logo__c,IPM_Project__r.IPM_Brand__c,IPM_Project__r.IPM_Category_Text__c,IPM_Project__r.IPM_FilledIn_Percentage__c,IPM_Project__r.IPM_Phase__c,IPM_Project__r.IPM_Project_Name__c,IPM_Project__c FROM IPM_Project_Document__c WHERE IPM_Project__r.IPM_Project_Leader__c = : UserInfo.getUserId() and IPM_Project__r.Is_Archieved__c = false ]));
                // sets the number of records in each page set
                //con.setPageSize(10);
            }
            return con;
        }
        set;
    }
    
    // returns a list of wrapper objects for the sObjects in the current page set
    /*public List<IPM_Project_Document__c> getProjects() {
    
        List<IPM_Project_Document__c> lstProjects= new List<IPM_Project_Document__c>();
        if(con != null){
        for(IPM_Project_Document__c a : (List<IPM_Project_Document__c>)con.getRecords())
            lstProjects.add(a);
            
        return lstProjects;
        }else{
            return null;
        }
     }*/
     
     public List<ProjectWrapper> getProjects() {
         projectcount =0; 
        set<string>setofProid=new set<string>(); 
        list<IPM_Project__share>Proid=[select ParentID from IPM_Project__share where userOrGroupid=:userinfo.getuserid()];
        for(IPM_Project__share res:Proid){
            setofProid.add(res.ParentID);
        }
        List<IPM_Project__c> lstProjects =[Select Name,IPM_Bosscard_Status__c,IPM_Bosscard__r.IPM_Brand__c,IPM_Bosscard__r.IPM_Filled_In_Percent__c,IPMRegion__c,IPM_Bosscard__r.Name,IPM_Bosscard__r.IPM_Bosscard_Logo__c,IPM_Project_Logo__c,IPM_Brand__c,IPM_Category_Text__c,IPM_FilledIn_Percentage__c,IPM_Phase__c,IPM_Project_Name__c FROM IPM_Project__c WHERE  (IPM_Project_Leader__c = : UserInfo.getUserId() or ID IN:setofProid or IPM_Bosscard__r.OwnerId = :UserInfo.getUserId()) and Is_Archieved__c = false Order By Name];
        //List<IPM_Project__c> lstProjects =[Select Name,IPM_Bosscard_Status__c,IPM_Bosscard__r.IPM_Brand__c,IPMRegion__c,IPM_Bosscard__r.Name,IPM_Bosscard__r.IPM_Bosscard_Logo__c,IPM_Project_Logo__c,IPM_Brand__c,IPM_Category_Text__c,IPM_FilledIn_Percentage__c,IPM_Phase__c,IPM_Project_Name__c FROM IPM_Project__c WHERE createddate=: System.today() and Is_Archieved__c = false];
        
        //List<IPM_Project_Document__c> lstProjectDocs=[select IPM_Approval_Date__c,IPM_Project__c,IPM_Project__r.IPM_Gate__c,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c IN : lstProjects];
        Id recordtypeid=Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
        User usr=[Select Id,IPM_Role__c from User where Id=: UserInfo.getUserId()];
        List<IPM_Project_Resource__c> presource=[select IPM_Project__c from IPM_Project_Resource__c where IPM_Role__c = :usr.IPM_Role__c  and IPM_User__c = : UserInfo.getUserId()];
        
        if(!presource.isEmpty()){
            List<Id> projectIds=new List<Id>();
            for(IPM_Project_Resource__c res:presource){
                projectIds.add(res.IPM_Project__c);
            }
            List<IPM_Project__c> updProjects=[Select Name,IPM_Bosscard_Status__c,IPM_Bosscard__r.IPM_Brand__c,IPM_Bosscard__r.IPM_Filled_In_Percent__c,IPMRegion__c,IPM_Bosscard__r.Name,IPM_Bosscard__r.IPM_Bosscard_Logo__c,IPM_Project_Logo__c,IPM_Brand__c,IPM_Category_Text__c,IPM_FilledIn_Percentage__c,IPM_Phase__c,IPM_Project_Name__c FROM IPM_Project__c WHERE Id IN : projectIds Order By Name];
            if(!updProjects.isEmpty()){
                lstProjects.addAll(updProjects);
            }
        }
        
          List<IPM_Milestone__c> lstipmmilestones=[SELECT Id,IPM_Name__c,IPM_Project__c,IPM_Project__r.Name,IPM_Project__r.IPM_Phase__c,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Completed_On__c,IPM_Phase__c FROM IPM_Milestone__c WHERE IPM_Project__c IN : lstProjects and IPM_Type_of_Milestone__c = 'Standard' And RecordtypeId = : recordtypeid];
        Map<Id,String> mapdocsDate=new Map<Id,String>();
        
        for(IPM_Milestone__c ipmmiles:lstipmmilestones){
            /*if(mapdocsDate.get(projDocs.IPM_Project__c) != null){
                if(projDocs.IPM_GateDocuments__c == 'Charter'){
                    mapdocsDate.put(projDocs.IPM_Project__c,projDocs.IPM_Approval_Date__c);
                }
            }*/
            //if(projDocs.IPM_Project__r.IPM_Gate__c == projDocs.IPM_GateDocuments__c){
                if(ipmmiles.IPM_Project__r.IPM_Phase__c == ipmmiles.IPM_Phase__c){
                    if(ipmmiles.IPM_Due_Date__c != null && Date.valueOf((System.now()).format('YYYY-MM-dd')).daysBetween(ipmmiles.IPM_Due_Date__c) <= 14){
                        if(IPM_Utils.phaseGateDocumentMap.containsKey(ipmmiles.IPM_Phase__c)) {
                       alertMessage.put(ipmmiles.IPM_Project__r.Name+IPM_Utils.phaseGateDocumentMap.get(ipmmiles.IPM_Phase__c),Date.valueOf((System.now()).format('YYYY-MM-dd')).daysBetween(ipmmiles.IPM_Due_Date__c));
                       }
                    } 
                    mapdocsDate.put(ipmmiles.IPM_Project__c,ipmmiles.IPM_Due_Date__c+','+ipmmiles.IPM_Name__c);
                }
            //}
        }
        List<ProjectWrapper> projects=new List<ProjectWrapper>();
        for(IPM_Project__c proj:lstProjects){
            projects.add(new ProjectWrapper(proj, mapdocsDate.get(proj.Id)));
            projectcount ++;
        }
        
        return projects;
        
        //return null;
     }
     
     public class ProjectWrapper {
     
         public IPM_Project__c projectObj{get;set;}
         public String projectDocumentDate{get;set;}
         public String phaseValue{get;set;}
         
         public ProjectWrapper(IPM_Project__c p, String d) {
            projectObj = p;
            if(d != null){
                String[] datephase=d.split(',');
                System.debug('\n datephase'+datephase);
                if(datephase[0] != 'null'){
                    System.debug('\n g'+datephase[0]);
                    projectDocumentDate = date.valueOf(datephase[0]).format();
                }
                phaseValue=datephase[1];
                
            }
        }
     }
     
     
    
    
     
}