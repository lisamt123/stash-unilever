/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_CountryBreakdownCheck
@CreateDate : 4/7/2014
@Description : This is a controller class for AF_ApprovalProcessForBrandEstController class, 
@			  this is used to display the country breakdown percentage and updation the percantage.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
public with sharing class AF_CountryBreakdownCheck {
	/***********************************************************************************
*  @Description: this method is used to query and validate the countrybreakdown% 
*  @name : CheckCountryBreakdown
*  @param : pBrandEstimate
*  @return: Boolean.
*************************************************************************************/	
	public Boolean CheckCountryBreakdown(String pBrandEstimate)
	{
		Boolean retResult = false;
		//1st check to see if there are estimates which are central billing - only need to look at ones where total >0
		List<AF_Agency_Estimate__c> lstAgESt = [select id from AF_Agency_Estimate__c where AF_Brand_Estimate__c=: pBrandEstimate and AF_Total__c >0 and AF_CentralBilling__c =true];
		if(!lstAgESt.isEmpty())   
		{
			//now we need to check list of estimates and make sure they are all at 100%
			List<aggregateResult> lstAgEStExc=  [SELECT AF_Agency_Estimate__c,sum(AF_Value__c) total FROM AF_Entity_Exception__c where AF_Agency_Estimate__c in:lstAgESt group by AF_Agency_Estimate__c];
			//If there are no exception - need to stop the approval
			if(lstAgEStExc.isEmpty()) {retResult=true;}
			else
			{
				if(lstAgEStExc.size()<lstAgESt.size()) {retResult=true;}
				else
				{
					//Now check they all add up to 100%
					for (AggregateResult ar : lstAgEStExc){
						if(ar.get(AF_Constants.TOTAL)!=100.00) retResult=true;
					}
				}
			}
		}
		return retResult;
	}
}