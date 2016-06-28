/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_BatchProcess_copy
   @CreateDate : 13/8/2014
   @Description : This is a controller class for AF_BatchProcess_Copy Page, 
   @			  this is used to create new brandestimates for new year from previous year brandestimates.
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
public with sharing class AF_BatchProcess_copy {
	/*********************************************************************************************
*  @Description: this method is used to query the previous year estimates and call the batch class
*  @name : confirm
*  @param : none
*  @return: pagereference.
***************************************************************************************************/
	public pagereference confirm()
	{
		ID batchprocessid;
		String Fisyear=string.valueOf(system.now().year()-1);
		String statusBasefee=AF_Constants.BASE_FEES_READYFORPO;
		string query = 'SELECT id,Name FROM AF_Brand_Estimate__c WHERE AF_Status_Base_Fees__c =' + '\'' +statusBasefee +'\''+' AND AF_Fiscal_Year__c ='+'\''+Fisyear+'\' and AF_Copied__c= false and AF_Locked__c = false and AF_Active__c = true';
		AF_BrandEstimatesBatch batchApex=new AF_BrandEstimatesBatch(query);
		batchprocessid = Database.executeBatch(batchApex,1);
		return null;
	}
	/*********************************************************************************************
*  @Description: this method is used to display confirmation msg
*  @name : displayMsg
*  @param : none
*  @return: pagereference.
***************************************************************************************************/
	public pagereference displayMsg(){
		apexpages.addmessage(new apexpages.message(apexpages.severity.info,Label.AF_Records_Processing));
		return null;
	}
}