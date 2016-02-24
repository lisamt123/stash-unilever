public with sharing class Amr_UploadSavingFilesController {
    
     public List<SelectOption> filesCountList {get; set;}  
     public String FileCount {get; set;}  
     public   List<MultipleDocumentInner> allFileList {get; set;}  
     public transient List<Document> dataList =  new List<Document>();
     private transient List<Document> allFileListFinal; 
     private  transient  List<FeedItem> attachedListToDisplay{get;set;}
     public String IdValue{get;set;}
     public String ContentUpdated{get;set;}
     public String bodyUpdated{get;set;}
     public String SavingObjId {get;set;}
   	 public String adManagerNumber{get;set;}
   	 public String quoteId{get;set;}

     public Amr_UploadSavingFilesController()  {  
       
       SavingObjId = ApexPages.currentPage().getParameters().get('id');
       String userId = UserInfo.getUserId();
       
       system.debug('userId====='+userId );
       
       //file upload
        allFileListFinal = new List<Document>();
        filesCountList = new List<SelectOption>() ;  
        allFileList = new List<MultipleDocumentInner>(); 
       // allFileList.add(new MultipleDocumentInner());
        attachedListToDisplay = new List<FeedItem>();
        Boolean flag = false;
        List<Amr_Saving__c> savObjList = [select Id from Amr_Saving__c];
        for(Amr_Saving__c obj:savObjList){
        	if(SavingObjId == obj.Id){
        		flag = true;
        	}
        }
        if(flag == true){
        Amr_Saving__c savObjNum = [select Job_Details__r.AdManagerText__c from Amr_Saving__c where Id =:SavingObjId limit 1];
        adManagerNumber = savObjNum.Job_Details__r.AdManagerText__c;
        }else{
        Amr_Quote__c quoteObjNum =[select Saving__r.Job_Details__r.AdManagerText__c from Amr_Quote__c where Id =:SavingObjId limit 1];
        adManagerNumber = quoteObjNum.Saving__r.Job_Details__r.AdManagerText__c;
        }
        
                
        system.debug('adManagerNumber!!'+adManagerNumber);
        system.debug('===fileCount'+FileCount);
        FileCount = ''; 
         
        for(Integer i = 1 ; i < 5 ; i++) { 
            filesCountList.add(new SelectOption(''+i , ''+i)) ;  
        }
     }
     
     public PageReference ChangeCount()  {  
      
        allFileList = new List<MultipleDocumentInner>();  
       
        system.debug('xx=====');
        
        //Adding multiple attachments instance  
        if(FileCount != null ){
        for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)  {
            allFileList.add(new MultipleDocumentInner()) ;  
            }
        }
        return null;  
    }  
    
    
    public void SaveAttachments()  
    {  
       
        system.debug('---file List---'+allFileList);
        system.debug('---file count---'+FileCount );
        if(attachedListToDisplay == null){
            attachedListToDisplay = new List<FeedItem>();
        }
        if(allFileList.size()>0){
            FeedItem FeedItemObj;
            for(MultipleDocumentInner obj : allFileList){
                if(obj.document.body !=null){
                    FeedItemObj = new FeedItem();
                    FeedItemObj.body = 'Attachment added';
                    FeedItemObj.ContentData = obj.document.body;
                    FeedItemObj.ParentId = SavingObjId;
                    FeedItemObj.ContentFileName = obj.document.name+'*'+obj.savingObj.Folder_Name__c;
                    attachedListToDisplay.add(FeedItemObj);
                }
                //obj.folderid = UserInfo.getUserId(); 
               // obj.IsPublic = true;
                //allFileListFinal.add(obj);
               
            }
            insert  attachedListToDisplay;
           
            //allFileListFinal = new  List<Document>();
           // allFileList =  new List<Document>();
            attachedListToDisplay = new List<FeedItem>();
            allFileList = new List<MultipleDocumentInner>();  
            
            
        }
        
        system.debug('============final'+allFileListFinal+'list---'+allFileList.size());
        if(allFileList.size() == 0 ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Confirm,' File(s) are uploaded successfully'));  
       
        }
       
        /*if(FileCount == null || FileCount == '')  {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select how many files you want to upload.'));  
            
        } */
        
    }  
     
     public class MultipleDocumentInner{
        public Document document{get;set;}
        public Amr_Saving__c savingObj{get;set;}
        public MultipleDocumentInner(){
            document = new document();
            savingObj = new Amr_Saving__c();
        }
     } 
      
       
 }