/*************************************************************************************************************************************
Name: Amr_SubmittedSavings_CC
Copyright © 2015 Salesforce
======================================================
Purpose:Class has activities such as delete,edit etc. related to submitted savings and quotes. 
-------
======================================================
History
-------
VERSION     AUTHOR             DATE           DETAIL           Description
1.0         Varuna Nikam       4/03/2016     INITIAL DEV      CSR:
*************************************************************************************************************************************/
public with sharing class Amr_SubmittedSavingController_CC {
    public String savingIdFromPage{get;set;}
    public Amr_Saving__c savObj {get;set;}
    public Amr_Saving__c savObjNum {get;set;}
    public String adManagerNumber{get;set;}
    public boolean editedSavingMode{get;set;}
    public boolean viewSavingMode{get;set;}
    public String saveRecordValue{get;set;}
    public List<SelectOption> shootLocation{get;set;}
    public List<String> selectedCountry{get;set;}
    public string userId{get;set;}
    public Amr_Quote__c acceptedQuote{get;set;}
    public List<Amr_Quote__c> quoteRelatedToSavingList{get;set;}
    public String savingId {get;set;}
    public String acceptedQuoteId{get;set;}
    public List<FeedItem> feedItemAcceptedList{get;set;}
    public List<FeedItem> feedItemAdditionalList {get;set;}
    public String chosenFileId {get;set;}
    public String jobId{get;set;}
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
    public Boolean savingMessages {get;set;}
    
     public  Document document {
        get {
          if (document == null)
             document = new Document();
             return document;
        }
        set;
   }
    public String lstcov {
      get{
            lstcov = JSON.serialize(Amr_CurrencyConversionRate__c.getAll().values());
            return lstcov;
        }set;
    } 
    public Amr_SubmittedSavingController_CC(){
        try{
    savingIdFromPage = ApexPages.currentPage().getParameters().get('id');
    feedItemAcceptedList = new List <FeedItem>();
    feedItemAdditionalList = new List <FeedItem>();
    if(savingIdFromPage!=null){
        editedSavingMode = false;
        viewSavingMode = true;
        savObj = new Amr_Saving__c();
        savObj = [select PC_Appraisal_Time_Management__c,PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c,PPC_Appraisal_Process_Management__c ,PPC_Appraisal_Cost_Management__c,CA_Appraisal_Time_Management__c,CA_Appraisal_Output_Quality__c ,CA_Appraisal_Process_Management__c ,CA_Appraisal_Cost_Management__c,Folder_Name__c,Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,No_of_Masters_List__c,Duration_of_Masters__c,No_of_Additional_Films_List__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Production_Type__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c,(select Total_Cost__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c from Quotes__r where Is_Accepted__c =:true) from Amr_Saving__c where Id=:savingIdFromPage limit 1];
                    
        savObjNum = [select Job_Details__r.AdManagerText__c from Amr_Saving__c where Id =:savingIdFromPage limit 1];
        adManagerNumber = savObjNum.Job_Details__r.AdManagerText__c;
        jobId = savObjNum.Job_Details__C; 
        } 
        selectedCountry = new List<String> {'Test'};
        List<Amr_Country_Cluster__c> countrylst=  Amr_Country_Cluster__c.getall().values();
        shootLocation = new List<SelectOption>();
        for(Amr_Country_Cluster__c countryObj:countrylst){
        shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
            }
            
           
                     
             userId = userinfo.getuserid(); 
             quoteInformation();
             getFeedItemAcceptedData();
             getFeedItemAdditionalData();
             savingMessages = false;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
        }
    }
/***********************************************************************************************************************************
Purpose: Method to get quotes related to saving.
Parameters: 
Returns: 

************************************************************************************************************************************/    
    public void quoteInformation(){
        try{
        acceptedQuote=[select Saving__r.Saving_Average_of_Quotes__c,Saving_Type__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Accepted_Final_Cost_props_wardrobe__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Editors_name__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_PPC_only_Local_Am__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Saving__c,Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id,Folder__c from Amr_Quote__c where Saving__c =:savingIdFromPage AND Is_Accepted__c =:true];
    
    quoteRelatedToSavingList = [select Saving_Type__c,Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Accepted_Final_Cost_props_wardrobe__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Editors_name__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_PPC_only_Local_Am__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Saving__c,Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id,Folder__c from Amr_Quote__c where Saving__c =:savingIdFromPage AND Is_Accepted__c =:false ORDER BY Quote_Number__c]; 
    }catch(Exception ex){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
        }
    }
  /***********************************************************************************************************************************
Purpose: Method to edit saving record.
Parameters: 
Returns:

************************************************************************************************************************************/  
    public PageReference edit(){
        try{
         if(saveRecordValue !=null){
        editedSavingMode = true;
        viewSavingMode = false;
         
        }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
        }
         return null;
    }
    
    public PageReference saveData(){
        
    return null;
    }
  /***********************************************************************************************************************************
Purpose: Method to upload documents.
Parameters: 
Returns:

************************************************************************************************************************************/  
    public PageReference uploadAcceptedData(){
        try{
    
    if(acceptedQuoteId!=null){
    
         if(document.body!=null){
        
            
            FeedItem FI = new FeedItem();
            FI.ParentId = acceptedQuoteId;
            FI.Body = Amr_ConstantForAdManager.ATTACHMENT_ADDED;
            FI.ContentData = document.body;
          
            FI.ContentFileName = document.Name;
            insert FI;
           
            document = new document();
        }else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Please_Select_Document));
        }
    }
    getFeedItemAcceptedData();
    }catch(Exception ex){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
        return null;
    }
    return null;
    }
