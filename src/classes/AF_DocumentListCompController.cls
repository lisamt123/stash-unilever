public class AF_DocumentListCompController{

    //Members
    public String ParentRecordId {get;set;}
    public String ParentObjectType {get;set;}
    public Boolean IsDisplayed {get;set;}
    public string IsViewAll{get;set;}
    public boolean isAgencyFlag{get;set;} //to check wether logged in user is partner user or not
    public List<Attachment> DocumentsList {get;set;}
    public Attachment DocumentRecord {get;set;}
    public List<CustomException> ErrorCollection {get;set;}
    public Boolean IsViewAllLink{get;set;}
    public String docId{get;set;}
    public AF_Brand_Estimate__c brandEstRecord{get;set;}
    public AF_OOPS_Actual__c oopsRecord{get;set;}
    public AF_Bonus_Summary__c bonusRecord{get;set;}
    public Boolean status{get;set;}
    
    public AF_DocumentListCompController()
    {
   // ParentRecordId = '';
        User userObj = new User();
        status = false;
        brandEstRecord = new AF_Brand_Estimate__c();
            userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
            if(userObj.AF_Agency_Fees_User_Type__c=='Agency'){
                isAgencyFlag=true;
            }              
        if(ApexPages.currentPage().getParameters().get('id') != null)
       {
            //ParentRecordId = ApexPages.currentPage().getParameters().get('id');
         
             //ParentRecordId='a2Tc0000000UBQN';
             //DocumentsList = LoadDocuments(ParentRecordId);
             DocumentRecord= new Attachment();
            ErrorCollection = new List<CustomException>();
       }
    }
   public List<Attachment> getAttachmentList()
    {
    List<Attachment> docs = new List<Attachment>();
    if(IsViewAll=='true'){
     docs = [select name,description,contenttype,Owner.name,LastModifiedDate from attachment where ParentId =:ParentRecordId ORDER BY CreatedDate DESC];
        if(docs.size() > 0){IsDisplayed = true;}
        IsViewAllLink = false;
    }
    else{
     docs = [select name,description,contenttype,Owner.name,LastModifiedDate from attachment where ParentId =:ParentRecordId ORDER BY CreatedDate DESC Limit 5];
    IsViewAllLink = true;
    }
    if(ParentRecordId.startsWith(System.Label.AF_BrandEstimateId)){
    brandEstRecord = [select AF_Status_Base_Fees__c from AF_Brand_Estimate__c where id=:ParentRecordId];
    if(brandEstRecord.AF_Status_Base_Fees__c == 'Ready for PO'){
        status = true;
    }
    }
    else if(ParentRecordId.startsWith(System.Label.AF_oopsActualId)){
    oopsRecord = [select AF_Status__c from AF_OOPS_Actual__c where id=:ParentRecordId];
    if(oopsRecord.AF_Status__c == 'Ready for PO'){
        status = true;
    }
    }
    else if(ParentRecordId.startsWith(System.Label.AF_BonusSummaryId)){
    bonusRecord = [select AF_Status__c from AF_Bonus_Summary__c where id=:ParentRecordId];
    if(bonusRecord.AF_Status__c == 'Ready for PO'){
        status = true;
    }
    }
     return docs ;
    }
    public void delDocument(){
    if(docId != ''){
    system.debug('docId....'+docId);
    Attachment docDel = new Attachment();
   
    docDel = [select Id from Attachment where Id=:docId and ParentId =:ParentRecordId];
    
    system.debug('docDel....'+docDel);
    delete docDel;
    }
    
    }
  /*public List<Attachment> LoadDocuments(string pDocsId)
    {
        List<Attachment> docs = [select name,description,contenttype,Owner.name,LastModifiedDate from attachment where ParentId =:pDocsId];
        if(docs.size() > 0){IsDisplayed = true;}                                
        return docs ;
    }*/
    
    public class CustomException extends Exception {}    
  }