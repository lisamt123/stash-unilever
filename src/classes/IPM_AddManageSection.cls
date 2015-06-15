public class IPM_AddManageSection{
/** Created by:Rajesh Kumar
module:Add manage section 
date:24/12/2014
requirement:
**/
  public IPM_Project__c project {get; set;}
  public List<IPM_Project_Document_Section__c> projSectionList {get; set;}
  public List<IPM_Project_Document_Section__c> projSubSectionList {get; set;} 
  public IPM_Project_Document__c projectDoc {get; set;}
  public string projectId{get;set;}
  public Boolean IsModified{get;set;}
  public string GetDocType{get;set;}
  
  //Constructor
  public IPM_AddManageSection(){
  GetDocType=ApexPages.currentPage().getParameters().get('DocType');
  projectId=ApexPages.currentPage().getParameters().get('Id');
  projectDoc=[Select Id,IPM_Document_Status__c,LastModifiedDate,IPM_Postponement_Date__c,IPM_Approval_Date__c,LastModifiedBy.smallPhotoURL,IPM_Approved_Comments__c,IPM_Postponed_Comments__c,LastModifiedBy.Name from IPM_Project_Document__c where IPM_Project__c=:projectId and IPM_GateDocuments__c=:GetDocType];    
  getProjectDocumentSection();
  getDocumentSectionMap();     
} 
 public void getProjectDocumentSection(){
           projSectionList=[Select Id,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.Id,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c=null order by IPM_Section__r.IPM_Section_Sequence__c asc]; 
  } 
    public void getDocumentSectionMap()
    {
        Set<Id> projectSecId=new Set<Id>();
        for(Integer i=0;i<projSectionList.size();i++)
        {
            projectSecId.add(projSectionList[i].IPM_Section__r.Id);
        } 
        projSubSectionList=[Select Id,IPM_GateHistory__c,IPM_GateHistory_Date__c,IPM_Section__c,IPM_Negotiable__c ,IPM_Default_Section__c,IPM_Section__r.IPM_Section_Type__c,IPM_Section__r.IPM_Section_Label_Type__c,IPM_Section__r.IPM_Section_Name__c,Name,LastModifiedBy.Name,LastModifiedDate,IPM_Section__r.IPM_Parent_Section__c,IPM_Project_Document__c,IPM_Section_Status__c,IPM_Section__r.IPM_Section_Sequence__c,IPM_Gate_Document_Summary__c,IPM_Count_of_Comments__c,IPM_FunctionalRole__c from IPM_Project_Document_Section__c where IPM_Project_Document__c=:projectDoc.Id and IPM_Section__r.IPM_Parent_Section__c !=null order by IPM_Section__r.IPM_Section_Sequence__c asc]; 

    }
//Method to save section and go back to parent page  
   public void SaveAddManage(){
      try{
          update projSubSectionList;
         }catch(Exception e){
         
         }
  }       
}