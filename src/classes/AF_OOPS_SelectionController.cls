/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_OOPS_SelectionController
@CreateDate : 10/07/2014
@Description : This is a controller class for AF_UL_OOPS_SelectMatrices Page, 
@			  this is used to display the oops actual and user can select the OOPS Actual.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_OOPS_SelectionController {
	//Members
	public String agencyId {get;set;}
	public String fiscalYear {get;set;}
	public String brandId {get;set;}
	public List<AF_OOPS_Actual__c> oopsActuals {get;set;}
	public String linkRed{get;set;}
	public Boolean isAgencyFlag{get;set;}
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_OOPS_SelectionController
*  @param : none
*  @return : none
*************************************************************************/
	public AF_OOPS_SelectionController() {
		brandId = ApexPages.currentPage().getParameters().get('bId');
		agencyId = ApexPages.currentPage().getParameters().get('aId');
		fiscalYear = ApexPages.currentPage().getParameters().get('fy');
		isAgencyFlag=false;
		User userObj = new User();
		userObj = [select Id,Contact.Account.Name, AF_Category__c, AF_Brand__c,Profile.Name, AF_Agency_Fees_User_Type__c from User where Id =:UserInfo.getUserId()];
		if(userObj.AF_Agency_Fees_User_Type__c==AF_Constants.UT_AGENCY){
			isAgencyFlag=true;
		}
		oopsActuals = [SELECT Name, AF_Status__c,oopsEstimateStatus__c FROM AF_OOPS_Actual__c  WHERE AF_Brand__c = :brandId AND AF_Agency_lk__c = :agencyId AND AF_Fiscal_year__c = :fiscalYear order by createddate desc];
		if(oopsActuals.size() == 1) {
			linkRed = oopsActuals[0].Id;
		}
	}
}