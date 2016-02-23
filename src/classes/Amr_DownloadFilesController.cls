public with sharing class Amr_DownloadFilesController {
    public Amr_Saving__c savingObj{get;set;}
    public String folderselected{get;set;}
    public String folerName{get;set;}
    public String adManagerNumber{get;set;}
    
    public List<FeedItem> DisplayList{
        get{
             if(DisplayList== null)
                 DisplayList= new List<FeedItem>();
             return DisplayList;
       }set;}
  
       
    public List<FeedItem> attachedList{
    get{
             if(attachedList== null)
                 attachedList= new List<FeedItem>();
             return attachedList;
    }set;} 
       
    
    
    public Amr_DownloadFilesController(){
         
         String SavingObjId = ApexPages.currentPage().getParameters().get('id');
         string userId = userinfo.getuserid();
         List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_CAP order by Assignee.name];
         boolean flag = false;
         Amr_Saving__c savObjNum = [select Job_Details__r.AdManagerText__c from Amr_Saving__c where Id =:SavingObjId limit 1];
        adManagerNumber = savObjNum.Job_Details__r.AdManagerText__c;
                
        system.debug('adManagerNumber!!'+adManagerNumber);
        // boolean flagUser = false;
         for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
             if(userId == permissionObj.Assignee.id){
               // attachedList = [select id,CreatedById,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,LastEditById FROM FeedItem where ParentId =:SavingObjId];
                flag = true;
                system.debug('inside cap User===>');
                break;
             }/*else{
              //  attachedList = [select id,CreatedById,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,LastEditById FROM FeedItem where ParentId =:SavingObjId And (CreatedById = :userId OR LastEditById = :userId)];
                 system.debug('inside rap User===>');
                 flagUser = true;
                 break;
             }*/
         }
         system.debug(flag+'======flagvalues==>');
         if(flag == true){
             system.debug('CAP');
             attachedList = [select id,CreatedById,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,LastEditById FROM FeedItem where ParentId =:SavingObjId];
         }else{
          
             attachedList = [select id,CreatedById,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,LastEditById FROM FeedItem where ParentId =:SavingObjId And (CreatedById = :userId OR LastEditById = :userId)];
         }
        
         system.debug('=======all list'+attachedList);
    }
    
    public PageReference downloadFile(){
        system.debug('=====>'+folderselected);
        if(String.isBlank(folderselected) ){
          system.debug('inside========>'+folderselected);
         DisplayList = new List<FeedItem>();
        // ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unilever finance member email : must follow the standard format of an email address, e.g. txt@txt.com'));
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Error_SelectValue));
         return null;
        }
        DisplayList = new List<FeedItem>();
        for(FeedItem attachedObj:attachedList ){
                 system.debug('file Names'+attachedObj.ContentFileName);
                 if(attachedObj.ContentFileName!= null){
	                 folerName = (attachedObj.ContentFileName).substringAfter('*');
	                 system.debug(folerName +'----folder----'+folderselected+'====>');
	                 if(folerName == folderselected){
	                     attachedObj.Title = (attachedObj.ContentFileName).substringBefore('*');
	                     DisplayList.add(attachedObj);
	                     system.debug('list need to display====>'+DisplayList);
	                 }
                 }
       }
      return null;
    }
    
}