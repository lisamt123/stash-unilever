public class IPM_ProjDocumentSectionHstryController{

public IPM_Project__c project{get; set;}
public Id projectId{get; set;}
public IPM_Project_Document__c projectDoc {get; set;}
public sObject projSectionList{get; set;} 
public Id sectionId{get;set;}
public Boolean secHistory {get;set;}
public Boolean isTaskeditable{get;set;}
Public Boolean isAllTask{get;set;}

public IPM_ProjDocumentSectionHstryController() {
    try{
        isTaskeditable=false;
        isAllTask=false; 
        projectId=ApexPages.currentPage().getParameters().get('Id');
       // getIpmuserType();
        if(ApexPages.currentPage().getParameters().get('projDocSecId')!=NULL)
        {
            sectionId=ApexPages.currentPage().getParameters().get('projDocSecId');
            secHistory=true;
        }
        else
        {
            secHistory=false;
        }
        
        project=[Select Id,IPM_Phase__c,IPMProject_Span__c,Is_Archieved__c from IPM_Project__c where Id=:projectId]; 
        if(project.IPM_Phase__c=='Ideas')
            projectDoc=[Select Id,IPM_Document_Status__c,IPM_Approval_Date__c  from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Charter'];    
        else if(project.IPM_Phase__c=='Feasibility') 
            projectDoc=[Select Id,IPM_Document_Status__c,IPM_Approval_Date__c  from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Contract'];
        else if(project.IPM_Phase__c=='PLE') 
            projectDoc=[Select Id,IPM_Document_Status__c,IPM_Approval_Date__c from IPM_Project_Document__c where IPM_Project__c=:project.Id and IPM_GateDocuments__c='Market Deployment'];    
        projSectionList=[Select Id,IPM_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id Limit 1]; 
        
 

    
    }catch(exception e){}
    }
//Get User type for security   
/*
public void getIpmuserType(){
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
    isTaskeditable=true;
   // FunctionRole=lstProuser[0].IPM_Role_Type__c;
    //if(lstProuser[0].IPM_Role_Type__c=='BD Marketing')
    //FunctionRole='BD';
    }
    else {
    isTaskeditable=false;
    }
  } 
 list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,IPM_Project_Gatekeeper__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c from IPM_Project__c where 
                                         id=:projectId limit 1];
 system.debug('size................'+lstofuser.size());
 if(lstofuser.size()>0){
    if(lstofuser[0].IPM_Project_Leader__c==userinfo.getuserid()){
    isTaskeditable=true;
    isAllTask=true;  
    }else if(lstofuser[0].IPM_Project_Gatekeeper__c==userinfo.getuserid()){
    isTaskeditable=false;
    isAllTask=false;
    //isvisible=false;  
    }else if(lstofuser[0].Deputy_Project_Leader__c==userinfo.getuserid()){
    isTaskeditable=true;
    isAllTask=true;    
    }else if(lstofuser[0].IPM_Technical_Project_Leader__c==userinfo.getuserid()){
    isTaskeditable=true;
    isAllTask=true;  
    }
   }
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
  isTaskeditable=true;
  isAllTask=true; 
 }                                         
} */       
}