/***********************************************************************************************************************************
Purpose: Method to get uploaded documents.
Parameters: 
Returns:

************************************************************************************************************************************/    
    public void getFeedItemAcceptedData(){
        try{
        feedItemAcceptedList = [select id,CreatedById,CreatedBy.name,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,CreatedDate 
                                          FROM FeedItem where ParentId =:acceptedQuote.Id];
       
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
        }   
    }
 /***********************************************************************************************************************************
Purpose: Method to delete document
Parameters: 
Returns:

************************************************************************************************************************************/   
    public PageReference deleteFile(){
        try{
       
        FeedItem feedItemObj = [select id from FeedItem where id=:chosenFileId limit 1];
        delete feedItemObj;
        getFeedItemAcceptedData();  
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
        }
    return null;
    }
/***********************************************************************************************************************************
Purpose: Method to upload additional documents.
Parameters: 
Returns:

************************************************************************************************************************************/    
    public PageReference uploadAdditionalData(){
        try{
   
    if(savingId!=null){
    
         if(document.body!=null){
        
               
            FeedItem FI = new FeedItem();
            FI.ParentId = savingId;
            FI.Body = Amr_ConstantForAdManager.ATTACHMENT_ADDED;
            FI.ContentData = document.body;
          
            FI.ContentFileName = document.Name;
            insert FI;
           
            document = new document();
        }else{
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.Amr_Please_Select_Document));
        }
    }
    getFeedItemAdditionalData();
    }catch(Exception ex){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
    }
    return null;
    }
/***********************************************************************************************************************************
Purpose: Method to get uploaded additional documents.
Parameters: 
Returns:

************************************************************************************************************************************/    
    public void getFeedItemAdditionalData(){
        try{
        feedItemAdditionalList = [select id,CreatedById,CreatedBy.name,Body,ContentFileName,LinkUrl,RelatedRecordId,ParentId,Title,CreatedDate 
                                          FROM FeedItem where ParentId =:savingIdFromPage];
       
    }catch(Exception ex){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
    }   
    }
 /***********************************************************************************************************************************
Purpose: Method to delete document.
Parameters: 
Returns:

************************************************************************************************************************************/   
    public PageReference deleteOtherFile(){
        try{
        system.debug('chosenFileId!!'+chosenFileId);
        FeedItem feedItemObj = [select id from FeedItem where id=:chosenFileId limit 1];
        delete feedItemObj;
    getFeedItemAdditionalData();    
    }catch(Exception ex){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
    }
    return null;
    }
/***********************************************************************************************************************************
Purpose: Method to delete saving record.
Parameters: 
Returns:

************************************************************************************************************************************/    
    public PageReference deleteSaving(){
        try{
        delete savObj;
        pagereference page = new PageReference(Label.Amr_Jobsheet_Id+jobId);
        page.setRedirect(true); 
        return page ;
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        system.debug(ex.getMessage());
        }
    return null;    
    }
    
     public void getCaProcessMangCategory(){
    system.debug('here');
    }
    
    /***********************************************************************************************************************************
Purpose: Method to submit saving record.
Parameters: 
Returns:
N-PATH:
Checking mandatory object field validation, which can not be break down into multiple classes.

************************************************************************************************************************************/    
    public PageReference SubmitWholeSaving(){
        try{
             boolean okayToSave = true;  
             /*
             N-Path:
             Check for each Object field validation in if clause.
             */
             if(savObj.Production_Type__c == '--None--' || string.isBlank(savObj.Production_Type__c)){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Prod Type'));
                 savingMessages = true;
                 okayToSave=false;
            }
            if(savObj.Stage_RAP_engaged__c == '--None--' || String.isBlank(savObj.Stage_RAP_engaged__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Stage RAP was Engaged'));
                savingMessages = true;
                okayToSave=false;
            }
            if(savObj.Scope_re_brief__c == '--None--' || String.isBlank(savObj.Scope_re_brief__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Has there been a scope re-brief?'));
                savingMessages = true;
                 okayToSave=false;
            }
           /* if(acceptedQuote.PC_Costs_Euro_Amount__c == 0 || acceptedQuote.PPC_Costs_Euro_Amount__c == 0 || acceptedQuote.CA_Costs_Euro_Amount__c == 0){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter PC,PPC,CA Euro amount in Accepted Quote (Opening and Closing Quote 1)'));
                 savingMessages = true;
                 okayToSave=false;
            }
            if(acceptedQuote.Accepted_Final_Cost_PPC_Euro_Amount__c == 0 || acceptedQuote.Accepted_Final_Cost_CA_Euro_Amount__c == 0 || acceptedQuote.Accepted_Final_Cost_PC_Euro_Amou__c == 0){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter PC,PPC,CA Euro amount in Accepted Final Costs'));
                savingMessages = true;
                okayToSave=false;
            }
            if(acceptedQuote.Saving_Type__c == '--None--' || String.isBlank(acceptedQuote.Saving_Type__c)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter What type of Savings is this?'));
                savingMessages = true;
                 okayToSave=false;
            }*/
            if(!okayToSave){
            system.debug('inside error');
            return null;
            
            }else{
             
            if(selectedCountry.size()>0){ 
                if(savObj.Shoot_Location__c != null){
                savObj.Shoot_Location__c = null;
            }
            for(String str : selectedCountry){
                if(savObj.Shoot_Location__c == null){
                    savObj.Shoot_Location__c = str ;
                }else{
                    
                    savObj.Shoot_Location__c += ','+str;
                }
            }
         
            }
  
        update savObj;
   
        update acceptedQuote;
        if(acceptedQuote.Total_Cost__c !=0){
        savObj.Percentage_Saving_Accepted_Quote__c = (acceptedQuote.Saving__r.Saving_Average_of_Quotes__c * 100 / acceptedQuote.Total_Cost__c).setscale(2);
        savObj.Saving_Accepted_Quote_Euro__c =  acceptedQuote.Total_Cost__c - acceptedQuote.Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c;      
        }        
        
             update savObj;
     
        update quoteRelatedToSavingList;
   
    
        AllValues();
        
        if(feedItemAcceptedList.size()<1 && feedItemAdditionalList.size()<1){
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.Amr_Please_Select_Document));
        return null;
        }else{
           
        pagereference page = new PageReference(Label.Amr_Submitted_Saving_Page_Id + savingIdFromPage);
        page.setRedirect(true); 
        return page ;
        }
        
        }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        System.debug(ex.getmessage());
        }  
    
    return null;
    }
