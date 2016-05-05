/*****************************************************************
@Description :This class is used for managing sections from gate document
@Created Date: 24/12/2014
@Author: Cognizant
@Referenced: ipmAddManageSections Page
******************************************************************/

public with sharing class IPM_AddManageSection extends IPM_ProjectIntermediateController{
    
    public List<IPM_Project_Document_Section__c> projSectionList {get; set;}// used to store the query result from IPM_Project_Document_Section__c object 
    public List<IPM_Project_Document_Section__c> projSubSectionList {get; set;} // used to store the query result from IPM_Project_Document_Section__c object
    public IPM_Project_Document__c projectDoc {get; set;}// used to store the query result from IPM_Project_Document__c object
    public string projectId{get;set;}// used to store the current project Id
    public Boolean IsModified{get;set;}//used in corresponding VF page
    public string GetDocType{get;set;}// used to store current document type    
    private static string className_STR=IPM_AddManageSection.class.getName();//get class name
    private static final string SAVEMETHOD ='SaveAddManage';// method name
    public string NonNogeotibale_STR{get;set;}
    /*****************************************************************
    @Description : This the constructor for the class
    @Referenced: ipmAddManageSections Page
    ******************************************************************/
    
    public IPM_AddManageSection ()
    {
    	super();
        GetDocType=ApexPages.currentPage().getParameters().get('DocType');
        projectId=ApexPages.currentPage().getParameters().get('Id');
        NonNogeotibale_STR=IPM_ConstantUtils.TYPE_NON_NEGOTIABLE;
        
        if(String.isNotBlank(projectId)){
            
            projectDoc=[SELECT Id,IPM_GateDocuments__c,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,
                        LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name 
                        FROM IPM_Project_Document__c 
                        WHERE IPM_Project__c=:projectId 
                        AND IPM_GateDocuments__c=:GetDocType LIMIT 1];
            getProjectDocumentSection();
            getDocumentSectionMap();
        }     
    }
    
    /*****************************************************************
    @Description :This method is used from IPM_Project_Document_Section__c object
    ******************************************************************/
    
    public void getProjectDocumentSection(){
        
        ID procjectDocId=projectDoc.ID;
        string enviromentalImpact=IPM_ConstantUtils.IPM_ENVIRONMENTAL_IMPACT;
        string queryProjSectionList='SELECT Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c,IPM_Section__r.IPM_Negotiable__c FROM IPM_Project_Document_Section__c WHERE IPM_Project_Document__c=:procjectDocId and IPM_Section__r.IPM_Parent_Section__c=null';
        queryProjSectionList=queryProjSectionList+' ORDER BY IPM_Section__r.IPM_Section_Sequence__c asc LIMIT 1000';               
        projSectionList=Database.query(queryProjSectionList);
    }
    
    /*****************************************************************
    @Description :This method is used from IPM_Project_Document_Section__c object
    ******************************************************************/   
    
    public void getDocumentSectionMap(){
        Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++){
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        } 
        
        ID procjectDocId=projectDoc.ID;
        string enviromentalImpact=IPM_ConstantUtils.IPM_ENVIRONMENTAL_IMPACT;
        string queryProjSubSectionList='SELECT Id,IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c,IPM_Section__r.External_ID__c,IPM_FunctionalRole__c,IPM_Section__r.IPM_Negotiable__c FROM IPM_Project_Document_Section__c WHERE IPM_Project_Document__c=:procjectDocId AND IPM_Section__r.IPM_Parent_Section__c !=null';
                             
       if(project.IPM_ProjectSubType__c==IPM_ConstantUtils.IPM_BLG)
        {
            queryProjSubSectionList=queryProjSubSectionList+' AND IPM_Master_Section_External_Id__c !=:enviromentalImpact';
        }
        
        queryProjSubSectionList=queryProjSubSectionList+' ORDER BY IPM_Section__r.IPM_Section_Sequence__c asc LIMIT 1000';   
        
        projSubSectionList=Database.query(queryProjSubSectionList);
    }
    
    /*****************************************************************
    @Description :This method is used for save manage section
    ******************************************************************/
    
    public void SaveAddManage(){
        try{
            if(projSubSectionList!=null && !projSubSectionList.isEmpty()) 
            {
            	update projSubSectionList;
            }
        }
        catch (DmlException ex){
           ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),className_STR,
        SAVEMETHOD,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);                
 
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));         
        }
        
        
    }       
}