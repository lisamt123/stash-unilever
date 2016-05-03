/*
     * Author: Shion Earl Abdillah
     * Date: 3/6/14;
     * Name: AF_BrandEstimate
     * Description: The Brand Estimate object class that provides record and child collection support, 
     *              DML helpers methods etc. Initiate this object when creating an brand estimate and its 
     *         child record: Agency_, 
     *              populate it then execute the appropriate DML methods.
     * Version 1.0 : [Shion] Initial Development
     * Version 1.1 : [Irfan] Making class accessible from Ajax calls  
*/
global class AF_Currency {
    
   /* public AF_Currency__c currency1 {get; set;}
    public Id CurrencyId {get;set;}
    
    //Collection Members
    public List<AF_Brand_Estimate__c> BrandEstimateCollection {get;set;}    
    public set<AF_Entity__c> UnileverEntityCollection {get;set;}
    public set<AF_Entity__c> AgencyEntityCollection {get;set;} 
    
    /*The following maps contain the Entity__c records that the matrix needs to account for in the X and Y of it.  
     * Use the following two Maps to render the x and y grid. Create control flow using these two maps 
     * .size() values for the x and the y accordingly. This enables the rendering of the matrix HTML grid without
     * any AF_Agency_Estimate__c record values in each. 
    */    
   /* Map<Id,AF_Entity__c> UnileverVerticalEntities {get;set;} 
    Map<Id,AF_Entity__c> AgencyHorizontalEntities {get;set;} 
    
    // The following maps provide the data construct and order for the matrix.  
    public Map<Id,AF_Agency_Estimate__c> HorizontalMatrixMap {get;set;} //holds the AF_Agency_Estimate__c nodes for a given row. 
    public Map<Id,Map<Id,AF_Agency_Estimate__c>> VerticalMatrixMap {get;set;} //this will use HorizontalMatrixMap to construct a rox of cells/nodes for the matrix
    
     //Record Type Support Members
    public Id UnileverRecordTypeId {get;set;}
    public Id AgencyRecordTypeId {get;set;}
        
    //Constructor
    public AF_Currency(Id pCurrencyId)
    {   
        CurrencyId = pCurrencyId;
        UnileverEntityCollection = new set<AF_Entity__c>();
        AgencyEntityCollection = new set<AF_Entity__c>();
        //Load(Currency1Id);
        
    }   */ 
  
    
 
    //DML Methods
   /* public void Load(Id pCurrencyId)
    {
        try
        {
            Currency = [select id FROM AF_Currency__c WHERE Id=: pCurrencyId];  //TODO: add fields into query required as we progress.
            if(Currency != null)
            {
                //load any associated Agency Estimates that have been created for this Brand Estimate.
                AgencyEstimateCollection = [Select a.Name, a.Id, a.CreatedById, a.AF_Brand_Estimate__c, a.AF_Unilever_Entity__c, a.AF_Traditional__c, a.AF_Traditional_Local__c, a.AF_Total__c, a.AF_Total_Local__c, a.AF_Agency_Entity__c, a.AF_Rate_Type__c, a.AF_Rate_Currency__c From AF_Agency_Estimate__c a WHERE a.AF_Brand_Estimate__c =: BrandEstimate.Id]; //TODO: add fields into query required as we progress.
                                
                //Generate Matrix Map Collection
                
            }
        }
        catch(Exception ex)
        {
            System.debug(ex);
        }
    }  */ 
   /* public void Save(Boolean IsUpdate)
    {
        try
        {
            if(IsUpdate)
            {
                update Currency1;
            }
            else
            {
                insert Currency1;            
            }
        
        }
        catch(Exception ex)
        {
            System.debug(ex);
        }
    }    
    public void Remove()
    {
        try
        {
            delete Currency1;
        }
        catch(Exception ex)
        {
            System.debug(ex);
        }
    }*/
    
    
}