/***********************************************************************************************************************************
Purpose: Method to update appraisal related to saving record.
Parameters: 
Returns: 
N-Path:
Fetching appraisal filelds and validations for the same need to be done at single place.
************************************************************************************************************************************/    
    
    public void AllValues(){
        try{
        System.debug('SAV ID FROM PAGE ->   ' + savingIdFromPage);
     Amr_Saving__c savingObj = [select Folder_Name__c,Shoot_Location__c,PC_Appraisal_Time_Management__c, 
                                PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,
                                 PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c, PPC_Appraisal_Process_Management__c,PPC_Appraisal_Cost_Management__c,
                                CA_Appraisal_Time_Management__c, CA_Appraisal_Output_Quality__c, CA_Appraisal_Process_Management__c,CA_Appraisal_Cost_Management__c,
                                 Pc_Time_Manage_Star__c,  Pc_Output_Quality_Star__c,     Pc_Proces_Manage_Star__c,Pc_Cost_Manage_Star__c ,Ppc_Time_Manage_Star__c,
                                 Ppc_Output_Quality_Star__c,Ppc_Process_Manage_Star__c,Ppc_Cost_Manage_Star__c,Ca_Time_Manage_Star__c,Ca_Output_Quality_Star__c,
                                 Ca_Process_Manage_Star__c,Ca_Cost_Manage_Star__c
                                 from Amr_Saving__c where Id =:savingIdFromPage];
        
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
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        System.debug(ex.getmessage());
        }
       
    }
/***********************************************************************************************************************************
Purpose: Method to get appraisal related to saving record.
Parameters: 
Returns: 

************************************************************************************************************************************/    
    public String getSelectedRatingStar(){
        try{
      list<Amr_Saving__c> lstsavingObj = [Select PC_Appraisal_Time_Management__c, 
                                PC_Appraisal_Output_Quality__c,PC_Appraisal_Process_Management__c,PC_Appraisal_Cost_Management__c,
                                 PPC_Appraisal_Time_Management__c,PPC_Appraisal_Output_Quality__c, PPC_Appraisal_Process_Management__c,PPC_Appraisal_Cost_Management__c,
                                CA_Appraisal_Time_Management__c, CA_Appraisal_Output_Quality__c, CA_Appraisal_Process_Management__c,CA_Appraisal_Cost_Management__c,
                                 Pc_Time_Manage_Star__c,  Pc_Output_Quality_Star__c,     Pc_Proces_Manage_Star__c,Pc_Cost_Manage_Star__c ,Ppc_Time_Manage_Star__c,
                                 Ppc_Output_Quality_Star__c,Ppc_Process_Manage_Star__c,Ppc_Cost_Manage_Star__c,Ca_Time_Manage_Star__c,Ca_Output_Quality_Star__c,
                                 Ca_Process_Manage_Star__c,Ca_Cost_Manage_Star__c
                                 from Amr_Saving__c where Id =:savingIdFromPage];
                                 
       System.debug('DAGTA -->  ' + JSON.Serialize(lstsavingObj ));
       
       return JSON.Serialize(lstsavingObj );
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        System.debug(ex.getmessage());
        }
       return null;
    }
    
}