/* Type Name: ipmProjectIntermediateController 
Author: 
Created Date:
Reason: Redirecting to Core Parameters, Task Generation, Project Scope, Team Members Pages
Change History:Added to fields to query. To be used in vf component "ipmProjectDetails" Removed Standard Controller
Author: Samrat Chakraborty
Modified Date: 15-10-2014  */
public with sharing class IPMProjectIntermediateController {
    
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
    public ipmProjectIntermediateController(){
      Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=9');
        isBossID='';
        projectId=ApexPages.currentPage().getParameters().get('Id');
        if(projectId=='' || projectId==null)
        {
        projectId=ApexPages.currentPage().getParameters().get('Pid');
        }
        isBossID=ApexPages.currentPage().getParameters().get('IsBossID');
        projectType=ApexPages.currentPage().getParameters().get('isProject');
        if(projectType=='true')
            isDescVisible=true;
        if(projectId!=null)

        project=[Select Id,IPM_Gatekeeping_Model__c,IPM_Project_Name__c,IPM_Project_Description__c,IPM_Category_Text__c,IPM_Brand__c,IPM_Project_Logo__c,IPM_Brand_Positioning__c,IPM_Category__r.Name,IPM_Category_Icon__c,IPM_Target_Launch_Date__c,IPM_Phase__c,IPM_Project_Type__c,IPMProject_Span__c from IPM_Project__c where Id=:projectId];
     
     System.debug('Number of Queries used in this Apex code so far: ' + Limits.getQueries());        
    }
      
     
  
}