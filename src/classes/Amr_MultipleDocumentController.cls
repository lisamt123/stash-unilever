public with sharing class Amr_MultipleDocumentController {
    
     public List<SelectOption> filesCountList {get; set;}  
     public String FileCount {get; set;}  
     public List<Document> allFileList {get; set;}  
     public transient List<Document> dataList =  new List<Document>();
     private transient List<Document> allFileListFinal; 
     public List<FeedItem> attachedListToDisplay{get;set;}
     public String IdValue{get;set;}
     public String ContentUpdated{get;set;}
     public String bodyUpdated{get;set;}

     public Amr_MultipleDocumentController()  {  
       
       String SavingObjId = ApexPages.currentPage().getParameters().get('id');
       String userId = UserInfo.getUserId();
       
       system.debug('userId====='+userId );
       
       List<FeedItem> attachedList = [select id,CreatedById,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,LastEditById FROM FeedItem where ParentId =:SavingObjId];
       System.debug('--->'+attachedList[0].LinkUrl);
       attachedListToDisplay =  new List<FeedItem>();
       
       for(FeedItem FeedItemObj:attachedList ){
           if(FeedItemObj.LastEditById == null && FeedItemObj.CreatedById == userId){
               system.debug('=====linkurl'+FeedItemObj);
               attachedListToDisplay.add(FeedItemObj);
           }
           if(FeedItemObj.LastEditById == userId){
             system.debug('======feedLink'+FeedItemObj.LinkUrl);
             attachedListToDisplay.add(FeedItemObj);
           }
       }
        //file upload
       /* allFileListFinal = new List<Document>();
        filesCountList = new List<SelectOption>() ;  
        allFileList = new List<Document>() ;  
        system.debug('===fileCount'+FileCount);
        FileCount = ''; 
         
        for(Integer i = 1 ; i < 5 ; i++) { 
            filesCountList.add(new SelectOption(''+i , ''+i)) ;  
        }*/
     }
     
    /* public PageReference ChangeCount()  {  
      
        if(allFileList.size()>0){
                allFileList.clear() ;  
        }
        system.debug('xx=====');
        
        //Adding multiple attachments instance  
        for(Integer i = 1 ; i <= Integer.valueOf(FileCount) ; i++)  
            allFileList.add(new Document()) ;  
        
        return null;  
    }  
    
    public void SaveAttachments()  
    {  
       
        system.debug('---file List---'+allFileList);
        system.debug('---file count---'+FileCount );
        if(allFileListFinal == null){
            allFileListFinal = new List<Document>();
        }
        if(allFileList.size()>0){
            allFileListFinal.add(allFileList[0]);
            test(allFileListFinal);
            allFileListFinal.remove(0);
            allFileList.remove(0);
        }
        
        system.debug('============final'+allFileListFinal+'list---'+allFileList.size());
        if(allFileList.size()== 0 ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Confirm,' file(s) are uploaded successfully'));  
       
        }
        //allFileList = null;
        if(FileCount == null || FileCount == '')  {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR,'Please select how many files you want to upload.'));  
            
        } 
        
    }  
      
       private void test(List<Document> lst){
          dataList.addAll(lst); 
       }*/
       
       public void updateDocument(){
          try{
          system.debug('id====='+IdValue);
          system.debug('id====='+bodyUpdated);
          Blob body =  Blob.valueOf(bodyUpdated);
          system.debug('id====='+ContentUpdated);
          FeedItem FeedItemObj =  [select id,CreatedById,ContentData,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,LastEditById FROM FeedItem where id =:IdValue];
          FeedItemObj.ContentData = body;
          FeedItemObj.ContentFileName = ContentUpdated;
          update FeedItemObj;
       }catch(Exception e){
           system.debug('--------'+e);
       }
       }
       
       
 }