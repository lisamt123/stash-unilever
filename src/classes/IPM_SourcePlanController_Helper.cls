
/***********************************************************************************************
@Author-Cognizant
@Description:GPL/BD/SC/TL user can create source plan for global GKM3 project after Ideas phase 
************************************************************************************************/
public with sharing class IPM_SourcePlanController_Helper {
 
   public static Boolean SKIP_TRIGGER_EXECUTION = false;  
	/*****************************************************************************************************************************
    @Description-check logged in user type to gice edit or read access on page
    ******************************************************************************************************************************/
    public static boolean getUserType(id projectId,boolean isEditable){
    	boolean editMode = isEditable;
        list<IPM_Project__c> projectList = new list<IPM_Project__c>();
        projectList =[SELECT IPM_Project_Leader__c,Deputy_Project_Leader__c,IPM_Technical_Project_Leader__c,(SELECT id FROM IPM_Project_Resources__r WHERE IPM_User__c=:userinfo.getuserid() 
                    AND IPM_Project__c=:projectId AND (IPM_Role_Type__c =:IPM_ConstantUtils.FUNCTIONAL_ROLE_BD OR IPM_Role_Type__c =:IPM_ConstantUtils.FUNCTIONAL_ROLE_TYPE_SUPPLY_CHAIN)) FROM IPM_Project__c 
                    WHERE id=:projectId AND Is_Archieved__c = false limit 1];
        
        if(!projectList.isEmpty())
        {
            for(IPM_Project_Resource__c resc:projectList[0].IPM_Project_Resources__r)
            {
            	editMode = true; 
            }
            if(userinfo.getuserid() == projectList[0].IPM_Project_Leader__c || userinfo.getuserid() == projectList[0].Deputy_Project_Leader__c || 
             userinfo.getuserid() == projectList[0].IPM_Technical_Project_Leader__c)
            {
                editMode = true; 
            }
              
        }  
        if(!editMode)
        {
            getCentralBPUsers(editMode);
        }
        return editMode;
    }
    /*****************************************************************************************************************************
    @Description-check logged in user type to gice edit or read access on page
    ******************************************************************************************************************************/
    public static boolean getCentralBPUsers(boolean isEditable){
        boolean editMode = isEditable;
        //security for central team and BP users
        IPM_CustomPermission cpr = new IPM_CustomPermission();
        //boolean isCentralTeam=false;
        boolean isBPUser=false;
        boolean isCentralTeam=false;
        isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
        isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
        if(isCentralTeam || isBPUser){
           editMode = true; 
        }
    	return editMode;
    }
    public static boolean isCentralTeamMember()
    {
    	IPM_CustomPermission cpr = new IPM_CustomPermission();
    	boolean isCentralTeam=false;
        isCentralTeam = cpr.isPermissionSetAssinged(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
        return isCentralTeam;
    }
    /*****************************************************************************************************************************
    @Description-delete product country map when user/system delete ipm country
    ******************************************************************************************************************************/
    public static void deleteProductForCountries(set<id> countryIds){
        list<IPM_ProductPlan__c> deleteProdPlanList = new list<IPM_ProductPlan__c>();
        deleteProdPlanList =[SELECT id FROM IPM_ProductPlan__c WHERE IPM_Country__c IN : countryIds LIMIT 50000];
        if(!deleteProdPlanList.isEmpty())
        {
            try{ 
                delete deleteProdPlanList;
            }
            catch(Exception ex){
            	ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),'IPM_SourcePlanController_Helper',
	                'deleteProductForCountries',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION);
            } 
        } 
    }
    /***************************************************************************************************************************
    @Description:check duplicate source unit and source into
    ****************************************************************************************************************************/
    public static boolean validateProductData(IPM_SourcePlanController.sourcePlanWrapper sourceClass,IPM_SourcePlanController.sourcePlanWrapper duplicateCheckClass){
    	if(duplicateCheckClass !=null){
    	 	boolean isgTODuplicate = false;
    	 	boolean isFormatDupicate = false;
    	 	boolean isFormulationDuplicate = false;
    	 	if(duplicateCheckClass.productPlan.IPM_Of_gTO__c == sourceClass.productPlan.IPM_Of_gTO__c)
    	 	{
    	 		isgTODuplicate = true;
    	 	}
    	 	if(isgTODuplicate && duplicateCheckClass.productPlan.IPM_Format__c == sourceClass.productPlan.IPM_Format__c)
    	 	{
    	 		isFormatDupicate = true;
    	 	}
    	 	if(isFormatDupicate && duplicateCheckClass.productPlan.IPM_Formulation__c == sourceClass.productPlan.IPM_Formulation__c)
    	 	{
    	 		isFormulationDuplicate = validateProductDataPartTwo(true, sourceClass, duplicateCheckClass);
			} 
            return isFormulationDuplicate;
        }
    	return false;        
    }
	
	
	
	/***************************************************************************************************************************
    @Description:check duplicate source unit and source into
    ****************************************************************************************************************************/
    public static boolean validateProductDataPartTwo(boolean isFormulationDuplicate,IPM_SourcePlanController.sourcePlanWrapper sourceClass,IPM_SourcePlanController.sourcePlanWrapper duplicateCheckClass){
    	boolean isGoldenPrototypeDuplicate = false;
		boolean isPackingDuplicate = false;
		boolean isProductNameDuplicate = false;
		if(isFormulationDuplicate && duplicateCheckClass.productPlan.IPM_GoldenPrototype__c == sourceClass.productPlan.IPM_GoldenPrototype__c)
		{
			isGoldenPrototypeDuplicate = true;
		} 
		if(isGoldenPrototypeDuplicate && duplicateCheckClass.productPlan.IPM_Packing__c == sourceClass.productPlan.IPM_Packing__c)
		{
			isPackingDuplicate = true;
		} 
		if(isPackingDuplicate && duplicateCheckClass.productPlan.IPM_Product_Name__c == sourceClass.productPlan.IPM_Product_Name__c)
		{
			isProductNameDuplicate = validateProductDataPartThree(true, sourceClass, duplicateCheckClass);
		}
		return isProductNameDuplicate;
	}
	
	/***************************************************************************************************************************
    @Description:check duplicate source unit and source into
    ****************************************************************************************************************************/
    public static boolean validateProductDataPartThree(boolean isProductNameDuplicate,IPM_SourcePlanController.sourcePlanWrapper sourceClass,IPM_SourcePlanController.sourcePlanWrapper duplicateCheckClass){
		boolean isProductSizeDuplicate = false;
		boolean isSizeMetricsDuplicate = false;
		if(isProductNameDuplicate && duplicateCheckClass.productPlan.IPM_ProductSize__c == sourceClass.productPlan.IPM_ProductSize__c)
		{
			isProductSizeDuplicate = true;
		} 
		if(isProductSizeDuplicate && duplicateCheckClass.productPlan.IPM_ProductSizeMetrics__c == sourceClass.productPlan.IPM_ProductSizeMetrics__c)
		{
			isSizeMetricsDuplicate = true;
		}
		return isSizeMetricsDuplicate;
	}
	/***************************************************************************************************************************
    @Description:check duplicate source unit and source into
    ****************************************************************************************************************************/
    public static boolean validateSourceUnit(integer row_Index,Map<integer,list<IPM_SourcePlanController.sourceUnitWrapper>> sourceUnitMap,integer sUnitPosition){
        integer compareSize = 0; 
        integer toBeCompareSize = 0;
        list<IPM_SourcePlanController.sourceUnitWrapper> srcUnitList = new list<IPM_SourcePlanController.sourceUnitWrapper>();
        srcUnitList = sourceUnitMap.get(row_Index);
        list<IPM_SourcePlanController.sourceUnitWrapper> srcUnitCompareList = new list<IPM_SourcePlanController.sourceUnitWrapper>();
        srcUnitCompareList = sourceUnitMap.get(sUnitPosition);
        compareSize = srcUnitCompareList.size();
        toBeCompareSize = srcUnitList.size(); 
        set<string> indexCompareSet = new set<string>();
        for(IPM_SourcePlanController.sourceUnitWrapper srcUnitClass:srcUnitList){
            indexCompareSet.add(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c+srcUnitClass.sourcingPlan.IPM_CapabilityConfirmed__c+srcUnitClass.sourceCountries);
            for(IPM_SourcePlanController.sourceUnitWrapper sUnit:srcUnitCompareList){
                if(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c+srcUnitClass.sourcingPlan.IPM_CapabilityConfirmed__c+srcUnitClass.sourceCountries == sUnit.sourcingPlan.IPM_SourcingUnit__c+sUnit.sourcingPlan.IPM_CapabilityConfirmed__c+sUnit.sourceCountries)
                {
                    indexCompareSet.remove(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c+srcUnitClass.sourcingPlan.IPM_CapabilityConfirmed__c+srcUnitClass.sourceCountries);
                }
            
            }   
            
        }
        if(indexCompareSet.isEmpty() && toBeCompareSize == compareSize)
        {
            return true;
        }
        return false;
        
        
    }
    /*****************************************************************************************************************************
    @Description:get all list of size measure 
    ******************************************************************************************************************************/
    public static list<selectoption> getAllSize(){
        list<selectoption> sizeMeasureList = new list<selectoption>();
        sObject sobj = new IPM_Project_Product__c();
        list<string> sizeMetricList = new List<string>();
        sizeMetricList = IPM_Utils.getPicklistValues(sobj, 'IPM_ProductSizeMetrics__c');
        for(string metrics:sizeMetricList){
            sizeMeasureList.add(new selectoption(metrics,metrics));
        }
    	return sizeMeasureList; 
    }
    /***************************************************************************************************************************
    @Description:get all source unit map
    ****************************************************************************************************************************/
    public static map<string,id> getMapofSourceUnit(list<IPM_SourcingUnit__c> sourceUnitsList){
        map<string,id> allSourceUnitsMap = new map<string,id>();
        for(IPM_SourcingUnit__c sourceUnit:sourceUnitsList){
            allSourceUnitsMap.put(sourceUnit.Source_Unit_Name__c,sourceUnit.id);
        }
        return allSourceUnitsMap ;
    }
    /***************************************************************************************************************************
    @Description:save product country mapping data
    ****************************************************************************************************************************/
    public static void saveSourceUnit(map<string,id> allSourceUnitsMap,integer row_Index,list<IPM_Project_Product__c> producList,Map<integer,list<IPM_SourcePlanController.sourceUnitWrapper>> sourceUnitMap){
        list<IPM_SourcePlanController.sourceUnitWrapper> srcUnitList = new list<IPM_SourcePlanController.sourceUnitWrapper>();
        srcUnitList = sourceUnitMap.get(row_Index); 
        map<id,IPM_ProductPlan__c> ProdPlanMap = new map<id,IPM_ProductPlan__c>([SELECT id,IPM_Country__c,IPM_Country__r.Country_Name__c FROM IPM_ProductPlan__c WHERE IPM_Project_Product__c =:producList[0].id LIMIT 1000]);
        map<string,id> countryProductPalnMap = new map<string,id>();
        for(IPM_ProductPlan__c prodPlan:ProdPlanMap.Values())
        {
            if(!countryProductPalnMap.containsKey(prodPlan.IPM_Country__r.Country_Name__c))
            {
                countryProductPalnMap.put(prodPlan.IPM_Country__r.Country_Name__c,prodPlan.id);
            }
        }
        list<IPM_SourcingPlan__c> deleteSourcePlansList = new list<IPM_SourcingPlan__c>();
        deleteSourcePlansList =[SELECT ID,IPM_SourcingUnit__c,IPM_ProductPlan__r.IPM_Country__c,IPM_ProductPlan__r.IPM_Country__r.Country_Name__c FROM IPM_SourcingPlan__c WHERE IPM_ProductPlan__c IN :ProdPlanMap.keyset() LIMIT 10000];
        Map<string,IPM_SourcingPlan__c> countrySourcePlanMap = new Map<string,IPM_SourcingPlan__c>();
        for(IPM_SourcingPlan__c sourceP:deleteSourcePlansList)
        {
            
            if(!countrySourcePlanMap.containsKey(sourceP.IPM_SourcingUnit__c+sourceP.IPM_ProductPlan__r.IPM_Country__r.Country_Name__c))
            {
                countrySourcePlanMap.put(sourceP.IPM_SourcingUnit__c+sourceP.IPM_ProductPlan__r.IPM_Country__r.Country_Name__c,sourceP);
            }
        }
        
        //call save source unit part one 
        saveSourceUnitPartOne(allSourceUnitsMap,countryProductPalnMap,producList,srcUnitList,countrySourcePlanMap);
        
    }
    /***************************************************************************************************************************
    @Description:save product country mapping data
    ****************************************************************************************************************************/
    public static void saveSourceUnitPartOne(map<string,id> allSourceUnitsMap, map<string,id> countryProductPalnMap,list<IPM_Project_Product__c> producList,list<IPM_SourcePlanController.sourceUnitWrapper> srcUnitList,Map<string,IPM_SourcingPlan__c> countrySourcePlanMap){
        list<IPM_SourcingPlan__c> sourcePlansList = new list<IPM_SourcingPlan__c>();
        list<IPM_SourcingPlan__c> sourcePlansListToUpdate = new list<IPM_SourcingPlan__c>();
        list<string> getSourceinto = new list<string>(); 
        for(IPM_SourcePlanController.sourceUnitWrapper srcUnitClass:srcUnitList){
            getSourceinto = new list<string>(); 
            getSourceinto = srcUnitClass.sourceCountries.split(IPM_ConstantUtils.Delimiter);
            if(!string.IsBlank(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c)){
                for(string srcUnit:getSourceinto) 
                {
                    if(!countrySourcePlanMap.containsKey(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c+srcUnit))
                    {
                        IPM_SourcingPlan__c sourPlan = new IPM_SourcingPlan__c();
                        sourPlan.IPM_SourcingUnit__c = srcUnitClass.sourcingPlan.IPM_SourcingUnit__c;
                        sourPlan.IPM_Sourcing_Unit__c = allSourceUnitsMap.get(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c);
                        sourPlan.IPM_ProductPlan__c = countryProductPalnMap.get(srcUnit);
                        sourPlan.IPM_CapabilityConfirmed__c = srcUnitClass.sourcingPlan.IPM_CapabilityConfirmed__c;
                        sourcePlansList.add(sourPlan);
                    }else
                    {
                        countrySourcePlanMap.remove(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c+srcUnit);
                        sourcePlansListToUpdate.add(srcUnitClass.sourcingPlan);
                    }
                }
            }
            
        }   
        if(!countrySourcePlanMap.Values().isEmpty()){
            delete countrySourcePlanMap.Values();
        }
        if(!sourcePlansList.isEmpty()){
            insert sourcePlansList;
        }
        if(!sourcePlansListToUpdate.isEmpty()){
        	update sourcePlansListToUpdate;
        }
        
    }
    /***************************************************************************************************************************
    @Description:save product country mapping data
    ****************************************************************************************************************************/
    public static void saveProductCountry(map<string,string>allCountryMap,list<IPM_Project_Product__c> producList,string holdProductCountry_STR){
        list<string> holdProductCoun = new list<string>();
        holdProductCoun = holdProductCountry_STR.split(IPM_ConstantUtils.Delimiter);
        list<IPM_ProductPlan__c> productPlanList = new list<IPM_ProductPlan__c>();
        list<IPM_ProductPlan__c> getExistingProdPlanList = new list<IPM_ProductPlan__c>();
        getExistingProdPlanList =[SELECT IPM_Country__c,IPM_Country__r.Country_Name__c FROM IPM_ProductPlan__c WHERE IPM_Project_Product__c =:producList[0].id AND IPM_Country__r.isActive__c = true LIMIT 500];
        set<string> existCountryName = new set<string>();
        set<string> removeExistingConSet = new set<string>();
        set<string> deleteProdContSet = new set<string>();
        
        for(IPM_ProductPlan__c existProd:getExistingProdPlanList)
        {
            existCountryName.add(existProd.IPM_Country__r.Country_Name__c);
        }
        
        for(string proSTR:holdProductCoun)
        { 
            if(!existCountryName.contains(proSTR)){
                IPM_ProductPlan__c productPlan = new IPM_ProductPlan__c();
                productPlan.IPM_Project_Product__c = producList[0].id;
                productPlan.IPM_Country__c = allCountryMap.get(proSTR);
                productPlanList.add(productPlan);
            }
            removeExistingConSet.add(proSTR);
        }
        for(string exisCnt:existCountryName)
        {
            if(!removeExistingConSet.Contains(exisCnt))
            {
                deleteProdContSet.add(exisCnt);
            }
        }
        list<IPM_ProductPlan__c> deleteProdPlanList = new list<IPM_ProductPlan__c>();
        deleteProdPlanList =[SELECT id FROM IPM_ProductPlan__c WHERE IPM_Project_Product__c =:producList[0].id AND IPM_Country__r.Country_Name__c IN : deleteProdContSet LIMIT 500];
        
        if(!productPlanList.isEmpty())
        {
            insert productPlanList;
        }
        if(!deleteProdPlanList.isEmpty())
        {
            delete deleteProdPlanList; 
        } 
    }
}