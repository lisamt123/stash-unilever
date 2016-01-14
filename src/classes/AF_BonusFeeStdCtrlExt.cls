/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_BonusFeeStdCtrlExt
   @CreateDate : 16/7/2014
   @Description : This is a controller class for AF_BonusMatrix Page, 
   @			  this is used to display the summary section of the Bonus Matrix page.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_BonusFeeStdCtrlExt {
	public String agencyId{get;set;}
	public String bonusSummaryId {get;set;}
	public Boolean noEstimates{get;set;}
	public String brandid{get;set;}
	public String Fyear{get;set;}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_BonusFeeStdCtrlExt
*  @param : none
*  @return : none
*************************************************************************/ 	
	public AF_BonusFeeStdCtrlExt(ApexPages.StandardController stdController) {
		noEstimates = false;
		bonusSummaryId = ApexPages.currentPage().getParameters().get('id');
		brandid=ApexPages.currentPage().getParameters().get('bId');
		Fyear=ApexPages.currentPage().getParameters().get('fy');
		agencyid=ApexPages.currentPage().getParameters().get('aId');
		List<AF_Bonus_Summary__c> bonusSummaries = [SELECT AF_Agency__c, Name,
													(SELECT AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name
													FROM Bonus_Matrix__r) 
													FROM AF_Bonus_Summary__c 
													WHERE Id =:bonusSummaryId LIMIT 1];
		for(AF_Bonus_Summary__c  eachRecord : bonusSummaries) {
			if(eachRecord.Bonus_Matrix__r.size() > 0) {
				noEstimates = true;
			}
		}
	}
}