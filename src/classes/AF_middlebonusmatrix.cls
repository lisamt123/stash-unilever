/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_middlebonusmatrix
@CreateDate : 3/8/2014
@Description : This is a controller class for AgencyHomePage Page, 
@			  this displays bonus summary in an intermediate page before bonus matrix.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_middlebonusmatrix {
	public String url_brandid{get;set;}
	Public String url_agencyid{get;set;}
	Public String url_year{get;set;}
	Public String bonusSummaryId {get;set;}
	Public  List<AF_Bonus_Summary__c> bonusSummaries{get;set;}
	public Boolean isAgencyAccess{get;set;}
	public Boolean isAgencyFlag{get;set;}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_middlebonusmatrix
*  @param : none
*  @return : none
*************************************************************************/
	public AF_middlebonusmatrix (){
		isAgencyFlag=false;
		isAgencyAccess = false;
		url_brandid=ApexPages.currentPage().getParameters().get(AF_Constants.BRANDID);
		url_agencyid=ApexPages.currentPage().getParameters().get(AF_Constants.AGENCYID);
		url_year=ApexPages.currentPage().getParameters().get(AF_Constants.YEAR);
		User userObj = new User();
		userObj = [select AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
			isAgencyFlag=true;
		}
		List<AF_Agency_Bonus_Access__c> agencyAccessList = AF_Agency_Bonus_Access__c.getall().values();
		for(AF_Agency_Bonus_Access__c eachBonusSetting : agencyAccessList) {
			if(isAgencyFlag && eachBonusSetting.AF_Access_Date__c <= system.today() && url_year == eachBonusSetting.AF_Fiscal_Year__c) {
				isAgencyAccess = true;  
			}
		}  
		bonusSummaries = [SELECT ID,AF_Agency__c, Name,
		(SELECT AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name
		FROM Bonus_Matrix__r) 
		FROM AF_Bonus_Summary__c 
		WHERE AF_Brand__c=:url_brandid and AF_Agency__c=:url_agencyid and AF_Fiscal_Year__c=:url_year LIMIT 1];
		if(bonusSummaries.size()==1){
			bonusSummaryId =bonusSummaries[0].id;
		}
	}    
}