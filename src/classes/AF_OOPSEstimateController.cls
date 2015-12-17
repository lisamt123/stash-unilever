/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_OOPSEstimateController
   @CreateDate : 8/8/2014
   @Description : This is a controller class for AF_OOPSEstimate Page, 
   @			  this is used to override the OOPSEstimate.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_OOPSEstimateController {
	public String oopsEstimateId;
	public AF_OOPS_Estimate__c oopsEstimate {get;set;}
	public user loggedinuser{set;get;}
	public boolean Buttondisplay{set;get;}
	public Boolean IsReadyforPO{get;set;}
	public decimal EsLocal{get;set;}
	public boolean isPOEditable{get;set;}
	public Boolean IsReadonlyPO{get;set;}
	public Boolean IsShowPOTab{get;set;}
	public boolean isOopsEditable{get;set;}
	public AF_OOPS_Estimate__c polist{get;set;}
	public Boolean bConfirmBox{get;set;}
	public decimal overrideEstimate{get;set;}
	public String overridePONumber{get;set;}
	public Boolean isCMCOSuperUser{get;set;}
	public String oopsQuarter;
	public Boolean POOverrideDisplay1{get;set;}
	/***********************************************************************************
*  @Description: this method is used as a getter and setter method for OOPSEstimate records
*  @name : OppsEstimatesValue
*  @param : none
*  @return: String.
*************************************************************************************/
	public String OppsEstimatesValue{     
		get{
			String result = '';
			if(oopsEstimate.AF_Estimate__c!= null){
				if(oopsEstimate.AF_Estimate__c > 0) {
					result = oopsEstimate.AF_Estimate__c.format();
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
				oopsEstimate.AF_Estimate__c = Decimal.valueOf(value);
			}
			else{
				oopsEstimate.AF_Estimate__c = 0.00;
			}
		}
	}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_OOPSEstimateController
*  @param : none
*  @return : none
*************************************************************************/ 
	public AF_OOPSEstimateController(){
		IsReadyforPO=false;
		isPOEditable=false;
		IsShowPOTab=false;
		IsReadonlyPO=false;
		Buttondisplay=false;
		bConfirmBox = false;
		isCMCOSuperUser = false;
		POOverrideDisplay1 = false;
		oopsQuarter='';
		oopsEstimateId = System.currentPageReference().getParameters().get('id');
		oopsEstimate = [Select a.AF_PO_Number__c,a.AF_OOPS_Actual__r.Quarter__c,a.AF_OOPS_Matrix_Currency_Code__c, a.Name, a.AF_isComment__c,AF_EstimateLocal__c,AF_OOPS_Actual__r.AF_Status__c, a.Unilever_Entity_Name__c,a.AF_Unilever_Entity__c, a.AF_Unilever_Entity_Column_Name__c, a.AF_Status__c, a.AF_Rate_Type__c, a.AF_Rate_Currency__c, a.AF_Quarter__c, a.AF_Overall_OOPS__c, a.AF_OOPS_Actual__c, a.AF_Locked__c, a.AF_Is_Crossborder_Wk__c, a.AF_IsCrossBorder__c, a.AF_Fiscal_Year__c, a.AF_Estimate__c, a.AF_Estimate_Local__c, a.AF_Brand_Estimate__c, a.AF_Archived__c, a.AF_Agreed_Base_Fees__c, a.AF_Agency_Spot_Rate__c, a.AF_Agency_Exchange_Rate__c, a.AF_Agency_Entity__c, a.AF_Agency_Entity_Column_Name__c, a.AF_Agency_Account__c,a.Agency_Entity_Name__c,AF_Ready_For_PO_Exchange_Rate__c From AF_OOPS_Estimate__c a  where Id=: oopsEstimateId];        
		polist=[Select o.id,o.name,o.AF_PO_Number__c,AF_Override_Estimate_Local__c from AF_OOPS_Estimate__c o where Id=: oopsEstimateId];
		if(polist!=null){
			overrideEstimate = polist.AF_Override_Estimate_Local__c;
			overridePONumber= polist.AF_PO_Number__c;
		}
		LoggedinUser=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c,profile.name  from  User  where id=:Userinfo.getuserid()   and IsActive=true  Order by CreatedDate Limit 50000];             
		if(LoggedinUser.AF_Agency_Fees_User_Type__c!=null){
			if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Regional Category Finance'){
				isPOEditable=true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance' ){
				isOopsEditable=true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement'  || LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency'){
				IsReadonlyPO=true;
			}
			if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance'|| LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO User' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Procurement' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Controller' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Regional Category Finance' || LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency' ){
				IsShowPOTab=true;
			}  
			if(LoggedinUser.AF_Agency_Fees_User_Type__c=='CMCO Super User'){
				isCMCOSuperUser = true;
			}
		}
		if(oopsEstimate.AF_Estimate__c != null){oopsEstimate.AF_Estimate__c = oopsEstimate.AF_Estimate__c;oopsEstimate.AF_Estimate__c = oopsEstimate.AF_Estimate__c.setscale(2);}      
		EsLocal= oopsEstimate.AF_EstimateLocal__c;
		if(oopsEstimate.AF_OOPS_Actual__r.AF_Status__c=='with agency' && LoggedinUser.AF_Agency_Fees_User_Type__c=='Category Finance')
		{
			Buttondisplay=true;
		}
		Else if(oopsEstimate.AF_OOPS_Actual__r.AF_Status__c=='with category finance' && LoggedinUser.AF_Agency_Fees_User_Type__c=='Agency')
		{
			Buttondisplay=true;
		}
		Else
		{
			Buttondisplay=false;
		}
		if(oopsEstimate.AF_Status__c=='Ready for PO'){
			IsReadyforPO=true;
		}
		if(oopsEstimate.AF_OOPS_Actual__r.Quarter__c!=null){
			oopsQuarter = oopsEstimate.AF_OOPS_Actual__r.Quarter__c;
			if(!oopsQuarter.contains('Q4')){
				POOverrideDisplay1 = true;
			}
		}
	}
	/***********************************************************************************
*  @Description: this method is used to update/override the OOPSEstimate Amounts
*  @name : Save
*  @param : none
*  @return: PageReference.
*************************************************************************************/
	public PageReference Save()
	{        
		try
		{
			if(oopsEstimate.AF_Estimate__c != null){
				OppsEstimatesValue=OppsEstimatesValue.Remove(',');
				oopsEstimate.AF_Estimate__c = oopsEstimate.AF_Estimate__c;
				oopsEstimate.AF_Estimate__c = oopsEstimate.AF_Estimate__c.setscale(2);}
			AF_RecursiveTriggerHelper.setAlreadyModified();
			oopsEstimate.IsUpdate__c = true;   
			update oopsEstimate;
			CalculateLocalC();
			apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));  
		}
		catch(DMLException ex)
		{
		ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),'AF_OOPSEstimateController','Save',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		}
		return null;
	}
	/***********************************************************************************
*  @Description: this method is used to replace the commas in the amounts
*  @name : CommaFilter
*  @param : value
*  @return: string.
*************************************************************************************/
	private string CommaFilter(string value)
	{
		if(value.contains(',')){value = value.replaceAll(',','');}
		return value;       
	} 
	/***************************************************************************************
*  @Description: this method is used to calculate the local currency value of the override amt
*  @name : CalculateLocalC
*  @param : none
*  @return: none.
*****************************************************************************************/
	public void CalculateLocalC(){
		try{
			String oopsvalue=OppsEstimatesValue.Remove(',');
			EsLocal=Decimal.valueof(oopsvalue)*oopsEstimate.AF_Agency_Exchange_Rate__c;
		}
		Catch(exception e){
			ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),'AF_OOPSEstimateController','CalculateLocalC',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			if(OppsEstimatesValue==''){
				EsLocal=null;
			}
		}
	}
	/***************************************************************************************
*  @Description: this method is used to update the OOPS PO Number
*  @name : SavePO
*  @param : none
*  @return: none.
*****************************************************************************************/ 
	public void SavePO(){
		if(polist.AF_PO_Number__c != null){
			if(overrideEstimate != polist.AF_Override_Estimate_Local__c)
			polist.AF_Override_Estimate_Local__c = overrideEstimate;
			update polist;
			overridePONumber = polist.AF_PO_Number__c;
			apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved')); 
		}      
	}
	/***************************************************************************************
*  @Description: this method is used to display the confirmation popup
*  @name : confirmBox
*  @param : none
*  @return: none.
*****************************************************************************************/ 
	public void confirmBox(){
		bConfirmBox = true;
	}
	/***************************************************************************************
*  @Description: this method is used to close the confirmation popup
*  @name : closePopupReject
*  @param : none
*  @return: none.
*****************************************************************************************/ 
	public void closePopupReject(){
		bConfirmBox = false;
	}
	/***************************************************************************************
*  @Description: this method is used to override the PO Number
*  @name : OverridePO
*  @param : none
*  @return: none.
*****************************************************************************************/
	public void OverridePO(){
		bConfirmBox = false;
		if(overridePONumber != polist.AF_PO_Number__c)
		polist.AF_PO_Number__c = overridePONumber;
		if(polist.AF_Override_Estimate_Local__c > EsLocal){
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,'You cannot enter amount greater than local value')); 
		}
		else{
			update polist;
			overrideEstimate = polist.AF_Override_Estimate_Local__c;
			apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,'Record successfully saved'));
		}   
	}
}