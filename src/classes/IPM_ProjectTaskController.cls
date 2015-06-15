/* Type Name: IpmProjectTaskController
Author: Aswin
Created Date:12/04/2014
Reason: To meet requirements  REQ */

public class IPM_ProjectTaskController
{

    Public sObject project{get;set;}
    public String sObjName{get; set;}
    public Id projectId{get; set;}
    public List<IPM_Task__c > ipmProjectTasks{get; set;}
    public List<IPM_Project_Template__c> ipmProjectTemplates{get; set;}
    public List<IPM_Project_Document_Section__c > ipmProjectDocumentSections{get; set;}

    public IPM_ProjectTaskController()
    {
        
       projectId  =ApexPages.currentPage().getParameters().get('id');
       string istype=ApexPages.currentPage().getParameters().get('type');
       
       sObjName = projectId.getSObjectType().getDescribe().getName();       
       string query= 'Select id from '+sObjName+' where id =\''+ projectId  + '\'';
       project  = Database.query(query);
       if(istype=='pdf'){
       Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=Task.pdf');
       }else{
       Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=Task.pdf');
       }
       IPM_Project_Template__c projectTemplate= new IPM_Project_Template__c();
       IPM_Project_Document_Section__c  projectDocumentSection = new IPM_Project_Document_Section__c();
       ipmProjectTemplates = new List<IPM_Project_Template__c>();
       ipmProjectDocumentSections = new List<IPM_Project_Document_Section__c >();
       
       if(project  != null)
       {       
        ipmProjectTasks= [SELECT Id, Name,IPM_Assignee__c,IPM_Completed__c,IPM_Due_Date1__c,IPM_Function__c,IPM_Project__c,IPM_Project_Document_Section__c,IPM_Project_Template__c,IPM_Section__c,IPM_Phase__c,IPM_Section_Number__c,IPM_Task_Complexity__c,IPM_Task_Name__c,IPM_Task_Type__c,IPM_Type_of_Gate__c,IPM_Version_Number__c FROM IPM_Task__c WHERE IPM_Project__c= :project.Id];
         
        for(IPM_Task__c ipmTask:ipmProjectTasks)
        { 
           
           
           if([Select Id,IPM_Category__c,IPM_Template_Complexity__c,IPM_Project__c,IPM_Template_Name__c from IPM_Project_Template__c WHERE id= :ipmTask.IPM_Project_Template__c].size()>0)
           {
               projectTemplate=  [Select Id,IPM_Category__c,IPM_Template_Complexity__c,IPM_Project__c,IPM_Template_Name__c from IPM_Project_Template__c WHERE id= :ipmTask.IPM_Project_Template__c];
               
               if(projectTemplate != null)
                   {
                       ipmProjectTemplates.add(projectTemplate);
                   }

           
           }

           
           if([Select Id from IPM_Project_Document_Section__c WHERE id= :ipmTask.IPM_Project_Document_Section__c].size()>0)
           {
               projectDocumentSection = [Select Id,IPM_Gate_Document_Summary__c,IPM_Section_Status__c,IPM_Project_Document__c,IPM_Project_Section__c,IPM_Section__c,IPM_Status_Icon__c,IPM_Negotiable__c,IPM_PDP_Document_Summary__c,IPM_Section_Help_Text_Long__c,IPM_Section_Name__c,IPM_Section_Owner__c,IPM_Section_Type__c from IPM_Project_Document_Section__c WHERE id= :ipmTask.IPM_Project_Document_Section__c];    

               if(projectTemplate != null)
                   {

                       ipmProjectDocumentSections.add(projectDocumentSection);
                   }
               
           }
           
           
           
        }

       }    


    }

   

}