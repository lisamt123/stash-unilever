public with sharing Class Amr_AdManagerHelper_CC{


    public String gbvmEmail;
   // public String thresholdValue;
     public double amountEntered{get;set;}
    public String ToUserEmailId{get;set;}
   // public String gbvmEmail  {get;set;}
    public Double thresholdValue  {get;set;}
    Amr_AdManagerController_CC admanagerObj;
    public Amr_AdManagerHelper_CC(){
        admanagerObj = new Amr_AdManagerController_CC(); 
    }
    
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
   Parameters: 
   Returns: It’s return Pagereference
   ********************************************************************/ 
        public PageReference createJob(String selectedCountryValue, String categoryNameValue, String brandPosNameValue,  String brandNameFromPageValue,Amr_Job_Details__c jobDetailsObj, String projectNameFromPageValue, List<SelectOption> listOfBrandValue){
                try{  
                      
                    Amr_CurrencyConversionRate__c currencyObject =[SELECT Currency_Unit__c,Name FROM Amr_CurrencyConversionRate__c WHERE Currency_Unit_To_Euro__c =:double.valueOf(selectedCountryValue) limit 1];
                    String currencyFinalString = currencyObject.Name+Amr_ConstantForAdManager.DASH+currencyObject.Currency_Unit__c;
                    List<MDO_BrandPositions__c> MDOBrandPositionslst =[select  brand_position_id__c,product_category_id__c,brand_id__c from MDO_BrandPositions__c where product_category_id__r.name = :categoryNameValue AND brand_position_id__r.name = :brandPosNameValue AND brand_id__r.name = :brandNameFromPageValue];
                    
                    if(MDOBrandPositionslst.size()>0){
                        MDO_BrandPositions__c MDOobj = MDOBrandPositionslst[0];
                        jobDetailsObj.ProductCategory__c = MDOobj.product_category_id__c;
                        jobDetailsObj.Brand_Position__c = MDOobj.brand_position_id__c;
                        jobDetailsObj.Brand_Final__c = MDOobj.brand_id__c;
                    }
                    jobDetailsObj.Currency_Conversion_Country_List__c = currencyFinalString;
                                     
                    adManagerNumberCreation(jobDetailsObj);
                    jobDetailsObj.Is_Submitt__c = true;
                    compareThresold(jobDetailsObj, categoryNameValue,brandPosNameValue,brandNameFromPageValue);
                    jobDetailsObj.GBVM_Email__c = gbvmEmail;
                    jobDetailsObj.Threshold_Amount__c = thresholdValue ;
                    jobDetailsObj.Job_Status__c = 'Pending';
                    jobDetailsObj.BroadcastMarketText__c = jobDetailsObj.Brodcast_Market__c;
                    insert jobDetailsObj;
                    
                    admanagerObj.getCategoryList();
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
   Parameters: 
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
   Parameters: 
   Returns: It’s return Nothing
   ********************************************************************/ 

    public void adManagerNumberCreation(Amr_Job_Details__c jobDetailsObj){
        try{
            Amr_Job_Details__c[] jobDetailList=[select Id,AdManagerText__c from Amr_Job_Details__c order by CreatedDate desc limit 1];
          
            Id id = jobDetailsObj.Brand_Final__c ;
          
            MDO_Brand__c jobBrand = [select Name from MDO_Brand__c  where Id =: id];
            String brandStr = jobBrand.Name;
            String brandName = brandStr.Left(3);
            
            if(jobDetailList.size()>0){
                String textStr = jobDetailList[0].AdManagerText__c;
                String adNumber = textStr.Right(5);
                if(adNumber == Amr_ConstantForAdManager.NINTY_SERIES){
                    jobDetailsObj.AdManagerText__c = brandName+Amr_ConstantForAdManager.BACK_SLASH+Amr_ConstantForAdManager.ZERO_SERIES;
                }else{
                    Integer num = integer.valueOf(adNumber)+1;
                    String numStr =string.valueof(num);
                    for(;numStr.length()<5;){
                        numstr=Amr_ConstantForAdManager.ZERO+numStr;
                        
                    }
                    jobDetailsObj.AdManagerText__c =brandName+Amr_ConstantForAdManager.BACK_SLASH+numstr;}
            }else{
                jobDetailsObj.AdManagerText__c =brandName+Amr_ConstantForAdManager.BACK_SLASH+Amr_ConstantForAdManager.ZERO_SERIES;
            }
           
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            system.debug(ex.getMessage());
        }
    }
     /*******************************************************************    
   Purpose:  This method is used to allocate job to RAP                                         
   Parameters: 
   Returns: It’s return Nothing
   ********************************************************************/ 

    @future
    @TestVisible static void automaticJobAllocation(String JobObject){
        try{
            InnerJobDetail jobDetailsNew = (InnerJobDetail)JSON.deserialize(JobObject, InnerJobDetail.class);
           
            //Autometic assigment
            
            if(jobDetailsNew.Cluster!=null && jobDetailsNew.Country!=null){
                
                List<Amr_Country_Cluster__c> countryClusterLst = Amr_Country_Cluster__c.getAll().values(); 
                List<String> emailIds = new List<String>();
               
                for(Amr_Country_Cluster__c obj:countryClusterLst){
                    if(obj.Cluster__c == jobDetailsNew.Cluster && obj.Country__c ==  jobDetailsNew.Country){
                       
                        emailIds.add(obj.Primary_RAP_Email__c); 
                }
            }
            system.debug('emailIds!!'+emailIds);
            List<PermissionSetAssignment> userList =  [SELECT Id,Assignee.Name,Assignee.id,Assignee.Email FROM PermissionSetAssignment where PermissionSet.Name = :Label.Amr_RAP AND Assignee.Email = :emailIds ];
           system.debug('userList!!'+userList);
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
}