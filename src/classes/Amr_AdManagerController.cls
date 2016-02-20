public with sharing class Amr_AdManagerController{

    public Amr_Job_Details__c jobDetails{get;set;}
    public Amr_Logging_Form_Setting__c r  {get; set;}
    //public List<Amr_CurrencyConversionRate__c> currencyConversion {get;set;}
    public String selectedCountry {get;set;}
    public String projectNameFromPage{get;set;}
    public String productionActivityData {get;set;}
    public List<selectOption> currencyRecords {
        get {
            List<selectOption> options = new List<selectOption>();
            options.add(new SelectOption('--None--','--None--'));
            List<Amr_CurrencyConversionRate__c> lstcov = Amr_CurrencyConversionRate__c.getAll().values();
            System.debug('Currency List Size --> ' + lstcov.size());
            //lstcov.sort();
            for (Amr_CurrencyConversionRate__c cc: lstcov)
                options.add(new SelectOption(String.valueOf(cc.Currency_Unit_To_Euro__c),cc.Name+'-'+cc.Currency_Unit__c));
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
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        jobDetails = new Amr_Job_Details__c();
        r = [SELECT Introduction__c, Header__c, Footer__c, Allocation__c, Automatic_Allocation_On__c FROM Amr_Logging_Form_Setting__c LIMIT 1];
        projNameList= [Select Name from Amr_Project_Details__c ORDER BY Name ASC limit 10000];

        listString = new list<string>();
        categoryString = new list<string>();
        listString.add('--None--');
        for(Amr_Project_Details__c i : projNameList){
            listString.add(i.name);
        }
        Set<MDO_Category__c> categorylst = utiltyObj.categoryValues();
        for(MDO_Category__c mdCat : categorylst){
            categoryString.add(mdCat.name);
        }

        listOfBrandPosition = new List<SelectOption>();
        listOfBrandPosition.add(new selectOption('--None--','--None--'));
        system.debug('mdString !!'+categoryString);
        system.debug('listString!!'+listString);
        System.debug('Project Name Size -> ' + projNameList.size());
        
        //  getProjectNameList();

    }

    public void updateSetting(){
        update r;       
    }


    /*public List<SelectOption> getCategoryList(){      
         listOfCategory = new List<SelectOption>();

         listOfCategory.add(new selectOption('--None--','--None--'));
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
         listOfBrandPosition.add(new selectOption('--None--','--None--'));
         for(MDO_BrandPositions__c bps : brandPositionlst){
             listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));
         }

        system.debug('brandPositionListt----->'+listOfBrandPosition);
        return listOfBrandPosition;

     } */


    public PageReference  brandPositionListData(){    
        System.debug('BBBBBBRANDDD ->'+ categoryName);  
        Amr_UtilityClass utiltyObj = new Amr_UtilityClass();
        Set<MDO_BrandPositions__c> brandPositionlst = utiltyObj.brandPostitionValues(categoryName);

        system.debug('brandPositionListttoo----->'+brandPositionlst );

   //     listOfBrandPosition = new List<SelectOption>();
     //   listOfBrandPosition.add(new selectOption('--None--','--None--'));
        Set<String> brnadPosNameSet = new Set<String>();
        for(MDO_BrandPositions__c bps : brandPositionlst){

            if(!brnadPosNameSet.contains(bps.brand_position_id__r.name)){
                listOfBrandPosition.add(new selectOption(bps.brand_position_id__r.name,bps.brand_position_id__r.name));

                brnadPosNameSet.add(bps.brand_position_id__r.name);
            }
        }

        system.debug('brandPositionListtt----->'+listOfBrandPosition);
        return null;

    }

    public List<SelectOption> getBrandList(){      
        listOfBrand = new List<SelectOption>();
        system.debug('========>'+brandPosName+'category name=====>'+categoryName);

        listOfBrand.add(new selectOption('--None--','--None--'));

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
    }



    public Pagereference getSubmitForm(){

        Boolean okayToSave = true;

        system.debug('hii!!'+categoryName+'!!'+brandPosName+'!!'+brandNameFromPage);
        system.debug('job detail checkboxes=======>'+jobDetails.Project_Details__c  );
        system.debug('projectNameFromPage=======>'+projectNameFromPage);
        system.debug('selectedCountry=======>'+selectedCountry);
        system.debug('productionActivityData!!'+productionActivityData);
        //----   
        system.debug('jobDetails.Check_With_CMI__c!!'+jobDetails.Check_With_CMI__c);
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
        if((String.isBlank(selectedCountry)|| selectedCountry == '--None--')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget allocated for this activity (enter all digits) : option must be selected from drop down'));
            okayToSave =false;
        }

        if(jobDetails.Budget_Allocated_Input_Value__c == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Budget allocated for this activity (enter all digits) : number must be entered'));
            okayToSave =false;
        }

        if(categoryName == '--None--'){
            system.debug('inside category'+categoryName);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
            okayToSave =false;
        }
        if(brandPosName == '--None--'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Category > Brand Positioning > Brand : option must be selected from all drop downs - Category, Brand Position & Brand Name'));
            okayToSave =false;
        }
        if(brandNameFromPage == '--None--'){
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
        //----     


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

        if(jobDetails.NewOriginalMaster__c == false && jobDetails.LanguageAdaptionMaster__c == false && jobDetails.Create_Additional_Material__c==false && jobDetails.ReworkExistingMaterial__c==false && jobDetails.BuyoutsTalent__c==false && jobDetails.BuyoutsMusic__c==false ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Production activity types : at least one option must be selected'));
            okayToSave =false;
        }
        
        if(jobDetails.NewOriginalMaster__c == true && jobDetails.NewOriginalMasterCinema__c == false && jobDetails.NewOriginalMasterTv__c==false && 
            jobDetails.NewOriginalMasterRadio__c==false && jobDetails.NewOriginalMasterPrint__c==false && jobDetails.NewOriginalMasterOutofHome__c==false &&
                jobDetails.NewOriginalMasterInStore__c==false && jobDetails.NewOriginalMasterDigital__c==false && jobDetails.NewOriginalMasterInternalVideo__c==false ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
       
        
         if(jobDetails.NewOriginalMaster__c == true && jobDetails.NewOriginalMasterOutofHome__c == true && jobDetails.NewOriginalMasterOutofHomeMovingImage__c==false && 
            jobDetails.NewOriginalMasterOutofHomeAudio__c==false && jobDetails.NewOriginalMasterOutofHomeStillImage__c==false  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false; 
        }
        
        
        if(jobDetails.NewOriginalMaster__c == true && jobDetails.NewOriginalMasterInStore__c == true && jobDetails.NewOriginalMasterInStoreMovingImage__c==false && 
            jobDetails.NewOriginalMasterInStoreAudio__c==false && jobDetails.NewOriginalMasterInStoreStillImage__c==false  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
           
        if(jobDetails.NewOriginalMaster__c == true && jobDetails.NewOriginalMasterCinema__c == false && jobDetails.NewOriginalMasterTv__c==false && 
            jobDetails.NewOriginalMasterRadio__c==false && jobDetails.NewOriginalMasterPrint__c==false && jobDetails.NewOriginalMasterOutofHome__c==false &&
                jobDetails.NewOriginalMasterInStore__c==false && jobDetails.NewOriginalMasterDigital__c==false && jobDetails.NewOriginalMasterInternalVideo__c==false ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
      
         if(jobDetails.NewOriginalMaster__c == true && jobDetails.NewOriginalMasterOutofHome__c == true && jobDetails.NewOriginalMasterOutofHomeMovingImage__c==false && 
            jobDetails.NewOriginalMasterOutofHomeAudio__c==false && jobDetails.NewOriginalMasterOutofHomeStillImage__c==false  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
        
        if(jobDetails.NewOriginalMaster__c == true && jobDetails.NewOriginalMasterInStore__c == true && jobDetails.NewOriginalMasterInStoreMovingImage__c==false && 
            jobDetails.NewOriginalMasterInStoreAudio__c==false && jobDetails.NewOriginalMasterInStoreStillImage__c==false  ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
          if(jobDetails.NewOriginalMaster__c == true && jobDetails.NewOriginalMasterDigital__c == true && jobDetails.NewOriginalMasterDigitalMovingImage__c==false && 
            jobDetails.NewOriginalMasterDigitalAudio__c==false && jobDetails.NewOriginalMasterDigitalStillImage__c==false  
            && jobDetails.Digital_Editorial__c==false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For New Original Master :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
        if(jobDetails.NewOriginalMaster__c == false && jobDetails.LanguageAdaptionMaster__c == true && jobDetails.LanguageAdaptionMasterTv__c==false && 
            jobDetails.LanguageAdaptionMasterCinema__c==false && jobDetails.LanguageAdaptionMasterRadio__c==false  
            && jobDetails.LanguageAdaptionMasterPrint__c==false && 
                jobDetails.LanguageAdaptionMasterOutofHome__c==false && 
                jobDetails.LanguageAdaptionMasterInStore__c==false && 
                jobDetails.LanguageAdaptionMasterDigital__c==false &&
                jobDetails.LanguageAdaptionMasterInternalVideo__c ==false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected'));
            okayToSave =false;
        }
        /*
         if(jobDetails.NewOriginalMaster__c == false && jobDetails.LanguageAdaptionMaster__c == true && jobDetails.LanguageAdaptionMasterTv__c==false && 
            jobDetails.LanguageAdaptionMasterCinema__c==false && jobDetails.LanguageAdaptionMasterRadio__c==false  
            && jobDetails.LanguageAdaptionMasterPrint__c==false && 
                jobDetails.LanguageAdaptionMasterOutofHome__c==false && 
                jobDetails.LanguageAdaptionMasterInStore__c==false && 
                jobDetails.LanguageAdaptionMasterDigital__c==false &&
                jobDetails.LanguageAdaptionMasterInternalVideo__c ==false){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to Language Adaption Master'));
            okayToSave =false;
        }
        */
    
    
        
         if(jobDetails.NewOriginalMaster__c == false && jobDetails.LanguageAdaptionMaster__c == true && jobDetails.LanguageAdaptionMasterOutofHome__c==true && 
            jobDetails.LanguageAdaptionMasterOutofHomeAudio__c==false && 
            jobDetails.LanguageAdaptionMasterOutHomeStillImage__c==false && 
            jobDetails.LanguageAdaptionMasterOutHomeMovingImage__c==false 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
         if(jobDetails.NewOriginalMaster__c == false && jobDetails.LanguageAdaptionMaster__c == true && jobDetails.LanguageAdaptionMasterInStore__c==true && 
            jobDetails.LanguageAdaptionMasterInStoreAudio__c==false && 
            jobDetails.LanguageAdaptionMasterInStoreMovingImage__c==false && 
            jobDetails.LanguageAdaptionMasterInStoreStillImage__c==false  
            
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
        if(jobDetails.NewOriginalMaster__c == false && jobDetails.LanguageAdaptionMaster__c == true && jobDetails.LanguageAdaptionMasterDigital__c==true && 
            jobDetails.LanguageAdaptionMasterDigitalAudio__c==false && 
            jobDetails.LanguageAdaptionMasterDigitalMovingImage__c==false && 
            jobDetails.LanguageAdaptionMasterDigitalStillImage__c==false  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Language Adaption Master :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
        
        
        if(jobDetails.NewOriginalMaster__c == false && jobDetails.Create_Additional_Material__c == true && jobDetails.AdditionalSupplementaryNewMaterialOOH__c==true && 
            jobDetails.AdditionalSupplementaryNewMaterialOofHMI__c==false && 
            jobDetails.AdditionalSupplementaryNewMaterialOofHSI__c==false && 
            jobDetails.AdditionalSupplementaryNewMaterialOofHA__c==false  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.Create_Additional_Material__c == true && jobDetails.AdditionalSupplementaryNewMaterialStore__c==true && 
            jobDetails.AdditionalSupplementaryNewMaterialInSMI__c==false && 
            jobDetails.AdditionalSupplementaryNewMaterialInSA__c==false && 
            jobDetails.AdditionalSupplementaryNewMaterialInSSI__c==false  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.Create_Additional_Material__c == true && jobDetails.AdditionalSupplementaryNewMaterialDigi__c==true && 
            jobDetails.AdditionalSupplementaryNewMaterialDigiMI__c==false && 
            jobDetails.AdditionalSupplementaryNewMaterialDigiA__c==false && 
            jobDetails.AdditionalSupplementaryNewMaterialDigiSI__c==false  &&
            jobDetails.Digital_Editorial__c==false  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.Create_Additional_Material__c == true &&  
            jobDetails.AdditionalSupplementaryNewMaterialStore__c==false && 
            jobDetails.AdditionalSupplementaryNewMaterialDigi__c==false &&
            jobDetails.AdditionalSupplementaryNewMaterialTv__c == false &&
            jobDetails.AdditionalSupplementaryNewMaterialCinema__c == false &&
            jobDetails.AdditionalSupplementaryNewMaterialRadio__c == false &&
            jobDetails.AdditionalSupplementaryNewMaterialOOH__c == false &&
            jobDetails.AdditionalSupplementaryNewMaterialIVideo__c== false
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Additional Supplementary NewMaterial :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.ReworkExistingMaterial__c == true && jobDetails.ReworkExistingMaterialOutofHome__c==true && 
            jobDetails.ReworkExistingMaterialOutHomeMovingImage__c==false && 
            jobDetails.ReworkExistingMaterialOutofHomeAudio__c==false && 
            jobDetails.ReworkExistingMaterialOutHomeStillImage__c==false 
            
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.ReworkExistingMaterial__c == true && jobDetails.ReworkExistingMaterialInStore__c==true && 
            jobDetails.ReworkExistingMaterialInStoreMovingImage__c==false && 
            jobDetails.ReworkExistingMaterialInStoreAudio__c==false && 
            jobDetails.In_Store_Still_Image__c==false  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.ReworkExistingMaterial__c == true && jobDetails.ReworkExistingMaterialDigital__c==true && 
            jobDetails.ReworkExistingMaterialDigitalMovingImage__c==false && 
            jobDetails.ReworkExistingMaterialDigitalAudio__c==false && 
            jobDetails.ReworkExistingMaterialDigitalStillImage__c==false  &&
            jobDetails.Digital_Editorial__c==false  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
        if(jobDetails.NewOriginalMaster__c == false && jobDetails.ReworkExistingMaterial__c == true &&            jobDetails.ReworkExistingMaterialOutofHome__c==false && 
            jobDetails.ReworkExistingMaterialInStore__c==false && 
            jobDetails.ReworkExistingMaterialDigital__c==false 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Rework Existing Material :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.BuyoutsTalent__c == true && jobDetails.BuyoutsTalentOutofHome__c==true && 
            jobDetails.BuyoutsTalentOutofHomeMovingImage__c==false && 
            jobDetails.BuyoutsTalentOutofHomeAudio__c==false && 
            jobDetails.BuyoutsTalentOutofHomeStillImage__c==false 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.BuyoutsTalent__c == true && jobDetails.BuyoutsTalentInStore__c==true && 
            jobDetails.BuyoutsTalentInStoreMovingImage__c==false && 
            jobDetails.BuyoutsTalentInStoreAudio__c==false && 
            jobDetails.BuyoutsTalentInStoreStillImage__c==false 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to In Store' ));
            okayToSave =false;
        }
        
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.BuyoutsTalent__c == true && jobDetails.BuyoutsTalentDigital__c==true && 
            jobDetails.BuyoutsTalentDigitalMovingImage__c==false && 
            jobDetails.BuyoutsTalentDigitalAudio__c==false && 
            jobDetails.BuyoutsTalentDigitalStillImage__c==false  &&
            jobDetails.Digital_Editorial__c==false  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        
          if(jobDetails.NewOriginalMaster__c == false && jobDetails.BuyoutsTalent__c == true &&               jobDetails.BuyoutsTalentOutofHome__c==false && 
            jobDetails.BuyoutsTalentInStore__c==false && 
            jobDetails.BuyoutsTalentDigital__c==false 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Talent :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.BuyoutsMusic__c == true && jobDetails.BuyoutsMusicOutofHome__c==true && 
            jobDetails.BuyoutsMusicOutofHomeMovingImage__c==false && 
            jobDetails.BuyoutsMusicOutofHomeAudio__c==false && 
            jobDetails.BuyoutsMusicOutofHomeStillImage__c==false 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to Out of Home'));
            okayToSave =false;
        }
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.BuyoutsMusic__c == true && jobDetails.BuyoutsMusicInStore__c==false && 
            jobDetails.BuyoutsMusicDigital__c==false && 
            jobDetails.BuyoutsMusicTv__c == false &&
            jobDetails.BuyoutsMusicCinema__c == false &&
            jobDetails.BuyoutsMusicRadio__c == false &&
            jobDetails.BuyoutsMusicInternalVideo__c == false &&
            jobDetails.BuyoutsMusicOutofHome__c == false
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Media Channel must be selected'));
            okayToSave =false;
        }
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.BuyoutsMusic__c == true && jobDetails.BuyoutsMusicInStore__c==true && 
            jobDetails.BuyoutsMusicInStoreMovingImage__c==false && 
            jobDetails.BuyoutsMusicInStoreAudio__c==false && 
            jobDetails.BuyoutsMusicInStoreStillImage__c==false 
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to In Store'));
            okayToSave =false;
        }
        
        
        
            if(jobDetails.NewOriginalMaster__c == false && jobDetails.BuyoutsMusic__c == true && jobDetails.BuyoutsMusicDigital__c==true && 
            jobDetails.BuyoutsMusicDigitalMovingImage__c==false && 
            jobDetails.BuyoutsMusicDigitalAudio__c==false && 
            jobDetails.BuyoutsMusicDigitalStillImage__c==false  &&
            jobDetails.Digital_Editorial__c==false  
            ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'For Buyouts Music :  at least one option of Medium must be selected corresponding to Digital'));
            okayToSave =false;
        }
        

        //Common ERROR 
        


        
    
        
        
        
        

       

        if( !okayToSave ) {
            return null;
        }
    
        // system.debug('jprojectName=======>'+projectName  );

        /*if(projectName != null && projectName != '' && projectName != 'Select')
            jobDetails.Project_Details__c= projectName;*/


        
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
        selectedCountry ='--None--';
        categoryName ='--None--';
        brandPosName ='--None--';
        brandNameFromPage ='--None--';
        

        PageReference pageRef = new PageReference('/apex/Amr_AdManager');

        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Thank you for submitting the job successfully, shortly you will receive the email confirmation'));
        listOfBrand = new List<SelectOption>();
        pageRef.setRedirect(false);
        return pageRef;


    }


    public static void insertJobAllocationData(String jobId, String userId, String emailIdToAllocate){

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

    }


    @future
    @TestVisible static void automaticJobAllocation(String JobObject){
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

                // Amr_Job_Details__c objamrjobdetails = new Amr_Job_Details__c(Id=jobDetailsNew.JobId, ownerId = userList[0].Assignee.id );
                //update objamrjobdetails ;
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


    //public String Brand{get;set;}
    //public String Categorty{get;set;}
    //public String BrandPostion{get;set;}
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
                Integer i;
                for(i=0;numStr.length()<5;i++){
                    numstr='0'+numStr;
                    system.debug('num string!!'+numStr); 
                }

                jobDetails.AdManagerText__c =brandName+'/'+numstr;}
        }else{
            jobDetails.AdManagerText__c =brandName+'/'+'00001';
        }
        system.debug('job details!!'+jobDetails);


    }



    public PageReference Redirect(){
        String sessionIdVal = userinfo.getSessionId();
        UserLoginId = userinfo.getuserid();  
        User userObj = [select id,SessionId__c from User where id = :UserLoginId];
        // PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id from PermissionSetAssignment where PermissionSet.Name = :Label.Amr_CAP order by Assignee.name];
        PermissionSetAssignmentList = [select id,Assignee.Name,Assignee.id,PermissionSet.Name from PermissionSetAssignment where (PermissionSet.Name = :Label.Amr_CAP OR PermissionSet.Name = 'RAP' OR PermissionSet.Name = 'AdManager') order by Assignee.name];
        system.debug('------>PermissionSetAssignmentList=='+PermissionSetAssignmentList );
        PageReference pageRef ;
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

            /*if(permissionObject.PermissionSet.Name == 'AdManager' && permissionObject.Assignee.id == UserLoginId  && userObj.SessionId__c == null){
                   system.debug('inside AdManager==>');
                   PageReference pageRef = new PageReference('/apex/Amr_AdManager');
                   pageRef.setRedirect(true);
                   return null;

               }*/

        }
        update userObj;
        if(pageRef != null){
            return pageRef;
        }
        PageReference pageRef1 = new PageReference('/apex/Amr_AdManager');
        pageRef1.setRedirect(true);
        return null;
    }

}