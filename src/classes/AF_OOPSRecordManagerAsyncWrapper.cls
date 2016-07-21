global class AF_OOPSRecordManagerAsyncWrapper 
{
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