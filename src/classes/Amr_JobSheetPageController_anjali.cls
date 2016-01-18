public with sharing class Amr_JobSheetPageController_anjali {

    public String docUploaded{get;set;}
    public String adManagerNumber{get;set;}
    public integer counterOfUpload = 0; 
    public String IdValue{get;set;}
    public boolean display{get;set;}
    public string IdNeedToUpdate{get;set;}
    public String productionType{get;set;}
    public  boolean DisplayLink{get;set;}
    public String quoteJobId{get;set;}
    public List<SelectOption> shootLocation{get;set;}
    public List<String> selectedCountry{get;set;}
    public String IdDeleted{get;set;}
    public  Document document {
        get {
          if (document == null)
             document = new Document();
             return document;
        }
        set;
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
    public string userId{get;set;}
    
    public Amr_JobSheetPageController_anjali(){
   
       try{
            isSave = false;
            isEdit = false;
            display = true;
            jobId = ApexPages.currentPage().getParameters().get('id');
            displayLink = true;
            selectedCountry = new List<String> {'Test'};
            List<Amr_Country_Cluster__c> countrylst=  Amr_Country_Cluster__c.getall().values();
            shootLocation = new List<SelectOption>();
            for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
            }
            
            system.debug('========>jobId'+jobId);
                        system.debug('========>selectedCountry '+selectedCountry );
             userId = userinfo.getuserid();
            List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='CAP' order by Assignee.name];
            boolean flag = false;
            for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                 if(userId == permissionObj.Assignee.id){
                   
                    flag = true;
                    system.debug('inside cap User===>');
                    break;
                 }
             }
           /* List<Amr_Saving__c> test = [select Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById
                               from Amr_Saving__c where Job_Details__r.id = :jobId];
                               
             system.debug('test==>'+test );*/
            if(jobId != null){
                 if(flag == true){
                      quoteList = [select Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Percentage_Saving_Average_of_Quote__c,Euro_Saving_Average_of_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c from Amr_Saving__c where Job_Details__r.id = :jobId];
                      system.debug('inside Cap List========>'+quoteList );
                 }else{
                   quoteList = [select Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Euro_Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quote__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c from Amr_Saving__c where Job_Details__r.id = :jobId AND (CreatedById = :userId OR LastModifiedById = :userId )];
                      system.debug('inside Rap List========>'+quoteList );
                 }            
                               //
                quoteJobId = jobId;
                if(quoteList.size()>0){
                        adManagerNumber = quoteList[0].Job_Details__r.AdManagerText__c;
                }else{
                   Amr_Job_Details__c jobObj = [select AdManagerText__c from Amr_Job_Details__c where id = :jobId];
                   adManagerNumber = jobObj.AdManagerText__c;
                }
                Amr_Saving__c obj = new Amr_Saving__c(Job_Details__c = quoteJobId);
                lstQuoteToaddRow.add(obj);
                system.debug('=====lstrow'+lstQuoteToaddRow);
            }
      
        }catch(exception e){
          system.debug('inside Excetion==>');
        }
    }
    
     
    public void SaveUpdatedData(){
    
    system.debug('inside IdValue==>'+IdValue);
        system.debug('inside onee==>'+Apexpages.currentPage().getParameters().get('one'));
        if(IdValue!=null){
            display = false;
            isEdit  = false;
            isSave = true;
        }      
    }
   
    public Boolean isEdit {get;set;}
    public Boolean isSave {get;set;}
    public void SaveNewData(){
        try{
        
         system.debug('selectedCountry=============>'+selectedCountry);
         if(selectedCountry == null || selectedCountry.size()<=0){
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Shoot Location'));
         }else{
             quoteList[0].Shoot_Location__c = null;
             for(String str : selectedCountry){
                  if(quoteList[0].Shoot_Location__c == null){
                            quoteList[0].Shoot_Location__c = str ;
                  }else{
                          quoteList[0].Shoot_Location__c += ','+str;
                  }
             }
             upsert quoteList;
             isEdit  = true;
             isSave = false;
             
             system.debug('===updated Quote List=============>'+quoteList+'---'+IdNeedToUpdate+'==='+DisplayLink);
         }
         
         }catch(Exception e){
          system.debug('upsert exception===');
         
         }
        
    }
      
    
    public PageReference  addRowSavingLine(){
     system.debug('===>list size=='+lstQuoteToaddRow);
        system.debug('------selected Country---'+selectedCountry);
    system.debug('===lstQuoteToaddRow===========>'+lstQuoteToaddRow);
            if(validate(lstQuoteToaddRow,document)){
                String Interests = '';
                if(lstQuoteToaddRow.size()>0 ){
                    for(String str : selectedCountry){
                        if(lstQuoteToaddRow[0].Shoot_Location__c == null){
                          lstQuoteToaddRow[0].Shoot_Location__c = str ;
                        }else{
                         lstQuoteToaddRow[0].Shoot_Location__c += ','+str ;
                        
                        }
                        
                        Interests = Interests + ';' + Str;
                    }
                    lstQuoteToaddRow[0].Shoot_Location_Multiselect__c = Interests ;
                    insert lstQuoteToaddRow;
                     
                     if(!uploadDocument(lstQuoteToaddRow)){
                         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Record is saved successfully'));
                     }
                   system.debug('---document insdie addRow--'+document);
                    system.debug('========>'+lstQuoteToaddRow);
                }
                
                list<String> insertedQuoteIdsList =  new list<String>();
                 List<Id> lstJobId = new List<Id>();
                for(Amr_Saving__c qoute:lstQuoteToaddRow){
                    
                    insertedQuoteIdsList.add(qoute.id);
                    
                    lstJobId.add(qoute.Job_Details__c);
                    
                     
                } 
                List<Amr_Job_Allocation__c> lstJobAllocation = new List<Amr_Job_Allocation__c>();
                List<Amr_Job_Allocation__c> lstJobAllocationUpdate = new List<Amr_Job_Allocation__c>();
                lstJobAllocation = [Select Id, Job_Allocated__c,Reported__c,Reported_Image__c from Amr_Job_Allocation__c where AM_Job_Detail__c IN : lstJobId ] ;
                
                for(Amr_Job_Allocation__c objJobAllocation : lstJobAllocation){
                    
                    objJobAllocation.Reported__c = 'Yes';
                    lstJobAllocationUpdate.add(objJobAllocation);
                }
                
                update lstJobAllocationUpdate;
                
                
                List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='CAP' order by Assignee.name];
            boolean flag = false;
            for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                 if(userId == permissionObj.Assignee.id){
                   
                    flag = true;
                    system.debug('inside cap User===>');
                    break;
                 }
             }
             if(flag == true){
                      lstQuoteToaddRow = [select id,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Production_Type__c,Duration_of_Additional_Films__c,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Job_Details__r.AdManagerText__c,
                                Number_Of_Quotes__c,Euro_Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quote__c,Average_Total_Opening_Quotes__c,Saving_Accepted_Quote_Euro__c,Percentage_Saving_Accepted_Quote__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c
                               from Amr_Saving__c where id in : insertedQuoteIdsList];
                 }else{
                   lstQuoteToaddRow = [select id,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Production_Type__c,Duration_of_Additional_Films__c,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Job_Details__r.AdManagerText__c,
                                Number_Of_Quotes__c,Euro_Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quote__c,Average_Total_Opening_Quotes__c,Saving_Average_of_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c
                               from Amr_Saving__c where id in : insertedQuoteIdsList AND (CreatedById = :userId OR LastModifiedById = :userId )];
                 }  
                /*lstQuoteToaddRow = [select id,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Production_Type__c,Duration_of_Additional_Films__c,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Job_Details__r.AdManagerText__c,
                                Number_Of_Quotes__c,Average_Total_Opening_Quotes__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c
                               from Amr_Saving__c where id in : insertedQuoteIdsList];*/
                system.debug('ids inserted===>'+insertedQuoteIdsList);
               
                
                for(Amr_Saving__c QuoteObj:lstQuoteToaddRow){
                    
                    quoteList.add(QuoteObj);
                }
            } 
       
        lstQuoteToaddRow.clear();
        lstQuoteToaddRow.add(new Amr_Saving__c(Job_Details__c = quoteJobId));
        counterOfUpload = 0;
       
        //document = new document();
        system.debug('===>list size=='+lstQuoteToaddRow);
        system.debug('------selected Country---'+selectedCountry);
        return null;
    }
    
    
    public boolean validate(List<Amr_Saving__c> quoteNeedToValidated,Document document){
       
       boolean flag = false;
       
       for(Amr_Saving__c quoteObj:quoteNeedToValidated){
          if((quoteObj.No_of_Masters__c!= null || quoteObj.Duration_of_Masters__c!= null || quoteObj.No_of_Additional_Films__c!= null
               || quoteObj.Duration_of_Additional_Films__c!= null || quoteObj.No_of_shoot_days__c!=null || quoteObj.Stage_RAP_engaged__c!=null
               || quoteObj.Production_Type__c!=null || quoteObj.Script_Title__c!=null || quoteObj.Scope_re_brief__c !=null) && document.body!=null) {    
               
                flag = true;
            }else{
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.Amr_Error_FileUpload));
               document.body = null;
               return false;
           }   
       }
     
     return flag;
    }
    
    public boolean uploadDocument(List<Amr_Saving__c> idsList){
          system.debug('id-------?>'+idsList);
           String parentId ;
          if(idsList.size()>0){
                parentId = idsList[0].Id;
                  system.debug('=======>'+parentId);
          }
          if(document.body!=null){    
              
              system.debug(document+'--------document Body'+document.body +'lstQuoteToaddRow=='+lstQuoteToaddRow);
              List<Folder> FolderId = [SELECT Id,Name FROM Folder where name = 'Brief'];
              document.FolderId = FolderId[0].Id;
              insert document;
              
              counterOfUpload = counterOfUpload+1;  
              system.debug('counter Of upload=====>'+counterOfUpload);  
              FeedItem FI = new FeedItem();
              FI.ParentId = parentId;
              FI.Body = 'Attachment added';
              FI.ContentData = document.body;
             
              FI.ContentFileName = document.Name +'*'+idsList[0].Folder_Name__c;
              system.debug('--->file Name'+FI.ContentFileName);
              insert FI;
  
              document = new document();
              if(document.id!=null && FI.id!=null){
                 document.body = null;
                 return true;
              }
          }
          return false;
    }
    
    public PageReference redirectNewPage(){
        PageReference redirectPage = new PageReference('/apex/Amr_Multiple_Document_Upload');
        //PageReference redirectPage = Page.Amr_Multiple_Document_Upload;
        redirectPage.setRedirect(true);
        redirectPage.getParameters().put('id',jobId);
        return redirectPage;
    }
    
    public void deleteQuote(){
      
       List<Amr_Saving__c> quoteToBeDeleted = new List<Amr_Saving__c>();
        
       integer index=0;
       integer indexNeedToRemove = 0;
       
       for(Amr_Saving__c quoteObj:quoteList ){
            index = index+1;
            if(quoteObj.id == IdDeleted){
               system.debug('===?'+index+'==index');
               system.debug('==index'+quoteList.get(index-1));
               indexNeedToRemove = index-1;
               quoteToBeDeleted.add(quoteObj);
            }
          
        }
        
        quoteList.remove(indexNeedToRemove);
        delete quoteToBeDeleted;
        
    }
    
}