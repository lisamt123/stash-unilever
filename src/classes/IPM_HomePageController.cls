public with sharing class IPM_HomePageController 
{
    public List<IPM_Project__History> lstprojecthistory {get;set;}
    public Map<Id,IPM_Project__History> mapphistory {get; set;}
    public Map<String,String> alertMessage { get; set; }
    public IPM_Project__c project {get; set;}
    public integer taskcount {get;set;}
    public integer alertscount {get;set;}
    public String taskcountValue {get;set;}
    public String projectId;
    public integer overduetaskscount {get;set;}
    public boolean isProjectEditable{get;set;}
    public boolean isBossCardEditable{get;set;}
    public Boolean isBosscard {get; set;}
    public string projectLabel{get;set;}
public IPM_HomePageController()
{
isProjectEditable=false;
isBossCardEditable=false;
projectLabel='';
alertscount=0;
Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
isBosscard=false;
getusertype();
overduetaskscount =[SELECT count() FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() AND  IPM_Due_Date1__c <: System.today() And IPM_Completed__c = false];
taskcount =[SELECT count() FROM IPM_Task__c WHERE IPM_Assignee__c =: UserInfo.getUserId() AND  IPM_Due_Date1__c != null];
taskcountValue =String.valueOf(taskcount);
    lstprojecthistory=[SELECT ParentId,Parent.Name,Parent.IPM_Fast_Track_Project__c FROM IPM_Project__History WHERE Field = 'IPM_Fast_Track_Project__c' AND CreatedDate >=: System.today()-7];
     mapphistory=new Map<Id,IPM_Project__History>();
    for(IPM_Project__History ph:lstprojecthistory){
        if(!mapphistory.containsKey(ph.ParentId)){
            mapphistory.put(ph.ParentId,ph);
        }
    }

 List<IPM_Project__c> lstProjects =[Select Name,IPM_Bosscard_Status__c,IPM_Bosscard__r.IPM_Brand__c,IPMRegion__c,IPM_Bosscard__r.Name,IPM_Bosscard__r.IPM_Bosscard_Logo__c,IPM_Project_Logo__c,IPM_Brand__c,IPM_Category_Text__c,IPM_FilledIn_Percentage__c,IPM_Phase__c,IPM_Project_Name__c FROM IPM_Project__c WHERE  IPM_Project_Leader__c = : UserInfo.getUserId() and Is_Archieved__c = false Order By IPM_Project_Name__c];
        //List<IPM_Project_Document__c> lstProjectDocs=[select IPM_Approval_Date__c,IPM_Project__c,IPM_Project__r.IPM_Gate__c,IPM_GateDocuments__c from IPM_Project_Document__c where IPM_Project__c IN : lstProjects];
        Id recordtypeid=Schema.Sobjecttype.IPM_Milestone__c.getRecordTypeInfosByName().get('IPM Project Milestones').getRecordTypeId();
          List<IPM_Milestone__c> lstipmmilestones=[SELECT Id,IPM_Name__c,IPM_Project__c,IPM_Project__r.Name,IPM_Project__r.IPM_Phase__c,IPM_Due_Date__c,IPM_Planned_Date__c,IPM_Completed_On__c,IPM_Phase__c FROM IPM_Milestone__c WHERE IPM_Project__c IN : lstProjects and IPM_Type_of_Milestone__c = 'Standard' And RecordtypeId = : recordtypeid];
        Map<Id,String> mapdocsDate=new Map<Id,String>();
        alertMessage = new Map<String,String>();
        for(IPM_Milestone__c ipmmiles:lstipmmilestones){
                if(ipmmiles.IPM_Project__r.IPM_Phase__c == ipmmiles.IPM_Phase__c){
                    if(ipmmiles.IPM_Due_Date__c != null && Date.valueOf((System.now()).format('YYYY-MM-dd')).daysBetween(ipmmiles.IPM_Due_Date__c) <= 14){
                        if(IPM_Utils.phaseGateDocumentMap.containsKey(ipmmiles.IPM_Phase__c)) {
                       alertMessage.put(IPM_Utils.phaseGateDocumentMap.get(ipmmiles.IPM_Phase__c),Date.valueOf((System.now()).format('YYYY-MM-dd')).daysBetween(ipmmiles.IPM_Due_Date__c)+' days for '+ipmmiles.IPM_Project__r.Name+ipmmiles.IPM_Project__c);
                       }
                    } 
                }
            //}
        alertscount=alertMessage.size();
        }


}


public PageReference project()
{
PageReference page=new PageReference('/apex/ipmproject_1');
return page;
}

public PageReference bosscard()
{
isBosscard=true;
PageReference page=new PageReference('/apex/ipmbosscard_1');
return page;
} 
//get usertype 
public void getusertype(){
list<IPM_User_Profile__c>lstuserprofile=[select id,IPM_User_Role__c,IPM_User_Function__c,Export_Porfolio_Data__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid() and (IPM_User_Role__c!=null or IPM_User_Function__c!=null)];
system.debug('lstuserprofile....'+lstuserprofile);
if(lstuserprofile.size()>0){
    for(IPM_User_Profile__c up:lstuserprofile){
    /*if(up.IPM_User_Role__c =='BD' || up.IPM_User_Role__c =='CMI'|| up.IPM_User_Role__c =='CD' || up.IPM_User_Role__c =='Finance'|| up.IPM_User_Role__c =='Supply Chain' || up.IPM_User_Role__c =='R&D' || up.IPM_User_Function__c =='GateKeeper' || up.Export_Porfolio_Data__c ==true){
    isProjectEditable=false;
    }
    if(up.Export_Porfolio_Data__c ==true){
    isBossCardEditable=false;
    }else{
    isBossCardEditable=true;
    }*/
    if(up.IPM_User_Function__c=='Project Leader'){
        isProjectEditable=true;
        isBossCardEditable=true;
    }
    }
}
/*else{
 isProjectEditable=false;
 isBossCardEditable=false;
}*/
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
 isProjectEditable=true;
 isBossCardEditable=true;
 } 
/*   
List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() and name='System Administrator' LIMIT 1];
if(PROFILE .size()>0){
isProjectEditable=true;
isBossCardEditable=true;
}*/

if(isProjectEditable==true && isBossCardEditable==true){
projectLabel='Create new project';
}
else if(isProjectEditable==false && isBossCardEditable==true){
projectLabel='Create new bosscard';
}
} 

}