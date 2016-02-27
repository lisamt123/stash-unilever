public with sharing class Amr_AdManagerController{

    public Amr_Job_Details__c jobDetails{get;set;}
    public static final String STR_NONE = '--None--';
    public static final String STR_CHECK = 'Check -> ';
    public Amr_Logging_Form_Setting__c r  {get; set;}
    //public List<Amr_CurrencyConversionRate__c> currencyConversion {get;set;}
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

    // public String projectName{get;set;}
    public String categoryName{get;set;}
    public String brandPosName{get;set;}
    public String brandNameFromPage{get;set;} 
    public List<SelectOption> listOfCategory{get;set;} 
    public List<SelectOption> listOfBrandPosition{get;set;}
    public List<SelectOption> listOfBrand{get;set;}
    // public  List<SelectOption> listOfProjectName {get;set;}
    public List<Amr_Project_Details__c> projNameList {get;set;}
    public  String[]  listString{get;set;}
    public  String[]  categoryString{get;set;}
    public String UserLoginId{get;set;}
    public List<PermissionSetAssignment> PermissionSetAssignmentList{get;set;}
    public boolean flag{get;set;}
    public boolean display{get;set;}
    public boolean displayRap{get;set;}


    public Amr_AdManagerController(){
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
        
        //  getProjectNameList();
    	}catch(Exception e){
    	system.debug(e.getMessage());
    	}
    }

    public void updateSetting(){
        update r;       
    }


    /*public List<SelectOption> getCategoryList(){      
         listOfCategory = new List<SelectOption>();

         listOfCategory.add(new selectOption(STR_NONE,STR_NONE));
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();

         Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();

         for(MDO_Category__c cat: categorylst){
             listOfCategory.add(new selectOption(cat.name,cat.name));
             system.debug('inside Category==>'+cat);
         }
         return listOfCategory;
     }*/

    public String getCategoryList(){ 
        System.debug('cATE ->' +  JSON.serialize(categoryString));
        return JSON.serialize(categoryString);
    }

    public String getMethodToPassProjectNames(){
        system.debug('serialize!!'+JSON.serialize(listString));
        return JSON.serialize(listString);
    }

    /*   public List<SelectOption> getBrandPositioningList(){    
         System.debug('BBBBBBRANDDD ->'+ categoryName);  
         Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
         Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(categoryName);

         listOfBrandPosition = new List<SelectOption>();
         listOfBrandPosition.add(new selectOption(STR_NONE,STR_NONE));
         for(MDO_BrandPositions__c bps : brandPositionlst){
             listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));
         }

        system.debug('brandPositionListt----->'+listOfBrandPosition);
        return listOfBrandPosition;

     } */


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

    public List<SelectOption> getBrandList(){  
    	try{    
        listOfBrand = new List<SelectOption>();
        system.debug('========>'+brandPosName+'category name=====>'+categoryName);
        listOfBrand.add(new selectOption(STR_NONE,STR_NONE));
        //Set<String> brandlst = new Set<String>();
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



    public Pagereference getSubmitForm(){
        try{
        Boolean okayToSave = true;
        system.debug('hii!!'+categoryName+'!!'+brandPosName+'!!'+brandNameFromPage);
        system.debug('job detail checkboxes=======>'+jobDetails.Project_Details__c  );
        system.debug('projectNameFromPage=======>'+projectNameFromPage);
        system.debug('selectedCountry=======>'+selectedCountry);
        system.debug('CC!'+productionActivityData);
        jobDetails.ProductionActivityTextArea__c = productionActivityData;
        system.debug('jobDetails.Check_With_CMI__c!!'+jobDetails.Check_With_CMI__c);
        System.debug(STR_CHECK + jobDetails.NewOriginalMaster__c + STR_CHECK + jobDetails.NewOriginalMasterOutofHome__c + STR_CHECK + jobDetails.NewOriginalMasterOutofHomeMovingImage__c + STR_CHECK +
        jobDetails.NewOriginalMasterOutofHomeAudio__c + STR_CHECK + jobDetails.NewOriginalMasterOutofHomeStillImage__c );
       
        if(jobDetails.Check_With_CMI__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Have you checked with CMI if there is an existing asset in the Millward Brown TV Ad Vitality Bank that could be utilised for this JTBD? : a radio button must be selected'));
            okayToSave =false;

        }
        if(jobDetails.Your_Email_Address__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Your email address : must follow the standard format of an email address, e.g. txt@txt.com'));
            okayToSave =false;
        } 
        if(jobDetails.Unilever_Finance_Member_Email__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unilever finance member email : must follow the standard format of an email address, e.g. txt@txt.com'));
            okayToSave =false;
        }
        if(jobDetails.Final_Approver_Of_Material_Email__c== null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Final approver of material email : must follow the standard format of an email address, e.g. txt@txt.com'));
            okayToSave =false;
        }
        if((String.isBlank(selectedCountry)|| selectedCountry == STR_NONE)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget allocated for this activity (enter all digits) : option must be selected from drop down'));
            okayToSave =false;
        }
        if(jobDetails.Budget_Allocated_Input_Value__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget allocated for this activity (enter all digits) : number must be entered'));
            okayToSave =false;
        }
        if(categoryName == STR_NONE){
            system.debug('inside category'+categoryName);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
            okayToSave =false;
        }
        if(brandPosName == STR_NONE){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
            okayToSave =false;
        }
        if(brandNameFromPage == STR_NONE){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
            okayToSave =false;
        }
        if(jobDetails.Agency_Contact_Account_Director_Email__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Agency contact or account director email : must follow the standard format of an email address, e.g. txt@txt.com'));
            okayToSave =false;
        }
        if(jobDetails.Project_Description__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project description : text must be entered'));
            okayToSave =false;
        }
        if(jobDetails.Campaign_Name__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Campaign name : text must be entered'));
            okayToSave =false;
        }
        if(jobDetails.Target_Air_Date__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Target air date : a date must be selected from the calendar'));
            okayToSave =false;
        }
         if(jobDetails.Project_Leader_Cluster__c == null || jobDetails.Project_Leader_Country__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Location of Unilever project leader : option must be selected from both market cluster and country drop downs'));
            okayToSave =false;
        }
        if(jobDetails.Function_You_Are_Part__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Which function are you part of (BD/BB/Other) : option must be selected from drop down'));
            okayToSave =false;
        }
        if(jobDetails.Budget_Responsibility__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget responsibility (BD, BB, Other) : option must be selected from drop down'));
            okayToSave =false;
        }
        if(jobDetails.Lead_Creative_Agency_name__c == null && jobDetails.Lead_Agency_Name_Other__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lead agency name : option must be selected from the drop down menu OR a name must be entered in the "Other" text box'));
            okayToSave =false;
        }
        if(jobDetails.Lead_Agency_Location_Cluster__c == null || jobDetails.Lead_Agency_Location_Country__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Lead agency location : option must be selected from both market cluster and country drop downs'));
            okayToSave =false;
        }
        if(String.isBlank(jobDetails.Project_Details__c) && String.isBlank(jobDetails.Project_Name_Other__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project name (e.g. Apollo) : option must be selected from the drop down menu OR a name must be entered in the "Other" text box'));
            okayToSave =false;
        }
        if(jobDetails.Project_Location_Cluster__c == null || jobDetails.Project_Location_Country__c==null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project location : option must be selected from both market cluster and country drop downs'));
            okayToSave =false;
        }
        if(jobDetails.Production_Activity_Type__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'What type of activity will this production support? : one option must be selected from the drop down menu'));
            okayToSave =false;
        }
        // system.debug('jobDetails.Project_Description__c!!'+jobDetails.Project_Description__c+'jobDetails.Execution_Name__c!!'+jobDetails.Execution_Name__c);  

        if(String.isBlank(jobDetails.Project_Description__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Project description : text must be entered'));
            okayToSave =false;
        }
        if(String.isBlank(jobDetails.Execution_Name__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Execution name : text must be entered'));
            okayToSave =false;
        }
        if(String.isBlank(jobDetails.Brodcast_Market__c)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Broadcast market : one option must be selected from the drop down menu'));
            okayToSave =false;
        }
        if(jobDetails.Require_Music__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Do you anticipate that your production will require Music? : a radio button must be selected'));
            okayToSave =false;
        }
        if(jobDetails.Require_Celebrity_Talent__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Do you anticipate that your production will require Celebrity Talent? : a radio button must be selected'));
            okayToSave =false;
        }
        if(jobDetails.Stage_of_Production_Activity__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Current stage of your production activity : option must be selected from drop down'));
            okayToSave =false;
        }
        if(!jobDetails.NewOriginalMaster__c && !jobDetails.LanguageAdaptionMaster__c  && !jobDetails.Create_Additional_Material__c && !jobDetails.ReworkExistingMaterial__c && !jobDetails.BuyoutsTalent__c && !jobDetails.BuyoutsMusic__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Production activity types : at least one option must be selected'));
            okayToSave =false;
        }
        if(jobDetails.NewOriginalMaster__c && !jobDetails.NewOriginalMasterCinema__c && !jobDetails.NewOriginalMasterTv__c && !jobDetails.NewOriginalMasterRadio__c && !jobDetails.NewOriginalMasterPrint__c && !jobDetails.NewOriginalMasterOutofHome__c &&
                !jobDetails.NewOriginalMasterInStore__c && !jobDetails.NewOriginalMasterDigital__c && !jobDetails.NewOriginalMasterInternalVideo__c ){                
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
         //utkarsh
        if(!jobDetails.NewOriginalMaster__c  && jobDetails.NewOriginalMasterOutofHome__c && !jobDetails.NewOriginalMasterOutofHomeMovingImage__c && 
            !jobDetails.NewOriginalMasterOutofHomeAudio__c && !jobDetails.NewOriginalMasterOutofHomeStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false; 
        }
        if(jobDetails.NewOriginalMaster__c && jobDetails.NewOriginalMasterInStore__c && !jobDetails.NewOriginalMasterInStoreMovingImage__c && 
            !jobDetails.NewOriginalMasterInStoreAudio__c && !jobDetails.NewOriginalMasterInStoreStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        if(jobDetails.NewOriginalMaster__c && !jobDetails.NewOriginalMasterCinema__c && !jobDetails.NewOriginalMasterTv__c && 
            !jobDetails.NewOriginalMasterRadio__c && !jobDetails.NewOriginalMasterPrint__c && !jobDetails.NewOriginalMasterOutofHome__c &&
                !jobDetails.NewOriginalMasterInStore__c && !jobDetails.NewOriginalMasterDigital__c && !jobDetails.NewOriginalMasterInternalVideo__c ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        if(jobDetails.NewOriginalMaster__c && jobDetails.NewOriginalMasterOutofHome__c && !jobDetails.NewOriginalMasterOutofHomeMovingImage__c && 
            !jobDetails.NewOriginalMasterOutofHomeAudio__c && !jobDetails.NewOriginalMasterOutofHomeStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        if(jobDetails.NewOriginalMaster__c && jobDetails.NewOriginalMasterInStore__c && !jobDetails.NewOriginalMasterInStoreMovingImage__c && 
            !jobDetails.NewOriginalMasterInStoreAudio__c && !jobDetails.NewOriginalMasterInStoreStillImage__c  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        if(jobDetails.NewOriginalMaster__c && jobDetails.NewOriginalMasterDigital__c && !jobDetails.NewOriginalMasterDigitalMovingImage__c && 
            !jobDetails.NewOriginalMasterDigitalAudio__c && !jobDetails.NewOriginalMasterDigitalStillImage__c  
            && !jobDetails.New_Original_Master_Digital_ED__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        if(!jobDetails.NewOriginalMaster__c && jobDetails.LanguageAdaptionMaster__c && !jobDetails.LanguageAdaptionMasterTv__c && 
            !jobDetails.LanguageAdaptionMasterCinema__c && !jobDetails.LanguageAdaptionMasterRadio__c && !jobDetails.LanguageAdaptionMasterPrint__c && 
               !jobDetails.LanguageAdaptionMasterOutofHome__c && !jobDetails.LanguageAdaptionMasterInStore__c && !jobDetails.LanguageAdaptionMasterDigital__c &&
                !jobDetails.LanguageAdaptionMasterInternalVideo__c){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected'));
            okayToSave =false;
        }
        if(!jobDetails.NewOriginalMaster__c && jobDetails.LanguageAdaptionMaster__c && jobDetails.LanguageAdaptionMasterOutofHome__c && 
            !jobDetails.LanguageAdaptionMasterOutofHomeAudio__c && 
            !jobDetails.LanguageAdaptionMasterOutHomeStillImage__c && 
            !jobDetails.LanguageAdaptionMasterOutHomeMovingImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        if(!jobDetails.NewOriginalMaster__c && jobDetails.LanguageAdaptionMaster__c && jobDetails.LanguageAdaptionMasterInStore__c && 
            !jobDetails.LanguageAdaptionMasterInStoreAudio__c && 
            !jobDetails.LanguageAdaptionMasterInStoreMovingImage__c && 
            !jobDetails.LanguageAdaptionMasterInStoreStillImage__c 
            
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        if(!jobDetails.NewOriginalMaster__c && jobDetails.LanguageAdaptionMaster__c && jobDetails.LanguageAdaptionMasterDigital__c && 
            !jobDetails.LanguageAdaptionMasterDigitalAudio__c && 
            !jobDetails.LanguageAdaptionMasterDigitalMovingImage__c && 
            !jobDetails.LanguageAdaptionMasterDigitalStillImage__c && !jobDetails.Language_Adaptation_of_Master_Digital_ED__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
        if(!jobDetails.NewOriginalMaster__c && jobDetails.Create_Additional_Material__c && jobDetails.AdditionalSupplementaryNewMaterialOOH__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialOofHMI__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialOofHSI__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialOofHA__c  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
            if(!jobDetails.NewOriginalMaster__c && jobDetails.Create_Additional_Material__c && jobDetails.AdditionalSupplementaryNewMaterialStore__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialInSMI__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialInSA__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialInSSI__c  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.Create_Additional_Material__c && jobDetails.AdditionalSupplementaryNewMaterialDigi__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialDigiMI__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialDigiA__c && 
            !jobDetails.AdditionalSupplementaryNewMaterialDigiSI__c  &&
            !jobDetails.Digital_Editorial__c  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to Digital'));
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
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.ReworkExistingMaterial__c && jobDetails.ReworkExistingMaterialOutofHome__c && 
            !jobDetails.ReworkExistingMaterialOutHomeMovingImage__c && 
            !jobDetails.ReworkExistingMaterialOutofHomeAudio__c && 
            !jobDetails.ReworkExistingMaterialOutHomeStillImage__c 
            
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.ReworkExistingMaterial__c && jobDetails.ReworkExistingMaterialInStore__c && 
            !jobDetails.ReworkExistingMaterialInStoreMovingImage__c && 
            !jobDetails.ReworkExistingMaterialInStoreAudio__c && 
            !jobDetails.In_Store_Still_Image__c  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.ReworkExistingMaterial__c && jobDetails.ReworkExistingMaterialDigital__c && 
            !jobDetails.ReworkExistingMaterialDigitalMovingImage__c && 
            !jobDetails.ReworkExistingMaterialDigitalAudio__c && 
            !jobDetails.ReworkExistingMaterialDigitalStillImage__c  &&
            !jobDetails.Rework_Exisiting_Material_Digital_ED__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
        if(!jobDetails.NewOriginalMaster__c && jobDetails.ReworkExistingMaterial__c && !jobDetails.ReworkExistingMaterialOutofHome__c && 
            !jobDetails.ReworkExistingMaterialInStore__c && 
            !jobDetails.ReworkExistingMaterialDigital__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsTalent__c && jobDetails.BuyoutsTalentOutofHome__c && 
            !jobDetails.BuyoutsTalentOutofHomeMovingImage__c && 
            !jobDetails.BuyoutsTalentOutofHomeAudio__c && 
            !jobDetails.BuyoutsTalentOutofHomeStillImage__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsTalent__c && jobDetails.BuyoutsTalentInStore__c && 
            !jobDetails.BuyoutsTalentInStoreMovingImage__c && 
            !jobDetails.BuyoutsTalentInStoreAudio__c && 
            !jobDetails.BuyoutsTalentInStoreStillImage__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to In Store' ));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsTalent__c && jobDetails.BuyoutsTalentDigital__c && 
            !jobDetails.BuyoutsTalentDigitalMovingImage__c && 
            !jobDetails.BuyoutsTalentDigitalAudio__c && 
            !jobDetails.BuyoutsTalentDigitalStillImage__c  &&
            !jobDetails.Buyouts_Talent_Digital_ED__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
          if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsTalent__c && !jobDetails.BuyoutsTalentOutofHome__c && 
            !jobDetails.BuyoutsTalentInStore__c && 
            !jobDetails.BuyoutsTalentDigital__c
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsMusic__c && jobDetails.BuyoutsMusicOutofHome__c && 
            !jobDetails.BuyoutsMusicOutofHomeMovingImage__c && 
            !jobDetails.BuyoutsMusicOutofHomeAudio__c && 
            !jobDetails.BuyoutsMusicOutofHomeStillImage__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to Out of Home'));
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
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsMusic__c && jobDetails.BuyoutsMusicInStore__c && 
            !jobDetails.BuyoutsMusicInStoreMovingImage__c && 
            !jobDetails.BuyoutsMusicInStoreAudio__c && 
            !jobDetails.BuyoutsMusicInStoreStillImage__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
            if(!jobDetails.NewOriginalMaster__c && jobDetails.BuyoutsMusic__c && jobDetails.BuyoutsMusicDigital__c && 
            !jobDetails.BuyoutsMusicDigitalMovingImage__c && 
            !jobDetails.BuyoutsMusicDigitalAudio__c && 
            !jobDetails.BuyoutsMusicDigitalStillImage__c  &&
            !jobDetails.Buyouts_Music_Digital_ED__c 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        if( !okayToSave ) {
            return null;
        }
    
     		 createJob();
     	}catch(Exception e){
    	system.debug(e.getMessage());
    	}
			 return null;

    }
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
        system.debug('job detail checkboxes=======>'+jobDetails);
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
        PageReference pageRef = new PageReference('/apex/Amr_AdManager');
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Thank you for submitting the job successfully, shortly you will receive the email confirmation'));
        listOfBrand = new List<SelectOption>();
        pageRef.setRedirect(false);
        return pageRef;
		}catch(Exception e){
    	system.debug(e.getMessage());
    	}	
	return null;
	} 

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
                /*if(jobShareObj.id !=null){
                        system.debug('inside job share---');
                        sendNotificationToRap(jobDetailsNew.AdManagerText,jobDetailsNew.JobId,emailIds[0]);
                 }*/
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



    public PageReference Redirect(){
    	try{
        String sessionIdVal = userinfo.getSessionId();
        UserLoginId = userinfo.getuserid();  
        User userObj = [select id,SessionId__c from User where id = :UserLoginId];
        // PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_CAP order by Assignee.name];
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
                pageRef = new PageReference('/apex/Amr_CAPJobPortfolio');
                pageRef.setRedirect(true);
                userObj.SessionId__c = sessionIdVal;
                // update userObj;
				} 
            if(permissionObject.PermissionSet.Name == 'RAP' && permissionObject.Assignee.id == UserLoginId && (userObj.SessionId__c == null || userObj.SessionId__c != sessionIdVal)){
                system.debug('inside RAP==>');
                pageRef = new PageReference('/apex/Amr_RAPJobPortfolio');
                pageRef.setRedirect(true);
                userObj.SessionId__c = sessionIdVal;
            }
        }
        update userObj;
        if(pageRef != null){
            return pageRef;
        }
        PageReference pageRef1 = new PageReference('/apex/Amr_AdManager');
        pageRef1.setRedirect(true);
        return null;
        }catch(Exception e){
    	system.debug(e.getMessage());
    	return null;
    	}
    }

}