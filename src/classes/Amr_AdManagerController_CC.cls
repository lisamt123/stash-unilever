/**********************************************************************  
Name:  Amr_AdManagerController_CC ()  Copyright © 2015  Salesforce  
====================================================== 
====================================================== 
Purpose:                                                           
-------   This class is holds the  business logic for Creation Of New Saving,Quote and Accepted Quote.                                                         
 ====================================================== 
 ====================================================== 
 History                                                             
 -------                                                             
 VERSION   AUTHOR                        DATE              DETAIL                    Description    
 1.0       Mindtree                  04/02/2016      INITIAL DEVELOPMENT            CSR: 
 ***********************************************************************/
public with sharing class Amr_AdManagerController_CC{

    public Amr_Job_Details__c jobDetails{get;set;}
    public static final String STR_NONE = '--None--';
    public static final String STR_CHECK = 'Check -> ';
    //public static final boolean VAL_TRUE = true;
    public Amr_Logging_Form_Setting__c r  {get; set;}
    //public String categorylabel{get;set;}
    
    public String selectedCountry {get;set;}
    public String projectNameFromPage{get;set;}
    public String productionActivityData {get;set;}
    public List<selectOption> currencyRecords {
        get {
            List<selectOption> options = new List<selectOption>();
            List<selectOption> optionsNew = new List<selectOption>();
            options.add(new SelectOption(STR_NONE,STR_NONE));
            List<Amr_CurrencyConversionRate__c> lstcov = Amr_CurrencyConversionRate__c.getAll().values();
            System.debug('Currency List Size --> ' + lstcov.size());
            lstcov.sort();
            
            Map<String,String> mapAmountToCurrency = new Map<String,String>();
        
            for (Amr_CurrencyConversionRate__c cc: lstcov){
                if( (cc.Name+'-'+cc.Currency_Unit__c == 'USA-US $') ||  (cc.Name+'-'+cc.Currency_Unit__c == 'UK-£' ) || (cc.Name+'-'+cc.Currency_Unit__c == 'EEC-Euro' )){
                    mapAmountToCurrency.put(cc.Name+'-'+cc.Currency_Unit__c , String.valueOf(cc.Currency_Unit_To_Euro__c));
                    options.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+'-'+cc.Currency_Unit__c));
                    continue;
                }   
                else{
                    optionsNew.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+'-'+cc.Currency_Unit__c));
                }
                //€ (EEC), £(UK), $(US)
            }
             options.addAll(optionsNew);
            
            return options;

        }
        set;
    }

   
    public String categoryName{get;set;}
    public String brandPosName{get;set;}
    public String brandNameFromPage{get;set;} 
    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public List<SelectOption> listOfBrand{get;set;}
   
    public List<Amr_Project_Details__c> projNameList {get;set;}
    public String[]  listString{get;set;}
    public String[]  categoryString{get;set;}
    public String UserLoginId{get;set;}
    public List<PermissionSetAssignment> PermissionSetAssignmentList{get;set;}
    public boolean flag{get;set;}
    public boolean display{get;set;}
    public boolean displayRap{get;set;}
    public String CheckWithCMI{get;set;}

    public Amr_AdManagerController_CC(){
        try{
            Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
            jobDetails = new Amr_Job_Details__c();
            r = [SELECT Introduction__c, Header__c, Footer__c, Allocation__c, Automatic_Allocation_On__c FROM Amr_Logging_Form_Setting__c LIMIT 1];
            projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];

            listString = new list<string>();
            categoryString = new list<string>();
            listString.add(STR_NONE);
            
            for(Amr_Project_Details__c i : projNameList){
                listString.add(i.name);
            }
            
            Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
            for(MDO_Category__c mdCat : categorylst){
                categoryString.add(mdCat.name);
            }

            listOfBrandPosition = new List<SelectOption>();
            listOfBrandPosition.add(new selectOption(STR_NONE,STR_NONE));
            system.debug('mdString !!'+categoryString);
            system.debug('listString!!'+listString);
            System.debug('Project Name Size -> ' + projNameList.size());
        
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }

    public void updateSetting(){
        update r;       
    }


    
   /*******************************************************************    
   Purpose:  This method is used to get Category Values                                                       
   Parameters: 
   Returns: It’s return String

   ********************************************************************/ 

    public String getCategoryList(){ 
        System.debug('cATE ->' +  JSON.serialize(categoryString));
        return JSON.serialize(categoryString);
    }
    
        
   /*******************************************************************    
   Purpose:  This method is used to get Project Name                                                     
   Parameters: 
   Returns: It’s return String

   ********************************************************************/ 
    
    public String getMethodToPassProjectNames(){
        system.debug('serialize!!'+JSON.serialize(listString));
        return JSON.serialize(listString);
    }
    
    /*******************************************************************    
   Purpose:  This method is used to get Brand Position Data                                                 
   Parameters: 
   Returns: It’s return PageReference

   ********************************************************************/ 
    public PageReference  brandPositionListData(){  
        try{  
            System.debug('BBBBBBRANDDD ->'+ categoryName);  
            Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
            
            Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(categoryName);
            system.debug('brandPositionListttoo----->'+brandPositionlst );
            Set<String> brnadPosNameSet = new Set<String>();
            
            for(MDO_BrandPositions__c bps : brandPositionlst){
                if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                    listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));
                    brnadPosNameSet.add(bps.brand_position_id__r.name);
                }
            }
            system.debug('brandPositionListtt----->'+listOfBrandPosition);
        }catch(Exception e){
            system.debug(e.getMessage());
        }
        
        return null;

    }
    
    /*******************************************************************    
   Purpose:  This method is used to get Brand Data                                                 
   Parameters: 
   Returns: It’s return optionValue

   ********************************************************************/ 
    public List<SelectOption> getBrandList(){  
        try{    
            listOfBrand = new List<SelectOption>();
            system.debug('========>'+brandPosName+'category name=====>'+categoryName);
            listOfBrand.add(new selectOption(STR_NONE,STR_NONE));
        
            Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
            Set<MDO_BrandPositions__c> brandlst = utiltyObj.brandValues(categoryName,brandPosName);
            Set<String> brnadNameSet = new Set<String>();
            
            for(MDO_BrandPositions__c bps : brandlst){
                if(!brnadNameSet.contains(bps.brand_id__r.name)){
                    listOfBrand.add(new selectOption(bps.brand_id__r.name,bps.brand_id__r.name));
                    brnadNameSet.add(bps.brand_id__r.name);
                }
            }
            
            return listOfBrand;
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        }
    }

    public boolean CheckWithCMIflag{get;set;}
    public boolean yourEmailAddressFlag{get;set;}
    public boolean unileverFinanceMemberEmailFlag{get;set;}
    public boolean projectLeaderCountryClusterFlag{get;set;}
    public boolean finalApproverMaterialEmailFlag{get;set;}
    public boolean functionYouArePartFlag{get;set;}
    public boolean budgetResponsibilityFlag{get;set;}
    public boolean budgetAllocatedCountryFlag{get;set;}
    public boolean budgetAllocatedInputFlag{get;set;}
    public boolean categoryNameFlag{get;set;}
    public boolean brandPosNameFlag{get;set;}
    public boolean brandNameFromPageFlag{get;set;}
    public boolean agencyDirectorEmailFlag{get;set;}
    public boolean projectDescriptionFlag{get;set;}
    public boolean campaignNameFlag{get;set;}
    public boolean targetAirDateFlag{get;set;}
    public boolean leadAgencyFlag{get;set;}
    public boolean LeadAgencyClusterFlag{get;set;}
    public boolean projectDetailsFlag{get;set;}
    public boolean productionActivityTypeFlag{get;set;}
    public boolean ExecutionNameFlag{get;set;}
    public boolean BrodcastMarketFlag{get;set;}
    public boolean RequireMusicFlag{get;set;}
    public boolean RequireTalentFlag{get;set;}
    public boolean StageProductionActivity{get;set;}
    
    /*******************************************************************    
   Purpose:  This method is used to validate job Values                                            
   Parameters: 
   Returns: It’s return Pagereference
   ********************************************************************/ 
    public Pagereference getSubmitForm(){
        try{
            CheckWithCMIflag = false;
            yourEmailAddressFlag = false;
            unileverFinanceMemberEmailFlag = false;
            projectLeaderCountryClusterFlag = false;
            finalApproverMaterialEmailFlag = false;
            FunctionYouArePartFlag = false;
            budgetResponsibilityFlag = false;
            budgetAllocatedCountryFlag = false;
            budgetAllocatedInputFlag = false;
            categoryNameFlag = false;
            brandPosNameFlag = false;
            brandNameFromPageFlag = false;
            AgencyDirectorEmailFlag = false;
            ProjectDescriptionFlag = false;
            CampaignNameFlag = false;
            TargetAirDateFlag = false;
            leadAgencyFlag = false;
            LeadAgencyClusterFlag = false;
            projectDetailsFlag = false;
            productionActivityTypeFlag = false;
            //ProjectDescriptionFlag = false;
            ExecutionNameFlag = false;
            BrodcastMarketFlag = false;
            RequireMusicFlag = false;
            RequireTalentFlag = false;
            StageProductionActivity = false;
            CheckWithCMI = 'Please fill in missing information';
            
            
            Boolean okayToSave = true;
            system.debug('hii!!'+categoryName+'!!'+brandPosName+'!!'+brandNameFromPage);
            system.debug('job detail checkboxes=======>'+jobDetails.Project_Details__c  );
            if(jobDetails.Project_Details__c!=null){
              Amr_Project_Details__c projectObj = [select id,name from Amr_Project_Details__c where id = :jobDetails.Project_Details__c ];
              projectNameFromPage = projectObj.name;
              system.debug('project name====>'+projectNameFromPage);
            }
            system.debug('projectNameFromPage=======>'+projectNameFromPage);
            system.debug('selectedCountry=======>'+selectedCountry);
            system.debug('CC!'+productionActivityData);
            
            jobDetails.ProductionActivityTextArea__c = productionActivityData;
            system.debug('jobDetails.Check_With_CMI__c!!'+jobDetails.Check_With_CMI__c);
            System.debug(STR_CHECK + jobDetails.NewOriginalMaster__c + STR_CHECK + jobDetails.NewOriginalMasterOutofHome__c + STR_CHECK + jobDetails.NewOriginalMasterOutofHomeMovingImage__c + STR_CHECK +
            jobDetails.NewOriginalMasterOutofHomeAudio__c + STR_CHECK + jobDetails.NewOriginalMasterOutofHomeStillImage__c );
            
            if(jobDetails.Check_With_CMI__c == null){      
                CheckWithCMIflag = true;     
            }
            
            if(jobDetails.Your_Email_Address__c == null){
                yourEmailAddressFlag = true;
            } 
          
            if(jobDetails.Unilever_Finance_Member_Email__c == null){
                unileverFinanceMemberEmailFlag = true;    
            }
            
            if(jobDetails.Final_Approver_Of_Material_Email__c== null){
                finalApproverMaterialEmailFlag = true;
                
            }
           
            if((String.isBlank(selectedCountry)|| selectedCountry == STR_NONE)){
                budgetAllocatedCountryFlag = true;
                
            }
            if(jobDetails.Budget_Allocated_Input_Value__c == null){
                budgetAllocatedInputFlag =  true;
                
            }
            
            if(categoryName == STR_NONE){
                
                categoryNameFlag = true;
                
            }
            if(brandPosName == STR_NONE){
                brandPosNameFlag = true;
                
            }
            if(brandNameFromPage == STR_NONE){
                brandNameFromPageFlag = true;
               
            }
            if(jobDetails.Agency_Contact_Account_Director_Email__c == null){
                AgencyDirectorEmailFlag = true;
                
            }
            if(jobDetails.Project_Description__c == null){
                ProjectDescriptionFlag = true;
               
            }
            if(jobDetails.Campaign_Name__c == null){
                CampaignNameFlag = true;
                
            }
            if(jobDetails.Target_Air_Date__c == null){
                TargetAirDateFlag = true;
               
            }
            
            if(jobDetails.Project_Leader_Cluster__c == null || jobDetails.Project_Leader_Country__c == null){
                projectLeaderCountryClusterFlag = true;
              
            }
            
            if(jobDetails.Function_You_Are_Part__c == null){
                FunctionYouArePartFlag = true;
               
            }
            
            if(jobDetails.Budget_Responsibility__c == null){
                budgetResponsibilityFlag = true;
               
            }
            
            if(jobDetails.Lead_Creative_Agency_name__c == null && jobDetails.Lead_Agency_Name_Other__c == null){
                leadAgencyFlag = true;
                
            }
            if(jobDetails.Lead_Agency_Location_Cluster__c == null || jobDetails.Lead_Agency_Location_Country__c == null){
                LeadAgencyClusterFlag = true; 
                
            }
            if(String.isBlank(jobDetails.Project_Details__c) && String.isBlank(jobDetails.Project_Name_Other__c) ){
                projectDetailsFlag = TRUE;
                projectNameFromPage = null;
               
            }
            
            if(jobDetails.Production_Activity_Type__c == null){
                productionActivityTypeFlag = true;
               
            }
        
            if(String.isBlank(jobDetails.Project_Description__c)){
                ProjectDescriptionFlag = true;
                
            }
            if(String.isBlank(jobDetails.Execution_Name__c)){
                ExecutionNameFlag = true;
                
            }
            if(String.isBlank(jobDetails.Brodcast_Market__c)){
                BrodcastMarketFlag = true;
                
            }
            if(jobDetails.Require_Music__c == null){
                RequireMusicFlag = true;
                
            }
            if(jobDetails.Require_Celebrity_Talent__c == null){
                RequireTalentFlag = true;
               
            }
            if(jobDetails.Stage_of_Production_Activity__c == null){
                StageProductionActivity = true;
               
            }
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
            if( !okayToSave || CheckWithCMIflag || yourEmailAddressFlag || unileverFinanceMemberEmailFlag || projectLeaderCountryClusterFlag || finalApproverMaterialEmailFlag || functionYouArePartFlag
            	 || budgetResponsibilityFlag || budgetAllocatedCountryFlag || budgetAllocatedInputFlag || categoryNameFlag || brandPosNameFlag || brandNameFromPageFlag || agencyDirectorEmailFlag
            	 || projectDescriptionFlag || campaignNameFlag || leadAgencyFlag || LeadAgencyClusterFlag || projectDetailsFlag || productionActivityTypeFlag 
            	 || ExecutionNameFlag || BrodcastMarketFlag || RequireMusicFlag || RequireTalentFlag || StageProductionActivity) {
           
                return null;
            }
    
            createJob();
        }catch(Exception e){
            system.debug(e.getMessage());
        }
            return null;

    }
    
    /*******************************************************************    
   Purpose:  This method is used to insert Job                                 
   Parameters: 
   Returns: It’s return Pagereference
   ********************************************************************/ 
        public PageReference createJob(){
                try{     
                    Amr_CurrencyConversionRate__c currencyObject =[SELECT Currency_Unit__c,Name FROM Amr_CurrencyConversionRate__c WHERE Currency_Unit_To_Euro__c =:double.valueOf(selectedCountry) limit 1];
                    system.debug('currencyObject !!!'+currencyObject);
                    String currencyFinalString = currencyObject.Name+'-'+currencyObject.Currency_Unit__c;
                    system.debug('selectedCountry !!!'+selectedCountry +'currencyObject !!!'+currencyObject +'currencyFinalString !!'+currencyFinalString );
                    List<MDO_BrandPositions__c> MDOBrandPositionslst =[select  brand_position_id__c,product_category_id__c,brand_id__c from MDO_BrandPositions__c where product_category_id__r.name = :categoryName AND brand_position_id__r.name = :brandPosName AND brand_id__r.name = :brandNameFromPage];
                    
                    if(MDOBrandPositionslst.size()>0){
                        MDO_BrandPositions__c MDOobj = MDOBrandPositionslst[0];
                        jobDetails.ProductCategory__c = MDOobj.product_category_id__c;
                        jobDetails.Brand_Position__c = MDOobj.brand_position_id__c;
                        jobDetails.Brand_Final__c = MDOobj.brand_id__c;
                    }
                    jobDetails.Currency_Conversion_Country_List__c = currencyFinalString;
                    
                    system.debug('values!@@!!'+jobDetails.ProductCategory__c+'!!'+jobDetails.Brand_Position__c+'!!'+jobDetails.Brand_Final__c);
                    
                    adManagerNumberCreation();
                    jobDetails.Is_Submitt__c = true;
                    compareThresold(jobDetails, categoryName,brandPosName,brandNameFromPage);
                    jobDetails.GBVM_Email__c = gbvmEmail;
                    jobDetails.Threshold_Amount__c = thresholdValue ;
                    System.debug('HELLO ->!!!!!' + jobDetails.GBVM_Email__c);   
                    insert jobDetails;
                    
                    getCategoryList();
                    InnerJobDetail innerClassObj = new InnerJobDetail(jobDetails.Project_Leader_Cluster__c,jobDetails.Project_Leader_Country__c,jobDetails.id,jobDetails.AdManagerText__c);
                    String obj = JSON.serialize(innerClassObj);
                    
                    automaticJobAllocation(obj);
                    jobDetails = new Amr_Job_Details__c();
                    selectedCountry =STR_NONE;
                    categoryName =STR_NONE;
                    brandPosName =STR_NONE;
                    brandNameFromPage =STR_NONE;
                    
                   // PageReference pageRef = new PageReference('/apex/Amr_AdManager');
                    PageReference pageRef = Page.Amr_AdManager;
                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,Label.Amr_Success_AdManager));
                    listOfBrand = new List<SelectOption>();
                    pageRef.setRedirect(false);
                    return pageRef;
                    
        }catch(Exception e){
            system.debug(e.getMessage());
        }       
            return null;
        } 
    
    /*******************************************************************    
   Purpose:  This method is used to allocate job to RAP                                         
   Parameters: 
   Returns: It’s return Nothing
   ********************************************************************/ 
    public static void insertJobAllocationData(String jobId, String userId, String emailIdToAllocate){
        try{
            Amr_Job_Allocation__c jobAlloc = new Amr_Job_Allocation__c();
            jobAlloc.AM_Job_Detail__c = jobId;
            jobAlloc.Is_Primary__c = TRUE ; 
            jobAlloc.User__c = userId;
            jobAlloc.Job_Allocated__c = 'Yes';
            insert jobAlloc;
            System.debug('PASSESD Email LEO ->  ' +  emailIdToAllocate);
            
            Amr_Job_Details__c jobDetails = new Amr_Job_Details__c(Id= jobId , ownerId = userId, JobAllocated_Email__c = emailIdToAllocate);
            update jobDetails; 
            System.debug('jobDetails ->  ' +  jobDetails);
        }catch(Exception e){
            system.debug(e.getMessage());
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
            system.debug(jobDetailsNew.Cluster+'----'+jobDetailsNew.Country+'-----'+jobDetailsNew.JobId);
            //Autometic assigment
            
            if(jobDetailsNew.Cluster!=null && jobDetailsNew.Country!=null){
                system.debug(jobDetailsNew.Cluster+'======>'+jobDetailsNew.Country);
                List<Amr_Country_Cluster__c> countryClusterLst = Amr_Country_Cluster__c.getAll().values(); 
                List<String> emailIds = new List<String>();
                system.debug(jobDetailsNew.Cluster +'======country===='+jobDetailsNew.Country);
                for(Amr_Country_Cluster__c obj:countryClusterLst){
                    if(obj.Cluster__c == jobDetailsNew.Cluster && obj.Country__c ==  jobDetailsNew.Country){
                        system.debug('inside===>'+obj.Primary_RAP_Email__c);
                        emailIds.add(obj.Primary_RAP_Email__c); 
                }
            }
            
            List<PermissionSetAssignment> userList =  [SELECT Id,Assignee.Name,Assignee.id,Assignee.Email FROM PermissionSetAssignment where PermissionSet.Name ='RAP' AND Assignee.Email = :emailIds ];
            if(userList.size()>0){
                Amr_Job_Details__Share jobShareObj  = new Amr_Job_Details__Share();
                jobShareObj.ParentId = jobDetailsNew.JobId;
                jobShareObj.UserOrGroupId = userList[0].Assignee.id;               
                jobShareObj.AccessLevel = 'Edit';
                insert jobShareObj;
                System.debug('PASSESD ->  ' + userList[0].Assignee.Email + ' ORIGINAL  -> ' + emailIds );
                insertJobAllocationData(jobDetailsNew.JobId,userList[0].Assignee.id, userList[0].Assignee.Email);
           }
        }
        }catch(Exception e){
            system.debug(e.getMessage());
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
   
    public double amountEntered{get;set;}
    public String ToUserEmailId{get;set;}
    public String gbvmEmail  {get;set;}
    public Double thresholdValue  {get;set;}
    
    /*******************************************************************    
   Purpose:  This method is used to trigger Email when amount given is greater than Thresold                                      
   Parameters: 
   Returns: It’s return Nothing
   ********************************************************************/ 
    // For Thresold Reach
    public void compareThresold(Amr_Job_Details__c jobDetailObj, String Categorty ,String BrandPostion , String Brand ){
        try{
        amountEntered = jobDetailObj.Allocated_Budget_euro__c;
        system.debug(Brand +'==='+Categorty+'===='+BrandPostion+'===='+amountEntered);
        List<Amr_JobBudgetThreshold__c> jobBudgetThresoldList = [select id,BrandPosition__r.name,Brand__r.name, Brand__r.Id, ProductCategory__r.Id,BrandPosition__r.Id,
                                                                 BrandCategoryPosition__c,Budget_Limit__c,ProductCategory__r.name,
                                                                 UserEmailId__c from Amr_JobBudgetThreshold__c where BrandPosition__r.name = :BrandPostion  and ProductCategory__r.name =:Categorty  ];
                                                          
        String brandCategoryPosition = BrandPostion+Brand+Categorty;
        system.debug('=======>'+brandCategoryPosition);                                                      
        for(Amr_JobBudgetThreshold__c jobBudgetThresoldObj:jobBudgetThresoldList){
            system.debug('=======>'+jobBudgetThresoldObj.BrandCategoryPosition__c);  
            String thresholdCompareId = jobBudgetThresoldObj.BrandPosition__r.name +''+ jobBudgetThresoldObj.Brand__r.name + jobBudgetThresoldObj.ProductCategory__r.name ;
            System.debug('Thre ->' + thresholdCompareId);
            
            if(thresholdCompareId == brandCategoryPosition){ 
                System.debug('Threshold -> ' + jobBudgetThresoldObj.Budget_Limit__c + 'Entered Ampunt -> ' + amountEntered);
                if(jobBudgetThresoldObj.Budget_Limit__c < amountEntered){
                    ToUserEmailId = jobBudgetThresoldObj.UserEmailId__c;
                    system.debug('to email Addresss====>'+ToUserEmailId);
                    ToUserEmailId = String.valueOf(ToUserEmailId);
                    gbvmEmail  = ToUserEmailId;
                    thresholdValue  = jobBudgetThresoldObj.Budget_Limit__c;
                    System.debug('HELLO ->' + jobDetails.GBVM_Email__c);
                }
            }
        }
        }catch(exception ex){
            system.debug('ex****'+ex.getMessage());
        }
   }


    /*******************************************************************    
   Purpose:  This method is used to create Ad Manager Number Denpending on Brand Name Value                                       
   Parameters: 
   Returns: It’s return Nothing
   ********************************************************************/ 

    public void adManagerNumberCreation(){
        try{
            Amr_Job_Details__c[] jobDetailList=[select Id,AdManagerText__c from Amr_Job_Details__c order by CreatedDate desc limit 1];
            system.debug('job details!!'+jobDetailList);
            Id id = jobDetails.Brand_Final__c ;
            system.debug('id!!'+id+'lookup!!!'+jobDetails.Brand_Final__c);
            MDO_Brand__c jobBrand = [select Name from MDO_Brand__c  where Id =: id];
            String brandStr = jobBrand.Name;
            String brandName = brandStr.Left(3);
            
            if(jobDetailList.size()>0){
                String textStr = jobDetailList[0].AdManagerText__c;
                String adNumber = textStr.Right(5);
                if(adNumber =='99999'){
                    jobDetails.AdManagerText__c = brandName+'/'+'00001';
                }else{
                    Integer num = integer.valueOf(adNumber)+1;
                    String numStr =string.valueof(num);
                    for(;numStr.length()<5;){
                        numstr='0'+numStr;
                        system.debug('num string!!'+numStr); 
                    }
                    jobDetails.AdManagerText__c =brandName+'/'+numstr;}
            }else{
                jobDetails.AdManagerText__c =brandName+'/'+'00001';
            }
            system.debug('job details!!'+jobDetails);
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }
    
    
    /*******************************************************************    
   Purpose:  This method is used to redirect to page denpending on who has logged in RAP OR CAP                                 
   Parameters: 
   Returns: It’s return Nothing
   ********************************************************************/ 


    public PageReference Redirect(){
        try{
            String sessionIdVal = userinfo.getSessionId();
            UserLoginId = userinfo.getuserid();  
            User userObj = [select id,SessionId__c from User where id = :UserLoginId];
            PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id,PermissionSet.Name from PermissionSetAssignment where (PermissionSet.Name = :Label.Amr_CAP OR PermissionSet.Name = 'RAP' OR PermissionSet.Name = 'AdManager') order by Assignee.name];
            system.debug('------>PermissionSetAssignmentList=='+PermissionSetAssignmentList );
            PageReference pageRef =null;
            flag = false;
            display = false;
            displayRap = false;
            system.debug(userObj.SessionId__c +'======'+sessionIdVal);
            
            for(PermissionSetAssignment permissionObject:PermissionSetAssignmentList ){
                system.debug('=======>'+permissionObject.PermissionSet.Name);
                
                if(permissionObject.PermissionSet.Name == Label.Amr_CAP && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                    system.debug('inside cap==>');
        
                    pageRef = Page.Amr_CAPJobPortfolio;
                    pageRef.setRedirect(true);
                    userObj.SessionId__c = sessionIdVal;
                
                                } 
                if(permissionObject.PermissionSet.Name == 'RAP' && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                    system.debug('inside RAP==>');
    
                    pageRef = Page.Amr_RAPJobPortfolio;
                    pageRef.setRedirect(true);
                    userObj.SessionId__c = sessionIdVal;
                }
            }
            update userObj;
            if(pageRef != null){
                return pageRef;
            }
   
            PageReference pageRef1 = Page.Amr_AdManager;
            pageRef1.setRedirect(true);
            return null;
        }catch(Exception e){
            system.debug(e.getMessage());
            return null;
        }
    }
    
    public void prodActivity(){
       
       
        System.debug('PRod -> ' + productionActivityData);
        
    }
    
}