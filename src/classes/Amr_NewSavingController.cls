public with sharing class Amr_NewSavingController {
    public Amr_Saving__c savingObj{get;set;} 
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
    public String adManagerNumber{get;set;}
    public List<SelectOption> shootLocation{get;set;}
    public List<String> selectedCountry{get;set;}
    public List<SelectOption> productionType{get;set;}
    public  Document document {
        get {
          if (document == null)
             document = new Document();
             return document;
        }
        set;
    }
    public Amr_Job_Details__c jobDetailObj{get;set;}
    public List<String> selectedProductionType{get;set;}
    public Integer QuoteNumber{get;set;}
   
    public  Amr_Quote__c acceptedQuote {get;set;}
    
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
    

    
    public  Amr_NewSavingController(){
        jobId = ApexPages.currentPage().getParameters().get('id');
        
        System.debug('JOB ID -> ' + jobId);
        
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
            
            if(jobDetailObj.AdManagerText__c !=null){
                adManagerNumber = jobDetailObj.AdManagerText__c;
            }
            
        }
        
        List<Amr_Country_Cluster__c> countrylst = Amr_Country_Cluster__c.getall().values();
        shootLocation = new List<SelectOption>();
        
        for(Amr_Country_Cluster__c countryObj:countrylst){
             shootLocation.add(new SelectOption(countryObj.Country__c,countryObj.Country__c));
        }
        
        savingObj = new Amr_Saving__c(Job_Details__c = jobId);
        System.debug('SACVING OBJ -> ' + savingObj + 'SAVING ID -> ' + savingObj.id);
        //For Production type
        //productionTypeValues();
    
    }
    
    
   
   
    integer i = 1;
  
    public void addRowQuote(){
            Amr_Quote__c quoteObj = new  Amr_Quote__c();
            if(i>5){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You can enter only 5 Quotes'));
            }else{
                if(i == 1){
                    docAndQuoteLst.add(new InnerSavingClass(i,true,quoteObj));
                    i = i+1;
                }else{
                    docAndQuoteLst.add(new InnerSavingClass(i,false,quoteObj)); 
                    i = i+1;
                }
            }
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
    
   
    public pageReference SaveAllData(){
        
        system.debug('==========>doc'+docAndQuoteLst);
        system.debug('==========>saving'+savingObj);
        system.debug('==========>quote Nu'+QuoteNumber);
       
        Amr_Quote__c quoteToInsert = new Amr_Quote__c();
        Document doc = new Document();
        
        if(savingObj.id == null){
            system.debug('saving id cannot be null');
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Enter Saving Record First'));
            
            for(InnerSavingClass innerObj:docAndQuoteLst){
                innerObj.attachmentObj = null;
            } 
                
        }else{
            
            integer counter = docAndQuoteLst.size()-1;
            
            if(docAndQuoteLst.size()>1 && docAndQuoteLst[counter-1].quoteObj.id == null && docAndQuoteLst[counter-1].quoteObj.Quote_Number__c != QuoteNumber ){
                system.debug('inside quote error msg=========>');
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Please Save Previous Quote'));
                return null;
            }else{
                for(InnerSavingClass innerObj:docAndQuoteLst){
                    system.debug('---inside for'+innerObj);
                    
                    if(innerObj.quoteObj.Quote_Number__c == QuoteNumber){
                        system.debug('inside quote Number====>'+innerObj.quoteObj);
                        quoteToInsert = innerObj.quoteObj;
                        doc = innerObj.attachmentObj;
                        innerObj.attachmentObj = NULL;
                    }
                    
                }
                
                if(quoteToInsert.Saving__c == null ){
                	System.debug(savingObj.id+'===saving id assign'+quoteToInsert.Saving__c);
                    quoteToInsert.Saving__c = savingObj.id;
                }
                
            
                
                upsert quoteToInsert;
                system.debug('quoteToInsert====>'+quoteToInsert.Saving__c);
                
                quoteToInsert = [select Total_Cost__c,Is_Accepted__c ,Local_Currency_of_PC_Costs__c ,
                Local_Amount_of_PC__c,PC_Costs_Euro_Amount__c,Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,
                PPC_Costs_Euro_Amount__c,Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,CA_Costs_Euro_Amount__c,Folder__c
                from Amr_Quote__c where Saving__c = :savingObj.id AND id = :quoteToInsert.id];
                
                if(quoteToInsert.Is_Accepted__c == true){
                       system.debug('inside true==>');
                        quoteToInsert.Accepted_Final_Cost_PC_only_Currency__c = quoteToInsert.Local_Currency_of_PC_Costs__c;
                        quoteToInsert.Accepted_Final_Cost_PC_only_Local_Amo__c = quoteToInsert.Local_Amount_of_PC__c;
                        quoteToInsert.Accepted_Final_Cost_PC_Euro_Amou__c = String.ValueOf(quoteToInsert.PC_Costs_Euro_Amount__c);
                        
                        quoteToInsert.Accepted_Final_Cost_PPC_only_Currency__c = quoteToInsert.Local_Currency_of_PPC_Costs__c;
                        quoteToInsert.Accepted_Final_Cost_PPC_only_Local_Am__c = quoteToInsert.Local_Amount_of_PPC__c;
                        quoteToInsert.Accepted_Final_Cost_PPC_Euro_Amount__c =quoteToInsert.PPC_Costs_Euro_Amount__c;
                        
                        quoteToInsert.Accepted_Final_Cost_CA_only_Currency__c = quoteToInsert.Local_Currency_of_CA_Costs__c;
                        quoteToInsert.Accepted_Final_Cost_CA_Local_Amount__c = quoteToInsert.Local_Amount_of_CA__c;
                        quoteToInsert.Accepted_Final_Cost_CA_Euro_Amount__c = String.ValueOf(quoteToInsert.CA_Costs_Euro_Amount__c);
                        
                        quoteToInsert.Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c = quoteToInsert.Total_Cost__c;
                        update quoteToInsert;
                        
                        List<Amr_Quote__c> acceptedQuotelst = [select Quote_Number__c,id,Accepted_Final_Cost_PC_only_Currency__c,Accepted_Final_Cost_PC_only_Local_Amo__c,Accepted_Final_Cost_PC_Euro_Amou__c,Accepted_Final_Cost_PPC_only_Currency__c,Accepted_Final_Cost_PPC_only_Local_Am__c,
                                                                      Accepted_Final_Cost_PPC_Euro_Amount__c,Accepted_Final_Cost_CA_only_Currency__c,Accepted_Final_Cost_CA_Local_Amount__c,Accepted_Final_Cost_CA_Euro_Amount__c,Accepted_Final_Cost_Editors_name__c,
                                                                      Accepted_Final_Cost_Total_editing_cost__c,Accepted_Final_Cost_Sound_Studio_Name__c,Accepted_Final_Cost_Total_Sound_Studio__c,Accepted_Final_Cost_Travel_Costs__c,Accepted_Final_Cost_props_wardrobe__c,Folder__c,
                                                                      Total_Accepted_Final_Cost_CA_PC_PPC_Eu__c,Saving_Type__c,Is_Accepted__c  from Amr_Quote__c where Is_Accepted__c = true AND Saving__c = :savingObj.id AND id = :quoteToInsert.id];
                        
                       system.debug('accepted ==>'+acceptedQuotelst);
                        if(acceptedQuotelst.size()>0){
                            acceptedQuote = acceptedQuotelst[0];
                            system.debug('inside quote============>'+acceptedQuote);
                        }
                }
               
               if(quoteToInsert.id !=null){
                    system.debug('====inside Upload doc'+quoteToInsert.id);
                    if(uploadQuoteDocument(quoteToInsert,doc)){
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Quote Saved Successfully'));
                    }
               }
            }
        }
        return null;
    }
    
    
     public boolean uploadQuoteDocument(Amr_Quote__c quote,Document doc){
        
        String parentId ;
            
        if(quote.id != null){
            parentId = quote.Id;
        }
            
        if(doc.body!=null){    
              
            system.debug(document+'--------document Body'+doc.body +'quote=='+quote);        
            FeedItem FI = new FeedItem();
            FI.ParentId = parentId;
            FI.Body = 'Attachment added';
            FI.ContentData = doc.body;
          
            FI.ContentFileName = doc.Name +'*'+quote.Folder__c;
            insert FI;
            
            doc = new document();
            
            if(FI.id!=null){
                 doc.body = null;
                 FI = new FeedItem();
                 FI = null;
                 return true;
            }
         }
        
        return false;
    }
   
   
   
    
    public PageReference SaveSaving(){
        try{
            
            
            if(validateSaving(savingObj,document)){
                
                if(selectedCountry.size()>0){
                    for(String str : selectedCountry){
                        if(savingObj.Shoot_Location__c == null){
                            savingObj.Shoot_Location__c = str ;
                        }else{
                            savingObj.Shoot_Location__c += ','+str;
                        }
                    }
                }
                
                insert savingObj;
                
                if(uploadDocument(savingObj)){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,Label.Amr_Success_ReportSaved));
                }
                
               /* PageReference pageRef = new PageReference('/apex/amr_jobsheet?id='+jobId);
                pageRef.setRedirect(true);
                return pageRef;*/
            }

        }catch(Exception e){
            system.debug('inside saving exception');
            system.debug('e'+e.getMessage());
        }
        
        return null;
    
    }
    
    public boolean validateSaving(Amr_Saving__c savingObjValidate,Document document){
        boolean flag = false;
        
        if((savingObjValidate.Production_Type__c !=null || savingObjValidate.No_of_Masters__c!=null ||savingObjValidate.Duration_of_Masters__c!=null
                || savingObjValidate.No_of_Additional_Films__c!=null || savingObjValidate.Duration_of_Additional_Films__c !=null
                || savingObjValidate.No_of_shoot_days__c !=null || savingObjValidate.Stage_RAP_engaged__c!=null || selectedCountry.size()>0 
                || savingObjValidate.Script_Title__c!=null || savingObjValidate.Scope_re_brief__c !=null)&& document.body!=null){
            flag = true;
        }else{  
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, Label.Amr_Error_FileUpload));
          document.body =null;
          return false;
        }
        
        return flag;
    }
       
    public boolean uploadDocument(Amr_Saving__c saving){
        
        String parentId ;
            
        if(saving.id != null){
            parentId = saving.Id;
        }
            
        if(document.body!=null){    
              
            system.debug(document+'--------document Body'+document.body +'saving=='+saving);        
            FeedItem FI = new FeedItem();
            FI.ParentId = parentId;
            FI.Body = 'Attachment added';
            FI.ContentData = document.body;
          
            FI.ContentFileName = document.Name +'*'+saving.Folder_Name__c;
            insert FI;
  
            document = new document();
            
            if(FI.id!=null){
                 document.body = null;
                 FI = new FeedItem();
                 FI = null;
                 return true;
            }
         }
        
        return false;
    }
    
    public void test(){
    	system.debug('here');
    }
    
     public void UpdateAcceptedQuote(){
        try{
            update acceptedQuote;
            
        }catch(Exception e){
                
            system.debug('delete Exception');
        }
    }
    
    //======================================================== Appraisal Section ============================
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
    }
    public void getCaCostMangCategory(){} */
    public void getCaProcessMangCategory(){}
    

    
    public PageReference AllValues(){
        
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
       
              PageReference pageRef = new PageReference('/apex/Amr_jobsheet?id='+jobId);
              return pageRef.setRedirect(true);
    }
    
     /*public void productionTypeValues( ){
        List<Amr_Production_Type__c> productionCustomSetting = Amr_Production_Type__c.getall().values();
        system.debug('===>custom setting===>'+productionCustomSetting);
        if(jobDetailObj!=null){
                
                     productionType = new List<SelectOption>();
                     
                     if(jobDetailObj.NewOriginalMasterTv__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            system.debug(obj.API_Name__c);
                            if(obj.API_Name__c == 'NewOriginalMasterTv__c'){
                                
                                productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.NewOriginalMasterCinema__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'NewOriginalMasterCinema__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.NewOriginalMasterPrint__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'NewOriginalMasterPrint__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.NewOriginalMasterRadio__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'NewOriginalMasterRadio__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.NewOriginalMasterOutofHome__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'NewOriginalMasterOutofHome__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.NewOriginalMasterInStore__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'NewOriginalMasterInStore__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    
                     if(jobDetailObj.NewOriginalMasterDigital__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'NewOriginalMasterDigital__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.NewOriginalMasterInternalVideo__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'NewOriginalMasterInternalVideo__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    //===================================================================
                    if(jobDetailObj.LanguageAdaptionMasterTv__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'LanguageAdaptionMasterTv__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                
                    if(jobDetailObj.LanguageAdaptionMasterCinema__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'LanguageAdaptionMasterCinema__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.LanguageAdaptionMasterRadio__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'LanguageAdaptionMasterRadio__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.LanguageAdaptionMasterPrint__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'LanguageAdaptionMasterPrint__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.LanguageAdaptionMasterOutofHome__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'LanguageAdaptionMasterOutofHome__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.LanguageAdaptionMasterInStore__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'LanguageAdaptionMasterInStore__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.LanguageAdaptionMasterDigital__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'LanguageAdaptionMasterDigital__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.LanguageAdaptionMasterInternalVideo__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'LanguageAdaptionMasterInternalVideo__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                     //===================================================================
                    
                    if(jobDetailObj.AdditionalSupplementaryNewMaterialCinema__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'AdditionalSupplementaryNewMaterialCinema__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.AdditionalSupplementaryNewMaterialTv__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'AdditionalSupplementaryNewMaterialTv__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.AdditionalSupplementaryNewMaterialRadio__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'AdditionalSupplementaryNewMaterialRadio__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.AdditionalSupplementaryNewMaterialPrint__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'AdditionalSupplementaryNewMaterialPrint__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.AdditionalSupplementaryNewMaterialOOH__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'AdditionalSupplementaryNewMaterialOOH__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                      if(jobDetailObj.AdditionalSupplementaryNewMaterialStore__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'AdditionalSupplementaryNewMaterialStore__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                      if(jobDetailObj.AdditionalSupplementaryNewMaterialDigi__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'AdditionalSupplementaryNewMaterialDigi__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                      if(jobDetailObj.AdditionalSupplementaryNewMaterialIVideo__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'AdditionalSupplementaryNewMaterialIVideo__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                   // =======================================================
                   if(jobDetailObj.ReworkExistingMaterialTv__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            system.debug(obj.API_Name__c);
                            if(obj.API_Name__c == 'ReworkExistingMaterialTv__c'){
                                
                                productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.ReworkExistingMaterialCinema__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'ReworkExistingMaterialCinema__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.ReworkExistingMaterialRadio__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'ReworkExistingMaterialRadio__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.ReworkExistingMaterialPrint__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'ReworkExistingMaterialPrint__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.ReworkExistingMaterialOutofHome__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'ReworkExistingMaterialOutofHome__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.ReworkExistingMaterialInStore__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'ReworkExistingMaterialInStore__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    
                     if(jobDetailObj.ReworkExistingMaterialDigital__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'ReworkExistingMaterialDigital__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.ReworkExistingMaterialInternalVideo__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'ReworkExistingMaterialInternalVideo__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    //===================================================
                    
                     if(jobDetailObj.BuyoutsTalentTv__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            system.debug(obj.API_Name__c);
                            if(obj.API_Name__c == 'BuyoutsTalentTv__c'){
                                
                                productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.BuyoutsTalentCinema__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsTalentCinema__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.BuyoutsTalentRadio__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsTalentRadio__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.BuyoutsTalentPrint__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsTalentPrint__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.BuyoutsTalentOutofHome__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsTalentOutofHome__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.BuyoutsTalentInStore__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsTalentInStore__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    
                     if(jobDetailObj.BuyoutsTalentDigital__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsTalentDigital__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.BuyoutsTalentInternalVideo__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsTalentInternalVideo__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    //======================
                    
                        if(jobDetailObj.BuyoutsMusicTv__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            system.debug(obj.API_Name__c);
                            if(obj.API_Name__c == 'BuyoutsMusicTv__c'){
                                
                                productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.BuyoutsMusicCinema__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsMusicCinema__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.BuyoutsMusicRadio__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsMusicRadio__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.BuyoutsMusicPrint__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsMusicPrint__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.BuyoutsMusicOutofHome__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsMusicOutofHome__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                     if(jobDetailObj.BuyoutsMusicInStore__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsMusicInStore__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    
                     if(jobDetailObj.BuyoutsMusicDigital__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsMusicDigital__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
                    if(jobDetailObj.BuyoutsMusicInternalVideo__c == true){
                        
                        for(Amr_Production_Type__c obj:productionCustomSetting){
                            if(obj.API_Name__c == 'BuyoutsMusicInternalVideo__c'){
                                 productionType.add(new SelectOption(obj.Field_Label__c,obj.Field_Label__c));
                            }
                        }
                        
                    }
                    
        }
    
    }*/
    
}