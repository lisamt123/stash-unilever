public with sharing class amr_gksubmittedSaving {
    public String docUploaded{get;set;}
    public String adManagerNumber{get;set;}
    public integer counterOfUpload = 0; 
    public String saveRecordValue{get;set;}
    public String saveRecordValueForQuote {get;set;}
    public boolean display{get;set;}
    public string IdNeedToUpdate{get;set;}
   // public String productionType{get;set;}
    public  boolean DisplayLink{get;set;}
    public String quoteJobId{get;set;}
    public string savingId{get;set;}
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
    public String jobId{get;set;}
    public List<Amr_Saving__c> quoteList{get;set;}
    public List<Amr_Quote__c> quoteRelatedToSavingList{get;set;}
    public List<Amr_Saving__c> lstQuoteToaddRow{
        get{
             if(lstQuoteToaddRow == null)
                    lstQuoteToaddRow = new List<Amr_Saving__c>();     
                return lstQuoteToaddRow;
        }set;
    }
    public string userId{get;set;}
    public amr_gksubmittedSaving(){
        editedSavingMode = false;
        viewSavingMode = true;
        editedQuoteMode = false;
        viewQuoteMode = true;
        jobId = ApexPages.currentPage().getParameters().get('id');
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
         }
         
    public void updateData(){
        try{
            
           
              jobId = ApexPages.currentPage().getParameters().get('id');
            
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
                                                      
                                                     from Amr_Job_Details__c where id = :jobId ];
            
           
           
         }
         //  productionTypeValues();
           
            if(jobId != null){
                 if(flag == true){
                      quoteList = [select Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Percentage_Saving_Average_of_Quote__c,Euro_Saving_Average_of_Quotes__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c from Amr_Saving__c where Job_Details__r.id = :jobId limit 1];
                      system.debug('inside Cap List========>'+quoteList  );
                      
                      
                 }else{
                   quoteList = [select Script_Title__c,Scope_re_brief__c,Shoot_Location__c,Job_Details__c,Job_Details__r.id,No_of_Additional_Films__c,Duration_of_Additional_Films__c,LastModifiedById,
                               No_of_Masters__c,Duration_of_Masters__c,Total_no_of_films__c,No_of_shoot_days__c,Stage_RAP_engaged__c,Job_Details__r.AdManagerText__c,CreatedById,Number_Of_Quotes__c,
                               Average_Total_Opening_Quotes__c,Euro_Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quote__c,Percentage_Saving_Accepted_Quote__c,Saving_Accepted_Quote_Euro__c,Saving_Average_of_Quotes__c,Percentage_Saving_Average_of_Quotes__c,Cost_Per_Master__c,Cost_per_master_per_shoot_day__c from Amr_Saving__c where Job_Details__r.id = :jobId AND (CreatedById = :userId OR LastModifiedById = :userId ) limit 1];
                      system.debug('inside Rap List========>'+quoteList );
                     
                 }            
                  Set<Id>savingIds=new Set<Id>();
                      for(Amr_Saving__c saving:quoteList){
                        savingIds.add(saving.Id);
                      }
                      quoteRelatedToSavingList = [select Saving__c,Quote_Number__c,Is_PC_part_of_the_Roster__c,PC_name__c,PC_Country__c,Service_Company_Name__c,
                                           Local_Currency_of_PC_Costs__c,Local_Amount_of_PC__c,PPC_Costs_Euro_Amount__c,
                                           Is_the_PPC_part_of_the_Roster__c,PPC_Name__c,PPC_Country__c,
                                           Local_Currency_of_PPC_Costs__c,Local_Amount_of_PPC__c,CA_Costs_Euro_Amount__c,
                                           CA_Additional_agency_Name__c,CA_Location__c,Is_Accepted__c,
                                           Local_Currency_of_CA_Costs__c,Local_Amount_of_CA__c,PC_Costs_Euro_Amount__c,
                                           Total_Cost__c,id,Folder__c from Amr_Quote__c where Saving__c IN :savingIds ORDER BY Quote_Number__c limit 1];             //
               
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
     public void productionTypeValues( ){
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
    
    }
     integer i = 1;
    public void addRowQuote(){
            if(i == 1){
                docAndQuoteLst.add(new InnerSavingClass(i,true));
                i = i+1;
            }else{
                docAndQuoteLst.add(new InnerSavingClass(i,false));  
                i = i+1;
            }
            
    }
    
    public class InnerSavingClass{
        public Amr_Quote__c quoteObj{get;set;}
        public document docObj{get;set;}
        public InnerSavingClass(Integer i,Boolean accepted){
            quoteObj = new Amr_Quote__c(Quote_Number__c = i,Is_Accepted__c = accepted);
            docObj =  new document();
        }
        
    }
    
     public void SaveQuote(){
        //system.debug('==========>doc'+docAndQuoteLst);
        //system.debug('==========>saving'+savingObj);
    
    }
    public PageReference editSaving(){
        
        if(saveRecordValue!=null){
        editedSavingMode = true;
        }
        system.debug('editedSavingMode!!'+editedSavingMode);
        return null;
    }
    
    public PageReference editQuote(){
        editedQuoteMode = true;
        
        return null;
    }
    
    public PageReference submitDataForSavingId(){
        system.debug('savingId!!'+savingId);
    return null;
    }
    
    public PageReference submitData(){
    system.debug('savingId!!'+savingId);
      system.debug('document!!'+document);
    if(document.body!=null){
    system.debug('document !!'+document);}
    update quoteList;
    editedSavingMode = false;
    updateData();
    system.debug('quoteList!!'+quoteList);
    pagereference page = new PageReference('/apex/amr_gksaving?id='+jobid);page.setRedirect(true); return page ; 
 
    

    return null;
    }
    
    
}