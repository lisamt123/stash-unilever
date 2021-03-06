/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_CustomSetting
@CreateDate : 22/8/2014
@Description : This is a controller class used in the AF_CustomSetting page to 
@               display all the custom setting used in the Agency fees application 
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_CustomSetting{
	public SettingProxy setting {get; set;}
	public AgencyEmailAlertsProxy emailAlerts {get;set;}
	public Map<String,AF_QuarterlyBonus__c> quarterlyBonusMap{get;set;}
	public List<AF_QuarterlyBonus__c> quarterlyBonusList{get;set;}
	public Map<String,AF_AgencyEmailAlerts__c> agencyEmailAlertMap{get;set;}
	public List<AF_AgencyEmailAlerts__c> agencyEmailAlertList{get;set;}
	public AF_TriggerDate__c triggerDate{get;set;}
	public Map<String,AF_Agency_Bonus_Access__c> agencyBonusMap{get;set;}
	public List<AF_Agency_Bonus_Access__c> agencyBonusList{get;set;}
	public Map<String,AF_isBonusLinkForAgency__c> bonusLinkMap{get;set;}
	public List<AF_isBonusLinkForAgency__c> bonusLinkList{get;set;}
	public DummyUser__c dummyUserId{get;set;}
	public AF_CMCO__c afCMCO{get;set;}
	public AF_CatFinanceThreshold__c catFinThreshold{get;set;}
	public AF_BrandEstimate_TriggerDate__c brandTriggerDate{get;set;}
	public AF_BonusQuarterly__c bonusQuarterly{get;set;}
	public List<AF_AnnualBonus_Qual__c> dummyList{get;set;}
	public Map<String,AF_AnnualBonus_Qual__c> annualBonusQualMap{get;set;}
	public List<AF_AnnualBonus_Qual__c> annualBonusQualList{get;set;}
	public AF_OOPS_Settings__c oopsPercentage{get;set;}
	public AF_Links__c afLinks{get;set;}
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	/***********************************************************************************
*  @Description: this contructor method will refer the custom setting 
*  @name : AF_CustomSetting
*  @param : none.
*  @return: none.
*************************************************************************************/
	public AF_CustomSetting()
	{
		dummyList = new List<AF_AnnualBonus_Qual__c>();
		quarterlyBonusMap = AF_QuarterlyBonus__c.getAll();
		quarterlyBonusList = quarterlyBonusMap.values();
		setting = new SettingProxy(quarterlyBonusList[0]);
		agencyEmailAlertMap = AF_AgencyEmailAlerts__c.getAll();
		agencyEmailAlertList = agencyEmailAlertMap.values();
		agencyBonusMap = AF_Agency_Bonus_Access__c.getAll();
		agencyBonusList = agencyBonusMap.values();
		bonusLinkMap = AF_isBonusLinkForAgency__c.getAll();
		bonusLinkList = bonusLinkMap.values();
		annualBonusQualMap = AF_AnnualBonus_Qual__c.getAll();
		annualBonusQualList = annualBonusQualMap.values();
		dummyList.add(annualBonusQualList[0]);
		triggerDate = new AF_TriggerDate__c();
		triggerDate = AF_TriggerDate__c.getOrgDefaults();
		dummyUserId = new DummyUser__c();
		dummyUserId = DummyUser__c.getOrgDefaults();
		afCMCO = new AF_CMCO__c();
		afCMCO = AF_CMCO__c.getOrgDefaults();
		catFinThreshold = new AF_CatFinanceThreshold__c();
		catFinThreshold = AF_CatFinanceThreshold__c.getOrgDefaults();
		brandTriggerDate = AF_BrandEstimate_TriggerDate__c.getOrgDefaults();
		bonusQuarterly = AF_BonusQuarterly__c.getOrgDefaults();
		oopsPercentage = AF_OOPS_Settings__c.getOrgDefaults();
		afLinks = AF_Links__c.getOrgDefaults();
		emailAlerts = new AgencyEmailAlertsProxy(agencyEmailAlertList[0],triggerDate,dummyUserId,oopsPercentage,afLinks,annualBonusQualList[0],annualBonusQualList[1],agencyBonusList[0],afCMCO,catFinThreshold,bonusQuarterly,brandTriggerDate);
	} 
	/***********************************************************************************
*  @Description: this method will get the QuarterlyBonus
*  @name : submitCustomSetting
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitCustomSetting(){
		try{
		update setting.getQuarterlyBonus();
		}
		catch(Exception e)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitCustomSetting',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update));
		}
	}
	/***********************************************************************************
*  @Description: this method will get the triggerDate
*  @name : submitTriggerDate
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitTriggerDate(){
		try{
		upsert emailAlerts.gettriggerDate();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitTriggerDate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the AgencyEmailAlerts
*  @name : submitAgencyEmailAlerts
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitAgencyEmailAlerts(){
		try{
		upsert emailAlerts.getAgencyEmailAlerts();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitAgencyEmailAlerts',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the AgencyBonus
*  @name : submitAgencyBonusMap
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitAgencyBonusMap(){
		try{
		upsert emailAlerts.getAgencyBonus();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitAgencyBonusMap',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the LinkList
*  @name : submitBonusLink
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitBonusLink(){
		try{
		upsert bonusLinkList;
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitBonusLink',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the DummyID
*  @name : submitDummyUserId
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitDummyUserId(){
		try{
		upsert emailAlerts.getDummyID();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitDummyUserId',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the CMCORights
*  @name : submitAFCMCO
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitAFCMCO(){
		try{
		upsert emailAlerts.getCMCORights();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitAFCMCO',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the CatFinance
*  @name : submitCatFinThreshold
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitCatFinThreshold(){
		try{
		upsert emailAlerts.getCatFinance();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitCatFinThreshold',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the BrandtriggerDate
*  @name : submitbrandTriggerDate
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitbrandTriggerDate(){
		try{
		upsert emailAlerts.getBrandtriggerDate();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitbrandTriggerDate',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the BonusQuarterly
*  @name : submitBonusQuarterly
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitBonusQuarterly(){
		try{
		upsert emailAlerts.getBonusQuarterly();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitBonusQuarterly',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the AnnualBonus
*  @name : submitAnnualBonusQual
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitAnnualBonusQual(){
		try{
		upsert emailAlerts.getAnnualBonus();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitAnnualBonusQual',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method will get the OopsPercent
*  @name : submitoopsPercentage
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitoopsPercentage(){
		try{
		update emailAlerts.getOopsPercent();
		}
		catch(Exception e)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitoopsPercentage',e.getMessage(),e.getTypeName(),e.getStackTraceString());
			apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		}
	}
	/***********************************************************************************
*  @Description: this method will get the AFLinks
*  @name : submitAFLinks
*  @param : none.
*  @return: none.
*************************************************************************************/
	public void submitAFLinks(){
		try{
		upsert emailAlerts.getAFLinks();
		}
		catch(Exception e)
	        {
	            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'submitAFLinks',e.getMessage(),e.getTypeName(),e.getStackTraceString());
	            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Upsert)); 
	        }
	}
	/***********************************************************************************
*  @Description: this method is used to pass the date parameters to string
*  @name : dateConversionMethod
*  @param : none.
*  @return: string.
*************************************************************************************/
	public  static String dateConversionMethod(String quarter){
		List<String> dateDisplay = new List<String>();
		String finalDate='';
		if(quarter <> NULL)
		dateDisplay = quarter.split('-');
		if(dateDisplay.size()>0){
			finalDate = finalDate+dateDisplay[2]+'/'+dateDisplay[1]+'/'+dateDisplay[0];
		}
		return finalDate;
	}
	/***********************************************************************************
*  @Description: this method is used wrap the class for custom setting
*  @name : SettingProxy
*  @param : none.
*  @return: none.
*************************************************************************************/
	public class SettingProxy {
		public String Name {get;set;}
		public Decimal Min {get;set;}
		public Decimal Stretching {get;set;}
		public Decimal Outstanding {get;set;}
		public id id{get;set;}
		/***********************************************************************************
*  @Description: this method is used wrap the AF_QuarterlyBonus__c  custom setting
*  @name : SettingProxy
*  @param : none.
*  @return: none.
*************************************************************************************/
		public SettingProxy(AF_QuarterlyBonus__c QB) {
			this.id = QB.id;
			this.Name = QB.Name;
			this.Min = QB.Minimum__c;
			this.Stretching = QB.Stretching__c;
			this.Outstanding = QB.Outstanding__c;
		}
		/***********************************************************************************
*  @Description: this method is used wrap the QuarterlyBonus  custom setting
*  @name : AF_QuarterlyBonus__c
*  @param : none.
*  @return: none.
*************************************************************************************/
		public AF_QuarterlyBonus__c getQuarterlyBonus() {
			return new AF_QuarterlyBonus__c(
			id=this.id,
			Name = this.Name,
			Minimum__c = this.Min,
			Stretching__c = this.Stretching,
			Outstanding__c = this.Outstanding
			);
		}
	}
	public class AgencyEmailAlertsProxy {
		public String AgencyEmailName {get;set;}
		public String Q1 {get;set;}
		public String Q2 {get;set;}
		public String Q3 {get;set;}
		public String Q4 {get;set;}
		public id AgencyEmailid{get;set;}
		public String triggerDate{get;set;}
		public String  triggerId{get;set;}
		public String dummyId{get;set;}
		public String dummyUserId{get;set;}
		public String oopsId{get;set;}
		public Decimal oopsPercentage{get;set;}
		public String linkId{get;set;}
		public String links{get;set;}
		public String qualId{get;set;}
		public String qualName{get;set;}
		public Decimal X1{get;set;}
		public Decimal X2{get;set;}
		public Decimal X3{get;set;}
		public Decimal X4{get;set;}
		public Decimal X5{get;set;}
		public String qualId1{get;set;}
		public String qualName1{get;set;}
		public Decimal X11{get;set;}
		public Decimal X22{get;set;}
		public Decimal X33{get;set;}
		public Decimal X44{get;set;}
		public Decimal X55{get;set;}
		public String BonusId{get;set;}
		public String BonusDate{get;set;}
		public String BonusYear{get;set;}
		public String cmcoId{get;set;}
		public Boolean cmcoRights{get;set;}
		public String catFinId{get;set;}
		public String catFinDate{get;set;}
		public String bonusName{get;set;}
		public String BonusQuartId{get;set;}
		public string BonusQuartQ1{get;set;}
		public String BrandTriggerId{get;set;}
		public String BrandTriggerDate{get;set;}
		public Boolean Brandcurrency{get;set;}
		/***********************************************************************************
*  @Description: this is wrapper class for the  custom setting
*  @name : AgencyEmailAlertsProxy
*  @param : none.
*  @return: none.
*************************************************************************************/
		public AgencyEmailAlertsProxy(AF_AgencyEmailAlerts__c AE,
		AF_TriggerDate__c TD,
		DummyUser__c DU,
		AF_OOPS_Settings__c oops,
		AF_Links__c link,
		AF_AnnualBonus_Qual__c qual,
		AF_AnnualBonus_Qual__c qual1,
		AF_Agency_Bonus_Access__c agencyBonus,
		AF_CMCO__c cmco,
		AF_CatFinanceThreshold__c catFin,
		AF_BonusQuarterly__c bquart,
		AF_BrandEstimate_TriggerDate__c triggerDate) {
			this.AgencyEmailid = AE.id;
			this.AgencyEmailName = AE.Name;
			this.Q1 = dateConversionMethod(String.valueOf(AE.Q1__c));
			this.Q2 = dateConversionMethod(String.valueOf(AE.Q2__c));
			this.Q3 = dateConversionMethod(String.valueOf(AE.Q3__c));
			this.Q4 = dateConversionMethod(String.valueOf(AE.Q4__c));
			this.triggerDate = dateConversionMethod(String.valueOf(TD.Date__c));
			this.triggerId = TD.id;
			this.dummyId = DU.id;
			this.dummyUserId = DU.User_id__c;
			this.oopsId = oops.Id;
			this.oopsPercentage = oops.Overall_Percentage__c;
			this.linkId = link.Id;
			this.links = link.AF_Community_Link__c;
			this.qualId = qual.Id;
			this.qualName = qual.Name;
			this.X1 = qual.X1__c;
			this.X2 = qual.X2__c;
			this.X3 = qual.X3__c;
			this.X4 = qual.X4__c;
			this.X5 = qual.X5__c;
			this.qualId1 = qual1.Id;
			this.qualName1 = qual1.Name;
			this.X11 = qual1.X1__c;
			this.X22 = qual1.X2__c;
			this.X33 = qual1.X3__c;
			this.X44 = qual1.X4__c;
			this.X55 = qual1.X5__c;
			this.bonusName = agencyBonus.Name;
			this.BonusId = agencyBonus.Id;
			this.BonusDate = dateConversionMethod(String.valueOf(agencyBonus.AF_Access_Date__c));
			this.BonusYear = agencyBonus.AF_Fiscal_Year__c;
			this.cmcoRights = cmco.AF_CMCO_Rights__c;
			this.cmcoId = cmco.Id;
			this.catFinId = catFin.Id;
			this.catFinDate = dateConversionMethod(String.valueOf(catFin.AF_Date__c));
			this.BonusQuartId = bquart.Id;
			this.BonusQuartQ1 = dateConversionMethod(String.valueOf(bquart.AF_BonusQuarterlyDate__c));
			this.BrandTriggerId = triggerDate.Id;
			this.Brandcurrency = triggerDate.AF_Currency_Uploaded__c;
			this.BrandTriggerDate = dateConversionMethod(String.valueOf(triggerDate.AF_Trigger_Date__c));
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the BrandtriggerDate
*  @name : AF_BrandEstimate_TriggerDate__c
*  @param : none.
*  @return: none.
*************************************************************************************/               
		public AF_BrandEstimate_TriggerDate__c getBrandtriggerDate() {
			return new AF_BrandEstimate_TriggerDate__c(
			id=this.BrandTriggerId,
			AF_Currency_Uploaded__c=this.Brandcurrency,
			AF_Trigger_Date__c = date.parse(this.BrandTriggerDate)
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the AgencyEmailAlerts
*  @name : AF_AgencyEmailAlerts__c
*  @param : none.
*  @return: none.
*************************************************************************************/     
		public AF_AgencyEmailAlerts__c getAgencyEmailAlerts() {
			return new AF_AgencyEmailAlerts__c(
			id=this.AgencyEmailid,
			Name = this.AgencyEmailName,
			Q1__c = date.parse(this.Q1),
			Q2__c = date.parse(this.Q2),
			Q3__c = date.parse(this.Q3),
			Q4__c = date.parse(this.Q4)
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the triggerDate
*  @name : AF_TriggerDate__c
*  @param : none.
*  @return: none.
*************************************************************************************/  
		public AF_TriggerDate__c gettriggerDate() {
			return new AF_TriggerDate__c(
			id=this.triggerId,
			Date__c = date.parse(this.triggerDate)
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the DummyID
*  @name : DummyUser__c
*  @param : none.
*  @return: none.
*************************************************************************************/  
		public DummyUser__c getDummyID() {
			return new DummyUser__c(
			id=this.dummyId,
			User_id__c=this.dummyUserId
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the OopsPercent
*  @name : AF_OOPS_Settings__c
*  @param : none.
*  @return: none.
*************************************************************************************/  
		public AF_OOPS_Settings__c getOopsPercent() {
			return new AF_OOPS_Settings__c(
			id=this.oopsId,
			Overall_Percentage__c=this.oopsPercentage
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the AFLinks
*  @name : AF_Links__c
*  @param : none.
*  @return: none.
*************************************************************************************/  
		public AF_Links__c getAFLinks() {
			return new AF_Links__c(
			id=this.linkId,
			AF_Community_Link__c=this.links
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the AnnualBonus
*  @name : getAnnualBonus
*  @param : none.
*  @return: none.
*************************************************************************************/   
		public List<AF_AnnualBonus_Qual__c> getAnnualBonus() {
			List<AF_AnnualBonus_Qual__c> annualBonus = new List<AF_AnnualBonus_Qual__c>();
			AF_AnnualBonus_Qual__c AB = new AF_AnnualBonus_Qual__c();
			AF_AnnualBonus_Qual__c AB1 = new AF_AnnualBonus_Qual__c();
			AB.id=this.qualId;
			AB.Name = this.qualName;
			AB.X1__c=this.X1;
			AB.X2__c=this.X2;
			AB.X3__c=this.X3;
			AB.X4__c=this.X4;
			AB.X5__c=this.X5;
			annualBonus.add(AB);
			AB1.id=this.qualId1;
			AB1.Name = this.qualName1;
			AB1.X1__c=this.X11;
			AB1.X2__c=this.X22;
			AB1.X3__c=this.X33;
			AB1.X4__c=this.X44;
			AB1.X5__c=this.X55;
			annualBonus.add(AB1);
			return annualBonus;
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the AgencyBonus
*  @name : AF_Agency_Bonus_Access__c
*  @param : none.
*  @return: none.
*************************************************************************************/   
		public AF_Agency_Bonus_Access__c getAgencyBonus() {
			return new AF_Agency_Bonus_Access__c(
			Name = this.bonusName,
			id=this.BonusId,
			AF_Access_Date__c=date.parse(this.BonusDate),
			AF_Fiscal_Year__c=this.BonusYear
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the CMCORights
*  @name : AF_CMCO__c
*  @param : none.
*  @return: none.
*************************************************************************************/   
		public AF_CMCO__c getCMCORights() {
			return new AF_CMCO__c(
			id=this.cmcoId,
			AF_CMCO_Rights__c=this.cmcoRights
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the CatFinance
*  @name : AF_CatFinanceThreshold__c
*  @param : none.
*  @return: none.
*************************************************************************************/   
		public AF_CatFinanceThreshold__c getCatFinance() {
			return new AF_CatFinanceThreshold__c(
			id=this.catFinId,
			AF_Date__c=date.parse(this.catFinDate)
			);
		}
		/***********************************************************************************
*  @Description: this method is used to wrap the BonusQuarterly
*  @name : AF_BonusQuarterly__c
*  @param : none.
*  @return: none.
*************************************************************************************/   
		public AF_BonusQuarterly__c getBonusQuarterly() {
			return new AF_BonusQuarterly__c(
			id=this.BonusQuartId,
			AF_BonusQuarterlyDate__c=date.parse(this.BonusQuartQ1)
			);
		}
	}
}