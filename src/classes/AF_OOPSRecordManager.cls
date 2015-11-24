public with sharing class AF_OOPSRecordManager
{
    /*
    Name:       AF_OOPSRecordManager
    Author:     Shion Abdillah
    Date:       01/07/14
    Desc:       This is the core DML and caluclation class for OOPS Actual and OOPS Estimate records.
    */
    
    public List<AF_Agency_Estimate__c> AgencyEstimateCollection {get;set;}
    public List<AF_OOPS_Estimate__c> OOPSEstimateCollection {get;set;}
    public List<AF_OOPS_Actual__c> OOPSActualCollection {get;set;}
    public AF_OOPS_Actual__c OOPSActual {get;set;} 
    public AF_Brand_Estimate__c BrandEstimate {get;set;}
    public Boolean IsBulkified {get;set;} 
    private Set<Id> BrandEstimateIds;
    private Map<Id,AF_Brand_Estimate__c> BrandEstimateCollection;
    private Double OverallPercentage {get;set;} 
    private AF_OOPS_Settings__c CustomSettings {get;set;}
    public String MatrixErrorMessage {get;set;}
    public Boolean IsMatrixError {get;set;}
    
    public AF_OOPSRecordManager(AF_Brand_Estimate__c pBrandEstimate)
    {       
        CustomSettings = AF_OOPS_Settings__c.getOrgDefaults();
        BrandEstimate = pBrandEstimate; 
        BrandEstimateCollection = new Map<Id,AF_Brand_Estimate__c>();
        BrandEstimateCollection.put(BrandEstimate.Id,BrandEstimate);       
        LoadOOPActualSingleRecord();           
        IsBulkified = false;        
    }
    
    public AF_OOPSRecordManager(set<Id> pBrandEstimateIds)
    {   
        CustomSettings = AF_OOPS_Settings__c.getOrgDefaults();  
        BrandEstimateIds = pBrandEstimateIds;
        LoadBrandEstimateCollectionById(BrandEstimateIds);        
        LoadOOPActualSingleRecord();                       
        IsBulkified = true;                  
    }
    
    public AF_OOPSRecordManager()
    {
        CustomSettings = AF_OOPS_Settings__c.getOrgDefaults();
        System.debug('CustomSettings: ' + CustomSettings.Overall_Percentage__c);        
    }
    
    public void RecalculateOOPSEstimates()
    {
        System.debug('Running RecalculateOOPSEstimates... ');
        Double OverallPercentage;
        if(OOPSActual != null)
        {
            OverallPercentage = OOPSActual.Overall__c;          
            LoadOOPSEstimateRecordsByCollection();
            if(OOPSEstimateCollection.size() > 0)
            {
                System.debug('OOPSEstimateCollection.size(): ' + OOPSEstimateCollection.size());
                
                for(AF_OOPS_Estimate__c oopsEstimate : OOPSEstimateCollection)
                {
                    System.debug('(Double)oopsEstimate.AF_Agreed_Base_Fees__c: ' + (Double)oopsEstimate.AF_Agreed_Base_Fees__c);
                    System.debug('(Double)OOPSActual.Overall__c: ' + (Double)OOPSActual.Overall__c);                    
                    oopsEstimate = OverallPercentageCalculation((Double)oopsEstimate.AF_Agreed_Base_Fees__c, (Double)OOPSActual.Overall__c,oopsEstimate,false);
                    System.debug('oopsEstimate.AF_Estimate__c: ' + oopsEstimate.AF_Estimate__c);            
                }           
                try
                {                                               
                    update OOPSEstimateCollection;  
                }   
                catch(DMLException ex)
                {
                	
                	for(AF_OOPS_Estimate__c oopsEstimate : OOPSEstimateCollection)
                	{
                		oopsEstimate.addError(ex);
                	}
                	
                    System.debug('ex: ' + ex);              
                }           
                
            }
        }
    }
           
    @testVisible private void LoadOOPActualSingleRecord()
    {                       
            OverallPercentage = CustomSettings.Overall_Percentage__c;
            
            if(BrandEstimateCollection != null)
            {
                for(AF_Brand_Estimate__c brandEstimateItem : BrandEstimateCollection.values())
                {
                    if(brandEstimateItem != null)
                    {
                        BrandEstimate = brandEstimateItem;
                        /*
                        try
                        {                                               
                            OOPSActual = [Select a.Name,a.AF_value__c, a.AF_Quarter__c, a.AF_Q3__c, a.AF_Q2__c, a.AF_Q1__c, a.AF_GR_Approval__c, a.AF_Fiscal_year__c,a.AF_Agency_lk__c, a.AF_Agency__c From AF_OOPS_Actual__c a WHERE a.AF_Fiscal_year__c = : BrandEstimate.AF_Fiscal_Year__c AND a.AF_Agency_lk__c = : BrandEstimate.AF_Agency__c AND a.AF_Brand__c = : BrandEstimate.Brand__c LIMIT 1];    
                        }   
                        catch(QueryException ex)
                        {} 
                        */                    
                        if(BrandEstimate.AF_OOPS_Estimates_Generated__c == false)
        				{
	                        if(OOPSActual == null )
	                        {
	                            System.debug('BrandEstimate: ' + BrandEstimate);
	                            //create the oops actual record for this - TEMP SOLUTION                
	                            OOPSActual = new AF_OOPS_Actual__c();                       
	                            OOPSActual.AF_Agency__c = BrandEstimate.AF_Agency__c;
	                            OOPSActual.AF_Agency_lk__c = BrandEstimate.AF_Agency__c;
	                            OOPSActual.AF_Agency__c = BrandEstimate.AF_AgencyName__c;
	                            OOPSActual.AF_Brand__c = BrandEstimate.Brand__c;
	                            OOPSActual.Quarter__c = BrandEstimate.AF_Basefee_Estimate_Initial_Quarter__c;                            
	                            OOPSActual.AF_Fiscal_year__c = BrandEstimate.AF_Fiscal_Year__c; 
	                            OOPSActual.Name = BrandEstimate.Name;
	                            OOPSActual.Overall__c = OverallPercentage; 
	                            OOPSActual.AF_Status__c = 'With Category Finance';
	                            OOPSActual.AF_AgencyUsers1__c = BrandEstimate.AF_AgencyUsers1__c;
	                            OOPSActual.AF_AgencyUsers2__c = BrandEstimate.AF_AgencyUsers2__c;
	                            OOPSActual.AF_AgencyUsers3__c = BrandEstimate.AF_AgencyUsers3__c;
	                            OOPSActual.AF_AgencyUsers4__c = BrandEstimate.AF_AgencyUsers4__c;
	                            OOPSActual.AF_AgencyUsers5__c = BrandEstimate.AF_AgencyUsers5__c;
	                            OOPSActual.AF_Cat_Finance_Approver_1__c = BrandEstimate.AF_Cat_Finance_Approver_1__c;
	                            OOPSActual.AF_Cat_Finance_Approver_2__c = BrandEstimate.AF_Cat_Finance_Approver_2__c;
	                            OOPSActual.AF_Cat_Finance_Approver_3__c = BrandEstimate.AF_Cat_Finance_Approver_3__c;
	                            OOPSActual.AF_Cat_Finance_Approver_4__c = BrandEstimate.AF_Cat_Finance_Approver_4__c;
	                            OOPSActual.AF_Cat_Finance_Approver_5__c = BrandEstimate.AF_Cat_Finance_Approver_5__c;                                               
	                           	try
	                           	{
	                            insert OOPSActual;
	                           	}
	                           	catch(DMLException ex)
	                           	{
	                           		OOPSActual.addError(ex);
	                           	}      
	                            //System.debug('New OOPSActual: ' + OOPSActual);                                  
	                        }   
	                        else
	                        {
	                            System.debug('Existing OOPSActual: ' + OOPSActual);
	                        }
        				}           
                    }   
                }       
            }                                                   
    }
        
    @testVisible private void LoadBrandEstimateCollectionById(set<Id> BrandEstimateIds)
    {
        try
        {       
            System.debug('LoadBrandEstimateCollectionById: ' + BrandEstimateIds);       
            // CreateOOPSEstimateRecordsByCollection        
            if(BrandEstimate != null && IsBulkified == false)
            {
                BrandEstimateCollection = new Map<Id,AF_Brand_Estimate__c>();
                BrandEstimateCollection.put(BrandEstimate.Id,BrandEstimate);
            }
            else
            {
                if(BrandEstimateIds.size() > 0)
                BrandEstimateCollection = new Map<Id,AF_Brand_Estimate__c>([Select a.UserEmail__c,a.AF_AgencyName__c, a.TriggerEmailAgency__c, a.SystemModstamp, a.RecordTypeId, a.Q4__c, a.Q1__c, a.OwnerId, a.Name, a.LastViewedDate, a.LastReferencedDate, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.IsUpdate__c, a.IsDeleted, a.Id, a.CreatedUserEmail__c, a.CreatedDate, a.CreatedById, a.Brand__c, a.BrandEstimateArchivedId__c, a.Base_Fee_Total__c, a.Archived_BrandEstimate_Quarter__c, a.Archived_BrandEstimate_BaseFee__c, a.Agency_Base_Fee__c, a.AF_User_TYpe__c, a.AF_Traditional__c, a.AF_Total__c, a.AF_Status_OOPs_Estimate__c, a.AF_Status_OOPs_Atcual__c, a.AF_Status_Bonus__c, a.AF_Status_Base_Fees__c, a.AF_Q3__c, a.AF_Q2__c, a.AF_ProgressImage__c, a.AF_Overall_OOPS__c, a.AF_OOPS_Overall__c, a.AF_Measure_Bonus__c, a.AF_Locked__c, a.AF_Include_in_OOPS_Traditional__c, a.AF_Include_in_OOPS_Digital__c, a.AF_Include_in_OOPS_Adaptation__c, a.AF_GR_Approval__c, a.AF_Fiscal_Year__c, a.AF_Entity_Combination__c, a.AF_Digital__c, a.AF_Crossborder__c, a.AF_Created_By_Batch__c, a.AF_Controller_Flag__c, a.AF_Comment_Type__c, a.AF_Category__c, a.AF_Category_Name__c, a.AF_Category_Name_Wk__c, a.AF_Cat_Finance_Approver_5__c, a.AF_Cat_Finance_Approver_4__c, a.AF_Cat_Finance_Approver_3__c, a.AF_Cat_Finance_Approver_2__c, a.AF_Cat_Finance_Approver_1__c, a.AF_Brand_Agency_FiscalYear__c, a.AF_Bonus_Trigger_Date__c, a.AF_Bonus_Threshold__c, a.AF_Basefee_Estimate_Initial_Quarter__c, a.AF_BaseFeeCreated__c, a.AF_Archived__c, a.AF_Agency__c, a.AF_AgencyUsers5__c, a.AF_AgencyUsers4__c,a.AF_OOPS_Estimates_Generated__c, a.AF_AgencyUsers3__c, a.AF_AgencyUsers2__c, a.AF_AgencyUsers1__c, a.AF_Adaptive__c, a.AF_Active__c From AF_Brand_Estimate__c a where a.Id IN : BrandEstimateIds]);   
            }        
        }
        catch(DMLException ex)
        {
        	
        	for(AF_Brand_Estimate__c brandEstimate : BrandEstimateCollection.values())
        	{
        		brandEstimate.addError(ex);
        	}
        	
            System.debug(ex);
        }
    }
    
    public void CreateOOPSEstimateRecordsByCollection()
    {       
        OOPSEstimateCollection = CreateOOPSEstimateRecords();
    } 
    
    public void LoadOOPSEstimateRecordsByCollection()
    {       
        OOPSEstimateCollection = [Select a.SystemModstamp, a.Name, a.LastViewedDate, a.LastReferencedDate, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.IsDeleted, a.Id, a.CreatedDate, a.CreatedById, a.AF_isComment__c, a.AF_Unilever_Entity__c, a.AF_Unilever_Entity_Column_Name__c, a.AF_Status__c, a.AF_Rate_Type__c, a.AF_Rate_Currency__c, a.AF_Quarter__c, a.AF_Overall_OOPS__c, a.AF_OOPS_Actual__c, a.AF_Locked__c, a.AF_Is_Crossborder_Wk__c, a.AF_IsCrossBorder__c, a.AF_Fiscal_Year__c, a.AF_Estimate__c, a.AF_EstimateLocal__c, a.AF_Brand_Estimate__c, a.AF_Archived__c, a.AF_Agreed_Base_Fees__c, a.AF_Agency_Spot_Rate__c, a.AF_Agency_Exchange_Rate__c, a.AF_Agency_Entity__c, a.AF_Agency_Entity_Column_Name__c, a.AF_Agency_Account__c From AF_OOPS_Estimate__c a where AF_OOPS_Actual__c = : OOPSActual.Id];     
    }
    
    @testVisible private List<AF_OOPS_Estimate__c> CreateOOPSEstimateRecords()
    {               
        List<AF_OOPS_Estimate__c> oopsEstimateCollection; 
        try
        {
            if(BrandEstimateIds.size() > 0)
            {
                AgencyEstimateCollection = [Select a.Variance_Total__c, a.Unilever_Code__c, a.SystemModstamp,  a.Name, a.Matrix_Currency_Code__c, a.LastViewedDate, a.LastReferencedDate, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Indicative_Gain_in_USD__c, a.Indicative_Gain_Loss_in_EUR__c, a.Id, a.CreatedDate, a.CreatedById, a.Category_Agency__c, a.Brand__c, a.Agency_Account__c, a.AF_isLocked__c, a.AF_isComment__c, a.AF_isCommentImage__c, a.AF_Unilever_Estimates__c, a.AF_Unilever_Entity__c, a.AF_Unilever_Entity_Name__c, a.AF_Unilever_Entity_Column_Name__c, a.AF_Traditional__c, a.AF_Traditional_Local__c, a.AF_Total__c, a.AF_Total_Local__c, a.AF_Sum_of_Value__c, a.AF_Sum_of_Percent__c, a.AF_Status__c, a.AF_Ready_For_PO_Entry_Currency__c, a.AF_Rate_Type__c, a.AF_Rate_Currency__c, a.AF_Quarter__c, a.AF_PO_Number__c, a.AF_No_of_Exceptions__c, a.AF_Matrix_Data_Entry_Currency__c, a.AF_Locked__c, a.AF_Is_Unilever_Central_Hub__c, a.AF_IsCrossborder__c, a.AF_IsCrossBorderImage__c, a.AF_Fiscal_Year__c, a.AF_Estimates_don_t_match__c, a.AF_Digital__c, a.AF_Digital_Local__c, a.AF_Deleted__c, a.AF_Crossborder__c, a.AF_Controller_Flag__c, a.AF_Comment_Type__c, a.AF_CentralBilling__c, a.AF_Category__c, a.AF_Brand_Logo__c, a.AF_Brand_Id__c, a.AF_Brand_Estimate__c, a.AF_Brand_Estimate_Status__c, a.AF_Archived__c, a.AF_Agency__c, a.AF_Agency_Spot_Rate__c, a.AF_Agency_Exchange_Rate__c, a.AF_Agency_Entity__c, a.AF_Agency_Entity_Name__c, a.AF_Agency_Entity_Column_Name__c, a.AF_Agency_Category_Id__c, a.AF_Adaptation__c, a.AF_Adaptation_Local__c From AF_Agency_Estimate__c a WHERE a.AF_Brand_Estimate__c IN : BrandEstimateIds];                   
                System.debug('AgencyEstimateCollection.size(): ' + AgencyEstimateCollection.size());
            }           
            if(AgencyEstimateCollection.size() > 0)
            {               
                oopsEstimateCollection = OOPSEstimateFactory(AgencyEstimateCollection); 
                if(BrandEstimate.AF_OOPS_Estimates_Generated__c == false)
                {
                	
	                insert oopsEstimateCollection;
	                if(oopsEstimateCollection.size() > 0)
                	{
                		OOPSActual.AF_Matrix_Generated__c = false;//this needs to be checked when we submit the oops matrix
                        //created another check for which stops entity refreshing here and set to true
                        //if the entity check this if(AF_Matrix_Generated__c = false || AF_Matrix_Generated__c = true) dont refresh ?
                		update OOPSActual;
                	}
	                BrandEstimate.AF_OOPS_Estimates_Generated__c = true;
	                update BrandEstimate;
                }                
            }           
        }
        catch(DMLException ex)
        {
        	BrandEstimate.addError(ex);
            //System.debug(ex);   
        }
        return oopsEstimateCollection;
    }
    
    @testVisible private List<AF_OOPS_Estimate__c> OOPSEstimateFactory(List<AF_Agency_Estimate__c> AgencyEstimateCollection)
    {
        
        List<AF_OOPS_Estimate__c> objCollection = new List<AF_OOPS_Estimate__c>(); 
        if(AgencyEstimateCollection != null)
        {
            if(AgencyEstimateCollection.size() > 0)
            {
                    for(AF_Agency_Estimate__c agencyEstimate : AgencyEstimateCollection)
                    {                   
                        AF_OOPS_Estimate__c objItem = OOPSEstimateSingleFactory(agencyEstimate);
                        objCollection.add(objItem);
                    }
            }           
        }
        return objCollection;
    }
    
    @testVisible private AF_OOPS_Estimate__c OOPSEstimateSingleFactory(AF_Agency_Estimate__c AgencyEstimate)
    {
        AF_OOPS_Estimate__c obj;                
        OverallPercentage = CustomSettings.Overall_Percentage__c;
        Double Estimatevalue = 0;
        BrandEstimate = BrandEstimateCollection.get(AgencyEstimate.AF_Brand_Estimate__c);       
        if(AgencyEstimate != null)      
        {
        	if(BrandEstimate.AF_OOPS_Estimates_Generated__c == false)
        	{        	
            //OOPS Estimate
            obj = new AF_OOPS_Estimate__c();                        
            obj.AF_Agency_Entity__c = AgencyEstimate.AF_Agency_Entity__c;
            obj.AF_Unilever_Entity__c = AgencyEstimate.AF_Unilever_Entity__c; 
            obj.AF_Fiscal_Year__c = AgencyEstimate.AF_Fiscal_Year__c;            
            obj.AF_Rate_Currency__c = AgencyEstimate.AF_Matrix_Data_Entry_Currency__c;
            obj.AF_Agreed_Base_Fees__c = AgencyEstimate.AF_Total__c;
            //obj.AF_Estimate_Local__c = AgencyEstimate.AF_Total__c;
            obj.AF_Agency_Exchange_Rate__c = AgencyEstimate.AF_Agency_Exchange_Rate__c;
            obj.AF_OOPS_Matrix_Currency_Code__c = AgencyEstimate.AF_Matrix_Data_Entry_Currency__c;
            if(OOPSActual != null) {obj.AF_OOPS_Actual__c = OOPSActual.Id;} 
            System.debug('BrandEstimate.AF_Include_in_OOPS_Traditional__c: ' + BrandEstimate.AF_Include_in_OOPS_Traditional__c);
            Estimatevalue = AgencyEstimate.AF_Traditional__c + AgencyEstimate.AF_Digital__c+AgencyEstimate.AF_Adaptation__c;           
            obj = OverallPercentageCalculation((Double)obj.AF_Agreed_Base_Fees__c, OverallPercentage,obj,false);            
            System.debug('OOPSEstimateSingleFactory: ' + obj);                        	
        	}                          
        }
        return obj;
    }   
    
    public AF_OOPS_Estimate__c OverallPercentageCalculation(Double pAgreedBaseFee, Double pOverallPercentage,AF_OOPS_Estimate__c pObj,Boolean IsDefault)
    {
        AF_OOPS_Estimate__c Obj = pObj;
        System.debug('pObj: ' + pObj);
        System.debug('pOverallPercentage: ' + pOverallPercentage);  
        System.debug('pAgreedBaseFee: ' + pAgreedBaseFee);      
        Double OverallPercentage;
        Double AgreedBaseFee = pAgreedBaseFee;  
        if(IsDefault){OverallPercentage = CustomSettings.Overall_Percentage__c;}else if(pOverallPercentage != null){OverallPercentage = pOverallPercentage;}                
        if(AgreedBaseFee != null){Obj.AF_Estimate__c = AgreedBaseFee*OverallPercentage/100;}else{Obj.AF_Estimate__c = 0.00;}
        return Obj;
    }
        
    public void DeleteOOPSActualRecordsByCollection()
    {
        try
        {
            if(BrandEstimateCollection.size() > 0)
            {
                set<Id> BrandEstimateIds = new set<Id>();
                for(AF_Brand_Estimate__c brandEstimate : BrandEstimateCollection.values())
                {
                    BrandEstimateIds.add(brandEstimate.Id);
                }
                if(BrandEstimateIds.size() > 0)
                {                   
                    OOPSActualCollection = [select Id,AF_BrandEstimateId__c FROM AF_OOPS_Actual__c where AF_BrandEstimateId__c IN : BrandEstimateIds];
                    
                    if(OOPSActualCollection.size() > 0)
                    { 
                        delete OOPSActualCollection;
                    }                           
                }
            }           
        }
        catch(DMLException ex)
        {
        	for(AF_OOPS_Actual__c oopsActual : OOPSActualCollection)
        	{
        		oopsActual.addError(ex);
        	}            
        }
    }
}