/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_BonusMatrixOverrideController
   @CreateDate : 19/7/2014
   @Description : This is a controller class for AF_BonusEstimate Page, 
   @			  this is used to override the Bonus Estimate value.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_BonusMatrixOverrideController 
{
	public string ParentId {get;set;}
	public AF_Bonus_Matrix__c BonusMatrixObj {get;set;}
	public decimal EsLocal{get;set;}
	public decimal TotalBonusValue;
	public String brandid;
	public String agencyid;
	public String fyear;
	public Boolean IsReadonlyPO{get;set;}
	public Boolean IsShowPOTab{get;set;}
	public set<String> bonusresultid=new set<String>();
	public list<AF_Bonus_Matrix__c>listofbonusmatrix=new list<AF_Bonus_Matrix__c>();
	public list<AF_Bonus_Results__C>listofbonusresult=new list<AF_Bonus_Results__C>();
	public decimal totalMatrixbonus;
	public decimal totalbonusresult;
	public Boolean IsReadyforPO{get;set;}
	public user LoggedinUser{set;get;}
	public boolean SubmitButtonDisplay {set;get;}
	public boolean isPOEditable{get;set;}
	public boolean isBonusEstimateEdit{get;set;}
	public string bonus_summaryid;
	private static string className_STR=AF_BonusMatrixOverrideController.class.getName();
	
	/**********************************************************************
*  @Description: this method is used to get and set the BonusEstimate value.
*  @name : BonusMatrixValue
*  @param : none
*  @return: String.
**********************************************************************/
	public String BonusMatrixValue{     
		get{String result = '';if(BonusMatrixObj.AF_Value__c!= null){
				if(BonusMatrixObj.AF_Value__c > 0) {
					result = BonusMatrixObj.AF_Value__c.format();
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
				BonusMatrixObj.AF_Value__c = Decimal.valueOf(value);
			}
			else{
				BonusMatrixObj.AF_Value__c = 0.00;
			}
		}
	}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_BonusMatrixOverrideController
*  @param : none
*  @return : none
*************************************************************************/ 
	public AF_BonusMatrixOverrideController()
	{
		try   
		{
			bonus_summaryid='';
			IsShowPOTab=false;
			IsReadonlyPO=false;    
			TotalBonusValue=0;  
			totalMatrixbonus=0;  
			brandid='';
			agencyid='';
			fyear=''; 
			totalbonusresult=0; 
			IsReadyforPO=false; 
			isPOEditable=false;
			isBonusEstimateEdit=false;
			listofbonusmatrix=new list<AF_Bonus_Matrix__c >();
			listofbonusresult=new list<AF_Bonus_Results__C>();
			bonusresultid=new set<String>();
			LoggedinUser=[select id,IsActive,Username,Name,AF_Brand__c,AF_Agency_Fees_User_Type__c,profile.name  from  User  where id=:Userinfo.getuserid()   and IsActive=true  Order by CreatedDate Limit 50000];             
			if(LoggedinUser.AF_Agency_Fees_User_Type__c!=null){
				if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_REGIONAL_CATEGORY_FINANCE){
					isPOEditable=true;
				}
				if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE){
					isBonusEstimateEdit=true;
				}
				if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.BASE_FEES_PROCUREMENT   || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
					IsReadonlyPO=true;
				}
				if(LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCP_SUPERUSER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE|| LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CMCO_USER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.BASE_FEES_PROCUREMENT || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CONTROLLER || LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_REGIONAL_CATEGORY_FINANCE|| LoggedinUser.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY ){
					IsShowPOTab=true;
				}  
			}
			if(ApexPages.currentPage().getParameters().get('Id') != null)
			{
				ParentId = ApexPages.currentPage().getParameters().get('Id');
				BonusMatrixObj = [Select a.AF_Bonus_Summary__r.AF_Status__c,a.AF_Bonus_Summary__r.id,a.AF_Bonus_Results__r.id, a.AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Agency_Name__c,a.AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Brand_Name__c,a.PO_Number__c,a.Unilever_Entity_Name__c,a.Agency_Entity_Name__c,a.AF_Bonus_Local_Value__c, a.Name, a.LastViewedDate, a.IsDeleted, a.Id, a.Category__c, a.Brand__c, a.AF_Value__c, a.AF_Value_Local__c, a.AF_Unilever_Entity__c, a.AF_Unilever_Entity_Column_Name__c, a.AF_Status__c, a.AF_Rate_Type__c, a.AF_Rate_Currency__c, a.AF_IsCrossBorder__c, a.AF_Fiscal_Year__c, a.AF_Brand_Estimate__c, a.AF_Bonus_Summary__c, a.AF_Bonus_Results__c, a.AF_Agency_Spot_Rate__c, a.AF_Agency_Exchange_Rate__c, a.AF_Agency_Entity__c, a.AF_Bonus_Results__r.AF_Bonus_Value_Bm__c, a.AF_Agency_Entity_Column_Name__c From AF_Bonus_Matrix__c a WHERE Id =:ParentId LIMIT 1];                
				TotalBonusValue=BonusMatrixObj.AF_Bonus_Results__r.AF_Bonus_Value_Bm__c;
				brandid=BonusMatrixObj.AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Brand_Name__c;
				agencyid=BonusMatrixObj.AF_Bonus_Results__r.AF_Bonus_Thresholds__r.Agency_Name__c;
				fyear= BonusMatrixObj.AF_Fiscal_Year__c;
				bonus_summaryid=BonusMatrixObj.AF_Bonus_Summary__r.id;
				EsLocal=BonusMatrixObj.AF_Bonus_Local_Value__c;
				if(BonusMatrixObj.AF_Bonus_Summary__r.AF_Status__c==AF_Constants.BONUS_SUMMARY_READYFORPO){
					IsReadyforPO=true;
				}
				listofbonusmatrix=[Select id,AF_Bonus_Results__r.id,AF_Value__c from AF_Bonus_Matrix__c where AF_Bonus_Summary__r.id=:bonus_summaryid];
				if(listofbonusmatrix.size()>0){
					for(AF_Bonus_Matrix__c  bm:listofbonusmatrix){
						if(bm.id!=ParentId){
							totalMatrixbonus=totalMatrixbonus+bm.AF_Value__c;
						}
						bonusresultid.add(bm.AF_Bonus_Results__r.id);
					}
				}
				listofbonusresult=[select id,AF_Total_Bonus_Value__c from AF_Bonus_Results__C where id IN:bonusresultid ];
				if(listofbonusresult.size()>0){
					for(AF_Bonus_Results__C bs:listofbonusresult){
						if(bs.AF_Total_Bonus_Value__c!=Null){
							totalbonusresult=totalbonusresult+bs.AF_Total_Bonus_Value__c;
						}
					}
				}
				if(BonusMatrixObj == null)
				{                 
					BonusMatrixObj = new AF_Bonus_Matrix__c();
				}
				else{
					EsLocal=BonusMatrixObj.AF_Bonus_Local_Value__c;
				}                                           
			}
		}
		catch(Exception ex) 
		{
			AF_ExceptionLoggingHelper.createObjectData(UserInfo.getUserId(),className_STR,'AF_BonusMatrixOverrideController',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString(),AF_Constants.APP_NAME);
			
		}
	}
	/*****************************************************************************
*  @Description: this method is used to update the overrided bonus estimate value
*  @name : Save
*  @param : none
*  @return: PageReference.
**********************************************************************************/
	public PageReference Save()
	{        
		try
		{
			if(BonusMatrixValue!=null){
				Decimal pureMatrixBonus = Decimal.valueof(BonusMatrixValue.Remove(','))+totalMatrixbonus;
				if(pureMatrixBonus>math.round(totalbonusresult)){
					apexpages.addmessage(new apexpages.message(apexpages.severity.Error, Label.AF_Override_Bonus + pureMatrixBonus + ' Total Bonus: ' + math.round(totalbonusresult)));                  
				}
				else{
					BonusMatrixObj.AF_Overidden__c = true;
					update BonusMatrixObj;
					CalculateLocalC();
					apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,Label.AF_Record_saved));          
				}
			}
		}
		catch(Exception ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'Save',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			BonusMatrixObj.AF_Overidden__c = true;
			update BonusMatrixObj;
			CalculateLocalC();
			apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,Label.AF_Record_saved));  
		}
		return null;
	}
	/**************************************************************************************
*  @Description: this method is used to replace the commas of the overrided bonus amount
*  @name : CommaFilter
*  @param : none
*  @return: string.
*******************************************************************************************/
	private string CommaFilter(string value)
	{
		String localValue=value;
		if(value.contains(',')){localValue = value.replaceAll(',','');}
		return localValue;       
	} 
	/**************************************************************************************
*  @Description: this method is used to calculate the local value of the override bonus value
*  @name : CalculateLocalC
*  @param : none
*  @return: none.
*******************************************************************************************/
	public void CalculateLocalC(){
		try{
			if(BonusMatrixValue!=null && BonusMatrixValue!=''){
				String bonusvalue=BonusMatrixValue.Remove(',');
				EsLocal=Decimal.valueof(bonusvalue)*BonusMatrixObj.AF_Agency_Exchange_Rate__c;
			}
		}
		catch(exception ex){
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'CalculateLocalC',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			if(BonusMatrixValue==''){
				EsLocal=0;
			}
		}
	}
	/**************************************************************************************
*  @Description: this method is used to update override PO bonus value
*  @name : SavePo
*  @param : none
*  @return: none.
*******************************************************************************************/
	public void SavePo(){
		try{
		update BonusMatrixObj;
		apexpages.addmessage(new apexpages.message(apexpages.severity.Confirm,Label.AF_Record_saved)); 
		}
		catch(exception ex){
		AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'CalculateLocalC',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
		apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		}         
	}            
}