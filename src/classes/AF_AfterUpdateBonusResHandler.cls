/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_AfterUpdateBonusResHandler
   @CreateDate : 5/7/2014
   @Description : This is a controller class for Bonus Matrix trigger, 
   @			  this is used to update to BonusMatrix.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_AfterUpdateBonusResHandler {
	/***********************************************************************************
*  @Description: this method is used to call the updateBonusMatrix method
*  @name : AF_AfterUpdHandler
*  @param : bonResultList
*  @return: none.
*************************************************************************************/
	public static void AF_AfterUpdHandler(AF_Bonus_Results__c[] bonResultList) { 
		Set<String> BonusResultIds = new Set<String>();
		for(AF_Bonus_Results__c  brandResults:bonResultList)   
		{
			BonusResultIds.add(brandResults.Id);          
		}
		List<String> bonResultsStrList = new List<String>(BonusResultIds);
		updateBonusMatrix(bonResultsStrList);
	}
	/***********************************************************************************
*  @Description: this method is used to update the Bonus Matrix
*  @name : updateBonusMatrix
*  @param : BonusResultIds
*  @return: none.
*************************************************************************************/
	@future(callOut=false)
	public static void updateBonusMatrix(String[] BonusResultIds) {
		if(BonusResultIds.size() > 0)
		{
			try
			{
				List<AF_Bonus_Matrix__c> BonusMatrixCollection = [Select a.AF_Bonus_Results__c From AF_Bonus_Matrix__c a where a.AF_Bonus_Results__c IN :BonusResultIds];
				update BonusMatrixCollection;
			}
			catch(Exception ex){
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),'AF_AfterUpdateBonusResHandler','updateBonusMatrix',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			}
		}  
	}   
}