public class Amr_JobSheetPageController {

    public id selectedrap { get;set; }
    public boolean cancel{get;set;}
    public String docUploaded{get;set;}
    public String adManagerNumber{get;set;}
    public integer counterOfUpload = 0;
    public Document document {
    get {
      if (document == null)
         document = new Document();
         return document;
    }
    set;
   }
    
    public PageReference Rapclick() {
        list<Amr_Job_Details__c> joblist = new list<Amr_Job_Details__c>();
        joblist = [select id,name,Ownerid from Amr_Job_Details__c where id =: 'a6pc0000000046E'];
        for(Amr_Job_Details__c jb : joblist ){
        jb.Ownerid = selectedrap;
        update jb;
    } 
        return null;
    }
    
// For Cancelled record it will update the testchecked field TRUE in that record
    public void cancelrec() 
    {
       List<Amr_Job_Details__c> JobList;
        JobList=[select id,name,TestCheck__c,status__c from Amr_Job_Details__c where id = 'a6pc0000000047R'];

       if(cancel == TRUE)
       {
                     for(Amr_Job_Details__c jobs:JobList)
           {
               jobs.TestCheck__c=TRUE;
               jobs.status__c=true;
               
               update jobs;
           }
       }
    } 
    
    
    public String jobId{get;set;}
    public List<Amr_Saving__c> quoteList{get;set;}
    public List<Amr_Saving__c> lstQuoteToaddRow{
        get{
             if(lstQuoteToaddRow == null)
                    lstQuoteToaddRow = new List<Amr_Saving__c>();     
                return lstQuoteToaddRow;
        }set;
    }
    
    
    //created by chaitanya
   
    public List<User> UserTemp = new List<User>();
       
    public List<SelectOption> UserList
    {
        get
        {
            UserTemp = [Select name From User where profile.name='System Administrator'];
            
            UserList = new List<SelectOption>();
            
            for(User temp : UserTemp)
            {
               
                UserList.add(new SelectOption(temp.Id, temp.Name));
            }
            return UserList;
        }
        set;
    }
    

   //-------end-------- 

    
    
    public String quoteJobId{get;set;}
    
    public Amr_JobSheetPageController(){
   
       try{
            jobId = ApexPages.currentPage().getParameters().get('id');
            system.debug('========>jobId'+jobId);
            if(jobId != null){
                quoteList = [select Script_Title__c,Scope_re_brief__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Job_Details__r.AdManagerText__c 
                               from Amr_Saving__c where Job_Details__r.id = :jobId];
                quoteJobId = jobId;
                adManagerNumber = quoteList[0].Job_Details__r.AdManagerText__c;
                Amr_Saving__c obj = new Amr_Saving__c(Job_Details__c = quoteJobId);
                lstQuoteToaddRow.add(obj);
                system.debug('=====lstrow'+lstQuoteToaddRow);
            }
      
        }catch(exception e){
          system.debug('inside Excetion==>');
        }
    }
    
      
    
    public PageReference  addRowSavingLine(){
         
        if(counterOfUpload == 0){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please upload atleast one file'));
            return null;
        }else{
            if(validate(lstQuoteToaddRow)){
                
                if(lstQuoteToaddRow.size()>0 ){
                    insert lstQuoteToaddRow;
                   // uploadDocument();
                   system.debug('---document insdie addRow--'+document);
                    system.debug('========>'+lstQuoteToaddRow);
                }
                
                list<String> insertedQuoteIdsList =  new list<String>();
                for(Amr_Saving__c qoute:lstQuoteToaddRow){
                    insertedQuoteIdsList.add(qoute.id);
                }
                
                lstQuoteToaddRow = [select id,Script_Title__c,Scope_re_brief__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Job_Details__r.AdManagerText__c 
                               from Amr_Saving__c where id in : insertedQuoteIdsList];
                system.debug('ids inserted===>'+insertedQuoteIdsList);
                
                for(Amr_Saving__c QuoteObj:lstQuoteToaddRow){
                    
                    quoteList.add(QuoteObj);
                }
            } 
        }
        lstQuoteToaddRow.clear();
        lstQuoteToaddRow.add(new Amr_Saving__c(Job_Details__c = quoteJobId));
        counterOfUpload = 0;
        //document = new document();
        system.debug('===>list size=='+lstQuoteToaddRow);
        return null;
    }
    
    
    public boolean validate(List<Amr_Saving__c> quoteNeedToValidated){
       
       boolean flag = false;
       
       for(Amr_Saving__c quoteObj:quoteNeedToValidated){
          if(quoteObj.No_of_Masters__c!= null || quoteObj.Duration_of_Masters__c!= null || quoteObj.No_of_Additional_Films__c!= null
               || quoteObj.Duration_of_Additional_Films__c!= null || quoteObj.No_of_shoot_days__c!=null || quoteObj.Stage_RAP_engaged__c!=null
               || quoteObj.Script_Title__c!=null || quoteObj.Scope_re_brief__c !=null) {    
                flag = true;
            }else{
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please enter at least one value'));
               return false;
           }   
       }
     
     return flag;
    }
    
    public void uploadDocument(){
          
          if(document.body!=null){    
              
              system.debug(document+'--------document Body'+document.body +'lstQuoteToaddRow=='+lstQuoteToaddRow);
              List<Folder> FolderId = [SELECT Id,Name FROM Folder where name = 'Brief'];
              document.FolderId = FolderId[0].Id;
              insert document;
              
              counterOfUpload = counterOfUpload+1;  
              system.debug('counter Of upload=====>'+counterOfUpload);  
              FeedItem FI = new FeedItem();
              FI.ParentId = UserInfo.getUserId();
              FI.Body = 'Attachment added';
              FI.ContentData = document.body;
              FI.ContentFileName = document.Name;
              insert FI;
              
              system.debug('====>feed'+FI);
              if(document.id!=null){
                 
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.confirm,'File uploaded successfully'));
              }
              
              document = new document();
          }else{
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Upload File'));
          }
    }
    
}