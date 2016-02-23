public with sharing class UtkarshSavingSub{
    public String docUploaded{get;set;}
    public String adManagerNumber{get;set;}
    public integer counterOfUpload = 0; 
    public String saveRecordValue{get;set;}
    public String saveRecordValueForQuote {get;set;}
    public String saveRecordValueForAccQuote{get;set;}
    public boolean display{get;set;}
    public string IdNeedToUpdate{get;set;}
   // public String productionType{get;set;}
    public  boolean DisplayLink{get;set;}
    public String quoteJobId{get;set;}
    public string savingId{get;set;}
    public String quoteId{get;set;}
    public List<SelectOption> shootLocation{get;set;}
    public List<String> selectedCountry{get;set;}
    public String IdDeleted{get;set;}
    public List<SelectOption> productionType{get;set;}
    public List<String> selectedProductionType{get;set;}
    public Amr_Job_Details__c jobDetailObj{get;set;}
    public boolean editedSavingMode{get;set;}
    public boolean viewSavingMode{get;set;}
    public boolean editedQuoteMode{get;set;}
    public boolean viewQuoteMode{get;set;}
    public boolean editedAcceptedQuote{get;set;}
    public boolean viewAcceptedQuote{get;set;}
    public Blob fileBody   {get;set;}
    public Integer QuoteNumber{get;set;}
    
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
    //Appraisal Class
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
    public Amr_Quote__c quoteObj{get;set;}
    
    
    //public  Amr_Quote__c acceptedQuote {get;set;}
    public  Document document {
        get {
          if (document == null)
             document = new Document();
             return document;
        }
        set;
   }
    public List<InnerSavingClass> docAndQuoteLst{
        get{
             if(docAndQuoteLst == null)
                    docAndQuoteLst = new List<InnerSavingClass>();     
                return docAndQuoteLst;
        }set;
    }
    public String lstcov {
      get{
            lstcov = JSON.serialize(Amr_CurrencyConversionRate__c.getAll().values());
            return lstcov;
        }set;
    }  
    public String jobId{get;set;}
    public List<Amr_Saving__c> quoteList{get;set;}
    public List<Amr_Quote__c> quoteRelatedToSavingList{get;set;}
  /*  public List<Amr_Saving__c> lstQuoteToaddRow{
        get{
             if(lstQuoteToaddRow == null)
                    lstQuoteToaddRow = new List<Amr_Saving__c>();     
                return lstQuoteToaddRow;
        }set;
    }*/
    public string userId{get;set;}
    public UtkarshSavingSub(){
        try{
        editedSavingMode = false;
        viewSavingMode = true;
        editedQuoteMode = false;
        viewQuoteMode = true;
        editedAcceptedQuote = false;
        viewAcceptedQuote = true;
        jobId = ApexPages.currentPage().getParameters().get('id');
        quoteObj = new Amr_Quote__c();
        selectedCountry = new List<String> {'Test'};
        List<Amr_Country_Cluster__c> countrylst=  Amr_Country_Cluster__c.getall().values();
        shootLocation = new List<SelectOption>();
        for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
            }
            
            system.debug('========>jobId'+jobId);
                        system.debug('========>selectedCountry '+selectedCountry );
             userId = userinfo.getuserid();
             updateData();
        }catch(Exception e){
            System.debug('ERROR   ->  ' + e.getMessage());
        }
         
    //  getSelectedRatingStar();       
  }
         
    public void updateData(){
        try{
            
           
            
            
            List<PermissionSetAssignment> PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name ='CAP' order by Assignee.name];
            boolean flag = false;
            for(PermissionSetAssignment permissionObj:PermissionSetAssignmentList){
                 if(userId == permissionObj.Assignee.id){
                   
                    flag = true;
                    system.debug('inside cap User===>');
                    break;
                 }
             }
             if(jobId!=null){
            jobDetailObj = [select id,AdManagerText__c,NewOriginalMasterTv__c,NewOriginalMasterCinema__c,NewOriginalMasterRadio__c,NewOriginalMasterPrint__c,
                                                     NewOriginalMasterOutofHome__c,NewOriginalMasterInStore__c,NewOriginalMasterDigital__c,
                                                     NewOriginalMasterInternalVideo__c,LanguageAdaptionMasterTv__c,LanguageAdaptionMasterCinema__c,LanguageAdaptionMasterRadio__c,
                                                     LanguageAdaptionMasterPrint__c,LanguageAdaptionMasterOutofHome__c,LanguageAdaptionMasterInStore__c,LanguageAdaptionMasterDigital__c,
                                                     LanguageAdaptionMasterInternalVideo__c,AdditionalSupplementaryNewMaterialTv__c,AdditionalSupplementaryNewMaterialCinema__c,
                                                     AdditionalSupplementaryNewMaterialRadio__c,AdditionalSupplementaryNewMaterialPrint__c,AdditionalSupplementaryNewMaterialOOH__c,
                                                     AdditionalSupplementaryNewMaterialStore__c,AdditionalSupplementaryNewMaterialDigi__c,AdditionalSupplementaryNewMaterialIVideo__c,
                                                     ReworkExistingMaterialTv__c,ReworkExistingMaterialCinema__c,ReworkExistingMaterialRadio__c,ReworkExistingMaterialPrint__c,
                                                     ReworkExistingMaterialOutofHome__c,ReworkExistingMaterialInStore__c,ReworkExistingMaterialDigital__c,ReworkExistingMaterialInternalVideo__c,
                                                     BuyoutsTalentTv__c,BuyoutsTalentCinema__c,BuyoutsTalentInStore__c,BuyoutsTalentRadio__c,BuyoutsTalentPrint__c,BuyoutsTalentOutofHome__c,
                                                     BuyoutsTalentDigital__c,BuyoutsTalentInternalVideo__c,BuyoutsMusicTv__c,BuyoutsMusicCinema__c,BuyoutsMusicRadio__c,BuyoutsMusicPrint__c,
                                                     BuyoutsMusicOutofHome__c,BuyoutsMusicInStore__c,BuyoutsMusicDigital__c,BuyoutsMusicInternalVideo__c 
                                                      
                                                     from Amr_Job_Details__c where id = :jobId];
            
           
           
         }
        
           
            if(jobId != null){
                 if(flag == true){
                      quoteList = [select PC_Appraisal_Time_Management__c,PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c,PPC_Appraisal_Process_Management__c ,PPC_Appraisal_Cost_Management__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Output_Quality__c ,CA_Appraisal_Process_Management__c ,CA_Appraisal_Cost_Management__c,Folder_Name__c,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Percentage_Saving_Average_of_Quote__c,Euro_Saving_Average_of_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c from Amr_Saving__c where Job_Details__r.id = :jobId];
                      system.debug('inside Cap List========>'+quoteList );
                      
                      
                 }else{
                   quoteList = [select PC_Appraisal_Time_Management__c,PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c,PPC_Appraisal_Process_Management__c ,PPC_Appraisal_Cost_Management__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Output_Quality__c ,CA_Appraisal_Process_Management__c ,CA_Appraisal_Cost_Management__c,Folder_Name__c,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Euro_Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quote__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c from Amr_Saving__c where Job_Details__r.id = :jobId AND (CreatedById = :userId OR LastModifiedById = :userId )];
                      system.debug('inside Rap List========>'+quoteList );
                     
                 }            
                  Set<Id>savingIds=new Set<Id>();
                      for(Amr_Saving__c saving:quoteList){
                        savingIds.add(saving.Id);
                      }
                      quoteRelatedToSavingList = [select Saving_Type__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Accepted_Final_Cost_props_wardrobe__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Editors_name__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_PPC_only_Local_Am__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Saving__c,Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id,Folder__c from Amr_Quote__c where Saving__c IN :savingIds ORDER BY Quote_Number__c];             //
               
              //  quoteJobId = jobId;
                if(quoteList.size()>0){
                        adManagerNumber = quoteList[0].Job_Details__r.AdManagerText__c;
                }else{
                   Amr_Job_Details__c jobObj = [select AdManagerText__c from Amr_Job_Details__c where id = :jobId];
                   adManagerNumber = jobObj.AdManagerText__c;
                }
                  
                         
              
            }
      
        }catch(exception e){
          system.debug('inside Excetion==>');
        }
    }
   
    integer i = 1;
  
    public PageReference addRowQuote(){
        
        try{
         system.debug('savingId!!'+savingId);
        Amr_Quote__c[] quoteNumberList  = [select Quote_Number__c from Amr_Quote__c where Saving__c =:savingId ORDER BY Quote_Number__c DESC];
      
                   
        system.debug('savingId!!'+savingId+'quoteNumberList.size()!!'+quoteNumberList.size()+'quoteNumberList!!'+quoteNumberList);
        if(quoteNumberList.size()<5){
             system.debug('11111!11111'+docAndQuoteLst.size());
            Amr_Quote__c quoteObj = new  Amr_Quote__c();
              if(quoteNumberList.size()>0){
                      system.debug('1333333331'+quoteNumberList.size() );
                    if((quoteNumberList.size()-1 > 5) || (docAndQuoteLst.size()-1 > 5) || (docAndQuoteLst.size() + quoteNumberList.size()) > 4){
         system.debug('errorr!!');
         
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No more docs can be added'));
         
          return null;
          
        } 
                        
                      if(docAndQuoteLst != null && !docAndQuoteLst.isEmpty()){
                        
                        quoteObj.Saving__c = savingId;
                        quoteObj.Quote_Number__c = (docAndQuoteLst.size());
                        docAndQuoteLst.add(new InnerSavingClass(Integer.valueof(quoteNumberList.size()+quoteObj.Quote_Number__c+1),false,quoteObj));
                    }
                    else{
                        quoteObj.Saving__c = savingId;
                        quoteObj.Quote_Number__c = (quoteNumberList.size()) +1;
                        docAndQuoteLst.add(new InnerSavingClass(Integer.valueof(quoteObj.Quote_Number__c),false,quoteObj));
                        
                    }
                    
              }
              else{
                   // quoteObj.Quote_Number__c =1;
                  // quoteObj.Saving__c = savingId;
                   // docAndQuoteLst.add(new InnerSavingClass(Integer.valueof(quoteObj.Quote_Number__c),true,quoteObj));
                   
                    if(docAndQuoteLst != null && !docAndQuoteLst.isEmpty()){
                        
                        quoteObj.Saving__c = savingId;
                        quoteObj.Quote_Number__c = (docAndQuoteLst.size());
                        docAndQuoteLst.add(new InnerSavingClass(Integer.valueof(quoteObj.Quote_Number__c+1 ),false,quoteObj));
                    }
                    else{
                        quoteObj.Saving__c = savingId;
                        quoteObj.Quote_Number__c = (quoteNumberList.size()) +1;
                        docAndQuoteLst.add(new InnerSavingClass(Integer.valueof(quoteObj.Quote_Number__c),true,quoteObj));
                        
                    }
            }
             
                system.debug(quoteNumberList.size());
        }else if(quoteNumberList.size() > 5 || docAndQuoteLst.size() > 5 || (docAndQuoteLst.size() + quoteNumberList.size()) > 5){
         system.debug('errorr!!');
         
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No more docs can be added'));
         
          return null;
          
        }   
        }catch(Exception e){} 
          return null;
    }
    
    public class InnerSavingClass{
        public Amr_Quote__c quoteObj{get;set;}
        public Document attachmentObj{get;set;}
        
        
        public InnerSavingClass( Integer i,Boolean accepted ,Amr_Quote__c quoteObj1){
            quoteObj = quoteObj1;
            quoteObj.Quote_Number__c = i;
            quoteObj.Is_Accepted__c = accepted;
            attachmentObj = new Document();
        }
        
    }
    
     public PageReference SaveNewQuote(){
        system.debug('==========>quoteObj'+docAndQuoteLst);
        system.debug('==========>fileBody'+fileBody);
        system.debug('==========>QuoteNumber'+QuoteNumber);
        system.debug('savingId!!'+savingId);
        
        
        
       try{ 
        
        if(savingId != null && docAndQuoteLst.size()>0){
             
         Amr_Quote__c[] quoteNumberList  = [select Quote_Number__c from Amr_Quote__c where Saving__c =:savingId ORDER BY Quote_Number__c DESC];             //
         integer counter = docAndQuoteLst.size()-1;
            
            if(docAndQuoteLst.size()>1 && docAndQuoteLst[counter-1].quoteObj.id == null && docAndQuoteLst[counter-1].quoteObj.Quote_Number__c != QuoteNumber){
                system.debug('inside quote error msg=========>');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Save Previous Quote'));
                return null;
            }   else{ 
             
             List<FeedItem>   lstFeedItem = new    List<FeedItem> ();   
              List<Amr_Quote__c >   lstquoteItem = new    List<Amr_Quote__c > ();     
            for(InnerSavingClass innerObj:docAndQuoteLst){
                system.debug('---inside for'+innerObj);
                    Document doc = new Document();
                    Amr_Quote__c quoteToInsert = new Amr_Quote__c();
                    system.debug('inside quote Number====>'+innerObj.quoteObj);
                    quoteToInsert = innerObj.quoteObj;
                    doc = innerObj.attachmentObj;
                   // innerObj.attachmentObj = NULL;
                    
                     if(quoteToInsert.Saving__c == null){
                        quoteToInsert.Saving__c = savingId;
                        }
                  /*  if(quoteNumberList.size()>0){
                    quoteToInsert.Quote_Number__c = quoteNumberList[0].Quote_Number__c +1;
                    }else{
                    quoteToInsert.Quote_Number__c =1;
                    }*/
                    
                    if(doc != null &&  doc.body!=null && quoteToInsert.id !=null){    
              
                         Amr_Quote__c quoteObj = [select Folder__c from Amr_Quote__c where Id =:quoteToInsert.id];
              
                        system.debug(document+'--------document Body'+doc.body);        
                        FeedItem FI = new FeedItem();
                        FI.ParentId = quoteToInsert.id;
                        FI.Body = 'Attachment added';
                        FI.ContentData = doc.body;
                      
                        FI.ContentFileName = doc.Name +'*'+quoteObj.Folder__c;
                        lstFeedItem.add(FI);
                       // doc = new document();
                    
                    }
                    lstquoteItem.add(quoteToInsert);
            }
           
            
                       
            upsert lstquoteItem;
            
            insert lstFeedItem;
            lstFeedItem = new List<FeedItem> ();   
            lstFeedItem = null;
            system.debug('lstquoteItem====>'+lstquoteItem);
            
            if(lstquoteItem.size()>0){
                for(Amr_Quote__c quote:lstquoteItem){
                    if(quote.Is_Accepted__c == true){
                        quote.Accepted_Final_Cost_PC_only_Currency__c = quote.Local_Currency_of_PC_Costs__c;
                        quote.Accepted_Final_Cost_PC_only_Local_Amo__c = quote.Local_Amount_of_PC__c;
                        quote.Accepted_Final_Cost_PC_Euro_Amou__c = String.ValueOf(quote.PC_Costs_Euro_Amount__c);
                        
                        quote.Accepted_Final_Cost_PPC_only_Currency__c = quote.Local_Currency_of_PPC_Costs__c;
                        quote.Accepted_Final_Cost_PPC_only_Local_Am__c = quote.Local_Amount_of_PPC__c;
                        quote.Accepted_Final_Cost_PPC_Euro_Amount__c =quote.PPC_Costs_Euro_Amount__c;
                        
                        quote.Accepted_Final_Cost_CA_only_Currency__c = quote.Local_Currency_of_CA_Costs__c;
                        quote.Accepted_Final_Cost_CA_Local_Amount__c = quote.Local_Amount_of_CA__c;
                        quote.Accepted_Final_Cost_CA_Euro_Amount__c = String.ValueOf(quote.CA_Costs_Euro_Amount__c);
                        
                        quote.Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c = quote.Total_Cost__c;
                    }
                }
            
            }
            
           update lstquoteItem;
           system.debug('updated with accepted lstquoteItem !!'+lstquoteItem);
            
         }
        }
       }catch(Exception e){
       
       }
       //  pagereference page = new PageReference('/apex/Amr_SubmittedSaving?id='+jobid);page.setRedirect(true); return page ;
        return null;
    }
    public void SaveQuote(){}
    public PageReference editSaving(){
        
        if(saveRecordValue!=null){
        editedSavingMode = true;
        }
       
        return null;
    }
    
    public PageReference editQuote(){
        
    system.debug('saveRecordValueForQuote!!'+saveRecordValueForQuote);
        editedQuoteMode = true;
        
        return null;
    }
    
    public PageReference submitDataQuote(){
        system.debug('quoteId!!'+quoteId);
        system.debug('document outside quote!!'+fileBody);
         try{
    document.body =  fileBody ;
    update quoteRelatedToSavingList;
    if(quoteRelatedToSavingList.size()>0){
        for(Amr_Quote__c quote:quoteRelatedToSavingList){
            if(quote.Is_Accepted__c == true){
                        quote.Accepted_Final_Cost_PC_only_Currency__c = quote.Local_Currency_of_PC_Costs__c;
                        quote.Accepted_Final_Cost_PC_only_Local_Amo__c = quote.Local_Amount_of_PC__c;
                        quote.Accepted_Final_Cost_PC_Euro_Amou__c = String.ValueOf(quote.PC_Costs_Euro_Amount__c);
                        
                        quote.Accepted_Final_Cost_PPC_only_Currency__c = quote.Local_Currency_of_PPC_Costs__c;
                        quote.Accepted_Final_Cost_PPC_only_Local_Am__c = quote.Local_Amount_of_PPC__c;
                        quote.Accepted_Final_Cost_PPC_Euro_Amount__c =quote.PPC_Costs_Euro_Amount__c;
                        
                        quote.Accepted_Final_Cost_CA_only_Currency__c = quote.Local_Currency_of_CA_Costs__c;
                        quote.Accepted_Final_Cost_CA_Local_Amount__c = quote.Local_Amount_of_CA__c;
                        quote.Accepted_Final_Cost_CA_Euro_Amount__c = String.ValueOf(quote.CA_Costs_Euro_Amount__c);
                        
                        quote.Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c = quote.Total_Cost__c;
                    }
        }
    
    }
     update quoteRelatedToSavingList;
     system.debug('updated with accepted quote on click of edit'+quoteRelatedToSavingList);
    if(document.body!=null && quoteId!=null){
    Amr_Quote__c quoteObj = [select Folder__c from Amr_Quote__c where Id =:quoteId];
    
       
              
            system.debug(document+'--------document Body'+document.body );        
            FeedItem FI = new FeedItem();
            FI.ParentId = quoteId;
            FI.Body = 'Attachment added';
            FI.ContentData = document.body;
          
            FI.ContentFileName = document.Name +'*'+quoteObj.Folder__c;
            insert FI;
  system.debug('FI!!'+FI+'quoteObj!!'+quoteObj);
            document = new document();
        }
        editedQuoteMode = false;
        updateData();
        pagereference page = new PageReference('/apex/Amr_SubmittedSaving?id='+jobid);page.setRedirect(true); return page ;
         system.debug('quoteRelatedToSavingList!!'+quoteRelatedToSavingList);
         }catch(Exception e){
         system.debug('inside quote submit data exception');
         }   
    return null;
    }
    
    public PageReference submitData(){
    system.debug('savingId!!'+savingId);
      system.debug('document outside!!'+fileBody );
      try{
        
      document.body =  fileBody ;
     if(document.body!=null && savingId!=null){     
    Amr_Saving__c savingObj = [select Folder_Name__c,Shoot_Location__c from Amr_Saving__c where Id =:savingId];  
     
    
    if(selectedCountry.size()>0){   
    for(String str : selectedCountry){
                if(savingObj.Shoot_Location__c == null){
                    savingObj.Shoot_Location__c = str ;
                }else{
                    savingObj.Shoot_Location__c += ','+str;
                }
            }
     update savingObj;       
    }
    update quoteList;
                  
            system.debug(document+'--------document Body'+document.body );        
            FeedItem FI = new FeedItem();
            FI.ParentId = savingId;
            FI.Body = 'Attachment added';
            FI.ContentData = document.body;
          
            FI.ContentFileName = document.Name +'*'+savingObj.Folder_Name__c;
            insert FI;
  
            document = new document();
        }
         
        
   
    editedSavingMode = false;
    updateData();
    system.debug('quoteList!!'+quoteList);
    pagereference page = new PageReference('/apex/Amr_SubmittedSaving?id='+jobid);page.setRedirect(true); return page ;
  
    }catch(Exception e){
    system.debug('inside saving submit data exception');
      }
        return null;
    } 
    
    public PageReference deleteQuote(){
        system.debug('quoteId!!'+quoteId);
        try{
            if(quoteId != null){
        Amr_Quote__c quoteObj = [select Id,Saving__c from Amr_Quote__c where Id =:quoteId limit 1]; 
        String savingIdFromQuoteId = quoteObj.Saving__c;
        system.debug('savingIdFromQuoteId!!'+savingIdFromQuoteId);
        delete quoteObj;
            
        List<Amr_Quote__c> quoteList =[select Id,Quote_Number__c from Amr_Quote__c where Saving__c =:savingIdFromQuoteId ORDER BY Quote_Number__c ASC ];
        Integer i=1;
                for(Amr_Quote__c quote:quoteList){
                    quote.Quote_Number__c = i;
                    i=i+1;
                }
                update quoteList;
                system.debug('New Quote List with arranged numbers!!'+quoteList);
            
        
        }
        
        
        pagereference page = new PageReference('/apex/Amr_SubmittedSaving?id='+jobid);page.setRedirect(true); return page ;
        }catch(Exception e){
        }
        
        
        return null;
    }
    
    public PageReference deleteSaving(){
    system.debug('savingId!!'+savingId);
        try{
            if(savingId != null){
        Amr_Saving__c savingObj = [select Id from Amr_Saving__c where Id =:savingId limit 1];   
        delete savingObj;}
        pagereference page = new PageReference('/apex/Amr_SubmittedSaving?id='+jobid);page.setRedirect(true); return page ;
        }catch(Exception e){
        }
        
        
        return null;
    
    }
    
     public void UpdateAcceptedQuote(){
        system.debug('!!'+quoteRelatedToSavingList);
        try{
            update quoteRelatedToSavingList;
            
        }catch(Exception e){
                
            system.debug('delete Exception');
        }
    }
    
    public PageReference editAcceptedQuote(){
        system.debug('saveRecordValueForAccQuote!!'+saveRecordValueForAccQuote);
    editedAcceptedQuote =true;
   
    return null;
    }
    
    public PageReference SubmitWholeSaving(){
        
        pagereference page = new PageReference('/apex/Amr_SubmittedSaving?id='+jobid);
        page.setRedirect(true); 
        return page ;
       
    
    return null;
    }
    /*
     public void getPcTimeMangCategory(){   
      System.debug('Pc TIME MANAGEMENT  ->  '+ pcTimeMangCategoryValue);
    }
    public void getPcCostMangCategory(){ 
    }
    public void getPcProcessMangCategory(){  
    }
    public void getPcOutputQualityCategory(){  
    }
    public void getPpcTimeMangCategory(){    
    }
    public void getPpcCostMangCategory(){
    }
    public void getPpcProcessMangCategory(){  
    }
    public void getPpcOutputQualityCategory(){
    }
    public void getCaTimeMangCategory(){ 
    } */
    public void getCaCostMangCategory(){}
    public void getCaProcessMangCategory(){}
    
    public void getCaOutputQualityCategory(){}
    
    public void AllValues(){
     Amr_Saving__c savingObj = [select Folder_Name__c,Shoot_Location__c,PC_Appraisal_Time_Management__c, 
                                PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,
                                 PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c, PPC_Appraisal_Process_Management__c,PPC_Appraisal_Cost_Management__c,
                                CA_Appraisal_Time_Management__c, CA_Appraisal_Output_Quality__c, CA_Appraisal_Process_Management__c,CA_Appraisal_Cost_Management__c,
                                 Pc_Time_Manage_Star__c,  Pc_Output_Quality_Star__c,     Pc_Proces_Manage_Star__c,Pc_Cost_Manage_Star__c ,Ppc_Time_Manage_Star__c,
                                 Ppc_Output_Quality_Star__c,Ppc_Process_Manage_Star__c,Ppc_Cost_Manage_Star__c,Ca_Time_Manage_Star__c,Ca_Output_Quality_Star__c,
                                 Ca_Process_Manage_Star__c,Ca_Cost_Manage_Star__c
                                 from Amr_Saving__c where Id =:savingId];
        
        System.debug('Pc TIME MANAGEMENT  ->  '+ pcTimeMangCategoryValue);
        System.debug('PC COST MANAGE MENT -> '+ pcCostMangCategoryValue);
        System.debug(' PC PROCESS MANAGEMNT -> '+ pcProcessMangCategoryValue );
        System.debug('PC OUTPUT -> '+ pcOutputQualityCategoryValue );
        System.debug('PPC TIME MAN --> ' +  pccTimeMangCategoryValue);
        System.debug('PPC COST -> ' + pccCostMangCategoryValue );
        System.debug('PPC PROCESS MANG -> '+ pccProcessMangCategoryValue);
        System.debug('PPC OUTPUT -> ' + pccOutputQualityCategoryValue  );
        System.debug('CA TIME MANG ->'+ caTimeMangCategoryValue);
        System.debug('CA COST MANG -> '+ caCostMangCategoryValue );
        System.debug('CA PROCESS MANG -> ' + caProcessMangCategoryValue);
        System.debug('CA OUTPUR -> '+ caOutputQualityCategoryValue );
       
        if(savingObj.id != null){
            
            // blank Check Pc
            
            if(String.isBlank(String.valueOf(pcTimeMangCategoryValue)) || String.isBlank(String.valueOf(pcTimeMangCategoryClass))) {
                if(!String.isBlank(savingObj.PC_Appraisal_Time_Management__c)){
                    pcTimeMangCategoryValue = Integer.valueOf(savingObj.PC_Appraisal_Time_Management__c);
                }
                else
                {
                    pcTimeMangCategoryValue = 0;
                }
                pcTimeMangCategoryClass = savingObj.Pc_Time_Manage_Star__c;
            }
            if(String.isBlank(String.valueOf(pcOutputQualityCategoryValue)) || String.isBlank(String.valueOf(pcOutputQualityCategoryClass))) {
                if(!String.isBlank(savingObj.PC_Appraisal_Output_Quality__c)){
                    pcOutputQualityCategoryValue = Integer.valueOf(savingObj.PC_Appraisal_Output_Quality__c);
                }
                else
                {
                    pcOutputQualityCategoryValue = 0;
                }
                
                pcOutputQualityCategoryClass = savingObj.Pc_Output_Quality_Star__c;
            }
            if(String.isBlank(String.valueOf(pcProcessMangCategoryValue)) || String.isBlank(String.valueOf(pcProcessMangCategoryClass))) {
                 if(!String.isBlank(savingObj.PC_Appraisal_Process_Management__c)){
                    pcProcessMangCategoryValue= Integer.valueOf(savingObj.PC_Appraisal_Process_Management__c);
                }
                else
                {
                    pcProcessMangCategoryValue = 0;
                }
                
                pcProcessMangCategoryClass = savingObj.Pc_Proces_Manage_Star__c;
            }
            if(String.isBlank(String.valueOf(pcCostMangCategoryValue)) || String.isBlank(String.valueOf(pcCostMangCategoryClass))) {
                 if(!String.isBlank(savingObj.PC_Appraisal_Cost_Management__c)){
                    pcCostMangCategoryValue= Integer.valueOf(savingObj.PC_Appraisal_Cost_Management__c);
                }
                else
                {
                    pcCostMangCategoryValue = 0;
                }
                
                pcCostMangCategoryClass= savingObj.Pc_Cost_Manage_Star__c ;
            }
            
            // blank Check PPc
            
            if(String.isBlank(String.valueOf(pccTimeMangCategoryValue)) || String.isBlank(String.valueOf(pccTimeMangCategoryClass ))) {
                if(!String.isBlank(savingObj.PPC_Appraisal_Output_Quality__c)){
                    pccTimeMangCategoryValue = Integer.valueOf(savingObj.PPC_Appraisal_Output_Quality__c);
                }
                else
                {
                    pccTimeMangCategoryValue = 0;
                }
                
                pccTimeMangCategoryClass = savingObj.Ppc_Time_Manage_Star__c;
            }
            if(String.isBlank(String.valueOf(pccOutputQualityCategoryValue)) || String.isBlank(String.valueOf(pccOutputQualityCategoryClass ))) {
                 if(!String.isBlank(savingObj.PPC_Appraisal_Output_Quality__c )){
                     pccOutputQualityCategoryValue = Integer.valueOf(savingObj.PPC_Appraisal_Output_Quality__c );
                }
                else
                {
                    pccOutputQualityCategoryValue = 0;
                }
               
                pccOutputQualityCategoryClass = savingObj.Ppc_Output_Quality_Star__c;
            }
            if(String.isBlank(String.valueOf(pccProcessMangCategoryValue)) || String.isBlank(String.valueOf(pccProcessMangCategoryClass))) {
                if(!String.isBlank(savingObj.PPC_Appraisal_Process_Management__c)){
                     pccProcessMangCategoryValue= Integer.valueOf(savingObj.PPC_Appraisal_Process_Management__c);
                }
                else
                {
                    pccProcessMangCategoryValue= 0;
                }   
                pccProcessMangCategoryClass= savingObj.Ppc_Process_Manage_Star__c;
            }
            if(String.isBlank(String.valueOf(pccCostMangCategoryValue)) || String.isBlank(String.valueOf(pccCostMangCategoryClass ))) {
                if(!String.isBlank(savingObj.PPC_Appraisal_Cost_Management__c )){
                     pccCostMangCategoryValue= Integer.valueOf(savingObj.PPC_Appraisal_Cost_Management__c );
                }
                else
                {
                    pccCostMangCategoryValue = 0;
                }               
                pccCostMangCategoryClass = savingObj.Ppc_Cost_Manage_Star__c;
            }
            
             // blank Check CA
            
            if(String.isBlank(String.valueOf(caTimeMangCategoryValue)) || String.isBlank(String.valueOf(caTimeMangCategoryClass ))) {
                if(!String.isBlank(savingObj.CA_Appraisal_Time_Management__c  )){
                caTimeMangCategoryValue = Integer.valueOf(savingObj.CA_Appraisal_Time_Management__c );
                }
                else
                {
                    caTimeMangCategoryValue = 0;
                } 
                caTimeMangCategoryClass = savingObj.Ca_Time_Manage_Star__c;
            }
            if(String.isBlank(String.valueOf(caOutputQualityCategoryValue )) || String.isBlank(String.valueOf(caOutputQualityCategoryClass ))) {
                if(!String.isBlank(savingObj.CA_Appraisal_Output_Quality__c)){
                caOutputQualityCategoryValue = Integer.valueOf(savingObj.CA_Appraisal_Output_Quality__c);
                }
                else
                {
                    caOutputQualityCategoryValue = 0;
                }
                
                caOutputQualityCategoryClass = savingObj.Ca_Output_Quality_Star__c;
            }
            if(String.isBlank(String.valueOf(caProcessMangCategoryValue)) || String.isBlank(String.valueOf(caProcessMangCategoryClass))) {
                if(!String.isBlank(savingObj.CA_Appraisal_Process_Management__c )){
                caProcessMangCategoryValue= Integer.valueOf(savingObj.CA_Appraisal_Process_Management__c );
                }
                else
                {
                    caProcessMangCategoryValue = 0;
                }
                
                caProcessMangCategoryClass= savingObj.Ca_Process_Manage_Star__c;
            }
            if(String.isBlank(String.valueOf(caCostMangCategoryValue )) || String.isBlank(String.valueOf(caCostMangCategoryClass ))) {
                if(!String.isBlank(savingObj.PPC_Appraisal_Cost_Management__c )){
                    caCostMangCategoryValue = Integer.valueOf(savingObj.PPC_Appraisal_Cost_Management__c );
                }
                else
                {
                    caCostMangCategoryValue = 0;
                }
                
                caCostMangCategoryClass = savingObj.Ca_Cost_Manage_Star__c;
            }

            
            
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
              savingObj.CA_Appraisal_Cost_Management__c = String.valueOf(caCostMangCategoryValue );
              
             
              
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
              pcTimeMangCategoryValue = null;
              pcOutputQualityCategoryValue= null;
              pcProcessMangCategoryValue= null;
              pcCostMangCategoryValue= null;
              pccOutputQualityCategoryValue= null;
              pccProcessMangCategoryValue= null;
              pccCostMangCategoryValue= null;
              caTimeMangCategoryValue= null;
              caOutputQualityCategoryValue = null;
              caProcessMangCategoryValue = null;
              caCostMangCategoryValue = null;
              
        }
       
    }
    
    public String getSelectedRatingStar(){
        
      list<Amr_Saving__c> lstsavingObj = [Select id, PC_Appraisal_Time_Management__c, 
                                PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,
                                 PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c, PPC_Appraisal_Process_Management__c,PPC_Appraisal_Cost_Management__c,
                                CA_Appraisal_Time_Management__c, CA_Appraisal_Output_Quality__c, CA_Appraisal_Process_Management__c,CA_Appraisal_Cost_Management__c,
                                 Pc_Time_Manage_Star__c,  Pc_Output_Quality_Star__c,     Pc_Proces_Manage_Star__c,Pc_Cost_Manage_Star__c ,Ppc_Time_Manage_Star__c,
                                 Ppc_Output_Quality_Star__c,Ppc_Process_Manage_Star__c,Ppc_Cost_Manage_Star__c,Ca_Time_Manage_Star__c,Ca_Output_Quality_Star__c,
                                 Ca_Process_Manage_Star__c,Ca_Cost_Manage_Star__c
                                 from Amr_Saving__c where Job_Details__c =:jobId];
                                 
       System.debug('DAGTA -->  ' + JSON.Serialize(lstsavingObj ));
       
       return JSON.Serialize(lstsavingObj );
    }
   
}