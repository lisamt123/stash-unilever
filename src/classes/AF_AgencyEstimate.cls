public class AF_AgencyEstimate 
{
    /*
     * Author: Shion Earl Abdillah
     * Date: 3/6/14;
     * Name: AF_AgencyEstimate
     * Description: The Brand Estimate object class that provides collection support, DML helpers methods
     *              Initiate this object when creating a brand estimate. 
     * Typical Use: Instantiate class and use as helper for saving AF_Agency_Estimate__c records and adding associated
     *              Entity__c records. Also use for rendering the Matrix by loading AF_Agency_Estimate__c records together with
     *              the parent AF_Brand_Estimate__c. This will provide the correct data for the matrix rendering required.
    */
    
    /*public AF_Brand_Estimate__c BrandEstimate {get; set;} //the parent Brand Estimate record.
    public AF_Agency_Estimate__c AgencyEstimate {get; set;} // the master record.
    
    
    //child collection members of AgencyEstimate
    public Map<Id,AF_Entity__c> ULEntityCollection {get;set;} //the Unilever Entity Collection
    public Map<Id,AF_Entity__c> AgencyEntityCollection {get;set;} //the Agency Entity Collection
    
    //Entity Single Support Members
    public AF_Entity__c Entity; 
    
    //Record Type Support Members
    public Id UnileverRecordTypeId {get;set;}
    public Id AgencyRecordTypeId {get;set;}
    
    public AF_AgencyEstimate(Id pAgencyEstimateId)
    {          
        Inititiate();
        Load(pAgencyEstimateId);
    }
    
    public AF_AgencyEstimate()
    {
        Inititiate();
    }
    
    private void Inititiate()
    {
        try
        {
            UnileverRecordTypeId = AF_Utils.getRecordId('Unilever');
            AgencyRecordTypeId = AF_Utils.getRecordId('Agency');        
        }
        catch(Exception ex)
        {
            System.debug(ex);
        }        
    }
    
    public void Load(Id pAgencyEstimateId)
    {
        try
        {
            UnileverRecordTypeId = AF_Utils.getRecordId('Unilever');
            AgencyRecordTypeId = AF_Utils.getRecordId('Agency');
            AgencyEstimate = [select id FROM AF_Agency_Estimate__c WHERE Id=: pAgencyEstimateId];  //add fields required.
            LoadEntityCollections(AgencyEstimate.Id);            
        }
        catch(Exception ex)
        {
            System.debug(ex);
        }
    }
    
    public void Save(Boolean IsUpdate)
    {
        try
        {
            if(IsUpdate)
            {
                update AgencyEstimate;
            }
            else
            {
                insert AgencyEstimate;            
            }
        
        }
        catch(Exception ex)
        {
            System.debug(ex);
        }
    }
    
    public void LoadEntityCollections(Id pAgencyEstimateId)
    {
        Id UnileverRecordTypeId = AF_Utils.getRecordId('Unilever');
        Id AgencyRecordTypeId = AF_Utils.getRecordId('Agency');
        set<Id> RecordTypeIds = new set<Id> {UnileverRecordTypeId,AgencyRecordTypeId};
        List<AF_Entity__c> UnfilteredEntities = [select Id FROM AF_Entity__c where Id=: pAgencyEstimateId AND RecordTypeId IN : RecordTypeIds];
        if(UnfilteredEntities.size() > 0)
        {
            for(AF_Entity__c entity : UnfilteredEntities)
            {
                if(entity.RecordTypeId == UnileverRecordTypeId){ULEntityCollection.put(entity.Id,entity);}
                else if(entity.RecordTypeId == AgencyRecordTypeId){AgencyEntityCollection.put(entity.Id,entity);}
            }
        }
    }
    
    public void SaveEntityCollections(Boolean IsUpdate)
    {
     try
        {

            List<AF_Entity__c> ULEntityObjects = AF_Utils.ConvertMapValuesToList(ULEntityCollection);            
            List<AF_Entity__c> AgenyEntityObjects = AF_Utils.ConvertMapValuesToList(AgencyEntityCollection);
            if(IsUpdate)
            {
                if(ULEntityCollection.size() > 0){update ULEntityObjects;}
                if(AgencyEntityCollection.size() > 0){update AgenyEntityObjects;}                
            }
            else
            {
                if(ULEntityCollection.size() > 0){insert ULEntityObjects;}
                if(AgencyEntityCollection.size() > 0){insert AgenyEntityObjects;}
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
            delete AgencyEstimate;
        }
        Catch(DmlException ex)
        {
            System.debug(ex.getMessage());       
        }        
    }    
    
    public void AddEntity()
    {

    }*/
    

}