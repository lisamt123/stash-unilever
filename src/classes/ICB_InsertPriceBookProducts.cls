public class ICB_InsertPriceBookProducts {
    
    @InvocableMethod
    public static void insertProducts(List<Id> product) {
        system.debug('Entering on the method');
        List<PricebookEntry> pbeList 	= new List<PricebookEntry>();
        List<PricebookEntry> pbeList2 	= new List<PricebookEntry>();   
        
        //Return the standard PriceBook to insert the product. 
       for(Pricebook2 pb1 : PriceBookEntryDAO.getInstance().getActivePricebook(true)) {
            
            pbeList.add(createsObject(pb1.Id, product.get(0)));
        }
        
        database.insert(pbeList);
        
        
        //Method to create the pricebookEntry
   
        for(Pricebook2 pb2 : PriceBookEntryDAO.getInstance().getActivePricebook(false)) {
            
            pbeList2.add(createsObject(pb2.Id, product.get(0)));
        }
        
        database.insert(pbeList2);
    }
    
    /**
     * 
     * 
     **/
    private static PricebookEntry createsObject(Id vId, Id prodId) {
        return new PricebookEntry ( Pricebook2Id 		= vId, 
                                   Product2Id 			= prodId, 
                                   IsActive 			= TRUE,
                                   UnitPrice 			= 0.0,
                                   UseStandardPrice 	= FALSE);
    }
}