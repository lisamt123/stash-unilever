/**********************************************************************
Name: ICB_InsertPriceBookProducts
Copyright © 2016 Unilever

Purpose:
Class used when fire the Process Builder to insert the products on the PriceBook

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
1.0    Carlos Henrique 08/08/2016  Class creation  
***********************************************************************/
public with sharing class ICB_InsertPriceBookProducts 
{
    
    
    /*******************************************************************
    Purpose: Retrieve products to show in component productInventoryBody
    Parameters: None
    Returns: None
	Throws [Exceptions]: Exception
    ********************************************************************/
    @InvocableMethod
    public static void insertProducts(List<Id> product) 
    {
        system.debug('Entering <insertProducts>' + product);
        
        List<PricebookEntry> pbeList 	= new List<PricebookEntry>();
        List<PricebookEntry> pbeList2 	= new List<PricebookEntry>();   
        
        try 
        {
            
            //Return the standard PriceBook to insert the product. 
            for(Pricebook2 pb1 : ICB_PriceBookEntryDAO.getInstance().getActivePricebook(true)) 
            {            
                pbeList.add(createsObject(pb1.Id, product.get(0)));
            }
            Database.insert(pbeList);
            
            //Method to create the pricebookEntry
            for(Pricebook2 pb2 : ICB_PriceBookEntryDAO.getInstance().getActivePricebook(false)) 
            {
                pbeList2.add(createsObject(pb2.Id, product.get(0)));
            }
            Database.insert(pbeList2);
            
        }  
        catch (Exception e)  
        {
            system.debug(Label.ICB_ERROR_MESSAGE + e.getCause());
        }
        system.debug('Exiting <insertProducts>');
    }
    
   /*******************************************************************
    Purpose: Create the PriceBook
    Parameters: PriceBookId, Product Id
    Returns: PricebookEntry
    Throws [Exceptions]: Exception
    ********************************************************************/
    private static PricebookEntry createsObject(Id vId, Id prodId) 
    {
        return new PricebookEntry ( Pricebook2Id 		= vId, 
                                   Product2Id 			= prodId, 
                                   IsActive 			= TRUE,
                                   UnitPrice 			= 0.0,
                                   UseStandardPrice 	= FALSE);
    }
}