public with sharing class AF_CommentsListCompController{

    //Members
    public String ParentRecordId {get;set;}
    public String ParentObjectType {get;set;}
    public String brandvalue1{get;set;}
    public String category1{get;set;}
    public String year1{get;set;}
    public Boolean IsDisplayed {get;set;}
    public string IsViewAll{get;set;}
    public Boolean IsViewAllLink{get;set;}
    public string CommentId{get;set;}
    public string ReturnPageURL{get;set;}
    public string commentValue{get;set;}
    public boolean isAgencyFlag{get;set;} //to check wether logged in user is partner user or not
    public AF_Comments__c CommentRecord {get;set;}
    public List<CustomException> ErrorCollection {get;set;}
    public boolean isCMCOUser{get;set;}  
    public  List<AF_Comments__c> commentsList;
    public Id myCommentId{get;set;}
    public Id myCreateId{get;set;}
    public Boolean bCMCOSuperUser{get;set;}
    public Id LoggedId{get;set;}
    public AF_CommentsListCompController()
    
    {   
        isCMCOUser=false;
        bCMCOSuperUser=false;
        LoggedId = UserInfo.getUserId();
        User userObj = new User();
        userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
        if(userObj.AF_Agency_Fees_User_Type__c=='Agency'){
            isAgencyFlag=true;
        }
        if(userObj.AF_Agency_Fees_User_Type__c=='CMCO User'){
            isCMCOUser=true;
        }  
        if(userObj.AF_Agency_Fees_User_Type__c=='CMCO Super User'){
            bCMCOSuperUser=true;
        }   
        IsDisplayed = false;        
        if(ApexPages.currentPage().getParameters().get('Id') != null)
        {
            CommentId = ApexPages.currentPage().getParameters().get('Id');          
        }
        ErrorCollection = new List<CustomException>();        
        CommentRecord = new AF_Comments__c();           
    }
    
    public List<AF_Comments__c> getCommentsList()
    {
        List<AF_Comments__c> comments;
        commentsList = new List<AF_Comments__c>();
        IsDisplayed = false;                                
        if(IsViewAll == 'true')
        {
            IsDisplayed = true;
            IsViewAllLink = false;
            comments = [select id, Name, AF_Type__c,AF_Public__c, AF_Parent_Record_Id__c, CreatedById, OwnerName__c, CreatedDate, AF_Comments__c from AF_Comments__c WHERE AF_Parent_Record_Id__c = : ParentRecordId ORDER BY CreatedDate DESC];    
        }
        else
        {
            IsViewAllLink = true;
            comments = [select id, Name, AF_Type__c, AF_Public__c,AF_Parent_Record_Id__c, CreatedById, OwnerName__c, CreatedDate, AF_Comments__c from AF_Comments__c WHERE AF_Parent_Record_Id__c = : ParentRecordId ORDER BY CreatedDate DESC LIMIT 5];    
        } 
        commentsList.addAll(comments);
        system.debug('myCommentId....'+myCommentId);
        return comments;
    }
    
    public PageReference EditComment()
    {
        ReturnPageURL = ParentRecordId;
        PageReference pageRef =  new PageReference('/apex/AF_EditComment');
        pageRef.getParameters().put('Id', CommentId);
        pageRef.getParameters().put('rp', ReturnPageURL);
        pageRef.setRedirect(true);  
       // return pageRef;
        return null;
    }
    public void SaveCommentEdit(){
    integer i=0;
    myCommentId=null;
    for(AF_Comments__c c:commentsList){
        if(c.AF_Comments__c.length() > 0){
            i++;
        }
    }
    if(i==commentsList.size()){
        system.debug('commentsList....'+commentsList);
        update commentsList;
    }
    
    }
    public void SaveComment()
    {
        //PageReference pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=false');
        //pageRef.setRedirect(true); 
            //PageReference pageRef = new PageReference('/apex/AF_AgencyEstimate');
        List<Exception> exceptionCollection = new List<Exception>();
         
        try
        {
            if(CommentRecord.AF_Comments__c.length() > 0)
            {
                
                /*
                CommentRecord.AF_Parent_Record_Id__c = ParentId;
                CommentRecord.AF_Parent_Object_Type__c = ParentRecordType;
                System.debug('CommentRecord.AF_Parent_Record_Id__c : ' +  CommentRecord.AF_Parent_Record_Id__c);
                System.debug('CommentRecord.AF_Parent_Object_Type__c : ' +  CommentRecord.AF_Parent_Object_Type__c);
                */
                
                AF_Comments__c recordsToInsert = new AF_Comments__c();
                recordsToInsert.AF_Parent_Record_Id__c = ParentRecordId;
                recordsToInsert.AF_Parent_Object_Type__c = ParentObjectType;
                recordsToInsert.AF_Comments__c = CommentRecord.AF_Comments__c;
                //recordsToInsert.AF_OOPS_Actual__c = ParentRecordId;
                recordsToInsert.AF_Public__c = CommentRecord.AF_Public__c;
                System.debug('Comment Record was AF_Parent_Object_Type__c: ' +   recordsToInsert.AF_Parent_Object_Type__c);
                System.debug('Comment Record was AF_Parent_Record_Id__c: ' +   recordsToInsert.AF_Parent_Record_Id__c);
                System.debug('Comment Record was recordsToInsert.AF_Comments__c: ' +   recordsToInsert.AF_Comments__c);
                MapToLookups(recordsToInsert);
                insert recordsToInsert;                                
            }             
        }
        catch(Exception ex)
        {
                system.debug(ex);  
        }
        //return pageRef;
    }  
    
    private void MapToLookups(AF_Comments__c pCommentRecord) 
    {
        // this is a helper method that detects ParentObjectType and assign the id to specific looup fields
        if(ParentObjectType == 'AF_Brand_Estimate__c'){System.debug('ParentObjectType was AF_Brand_Estimate__c');pCommentRecord.AF_Brand_Estimate__c = ParentRecordId; UpdateIsCommentOnRecord('AF_Brand_Estimate__c', ParentRecordId);}
        if(ParentObjectType == 'AF_Agency_Estimate__c'){System.debug('ParentObjectType was AF_Agency_Estimate__c');pCommentRecord.AF_Agency_Estimate__c = ParentRecordId; UpdateIsCommentOnRecord('AF_Agency_Estimate__c', ParentRecordId);}
        if(ParentObjectType == 'AF_Bonus_Summary__c'){System.debug('ParentObjectType was AF_Bonus__c');pCommentRecord.AF_Bonus_Summary__c = ParentRecordId;}
        if(ParentObjectType == 'AF_Bonus_Matrix__c'){System.debug('ParentObjectType was AF_Bonus_Matrix__c');pCommentRecord.AF_Bonus__c = ParentRecordId;}
        if(ParentObjectType == 'AF_OOPS_Estimate__c'){System.debug('ParentObjectType was AF_OOPS_Estimate__c');pCommentRecord.AF_OOPS_Estimate__c = ParentRecordId;}        
        //add more here as these mapping are made with comments.         
    }
        
    private void UpdateIsCommentOnRecord(string pObjectType, Id pObjectId)
    {   
        System.debug('UpdateIsCommentOnRecord is running.');
        if(pObjectType == 'AF_Brand_Estimate__c'){try{AF_Brand_Estimate__c objBE    = [select Id, AF_isComment__c from AF_Brand_Estimate__c where Id = : pObjectId];if(objBE != null){objBE.AF_isComment__c = true; update objBE;}}catch(DMLException ex){System.debug(ex);}}
        if(pObjectType == 'AF_Agency_Estimate__c'){try{ AF_Agency_Estimate__c objAE = [select Id, AF_isComment__c from AF_Agency_Estimate__c where Id = : pObjectId];if(objAE != null){System.debug('UpdateIsCommentOnRecord: AF_Agency_Estimate__c.');objAE.AF_isComment__c = true; update objAE;}}catch(DMLException ex){System.debug(ex);}}
        //if(pObjectType == 'AF_Bonus__c'){try{Account obj  = [select Id, IsComment from [object] where Id = : pObjectId];if([obj] != null){obj.IsComment__c = true; update [obj];}}catch(DMLException ex){System.debug(ex);}}
        if(pObjectType == 'AF_OOPS_Estimate__c'){try{AF_OOPS_Estimate__c objOE  = [select Id, AF_isComment__c from AF_OOPS_Estimate__c where Id = : pObjectId];if(objOE != null){objOE.AF_isComment__c = true; update objOE;}}catch(DMLException ex){System.debug(ex);}}        
    }
       
    public class CustomException extends Exception {}
    
    public void editCommentByUsers(){
        system.debug('recordId..'+myCommentId);
        system.debug('myCreateId...'+myCreateId);
        system.debug('loggedin...'+UserInfo.getUserId());
        if(myCreateId!=UserInfo.getUserId() && bCMCOSuperUser==false){
            myCommentId=null;
             apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Comment cannot be Changed')); 
        }
    }
 
}