/*****************************************************************************************************************************
   @Author :Cognizant
   @name : AF_OOPSRecordManagerAsyncWrapper
   @CreateDate : 17/6/2014
   @Description : This is used to call the AF_OOPSRecordManager class.
   @			  
   @Version : 1.0
   @reference : none
  ****************************************************************************************************************************/
global class AF_OOPSRecordManagerAsyncWrapper 
{
	/***********************************************************************************
*  @Description: this method is used to create OOPSEStimate records
*  @name : CreateOOPSEstimateRecordsByCollection
*  @param : BrandEstimateIds
*  @return: none.
*************************************************************************************/
	@future
	public static void CreateOOPSEstimateRecordsByCollection(Set<ID> BrandEstimateIds)
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
				AF_OOPSRecordManager OOPSRecordManager = new AF_OOPSRecordManager(Ids);
				OOPSRecordManager.CreateOOPSEstimateRecordsByCollection();
			}               
		}
	}
}