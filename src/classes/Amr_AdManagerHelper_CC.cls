/**********************************************************************  
Name:  Amr_AdManagerHelper_CC Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This is a helper class for AdManager Controller.                                                         
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  04/02/2016      INITIAL DEVELOPMENT            CSR: 
 ***********************************************************************/



public with sharing Class Amr_AdManagerHelper_CC{


    public String gbvmEmail = NULL;
    public double amountEntered{get;set;}
    public String ToUserEmailId{get;set;}
    public Double thresholdValue  {get;set;}    
    Amr_AdManagerController_CC admanagerObj;
    public Amr_AdManagerHelper_CC(){
        admanagerObj = new Amr_AdManagerController_CC(); 
    }
    
        /*******************************************************************    
   Purpose:  This method is check the production activity type validation                                      
   Parameters: Job Detail(Object)
   Returns: It’s return a Boolean value.
   ********************************************************************/ 
   
   
    public Boolean productionActivityTypeValidation( Amr_Job_Details__c jobDetailsObj){
    
            Boolean okayToSaveCheck = true;
            if(!jobDetailsObj.NewOriginalMaster__c && !jobDetailsObj.LanguageAdaptionMaster__c  && !jobDetailsObj.Create_Additional_Material__c && !jobDetailsObj.ReworkExistingMaterial__c && !jobDetailsObj.BuyoutsTalent__c && !jobDetailsObj.BuyoutsMusic__c ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Production_activity_types_at_least_one_option_must_be_selected));
                okayToSaveCheck =false;                
            }
            if(jobDetailsObj.NewOriginalMaster__c && !jobDetailsObj.NewOriginalMasterCinema__c && !jobDetailsObj.NewOriginalMasterTv__c && !jobDetailsObj.NewOriginalMasterRadio__c && !jobDetailsObj.NewOriginalMasterPrint__c && !jobDetailsObj.NewOriginalMasterOutofHome__c &&
                !jobDetailsObj.NewOriginalMasterInStore__c && !jobDetailsObj.NewOriginalMasterDigital__c && !jobDetailsObj.NewOriginalMasterInternalVideo__c ){                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_For_New_Original_Masterat_least_one_option_of_Media_Channel_must_be_selected));
                okayToSaveCheck =false;
            }
         
            if(!jobDetailsObj.NewOriginalMaster__c  && jobDetailsObj.NewOriginalMasterOutofHome__c && !jobDetailsObj.NewOriginalMasterOutofHomeMovingImage__c && 
                !jobDetailsObj.NewOriginalMasterOutofHomeAudio__c && !jobDetailsObj.NewOriginalMasterOutofHomeStillImage__c  ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_least_one_option_of_Medium_must_be_selected_corres_to_Out));
                okayToSaveCheck =false; 
            }
            if(jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.NewOriginalMasterInStore__c && !jobDetailsObj.NewOriginalMasterInStoreMovingImage__c && 
                !jobDetailsObj.NewOriginalMasterInStoreAudio__c && !jobDetailsObj.NewOriginalMasterInStoreStillImage__c  ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOrigiMastat_least_one_option_of_Medium_mustbe_selected_corresto_instore));
                okayToSaveCheck =false;
            }
       
            if(jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.NewOriginalMasterOutofHome__c && !jobDetailsObj.NewOriginalMasterOutofHomeMovingImage__c && 
                !jobDetailsObj.NewOriginalMasterOutofHomeAudio__c && !jobDetailsObj.NewOriginalMasterOutofHomeStillImage__c  ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_leastoneoption_ofMedium_mustbe_selected_corres_to_outOfHo));
                okayToSaveCheck =false;
            }
            if(jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.NewOriginalMasterInStore__c && !jobDetailsObj.NewOriginalMasterInStoreMovingImage__c && 
                !jobDetailsObj.NewOriginalMasterInStoreAudio__c && !jobDetailsObj.NewOriginalMasterInStoreStillImage__c  ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOrigiMaster_at_least_one_optionofMedium_mustbe_selected_corres_inStore));
                okayToSaveCheck =false;
            }
            if(jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.NewOriginalMasterDigital__c && !jobDetailsObj.NewOriginalMasterDigitalMovingImage__c && 
                !jobDetailsObj.NewOriginalMasterDigitalAudio__c && !jobDetailsObj.NewOriginalMasterDigitalStillImage__c  
                && !jobDetailsObj.New_Original_Master_Digital_ED__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_least_one_option_of_Medium_mustbeselected_corre_todigital));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.LanguageAdaptionMaster__c && !jobDetailsObj.LanguageAdaptionMasterTv__c && 
                !jobDetailsObj.LanguageAdaptionMasterCinema__c && !jobDetailsObj.LanguageAdaptionMasterRadio__c && !jobDetailsObj.LanguageAdaptionMasterPrint__c && 
                !jobDetailsObj.LanguageAdaptionMasterOutofHome__c && !jobDetailsObj.LanguageAdaptionMasterInStore__c && !jobDetailsObj.LanguageAdaptionMasterDigital__c &&
                !jobDetailsObj.LanguageAdaptionMasterInternalVideo__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Language_Adaption_Master_at_least_one_option_of_Medium_must_be_selected));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.LanguageAdaptionMaster__c && jobDetailsObj.LanguageAdaptionMasterOutofHome__c && 
                !jobDetailsObj.LanguageAdaptionMasterOutofHomeAudio__c && 
                !jobDetailsObj.LanguageAdaptionMasterOutHomeStillImage__c && 
                !jobDetailsObj.LanguageAdaptionMasterOutHomeMovingImage__c
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LangAdaptMaster_atleast_one_option_of_Medium_mustbe_selected_correTo_OutO));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.LanguageAdaptionMaster__c && jobDetailsObj.LanguageAdaptionMasterInStore__c && 
                !jobDetailsObj.LanguageAdaptionMasterInStoreAudio__c && 
                !jobDetailsObj.LanguageAdaptionMasterInStoreMovingImage__c && 
                !jobDetailsObj.LanguageAdaptionMasterInStoreStillImage__c 
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LangAdaptMaster_atleast_oneoption_of_Medium_mustbe_selectedcorres_in_st));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.LanguageAdaptionMaster__c && jobDetailsObj.LanguageAdaptionMasterDigital__c && 
                !jobDetailsObj.LanguageAdaptionMasterDigitalAudio__c && 
                !jobDetailsObj.LanguageAdaptionMasterDigitalMovingImage__c && 
                !jobDetailsObj.LanguageAdaptionMasterDigitalStillImage__c && !jobDetailsObj.Language_Adaptation_of_Master_Digital_ED__c
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LanguageAdaptionMaster_least_one_optionofMedium_mustbe_selected_corr_to_Digi));
                okayToSaveCheck =false;
            }
        
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.Create_Additional_Material__c && jobDetailsObj.AdditionalSupplementaryNewMaterialOOH__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialOofHMI__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialOofHSI__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialOofHA__c  
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditiSuppNewMaterial_atleast_one_optionofMedium_mustbe_selected_corr_toou));
                okayToSaveCheck =false;
            }
        
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.Create_Additional_Material__c && jobDetailsObj.AdditionalSupplementaryNewMaterialStore__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialInSMI__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialInSA__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialInSSI__c  
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditSuppNewMaterial_at_least_one_optionofMedium_mustbeselect_cor_toinstore));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.Create_Additional_Material__c && jobDetailsObj.AdditionalSupplementaryNewMaterialDigi__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialDigiMI__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialDigiA__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialDigiSI__c  &&
                !jobDetailsObj.Additional_Supplementary_NM_Digital_ED__c  
             ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AddiSuppNewMaterial_atleast_oneoptionofMedium_must_be_selected_corr_to_Dig));
                okayToSaveCheck =false;
            }
        
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.Create_Additional_Material__c &&  
                !jobDetailsObj.AdditionalSupplementaryNewMaterialStore__c && 
                !jobDetailsObj.AdditionalSupplementaryNewMaterialDigi__c &&
                !jobDetailsObj.AdditionalSupplementaryNewMaterialTv__c &&
                !jobDetailsObj.AdditionalSupplementaryNewMaterialCinema__c &&
                !jobDetailsObj.AdditionalSupplementaryNewMaterialRadio__c &&
                !jobDetailsObj.AdditionalSupplementaryNewMaterialOOH__c &&
                !jobDetailsObj.AdditionalSupplementaryNewMaterialIVideo__c
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditionalSupplNewMaterial_atleast_oneoptionof_MedChannel_mustbe_sel));
                okayToSaveCheck =false;
            }
            
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.ReworkExistingMaterial__c && jobDetailsObj.ReworkExistingMaterialOutofHome__c && 
                !jobDetailsObj.ReworkExistingMaterialOutHomeMovingImage__c && 
                !jobDetailsObj.ReworkExistingMaterialOutofHomeAudio__c && 
                !jobDetailsObj.ReworkExistingMaterialOutHomeStillImage__c  
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_RewExistingMat_at_least_one_optionofMedium_mustbe_selected_corr_to_OOH));
                okayToSaveCheck =false;
            }
            
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.ReworkExistingMaterial__c && jobDetailsObj.ReworkExistingMaterialInStore__c && 
                !jobDetailsObj.ReworkExistingMaterialInStoreMovingImage__c && 
                !jobDetailsObj.ReworkExistingMaterialInStoreAudio__c && 
                !jobDetailsObj.In_Store_Still_Image__c  
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_ReworkExistMater_atleast_oneoption_of_Medium_mustbeselected_corr_to_inStor));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.ReworkExistingMaterial__c && jobDetailsObj.ReworkExistingMaterialDigital__c && 
                !jobDetailsObj.ReworkExistingMaterialDigitalMovingImage__c && 
                !jobDetailsObj.ReworkExistingMaterialDigitalAudio__c && 
                !jobDetailsObj.ReworkExistingMaterialDigitalStillImage__c  &&
                !jobDetailsObj.Rework_Exisiting_Material_Digital_ED__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_RewExistMaterial_atleastone_option_of_Medium_must_be_selected_corr_to_Digi));
                okayToSaveCheck =false;
            }
        
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.ReworkExistingMaterial__c && !jobDetailsObj.ReworkExistingMaterialOutofHome__c && 
                !jobDetailsObj.ReworkExistingMaterialInStore__c && 
                !jobDetailsObj.ReworkExistingMaterialDigital__c 
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_ReworkExistMat_atleast_oneoption_of_Media_Channel_mustbe_selected));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.BuyoutsTalent__c && jobDetailsObj.BuyoutsTalentOutofHome__c && 
                !jobDetailsObj.BuyoutsTalentOutofHomeMovingImage__c && 
                !jobDetailsObj.BuyoutsTalentOutofHomeAudio__c && 
                !jobDetailsObj.BuyoutsTalentOutofHomeStillImage__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,LABEL.Amr_Buyouts_Talent_atleast_one_optionofMedium_mustbe_selected_corr_to_OOH));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.BuyoutsTalent__c && jobDetailsObj.BuyoutsTalentInStore__c && 
                !jobDetailsObj.BuyoutsTalentInStoreMovingImage__c && 
                !jobDetailsObj.BuyoutsTalentInStoreAudio__c && 
                !jobDetailsObj.BuyoutsTalentInStoreStillImage__c
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyoutsTalent_at_least_oneoptionofMedium_mustbe_selected_corre_to_Instore ));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.BuyoutsTalent__c && jobDetailsObj.BuyoutsTalentDigital__c && 
                !jobDetailsObj.BuyoutsTalentDigitalMovingImage__c && 
                !jobDetailsObj.BuyoutsTalentDigitalAudio__c && 
                !jobDetailsObj.BuyoutsTalentDigitalStillImage__c  &&
                !jobDetailsObj.Buyouts_Talent_Digital_ED__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyTalent_atleastoneoption_of_Medium_mustbe_selected_corr_to_Digital));
                okayToSaveCheck =false;
            }
        
          if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.BuyoutsTalent__c && !jobDetailsObj.BuyoutsTalentOutofHome__c && 
                !jobDetailsObj.BuyoutsTalentInStore__c && 
                !jobDetailsObj.BuyoutsTalentDigital__c
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Talent_at_least_one_option_of_Media_Channel_must_be_selected));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.BuyoutsMusic__c && jobDetailsObj.BuyoutsMusicOutofHome__c && 
                !jobDetailsObj.BuyoutsMusicOutofHomeMovingImage__c && 
                !jobDetailsObj.BuyoutsMusicOutofHomeAudio__c && 
                !jobDetailsObj.BuyoutsMusicOutofHomeStillImage__c 
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyoutMusic_at_least_one_option_of_Medium_mustbe_selected_corre_to_OutOfHome));
                okayToSaveCheck =false;
            }
        
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.BuyoutsMusic__c && !jobDetailsObj.BuyoutsMusicInStore__c && 
                !jobDetailsObj.BuyoutsMusicDigital__c && 
                !jobDetailsObj.BuyoutsMusicTv__c &&
                !jobDetailsObj.BuyoutsMusicCinema__c &&
                !jobDetailsObj.BuyoutsMusicRadio__c  &&
                !jobDetailsObj.BuyoutsMusicInternalVideo__c &&
                !jobDetailsObj.BuyoutsMusicOutofHome__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_For_Buyouts_Music_at_least_one_option_of_Media_Channel_must_be_selected));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.BuyoutsMusic__c && jobDetailsObj.BuyoutsMusicInStore__c && 
            !jobDetailsObj.BuyoutsMusicInStoreMovingImage__c && 
            !jobDetailsObj.BuyoutsMusicInStoreAudio__c && 
            !jobDetailsObj.BuyoutsMusicInStoreStillImage__c 
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Music_at_least_one_option_of_Medium_mustbe_selected_corr_to_Instore));
                okayToSaveCheck =false;
            }
            if(!jobDetailsObj.NewOriginalMaster__c && jobDetailsObj.BuyoutsMusic__c && jobDetailsObj.BuyoutsMusicDigital__c && 
                !jobDetailsObj.BuyoutsMusicDigitalMovingImage__c && 
                !jobDetailsObj.BuyoutsMusicDigitalAudio__c && 
                !jobDetailsObj.BuyoutsMusicDigitalStillImage__c  &&
                !jobDetailsObj.Buyouts_Music_Digital_ED__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Music_at_least_one_option_of_Medium_must_be_selected_corre_to_Digita));
                okayToSaveCheck =false;
            }
            
            return okayToSaveCheck;
    
    }
    
      /*******************************************************************    
   Purpose:  This method is used to insert Job                                 
   Parameters: Country(String), vategory(String), Brand position(String), Brand(String), Job Detail(Object), project name(String), Brand Value(List<SelectOption>)
   Returns: It’s return Pagereference
   ********************************************************************/ 
        public PageReference createJob(String selectedCountryValue, String categoryNameValue, String brandPosNameValue,  String brandNameFromPageValue,Amr_Job_Details__c jobDetailsObj, String projectNameFromPageValue, List<SelectOption> listOfBrandValue, Boolean singleOrMultiCategory){
                try{  
                      
                    Amr_CurrencyConversionRate__c currencyObject =[SELECT Currency_Unit__c,Name FROM Amr_CurrencyConversionRate__c WHERE Currency_Unit_To_Euro__c =:double.valueOf(selectedCountryValue) limit 1];
                    String currencyFinalString = currencyObject.Name+Amr_ConstantForAdManager.DASH+currencyObject.Currency_Unit__c;

                    if(singleOrMultiCategory){
                        jobDetailsObj.ProductCategory__c = [SELECT Id FROM MDO_Category__c WHERE Name =:categoryNameValue AND status__c = 'Active' LIMIT 1].Id;
                        jobDetailsObj.Brand_Position__c = [SELECT Id FROM MDO_BrandPosition__c WHERE Name =:brandPosNameValue AND status__c = 'Active' LIMIT 1].Id;
                        jobDetailsObj.Brand_Final__c = [SELECT Id FROM MDO_Brand__c WHERE Name =:brandNameFromPageValue AND status__c = 'Active' LIMIT 1].Id;
                    }
                    else{
                        jobDetailsObj.Multi_Category__c = [SELECT Id FROM Amr_Multi_Category__c WHERE Name =:categoryNameValue AND status__c = 'Active' LIMIT 1].Id;
                        jobDetailsObj.Multi_Brand_Positioning__c = [SELECT Id FROM Amr_Multi_Brand_Positioning__c WHERE Name =:brandPosNameValue AND status__c = 'Active' LIMIT 1].Id;
                        jobDetailsObj.Multi_Brand__c = [SELECT Id FROM Amr_Multi_Brand__c WHERE Name =:brandNameFromPageValue AND status__c = 'Active' LIMIT 1].Id;
                    }
                    
                    jobDetailsObj.Currency_Conversion_Country_List__c = currencyFinalString;
                                     
                    adManagerNumberCreation(jobDetailsObj);
                    jobDetailsObj.Is_Submitt__c = true;
                    if(singleOrMultiCategory){
                    compareThresold(jobDetailsObj, categoryNameValue,brandPosNameValue,brandNameFromPageValue);
                    }
                    jobDetailsObj.GBVM_Email__c = gbvmEmail;
                    jobDetailsObj.Threshold_Amount__c = thresholdValue ;
                    jobDetailsObj.Job_Status__c = 'Pending';
                    jobDetailsObj.BroadcastMarketText__c = jobDetailsObj.Brodcast_Market__c;
                    if( singleOrMultiCategory ){
                        jobDetailsObj.Single_or_multiply_project__c = 'single';
                        admanagerObj.getCategoryList();
                    }
                    else{
                        jobDetailsObj.Single_or_multiply_project__c = 'multiply';
                        admanagerObj.getMultiCategoryList();
                    }
                    insert jobDetailsObj;
                    
                    InnerJobDetail innerClassObj = new InnerJobDetail(jobDetailsObj.Project_Leader_Cluster__c,jobDetailsObj.Project_Leader_Country__c,jobDetailsObj.id,jobDetailsObj.AdManagerText__c);
                    String obj = JSON.serialize(innerClassObj);
                    
                    automaticJobAllocation(obj);
                    /*jobDetailsObj = new Amr_Job_Details__c();
                    selectedCountryValue =Amr_ConstantForAdManager.NONE;
                    categoryNameValue =Amr_ConstantForAdManager.NONE;
                    brandPosNameValue =Amr_ConstantForAdManager.NONE;
                    brandNameFromPageValue =Amr_ConstantForAdManager.NONE;
                    projectNameFromPageValue = Amr_ConstantForAdManager.NONE;*/
                    
                   // PageReference pageRef = new PageReference('/apex/Amr_AdManager');
                    PageReference pageRef = Page.Amr_AdManager;
                  //  ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_AdManager));
                   // listOfBrandValue = new List<SelectOption>();
                    pageRef.setRedirect(false);
                    return pageRef;
                    
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }       
            return null;
        } 
         /*******************************************************************    
   Purpose:  This method is used to trigger Email when amount given is greater than Thresold                                      
   Parameters:  Job detail object(object), Category(String), Brand position(String), Brand(String)
   Returns: It’s return Nothing
   ********************************************************************/ 
    // For Threshold Reach
    public void compareThresold(Amr_Job_Details__c jobDetailObj, String Categorty ,String BrandPostion , String Brand ){
        try{
        amountEntered = jobDetailObj.Allocated_Budget_euro__c;
       
        List<Amr_JobBudgetThreshold__c> jobBudgetThresoldList = [select id,BrandPosition__r.name,Brand__r.name, Brand__r.Id, ProductCategory__r.Id,BrandPosition__r.Id,
                                                                 BrandCategoryPosition__c,Budget_Limit__c,ProductCategory__r.name,
                                                                 UserEmailId__c from Amr_JobBudgetThreshold__c where BrandPosition__r.name = :BrandPostion  and ProductCategory__r.name =:Categorty  ];
                                                          
        String brandCategoryPosition = BrandPostion+Brand+Categorty;
                                               
        for(Amr_JobBudgetThreshold__c jobBudgetThresoldObj:jobBudgetThresoldList){
            
            String thresholdCompareId = jobBudgetThresoldObj.BrandPosition__r.name +''+ jobBudgetThresoldObj.Brand__r.name + jobBudgetThresoldObj.ProductCategory__r.name ;
          
            
            if(thresholdCompareId == brandCategoryPosition){ 
             
                if(jobBudgetThresoldObj.Budget_Limit__c < amountEntered){
                    ToUserEmailId = jobBudgetThresoldObj.UserEmailId__c;
                
                    ToUserEmailId = String.valueOf(ToUserEmailId);
                    gbvmEmail  = ToUserEmailId;
                    thresholdValue  = jobBudgetThresoldObj.Budget_Limit__c;
                  
                }
            }
        }
        }catch(exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug('ex****'+ex.getMessage());
        }
   }


    /*******************************************************************    
   Purpose:  This method is used to create Ad Manager Number Denpending on Brand Name Value                                       
   Parameters: Job Detail Object(Object)
   Returns: It’s return Nothing
   ********************************************************************/ 

    public void adManagerNumberCreation(Amr_Job_Details__c jobDetailsObj){
        try{
            String brandStr = '';
            if(jobDetailsObj.Single_or_multiply_project__c == 'single'){
                Id id = jobDetailsObj.Brand_Final__c ;
                MDO_Brand__c jobBrand = [select Name from MDO_Brand__c  where Id =: id];
                brandStr = jobBrand.Name;
            }
            else{
                Id id = jobDetailsObj.Multi_Brand__c;
                Amr_Multi_Brand__c jobBrand = [select Name from Amr_Multi_Brand__c  where Id =: id];
                brandStr = jobBrand.Name;            
            }

            String brandName = brandStr.Left(3);
            AmrAdManagerNumber__c AdMgNumber = AmrAdManagerNumber__c.getInstance('AdManagerNumber');
            String adNumber = AdMgNumber.AdManagerNumber__c;
            if(adNumber != Amr_ConstantForAdManager.NINTY_SERIES ){
                Integer num = integer.valueOf(adNumber)+1;
                String numStr =string.valueof(num);
                for(;numStr.length()<5;){
                    numstr=Amr_ConstantForAdManager.ZERO+numStr;
                }
                jobDetailsObj.AdManagerText__c =brandName+Amr_ConstantForAdManager.BACK_SLASH+numstr;
                AdMgNumber.AdManagerNumber__c = numstr;
            }else{
                jobDetailsObj.AdManagerText__c =brandName+Amr_ConstantForAdManager.BACK_SLASH+Amr_ConstantForAdManager.ZERO_SERIES;
                AdMgNumber.AdManagerNumber__c = Amr_ConstantForAdManager.ZERO_SERIES;
            }
             
             update AdMgNumber;
           
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }
    
/*******************************************************************    
Purpose:  This method is used to allocate job to RAP                                         
Parameters: Job Object(String)
Returns: It’s return Nothing
********************************************************************/ 

    @future
    @TestVisible static void automaticJobAllocation(String JobObject){
        try{
            InnerJobDetail jobDetailsNew = (InnerJobDetail)JSON.deserialize(JobObject, InnerJobDetail.class);
           
            //Automatic assigment
            
            if(jobDetailsNew.Cluster!=null && jobDetailsNew.Country!=null){
                
                List<Amr_Country_Cluster__c> countryClusterLst = Amr_Country_Cluster__c.getAll().values(); 
                List<String> emailIds = new List<String>();
               
                for(Amr_Country_Cluster__c obj:countryClusterLst){
                    if(obj.Cluster__c == jobDetailsNew.Cluster && obj.Country__c ==  jobDetailsNew.Country){
                       
                        emailIds.add(obj.Primary_RAP_Email__c); 
                }
            }
            List<PermissionSetAssignment> userList =  [SELECT Id,Assignee.Name,Assignee.id,Assignee.Email FROM PermissionSetAssignment where PermissionSet.Name = :Label.Amr_RAP AND Assignee.Email = :emailIds ];
            if(userList.size()>0){
                if(userinfo.getuserid() != userList[0].Assignee.id){
                    Amr_Job_Details__Share jobShareObj  = new Amr_Job_Details__Share();
                    jobShareObj.ParentId = jobDetailsNew.JobId;
                    jobShareObj.UserOrGroupId = userList[0].Assignee.id;               
                    jobShareObj.AccessLevel = Amr_ConstantForAdManager.EDIT;
                    insert jobShareObj;
                }
                Amr_AdManagerController_CC.insertJobAllocationData(jobDetailsNew.JobId,userList[0].Assignee.id, userList[0].Assignee.Email);
           }
        }
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }
    
    @TestVisible public class InnerJobDetail{
        public String Cluster{get;set;}
        public String Country{get;set;}
        public String JobId{get;set;}
        public String AdManagerText{get;set;}
        public InnerJobDetail(String Clust,String Count,String Id,String AdManagertxt){
            Cluster = Clust;
            Country = Count;
            JobId = Id;
            AdManagerText = AdManagertxt;
        }
    }
    
public boolean multiCategoryNameFlag = FALSE;
public boolean multiBrandPosNameFlag = FALSE;
public boolean multiBrandNameFlag = FALSE;
public boolean validationFlag = TRUE;
public boolean successMessage = TRUE;
        
/*******************************************************************    
Purpose:  This method is used to insert/update multiply/Non Specific brands                                 
Parameters: String multiCategory value, String multiBrandPositioning value, String multiBrand value from CAP Admin space
Returns: It’s return Pagereference
********************************************************************/ 
public PageReference createMultiBrandPositions(String multiCategory, String multiBrandPositioning, String multiBrand1,String multiBrand2,String multiBrand3,String multiBrand4,String multiBrand5 ){
    
    Id multicatId = NULL;
    Id multibrandPositioningId = NULL;
    
    PageReference pageRef = Page.Amr_CAPAdmin;
    pageRef.setRedirect(false);
    
    
    if( multiCategory == NULL || multiBrandPositioning == NULL || multiCategory == '' || multiBrandPositioning == ''){
     return null;
    }

    if( multiBrand1 == NULL && multiBrand2 == NULL && multiBrand3 == NULL && multiBrand4 == NULL && multiBrand5 == NULL){
    return null;
    }  

    //Validation
    /*
    if(multiCategory != Amr_ConstantForAdManager.NONE ){
        multiCategoryNameFlag = TRUE;
    }
    if(multiBrandPositioning != Amr_ConstantForAdManager.NONE ){
        multiBrandPosNameFlag = TRUE;
    }
    if( multiBrand1 != NULL || multiBrand2 != NULL || multiBrand3 != NULL || multiBrand4 != NULL || multiBrand5 != NULL){
        multiBrandNameFlag = TRUE;
    }
      
    if( !multiCategoryNameFlag && !multiBrandPosNameFlag && !multiBrandNameFlag  ){
     return NULL;
    }

   if( multiCategoryNameFlag &&  multiBrandPosNameFlag &&   multiBrandNameFlag ){
    validationFlag = FALSE;
    }
    if (validationFlag ){
        successMessage = false;
        return null;    
    }
    */
    Set<String> multiBrand =  new Set<String>{multiBrand1,multiBrand2,multiBrand3,multiBrand4,multiBrand5};
try{

    //Multi Category

    List<Amr_Multi_Category__c> categoryId = [select id from Amr_Multi_Category__c  where name =:multiCategory ORDER BY Name limit 1];
    if(categoryId.size() > 0){
    multicatId = categoryId[0].Id;
    }
    else{
    Amr_Multi_Category__c mCategory = new Amr_Multi_Category__c();
    mCategory.Name = multiCategory;
    mCategory.Status__c = 'Active';
    insert mCategory;
    multicatId = mCategory.Id;    
    }

    //Multi BrandPositioning
    List<Amr_Multi_Brand_Positioning__c> mbrandPositioningId = [select id from Amr_Multi_Brand_Positioning__c  where name =:multiBrandPositioning ORDER BY Name limit 1];
    
    if(mbrandPositioningId.size() > 0){
    multibrandPositioningId = mbrandPositioningId[0].Id;
    }
    else{
    Amr_Multi_Brand_Positioning__c mBrandPositioning = new Amr_Multi_Brand_Positioning__c();
    mBrandPositioning.Name = multiBrandPositioning;
    mBrandPositioning.Status__c = 'Active';
    insert mBrandPositioning;
    multibrandPositioningId = mBrandPositioning.Id;    
    }

    for(String mB :multiBrand){
        if(mB.length() > 0 ){
        createMultiBrandPos(multicatId, multibrandPositioningId, mB);
        }
    }    
    pageRef = Page.Amr_CAPAdmin;
    pageRef.setRedirect(true);
    //return pageRef;
    return null;
                    
}catch(exception ex){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
    system.debug('ex****'+ex.getMessage());
}
return Null;
}

/*******************************************************************    
Purpose:  This method is used to insert/update multiply/Non Specific brands                                 
Parameters: String multiCategory value, String multiBrandPositioning value, String multiBrand value from CAP Admin space
Returns: It’s return Pagereference
********************************************************************/ 
public void createMultiBrandPos(Id multicatId, Id multiBrandPositioningId, String multiBrand){
    Id multibrandId = NULL;
    //Multi Brand
    List<Amr_Multi_Brand__c> mBrandId = [select id from Amr_Multi_Brand__c  where name =:multiBrand ORDER BY Name limit 1];

    if(mBrandId.size() > 0){
    multibrandId = mBrandId[0].Id;
    }
    else{
    Amr_Multi_Brand__c mBrand = new Amr_Multi_Brand__c();
    mBrand.Name = multiBrand;
    mBrand.Status__c = 'Active';
    insert mBrand;
    multibrandId = mBrand.Id;    
    }

    //Multi BrandPositions
    List<Amr_Multi_Brand_Positions__c> multiBrandPositionsId = [select id, Multi_Category__c, Multi_Brand_Positioning__c, Multi_Brand__c from Amr_Multi_Brand_Positions__c  where Multi_Category__c =:multicatId and Multi_Brand_Positioning__c =:multiBrandPositioningId and Multi_Brand__c =:multibrandId ORDER BY Name limit 1];

    if(multiBrandPositionsId.size() == 0){
    Amr_Multi_Brand_Positions__c mBrandPositions = new Amr_Multi_Brand_Positions__c();
    mBrandPositions.Multi_Category__c = multicatId;
    mBrandPositions.Multi_Brand_Positioning__c = multibrandPositioningId;
    mBrandPositions.Multi_Brand__c = multibrandId;
    mBrandPositions.Status__c = 'Active';
    insert mBrandPositions;
    }
 
}
    


    
}