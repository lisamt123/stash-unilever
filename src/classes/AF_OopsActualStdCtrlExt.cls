/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_OopsActualStdCtrlExt
   @CreateDate : 19/7/2014
   @Description : This is a controller class for AF_UL_oopsMatrix Page, 
   @			  this is used to query and display the OOPS details.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_OopsActualStdCtrlExt {
	//Members
	public String agencyId{get;set;}
	public String ParentId{get;set;}
	public String oopsActualId {get;set;}
	public String ParentRecordType {get;set;}
	public AF_OOPS_Actual__c oopsActual {get;set;}
	public Boolean noEstimates {get;set;}
	private static string className_STR=AF_OopsActualStdCtrlExt.class.getName();
	/**********************************************************************
*  @Description: Contructor method
*  @name : AF_OopsActualStdCtrlExt
*  @param : ApexPages.StandardController
*  @return : none
*************************************************************************/ 
	public AF_OopsActualStdCtrlExt(ApexPages.StandardController stdController) {
		oopsActualId = ApexPages.currentPage().getParameters().get('id');
		List<AF_OOPS_Actual__c> oopsActuals = [SELECT  AF_Agency_lk__c, Name,Overall__c,
		(SELECT AF_Agency_Entity__r.AF_Country__c,AF_Unilever_Entity__r.Name,AF_Estimate__c
		FROM OOPS_Estimates__r) 
		FROM AF_OOPS_Actual__c 
		WHERE Id =:oopsActualId LIMIT 1];
		for(AF_OOPS_Actual__c  eachOopsActual : oopsActuals) {
			oopsActual = eachOopsActual;
			agencyId = eachOopsActual.AF_Agency_lk__c;
			if(eachOopsActual.OOPS_Estimates__r.size() > 0) {
				noEstimates = true;
			}
		}
	} 
	/***********************************************************************************
*  @Description: this method is used to update the OOPS records
*  @name : SaveRecord
*  @param : none
*  @return: PageReference.
*************************************************************************************/
	public PageReference SaveRecord()
	{
		PageReference pageRef;
		try
		{   
			update oopsActual;
			pageRef = ApexPages.currentPage();
			pageRef.setRedirect(true);
		}
		catch(DMLException ex)
		{
			AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,'SaveRecord',ex.getMessage(),ex.getTypeName(),ex.getStackTraceString());
			pageRef.setRedirect(true);
			pageRef = null;             
		}
		return pageRef;
	}
}