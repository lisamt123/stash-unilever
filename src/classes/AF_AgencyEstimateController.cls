/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_AgencyEstimateController
@CreateDate : 20/6/2014
@Description : This is a controller class for AF_AgencyEstimate Page, 
@			  IS USED TO DISPLAY THE AGENCYESTIMATE DIGITAL, TRADITIONAL,ADAPATION,AMOUNTS IN THE BASE FEE MATRIX.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_AgencyEstimateController
{
	public Boolean IsReadyforPO { get; set; }
	public Boolean fieldsReadOnly {get;set;}
	public Boolean isAgency{get;set;}
	public Boolean isCatFinance{get;set;}
	public Boolean catFieldsReadOnly {get;set;}
	public Boolean isCMCO {get;set;}
	public Boolean cmcoFieldsReadOnly {get;set;}
	public Boolean isControllerPro{get;set;}
	public Boolean isCMCOSuperUser{get;set;}
	public Boolean isCMCOReadyPOEdit{get;set;}
	public List<AF_CMCO__c> cmcoEditDateList{get;set;}
	public Boolean CMCORO{get;set;}
	//Record Members
	public AF_Agency_Estimate__c AgencyEstimate {get;set;}    
	public AF_Entity_Exception__c EntityException {get;set;}
	public list<AF_Entity_Exception__c> lst_EntityException=new list<AF_Entity_Exception__c>();
	public list<Entitywrapper>Wrapperlist {get;set;}
	public list<selectoption> Countrynames{get;set;}
	public Boolean IsEditMode {get;set;}   
	//Display Members
	public Double DisplayTotal {get;set;}
	public Boolean IsUpdate {get;set;}
	public Boolean IsInsert {get;set;}
	public string UnileverEntityName {get;set;}
	public string AgencyEntityName {get;set;}
	public Boolean DisplayExceptionList {get;set;}
	public Double EntityExceptionPercentage {get;set;}
	public Double EntityExceptionValue {get;set;}
	public string EntityExceptionCountry {get;set;}
	public string ExceptionId {get;set;}
	public Boolean isPOEditable{get;set;}
	public String delCountryId{get;set;}
	//Collection Members
	public List<AF_Comments__c> CommentsCollection {get;set;}
	public List<Document> DocumentsCollection {get;set;}
	public List<string> HistoryCollection {get;set;}
	public List<AF_Entity_Exception__c> EntityExceptionCollection {get;set;}
	public List<AF_Entity__c> UnileverEntity {get;set;}
	public Boolean IsCentralHub {get;set;} 
	public Boolean IsReadonlyPO{get;set;}
	public Boolean IsShowPOTab{get;set;}
	public String ParentId {get;set;}
	public String ParentRecordType {get;set;}
	public String ErrorMessage {get;set;}
	public AF_Comments__c CommentRecord {get;set;}
	public Boolean IsLocked {get;set;} 
	public Boolean IsError {get;set;}
	public String ActivePanel {get;set;}
	public Decimal TotalPercent{get;set;}
	public Decimal TotalValue{get;set;}
	public Decimal TotalLocal{get;set;}
	public Decimal TotalLocalUSD{get;set;}
	public Decimal PoNumber{get;set;}
	public Decimal PoValue{get;set;}
	public Integer posDelete{get;set;}
	public Boolean isAgencyEstEditable{get;set;}
	public Decimal traditionalUSD{get;set;}
	public Decimal DigitalUSD{get;set;}
	public Decimal AdaptationUSD{get;set;}
	public Boolean bConfirmBox{get;set;}
	public Decimal OverrideTotal{get;set;}
	public Decimal overrideTrad{get;set;}
	public Decimal overrideDigital{get;set;}
	public Decimal overrideAdapt{get;set;}
	public String overridePONumber{get;set;}
	public String brandEstQuarter;
	public Boolean POOverrideDisplay{get;set;}
	private static string className_STR=AF_AgencyEstimateController.class.getName();
	
	/**********************************************************************
*  @Description: this method is used to populate Traditional values 
   @			 and display in the page.
*  @name : TraditionalDisplay
*  @param : none
*  @return: String.
**********************************************************************/	
		
	public String TraditionalDisplay{     
		get{String result = '';
			if(AgencyEstimate .AF_Traditional__c != null){
				if(AgencyEstimate .AF_Traditional__c > 0) {
					result = AgencyEstimate .AF_Traditional__c.format();
				}
				else{
					result ='';
				}
			}return result;
		}
		set{
			value = CommaFilter(value);
			if(value != ''){
				AgencyEstimate .AF_Traditional__c = Integer.valueOf(value);
			}
			else{
				AgencyEstimate.AF_Traditional__c = 0.00;
			}
		}
	}
	/**********************************************************************
*  @Description: this method is used to populate Digital values 
   @			 and display in the page.
*  @name : DigitalDisplay
*  @param : none
*  @return: String.
**********************************************************************/		
	public String DigitalDisplay
	{        
		get{String result = '';
			if(AgencyEstimate.AF_Digital__c != null){
				if(AgencyEstimate .AF_Digital__c > 0) {
					result = AgencyEstimate .AF_Digital__c.format();
				}
				else{
					result ='';
				}
			}
			return result;
		}
		set{value = CommaFilter(value);
			if(value != ''){
				AgencyEstimate .AF_Digital__c = Integer.valueOf(value);
			}
			else{
				AgencyEstimate .AF_Digital__c = 0.00;
			}
		}        
	}
	/**********************************************************************
*  @Description: this method is used to populate Adaptation values 
   @			 and display in the page.
*  @name : AdaptationDisplay
*  @param : none
*  @return: String.
**********************************************************************/	
	public String AdaptationDisplay
	{
		get{String result = '';
			if(AgencyEstimate .AF_Adaptation__c != null)
			{if(AgencyEstimate.AF_Adaptation__c > 0) {
					result = AgencyEstimate.AF_Adaptation__c.format();
				}
				else{
					result ='';
				}
			}
			return result;
		}        
		set{value = CommaFilter(value);
			if(value != ''){
				AgencyEstimate.AF_Adaptation__c = Integer.valueOf(value);
			}
			else{
				AgencyEstimate.AF_Adaptation__c = 0.00;
			}
		}        
	}
	public String TotalDisplay
	{        
		get;
		set;
	}
	public decimal TotalDisplayN{get;set;}
	public List<AF_Entity_Exception__c> getDisplayEntityException()
	{               
		return EntityExceptionCollection;
	}
	public void clearErrorMsg(){
		ApexPages.getMessages().clear();
	}
	private string CommaFilter(string value)
	{
		String localValue=value;
		if(value.contains(',')){localValue = value.replaceAll(',','');}
		return localValue;       
	}
	/**********************************************************************
*  @Description: this method is used to set the Traditional,Digital,Adaptation values 
*  @name : SetDisplayValues
*  @param : none
*  @return: none
**********************************************************************/	
	private void SetDisplayValues()
	{
		DigitalDisplay = String.valueof(AgencyEstimate.AF_Digital__c);
		TraditionalDisplay = String.valueof(AgencyEstimate.AF_Traditional__c);
		AdaptationDisplay = String.valueof(AgencyEstimate.AF_Adaptation__c);
		if(AgencyEstimate.AF_Traditional_Local__c != null){
			AgencyEstimate.AF_Traditional_Local__c = Double.valueof(AgencyEstimate.AF_Traditional_Local__c); 
			AgencyEstimate.AF_Traditional_Local__c = Double.valueof(AgencyEstimate.AF_Traditional_Local__c.setscale(0));
		}
		if(AgencyEstimate.AF_Digital_Local__c != null){
			AgencyEstimate.AF_Digital_Local__c = Double.valueof(AgencyEstimate.AF_Digital_Local__c);
			AgencyEstimate.AF_Digital_Local__c = Double.valueof(AgencyEstimate.AF_Digital_Local__c.setscale(0));
		}
		if(AgencyEstimate.AF_Adaptation_Local__c != null){
			AgencyEstimate.AF_Adaptation_Local__c = Double.valueof(AgencyEstimate.AF_Adaptation_Local__c);
			AgencyEstimate.AF_Adaptation_Local__c = Double.valueof(AgencyEstimate.AF_Adaptation_Local__c.setscale(0));
		}
		if(AgencyEstimate.AF_Traditional_Local__c!=null){
			TotalLocal=AgencyEstimate.AF_Traditional_Local__c+AgencyEstimate.AF_Digital_Local__c+AgencyEstimate.AF_Adaptation_Local__c;
		}
		//Chnage for displaying one more row for ready for PoNumber
		if(AgencyEstimate.Traditional_USD_Formula__c != null){traditionalUSD = AgencyEstimate.Traditional_USD_Formula__c;}
		if(AgencyEstimate.AF_Digital_USD_Formula__c != null){DigitalUSD = Double.valueof(AgencyEstimate.AF_Digital_USD_Formula__c.setscale(0));}
		if(AgencyEstimate.Adaptation_USD_Formula__c != null){AdaptationUSD = Double.valueof(AgencyEstimate.Adaptation_USD_Formula__c.setscale(0));}
		if(AgencyEstimate.Traditional_USD_Formula__c!=null){
			TotalLocalUSD=AgencyEstimate.Traditional_USD_Formula__c+AgencyEstimate.AF_Digital_USD_Formula__c+AgencyEstimate.Adaptation_USD_Formula__c;
		}
	}
	public user LoggedinUser{set;get;}
	public boolean SubmitButtonDisplay {set;get;}
	public AF_PO_Report__c poReportObj{get;set;}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_AgencyEstimateController
*  @param : none
*  @return : none
*************************************************************************/      
	public AF_AgencyEstimateController()
	{           
		isCMCOSuperUser = false;
		isCMCO = false;
		cmcoFieldsReadOnly = false;
		isAgency = false;
		fieldsReadOnly = false;
		catFieldsReadOnly=false;
		isCatFinance = false;
		IsShowPOTab=false;
		IsReadonlyPO=false;
		IsEditMode=true;
		TotalPercent=0;
		TotalValue=0;
		TotalLocal=0;
		IsReadyforPO=false;
		PoNumber=0;
		PoValue=0;
		isPOEditable=false;
		isAgencyEstEditable=false;
		isControllerPro = false;
		posDelete =0;
		CMCORO = false;
		IsCentralHub = true; 
		ActivePanel=AF_Constants.AGENCY_ESTIMATE;
		ParentId = ApexPages.currentPage().getParameters().get('Id');    
		GetCountry();
		EntityException = new AF_Entity_Exception__c(); 
		Wrapperlist =new  list<Entitywrapper>();
		isCMCOReadyPOEdit = false;
		bConfirmBox = false;
		cmcoEditDateList = new List<AF_CMCO__c>();
		CallEntityWrapper();
		poReportObj = new AF_PO_Report__c();
		OverrideTotal=0;
		brandEstQuarter='';
		POOverrideDisplay = false;
		identifyLoggedUser();
		cmcoEditDateList = [SELECT AF_CMCO_Rights__c FROM AF_CMCO__c LIMIT 1];
		if(cmcoEditDateList.size()>0){
			if(cmcoEditDateList[0].AF_CMCO_Rights__c){
				isCMCOReadyPOEdit = true;
			}
		}   
		if(ApexPages.currentPage().getParameters().get('Id') != null)
		{
			constructorExt();
			      
		}
		else
		{
			if(ApexPages.currentPage().getParameters().get('bid') != null && ApexPages.currentPage().getParameters().get('aid') != null && ApexPages.currentPage().getParameters().get('uid') != null)
			{
				IsUpdate = false;
				IsInsert = true;
				IsCentralHub = false;
				AgencyEstimate = new AF_Agency_Estimate__c();                   
				AgencyEstimate.AF_Brand_Estimate__c = ApexPages.currentPage().getParameters().get('bid'); 
				AgencyEstimate.AF_Unilever_Entity__c = ApexPages.currentPage().getParameters().get('uid');
				AgencyEstimate.AF_Agency_Entity__c = ApexPages.currentPage().getParameters().get('aid');  
				UnileverEntityName = AF_Utils.EntityNameValue(ApexPages.currentPage().getParameters().get('uid'));
				AgencyEntityName = AF_Utils.EntityNameValue(ApexPages.currentPage().getParameters().get('aid'));                                                
			}                
		}
		if((AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WITH_AGENCY&& LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY) || 
				(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c==AF_Constants.CATEGORY_FINANCE && LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE) ||
				LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER)
		{
			SubmitButtonDisplay=true;            
		}
		Else
		{
			SubmitButtonDisplay=false;
		} 
	}
		/**********************************************************************
*  @Description: this method is used as an constructor extension,and holds the logic of
				 identifying the logged in user and also give the access of readonly and 
				 edit depending on the user 
*  @name : constructorExt
*  @param : none
*  @return: none
**********************************************************************/	
	public void constructorExt(){
		IsUpdate = true;
			IsInsert = false;               
			AgencyEstimate = [SELECT Id,AF_OverridePO_Adaptation_LC__c,AF_OverridePO_Digital_LC__c,AF_OverridePO_Traditional_LC__c,AF_Category_Finance_Flag__c,AF_Total_USD__c,AF_Total_Local__c,Traditional_USD_Formula__c,AF_Digital_USD_Formula__c,Adaptation_USD_Formula__c,AF_IsCrossborder__c,AF_Ready_For_PO_Entry_Currency__c,AF_Agency_Spot_Rate__c,AF_Quarter_PO_Raised__c,AF_PO_Value__c,AF_Adaptation__c,AF_PO_Number__c,AF_Brand_Estimate__r.AF_CMCO_Rejected__c,AF_Brand_Estimate__r.AF_Basefee_Estimate_Initial_Quarter__c,AF_Brand_Estimate__r.AF_Status_Base_Fees__c,AF_Is_Unilever_Central_Hub__c,AF_CentralBilling__c, AF_Unilever_Entity_Name__c,AF_Agency_Entity_Name__c,AF_isLocked__c, AF_Digital__c, AF_Traditional__c,AF_Agency_Entity__c,AF_Unilever_Entity__c,AF_Total__c,AF_Matrix_Data_Entry_Currency__c, AF_Traditional_Local__c, AF_Digital_Local__c, AF_Adaptation_Local__c,AF_Agency_Exchange_Rate__c,AF_CentralBillingMessage__c,AF_LC_Traditional__c,AF_LC_Digital__c,AF_LC_Adaptation__c,AF_LC_Total__c  FROM AF_Agency_Estimate__c WHERE Id = : ParentId];
			EntityExceptionCollection = [SELECT Id, AF_Agency_Estimate__c, AF_Value_Euro__c,AF_Value__c,AF_Country__c FROM AF_Entity_Exception__c where AF_Agency_Estimate__c = : ParentId];
			if(EntityExceptionCollection != null){if(EntityExceptionCollection.size() > 0){DisplayExceptionList = true;}}            
			if(AgencyEstimate != null)
			{      
				UnileverEntityName = AgencyEstimate.AF_Unilever_Entity_Name__c;
				AgencyEntityName = AgencyEstimate.AF_Agency_Entity_Name__c;
				IsCentralHub = AgencyEstimate.AF_CentralBilling__c;
				if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_READYFORPO){
					IsReadyforPO=true;
					if(AgencyEstimate.AF_Quarter_PO_Raised__c!=null){
						PoValue=(AgencyEstimate.AF_Quarter_PO_Raised__c);
					}
				}else{
					SetDisplayValues();
				}
				//Added by Reetha for access rights of agency Users
				if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WITH_AGENCY){
					fieldsReadOnly = true;
				}
				if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c==AF_Constants.CATEGORY_FINANCE){
					catFieldsReadOnly = true;
				}
				if(AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c==AF_Constants.BASE_FEES_WIHTCMCO){
					cmcoFieldsReadOnly = true;
				}
				if(AgencyEstimate.AF_Brand_Estimate__r.AF_Basefee_Estimate_Initial_Quarter__c!=null){
					brandEstQuarter = AgencyEstimate.AF_Brand_Estimate__r.AF_Basefee_Estimate_Initial_Quarter__c;
					if(!brandEstQuarter.contains(AF_Constants.QUARTER4)){
						POOverrideDisplay = true;
					}
				}
				if(AgencyEstimate.AF_isLocked__c == null || !AgencyEstimate.AF_isLocked__c)IsLocked = true;else{IsLocked = false;}
				CalculateTotal();
				if(AgencyEstimate.af_total__c >0)
				{
					IsEditMode=true;
				}
				else
				{
					IsEditMode=true;
				}
				try{
					poReportObj = [SELECT AF_Calculate_Tradition_Local__c,AF_Calculate_Adaptation_Local__c,AF_Calculate_Digital_Local__c,AF_PO_Value_Total_LC__c from AF_PO_Report__c where AF_Agency_Estimate_ID__c=:ParentId];
				}
				catch(Exception ex){
					AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'AF_AgencyEstimateController',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
					apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_QueryFailed));
				}
				if(AgencyEstimate.AF_OverridePO_Adaptation_LC__c!=null)
				OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Adaptation_LC__c;
				if(AgencyEstimate.AF_OverridePO_Digital_LC__c!=null)
				OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Digital_LC__c; 
				if(AgencyEstimate.AF_OverridePO_Traditional_LC__c!=null)
				OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Traditional_LC__c;
				overrideTrad =  AgencyEstimate.AF_OverridePO_Traditional_LC__c;
				overrideDigital = AgencyEstimate.AF_OverridePO_Digital_LC__c;
				overrideAdapt = AgencyEstimate.AF_OverridePO_Adaptation_LC__c;
				overridePONumber = AgencyEstimate.AF_PO_Number__c;
			}  
	}
		/**********************************************************************
*  @Description: this method is used identify which user has logged in to the application,
				 depending on the logged in user ,making the UI visiblity
*  @name : identifyLoggedUser
*  @param : none
*  @return: none
**********************************************************************/	
	public void identifyLoggedUser(){
		LoggedinUser=[SELECT id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c,profile.name  FROM  User  WHERE id=:Userinfo.getuserid()   AND IsActive=true  ORDER BY CreatedDate LIMIT 50000];             
		if(LoggedinUser.AF_Agency_Fees_User_Type__c!=null){
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_REGIONAL_CATEGORY_FINANCE){
				isPOEditable=true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY ){
				isAgencyEstEditable=true;
			} 
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_PROCUREMENT  ||  LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
				IsReadonlyPO=true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE|| LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_PROCUREMENT || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_REGIONAL_CATEGORY_FINANCE||LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY ){
				IsShowPOTab=true;
			}  
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
				isAgency= true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE){
				isCatFinance= true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER){
				isCMCO= true;
				CMCORO=true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_PROCUREMENT || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER){
				isControllerPro = true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER){
				isCMCOSuperUser = true;
			}
		}
	}
	/**********************************************************************
*  @Description: this method is used to call the wrapper method 
*  @name : getupdatedC_breakdown
*  @param : none
*  @return: none
**********************************************************************/	
	public void getupdatedC_breakdown(){
		Wrapperlist.clear();
		CallEntityWrapper(); 
	}
	/**********************************************************************
*  @Description: this method is used to populate the wrapper with values 
*  @name : CallEntityWrapper
*  @param : none
*  @return: none
**********************************************************************/	
	public void CallEntityWrapper(){
		Wrapperlist.clear();
		TotalPercent=0;
		TotalValue=0;
		Integer wrapperPos=-1;
		Wrapperlist =new  list<Entitywrapper>();
		lst_EntityException =[Select id,name,AF_Country__c,AF_Agency_Estimate__c,AF_Value__c,AF_Value_Euro__c from AF_Entity_Exception__c where AF_Agency_Estimate__c=:ParentId ];
		if(lst_EntityException.size()>0){
			for(AF_Entity_Exception__c Entity_exc:lst_EntityException){
				wrapperPos++;
				if(Entity_exc.AF_Value__c!=null){
					TotalPercent=TotalPercent+Entity_exc.AF_Value__c;
				}
				if(Entity_exc.AF_Value_Euro__c!=Null){
					TotalValue= TotalValue+Entity_exc.AF_Value_Euro__c;
				}
				Wrapperlist.add(new Entitywrapper(Entity_exc,true,wrapperPos));
			}
		}    
	}
	/**********************************************************************
*  @Description: this method is get and display the Unilever Entities 
*  @name : getUnileverEntities
*  @param : none
*  @return: List of Select Options.
**********************************************************************/	
	public List<SelectOption> getUnileverEntities()
	{
		UnileverEntity = [SELECT id, name FROM AF_Entity__c LIMIT 50];
		List<SelectOption> UEList = new List<SelectOption>();
		for(AF_Entity__c afe : UnileverEntity)
		{           
			UEList.add(new SelectOption(afe.Name,afe.Name));
		}
		return UEList;
	}
	/**********************************************************************
*  @Description: this method is to display the confirmation box 
*  @name : confirmBox
*  @param : none
*  @return: none.
**********************************************************************/	
	public void confirmBox(){
		bConfirmBox = true;
	}
	/**********************************************************************
*  @Description: this method is to close the confirmation box 
*  @name : closePopupReject
*  @param : none
*  @return: none.
**********************************************************************/	
	public void closePopupReject(){
		bConfirmBox = false;
	}
	/**********************************************************************
*  @Description: this method is used to update the PO Number
*  @name : UpdatPO
*  @param : none
*  @return: none.
**********************************************************************/
	public void UpdatPO(){
		if(AgencyEstimate.AF_PO_Number__c!=null){
			if(overrideTrad != AgencyEstimate.AF_OverridePO_Traditional_LC__c)
			AgencyEstimate.AF_OverridePO_Traditional_LC__c = overrideTrad;
			if(overrideDigital != AgencyEstimate.AF_OverridePO_Digital_LC__c)
			AgencyEstimate.AF_OverridePO_Digital_LC__c = overrideDigital;
			if(overrideAdapt != AgencyEstimate.AF_OverridePO_Adaptation_LC__c)
			AgencyEstimate.AF_OverridePO_Adaptation_LC__c = overrideAdapt;
			try{
			update AgencyEstimate;
			overridePONumber = AgencyEstimate.AF_PO_Number__c;
			apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,Label.AF_Record_saved));
			}
			catch(Exception e)
        	{
            	AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'UpdatPO',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            	apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
        	}	
		}    
	}
	/**********************************************************************
*  @Description: this method is used to override the PO Number
*  @name : OverridePO
*  @param : none
*  @return: none.
**********************************************************************/
	public void OverridePO(){
		OverrideTotal=0;
		Boolean errMsgOverride=false;
		bConfirmBox = false;
		if(overridePONumber != AgencyEstimate.AF_PO_Number__c)
		AgencyEstimate.AF_PO_Number__c = overridePONumber;
		if(AgencyEstimate.AF_OverridePO_Adaptation_LC__c!=null)
		OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Adaptation_LC__c;
		if(AgencyEstimate.AF_OverridePO_Digital_LC__c!=null)
		OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Digital_LC__c;
		if(AgencyEstimate.AF_OverridePO_Traditional_LC__c!=null)
		OverrideTotal = OverrideTotal + AgencyEstimate.AF_OverridePO_Traditional_LC__c;
		if(OverrideTotal>AgencyEstimate.AF_LC_Total__c){
			errMsgOverride=true;
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Pooveride));
		}
		if(!errMsgOverride){
			update AgencyEstimate;
			overrideTrad =  AgencyEstimate.AF_OverridePO_Traditional_LC__c;
			overrideDigital =  AgencyEstimate.AF_OverridePO_Digital_LC__c;
			overrideAdapt =  AgencyEstimate.AF_OverridePO_Adaptation_LC__c;
			try{
				poReportObj = [SELECT AF_Calculate_Tradition_Local__c,AF_Calculate_Adaptation_Local__c,AF_Calculate_Digital_Local__c,AF_PO_Value_Total_LC__c from AF_PO_Report__c where AF_Agency_Estimate_ID__c=:ParentId];
			}
			catch(Exception ex){
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'OverridePO',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_QueryFailed));
			}
			apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,Label.AF_Record_saved)); 
		}
	}
	/**********************************************************************
*  @Description: this method is used to update/insert the Traditional,Digital and 
   @			 Adapation values to AgencyEstimate
*  @name : Save
*  @param : none
*  @return: PageReference.
**********************************************************************/	
	public PageReference Save()
	{        
		PageReference pageRef;          
		try
		{
			upsert AgencyEstimate;
			apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,Label.AF_Record_saved));    
		}
		catch(DMLException ex)
		{
			pageRef = new PageReference(AF_Constants.CLOSE_REFRESH);
			pageRef.setRedirect(true);        
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'Save',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());    
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert));  
		}
		return pageRef;
	}
	/**********************************************************************
*  @Description: this method is used to update/insert the Traditional,Digital and 
   @			 Adapation values to AgencyEstimate
*  @name : JustSave
*  @param : none
*  @return: PageReference.
**********************************************************************/		
	public PageReference JustSave()
	{        
		PageReference pageRef;          
		try
		{
			CalculateTotal();
			IsEditMode=True;
			TraditionalDisplay = TraditionalDisplay.Remove(',');
			DigitalDisplay = DigitalDisplay.Remove(',');
			AdaptationDisplay = AdaptationDisplay.Remove(',');
			if((AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c == AF_Constants.CATEGORY_FINANCE && isCatFinance)
				||AgencyEstimate.AF_Brand_Estimate__r.AF_Status_Base_Fees__c == AF_Constants.BASE_FEES_WIHTCMCO && (isCMCO||isCMCOSuperUser))
			AgencyEstimate.AF_Category_Finance_Flag__c=true;
			upsert AgencyEstimate;
			UpdateEntityEX();
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.AF_AgencyEstimateSuccess);
			ApexPages.addMessage(myMsg);
			if(IsCentralHub)  ActivePanel=AF_Constants.COUNTRY_BREAKDOWN;
			return null; 
		}
		catch(Exception ex)
		
		{
			String str = ex.getMessage();
			if(str.contains(AF_Constants.DML_EXCEPTION)){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_Record_Unsaved));
			}
			else if(str.contains(AF_Constants.NO_ACCESS_EXCEPTION)){
				ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,Label.AF_User_Access));
			}
			return null;            
		}
		return pageRef;
	}
	/**********************************************************************
*  @Description: this method is used to update the Entity Exception			 
*  @name : UpdateEntityEX
*  @param : none
*  @return: none.
**********************************************************************/		
	public void UpdateEntityEX(){
		if( IsCentralHub){
			list<AF_Entity_Exception__c>getoldetityexc=[Select id,name,AF_Country__c,AF_Agency_Estimate__c,AF_Value__c,AF_Value_Euro__c from AF_Entity_Exception__c where AF_Agency_Estimate__c=:ParentId ];
			list<AF_Entity_Exception__c>updatedenitytexception=new list<AF_Entity_Exception__c>();
			if(getoldetityexc.size()>0){
				for(AF_Entity_Exception__c Entity_exc1:getoldetityexc){
					if(Entity_exc1.AF_Value__c!=null){
						Entity_exc1.AF_Value_Euro__c=Entity_exc1.AF_Value__c*TotalDisplayN/100;
						updatedenitytexception.add(Entity_exc1);
					}
				}
			}
			if(updatedenitytexception.size()>0){
				try{
				update updatedenitytexception;
				}
				catch(Exception e)
        		{
            		AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'UpdateEntityEX',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            		apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
       			}
			}
			Wrapperlist.clear();
			TotalPercent=0;
			TotalValue=0; 
			Integer wrapperPos=-1;
			lst_EntityException =[Select id,name,AF_Country__c,AF_Agency_Estimate__c,AF_Value__c,AF_Value_Euro__c from AF_Entity_Exception__c where AF_Agency_Estimate__c=:ParentId ];
			if(lst_EntityException.size()>0){
				for(AF_Entity_Exception__c Entity_exc:lst_EntityException){
					wrapperPos++;
					if(Entity_exc.AF_Value__c!=null){
						TotalPercent=TotalPercent+Entity_exc.AF_Value__c;
					}
					if(Entity_exc.AF_Value_Euro__c!=Null){
						TotalValue= TotalValue+Entity_exc.AF_Value_Euro__c;
					}
					Wrapperlist.add(new Entitywrapper(Entity_exc,true,wrapperPos));
				}
			}    
		}
	} 
	/**********************************************************************
*  @Description: this method is used to delete the Entity exception			 
*  @name : delCounrtyRecord
*  @param : none
*  @return: none.
**********************************************************************/	
	public void delCounrtyRecord(){
		if(delCountryId!=''){
			AF_Entity_Exception__c delEntity = new AF_Entity_Exception__c();
			delEntity = [SELECT Id FROM AF_Entity_Exception__c WHERE Id=:delCountryId];
			try{
			delete delEntity;
			}
			catch(Exception e)
        	{
            	AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'delCounrtyRecord',e.getMessage(),e.getTypeName(),e.getStackTraceString());
            	apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete)); 
        	}
			Integer counter=-1;
			for(Entitywrapper ent:Wrapperlist){
				counter++;
				if(ent.EntityEx.Id == delCountryId){
					TotalPercent = (TotalPercent - ent.EntityEx.AF_Value__c);
					TotalValue = (TotalValue - ent.EntityEx.AF_Value_Euro__c);
					break;
				}
			}
			Wrapperlist.remove(counter);
		}
		else{
			Integer counterWrapper=-1;
			for(Entitywrapper ent:Wrapperlist){
				counterWrapper++;
				if(!ent.del && ent.position == posDelete){
					break;
				}
			}
			Wrapperlist.remove(counterWrapper);
		}
	}
	/**********************************************************************
*  @Description: this method is used to insert the Entity exception			 
*  @name : SaveEntityException
*  @param : none
*  @return: PageReference.
**********************************************************************/	
	public PageReference SaveEntityException()
	{
		PageReference pageRef;                         
		try
		{                       
			EntityException.AF_Agency_Estimate__c = ParentId;                               
			insert EntityException;
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,system.label.AF_EntityException);
			ApexPages.addMessage(myMsg);
			return null;
		}
		catch(DMLException ex)
		{
			ApexPages.addMessages(ex);
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SaveEntityException',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());     
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
			pageRef = null;
		}
		return pageRef;         
	}
	/**********************************************************************
*  @Description: this method is used to call the CalculateTotal	method	 
*  @name : UpdateDisplayTotal
*  @param : none
*  @return: PageReference.
**********************************************************************/		
	public PageReference UpdateDisplayTotal() 
	{
		CalculateTotal();    
		return null;
	}
	/**********************************************************************
*  @Description: this method is used enable the record in edit mode	 
*  @name : NowInEditMode
*  @param : none
*  @return: PageReference.
**********************************************************************/
	public PageReference NowInEditMode()
	{
		IsEditMode=true;
		return null;
	}
	/**********************************************************************
*  @Description: this method is used to calculate the local currency for
   @			 Traditional,Digital and Adaptation values 
*  @name : CalculateTotal
*  @param : none
*  @return: none.
**********************************************************************/
	public void CalculateTotal()
	{
		Double calc =  (AgencyEstimate .AF_Traditional__c + AgencyEstimate .AF_Digital__c + AgencyEstimate .AF_Adaptation__c);
		DisplayTotal = (calc.round());
		TotalDisplayN=calc.round(); 
		if(AgencyEstimate.AF_Agency_Exchange_Rate__c!=null && !IsReadyforPO){
			AgencyEstimate.AF_Digital_Local__c=AgencyEstimate.AF_Agency_Exchange_Rate__c* AgencyEstimate .AF_Digital__c;
			AgencyEstimate.AF_Traditional_Local__c= AgencyEstimate.AF_Agency_Exchange_Rate__c*AgencyEstimate .AF_Traditional__c;
			AgencyEstimate.AF_Adaptation_Local__c=AgencyEstimate.AF_Agency_Exchange_Rate__c*AgencyEstimate .AF_Adaptation__c ; 
			TotalLocal=AgencyEstimate.AF_Digital_Local__c+  AgencyEstimate.AF_Traditional_Local__c+ AgencyEstimate.AF_Adaptation_Local__c;
		}else{
			TotalLocal=AgencyEstimate.AF_Total_Local__c;
		}  
	}
	/**********************************************************************
*  @Description: this method is used to reload the page
*  @name : Reload
*  @param : none
*  @return: PageReference.
**********************************************************************/
	public PageReference Reload()
	{
		PageReference pageRef = ApexPages.currentPage();
		pageRef.setRedirect(true);
		return pageRef;
	}
	/**********************************************************************
*  @Description: this method is used to delete the Entity Exception
*  @name : DeleteEntityException
*  @param : none
*  @return: none.
**********************************************************************/
	public void DeleteEntityException(){
		AF_Entity_Exception__c delEntityException = new AF_Entity_Exception__c(Id=ExceptionId);
		delete delEntityException;          
	}
	public PageReference DeleteException()
	{
		PageReference pageRef;
		try
		{   
			AF_Entity_Exception__c delEntityException = new AF_Entity_Exception__c(Id=ExceptionId);
			delete delEntityException;
			pageRef = ApexPages.currentPage();
			pageRef.setRedirect(true);
		}
		catch(DMLException ex)
		{
			ApexPages.addMessages(ex);
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(), className_STR,'DeleteException',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());  
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete));    
			pageRef = new PageReference(AF_Constants.CLOSE_REFRESH);
			pageRef.setRedirect(true);
			pageRef = null;             
		}
		return pageRef;
	}
	/**********************************************************************
*  @Description: this method is used to add comment
*  @name : AddComment
*  @param : none
*  @return: PageReference.
**********************************************************************/
	public PageReference AddComment()
	{
		PageReference pageRef = new PageReference(AF_Constants.ADD_COMMENT + ParentId);
		pageRef.setRedirect(true);
		return pageRef;
	}
	//supporting classes
	public class CustomException extends Exception {}
	/**********************************************************************
*  @Description: this method is used to get the country list avaliable in the
   @				 Entity Exception.
*  @name : getCountry
*  @param : none
*  @return: List of SelectOption.
**********************************************************************/		
	public List<SelectOption> getCountry(){
		Schema.sObjectType sobject_type = AF_Entity_Exception__c.getSObjectType();
		Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
		Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
		List<Schema.PicklistEntry> pick_list_values = field_map.get(AF_Constants.COUNTRY).getDescribe().getPickListValues();
		Countrynames = new List<SelectOption>();
		Countrynames.add(new selectoption('',AF_Constants.AF_COUNTRY_DELIM));
		for (Schema.PicklistEntry a : pick_list_values) {
			Countrynames.add(new selectOption(a.getValue(), a.getValue()));
		}
		return Countrynames;
	} 
	/**********************************************************************
*  @Description: this method is used to add new row to add the Entity Exception
*  @name : AddNewRow
*  @param : none
*  @return: none.
**********************************************************************/	
	public void AddNewRow(){
		CalculateCountryValue();
		AF_Entity_Exception__c  entity_ex=new AF_Entity_Exception__c();
		Integer wrapperSize =  Wrapperlist.size();
		Wrapperlist.add(new Entitywrapper(entity_ex,false,wrapperSize));
	}
	/**********************************************************************
*  @Description: this method is used to for calculating the Entity Exception
   @			 percentage.
*  @name : CalculateCountryValue
*  @param : none
*  @return: none.
**********************************************************************/	
	public void CalculateCountryValue(){
		TotalPercent=0;
		TotalValue=0;
		for(Entitywrapper ent_wrp:Wrapperlist){
			if(ent_wrp.EntityEx.AF_Value__c!=NUll){
				ent_wrp.EntityEx.AF_Value_Euro__c=TotalDisplayN*ent_wrp.EntityEx.AF_Value__c/100;
				TotalPercent=TotalPercent+ent_wrp.EntityEx.AF_Value__c;
				TotalValue=TotalValue+ ent_wrp.EntityEx.AF_Value_Euro__c;
			}
		}
	}
	/**********************************************************************
*  @Description: this method is used display the validation messages for the EntityException
*  @name : SaveEntityExceptionRecords
*  @param : none
*  @return: none.
**********************************************************************/		
	public void SaveEntityExceptionRecords(){
		CalculateCountryValue();
		list<AF_Entity_Exception__c >updated_entity_ex=new list<AF_Entity_Exception__c>();
		decimal totalper=0;
		Integer counter=0;
		Integer counterSave=0;
		try{
			for(integer i=0;i<Wrapperlist.size();i++){
				for(integer j=i+1;j<Wrapperlist.size();j++){
					if(Wrapperlist[i].EntityEx.AF_Country__c == Wrapperlist[j].EntityEx.AF_Country__c){
						counter++;
						apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Country_selected));
					}
				}
			}
			if(counter==0){
				for(Entitywrapper ent:Wrapperlist){
					AF_Entity_Exception__c  entity_ex_new=new AF_Entity_Exception__c();
					entity_ex_new.AF_Agency_Estimate__c=ParentId;
					entity_ex_new.AF_Country__c=ent.EntityEx.AF_Country__c;
					entity_ex_new.AF_Value__c=ent.EntityEx.AF_Value__c;
					entity_ex_new.AF_Value_Euro__c=ent.EntityEx.AF_Value_Euro__c;
					entity_ex_new.id=ent.EntityEx.id;
					totalper=totalper+ent.EntityEx.AF_Value__c;
					updated_entity_ex.add(entity_ex_new);
					if(ent.EntityEx.AF_Country__c==null){
						counterSave=1;
						Apexpages.addmessage(new apexpages.message(apexpages.severity.ERROR, Label.AF_Select_Country));
					}
				}
				if(counterSave==0){
					if(!(totalper>100)){
						upsert updated_entity_ex;
						apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,Label.AF_Record_saved)); 
						CallEntityWrapper();
					}
					else{
						apexpages.addmessage(new apexpages.message(apexpages.severity.Error,system.label.AF_Country_breakdown_percentage));  
					}
				}       
			}
		}
		catch(exception ex){
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SaveEntityExceptionRecords',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
		}
	}   
	/**********************************************************************
*  @Description: this is the Wrapper class to populate the EntityException
*  @name : Entitywrapper
*  @param : none
*  @return: none
**********************************************************************/  
	public class Entitywrapper{
		public AF_Entity_Exception__c EntityEx{get;set;}
		public Boolean Del{get;set;}
		public Integer position{get;set;}
		public Entitywrapper(AF_Entity_Exception__c EntityEx,Boolean Del,Integer pos){
			this.EntityEx=EntityEx;
			this.Del = Del;
			this.position = pos;
		}
	}
}