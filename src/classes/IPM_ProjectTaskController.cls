/********************************************************************* 
*@Author:Cognizant
*@Date: september 2014
*@Description : This is used to print the task as PDF
*Referring in page 
************************************************************************/

public with sharing class IPM_ProjectTaskController
{

    Public sObject project{get;set;} // Initilaizing the project obj
    public String sObjName{get; set;} // Getting the sobj
    public Id projectId{get; set;} // Getting the projectid
    public List<IPM_Task__c > ipmProjectTasks{get; set;} // Getting the IPM_Task__c object
    public List<IPM_Project_Template__c> ipmProjectTemplates{get; set;} // Getting the project template details
    public List<IPM_Project_Document_Section__c > ipmProjectDocumentSections{get; set;} // Getting the project document sections
    
    
/***************************************************************
*@Description :Constructor to fetch the details of the Tasks
****************************************************************/

    public IPM_ProjectTaskController()
    {
        projectId  =ApexPages.currentPage().getParameters().get('id');
        string istype=ApexPages.currentPage().getParameters().get('type');   
        sObjName = projectId.getSObjectType().getDescribe().getName();       
        string query = IPM_ProjectTaskController.getCreatableFieldsSOQL(sObjName ,'Id =: projectId');
        project  = Database.query(query);
        
        if(istype==IPM_ConstantUtils.ATTACHMENT){
            Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename=Task.'+IPM_ConstantUtils.ATTACHMENT);
        }else{
            Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=Task.'+IPM_ConstantUtils.ATTACHMENT);
        }
        
        ipmProjectTemplates = new List<IPM_Project_Template__c>(); // Getting the right Project Template 
        ipmProjectDocumentSections = new List<IPM_Project_Document_Section__c >(); // Getting the Project document section
       
        if(project  != null)
        {       
            ipmProjectTasks= [SELECT Id, Name,IPM_Assignee__c,IPM_Completed__c,IPM_Due_Date1__c,IPM_Function__c,IPM_Project__c,IPM_Project_Document_Section__c,IPM_Project_Template__c,IPM_Section__c,IPM_Phase__c,IPM_Section_Number__c,IPM_Task_Complexity__c,IPM_Task_Name__c,IPM_Task_Type__c,IPM_Type_of_Gate__c,IPM_Version_Number__c FROM IPM_Task__c WHERE IPM_Project__c= :project.Id];
            
            List<String> lstprojectTemplate=new List<String>();
            List<String> lstProjectDocumentSection=new List<String>();
            for(IPM_Task__c ipmTask:ipmProjectTasks)
            { 
                if(ipmTask.IPM_Project_Template__c != null){
                    lstprojectTemplate.add(ipmTask.IPM_Project_Template__c);
                }
                if(ipmTask.IPM_Project_Document_Section__c != null){
                    lstProjectDocumentSection.add(ipmTask.IPM_Project_Document_Section__c);
                }
            }
            // Quering for Project Template 
            if(!lstprojectTemplate.isEmpty()){
                ipmProjectTemplates=  [Select Id,IPM_Category__c,IPM_Template_Complexity__c,IPM_Project__c,IPM_Template_Name__c from IPM_Project_Template__c WHERE id IN : lstprojectTemplate];
            }
            // Querying for project Document section
            if(!lstProjectDocumentSection.isEmpty()){
                ipmProjectDocumentSections = [Select Id,IPM_Gate_Document_Summary__c,IPM_Section_Status__c,IPM_Project_Document__c,IPM_Project_Section__c,IPM_Section__c,IPM_Status_Icon__c,IPM_Negotiable__c,IPM_PDP_Document_Summary__c,IPM_Section_Help_Text_Long__c,IPM_Section_Name__c,IPM_Section_Owner__c,IPM_Section_Type__c from IPM_Project_Document_Section__c WHERE id IN : lstProjectDocumentSection];    
            }
        }    
    }
    
       /*****************************************************************************************************
    @Description : Returns a dynamic SOQL statement for the whole object,
    includes only creatable fields since we will be inserting a cloned result of this query
    @Param: Fmap - For getting the sobj feild values
    @Return: Its a query string which will return the fields.
    ******************************************************************************************************/     
    
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        String selects = '';
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
        
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ 
                Schema.DescribeFieldResult fd = ft.getDescribe(); 
                if (fd.isCreateable()){ 
                    selectFields.add(fd.getName());
                }
            }
        }
        
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                if(s != IPM_Utils.ExternalField){
                    selects += s + ',';
                }
            }
            if (selects.endsWith(',')){
                selects = selects.substring(0,selects.lastIndexOf(','));
            }
        }
        
        return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
    }
    
    
}