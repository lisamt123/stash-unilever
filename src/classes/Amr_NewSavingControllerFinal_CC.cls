/**********************************************************************  
Name:  Amr_NewSavingControllerFinal_CC ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This class is holds the  business logic for Creation Of New Saving,Quote and Accepted Quote.                                                         
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  04/03/2016      INITIAL DEVELOPMENT            CSR: 
 ***********************************************************************/


public with sharing class Amr_NewSavingControllerFinal_CC {
     
    public Amr_Saving__c savingObj{get;set;}
    public String jobId{get;set;}
    public Amr_Job_Details__c jobDetailObj{get;set;}
    public String adManagerNumber{get;set;} 
    public List<SelectOption> shootLocation{get;set;}
    public List<String> selectedCountry{get;set;}
    public  Amr_Quote__c acceptedQuote {get;set;}
    public List<Amr_Quote__c> quoteList{
        get{
             if(quoteList == null)
                    quoteList = new List<Amr_Quote__c>();     
                return quoteList;
        }set;
    }
    
    public Document document {
        get {
          if (document == null)
             document = new Document();
             return document;
        }
        set;
    }
    //public Transient Document document{get;set;}
    public List<FeedItem> attachedList{
    get{
             if(attachedList== null)
                 attachedList= new List<FeedItem>();
             return attachedList;
    }set;} 
    
    public String IdDeleted{get;set;}
    public String IdDeletedSaving{get;set;}
    
    public List<FeedItem> attachedListSaving{
    get{
             if(attachedListSaving== null)
                 attachedListSaving= new List<FeedItem>();
             return attachedListSaving;
    }set;} 
    
    //Appraisal
    public Integer pcTimeMangCategoryValue {get;set;}
    public Integer pcCostMangCategoryValue {get;set;}
    public Integer pcProcessMangCategoryValue {get;set;}
    public Integer pcOutputQualityCategoryValue{get;set;}
    public Integer pccTimeMangCategoryValue {get;set;}
    public Integer pccCostMangCategoryValue {get;set;}
    public Integer pccProcessMangCategoryValue{get;set;}
    public Integer pccOutputQualityCategoryValue {get;set;}
    public Integer caTimeMangCategoryValue {get;set;}
    public Integer caCostMangCategoryValue {get;set;}
    public Integer caProcessMangCategoryValue{get;set;}
    public Integer caOutputQualityCategoryValue {get;set;}
    
    public String pcTimeMangCategoryClass {get;set;}
    public String pcCostMangCategoryClass {get;set;}
    public String pcProcessMangCategoryClass {get;set;}
    public String pcOutputQualityCategoryClass{get;set;}
    public String pccTimeMangCategoryClass {get;set;}
    public String pccCostMangCategoryClass {get;set;}
    public String pccProcessMangCategoryClass{get;set;}
    public String pccOutputQualityCategoryClass {get;set;}
    public String caTimeMangCategoryClass {get;set;}
    public String caCostMangCategoryClass {get;set;}
    public String caProcessMangCategoryClass{get;set;}
    public String caOutputQualityCategoryClass {get;set;}
    public String lstcov {
      get{
            lstcov = JSON.serialize(Amr_CurrencyConversionRate__c.getAll().values());
            return lstcov;
        }set;
    } 
    
    public Amr_NewSavingControllerFinal_CC(){
        jobId = ApexPages.currentPage().getParameters().get('id');
        jobDetailObj = new Amr_Job_Details__c();
        if(jobId!=null){
             jobDetailObj = [select id,AdManagerText__c from Amr_Job_Details__c where id = :jobId];
        }
        
        if(jobDetailObj.AdManagerText__c !=null){
                adManagerNumber = jobDetailObj.AdManagerText__c;
        }
         
        List<Amr_Country_Cluster__c> countrylst = Amr_Country_Cluster__c.getall().values();
        shootLocation = new List<SelectOption>();
        
        for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
        }
        
        savingObj = new Amr_Saving__c(Job_Details__c = jobId);
        acceptedQuote = new Amr_Quote__c(Quote_Number__c = 1,Is_Accepted__c = true);
        
        for(integer i=2;i<=5;i++){
            Amr_Quote__c quoteObj = new Amr_Quote__c(Quote_Number__c = i,Is_Accepted__c = false);
            quoteList.add(quoteObj);
            system.debug('inside add Quote');
        }
        system.debug('quote list==>'+quoteList);
       
    }
    
    
   /*******************************************************************    
   Purpose:  This method is used to insert data of Quote and Saving                                                        
   Parameters: 
   Returns: It’s return nothing 

   ********************************************************************/ 
    public void SaveQuoteAndSavingData(){
        system.debug('saving data'+savingObj);
        system.debug('accepted quote data'+acceptedQuote);
        system.debug('quote List data'+quoteList);
        //try{
            
            if(selectedCountry.size()>0){
                    for(String str : selectedCountry){
                        if(savingObj.Shoot_Location__c == null){
                            savingObj.Shoot_Location__c = str ;
                        }else{
                            savingObj.Shoot_Location__c += ','+str;
                        }
                    }
            }
            upsert savingObj;
            
            if(savingObj.id !=null){
                acceptedQuote.Saving__c = savingObj.id;
                upsert acceptedQuote;
                
                
                system.debug('accepted quote insert successfully===>'+acceptedQuote.id);
                
                for(Amr_Quote__c quoteObj:quoteList){
                    quoteObj.Saving__c = savingObj.id;
                }
                upsert quoteList;
                
            }
            Amr_Saving__c savingObjInserted = [select Cost_Per_Master__c,Cost_per_master_per_shoot_day__c,Percentage_Saving_Accepted_Quote__c,
                                Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Saving_Accepted_Quote_Euro__c, 
                                Production_Type__c,No_of_Masters__c,Duration_of_Masters__c,No_of_Additional_Films__c,Duration_of_Additional_Films__c,
                                No_of_shoot_days__c,Stage_RAP_engaged__c,Script_Title__c,Scope_re_brief__c,Number_Of_Quotes__c,Average_Total_Opening_Quotes__c from Amr_Saving__c where id =:savingObj.id];
            savingObj = savingObjInserted;
        //}catch(Exception e){
        //  system.debug('===inside exception'+e.getMessage());
        //}
    }
    
     /*******************************************************************    
   Purpose:  This method is used to insert document in accepted quote                                                      
   Parameters: 
   Returns: It’s return nothing 

   ********************************************************************/ 
   
    public void UploadAcceptedquoteDoc(){
        if(validateAccepted(acceptedQuote)){
            String parentId = null;
            system.debug('accepted quote Id '+acceptedQuote.id);
            acceptedQuote.Folder__c = 'Accepted Quotes and Documents';    
            if(acceptedQuote.id != null){
                parentId = acceptedQuote.Id;
                system.debug('parent Id==>'+parentId);
            }
        
            if(document.body!=null){    
                system.debug(document+'--------document Body'+document.body);        
                FeedItem FI = new FeedItem();
                FI.ParentId = parentId;
                FI.Body = 'Attachment added';
                FI.ContentData = document.body;
                system.debug('doc name==>'+document.Name);
                FI.ContentFileName = document.Name;
                insert FI;
                system.debug('feed Item Inserted===>'+FI.id);
                document = new document();
                
                if(FI.id!=null){
                     document.body = null;
                     FI = new FeedItem();
                     FI = null; 
                }
            }
         
            attachedList = [select id,CreatedById,CreatedBy.name,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,CreatedDate 
                                FROM FeedItem where ParentId =:parentId];
        }
    }
    
  /*******************************************************************    
   Purpose:  This method is used to validate acceptedQuote in order to insert Document                                                      
   Parameters: 
   Returns: It’s return boolean

   ********************************************************************/ 
    public boolean validateAccepted(Amr_Quote__c acceptedQuoteObj){
        boolean flag = false;
         if(acceptedQuoteObj.id!=null){
             flag = true;
         }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Save Saving and Quote'));
            document.body =null;
            return false;
         }
         return flag;
    }
    
   /*******************************************************************    
   Purpose:  This method is used to delete document                                              
   Parameters: 
   Returns: It’s return nothing 

   ********************************************************************/ 
    public void deleteDocument(){
        system.debug('feed Item Id need to be deleted ========>'+IdDeleted);
        FeedItem feedObj = [select id,CreatedById,CreatedBy.name,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,CreatedDate 
                                FROM FeedItem where id = :IdDeleted];
        delete feedObj;
        
        attachedList = [select id,CreatedById,CreatedBy.name,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,CreatedDate 
                                FROM FeedItem where ParentId =:acceptedQuote.id];
    }
    
    
   /*******************************************************************    
   Purpose:  This method is used to upload additional document                                           
   Parameters: 
   Returns: It’s return nothing 

   ********************************************************************/ 
    public void UploadAdditionalDoc(){
        if(validateAdditional(savingObj)){
            String parentId = null;
            system.debug('accepted quote Id '+acceptedQuote.id);
            //acceptedQuote.Folder__c = 'Accepted Quotes and Documents';    
            if(savingObj.id != null){
                parentId = savingObj.Id;
                system.debug('parent Id==>'+parentId);
            }
        
            if(document.body!=null){    
                system.debug(document+'--------document Body'+document.body);        
                FeedItem FI = new FeedItem();
                FI.ParentId = parentId;
                FI.Body = 'Attachment added';
                FI.ContentData = document.body;
                system.debug('doc name==>'+document.Name);
                FI.ContentFileName = document.Name;
                insert FI;
                system.debug('feed Item Inserted===>'+FI.id);
                document = new document();
            
                if(FI.id!=null){
                    document.body = null;
                    FI = new FeedItem();
                    FI = null; 
                }
            }
         
            attachedListSaving = [select id,CreatedById,CreatedBy.name,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,CreatedDate 
                                FROM FeedItem where ParentId =:parentId];
        }
    }
    
        
   /*******************************************************************    
   Purpose:  This method is used to validate saving in order to insert additional document                                                    
   Parameters: 
   Returns: It’s return boolean

   ********************************************************************/ 
    public boolean validateAdditional(Amr_Saving__c savingObj){
        boolean flag = false;
         if(savingObj.id!=null){
             flag = true;
         }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Save Saving and Quote'));
            document.body =null;
            return false;
         }
         return flag;
    }
    
    /*******************************************************************    
   Purpose:  This method is used to delete document uploaded in additional document                                                     
   Parameters: 
   Returns: It’s return nothing

   ********************************************************************/ 
    public void deleteDocumentSaving(){
        system.debug('feed Item Id need to be deleted ========>'+IdDeletedSaving);
        FeedItem feedObj = [select id,CreatedById,CreatedBy.name,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,CreatedDate 
                                FROM FeedItem where id = :IdDeletedSaving];
        delete feedObj;
        
        attachedListSaving = [select id,CreatedById,CreatedBy.name,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,CreatedDate 
                                FROM FeedItem where ParentId =:savingObj.id];
    }
    
    public void getCaProcessMangCategory(){
     system.debug('inside');
    }
    
    
    /*******************************************************************    
   Purpose:  This method is used to insert appraisal data                                                 
   Parameters: 
   Returns: It’s return Pagereference

   ********************************************************************/ 
    
     public Pagereference AllValues(){
        Boolean flag = true;
        if(attachedListSaving.size()<1 || attachedList.size()<1){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please attach at least one document in accepted Quote and one in additional document'));
            flag = false;
            
        }
        if(savingObj.id == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Save Saving and Quote '));
            flag = false;
        }
        
        if(!flag) {
            return null;
        }
       
        System.debug('Pc TIME MANAGEMENT  ->  '+ pcTimeMangCategoryValue + ' CLASSS -> 1' +  pcTimeMangCategoryClass );
        System.debug('PC COST MANAGE MENT -> '+ pcCostMangCategoryValue + ' CLASSS -> 2' + pcCostMangCategoryClass );
        System.debug(' PC PROCESS MANAGEMNT -> '+ pcProcessMangCategoryValue  + ' CLASSS ->3 ' + pcProcessMangCategoryClass );
        System.debug('PC OUTPUT -> '+ pcOutputQualityCategoryValue  + ' CLASSS -> 4' + pcOutputQualityCategoryClass);
        System.debug('PPC TIME MAN --> ' +  pccTimeMangCategoryValue  + ' CLASSS ->5 ' + pccTimeMangCategoryClass );
        System.debug('PPC COST -> ' + pccCostMangCategoryValue  + ' CLASSS -> 6' + pccCostMangCategoryClass );
        System.debug('PPC PROCESS MANG -> '+ pccProcessMangCategoryValue  + ' CLASSS ->7 ' + pccProcessMangCategoryClass);
        System.debug('PPC OUTPUT -> ' + pccOutputQualityCategoryValue  + ' CLASSS ->8 ' + pccOutputQualityCategoryClass );
        System.debug('CA TIME MANG ->'+ caTimeMangCategoryValue  + ' CLASSS ->9 ' + caTimeMangCategoryClass );
        System.debug('CA COST MANG -> '+ caCostMangCategoryValue   + ' CLASSS -> 10' + caCostMangCategoryClass );
        System.debug('CA PROCESS MANG -> ' + caProcessMangCategoryValue  + ' CLASSS ->11 ' + caProcessMangCategoryClass);
        System.debug('CA OUTPUR -> '+ caOutputQualityCategoryValue  + ' CLASSS -> 12' + caOutputQualityCategoryClass );
        
        if(savingObj.id != null){
            //pc appraisal
              savingObj.PC_Appraisal_Time_Management__c = String.valueOf(pcTimeMangCategoryValue);
              savingObj.PC_Appraisal_Output_Quality__c = String.valueOf(pcOutputQualityCategoryValue);
              savingObj.PC_Appraisal_Process_Management__c = String.valueOf(pcProcessMangCategoryValue);
              savingObj.PC_Appraisal_Cost_Management__c = String.valueOf(pcCostMangCategoryValue);
             //PPC Appraisal
              savingObj.PPC_Appraisal_Time_Management__c = String.valueOf(pccTimeMangCategoryValue);
              savingObj.PPC_Appraisal_Output_Quality__c = String.valueOf(pccOutputQualityCategoryValue);
              savingObj.PPC_Appraisal_Process_Management__c = String.valueOf(pccProcessMangCategoryValue);
              savingObj.PPC_Appraisal_Cost_Management__c = String.valueOf(pccCostMangCategoryValue);
             //CA Appraisal
              savingObj.CA_Appraisal_Time_Management__c = String.valueOf(caTimeMangCategoryValue);
              savingObj.CA_Appraisal_Output_Quality__c = String.valueOf(caOutputQualityCategoryValue );
              savingObj.CA_Appraisal_Process_Management__c = String.valueOf(caProcessMangCategoryValue);
              savingObj.CA_Appraisal_Cost_Management__c = String.valueOf(caCostMangCategoryValue);
              
              
               //pc appraisal class
              savingObj.Pc_Time_Manage_Star__c = String.valueOf(pcTimeMangCategoryClass );
              savingObj.Pc_Output_Quality_Star__c= String.valueOf(pcOutputQualityCategoryClass);
              savingObj.Pc_Proces_Manage_Star__c= String.valueOf(pcProcessMangCategoryClass );
              savingObj.Pc_Cost_Manage_Star__c = String.valueOf(pcCostMangCategoryClass);
             //PPC Appraisal Class
              savingObj.Ppc_Time_Manage_Star__c= String.valueOf(pccTimeMangCategoryClass );
              savingObj.Ppc_Output_Quality_Star__c= String.valueOf(pccOutputQualityCategoryClass );
              savingObj.Ppc_Process_Manage_Star__c= String.valueOf(pccProcessMangCategoryClass);
              savingObj.Ppc_Cost_Manage_Star__c= String.valueOf(pccCostMangCategoryClass );
             //CA Appraisal classs
              savingObj.Ca_Time_Manage_Star__c= String.valueOf(caTimeMangCategoryClass );
              savingObj.Ca_Output_Quality_Star__c= String.valueOf(caOutputQualityCategoryClass );
              savingObj.Ca_Process_Manage_Star__c= String.valueOf(caProcessMangCategoryClass);
              savingObj.Ca_Cost_Manage_Star__c= String.valueOf(caCostMangCategoryClass );
              
              
              update savingObj;
              
        }
        return null;
     }
}