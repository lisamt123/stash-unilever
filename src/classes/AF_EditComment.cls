public with sharing class AF_EditComment
{
    public String ParentId {get;set;}
    public String CommentId {get;set;}
    public String ParentRecordType {get;set;}
    public String ReturnPage {get;set;}
    public AF_Comments__c CommentRecord {get;set;}
    public List<CustomException> ErrorCollection {get;set;}    
    public Boolean IsEdit {get;set;}
    public Boolean IsAdd {get;set;}            
    public Boolean IsDisplayed {get;set;}
    public String ReturnPageURL {get;set;}
    
    
    public AF_EditComment()
    {
        
        if(ApexPages.currentPage().getParameters().get('Id') != null)
        {
            CommentId = ApexPages.currentPage().getParameters().get('Id');          
        }
        
        if(ApexPages.currentPage().getParameters().get('rp') != null)
        {
            ReturnPage = ApexPages.currentPage().getParameters().get('rp');
        }
        
        ErrorCollection = new List<CustomException>();
        
        CommentRecord = [Select a.SystemModstamp, a.OwnerName__c, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.AF_Public__c, a.AF_Parent_Record_Id__c, a.AF_Parent_Object_Type__c, a.AF_Comments__c, a.AF_Bonus__c From AF_Comments__c a where a.Id = : CommentId];   
        if(IsEdit == true){IsAdd = false;}else{IsAdd = true;}     
    }
    public PageReference SaveComment()
    {
        PageReference pageRef = new PageReference('/apex/AF_UL_AgencyMatrix?Id='+ReturnPage);
        pageRef.setRedirect(true);                       
        try
        {
            if(CommentRecord.AF_Comments__c.length() > 0)
            {                
                update CommentRecord;                
            }             
        }
        catch(Exception ex)
        {
                system.debug(ex);  
        }
        //return pageRef;
       
        apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,'Successfully updated'));
        return null;
    }  
    
    private void MapToLookups() 
    {
        // this is a helper method that detects ParentRecordType and assign the id to specific looup fields
        if(ParentRecordType == 'AF_Brand_Estimate__c'){System.debug('ParentRecordType was AF_Brand_Estimate__c');CommentRecord.AF_Brand_Estimate__c = ParentId;}
        if(ParentRecordType == 'AF_Agency_Estimate__c'){System.debug('ParentRecordType was AF_Agency_Estimate__c');CommentRecord.AF_Agency_Estimate__c = ParentId;}
        if(ParentRecordType == 'AF_Bonus__c'){System.debug('ParentRecordType was AF_Bonus__c');CommentRecord.AF_Bonus__c = ParentId;}
        if(ParentRecordType == 'AF_OOPS_Estimate__c'){System.debug('ParentRecordType was AF_OOPS_Estimate__c');CommentRecord.AF_OOPS_Estimate__c = ParentId;}       
        //add more here as these mapping are made with comments.         
    }
                 
    public class CustomException extends Exception {}

}