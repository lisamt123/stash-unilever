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
    public Boolean productionActivityTypeValidation(Boolean okayToSave, Amr_Job_Details__c jobDetails){
    
   
            if(!jobDetails.NewOriginalMaster__c && !jobDetails.LanguageAdaptionMaster__c  && !jobDetails.Create_Additional_Material__c && !jobDetails.ReworkExistingMaterial__c && !jobDetails.BuyoutsTalent__c && !jobDetails.BuyoutsMusic__c ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Production_activity_types_at_least_one_option_must_be_selected));
                okayToSave =false;                
            }
            if(jobDetails.NewOriginalMaster__c && !jobDetails.NewOriginalMasterCinema__c && !jobDetails.NewOriginalMasterTv__c && !jobDetails.NewOriginalMasterRadio__c && !jobDetails.NewOriginalMasterPrint__c && !jobDetails.NewOriginalMasterOutofHome__c &&
                !jobDetails.NewOriginalMasterInStore__c && !jobDetails.NewOriginalMasterDigital__c && !jobDetails.NewOriginalMasterInternalVideo__c ){                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_For_New_Original_Masterat_least_one_option_of_Media_Channel_must_be_selected));
                okayToSave =false;
            }
         
            if(!jobDetails.NewOriginalMaster__c  && jobDetails.NewOriginalMasterOutofHome__c && !jobDetails.NewOriginalMasterOutofHomeMovingImage__c && 
                !jobDetails.NewOriginalMasterOutofHomeAudio__c && !jobDetails.NewOriginalMasterOutofHomeStillImage__c  ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_least_one_option_of_Medium_must_be_selected_corres_to_Out));
                okayToSave =false; 
            }
            if(jobDetails.NewOriginalMaster__c && jobDetails.NewOriginalMasterInStore__c && !jobDetails.NewOriginalMasterInStoreMovingImage__c && 
                !jobDetails.NewOriginalMasterInStoreAudio__c && !jobDetails.NewOriginalMasterInStoreStillImage__c  ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOrigiMastat_least_one_option_of_Medium_mustbe_selected_corresto_instore));
                okayToSave =false;
            }
       
            if(jobDetails.NewOriginalMaster__c && jobDetails.NewOriginalMasterOutofHome__c && !jobDetails.NewOriginalMasterOutofHomeMovingImage__c && 
                !jobDetails.NewOriginalMasterOutofHomeAudio__c && !jobDetails.NewOriginalMasterOutofHomeStillImage__c  ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_leastoneoption_ofMedium_mustbe_selected_corres_to_outOfHo));
                okayToSave =false;
            }
            if(jobDetails.NewOriginalMaster__c && jobDetails.NewOriginalMasterInStore__c && !jobDetails.NewOriginalMasterInStoreMovingImage__c && 
                !jobDetails.NewOriginalMasterInStoreAudio__c && !jobDetails.NewOriginalMasterInStoreStillImage__c  ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOrigiMaster_at_least_one_optionofMedium_mustbe_selected_corres_inStore));
                okayToSave =false;
            }
            if(jobDetails.NewOriginalMaster__c && jobDetails.NewOriginalMasterDigital__c && !jobDetails.NewOriginalMasterDigitalMovingImage__c && 
                !jobDetails.NewOriginalMasterDigitalAudio__c && !jobDetails.NewOriginalMasterDigitalStillImage__c  
                && !jobDetails.New_Original_Master_Digital_ED__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_NewOriginMaster_at_least_one_option_of_Medium_mustbeselected_corre_todigital));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.LanguageAdaptionMaster__c && !jobDetails.LanguageAdaptionMasterTv__c && 
                !jobDetails.LanguageAdaptionMasterCinema__c && !jobDetails.LanguageAdaptionMasterRadio__c && !jobDetails.LanguageAdaptionMasterPrint__c && 
                !jobDetails.LanguageAdaptionMasterOutofHome__c && !jobDetails.LanguageAdaptionMasterInStore__c && !jobDetails.LanguageAdaptionMasterDigital__c &&
                !jobDetails.LanguageAdaptionMasterInternalVideo__c){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Language_Adaption_Master_at_least_one_option_of_Medium_must_be_selected));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.LanguageAdaptionMaster__c && jobDetails.LanguageAdaptionMasterOutofHome__c && 
                !jobDetails.LanguageAdaptionMasterOutofHomeAudio__c && 
                !jobDetails.LanguageAdaptionMasterOutHomeStillImage__c && 
                !jobDetails.LanguageAdaptionMasterOutHomeMovingImage__c
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LangAdaptMaster_atleast_one_option_of_Medium_mustbe_selected_correTo_OutO));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.LanguageAdaptionMaster__c && jobDetails.LanguageAdaptionMasterInStore__c && 
                !jobDetails.LanguageAdaptionMasterInStoreAudio__c && 
                !jobDetails.LanguageAdaptionMasterInStoreMovingImage__c && 
                !jobDetails.LanguageAdaptionMasterInStoreStillImage__c 
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LangAdaptMaster_atleast_oneoption_of_Medium_mustbe_selectedcorres_in_st));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.LanguageAdaptionMaster__c && jobDetails.LanguageAdaptionMasterDigital__c && 
                !jobDetails.LanguageAdaptionMasterDigitalAudio__c && 
                !jobDetails.LanguageAdaptionMasterDigitalMovingImage__c && 
                !jobDetails.LanguageAdaptionMasterDigitalStillImage__c && !jobDetails.Language_Adaptation_of_Master_Digital_ED__c
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_LanguageAdaptionMaster_least_one_optionofMedium_mustbe_selected_corr_to_Digi));
                okayToSave =false;
            }
        
            if(!jobDetails.NewOriginalMaster__c && jobDetails.Create_Additional_Material__c && jobDetails.AdditionalSupplementaryNewMaterialOOH__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialOofHMI__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialOofHSI__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialOofHA__c  
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditiSuppNewMaterial_atleast_one_optionofMedium_mustbe_selected_corr_toou));
                okayToSave =false;
            }
        
            if(!jobDetails.NewOriginalMaster__c && jobDetails.Create_Additional_Material__c && jobDetails.AdditionalSupplementaryNewMaterialStore__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialInSMI__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialInSA__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialInSSI__c  
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditSuppNewMaterial_at_least_one_optionofMedium_mustbeselect_cor_toinstore));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.Create_Additional_Material__c && jobDetails.AdditionalSupplementaryNewMaterialDigi__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialDigiMI__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialDigiA__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialDigiSI__c  &&
                !jobDetails.Additional_Supplementary_NM_Digital_ED__c  
             ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AddiSuppNewMaterial_atleast_oneoptionofMedium_must_be_selected_corr_to_Dig));
                okayToSave =false;
            }
        
            if(!jobDetails.NewOriginalMaster__c && jobDetails.Create_Additional_Material__c &&  
                !jobDetails.AdditionalSupplementaryNewMaterialStore__c && 
                !jobDetails.AdditionalSupplementaryNewMaterialDigi__c &&
                !jobDetails.AdditionalSupplementaryNewMaterialTv__c &&
                !jobDetails.AdditionalSupplementaryNewMaterialCinema__c &&
                !jobDetails.AdditionalSupplementaryNewMaterialRadio__c &&
                !jobDetails.AdditionalSupplementaryNewMaterialOOH__c &&
                !jobDetails.AdditionalSupplementaryNewMaterialIVideo__c
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_AdditionalSupplNewMaterial_atleast_oneoptionof_MedChannel_mustbe_sel));
                okayToSave =false;
            }
            
            if(!jobDetails.NewOriginalMaster__c && jobDetails.ReworkExistingMaterial__c && jobDetails.ReworkExistingMaterialOutofHome__c && 
                !jobDetails.ReworkExistingMaterialOutHomeMovingImage__c && 
                !jobDetails.ReworkExistingMaterialOutofHomeAudio__c && 
                !jobDetails.ReworkExistingMaterialOutHomeStillImage__c  
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_RewExistingMat_at_least_one_optionofMedium_mustbe_selected_corr_to_OOH));
                okayToSave =false;
            }
            
            if(!jobDetails.NewOriginalMaster__c && jobDetails.ReworkExistingMaterial__c && jobDetails.ReworkExistingMaterialInStore__c && 
                !jobDetails.ReworkExistingMaterialInStoreMovingImage__c && 
                !jobDetails.ReworkExistingMaterialInStoreAudio__c && 
                !jobDetails.In_Store_Still_Image__c  
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_ReworkExistMater_atleast_oneoption_of_Medium_mustbeselected_corr_to_inStor));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.ReworkExistingMaterial__c && jobDetails.ReworkExistingMaterialDigital__c && 
                !jobDetails.ReworkExistingMaterialDigitalMovingImage__c && 
                !jobDetails.ReworkExistingMaterialDigitalAudio__c && 
                !jobDetails.ReworkExistingMaterialDigitalStillImage__c  &&
                !jobDetails.Rework_Exisiting_Material_Digital_ED__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_RewExistMaterial_atleastone_option_of_Medium_must_be_selected_corr_to_Digi));
                okayToSave =false;
            }
        
            if(!jobDetails.NewOriginalMaster__c && jobDetails.ReworkExistingMaterial__c && !jobDetails.ReworkExistingMaterialOutofHome__c && 
                !jobDetails.ReworkExistingMaterialInStore__c && 
                !jobDetails.ReworkExistingMaterialDigital__c 
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_ReworkExistMat_atleast_oneoption_of_Media_Channel_mustbe_selected));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsTalent__c && jobDetails.BuyoutsTalentOutofHome__c && 
                !jobDetails.BuyoutsTalentOutofHomeMovingImage__c && 
                !jobDetails.BuyoutsTalentOutofHomeAudio__c && 
                !jobDetails.BuyoutsTalentOutofHomeStillImage__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,LABEL.Amr_Buyouts_Talent_atleast_one_optionofMedium_mustbe_selected_corr_to_OOH));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsTalent__c && jobDetails.BuyoutsTalentInStore__c && 
                !jobDetails.BuyoutsTalentInStoreMovingImage__c && 
                !jobDetails.BuyoutsTalentInStoreAudio__c && 
                !jobDetails.BuyoutsTalentInStoreStillImage__c
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyoutsTalent_at_least_oneoptionofMedium_mustbe_selected_corre_to_Instore ));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsTalent__c && jobDetails.BuyoutsTalentDigital__c && 
                !jobDetails.BuyoutsTalentDigitalMovingImage__c && 
                !jobDetails.BuyoutsTalentDigitalAudio__c && 
                !jobDetails.BuyoutsTalentDigitalStillImage__c  &&
                !jobDetails.Buyouts_Talent_Digital_ED__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyTalent_atleastoneoption_of_Medium_mustbe_selected_corr_to_Digital));
                okayToSave =false;
            }
        
          if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsTalent__c && !jobDetails.BuyoutsTalentOutofHome__c && 
                !jobDetails.BuyoutsTalentInStore__c && 
                !jobDetails.BuyoutsTalentDigital__c
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Talent_at_least_one_option_of_Media_Channel_must_be_selected));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsMusic__c && jobDetails.BuyoutsMusicOutofHome__c && 
                !jobDetails.BuyoutsMusicOutofHomeMovingImage__c && 
                !jobDetails.BuyoutsMusicOutofHomeAudio__c && 
                !jobDetails.BuyoutsMusicOutofHomeStillImage__c 
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_BuyoutMusic_at_least_one_option_of_Medium_mustbe_selected_corre_to_OutOfHome));
                okayToSave =false;
            }
        
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsMusic__c && !jobDetails.BuyoutsMusicInStore__c && 
                !jobDetails.BuyoutsMusicDigital__c && 
                !jobDetails.BuyoutsMusicTv__c &&
                !jobDetails.BuyoutsMusicCinema__c &&
                !jobDetails.BuyoutsMusicRadio__c  &&
                !jobDetails.BuyoutsMusicInternalVideo__c &&
                !jobDetails.BuyoutsMusicOutofHome__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_For_Buyouts_Music_at_least_one_option_of_Media_Channel_must_be_selected));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsMusic__c && jobDetails.BuyoutsMusicInStore__c && 
            !jobDetails.BuyoutsMusicInStoreMovingImage__c && 
            !jobDetails.BuyoutsMusicInStoreAudio__c && 
            !jobDetails.BuyoutsMusicInStoreStillImage__c 
            ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Music_at_least_one_option_of_Medium_mustbe_selected_corr_to_Instore));
                okayToSave =false;
            }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsMusic__c && jobDetails.BuyoutsMusicDigital__c && 
                !jobDetails.BuyoutsMusicDigitalMovingImage__c && 
                !jobDetails.BuyoutsMusicDigitalAudio__c && 
                !jobDetails.BuyoutsMusicDigitalStillImage__c  &&
                !jobDetails.Buyouts_Music_Digital_ED__c 
                ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.Amr_Buyouts_Music_at_least_one_option_of_Medium_must_be_selected_corre_to_Digita));
                okayToSave =false;
            }
            
            return okayToSave;
    
    }
    
      /*******************************************************************    
   Purpose:  This method is used to insert Job                                 
   Parameters: 
   Returns: It’s return Pagereference
   ********************************************************************/ 
        public PageReference createJob(String selectedCountry, String categoryName, String brandPosName,  String brandNameFromPage,Amr_Job_Details__c jobDetails, String projectNameFromPage, List<SelectOption> listOfBrand){
                try{  
                      
                    Amr_CurrencyConversionRate__c currencyObject =[SELECT Currency_Unit__c,Name FROM Amr_CurrencyConversionRate__c WHERE Currency_Unit_To_Euro__c =:double.valueOf(selectedCountry) limit 1];
                    String currencyFinalString = currencyObject.Name+Amr_ConstantForAdManager.DASH+currencyObject.Currency_Unit__c;
                    List<MDO_BrandPositions__c> MDOBrandPositionslst =[select  brand_position_id__c,product_category_id__c,brand_id__c from MDO_BrandPositions__c where product_category_id__r.name = :categoryName AND brand_position_id__r.name = :brandPosName AND brand_id__r.name = :brandNameFromPage];
                    
                    if(MDOBrandPositionslst.size()>0){
                        MDO_BrandPositions__c MDOobj = MDOBrandPositionslst[0];
                        jobDetails.ProductCategory__c = MDOobj.product_category_id__c;
                        jobDetails.Brand_Position__c = MDOobj.brand_position_id__c;
                        jobDetails.Brand_Final__c = MDOobj.brand_id__c;
                    }
                    jobDetails.Currency_Conversion_Country_List__c = currencyFinalString;
                                     
                    adManagerNumberCreation(jobDetails);
                    jobDetails.Is_Submitt__c = true;
                    compareThresold(jobDetails, categoryName,brandPosName,brandNameFromPage);
                    jobDetails.GBVM_Email__c = gbvmEmail;
                    jobDetails.Threshold_Amount__c = thresholdValue ;
                    jobDetails.Job_Status__c = 'Pending';
                    jobDetails.BroadcastMarketText__c = jobDetails.Brodcast_Market__c;
                    insert jobDetails;
                    
                    admanagerObj.getCategoryList();
                    InnerJobDetail innerClassObj = new InnerJobDetail(jobDetails.Project_Leader_Cluster__c,jobDetails.Project_Leader_Country__c,jobDetails.id,jobDetails.AdManagerText__c);
                    String obj = JSON.serialize(innerClassObj);
                    
                    automaticJobAllocation(obj);
                    jobDetails = new Amr_Job_Details__c();
                    selectedCountry =Amr_ConstantForAdManager.NONE;
                    categoryName =Amr_ConstantForAdManager.NONE;
                    brandPosName =Amr_ConstantForAdManager.NONE;
                    brandNameFromPage =Amr_ConstantForAdManager.NONE;
                    projectNameFromPage = Amr_ConstantForAdManager.NONE;
                    
                   // PageReference pageRef = new PageReference('/apex/Amr_AdManager');
                    PageReference pageRef = Page.Amr_AdManager;
                  //  ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_AdManager));
                    listOfBrand = new List<SelectOption>();
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

    public void adManagerNumberCreation(Amr_Job_Details__c jobDetails){
        try{
            Amr_Job_Details__c[] jobDetailList=[select Id,AdManagerText__c from Amr_Job_Details__c order by CreatedDate desc limit 1];
          
            Id id = jobDetails.Brand_Final__c ;
          
            MDO_Brand__c jobBrand = [select Name from MDO_Brand__c  where Id =: id];
            String brandStr = jobBrand.Name;
            String brandName = brandStr.Left(3);
            
            if(jobDetailList.size()>0){
                String textStr = jobDetailList[0].AdManagerText__c;
                String adNumber = textStr.Right(5);
                if(adNumber == Amr_ConstantForAdManager.NINTY_SERIES){
                    jobDetails.AdManagerText__c = brandName+Amr_ConstantForAdManager.BACK_SLASH+Amr_ConstantForAdManager.ZERO_SERIES;
                }else{
                    Integer num = integer.valueOf(adNumber)+1;
                    String numStr =string.valueof(num);
                    for(;numStr.length()<5;){
                        numstr=Amr_ConstantForAdManager.ZERO+numStr;
                        
                    }
                    jobDetails.AdManagerText__c =brandName+Amr_ConstantForAdManager.BACK_SLASH+numstr;}
            }else{
                jobDetails.AdManagerText__c =brandName+Amr_ConstantForAdManager.BACK_SLASH+Amr_ConstantForAdManager.ZERO_SERIES;
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
                Amr_Job_Details__Share jobShareObj  = new Amr_Job_Details__Share();
                jobShareObj.ParentId = jobDetailsNew.JobId;
                jobShareObj.UserOrGroupId = userList[0].Assignee.id;               
                jobShareObj.AccessLevel = Amr_ConstantForAdManager.EDIT;
                insert jobShareObj;
              
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