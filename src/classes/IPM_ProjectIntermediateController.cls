/* Type Name: ipmProjectIntermediateController 
Author: 
Created Date:
Reason: Redirecting to Core Parameters, Task Generation, Project Scope, Team Members Pages
Change History:Added to fields to query. To be used in vf component "ipmProjectDetails" Removed Standard Controller
Author: Samrat Chakraborty
Modified Date: 15-10-2014  */
public with sharing class IPM_ProjectIntermediateController {
    
    //Initializing Variables
  
    public IPM_Project__c project {get; set;}
    public String projectId;
    public Boolean isImage{get; set;}
    public Boolean isDescVisible{get; set;}
    public String projectType;
    public string isBossID{get;set;}
    public list<IPM_Project__c>ProjectCoreParemeters=new list<IPM_Project__c>();
    public boolean isCoreParameter{get;set;}
    public boolean isPLeader{get;set;}
    public IPM_ProjectIntermediateController(){
      Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
        isBossID='';
        projectId=ApexPages.currentPage().getParameters().get('Id');
        if(projectId=='' || projectId==null)
        {
        projectId=ApexPages.currentPage().getParameters().get('Pid');
        }
        isBossID=ApexPages.currentPage().getParameters().get('IsBossID');
        projectType=ApexPages.currentPage().getParameters().get('isProject');
        isDescVisible=false;
        isCoreParameter=false;
       //ProjectCoreParemeters = [Select id, IPM_IsCompleted__c from IPM_Project__c where id =:projectId];
        if(ProjectCoreParemeters.size()>0){
         if(ProjectCoreParemeters[0].IPM_IsCompleted__c==true){
         isCoreParameter=true;
         }
       }
       IPM_Project__c IPM_proj =new IPM_Project__c();
      // IPM_proj=[select Deputy_Project_Leader__c,IPM_Project_Leader__c from IPM_Project__c where id=:projectId ];
      /* if(IPM_proj.Deputy_Project_Leader__c==userinfo.getuserid() || IPM_proj.IPM_Project_Leader__c==userinfo.getuserid() ){
         isPLeader=true; 
       }*/
       /**else if(IPM_proj.Deputy_Project_Leader__r.id==userinfo.getuserid()){
       isDPLeader=true;
       }
       if(IPM_proj.IPM_Project_Leader__c==userinfo.getuserid()){
        isPLeader=true;
       }**/
       
        if(projectType=='true')
            isDescVisible=true;
        if(projectId!=null)
      //  if(isBossID=='true'){
       //  project=[Select Id,IPM_Project_Name__c,IPM_Project_Description__c,IPM_Category_Text__c,IPM_Brand__c,IPM_Project_Logo__c,IPM_Brand_Positioning__c,IPM_Category__r.Name,IPM_Target_Launch_Date__c from IPM_Project__c where IPM_Bosscard__r.id=:projectId];
       // }else{
        project=[Select Id,IPM_Project_Name__c,IPM_Project_Description__c,IPM_Project_Leader__c,Deputy_Project_Leader__c,IPM_Category_Text__c,IPM_Brand__c,IPM_Project_Logo__c,IPM_Brand_Positioning__c,IPM_Category__r.Name,IPM_Target_Launch_Date__c,IPM_Phase__c from IPM_Project__c where Id=:projectId];
       // }
         if(project.Deputy_Project_Leader__c==userinfo.getuserid() || project.IPM_Project_Leader__c==userinfo.getuserid() ){
         isPLeader=true; 
       }
        if(project.IPM_Project_Logo__c !=null)
            isImage=true;
      
    }
      
    //Initializing Constructor
  /*  public ipmProjectIntermediateController(ApexPages.StandardController controller) {
        
        projectId=ApexPages.currentPage().getParameters().get('Id');
        projectType=ApexPages.currentPage().getParameters().get('isProject');
        if(projectType=='true')
            isDescVisible=true;
        if(projectId!=null)
        project=[Select Id,IPM_Project_Name__c,IPM_Project_Description__c,IPM_Project_Logo__c,IPM_Brand_Positioning__c,IPM_Category__r.Name from IPM_Project__c where Id=:projectId];
        if(project.IPM_Project_Logo__c !=null)
            isImage=true;

    }*/
    
     public PageReference BackToProjectIntermediate(){
               pagereference pg=new pagereference('/apex/ipmProject?id='+projectId);
               return pg;
     }

}