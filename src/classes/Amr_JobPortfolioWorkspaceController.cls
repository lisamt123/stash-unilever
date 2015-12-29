public class Amr_JobPortfolioWorkspaceController{
    
    public Amr_Alert__c alertobj {get;set;}
    public Amr_Comments__c commentObj {get;set;}
    public String jobIdFromPage {get;set;}
    public List<Amr_Alert__c> alertRecordList {get;set;}
    public List<Amr_Comments__c> commentRecordList {get;set;}
    public Id chosenId {get;set;}
    public Id chosenIdForComment {get;set;}
    public  Document document {
    get {
      if (document == null)
         document = new Document();
         return document;
    }
    set;
   }
   public List<FeedItem> documentList{get;set;}
    
    public Amr_JobPortfolioWorkspaceController(){
        alertobj = new Amr_Alert__c();
        commentObj = new Amr_Comments__c();
        jobIdFromPage = ApexPages.currentPage().getParameters().get('id');
        getAlertList();
        getCommentList();
        getDocuments();
    }
    
    public void getAlertList(){
        //alertRecordList = new List<Alert__c>();
        alertRecordList = [select id,New_Alert__c,Alert_Message__c,Job_Id__r.AdManagerText__c from Amr_Alert__c where Job_Id__r.Id =:jobIdFromPage];
          system.debug('alertRecordList********** '+alertRecordList );
    }
    
    public PageReference addNewAlert(){
        
        system.debug('alertobj!!'+alertobj+'jobIdFromPage !!'+jobIdFromPage);
        if(String.isBlank(jobIdFromPage)){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'JobId not found'));
             return null;
        }else{
        Amr_Alert__c addAlertObj = new Amr_Alert__c();
        addAlertObj.New_Alert__c= alertobj.New_Alert__c;
        addAlertObj.Alert_Message__c= alertobj.Alert_Message__c;
        addAlertObj.Job_Id__c = jobIdFromPage;
       
        insert addAlertObj;
        getAlertList();
        
        alertobj.New_Alert__c = null;
        alertobj.Alert_Message__c = '';
        return null;
    }
   }
    public Pagereference deleteAlert(){
               
        Amr_Alert__c alert =[select Id from Amr_Alert__c where Id=:chosenId limit 1];
        system.debug('object delete!!'+alert);
        delete alert;
        system.debug('deleted!!!!!'+chosenId);
         getAlertList();
        return null;
    }
    
     public void getCommentList(){
        
        commentRecordList =[select id,new_Comment__c,CreatedDate from Amr_Comments__c where AM_Job_Detail__r.Id=:jobIdFromPage];
        system.debug('commentRecordList ********** '+commentRecordList);
    }
    
       public PageReference addNewComment(){
        if(String.isBlank(jobIdFromPage)){
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'JobId not found'));
             return null;
        }
        else{
        Amr_Comments__c addCommentObj = new Amr_Comments__c();
        addCommentObj.new_Comment__c = commentObj.new_Comment__c;
        addCommentObj.CreatedDate = commentObj.createdDate;
        addCommentObj.AM_Job_Detail__c = jobIdFromPage;
        insert addCommentObj;
        getCommentList();
        commentObj.new_Comment__c='';
        
            return null;
    }
 }
    public Pagereference deleteComment(){
               
        Amr_Comments__c comment =[select Id from Amr_Comments__c where Id=:chosenIdForComment  limit 1];
        system.debug('object delete!!'+comment);
        delete comment ;
        system.debug('deleted!!!!!'+chosenId);
        getCommentList();
        return null;
    }
    
    public PageReference uploadDocument(){
    
            system.debug('inside upload!!'+document+'jobIdFromPage!!'+jobIdFromPage);
                 
                  if(document.body!=null && jobIdFromPage != null){           
              system.debug(document+'--------document Body'+document.body);
              List<Folder> FolderId = [SELECT Id,Name FROM Folder where name = 'Brief'];
              system.debug('FolderId !!'+FolderId);
              document.FolderId = FolderId[0].Id;
              insert document;
                                   
              FeedItem FI = new FeedItem();
              FI.ParentId = jobIdFromPage;
              FI.Body = 'Attachment added';
              FI.ContentData = document.body;
              FI.ContentFileName = document.Name;
              insert FI;
              getDocuments();
              system.debug('====>feed'+FI);
              document = new document();
        }
            
        
        return null;
    }
    
    public void getDocuments(){
    
       documentList= [select ContentFileName,createdDate from FeedItem where ParentId =:jobIdFromPage];
    }
}