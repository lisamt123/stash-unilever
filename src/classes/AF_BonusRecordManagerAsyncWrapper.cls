global class AF_BonusRecordManagerAsyncWrapper 
{
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