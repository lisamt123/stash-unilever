Global with sharing class AF_BonusRecordManager {
    /*
    Name:       AF_BonusRecordManager
    Author:     Shion Abdillah
    Date:       22/07/14
    Desc:       This is the core DML and caluclation class for Bonus Records.
    */
    public List<AF_Agency_Estimate__c> AgencyEstimateCollection {get;set;}
    public AF_Brand_Estimate__c BrandEstimate {get;set;}
    public Boolean IsBulkified {get;set;}
    private Boolean IsPilotModel {get;set;} 
    private Set<Id> BrandEstimateIds; 
    private List<AF_Brand_Estimate__c> BrandEstimateCollection; 
    private AF_Bonus_Results__c GlobalBonusResults;
    private AF_Bonus_Summary__c BonusSummary;
    private AF_Bonus_Matrix__c BonusMatrix;
    private AF_Bonus_Threshold__c BonusThreshold; 
    private List<AF_Bonus_Matrix__c> BonusMatrixCollection;
    private Map<string,double> CountryTotalMap = new Map<string,double>();
    public String MatrixErrorMessage {get;set;}
    public Boolean IsMatrixError {get;set;}
    Global set<string> ExceptionList = new set<string>();
    public AF_BonusRecordManager(AF_Brand_Estimate__c pBrandEstimate)
    {               
        BrandEstimate = pBrandEstimate; 
        BrandEstimateCollection = new List<AF_Brand_Estimate__c>();
        BrandEstimateCollection.add(BrandEstimate); 
        IsBulkified = false;                
    }
    
    public AF_BonusRecordManager(set<Id> pBrandEstimateIds)
    {   
        BrandEstimateIds = pBrandEstimateIds;
        LoadBrandEstimateCollectionById(BrandEstimateIds);
        IsBulkified = true;                  
    }
    
    public AF_BonusRecordManager()
    {
    
    }
        
    @testVisible private void LoadBrandEstimateCollectionById(set<Id> BrandEstimateIds)
    {
        try
        {                   
            System.debug('LoadBrandEstimateCollectionById: ' + BrandEstimateIds);                                      
            if(BrandEstimateIds.size() > 0)
            BrandEstimateCollection = [Select a.UserEmail__c,a.AF_No_Bonus__c,a.AF_AgencyName__c, a.AF_Pilot_Model__c, a.TriggerEmailAgency__c, a.SystemModstamp, a.RecordTypeId, a.Q4__c, a.Q1__c, a.OwnerId, a.Name, a.LastViewedDate, a.LastReferencedDate, a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, a.IsUpdate__c, a.IsDeleted, a.Id, a.CreatedUserEmail__c, a.CreatedDate, a.CreatedById, a.Brand__c, a.BrandEstimateArchivedId__c, a.Base_Fee_Total__c, a.Archived_BrandEstimate_Quarter__c, a.Archived_BrandEstimate_BaseFee__c, a.Agency_Base_Fee__c, a.AF_User_TYpe__c, a.AF_Traditional__c, a.AF_Total__c, a.AF_Status_OOPs_Estimate__c, a.AF_Status_OOPs_Atcual__c, a.AF_Status_Bonus__c, a.AF_Status_Base_Fees__c, a.AF_Q3__c, a.AF_Q2__c, a.AF_ProgressImage__c, a.AF_Overall_OOPS__c, a.AF_OOPS_Overall__c, a.AF_Measure_Bonus__c, a.AF_Locked__c, a.AF_Include_in_OOPS_Traditional__c, a.AF_Include_in_OOPS_Digital__c, a.AF_Include_in_OOPS_Adaptation__c, a.AF_GR_Approval__c, a.AF_Fiscal_Year__c, a.AF_Entity_Combination__c, a.AF_Digital__c, a.AF_Crossborder__c, a.AF_Created_By_Batch__c, a.AF_Controller_Flag__c, a.AF_Comment_Type__c, a.AF_Category__c, a.AF_Category_Name__c, a.AF_Category_Name_Wk__c, a.AF_Cat_Finance_Approver_5__c, a.AF_Cat_Finance_Approver_4__c, a.AF_Cat_Finance_Approver_3__c, a.AF_Cat_Finance_Approver_2__c, a.AF_Cat_Finance_Approver_1__c, a.AF_Brand_Agency_FiscalYear__c, a.AF_Bonus_Trigger_Date__c, a.AF_Bonus_Threshold__c, a.AF_Basefee_Estimate_Initial_Quarter__c, a.AF_BaseFeeCreated__c, a.AF_Archived__c, a.AF_Agency__c, a.AF_AgencyUsers5__c, a.AF_AgencyUsers4__c, a.AF_AgencyUsers3__c, a.AF_AgencyUsers2__c, a.AF_AgencyUsers1__c, a.AF_Adaptive__c, a.AF_Active__c,a.AF_BrandName__c From AF_Brand_Estimate__c a where a.Id IN : BrandEstimateIds];                                                     
        }
        catch(DMLException ex)
        {
            System.debug(ex);
        }
    }
    
    public void CreateMultiObjectRecords()
    {   
        try
        {                                   
            if(BrandEstimateCollection.size() > 0)
            {
                AgencyEstimateCollection = [Select a.Variance_Total__c,a.Agency_Account_Id__c, a.Unilever_Code__c, a.SystemModstamp,a.Name, a.Matrix_Currency_Code__c, a.LastViewedDate, a.LastReferencedDate, a.LastModifiedDate, a.LastModifiedById, a.IsDeleted, a.Indicative_Gain_in_USD__c, a.Indicative_Gain_Loss_in_EUR__c, a.Id, a.CreatedDate, a.CreatedById, a.Category_Agency__c, a.Brand__c, a.Agency_Account__c, a.AF_isLocked__c, a.AF_isComment__c, a.AF_isCommentImage__c, a.AF_Unilever_Estimates__c, a.AF_Unilever_Entity__c, a.AF_Unilever_Entity_Name__c, a.AF_Unilever_Entity_Column_Name__c, a.AF_Traditional__c, a.AF_Traditional_Local__c, a.AF_Total__c, a.AF_Total_Local__c, a.AF_Sum_of_Value__c, a.AF_Sum_of_Percent__c, a.AF_Status__c, a.AF_Ready_For_PO_Entry_Currency__c, a.AF_Rate_Type__c, a.AF_Rate_Currency__c, a.AF_Quarter__c, a.AF_PO_Number__c, a.AF_No_of_Exceptions__c, a.AF_Matrix_Data_Entry_Currency__c, a.AF_Locked__c, a.AF_Is_Unilever_Central_Hub__c, a.AF_IsCrossborder__c, a.AF_IsCrossBorderImage__c, a.AF_Fiscal_Year__c, a.AF_Estimates_don_t_match__c, a.AF_Digital__c, a.AF_Digital_Local__c, a.AF_Deleted__c, a.AF_Crossborder__c, a.AF_Controller_Flag__c, a.AF_Comment_Type__c, a.AF_CentralBilling__c, a.AF_Category__c, a.AF_Brand_Logo__c, a.AF_Brand_Id__c, a.AF_Brand_Estimate__c, a.AF_Brand_Estimate_Status__c, a.AF_Archived__c, a.AF_Agency__c, a.AF_Agency_Spot_Rate__c, a.AF_Agency_Exchange_Rate__c, a.AF_Agency_Entity__c, a.AF_Agency_Entity_Name__c, a.AF_Agency_Entity_Column_Name__c, a.AF_Agency_Category_Id__c, a.AF_Adaptation__c, a.AF_Adaptation_Local__c From AF_Agency_Estimate__c a WHERE a.AF_Brand_Estimate__c IN : BrandEstimateIds];               
            }
            
            for(AF_Brand_Estimate__c brandEstimate : BrandEstimateCollection)
            {
                if(brandEstimate.AF_Basefee_Estimate_Initial_Quarter__c.contains('Q4') == true && brandEstimate.AF_No_Bonus__c==false)
                {
                    BonusMatrixCollection = BonusMultiObjectFactory(brandEstimate, AgencyEstimateCollection);
                }               
            }
        }
        catch(DMLException ex)
        { 
            System.debug(ex);   
        }
    }
    
    //This method contains 2 DMLs in the FOR loop and is being called in the for loop again, it needs to be refactored.
    @testVisible private List<AF_Bonus_Matrix__c> BonusMultiObjectFactory(AF_Brand_Estimate__c pBrandEstimate, List<AF_Agency_Estimate__c> pAgencyEstimateCollection)
    {
        set<Id> BonusThresholdId = new set<Id>();
        IsMatrixError = false;
        if(pBrandEstimate.AF_Pilot_Model__c == true){IsPilotModel=true;}else{IsPilotModel=false;}
        
        List<AF_Bonus_Matrix__c> objCollection = new List<AF_Bonus_Matrix__c>();
        set<Id> BonusThresholdIds = new set<Id>();
        List<AF_Bonus_Threshold__c> BonusThresholdCollection = [Select a.Year__c,a.Country_Name__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastViewedDate,  a.Id,a.Brand_Name__c, a.Bonus_Measure__c, a.Agency_Name__c, a.AF_Unique_Thresholds__c, a.AF_Traditional__c, a.AF_Stretching__c, a.AF_Pilot_Model__c, a.AF_Outstanding__c, a.AF_Minimum__c, a.AF_Digital__c, a.AF_Country__c, a.AF_Country_Full_Name__c, a.AF_Category__c, a.AF_Brand_Estimate__c, a.AF_Bonusable_Fee__c From AF_Bonus_Threshold__c a where Agency_Name__c=:pBrandEstimate.AF_Agency__c and Brand_Name__c=:pBrandEstimate.Brand__c and Year__c =: pBrandEstimate.AF_Fiscal_Year__c ];
        if(BonusThresholdCollection.size()>0){
            for(AF_Bonus_Threshold__c b:BonusThresholdCollection){
            BonusThresholdId.add(b.Id);
            }
        }
        system.debug('BonusThresholdCollection.size():  ' + BonusThresholdCollection.size());
        system.debug('BonusThresholdCollection:  ' + BonusThresholdCollection);
        
        List<AF_Agency_Estimate__c> filteredAgencyEstimateCollection = new List<AF_Agency_Estimate__c>(); 
        List<AF_Bonus_Summary__c> BonusSummarys = [Select a.Name, a.Id, a.AF_Status__c, a.AF_Fiscal_Year__c, a.AF_Brand__c, a.AF_Agency__c From AF_Bonus_Summary__c a where a.AF_Brand__c = : pBrandEstimate.Brand__c AND a.AF_Agency__c = : pBrandEstimate.AF_Agency__c AND a.AF_Fiscal_Year__c = : pBrandEstimate.AF_Fiscal_Year__c LIMIT 1];
        
        set<string> UnileverEntityCollection = new set<string>();
        set<string> UnileverEntityWithBonusThresholdCollection = new set<string>();
       
        for(AF_Bonus_Summary__c bs : BonusSummarys)
        {
            BonusSummary = bs; //set the bonus summer to be used.
        }
        
        system.debug('BonusSummary:  ' + BonusSummary);
        
        if(BonusSummary == null){BonusSummary = BonusSummarySingleFactory(pBrandEstimate);} //no Bonus Summary was found so nothing was able to be used.
        
        Boolean isUpdate = false;
        for(AF_Bonus_Threshold__c bonusThreshold : BonusThresholdCollection) 
        {               
            if(pBrandEstimate.AF_Pilot_Model__c == true)
            {
                bonusThreshold.AF_Pilot_Model__c = true;
                isUpdate = true;
            }
        }
        
        try
        {
            if(isUpdate == true)
            {
                update BonusThresholdCollection;
            }   
        }
        catch(DMLException ex)
        {
            System.debug(ex);   
        }

        if(IsPilotModel == false)
        {

                     
            Map<String,Double> CountryNameAndTotalCollection = new Map<String,Double>();            
            List<AggregateResult> AgencyEstimateTotalCountByCountry = [SELECT SUM(AF_Total__c) CountryTotal,AF_Unilever_Entity__r.AF_Country__c CountryName FROM AF_Agency_Estimate__c  where AF_Brand_Estimate__c=: pBrandEstimate.Id GROUP BY AF_Unilever_Entity__r.AF_Country__c];
            if(AgencyEstimateTotalCountByCountry.size() > 0)
            {
                for (AggregateResult ar : AgencyEstimateTotalCountByCountry)
                {       
                    if(Double.valueof(ar.get('CountryTotal')) > 0)      
                    CountryNameAndTotalCollection.put(String.ValueOf(ar.get('CountryName')),Double.valueof(ar.get('CountryTotal')));                                
                }               
            }
            Boolean result = false;
            Boolean finalResult = true;
            set<string> CountryNames =  new set<string>(); 
            set<string> BonusThresholdCountryNames = new set<string>(); 
            set<string> ExceptionList = new set<string>(); 
            if(CountryNameAndTotalCollection.size() > 0)
            {
                    
                for(AF_Bonus_Threshold__c bonusThreshold : BonusThresholdCollection) 
                {
                    if(BonusThresholdCountryNames.contains(bonusThreshold.Country_Name__c) == false)
                    {
                        BonusThresholdCountryNames.add(bonusThreshold.Country_Name__c);
                    }                   
                }
                System.debug('BonusThresholdCountryNames.size(): ' + BonusThresholdCountryNames.size());
                    
                for(string countryName : CountryNameAndTotalCollection.keySet()) 
                {
                    system.debug('CountryNames: ' + countryName);
                    if(CountryNames.contains(countryName) == false)
                    {
                        CountryNames.add(countryName);  
                    }                   
                }
                System.debug('CountryNames.size(): ' + CountryNames.size());            
                ExceptionList = CountryNames.clone();
                System.debug('ExceptionList.size(): ' + ExceptionList);
                for(string countryName :ExceptionList)
                {
                    system.debug('countryName to check: ' + countryName);
                    system.debug('countryName result: ' + BonusThresholdCountryNames.contains(countryName));
                    if(BonusThresholdCountryNames.contains(countryName) == true)                                
                    ExceptionList.remove(countryName); 
                }
                
            
                if(ExceptionList.size() > 0)
                {
                    finalResult = false;
                }
               /*                                                 
                if(finalResult == false)
                {
                    MatrixErrorMessage = 'Cannot create bonus matrix due to insufficient Bonus Threshold records. ';
                    string countries = '';
                    for(string countryName : ExceptionList)
                    {
                        countries = countries + countryName + ' , ';
                    }
                    countries = countries.substring(0,countries.length()-2);
                    MatrixErrorMessage = MatrixErrorMessage + ' Please add Bonus Thresholds for the following unilever entities:  ' +countries; 
                    IsMatrixError = true;                   
                }
                */ 
            }
        }
        
        if(IsMatrixError == false)
        {
                                                    
            for(AF_Bonus_Threshold__c bonusThreshold : BonusThresholdCollection) 
            {           
                BonusThresholdIds.add(bonusThreshold.Id);
                if(!UnileverEntityWithBonusThresholdCollection.contains(bonusThreshold.Country_Name__c))
                {
                    UnileverEntityWithBonusThresholdCollection.add(bonusThreshold.Country_Name__c);
                    system.debug('Entity Country Added.');      
                }           
            }
           system.debug('UnileverEntityWithBonusThresholdCollection.size():' + UnileverEntityWithBonusThresholdCollection.size());
           
            if(IsPilotModel != true)
            {
                for(AF_Agency_Estimate__c agencyEstimate : pAgencyEstimateCollection)
                {
                    system.debug('agencyEstimate.AF_Unilever_Entity_Name__c: ' + agencyEstimate.AF_Unilever_Entity_Name__c);
                    
                    if(UnileverEntityWithBonusThresholdCollection.contains(agencyEstimate.AF_Unilever_Entity_Name__c))
                    {
                        filteredAgencyEstimateCollection.add(agencyEstimate);                                   
                    }
                }
            }
            else if(IsPilotModel == true)
            {
                for(AF_Agency_Estimate__c agencyEstimate : pAgencyEstimateCollection)
                {
                    filteredAgencyEstimateCollection.add(agencyEstimate);
                }           
            }
            
            system.debug('filteredAgencyEstimateCollection : ' + filteredAgencyEstimateCollection.size());    
            
            if(BonusThresholdCollection.size() > 0)     
            {           
                system.debug('BonusThresholdIds: ' + BonusThresholdIds.size());         
                Map<Id,AF_Bonus_Results__c> BonusResultsCollection = new Map<Id,AF_Bonus_Results__c>([Select a.Name,a.AF_Total_Remuneration__c, a.AF_Bonus_Thresholds__c From AF_Bonus_Results__c a where a.AF_Bonus_Thresholds__c IN : BonusThresholdIds AND a.RecordTypeId = : Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Annual').getRecordTypeId()]);                                     
                List<AF_Sub_Result__c> listSubResult = [select AF_Digital__c,AF_Traditional__c,AF_Bonus_Threshold__c from AF_Sub_Result__c where AF_Bonus_Threshold__c IN :BonusThresholdId];
                system.debug('BonusResultsCollection: ' + BonusResultsCollection.size());       
               system.debug('IsPilotModel:  ' + IsPilotModel);             
                //if(BonusResultsCollection.size() > 0){BonusResults = BonusResultSingleFactory(pBrandEstimate);BonusResultsCollection.put(BonusResults.Id,BonusResults);}
                for(AF_Bonus_Threshold__c bonusThreshold : BonusThresholdCollection) 
                {   
                    objCollection = new List<AF_Bonus_Matrix__c>();  
                                                
                    if(IsPilotModel == false)
                    {                                                   
                        for(AF_Bonus_Results__c br :  BonusResultsCollection.Values())
                        {
                            if(br.AF_Bonus_Thresholds__c == bonusThreshold.Id)
                            {                        
                                for(AF_Agency_Estimate__c agencyEstimate : filteredAgencyEstimateCollection)
                                {
                                    if(bonusThreshold.Country_Name__c == agencyEstimate.AF_Unilever_Entity_Name__c)
                                    {
                                        AF_Bonus_Matrix__c objItem = BonusMatrixSingleFactory(agencyEstimate,BonusSummary,br,bonusThreshold,listSubResult);
                                        objCollection.add(objItem); 
                                    }                           
                                }
                            }   
                        }                   
                    }
                    else
                    {   
                             
                        for(AF_Agency_Estimate__c agencyEstimate : filteredAgencyEstimateCollection)
                        {                       
                            AF_Bonus_Matrix__c objItem = BonusMatrixSingleFactory(agencyEstimate,BonusSummary,null,bonusThreshold,null);
                            objCollection.add(objItem);                                                     
                        }
                        
                        
                        
                    }
                    
                    if(IsPilotModel == true)
                    {
                        objCollection = PilotModelBonusMatrixGenerator(pBrandEstimate,objCollection, GlobalBonusResults,bonusThreshold);                    
                    }               
                    
                    if(objCollection.size() > 0)
                    {
                        try
                        {                       
                            insert objCollection; //this DML in the FOR LOOP
                        }
                        catch(DMLException ex)
                        {
                            System.debug(ex);
                        }       
                    }           
                    
                }                                   
            }
        }           
        return objCollection;   
    }
    
    @testVisible private AF_Bonus_Summary__c BonusSummarySingleFactory(AF_Brand_Estimate__c pBrandEstimate)
    {
        AF_Bonus_Summary__c obj = new AF_Bonus_Summary__c();
        if(pBrandEstimate != null)      
        {
            try
            {  
                obj.Name = pBrandEstimate.AF_BrandName__c + ' -  ' + pBrandEstimate.AF_AgencyName__c + ' -  ' + pBrandEstimate.AF_Fiscal_Year__c;
                obj.AF_Agency__c = pBrandEstimate.AF_Agency__c;
                obj.AF_Brand__c = pBrandEstimate.Brand__c;
                obj.AF_Fiscal_Year__c = pBrandEstimate.AF_Fiscal_Year__c;
                obj.AF_Is_Pilot_Model__c = pBrandEstimate.AF_Pilot_Model__c;//Adding pilot model to bonus summary from brand estimate    
                insert obj;                     
            }
            catch(DMLException ex)
            {
                System.debug(ex);
            }       
        }                                           
        return obj;
    }   
    
    @testVisible private AF_Bonus_Results__c BonusResultSingleFactory(AF_Bonus_Threshold__c pBonusThreshold, AF_Brand_Estimate__c pBrandEstimate, string pRecordTypeId)
    {
        AF_Bonus_Results__c obj = new AF_Bonus_Results__c();
        if(pBrandEstimate != null)      
        {
            try
            {       
                
                obj.AF_Bonus_Thresholds__c = pBonusThreshold.Id;              
                obj.AF_Total_Remuneration__c = 0.00;
                obj.AF_Total_bonus_fees__c = 0.00;
                obj.AF_Bonusable_Fees__c = 0.00;
                obj.AF_Locked__c = false;
                obj.AF_Status__c = 'None';
                if(pRecordTypeId != null){obj.RecordTypeId = pRecordTypeId;}
                insert obj;                 
            }
            catch(DMLException ex)
            {
                System.debug(ex);
            }       
        }   
        return obj;
    }   
    
    @testVisible private AF_Bonus_Matrix__c BonusMatrixSingleFactory(AF_Agency_Estimate__c pAgencyEstimate, AF_Bonus_Summary__c pBonusSummary, AF_Bonus_Results__c pBonusResults, AF_Bonus_Threshold__c pBonusThreshold,List<AF_Sub_Result__c> subresult)
    {
        AF_Bonus_Matrix__c obj = new AF_Bonus_Matrix__c();  
        double BonusableFee= 0.00;  
        Boolean Digital=false;
        Boolean Traditional = false;        
        if(pAgencyEstimate != null)     
        {
            try
            {   
                                 
                obj.AF_Fiscal_Year__c = pAgencyEstimate.AF_Fiscal_Year__c;
                // obj.AF_Value__c = pAgencyEstimate.AF_Total__c;
                obj.AF_Agency_Exchange_Rate__c = pAgencyEstimate.AF_Agency_Exchange_Rate__c;
                obj.AF_Agency_Entity__c = pAgencyEstimate.AF_Agency_Entity__c;
                obj.AF_Unilever_Entity__c = pAgencyEstimate.AF_Unilever_Entity__c;
                obj.AF_Agency_Spot_Rate__c = pAgencyEstimate.AF_Agency_Spot_Rate__c; 
                obj.AF_Agency_Exchange_Rate__c = pAgencyEstimate.AF_Agency_Exchange_Rate__c;           
                obj.AF_Rate_Currency__c = pAgencyEstimate.AF_Matrix_Data_Entry_Currency__c;                                             
                if(obj.AF_Agency_Exchange_Rate__c != null){if(obj.AF_Value__c != null){obj.AF_Value_Local__c = obj.AF_Value__c * obj.AF_Agency_Exchange_Rate__c;}}                
                if(pBonusResults != null)
                {
                obj.AF_Bonus_Results__c = pBonusResults.Id;
                }
                obj.AF_Bonus_Summary__c = pBonusSummary.Id;
                System.debug('pBonusThreshold: ' + pBonusThreshold);             
                if(pBonusThreshold != null)
                {                                       
                    System.debug('pBonusThreshold.Id: ' + pBonusThreshold.Id);
                    System.debug('pBonusThreshold.AF_Brand_Estimate__c: ' + pBonusThreshold.AF_Brand_Estimate__c);
                    System.debug('IsPilotModel: ' + IsPilotModel);
                    System.debug('pAgencyEstimate.AF_Fiscal_Year__c: ' + pAgencyEstimate.AF_Fiscal_Year__c);
                    System.debug('pBonusThreshold.Year__c: ' + pBonusThreshold.Year__c);
                    System.debug('pAgencyEstimate.AF_Digital__c: ' + pAgencyEstimate.AF_Digital__c);
                    System.debug('pAgencyEstimate.AF_Traditional__c: ' + pAgencyEstimate.AF_Traditional__c);
                    //system.debug('subresult...'+subresult);
                    if(subresult!=null){
                    for(AF_Sub_Result__c sb:subresult){
                        if(sb.AF_Bonus_Threshold__c == pBonusThreshold.Id){
                            if(sb.AF_Digital__c == true){
                                Digital = true;
                            }
                            if(sb.AF_Traditional__c == true){
                                Traditional = true;
                            }
                        }
                    }
                    system.debug('Digital....'+Digital);
                     system.debug('Traditional....'+Traditional);
                    
                    if(pAgencyEstimate.AF_Fiscal_Year__c == pBonusThreshold.Year__c)
                    {
                        if(Digital)
                        {
                            BonusableFee =  BonusableFee + pAgencyEstimate.AF_Digital__c;
                        }   
                        if(Traditional)
                        {
                            BonusableFee = BonusableFee + pAgencyEstimate.AF_Traditional__c;
                        }                       
                    }  
                    }
                    else{
                    if(pAgencyEstimate.AF_Fiscal_Year__c == pBonusThreshold.Year__c)
                    {
                        if(pBonusThreshold.AF_Digital__c == true)
                        {
                            BonusableFee =  BonusableFee + pAgencyEstimate.AF_Digital__c;
                        }   
                        if(pBonusThreshold.AF_Traditional__c == true)
                        {
                            BonusableFee = BonusableFee + pAgencyEstimate.AF_Traditional__c;
                        }                       
                    } 
                    
                    }
                                                                                                   
                }
                System.debug('BonusableFee: ' + BonusableFee);
                obj.AF_BonusableFee__c = BonusableFee;
                AddCountryTotal(pBonusThreshold.AF_Country__c, BonusableFee);
                obj.AF_Base_Fee_Country_Total__c = CountryTotalMap.get(pBonusThreshold.AF_Country__c);
                System.debug('obj.AF_Base_Fee_Country_Total__c: ' + obj.AF_Base_Fee_Country_Total__c);
                //insert obj;
            }
            catch(DMLException ex)
            {
                System.debug(ex);
            }
        }
        return obj;
    }   
    
    
    @testVisible private List<AF_Bonus_Matrix__c> PilotModelBonusMatrixGenerator(AF_Brand_Estimate__c pBrandEstimate, List<AF_Bonus_Matrix__c> pBonusMatrixCollection, AF_Bonus_Results__c pBonusResult,AF_Bonus_Threshold__c pBonusThreshold)
    { 
        System.debug('PilotModelBonusMatrixGenerator is running.');
        System.debug('RecordTypeId for Bonus Annual: ' + Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Annual').getRecordTypeId());
        
        System.debug('pBonusMatrixCollection size is: ' + pBonusMatrixCollection.size());       
        Double MatrixTotal = 0.00;                       
        AF_Bonus_Results__c BonusResults;
        if(pBonusResult == null)
        {
            BonusResults = BonusResultSingleFactory(pBonusThreshold, pBrandEstimate,Schema.SObjectType.AF_Bonus_Results__c.getRecordTypeInfosByName().get('Bonus Annual').getRecordTypeId());
            GlobalBonusResults = BonusResults;              
        }   
        else
        {
            BonusResults = pBonusResult;
        }
                
        System.debug('BonusResults: ' + BonusResults);
        
        if(BonusResults.AF_Total_Remuneration__c != null)
        {
            if(BonusResults.AF_Total_Remuneration__c >= 0.00)
            {               
                if(pBonusMatrixCollection != null)
                {
                    if(pBonusMatrixCollection.size() > 0)
                    {
                        for(AF_Bonus_Matrix__c bm : pBonusMatrixCollection)
                        {
                            //Add up the total of all the totals in the matrix items
                            MatrixTotal = MatrixTotal + bm.AF_BonusableFee__c; 
                        }                       
                        //System.debug('MatrixTotal is: ' + MatrixTotal);                       
                        for(AF_Bonus_Matrix__c bm : pBonusMatrixCollection)
                        {
                            if(MatrixTotal != 0.00)
                            {                   
                                System.debug('MatrixTotal is: ' + MatrixTotal);
                                System.debug('Old AF_Value_Local__c is: ' + bm.AF_Value__c);
                                bm.AF_Value__c = (bm.AF_BonusableFee__c/MatrixTotal) *  BonusResults.AF_Total_Remuneration__c;                                                              
                                System.debug('New AF_Value__c is: ' + bm.AF_Value__c);
                            }                           
                            bm.AF_Bonus_Results__c = BonusResults.Id;                           
                        }                                       
                    }   
                }               
            }
                        
        }   
        return pBonusMatrixCollection;
    }
    
    
    private void AddCountryTotal(string countryName, double valueToAdd)
    {        
        Double result = CountryTotalMap.get(countryName); 
        if(result != null)
        {
           result = result +  valueToAdd;
           CountryTotalMap.put(countryName,result);
        }
        else
        {
            CountryTotalMap.put(countryName,valueToAdd);
        }           
    }
    
    public Boolean BonusThresholdValidationCheck(AF_Brand_Estimate__c pBrandEstimate)
    {                          
            Boolean result = false;
            Boolean finalResult = false;
            set<string> CountryNames =  new set<string>(); 
            set<string> BonusThresholdCountryNames = new set<string>(); 
            //set<string> ExceptionList = new set<string>(); 
            if(pBrandEstimate.AF_Pilot_Model__c==false && pBrandEstimate.AF_No_Bonus__c == false){
            
            if(pBrandEstimate.AF_Status_Base_Fees__c == 'With Category Finance' && pBrandEstimate.AF_Basefee_Estimate_Initial_Quarter__c.contains('Q4') == true)
            {
                Map<String,Double> CountryNameAndTotalCollection = new Map<String,Double>();            
                List<AggregateResult> AgencyEstimateTotalCountByCountry = [SELECT SUM(AF_Total__c) CountryTotal,AF_Unilever_Entity__r.AF_Country__c CountryName FROM AF_Agency_Estimate__c  where AF_Brand_Estimate__c=: pBrandEstimate.Id GROUP BY AF_Unilever_Entity__r.AF_Country__c];
                List<AF_Bonus_Threshold__c> BonusThresholdCollection = [Select a.Year__c,a.Country_Name__c, a.SystemModstamp, a.OwnerId, a.Name, a.LastViewedDate,  a.Id,a.Brand_Name__c, a.Bonus_Measure__c, a.Agency_Name__c, a.AF_Unique_Thresholds__c, a.AF_Traditional__c, a.AF_Stretching__c, a.AF_Pilot_Model__c, a.AF_Outstanding__c, a.AF_Minimum__c, a.AF_Digital__c, a.AF_Country__c, a.AF_Country_Full_Name__c, a.AF_Category__c, a.AF_Brand_Estimate__c, a.AF_Bonusable_Fee__c From AF_Bonus_Threshold__c a where Agency_Name__c=:pBrandEstimate.AF_Agency__c and Brand_Name__c=:pBrandEstimate.Brand__c and Year__c =: pBrandEstimate.AF_Fiscal_Year__c ];
                if(AgencyEstimateTotalCountByCountry.size() > 0)
                {
                    for (AggregateResult ar : AgencyEstimateTotalCountByCountry)
                    {       
                        if(Double.valueof(ar.get('CountryTotal')) > 0)      
                        CountryNameAndTotalCollection.put(String.ValueOf(ar.get('CountryName')),Double.valueof(ar.get('CountryTotal')));                                
                    }               
                }
                 
                if(CountryNameAndTotalCollection.size() > 0)
                {
                        
                    for(AF_Bonus_Threshold__c bonusThreshold : BonusThresholdCollection) 
                    {
                        if(BonusThresholdCountryNames.contains(bonusThreshold.Country_Name__c) == false)
                        {
                            BonusThresholdCountryNames.add(bonusThreshold.Country_Name__c);
                        }                   
                    }
                    System.debug('BonusThresholdCountryNames.size(): ' + BonusThresholdCountryNames.size());
                        
                    for(string countryName : CountryNameAndTotalCollection.keySet()) 
                    {
                        system.debug('CountryNames: ' + countryName);
                        if(CountryNames.contains(countryName) == false)
                        {
                            CountryNames.add(countryName);  
                        }                   
                    }
                    System.debug('CountryNames.size(): ' + CountryNames.size());            
                    ExceptionList = CountryNames.clone();
                    System.debug('ExceptionList.size(): ' + ExceptionList);
                    for(string countryName :ExceptionList)
                    {
                        system.debug('countryName to check: ' + countryName);
                        system.debug('countryName result: ' + BonusThresholdCountryNames.contains(countryName));
                        if(BonusThresholdCountryNames.contains(countryName) == true)                                
                        ExceptionList.remove(countryName); 
                    }
                
                    if(ExceptionList.size() < 1)
                    {
                        finalResult = false;
                    } else{
                    finalResult = true;
                    }
                    system.debug('ExceptionList....'+ExceptionList);
                    system.debug('finalResult'+ finalResult);
                            
                }
            }
        }   
        return finalResult;     
    }    
}