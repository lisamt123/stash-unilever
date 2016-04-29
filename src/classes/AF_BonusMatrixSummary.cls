/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusMatrixSummary
@CreateDate : 27/7/2014
@Description : This is a controller class for AF_BonusEstimate Page, 
@			  which is used to display the Bonus Summary section of Bonus Matrix page.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_BonusMatrixSummary {
	public  List<AF_Bonus_Summary__c> bonusSummaries{get;set;}
	public AF_Bonus_Results__c bonusResultObj{get;set;}
	public AF_Bonus_Summary__c bonusSummaryObj{get;set;}
	public Integer bonus {get;set;}//To get bonus 
	public Decimal bonusableFee{get;set;}//To get bonusableFee
	public Integer totalfee{get;set;}//To get totalfee
	public Integer overallbonusPer{get;set;}//To display overallbonusPer
	public Integer qualPer{get;set;}//To display Qualitative bonus
	public Integer quantPer{get;set;}//To display Quantitative bonus
	public String BrandId {get;set;}//To get selected Brand
	public String AgencyId{get;set;}//To get selected Agency
	public Decimal remainingAllowances{get;set;}
	public Decimal BonusTarget{get;set;}
	public Decimal qualValue{get;set;}
	public  Decimal quant{get;set;}
	public Integer totalquant_qual{get;set;}
	public Boolean IsReadyForPO{get;set;}
	public Boolean isCatFinance{get;set;}
	public Boolean isAgencyFlag{get;set;}
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_BonusMatrixSummary
*  @param : none
*  @return : none
*************************************************************************/ 
	public AF_BonusMatrixSummary(ApexPages.StandardController stdController){
		String BonusSummaryId = ApexPages.currentPage().getParameters().get('Id');
		IsReadyForPO=false;
		BonusTarget=0;
		totalquant_qual=0;
		bonusSummaryObj= new AF_Bonus_Summary__c();
		Decimal overallBonus=0;
		qualValue=0;
		quant=0;
		bonusableFee=0;
		totalfee=0;
		overallbonusPer=0;
		qualPer=0;
		quantPer=0;
		remainingAllowances=0;
		isCatFinance=false;
		isAgencyFlag=false;
		User userObj = new User();
		userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_CATEGORY_FINANCE){
			isCatFinance=true;
		}
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
			isAgencyFlag=true;
		}
		bonusSummaryObj=[SELECT AF_Status__c,AF_Agency__c,AF_Agency__r.Name,AF_Brand__c,AF_Brand__r.Name,AF_Fiscal_Year__c,AF_Bonus_Matrix_Value__c,AF_Is_Pilot_Model__c,
		(SELECT AF_Bonus_Results__r.AF_Total_Remuneration__c,AF_Bonus_Results__r.AF_Status__c,AF_Bonus_Results__r.AF_Bonus_Value_Bm__c, AF_Bonus_Results__r.AF_Total_Bonus_Value__c 
		From Bonus_Matrix__r)
		FROM AF_Bonus_Summary__c 
		WHERE id=:BonusSummaryId];
		BrandId=bonusSummaryObj.AF_Brand__c;
		AgencyId=bonusSummaryObj.AF_Agency__c;
		String year=bonusSummaryObj.AF_Fiscal_Year__c;
		if(bonusSummaryObj.AF_Status__c==AF_Constants.BONUS_SUMMARY_READYFORPO){
			IsReadyForPO=true;
		}
		decimal BonusTarget1=0;
		//to store unique Threshold Ids
		Set<ID> ids = new Set<ID>();
		for(AF_Bonus_Threshold__c bonusThObj : [SELECT Id FROM AF_Bonus_Threshold__c Where Agency_Name__c=:AgencyId AND Brand_Name__c=:BrandId AND Year__c=:year]){
			ids.add(bonusThObj.Id);
		}
		//Query all Results related to Bonus Thresholds
		for(AF_Bonus_Results__c bonusResultObj :[SELECT AF_Total_Bonus_Value__c,AF_Total_Remuneration__c,
		AF_Bonus_Value_Bm__c,AF_Bonusable_Fees__c,AF_Total_bonus_fees__c,
		AF_Total_Bonus__c,AF_Quant_Bonus_Value__c,AF_Qual_Bonus_Value__c
		FROM AF_Bonus_Results__c 
		WHERE AF_Bonus_Thresholds__c IN:ids AND recordType.Name=:AF_Constants.ANNUAL_BONUS_REC_TYPE]){
			if(bonusResultObj.AF_Total_Bonus_Value__c==null)
			bonusResultObj.AF_Total_Bonus_Value__c=0;
			overallBonus+=bonusResultObj.AF_Total_Bonus_Value__c;
			BonusTarget1=BonusTarget1+(bonusResultObj.AF_Total_Bonus_Value__c);
			if(bonusResultObj.AF_Qual_Bonus_Value__c==null)
			bonusResultObj.AF_Qual_Bonus_Value__c=0;
			qualValue+=bonusResultObj.AF_Qual_Bonus_Value__c;
			if(bonusResultObj.AF_Quant_Bonus_Value__c==null)
			bonusResultObj.AF_Quant_Bonus_Value__c=0;
			quant+=bonusResultObj.AF_Quant_Bonus_Value__c;
			if(bonusResultObj.AF_Bonusable_Fees__c==null)
			bonusResultObj.AF_Bonusable_Fees__c=0;
			bonusableFee+=bonusResultObj.AF_Bonusable_Fees__c;
			if(bonusResultObj.AF_Total_bonus_fees__c==null)
			bonusResultObj.AF_Total_bonus_fees__c=0;
			totalfee+=Integer.valueOf(bonusResultObj.AF_Total_bonus_fees__c);
		}
		BonusTarget=math.round(BonusTarget1);
		totalquant_qual=math.round(quant+qualValue);
		if(bonusSummaryObj.AF_Is_Pilot_Model__c) {
			if(bonusSummaryObj.Bonus_Matrix__r.size() > 0) {
				if(bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Total_Remuneration__c != null &&
						bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Bonus_Value_Bm__c != null) {
					remainingAllowances = (bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Total_Remuneration__c - 
					bonusSummaryObj.Bonus_Matrix__r[0].AF_Bonus_Results__r.AF_Bonus_Value_Bm__c);
					if(remainingAllowances<1){
						remainingAllowances=0;
					}
				}
			}
		}else {
			remainingAllowances = (BonusTarget - bonusSummaryObj.AF_Bonus_Matrix_Value__c);
			if(remainingAllowances<1){
				remainingAllowances=0;
			}
		}
		//Calculate Overall bonus Percentage,Quatitative Bonus,Qualitative Bonus
		if(bonusableFee!=0){  
			qualPer=Math.round((qualValue*100)/bonusableFee);
			quantPer=Math.round((quant*100)/bonusableFee);
			if(bonusSummaryObj.AF_Is_Pilot_Model__c) 
			{
				overallbonusPer=Math.round((overallBonus*100)/bonusableFee);
			}
			else
			{
				overallbonusPer=qualPer+quantPer;
			}
		}
	}
	/**********************************************************************
*  @Description: this method is used to submit the Bonus finally.
*  @name : SubmitforStatus
*  @param : none
*  @return: pagereference
**********************************************************************/
	public pagereference SubmitforStatus(){
		string Submit_for_status='SubmitforStatus';
		List<AF_Bonus_Matrix__c> bonusMatrixList = new List<AF_Bonus_Matrix__c>();
		if(bonusableFee==0){
			apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Annual_Bonus));
		}
		else if(remainingAllowances==0){
			bonusSummaryObj.AF_Status__c=AF_Constants.BONUS_SUMMARY_READYFORPO;
			try{
			update bonusSummaryObj;
			}
			 catch(Exception e)
		        {
		            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,Submit_for_status,e.getMessage(),e.getTypeName(),e.getStackTraceString());
		            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		        }
			for(AF_Bonus_Matrix__c BM:bonusSummaryObj.Bonus_Matrix__r){
				BM.AF_Status__c = AF_Constants.BONUS_SUMMARY_READYFORPO;
				bonusMatrixList.add(BM);
			}
			if(bonusMatrixList.size()>0){
				try{
				update bonusMatrixList;
				}
				catch(Exception e)
		        {
		            AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,Submit_for_status,e.getMessage(),e.getTypeName(),e.getStackTraceString());
		            apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Update)); 
		        }
			}
			IsReadyForPO=true;
		}
		return null;
	}
}