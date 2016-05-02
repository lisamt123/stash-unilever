/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_BonusRecordManagerAsyncWrapper
@CreateDate : 23/6/2014
@Description : This is a future class, 
@			  this is used to create the Bonus Matrix records based on the corresponding Agency Estimate records.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
global class AF_BonusRecordManagerAsyncWrapper 
{
	/***********************************************************************************
*  @Description: this method is used to call the AF_BonusRecordManager
*  @name : CreateMultiObjectRecordsAsync
*  @param : BrandEstimateIds
*  @return: none.
*************************************************************************************/
	@future
	public static void CreateMultiObjectRecordsAsync(Set<ID> BrandEstimateIds)
	{
		if(BrandEstimateIds.size() > 0)
		{
			set<Id> Ids = new set<Id>();
			for(string idVal : BrandEstimateIds)
			{
				Ids.add(idVal);     
			}   
			if(Ids.size() > 0)
			{               
				AF_BonusRecordManager bonusRecordManager = new AF_BonusRecordManager(Ids);
				bonusRecordManager.CreateMultiObjectRecords();
			}               
		}
	}
}