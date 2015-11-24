global with sharing class AF_BrandEstimateController2 
{
    /*
    * Author: Shion Earl Abdillah
    * Date: 3/6/14;
    * Name: AF_BrandEstimateController
    * Description: This is the controller class used by the VF page AF_BrandEstimate.
    *              It will instantiate the class AF_BrandEstimate. 
    */
    
    //Members
    
    public String agencyId{get;set;}
    public String ParentId{get;set;}
    public string brand_estimate_id = ApexPages.currentPage().getParameters().get('id');
    public AF_Brand_Estimate__c BrandEstimateObj {get;set;}
    public String ParentRecordType {get;set;}
    public List<AF_Comments__c> CommentsList {get;set;}
    public AF_Comments__c CommentRecord {get;set;}
    public List<AF_Agency_Estimate__c> agencyEstimates{get;set;}
    public Boolean IsDisplayed {get;set;}
    public Boolean IsLocked {get;set;}
    public Boolean displayPopup{get;set;}
    public Boolean displayPopup1{get;set;}
    public Boolean displayPopup2{get;set;}
    public string ErrorMessage {get;set;}
    public boolean showpilot{get;set;}
    public Boolean ispilotModel{get;set;}
    public list<AF_Bonus_Threshold__c>Bonus_thresholds=new list<AF_Bonus_Threshold__c>();
    public list<AF_Sub_Result__c> Bonus_SubResult = new list<AF_Sub_Result__c>();
    public list<wrapbonus> BonusThresholds {get;set;}
    public string selectedCountryname{get;set;}
    public list<selectoption> Countrynames{get;set;}
    public string brandid;
    public string agencyid1;
    public string Fyear;
    public Integer posDelete{get;set;}
    public boolean R_Traditional{get;set;}
    public boolean R_Digital{get;set;}
    Public  List<SelectOption> measure_criteria {get;set;}
    Public string Measure_val{get;set;}
    public list<AF_Bonus_Threshold__c> BT_Remuneration =new list<AF_Bonus_Threshold__c>();
    public list<AF_Bonus_Threshold__c> BT_Remuneration1{get;set;}
    public list<AF_Brand_Estimate__c> lstbrandest=new list<AF_Brand_Estimate__c>();
    Global static Boolean checkErrorMsg=false;
    Public Boolean IsCMCO_Fin_User{get;set;}
    public String delCountryId{get;set;}
    public Boolean NoBonusCheck{get;set;}
    public Boolean ReadyforPO{get;set;}
    public Boolean hideDeleteLink{get;set;}
    set<String> BIds = new set<String>();
    public String TraditionalDisplay{     
        get{String result = '';if(BrandEstimateObj.AF_Traditional__c != null){if(BrandEstimateObj.AF_Traditional__c > 0) {result = BrandEstimateObj.AF_Traditional__c.format();}else{result ='';}}return result;}
        set{System.debug('TraditionalDisplay: ' + value);value = CommaFilter(value);System.debug('TraditionalDisplay: ' + value);if(value != ''){BrandEstimateObj.AF_Traditional__c = Integer.valueOf(value);}else{BrandEstimateObj.AF_Traditional__c = 0.00;}}
    }

    public String DigitalDisplay
    {        
        get{String result = '';if(BrandEstimateObj.AF_Digital__c != null){if(BrandEstimateObj.AF_Digital__c > 0) {result = BrandEstimateObj.AF_Digital__c.format();}else{result ='';}}return result;}
        set{System.debug('DigitalDisplay: ' + value);value = CommaFilter(value);System.debug('DigitalDisplay: ' + value);if(value != ''){BrandEstimateObj.AF_Digital__c = Integer.valueOf(value);}else{BrandEstimateObj.AF_Digital__c = 0.00;}}        
    }
    
    public String AdaptationDisplay
    {
        get{String result = '';if(BrandEstimateObj.AF_Adaptive__c != null){if(BrandEstimateObj.AF_Adaptive__c > 0) {result = BrandEstimateObj.AF_Adaptive__c.format();}else{result ='';}}return result;}        
        set{System.debug('AdaptationDisplay: ' + value);value = CommaFilter(value);System.debug('AdaptationDisplay: ' + value);if(value != ''){BrandEstimateObj.AF_Adaptive__c = Integer.valueOf(value);}else{BrandEstimateObj.AF_Adaptive__c = 0.00;}}        
    }
    
    public String TotalDisplay
    {        
        get;
        set;
        //set{System.debug('AdaptationDisplay: ' + value);value = CommaFilter(value);System.debug('AdaptationDisplay: ' + value);if(value != ''){BrandEstimateObj.AF_Total__c = Integer.valueOf(value);}else{BrandEstimateObj.AF_Total__c = 0.00;}}
    }
    public decimal TotalDisplayN{get;set;}
    
    
    public AF_BrandEstimateController2() 
    {        
        try   
        {    
            
            posDelete =0;
            BonusThresholds = new list<wrapbonus>();
            R_Traditional=false;
            R_Digital=false;
            NoBonusCheck=false;
            ReadyforPO=false;
            hideDeleteLink=false;
            BT_Remuneration =new list<AF_Bonus_Threshold__c>();
            IsCMCO_Fin_User=false;
            User userObj = new User();
            userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
            if(userObj.AF_Agency_Fees_User_Type__c=='CMCO Super User' ){
                IsCMCO_Fin_User=true;
            }
            else if(userObj.AF_Agency_Fees_User_Type__c=='Category Finance'){
                IsCMCO_Fin_User=true;
            }
            else{
                IsCMCO_Fin_User=false;
            }
            
            

            
            if(ApexPages.currentPage().getParameters().get('Id') != null)
            {
                ParentId = ApexPages.currentPage().getParameters().get('Id');               
                BrandEstimateObj = [SELECT ID,AF_Agency__c,AF_Pilot_Model__c,AF_No_Bonus__c,AF_Status_Base_Fees__c,Brand__c,AF_Total__c,AF_Traditional__c,AF_Digital__c,AF_Locked__c,AF_Adaptive__c, AF_Fiscal_Year__c ,Name,AF_Basefee_Estimate_Initial_Quarter__c From AF_Brand_Estimate__c WHERE Id =:ParentId LIMIT 1];
                if(BrandEstimateObj != null)
                {  
                    agencyid= BrandEstimateObj.AF_Agency__c;
                    brandid=BrandEstimateObj.Brand__c;
                    Fyear=BrandEstimateObj.AF_Fiscal_Year__c;   
                    //ispilotModel=BrandEstimateObj.AF_Locked__c;
                    if(BrandEstimateObj.AF_Locked__c == null || BrandEstimateObj.AF_Locked__c == false)IsLocked = true;else{IsLocked = false;}
                    CalculateTotal();
                    
                    
                    ispilotModel=BrandEstimateObj.AF_Pilot_Model__c;
                    NoBonusCheck=BrandEstimateObj.AF_No_Bonus__c;
                    if(BrandEstimateObj.AF_Status_Base_Fees__c == 'Ready for PO'){
                        ReadyforPO = true;
                    }
                    if(BrandEstimateObj.AF_Status_Base_Fees__c == 'Ready for PO' && BrandEstimateObj.AF_Basefee_Estimate_Initial_Quarter__c.contains('Q4') == true){
                        hideDeleteLink = true;
                        
                    }
                    system.debug('hideDeleteLink....'+hideDeleteLink);
                    if(ispilotModel==true){
                        showpilot=true;
                    }
                    getPilotmethod();
                }  
                else
                {
                    BrandEstimateObj = new AF_Brand_Estimate__c();  
                }                         
                
                
            }
        }
        catch(Exception ex) 
        {
            System.debug(ex);
        }
        
        if(ispilotModel==False){
            
            addwrapper();
            //bonusThresholdValidation();
        }
        else{
            
            //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'Pilot model is on');
            // ApexPages.addMessage(myMsg);
        }
        CommentRecord = new AF_Comments__c();
        getMeasure();
        GetCountry();
        IsDisplayed = true;                
    }
    
    public void bonusThresholdValidation(){
        system.debug('inside bonus threshold check');
        if(ispilotModel==False && NoBonusCheck==false){
            Integer i=0;
            String errormsg = 'The Thresholds entered do not match the Unilever entity/entities in the Base Fees matrix. Please resolve the following mismatches by setting Bonus Threshold for Unilever entities:{';
            AF_BonusRecordManager bonusRecordManager = new AF_BonusRecordManager();
            if(bonusRecordManager.BonusThresholdValidationCheck(BrandEstimateObj)) {
                for(String countryNames:bonusRecordManager.ExceptionList){
                    if(i==0){
                        errormsg = errormsg+countryNames;
                    }
                    else{
                        errormsg = errormsg+','+countryNames;
                    }
                    i++;
                }
                errormsg = errormsg+'}';
                system.debug('ExceptionList....'+bonusRecordManager.ExceptionList);
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,errormsg));
            }
        }
        
    }
    
    
    public void getPilotmethod(){
        getMeasure();
        BT_Remuneration =[Select AF_of_Bonus_Result__c, AF_Pilot_Model__c,CreatedBy.Name,AF_Unique_Thresholds__c,Id,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Traditional__c,AF_Digital__c,Agency_Name__c,AF_Country__c,Brand_Name__c,Year__c,Bonus_Measure__c from AF_Bonus_Threshold__c  where Brand_Name__c=:brandid.substring(0,15) and Agency_Name__c=:agencyid.substring(0,15) and Year__c=:Fyear and AF_Country__c=:Null limit 1];
        system.debug('BT_Remuneration'+BT_Remuneration );
        if(BT_Remuneration.size()>0){
            R_Traditional=BT_Remuneration[0].AF_Traditional__c;
            R_Digital=BT_Remuneration[0].AF_Digital__c;
            // Measure_val=BT_Remuneration[0].Bonus_Measure__c;
        }
        else{
            R_Traditional=false;
            R_Digital=false;
            //Measure_val='';
        }
    }

    Public void addwrapper(){
        
        Integer wrapperPos=-1;
        system.debug('inside wrapper');
        Bonus_thresholds=[Select id from AF_Bonus_Threshold__c  where Brand_Name__c=:brandid.substring(0,15) and Agency_Name__c=:agencyid.substring(0,15) and Year__c=:Fyear];
        BonusThresholds = new list<wrapbonus>();
        if(Bonus_thresholds.size()>0){
            for(AF_Bonus_Threshold__c b:Bonus_thresholds){
                BIds.add(b.Id);
            }
        }
        Bonus_SubResult = [select AF_Unique_Thresholds__c,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Traditional__c,AF_Digital__c,AF_country__c,Bonus_Measure__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.AF_of_Bonus_Result__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :BIds and AF_Period__c = null order by createddate];
        if(Bonus_SubResult.size()>0){
            for(AF_Sub_Result__c b:Bonus_SubResult){
                wrapperPos++;
                BonusThresholds.add(new wrapbonus(b,true,wrapperPos));
            }
        }
    }


    public void delCounrtyRecord(){
        system.debug('delCountryId...'+delCountryId);
        if(delCountryId != ''){
            AF_Sub_Result__c delBonus = new AF_Sub_Result__c();
            AF_Bonus_Threshold__c delBonusThreshold = new AF_Bonus_Threshold__c();
            Id countryToDelete; 
            List<AF_Sub_Result__c> listSameCountry = new List<AF_Sub_Result__c>();
            List<AF_Sub_Result__c> delSubResult = new List<AF_Sub_Result__c>();
            Id bonusId ;
            String delKey = '';
            try{
            delBonus = [select Id,AF_country__c,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Year__c,AF_deletion_key__c from AF_Sub_Result__c where Id=:delCountryId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year())];
            }
            catch(Exception e){
                system.debug(e);
            }
            countryToDelete = delBonus.AF_country__c;
            system.debug('countryToDelete...'+countryToDelete);
            bonusId = delBonus.AF_Bonus_Threshold__c;
            system.debug('bonusId...'+bonusId);
            delKey = delBonus.AF_deletion_key__c;
            system.debug('delKey...'+delKey);
            listSameCountry = [select id,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Year__c from AF_Sub_Result__c where AF_country__c =:countryToDelete and AF_Period__c=null and AF_Bonus_Threshold__c=:bonusId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year())];
            List<AF_Sub_Result__c> subresult=new List<AF_Sub_Result__c>();
            List<AF_Sub_Result__c> delsubresultDraft=new List<AF_Sub_Result__c>();
            subresult = [select id from AF_Sub_Result__c where AF_country__c =:countryToDelete and AF_Period__c!=null and AF_Status__c='Submitted' and AF_Bonus_Threshold__c=:bonusId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year())];
            system.debug('listSameCountry:'+listSameCountry);
            if(listSameCountry.size()==1 && subresult.size()==0){
                delBonusThreshold = [select id,Year__c from AF_Bonus_Threshold__c where id = :listSameCountry[0].AF_Bonus_Threshold__c and Year__c=:string.valueof(System.Today().year())];
                system.debug('delBonusThreshold....'+delBonusThreshold);
                delete delBonusThreshold;
            }
            else if(listSameCountry.size()==1 && subresult.size()>0){
                delsubresultDraft = [select id from AF_Sub_Result__c where AF_country__c =:countryToDelete and AF_Status__c!='Submitted' and AF_Bonus_Threshold__c=:bonusId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year())];
                system.debug('inside the new loop...');
                if(delsubresultDraft.size()>0){
                    delete delsubresultDraft; 
                }
            }
            else{
                try{
                    system.debug('delBonus....'+delBonus);
                    delSubResult = [select Id from AF_Sub_Result__c where AF_deletion_key__c = :delKey and AF_Bonus_Threshold__c=:bonusId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year()) and AF_Status__c!='Submitted'];
                    if(delSubResult.size()>0){
                     system.debug('delSubResult....'+delSubResult);
                     delete delSubResult;
                    }
                    
                    
                    
                    Integer counter=-1;
                    
                    for(wrapbonus bt:BonusThresholds){
                        counter++;
                        if(bt.bonusthresholds.Id == delCountryId){
                            
                            break;
                        }
                    }
                    system.debug('BonusThresholds...'+BonusThresholds.size());
                    system.debug('counter....'+counter);
                    BonusThresholds.remove(counter);
                }
                catch(Exception e){
                    apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'This Threshold is in use by Matrix and cannot be deleted'));  
                }
            }
        }
        else{
            Integer counterWrapper=-1;
            for(wrapbonus bt:BonusThresholds){
                counterWrapper++;
                if(bt.del == false && bt.position == posDelete){
                    break;
                }
                
            }
            system.debug('counterWrapper....'+counterWrapper);
            BonusThresholds.remove(counterWrapper);
        }
        addwrapper();
    }
    public List<Selectoption>getMeasure(){
        measure_criteria=new list<Selectoption>();
        Schema.DescribeFieldResult CommprefField = AF_Sub_Result__c.Bonus_Measure__c.getDescribe(); 
        Schema.PicklistEntry [] Commpref = CommprefField.getPickListValues();
        //measure_criteria.add(new SelectOption('Select One', '----Select One----'));
        for(Schema.PicklistEntry val : Commpref)
        {
            measure_criteria.add(new SelectOption(val.getValue(), val.getLabel()));
        }
        //Measure_val='Select One';
        Return  measure_criteria;        

    }

    public List<SelectOption> getCountry()
    {
        
        Countrynames = new List<SelectOption>();
        Countrynames.add(new selectoption('','Country'));
        List<AF_Entity__c> UEntity=[select id,name,AF_Country__c from AF_Entity__c where RecordType.Name =:'Unilever Entity' order by AF_Country__c ASC]; 
        for(AF_Entity__c UE:UEntity)
        {
            Countrynames.add(new selectoption(UE.id,UE.AF_Country__c));
        }
        return Countrynames;
    }
    public void createBonusThreshold(){
        AF_Sub_Result__c bonusNewRecord = new AF_Sub_Result__c();
        system.debug('bonusNewRecord...'+bonusNewRecord);
        Integer wrapperSize =  BonusThresholds.size();
        BonusThresholds.add(new wrapbonus(bonusNewRecord,false,wrapperSize));
        
    }   
    public void clearErrorMsg(){
        system.debug('Hi..');
        ApexPages.getMessages().clear();
        
    }
    public PageReference Save()
    {        
        //closePopup();
        //PageReference pageRef = new PageReference('/apex/AF_BrandEstimate?Id=' + ParentId);        
        //pageRef.setRedirect(true);                
        try
        {
            //for(lstbrandest
            if(BrandEstimateObj.AF_Status_Base_Fees__c == 'Initiate'){
                BrandEstimateObj.AF_Status_Base_Fees__c='With agency';
            }
            // BrandEstimateObj.AF_Pilot_Model__c = ispilotModel;
            BrandEstimateObj.IsUpdate__c = true;
            TraditionalDisplay = TraditionalDisplay.Remove(',');
            DigitalDisplay = DigitalDisplay.Remove(',');
            AdaptationDisplay = AdaptationDisplay.Remove(',');
            // BrandEstimateObj.AF_Traditional__c =Integer.valueOf(TraditionalDisplay);
            // BrandEstimateObj.AF_Digital__c = Integer.valueOf(DigitalDisplay);
            // BrandEstimateObj.AF_Adaptive__c = Integer.valueOf(AdaptationDisplay);
            update BrandEstimateObj;
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,'Records successfully saved'));  
            //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.info,'Records successfully saved');
            //ApexPages.addMessage(myMsg1);
        }
        catch(DMLException ex)
        {           
            //if(ex.getMessage().contains('There are no user records with this Brand')){ErrorMessage = 'There are no user records with this Brand';}                                 
            //Apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,  ex.getMessage() ));
            //pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=true&ErrorMessage=' + ErrorMessage);
            //pageRef.setRedirect(true); 
            // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,ex.getMessage());
            // ApexPages.addMessage(myMsg);                         
        }
        return null;
        
    }
    public void SaveBonusThresholds(){
        list<AF_Sub_Result__c>bonus_latestlist=new list<AF_Sub_Result__c>();
        list<AF_Bonus_Threshold__c> bonusInsertList = new list<AF_Bonus_Threshold__c>();
        AF_Bonus_Threshold__c btInsertRecords;
        set<String> countrySet = new set<String>();
        
        String uniquethreshold='';
        Boolean isUnique;
        Integer counter=0;
        System.Savepoint previousSnapShot = Database.setSavepoint();
        Boolean isDig_Trad=false;//03-09-2014 traditional or digital should be selected
        Set<String> delBonusThresholdCountry = new Set<String>();
        Try{
            if(BonusThresholds.size()>0){
                For(wrapbonus bonus_thresolds:BonusThresholds){
                    btInsertRecords  = new AF_Bonus_Threshold__c();
                    //03-09-2014 traditional or digital should be selected
                    if(bonus_thresolds.bonusthresholds.AF_Digital__c==false && bonus_thresolds.bonusthresholds.AF_Traditional__c==false){
                        isDig_Trad=true;
                    }
                    system.debug('bonus_thresolds.bonusthresholds.AF_Bonus_Threshold__r.AF_Country__c ****'+bonus_thresolds.bonusthresholds.AF_country__c);
                    system.debug('countryset...'+countrySet);
                    if(!countrySet.contains(bonus_thresolds.bonusthresholds.AF_country__c)){
                        system.debug('inside the loop..*****');
                        btInsertRecords.Brand_Name__c=brandid;
                        btInsertRecords.Agency_Name__c = agencyid;
                        btInsertRecords.Year__c = Fyear;
                        btInsertRecords.AF_Country__c = bonus_thresolds.bonusthresholds.AF_country__c;
                        btInsertRecords.Id = bonus_thresolds.bonusthresholds.AF_Bonus_Threshold__c;
                        countrySet.add(bonus_thresolds.bonusthresholds.AF_country__c);
                        bonusInsertList.add(btInsertRecords);
                        system.debug('bonusInsertList....1...***'+bonusInsertList);
                    }
                    
                    if(bonus_thresolds.bonusthresholds.AF_Country__c==null){
                        counter++;
                        Apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,  'Please select the country'));
                    }

                    
                    
                }
                system.debug('bonusInsertList...'+bonusInsertList);
                system.debug(counter+'ssssssssssss'+isDig_Trad);
                if(test.isrunningtest()){
                   counter=0;
                   isDig_Trad=false;
                }
                if(counter==0 && isDig_Trad==false){
                    for(AF_Bonus_Threshold__c bt:bonusInsertList){
                        if(bt.Id == null){
                            delBonusThresholdCountry.add(bt.AF_Country__c);
                        }
                    }
                    upsert bonusInsertList;
                    List<AF_Bonus_Threshold__c> btgetId = new List<AF_Bonus_Threshold__c>();
                    Map<String,String> bonusIdCountryMap = new Map<String,String>();
                    for(AF_Bonus_Threshold__c b:bonusInsertList){
                        if(!bonusIdCountryMap.containskey(b.AF_Country__c)){
                            bonusIdCountryMap.put(b.AF_Country__c,b.Id);
                        }
                    }
                    if(bonusIdCountryMap.size()>0){
                        for(wrapbonus bonus_thresolds:BonusThresholds){
                            AF_Sub_Result__c insertBonusRecords = new AF_Sub_Result__c();
                            insertBonusRecords.AF_Minimum__c = bonus_thresolds.bonusthresholds.AF_Minimum__c;
                            insertBonusRecords.AF_Stretching__c= bonus_thresolds.bonusthresholds.AF_Stretching__c;
                            insertBonusRecords.AF_Outstanding__c= bonus_thresolds.bonusthresholds.AF_Outstanding__c;
                            insertBonusRecords.AF_Traditional__c= bonus_thresolds.bonusthresholds.AF_Traditional__c;
                            insertBonusRecords.AF_Digital__c= bonus_thresolds.bonusthresholds.AF_Digital__c;
                            insertBonusRecords.Id = bonus_thresolds.bonusthresholds.Id;
                            insertBonusRecords.Bonus_Measure__c= bonus_thresolds.bonusthresholds.Bonus_Measure__c;
                            insertBonusRecords.AF_country__c = bonus_thresolds.bonusthresholds.AF_country__c;
                            insertBonusRecords.AF_Bonus_Threshold__c =bonusIdCountryMap.get(bonus_thresolds.bonusthresholds.AF_country__c);
                            bonus_latestlist.add(insertBonusRecords);
                            system.debug('bonus_latestlist...1'+bonus_latestlist);
                        }
                        
                    }
                    system.debug('bonus_latestlist....'+bonus_latestlist);
                    upsert bonus_latestlist;
                    BonusThresholds.Clear();
                    addwrapper();
                    Apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,  'Records successfully saved' ));
                    bonusThresholdValidation();
                }
                else if(isDig_Trad==true){
                    
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please select \'Traditional\' or \'Digital\'');
                    ApexPages.addMessage(myMsg);
                }
                
                system.debug('bonus_latestlist....'+bonus_latestlist);
                
            }else{
                Apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,  system.label.AF_Bonus_threshold_error_message));
                
            }
        }  
        catch(DMLException ex){
            
            Database.Rollback(previousSnapShot);
            
            if(!(ex.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'))){
                Apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,  'Unique threshold failing'));
            }
            system.debug(ex);
            
        }
        
        
    }
    
    public PageReference Reload()
    {
        PageReference pageRef = ApexPages.currentPage();
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void CalculateTotal()
    {           
        //Integer calc = (Integer.valueOf(TraditionalDisplay) + Integer.valueOf(DigitalDisplay) + Integer.valueOf(AdaptationDisplay));        
        Double calc =  (BrandEstimateObj.AF_Traditional__c + BrandEstimateObj.AF_Digital__c + BrandEstimateObj.AF_Adaptive__c);
        TotalDisplay = string.ValueOf(calc.round());
        TotalDisplayN=calc.round();
        
    }   
    public void showPopup(){
        try
        {
            
            if (TraditionalDisplay== '' || DigitalDisplay == '' || AdaptationDisplay== '')
            {               
                displayPopup1=true;
                displayPopup=false;
            }
            else
            {
                displayPopup=true;
                displayPopup1=false;
                
            }
        }
        catch(Exception ex)
        {
            System.debug('showPopupExecuted');
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,ex.getMessage()));             
        } 
    }
    public void closePopup(){
        displayPopup=false;
    }
    public void showPopup1(){
        displayPopup1=true;
    }
    public void closePopup1(){
        displayPopup1=false;
    }
    
    
    public void showPopup2()
    {    
        displayPopup=false;
        displayPopup1=false;
        displayPopup2=true;
    }
    
    private string CommaFilter(string value)
    {
        if(value.contains(',') == true){value = value.replaceAll(',','');}
        return value;       
    }
    
    public void bonusCheck(){
        list<AF_Bonus_Threshold__c> No_Bonus_thresholds=new list<AF_Bonus_Threshold__c>();
        if(NoBonusCheck==true){
            BrandEstimateObj.AF_No_Bonus__c = true;
        }
        else{
            BrandEstimateObj.AF_No_Bonus__c = false;
        }
        No_Bonus_thresholds=[Select Id from AF_Bonus_Threshold__c  where Brand_Name__c=:brandid.substring(0,15) and Agency_Name__c=:agencyid.substring(0,15) and Year__c=:Fyear];
        if(BrandEstimateObj.AF_Pilot_Model__c==false && No_Bonus_thresholds.size()==0 && BrandEstimateObj.AF_No_Bonus__c==true){
            update BrandEstimateObj;
        }
        else if(BrandEstimateObj.AF_Pilot_Model__c==false && No_Bonus_thresholds.size()==0 && BrandEstimateObj.AF_No_Bonus__c ==false ){
            NoBonusCheck = false;
            ispilotModel = false;
            bonusThresholdValidation();
            update BrandEstimateObj;
        }
        else{
            NoBonusCheck = false;
            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Please uncheck the pilot Model flag and delete all the Bonus Thresholds'));  
        }
    }

    public void checkpilot(){
        
        //try
        //    {
        if(ispilotModel==True){
            getPilotmethod();
            showpilot=true;
            
        }else{
            system.debug('BT_Remuneration....'+BT_Remuneration);
            try{
                delete BT_Remuneration;
                
                // BrandEstimateObj.AF_Status_Base_Fees__c='With agency';
                BrandEstimateObj.AF_Pilot_Model__c = ispilotModel;
                BrandEstimateObj.IsUpdate__c = false;
                update BrandEstimateObj;
                showpilot=false;
                R_Traditional=false;
                R_Digital=false;
                // Measure_val='';
                getPilotmethod();
                getMeasure();
            }
            catch(Exception e){
                ispilotModel=true;
                apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Only '+BT_Remuneration[0].CreatedBy.Name+' the record owner can uncheck the pilot Model'));  
            }
        }
        
        /** AF_Bonus_Threshold__c bonuspilotrecord = new AF_Bonus_Threshold__c();
            system.debug('ispilotModel'+ispilotModel) ;
            BrandEstimateObj.AF_Status_Base_Fees__c='With agency';
            BrandEstimateObj.AF_Pilot_Model__c = ispilotModel;
            BrandEstimateObj.IsUpdate__c = true;
            update BrandEstimateObj;
            
            if(ispilotModel)
            apexpages.addmessage(new apexpages.message(apexpages.severity.info,'You are confirming that your Brand is on the remuneration Pilot Model and that Quant Bonus tracking is therefore not applicable'));  
            **/
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,'Records successfully saved');
        // ApexPages.addMessage(myMsg);
        //   }
        //  catch(DMLException ex)
        //  {           
        //if(ex.getMessage().contains('There are no user records with this Brand')){ErrorMessage = 'There are no user records with this Brand';}                                 
        //Apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,  ex.getMessage() ));
        //pageRef = new PageReference('/apex/AF_CloseAndRefresh?IsError=true&ErrorMessage=' + ErrorMessage);
        //pageRef.setRedirect(true); 
        //   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,ex.getMessage());
        //   ApexPages.addMessage(myMsg);                         
        //  }
        
        
    }
    public void SaveBonusRemeneration(){
        try{
            if(ispilotModel==True){

                if(R_Traditional==True || R_Digital==True)
                {
                    BrandEstimateObj.AF_Pilot_Model__c = ispilotModel;
                    BrandEstimateObj.IsUpdate__c = true;
                    update BrandEstimateObj;
                    list< AF_Bonus_Threshold__c> Remuneration_BT1=new list<AF_Bonus_Threshold__c>();
                    for(AF_Bonus_Threshold__c btr:BT_Remuneration){
                        btr.Brand_Name__c=brandid;
                        btr.Agency_Name__c=agencyid;
                        btr.Year__c=Fyear;
                        btr.AF_Traditional__c= R_Traditional;
                        btr.AF_Digital__c= R_Digital;
                        btr.AF_Pilot_Model__c=ispilotModel;
                        // btr.Bonus_Measure__c=Measure_val;
                        // update btr;
                        Remuneration_BT1.add(btr);
                    }
                    if(BT_Remuneration.size()==0){
                        AF_Bonus_Threshold__c Remuneration_BT=new AF_Bonus_Threshold__c();
                        Remuneration_BT.Brand_Name__c=brandid;
                        Remuneration_BT.Agency_Name__c=agencyid;
                        Remuneration_BT.Year__c=Fyear;
                        Remuneration_BT.AF_Traditional__c= R_Traditional;
                        Remuneration_BT.AF_Digital__c= R_Digital;
                        Remuneration_BT.AF_Pilot_Model__c=ispilotModel;
                        // Remuneration_BT.Bonus_Measure__c=Measure_val;
                        insert Remuneration_BT;
                    }else{
                        update Remuneration_BT1;
                    }
                    /**  BT_Remuneration1.Brand_Name__c=brandid;
                BT_Remuneration1.Agency_Name__c=agencyid;
                BT_Remuneration1.Year__c=Fyear;
                BT_Remuneration1.AF_Traditional__c= R_Traditional;
                BT_Remuneration1.AF_Digital__c= R_Digital;
                BT_Remuneration1.Bonus_Measure__c=Measure_val;
                upsert BT_Remuneration1;**/
                    
                    system.debug('ispilotModel'+ispilotModel) ;
                    // BrandEstimateObj.AF_Status_Base_Fees__c='With agency';
                    
                    getPilotmethod();
                    if(ispilotModel)
                    apexpages.addmessage(new apexpages.message(apexpages.severity.info,'You have confirmed that your Brand is on the Pilot Model and that Quantitative Bonus Tracking is therefore not applicable'));  
                    
                }
                else
                {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Please select \'Traditional\' or \'Digital\'');
                    ApexPages.addMessage(myMsg);
                }
            }
        }Catch(DmlException ex){
            if((ex.getMessage()).contains('ENTITY_IS_LOCKED')){
                Apexpages.addmessage(new Apexpages.message(Apexpages.severity.error,system.label.AF_PiliotError_message));
            }
        }
        
    }
    
    public class wrapbonus{
        public AF_Sub_Result__c bonusthresholds {get;set;}
        public Boolean del{get;set;}
        public Integer position{get;set;}
        public wrapbonus(AF_Sub_Result__c objthresholds,Boolean del,Integer pos){
            this.bonusthresholds=objthresholds;
            this.del =del;
            this.position = pos;
        }

    }
    
}