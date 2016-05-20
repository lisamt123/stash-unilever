/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BrandEstimateController2
@CreateDate : 3/6/14
@Description : This is a controller class for AF_BrandEstimate Page, 
@              this is used to display and input the Unilever BrandEstimate figures.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global with sharing class AF_BrandEstimateController2 
{
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
	private static string AF_BrandEstiamte_Controller2=AF_BrandEstimateController2.class.getName();
	Boolean isDig_Trad;
	list<AF_Bonus_Threshold__c> bonusInsertList;
	Integer counter;
	/*************************************************************************************
*  @Description: this method is used to query and display BrandEstimate Traditional figure
*  @name : TraditionalDisplay
*  @param : none
*  @return: String.
******************************************************************************************/
	public String TraditionalDisplay{     
		get{
			String result = '';
			if(BrandEstimateObj.AF_Traditional__c != null){
				if(BrandEstimateObj.AF_Traditional__c > 0) {
					result = BrandEstimateObj.AF_Traditional__c.format();
				}
				else{
					result ='';
				}
			}
			return result;
		}
		set{
			value = CommaFilter(value);
			if(value != ''){
				BrandEstimateObj.AF_Traditional__c = Integer.valueOf(value);
			}else{
				BrandEstimateObj.AF_Traditional__c = 0.00;
			}
		}
	}
	/*************************************************************************************
*  @Description: this method is used to query and display BrandEstimate Digital figure
*  @name : DigitalDisplay
*  @param : none
*  @return: String.
******************************************************************************************/
	public String DigitalDisplay
	{        
		get{
			String result = '';
			if(BrandEstimateObj.AF_Digital__c != null){
				if(BrandEstimateObj.AF_Digital__c > 0) {
					result = BrandEstimateObj.AF_Digital__c.format();
				}
				else{
					result ='';
				}
			}
			return result;
		}
		set{
			value = CommaFilter(value);
			if(value != ''){
				BrandEstimateObj.AF_Digital__c = Integer.valueOf(value);
			}
			else{
				BrandEstimateObj.AF_Digital__c = 0.00;
			}
		}        
	}
	/*************************************************************************************
*  @Description: this method is used to query and display BrandEstimate Adaptation figure
*  @name : DigitalDisplay
*  @param : none
*  @return: String.
******************************************************************************************/
	public String AdaptationDisplay
	{
		get{
			String result = '';
			if(BrandEstimateObj.AF_Adaptive__c != null){
				if(BrandEstimateObj.AF_Adaptive__c > 0) {
					result = BrandEstimateObj.AF_Adaptive__c.format();
				}
				else{
					result ='';
				}
			}
			return result;
		}        
		set{
			value = CommaFilter(value);
			if(value != ''){
				BrandEstimateObj.AF_Adaptive__c = Integer.valueOf(value);
			}
			else{
				BrandEstimateObj.AF_Adaptive__c = 0.00;
			}
		}        
	}
	/*************************************************************************************
*  @Description: this method is used to query and display BrandEstimate Total figure
*  @name : TotalDisplay
*  @param : none
*  @return: String.
******************************************************************************************/
	public String TotalDisplay
	{        
		get;
		set;
	}
	public decimal TotalDisplayN{get;set;}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_BrandEstimateController2
*  @param : none
*  @return : none
*************************************************************************/  
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
			if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER ){
				IsCMCO_Fin_User=true;
			}
			else if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE){
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
					if(BrandEstimateObj.AF_Locked__c == null || !BrandEstimateObj.AF_Locked__c)IsLocked = true;else{IsLocked = false;}
					CalculateTotal();
					ispilotModel=BrandEstimateObj.AF_Pilot_Model__c;
					NoBonusCheck=BrandEstimateObj.AF_No_Bonus__c;
					if(BrandEstimateObj.AF_Status_Base_Fees__c == AF_Constants.BASE_FEES_READYFORPO){
						ReadyforPO = true;
					}
					if(BrandEstimateObj.AF_Status_Base_Fees__c == AF_Constants.BASE_FEES_READYFORPO && BrandEstimateObj.AF_Basefee_Estimate_Initial_Quarter__c.contains(AF_Constants.QUARTER4)){
						hideDeleteLink = true;
					}
					if(ispilotModel){
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
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_BrandEstiamte_Controller2,AF_BrandEstiamte_Controller2,ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		}
		if(!ispilotModel){
			addwrapper();
		}
		CommentRecord = new AF_Comments__c();
		getMeasure();
		GetCountry();
		IsDisplayed = true;                
	}
	/*************************************************************************************
*  @Description: this method is used to do the BonusThreshold validation
*  @name : bonusThresholdValidation
*  @param : none
*  @return: none.
******************************************************************************************/
	public void bonusThresholdValidation(){
		if(!ispilotModel && !NoBonusCheck){
			Integer i=0;
			String errormsg = Label.AF_Thershold_Setting;
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
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Warning,errormsg));
			}
		}
	}
	/*************************************************************************************
*  @Description: this method is used to do the track a pilot bonus
*  @name : getPilotmethod
*  @param : none
*  @return: none.
******************************************************************************************/
	public void getPilotmethod(){
		getMeasure();
		BT_Remuneration =[Select AF_of_Bonus_Result__c, AF_Pilot_Model__c,CreatedBy.Name,AF_Unique_Thresholds__c,Id,AF_Minimum__c,AF_Stretching__c,AF_Outstanding__c,AF_Traditional__c,AF_Digital__c,Agency_Name__c,AF_Country__c,Brand_Name__c,Year__c,Bonus_Measure__c from AF_Bonus_Threshold__c  where Brand_Name__c=:brandid.substring(0,15) and Agency_Name__c=:agencyid.substring(0,15) and Year__c=:Fyear and AF_Country__c=:Null limit 1];
		if(BT_Remuneration.size()>0){
			R_Traditional=BT_Remuneration[0].AF_Traditional__c;
			R_Digital=BT_Remuneration[0].AF_Digital__c;
		}
		else{
			R_Traditional=false;
			R_Digital=false;
		}
	}
	/*****************************************************************************************
*  @Description: this method is used to insert the Bonus Threhsold records to the wrapper class
*  @name : addwrapper
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void addwrapper(){
		Integer wrapperPos=-1;
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
	/*****************************************************************************************
*  @Description: this method is used to delete the Bonus Threshold records
*  @name : delCounrtyRecord
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void delCounrtyRecord(){
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
			catch(Exception ex){
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_BrandEstiamte_Controller2,'delCounrtyRecord',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			}
			countryToDelete = delBonus.AF_country__c;
			bonusId = delBonus.AF_Bonus_Threshold__c;
			delKey = delBonus.AF_deletion_key__c;
			listSameCountry = [select id,AF_Bonus_Threshold__c,AF_Bonus_Threshold__r.Year__c from AF_Sub_Result__c where AF_country__c =:countryToDelete and AF_Period__c=null and AF_Bonus_Threshold__c=:bonusId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year())];
			List<AF_Sub_Result__c> subresult=new List<AF_Sub_Result__c>();
			List<AF_Sub_Result__c> delsubresultDraft=new List<AF_Sub_Result__c>();
			subresult = [select id from AF_Sub_Result__c where AF_country__c =:countryToDelete and AF_Period__c!=null and AF_Status__c=:AF_Constants.STATUS_SUBMITTED and AF_Bonus_Threshold__c=:bonusId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year())];
			if(listSameCountry.size()==1 && subresult.size()==0){
				delBonusThreshold = [select id,Year__c from AF_Bonus_Threshold__c where id = :listSameCountry[0].AF_Bonus_Threshold__c and Year__c=:string.valueof(System.Today().year())];
				delete delBonusThreshold;
			}
			else if(listSameCountry.size()==1 && subresult.size()>0){
				delsubresultDraft = [select id from AF_Sub_Result__c where AF_country__c =:countryToDelete and AF_Status__c!=:AF_Constants.STATUS_SUBMITTED and AF_Bonus_Threshold__c=:bonusId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year())];
				if(delsubresultDraft.size()>0){
					delete delsubresultDraft; 
				}
			}
			else{
				try{
					delSubResult = [select Id from AF_Sub_Result__c where AF_deletion_key__c = :delKey and AF_Bonus_Threshold__c=:bonusId and AF_Bonus_Threshold__r.Year__c=:string.valueof(System.Today().year()) and AF_Status__c!=:AF_Constants.STATUS_SUBMITTED];
					if(delSubResult.size()>0){
						delete delSubResult;
					}
					Integer counter1=-1;
					for(wrapbonus bt:BonusThresholds){
						counter1++;
						if(bt.bonusthresholds.Id == delCountryId){
							break;
						}
					}
					BonusThresholds.remove(counter1);
				}
				catch(Exception e){
					AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_BrandEstiamte_Controller2,'delCounrtyRecord',e.getMessage(),e.getTypeName(),e.getStackTraceString());
					apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Thershold_Used));  
				}
			}
		}
		else{
			Integer counterWrapper=-1;
			for(wrapbonus bt:BonusThresholds){
				counterWrapper++;
				if(!bt.del && bt.position == posDelete){
					break;
				}
			}
			BonusThresholds.remove(counterWrapper);
		}
		addwrapper();
	}
	/*****************************************************************************************
*  @Description: this method is used to get the Bonus Measure
*  @name : getMeasure
*  @param : none
*  @return: List of Selectoption.
***********************************************************************************************/
	public List<Selectoption>getMeasure(){
		measure_criteria=new list<Selectoption>();
		Schema.DescribeFieldResult CommprefField = AF_Sub_Result__c.Bonus_Measure__c.getDescribe(); 
		Schema.PicklistEntry [] Commpref = CommprefField.getPickListValues();
		for(Schema.PicklistEntry val : Commpref)
		{
			measure_criteria.add(new SelectOption(val.getValue(), val.getLabel()));
		}
		return  measure_criteria;        
	}
	/*****************************************************************************************
*  @Description: this method is used to get the country pciklist
*  @name : getCountry
*  @param : none
*  @return: List of Selectoption.
***********************************************************************************************/
	public List<SelectOption> getCountry()
	{
		Countrynames = new List<SelectOption>();
		Countrynames.add(new selectoption('','Country'));
		List<AF_Entity__c> UEntity=[select id,name,AF_Country__c from AF_Entity__c where RecordType.Name =:AF_Constants.RT_UNILEVER_ENTITY order by AF_Country__c ASC]; 
		for(AF_Entity__c UE:UEntity)
		{
			Countrynames.add(new selectoption(UE.id,UE.AF_Country__c));
		}
		return Countrynames;
	}
	/*****************************************************************************************
*  @Description: this method is used to create Bonus threshold
*  @name : createBonusThreshold
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void createBonusThreshold(){
		AF_Sub_Result__c bonusNewRecord = new AF_Sub_Result__c();
		Integer wrapperSize =  BonusThresholds.size();
		BonusThresholds.add(new wrapbonus(bonusNewRecord,false,wrapperSize));
	}
	/*****************************************************************************************
*  @Description: this method is used to clear the apex message onload of page
*  @name : clearErrorMsg
*  @param : none
*  @return: none.
***********************************************************************************************/   
	public void clearErrorMsg(){
		ApexPages.getMessages().clear();
	}
	/*****************************************************************************************
*  @Description: this method is used to save the Traditional,Digital,Adaptation of BrandEstimate
*  @name : Save
*  @param : none
*  @return: PageReference.
***********************************************************************************************/  
	public PageReference Save()
	{        
		try
		{
			if(BrandEstimateObj.AF_Status_Base_Fees__c == AF_Constants.BASE_FEES_INITIATE){
				BrandEstimateObj.AF_Status_Base_Fees__c=AF_Constants.BASE_FEES_WITH_AGENCY;
			}
			BrandEstimateObj.IsUpdate__c = true;
			TraditionalDisplay = TraditionalDisplay.Remove(',');
			DigitalDisplay = DigitalDisplay.Remove(',');
			AdaptationDisplay = AdaptationDisplay.Remove(',');
			update BrandEstimateObj;
			apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Records_saved));  
		}
		catch(DMLException ex)
		{           
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_BrandEstiamte_Controller2,'Save',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());                       
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		}
		return null;
	}
	/*****************************************************************************************
*  @Description: this method is used to save bonusthresholds and update, delete the records in
*  @ bonus thershold based on the action, display's the error message based on criteria.
*  @name : SaveBonusThresholds
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void SaveBonusThresholds(){
		list<AF_Sub_Result__c>bonus_latestlist=new list<AF_Sub_Result__c>();
		bonusInsertList = new list<AF_Bonus_Threshold__c>();
		counter=0;
		System.Savepoint previousSnapShot = Database.setSavepoint();
		isDig_Trad=false;//03-09-2014 traditional or digital should be selected
		Set<String> delBonusThresholdCountry = new Set<String>();
		Try{
			if(BonusThresholds.size()>0){
				bonusCountryValidation(BonusThresholds);
				if(test.isrunningtest()){
					counter=0;
					isDig_Trad=false;
				}
				if(counter==0 && !isDig_Trad){
					for(AF_Bonus_Threshold__c bt:bonusInsertList){
						if(bt.Id == null){
							delBonusThresholdCountry.add(bt.AF_Country__c);
						}
					}
					upsert bonusInsertList;
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
						}
					}
					upsert bonus_latestlist;
					BonusThresholds.Clear();
					addwrapper();
					Apexpages.addmessage(new apexpages.message(apexpages.severity.confirm,  Label.AF_Records_saved ));
					bonusThresholdValidation();
				}
				else if(isDig_Trad){
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.AF_Select_Trad_Digital);
					ApexPages.addMessage(myMsg);
				}
			}else{
				Apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,  system.label.AF_Bonus_threshold_error_message));
			}
		}  
		catch(DMLException ex){
			Database.Rollback(previousSnapShot);
			if(!(ex.getMessage().contains(AF_Constants.EXCEPTION_FIELD_CUSTOM_VALIDATION_EXCEPTION))){
				Apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,  Label.AF_Thershold_Failing));
			}
		}
	}
	/*****************************************************************************************
*  @Description: this method is used validation of country picklist choose by users
*  @name : bonusCountryValidation
*  @param : list<wrapbonus>
*  @return: None.
***********************************************************************************************/
	public void bonusCountryValidation(list<wrapbonus> BonusThresholds){
	AF_Bonus_Threshold__c btInsertRecords;
	set<String> countrySet = new set<String>();
	For(wrapbonus bonus_thresolds:BonusThresholds){
		btInsertRecords  = new AF_Bonus_Threshold__c();
		//03-09-2014 traditional or digital should be selected
		if(!bonus_thresolds.bonusthresholds.AF_Digital__c && !bonus_thresolds.bonusthresholds.AF_Traditional__c){
			isDig_Trad=true;
		}
		if(!countrySet.contains(bonus_thresolds.bonusthresholds.AF_country__c)){
			btInsertRecords.Brand_Name__c=brandid;
			btInsertRecords.Agency_Name__c = agencyid;
			btInsertRecords.Year__c = Fyear;
			btInsertRecords.AF_Country__c = bonus_thresolds.bonusthresholds.AF_country__c;
			btInsertRecords.Id = bonus_thresolds.bonusthresholds.AF_Bonus_Threshold__c;
			countrySet.add(bonus_thresolds.bonusthresholds.AF_country__c);
			bonusInsertList.add(btInsertRecords);
		}
		if(bonus_thresolds.bonusthresholds.AF_Country__c==null){
			counter++;
			Apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR,  Label.AF_Select_Country));
		}
	}
	}
	/*****************************************************************************************
*  @Description: this method is used to reload the page
*  @name : Reload
*  @param : none
*  @return: PageReference.
***********************************************************************************************/
	public PageReference Reload()
	{
		PageReference pageRef = ApexPages.currentPage();
		pageRef.setRedirect(true);
		return pageRef;
	}
	/*****************************************************************************************
*  @Description: this method is used to calculate the Total of Traditional,digital,Adaptation
*  @name : CalculateTotal
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void CalculateTotal()
	{           
		Double calc =  (BrandEstimateObj.AF_Traditional__c + BrandEstimateObj.AF_Digital__c + BrandEstimateObj.AF_Adaptive__c);
		TotalDisplay = string.ValueOf(calc.round());
		TotalDisplayN=calc.round();
	}  
	/*****************************************************************************************
*  @Description: this method is used to display the poupup window
*  @name : showPopup
*  @param : none
*  @return: none.
***********************************************************************************************/ 
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
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_BrandEstiamte_Controller2,'showPopup',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());   
		} 
	}
	/*****************************************************************************************
*  @Description: this method is used to close the poupup window
*  @name : closePopup
*  @param : none
*  @return: none.
***********************************************************************************************/ 
	public void closePopup(){
		displayPopup=false;
	}
	/*****************************************************************************************
*  @Description: this method is used to close the poupup window
*  @name : showPopup1
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void showPopup1(){
		displayPopup1=true;
	}
	/*****************************************************************************************
*  @Description: this method is used to close the poupup window
*  @name : closePopup1
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void closePopup1(){
		displayPopup1=false;
	}
	/*****************************************************************************************
*  @Description: this method is used to display the poupup window
*  @name : showPopup2
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void showPopup2()
	{    
		displayPopup=false;
		displayPopup1=false;
		displayPopup2=true;
	}
	/*****************************************************************************************
*  @Description: this method is used to remove the comma from the figures
*  @name : CommaFilter
*  @param : none
*  @return: none.
***********************************************************************************************/
	private string CommaFilter(string value)
	{
		String localValue=value;
		if(localValue.contains(',') ){localValue = localValue.replaceAll(',','');}
		return localValue;       
	}
	/*****************************************************************************************
*  @Description: this method is used to update bonus is required or not for the BrandEstimate
*  @name : bonusCheck
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void bonusCheck(){
		list<AF_Bonus_Threshold__c> No_Bonus_thresholds=new list<AF_Bonus_Threshold__c>();
		if(NoBonusCheck){
			BrandEstimateObj.AF_No_Bonus__c = true;
		}
		else{
			BrandEstimateObj.AF_No_Bonus__c = false;
		}
		No_Bonus_thresholds=[Select Id from AF_Bonus_Threshold__c  where Brand_Name__c=:brandid.substring(0,15) and Agency_Name__c=:agencyid.substring(0,15) and Year__c=:Fyear];
		if(!BrandEstimateObj.AF_Pilot_Model__c && No_Bonus_thresholds.size()==0 && BrandEstimateObj.AF_No_Bonus__c){
			update BrandEstimateObj;
		}
		else if(!BrandEstimateObj.AF_Pilot_Model__c && No_Bonus_thresholds.size()==0 && !BrandEstimateObj.AF_No_Bonus__c ){
			NoBonusCheck = false;
			ispilotModel = false;
			bonusThresholdValidation();
			update BrandEstimateObj;
		}
		else{
			NoBonusCheck = false;
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Pilot_Model));  
		}
	}
	/*****************************************************************************************
*  @Description: this method is used to check the brandestimate is pilot
*  @name : checkpilot
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void checkpilot(){
		if(ispilotModel){
			getPilotmethod();
			showpilot=true;
		}else{
			try{
				delete BT_Remuneration;
				BrandEstimateObj.AF_Pilot_Model__c = ispilotModel;
				BrandEstimateObj.IsUpdate__c = false;
				update BrandEstimateObj;
				showpilot=false;
				R_Traditional=false;
				R_Digital=false;
				getPilotmethod();
				getMeasure();
			}
			catch(Exception e){
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),AF_BrandEstiamte_Controller2,'checkpilot',e.getMessage(),e.getTypeName(),e.getStackTraceString());
				ispilotModel=true;
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'Only '+BT_Remuneration[0].CreatedBy.Name+Label.AF_Uncheck_pilot));  
			}
		}
	}
	/*****************************************************************************************
*  @Description: this method is used to update the BrandEstimate as remuneration
*  @name : SaveBonusRemeneration
*  @param : none
*  @return: none.
***********************************************************************************************/
	public void SaveBonusRemeneration(){
		try{
			if(ispilotModel){
				if(R_Traditional || R_Digital)
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
						insert Remuneration_BT;
					}else{
						update Remuneration_BT1;
					}
					getPilotmethod();
					if(ispilotModel)
					apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Quantative_Bonus));  
				}
				else
				{
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,Label.AF_Select_Trad_Digital);
					ApexPages.addMessage(myMsg);
				}
			}
		}Catch(DmlException ex){
			if((ex.getMessage()).contains(AF_Constants.EXCEPTION_ENTITY_IS_LOCKED)){
				Apexpages.addmessage(new Apexpages.message(Apexpages.severity.error,system.label.AF_PiliotError_message));
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
			}
		}
	}
	/*****************************************************************************************
*  @Description: this class is a warpper class used to display the details
*  @name : wrapbonus
*  @param : none
*  @return: none.
***********************************************************************************************/
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