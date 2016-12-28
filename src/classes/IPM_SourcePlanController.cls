/***********************************************************************************************
@Author-Cognizant
@Description:GPL/BD/SC/TL user can create source plan for global GKM3 project after Ideas phase 
************************************************************************************************/

public with sharing class IPM_SourcePlanController { 
    public static IPM_Project__c project {
        get {
            return IPM_Utils.getProjectFullInfo(ApexPages.currentPage().getParameters().get('Id'));
        }
    }
	public String docType ;
    public map<integer,sourcePlanWrapper> sourcePlanMap{get;set;}//map of wrapper class to store product and product plan data 
    public map<integer,list<sourceUnitWrapper>> sourceUnitMap{get;set;}//map wrapper class to store source plan data
    public list<IPM_Country__c> allCountryList{get;set;}//get all country list
    public list<IPM_ProductPlan__c> productPlanList{get;set;}//get all product plan list
    public Id projectId{get; set;} //used to fetch current projectId 
    public map<string,string>allCountryMap{get;set;}//map of all country
    public set<string>allProductCountrySet{get;set;}//set of product countries
    public set<string>notAssoProductCntrySet{get;set;} //set of not assigned countries to product
    public integer totalRowsInTable{get;set;}//hold total number of rows in table
    public integer row_Index{get;set;}//used to delete product
    public list<selectoption>sizeMeasureList{get;set;}//get all select option for size
    public integer wrapperPosition;//hold wrapper position
    private static final string IPM_SOURCEPLAN_CLASS_STR = IPM_SourcePlanController.class.getName();//get current class name
    public boolean isEditable{get;set;}//check whether current user has edit access on source plan page
    public list<IPM_SourcingUnit__c> sourceUnitsList {get;set;}//get all source unit names
    public string searchUnit_STR{get;set;}//hold source unit name
    public string holdSelectedProCountry{get;set;}//hold product country when clcik on done
    public map<string,id> allSourceUnitsMap {get;set;}//get all source unit map
    public set<string> notAssignedSourceCountrySet{get;set;}//set of not assigned source into countries from product countries list
    public set<string> assignedSourceCountrySet{get;set;}//set of assigned source into countries from product countries list
    public boolean isDuplicateRow{get;set;}//check whether duplicate row is found
    public set<integer> wrapperKeys{get;set;}//keyset of map of wrapper 
    public boolean gTOMoreThan{get;set;}//show error message to user when he/she has entered more than 100 or less than 0
    public boolean isSaveSuccess{get;set;}//whether save hppen or not
    public boolean bIsPDLApproved{get;set;}
    public string sourceUnitID{get;set;}
    public boolean capabilityFlag {get;set;}
    public boolean isCentralTeam{get;set;}
    public string sSourcingUnit{get;set;}
    public string sFilterColumn{get;set;}
    public string sSortOrder{get;set;}
    public List<SelectOption> SourcingUnits{get;set;}
    public integer sourceUnitIndex{get;set;}
    public boolean isLocalView;
    /********************************************************************************************
    @Description-Constructor  
    *********************************************************************************************/
    public IPM_SourcePlanController(){
    	isLocalView=false;
        totalRowsInTable = 0;
        wrapperPosition = 0;
        row_Index = null;
        sourceUnitIndex = null;
        isEditable = false;
        isDuplicateRow = false;
        gTOMoreThan = false;
        isSaveSuccess = false;
        searchUnit_STR =IPM_ConstantUtils.BLANK;
        holdSelectedProCountry = IPM_ConstantUtils.BLANK;
        projectId=ApexPages.currentPage().getParameters().get(IPM_ConstantUtils.SF_ID);
        docType = Apexpages.currentPage().getParameters().get('DocumentType');
        sourcePlanMap = new map<integer,sourcePlanWrapper>();
        sourceUnitMap = new map<integer,list<sourceUnitWrapper>> ();
        allCountryList = new list<IPM_Country__c>();
        productPlanList = new list<IPM_ProductPlan__c>();
        allCountryMap = new map<string,string>();
        allProductCountrySet = new set<string>();
        notAssoProductCntrySet = new set<string>();
        allSourceUnitsMap = new map<string,id>();
        notAssignedSourceCountrySet =new  set<string>();
        assignedSourceCountrySet =new  set<string>();
        wrapperKeys = new set<integer>() ;
        allCountryList =[SELECT Country_Name__c FROM IPM_Country__c WHERE IPM_Project__c =:projectId AND isActive__c = true order by Country_Name__c ASC LIMIT 1000];
        productPlanList =[SELECT IPM_Country__r.Country_Name__c FROM IPM_ProductPlan__c WHERE IPM_Project_Product__r.IPM_Project__c =:projectId  and IPM_Country__r.isActive__c = true order by IPM_Country__r.Country_Name__c ASC LIMIT 1000];
        if(allCountryList.isEmpty()){
            allCountryList =[SELECT Country_Name__c FROM IPM_Country__c WHERE IPM_Local_Project__c =:projectId AND isActive__c = true order by Country_Name__c ASC LIMIT 1000]; 
            Set<Id> lstCountryIDs = (new Map<Id,IPM_Country__c>(allCountryList)).keySet();
            productPlanList =[SELECT IPM_Country__r.Country_Name__c FROM IPM_ProductPlan__c WHERE IPM_Country__c in : lstCountryIDs  and IPM_Country__r.isActive__c = true order by IPM_Country__r.Country_Name__c ASC LIMIT 1000];
        }
        for(IPM_ProductPlan__c prodPlan:productPlanList)
        {
            allProductCountrySet.add(prodPlan.IPM_Country__r.Country_Name__c);
        }
        for(IPM_Country__c country:allCountryList)
        {
            if(!allProductCountrySet.contains(country.Country_Name__c))
            {
                notAssoProductCntrySet.add(country.Country_Name__c);        
            }
            allCountryMap.put(country.Country_Name__c,country.id);
        }
        sFilterColumn = 'IPM_Product_Name__c';
        sSortOrder ='asc';
        createProjectProductOnLoad();
        if(docType!='PDF'){
        	getAllSourcingUnits();
        }
    }
    /***************************************************************************************************************************
    @Description:get all source unit names
    ****************************************************************************************************************************/
    public void getSourceUnit(){
        sourceUnitsList = new list<IPM_SourcingUnit__c>();
        sourceUnitsList =[SELECT Source_Unit_Name__c FROM IPM_SourcingUnit__c WHERE Source_Unit_Name__c Like: '%'+searchUnit_STR +'%' AND Status__c = true order by Source_Unit_Name__c ASC LIMIT 1000];
        bIsPDLApproved=false;
    	getPDLApprovedStatus();
    	isCentralTeam=IPM_SourcePlanController_Helper.isCentralTeamMember(); 
    }
    public pageReference updateSourcinngUnit()
    {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
        Map<String,String> prefixKeyMap = new Map<String,String>{};
        for(String sObj : gd.keySet())
        {
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe();
            prefixKeyMap.put(r.getName(), r.getKeyPrefix());
        }
        String sPageName = prefixKeyMap.get('IPM_SourcingUnit__c');
        PageReference pageRef = new PageReference('/' + sPageName );
        return pageRef;
    } 
    public void getPDLApprovedStatus()
    {       
        bIsPDLApproved = false;
        List<IPM_Project_Document__c> lstPDlDocument  = new List<IPM_Project_Document__c>();
        Id projID;
        if(project.IPM_Parent_Project__c == Null)
        {    	
        	projID = project.id;
        }else if(project.IPM_Parent_Project__c != Null)
        {
        	projID = project.IPM_Parent_Project__c;
        }
        lstPDlDocument = [Select id,IPM_Document_Status__c From IPM_Project_Document__c Where IPM_GateDocuments__c =: IPM_ConstantUtils.PRODUCT_DESIGN_LOCK_DOCUMENT and IPM_Project__c=: projID and IPM_Document_Status__c=:IPM_ConstantUtils.STATUS_APPROVED limit 1];
        if(!lstPDlDocument.isEmpty())
        {
            bIsPDLApproved = true;        
        }
            
    }
    public void getAllSourcingUnits()
    {
        Set<String> setOptions = new Set<String>();
        SourcingUnits = new List<SelectOption>(); 
        SourcingUnits.add(new SelectOption('Select Sourcing Unit','Select Sourcing Unit'));
        list<IPM_SourcingPlan__c> SourcePlansList = new list<IPM_SourcingPlan__c>();
        SourcePlansList =[SELECT IPM_ProductPlan__r.IPM_Project_Product__c,IPM_CapabilityConfirmed__c,IPM_SourcingUnit__c,IPM_ProductPlan__r.IPM_Country__c,IPM_ProductPlan__r.IPM_Country__r.Country_Name__c FROM IPM_SourcingPlan__c WHERE IPM_ProductPlan__r.IPM_Project_Product__r.IPM_Project__c =:projectId and IPM_ProductPlan__r.IPM_Country__c !=null order by IPM_SourcingUnit__c ASC LIMIT 10000];
        
         for(IPM_SourcingPlan__c oSourcingPlan : SourcePlansList){
            if(!setOptions.contains(oSourcingPlan.IPM_SourcingUnit__c))
                {
                    SourcingUnits.add(new SelectOption(oSourcingPlan.IPM_SourcingUnit__c,oSourcingPlan.IPM_SourcingUnit__c));
                    setOptions.add(oSourcingPlan.IPM_SourcingUnit__c);
                } 
        }    
               
       
    }
    public void updateCapabilityForSourcingUnit()
    {
        
        list<IPM_SourcingPlan__c> SourcePlansList = new list<IPM_SourcingPlan__c>();
        SourcePlansList =[SELECT IPM_ProductPlan__r.IPM_Project_Product__c,IPM_CapabilityConfirmed__c,IPM_SourcingUnit__c,IPM_ProductPlan__r.IPM_Country__c,IPM_ProductPlan__r.IPM_Country__r.Country_Name__c FROM IPM_SourcingPlan__c WHERE IPM_ProductPlan__r.IPM_Project_Product__r.IPM_Project__c =:projectId AND IPM_SourcingUnit__c =: sSourcingUnit LIMIT 10000];
        for (list<sourceUnitWrapper> lstSourcingPlan : sourceUnitMap.values())
        {
            for(sourceUnitWrapper oSourcingPlan : lstSourcingPlan){
                if(oSourcingPlan.sourcingPlan.IPM_SourcingUnit__c==sSourcingUnit){
                    oSourcingPlan.sourcingPlan.IPM_CapabilityConfirmed__c = capabilityFlag;
                }
            }
        }
        for(IPM_SourcingPlan__c srcPlan: SourcePlansList )
        {
            srcPlan.IPM_CapabilityConfirmed__c = capabilityFlag;
        }
        if(!SourcePlansList.isEmpty()){
            update SourcePlansList;
        }
        capabilityFlag=false;       
    }
    /***************************************************************************************************************************
    @Description:create new project product when user click on Add Row
    ****************************************************************************************************************************/
    public void createProjectProduct(){
        IPM_Project_Product__c projectProduct = new IPM_Project_Product__c ();
        projectProduct.IPM_Project__c = projectId;
        string countryStr=IPM_ConstantUtils.BLANK;
        IPM_SourcingPlan__c sourcePlan = new IPM_SourcingPlan__c();
        list<string> sourceIntoList = new list<string>();
        for(sourcePlanWrapper sourceC: sourcePlanMap.values()){
            sourceC.readModeRow = false; 
        } 
        sourceUnitMap.put(wrapperPosition, new list<sourceUnitWrapper>());
        sourceUnitMap.get(wrapperPosition).add(new sourceUnitWrapper(sourcePlan,countryStr));
        sourcePlanMap.put(wrapperPosition,new sourcePlanWrapper(wrapperPosition,true,false,projectProduct,countryStr,sourceIntoList));
        wrapperPosition++; 
        totalRowsInTable = sourcePlanMap.size(); 
        wrapperKeys = sourcePlanMap.keyset(); 
        
        
        
    }
    /***************************************************************************************************************************
    @Description:create new project product when user click on Add Row
    ****************************************************************************************************************************/
    public void addNewSourcePlanRow(){
        string countryStr = IPM_ConstantUtils.BLANK;
        IPM_SourcingPlan__c sourcePlan = new IPM_SourcingPlan__c();
        sourceUnitMap.get(row_Index).add(new sourceUnitWrapper(sourcePlan,countryStr));
    }
    /***************************************************************************************************************************
    @Description:get all source into country for product mapping
    ****************************************************************************************************************************/
    public void getSourcedinto(){
        list<string> sourceIntoCList= new list<string>();
        transient List<string> productCountryList = new List<string>();
        integer mapPosition = null;
        for(sourcePlanWrapper sourceClass: sourcePlanMap.Values()){
            if(sourceClass.readModeRow){
                mapPosition = sourceClass.productProsition;
                sourceIntoCList = holdSelectedProCountry.split(IPM_ConstantUtils.Delimiter);
                sourceClass.sourceIntoList = sourceIntoCList;
                sourceClass.countryStr = holdSelectedProCountry;
                sourceClass.countryStrToDisplay = holdSelectedProCountry.replace(IPM_ConstantUtils.Delimiter, IPM_ConstantUtils.Delimiter+IPM_ConstantUtils.EMPTY_STRING_DELIMITER);
                productCountryList.add(holdSelectedProCountry);
            }else{  
                productCountryList.add(sourceClass.countryStr);
            }
        }
        set<string> getProdCSet = getProductCountryNames(productCountryList);
        transient List<string> sourceCStrList = new List<string>();
        transient set<string> sourceCSet =  new Set<string>();
        transient set<integer> srcWrapperkeySet = new set<integer>();
        srcWrapperkeySet = sourceUnitMap.keyset();
        for(integer itnKey: srcWrapperkeySet){
            for(sourceUnitWrapper sourceU: sourceUnitMap.get(itnKey))
            {
                sourceCStrList.add(sourceU.sourceCountries);
            }
        }
        transient List<string> sourceCList = new List<string>();
        for(string strC: sourceCStrList)
        {
            sourceCList = strC.split(IPM_ConstantUtils.Delimiter);
            for(string srcC: sourceCList)
            {
                sourceCSet.add(srcC);
            }
        }
        notAssignedSourceCountrySet.clear();
        for(string pCountry:getProdCSet)
        {
            if(!sourceCSet.contains(pCountry))
            {
                notAssignedSourceCountrySet.add(pCountry);
            }
        }
        removeSourceCntry(mapPosition,sourceIntoCList);
        
    }
    /***************************************************************************************************************************
    @Description:get all source into country for product mapping
    ****************************************************************************************************************************/
    public void removeSourceCntry(integer mapPosition,list<string> sourceIntoCList){
        set<string> sourceCountryStrSet = new set<string>();
        sourceCountryStrSet.addAll(sourceIntoCList);
        string countryName_STR = IPM_ConstantUtils.BLANK; 
        list<sourceUnitWrapper> sourceUnitList = new list<sourceUnitWrapper>();
        sourceUnitList = sourceUnitMap.get(mapPosition);
        map<integer,set<string>> countryWithSUnitMap = new  map<integer,set<string>>();
        map<integer,string> actualCountryWithSUnitMap = new  map<integer,string>();
        map<integer,IPM_SourcingPlan__c> actualSUnitMap = new  map<integer,IPM_SourcingPlan__c>();
        
        integer sUnit_INT = 0;
        for(sourceUnitWrapper sourceU: sourceUnitList)
        {
                
            List<string> sourceCStrList = new List<string>();
            sourceCStrList = sourceU.sourceCountries.split(IPM_ConstantUtils.Delimiter);
            set<string> sourceCSet =  new Set<string>();
            sourceCSet.addAll(sourceCStrList);
            countryWithSUnitMap.put(sUnit_INT,sourceCSet);
            actualSUnitMap.put(sUnit_INT,sourceU.sourcingPlan);
            sUnit_INT++;
        }
        for(integer cUnit:countryWithSUnitMap.Keyset())
        {
            countryName_STR = IPM_ConstantUtils.BLANK;
            for(string srcC_STR: countryWithSUnitMap.get(cUnit)){
                if(sourceCountryStrSet.contains(srcC_STR)){
                    countryName_STR = countryName_STR+srcC_STR+IPM_ConstantUtils.Delimiter;
                } 
            }
            actualCountryWithSUnitMap.put(cUnit,countryName_STR);
            
        }  
        sourceUnitMap.put(mapPosition,new list<sourceUnitWrapper>());
        for(integer cUnit: actualSUnitMap.keyset())
        {
            
            sourceUnitMap.get(mapPosition).add(new sourceUnitWrapper(actualSUnitMap.get(cUnit),actualCountryWithSUnitMap.get(cUnit)));  
        }    
     }
    
    /***************************************************************************************************************************
    @Description:create new project product on page load if there is no record exist for current project
    ****************************************************************************************************************************/
    public void createProjectProductOnLoad(){
    	List<IPM_Project_Product__c> projectProductListwithNullCountries;
        sizeMeasureList = IPM_SourcePlanController_Helper.getAllSize();
        if(docType!='PDF'){
	        isEditable = IPM_SourcePlanController_Helper.getUserType(projectId,isEditable);
	        isEditable = IPM_SourcePlanController_Helper.getCentralBPUsers(isEditable);
        }        
      	getSourceUnit();
        allSourceUnitsMap = IPM_SourcePlanController_Helper.getMapofSourceUnit(sourceUnitsList);
        map<id,set<string>> productNCountryMap = new map<id,set<string>>();
        set<id> productPlanIds = new set<id>();
        List<IPM_Project_Product__c> projectProductList = new List<IPM_Project_Product__c> ();
        String sQuery = 'SELECT IPM_Of_gTO__c,IPM_Format__c,IPM_Formulation__c,IPM_GoldenPrototype__c,IPM_Project__c,IPM_Packing__c,IPM_Product_Name__c,IPM_ProductSize__c,IPM_ProductSizeMetrics__c,(SELECT IPM_Country__r.Country_Name__c,IPM_Project_Product__c FROM IPM_ProductPlans__r WHERE IPM_Country_Null__c = false and IPM_Country__r.isActive__c = true) FROM IPM_Project_Product__c WHERE IPM_Project__c =:projectId order by ' + sFilterColumn + ' '+ sSortOrder + ' limit 1000';
        String sQueryBlankCountries = 'SELECT IPM_Of_gTO__c,IPM_Format__c,IPM_Formulation__c,IPM_GoldenPrototype__c,IPM_Project__c,IPM_Packing__c,IPM_Product_Name__c,IPM_ProductSize__c,IPM_ProductSizeMetrics__c,(SELECT IPM_Country__r.Country_Name__c,IPM_Project_Product__c FROM IPM_ProductPlans__r WHERE IPM_Country_Null__c = true) FROM IPM_Project_Product__c WHERE IPM_Project__c =:projectId order by ' + sFilterColumn + ' '+ sSortOrder + ' limit 1000';
        projectProductList = database.Query(sQuery);
        projectProductListwithNullCountries = database.query(sQueryBlankCountries);
        if(projectProductList.isEmpty()){
            list<IPM_Country__c> lstCountry = [ Select ID From IPM_Country__c Where IPM_Local_Project__c =: projectId ];        
            Set<Id> lstCountryIDs = (new Map<Id,IPM_Country__c>(lstCountry)).keySet();      
            id parentProId = null;
            if(project !=null && project.IPM_Parent_Project__c !=null){
                parentProId = project.IPM_Parent_Project__c;
            }
            projectProductList = [SELECT IPM_Of_gTO__c,IPM_Format__c,IPM_Formulation__c,IPM_GoldenPrototype__c,IPM_Project__c,IPM_Packing__c,IPM_Product_Name__c,IPM_ProductSize__c,IPM_ProductSizeMetrics__c,(SELECT IPM_Country__r.Country_Name__c,IPM_Project_Product__c FROM IPM_ProductPlans__r WHERE IPM_Country_Null__c = false and IPM_Country__r.isActive__c = true AND IPM_Country__c IN : lstCountryIDs) FROM IPM_Project_Product__c WHERE  IPM_Project__c =:parentProId order by IPM_Product_Name__c asc limit 1000];
            if(projectProductList.size()>0){
            	isLocalView =true;
            }
        } 
        sourcePlanMap.clear();     
        IF(projectProductList.isEmpty())
        {
            createProjectProduct(); 
        }
        else{
            for(IPM_Project_Product__c product:projectProductList)
            {
                for(IPM_ProductPlan__c prod:product.IPM_ProductPlans__r){
                        
                    if(!productNCountryMap.containsKey(prod.IPM_Project_Product__c))
                    {
                        productNCountryMap.put(prod.IPM_Project_Product__c,new set<string>());  
                    }
                    productNCountryMap.get(prod.IPM_Project_Product__c).add(prod.IPM_Country__r.Country_Name__c);
                    productPlanIds.add(prod.id);
                }    
            }
            for(IPM_Project_Product__c product:projectProductListwithNullCountries)
            {
            	for(IPM_ProductPlan__c prod:product.IPM_ProductPlans__r){
                	productPlanIds.add(prod.id);
            	}
            }
            loadDataToTable(productPlanIds,projectProductList,productNCountryMap);                       
        }
        
    }
    /***************************************************************************************************************************
    @Description:load existing data from table and display in table
    ****************************************************************************************************************************/
    public void loadDataToTable(set<id> productPlanIds,List<IPM_Project_Product__c> projectProductList,map<id,set<string>> productNCountryMap){
        map<id,list<sourceUnitWrapper>> productWrapperMap = new map<id,list<sourceUnitWrapper>>();
        productWrapperMap = getAllSourcePlanUnit(productPlanIds);
        for(string allCountry:allProductCountrySet)
        {
            if(!assignedSourceCountrySet.contains(allCountry)){
                notAssignedSourceCountrySet.add(allCountry);
            }
        }
        for(IPM_Project_Product__c product:projectProductList)
        {        	
        	boolean bIsSourcingUnitBlank = false;
            String country_STR = IPM_ConstantUtils.BLANK;
            List<string> lstCountry = new list<string>();
            if(productNCountryMap.containsKey(product.id)){
                for(string strCountry:productNCountryMap.get(product.id)){
                    lstCountry.add(strCountry);
                }
            }
            lstCountry.sort();
            country_STR = string.join(lstCountry,IPM_ConstantUtils.Delimiter);
            list<string> sourceIntoList = new list<string>();
            if(productNCountryMap.containsKey(product.id)){
                sourceIntoList.addAll(productNCountryMap.get(product.id));  
            }
            sourceIntoList.sort();
            if(!productWrapperMap.containsKey(product.id)){
                string countryStr = IPM_ConstantUtils.BLANK;
                IPM_SourcingPlan__c sourcePlan = new IPM_SourcingPlan__c();
                sourceUnitMap.put(wrapperPosition, new list<sourceUnitWrapper>());
                sourceUnitMap.get(wrapperPosition).add(new sourceUnitWrapper(sourcePlan,countryStr));
                bIsSourcingUnitBlank = true;
                
            }else{
                sourceUnitMap.put(wrapperPosition, productWrapperMap.get(product.id));
            }
            if((isLocalView && !bIsSourcingUnitBlank) || !isLocalView)
            	sourcePlanMap.put(wrapperPosition,new sourcePlanWrapper(wrapperPosition,false,false,product,country_STR,sourceIntoList));
            wrapperPosition++;
        }
        totalRowsInTable = sourcePlanMap.size(); 
        wrapperKeys = sourcePlanMap.keyset(); 
    }
    /****************************************************************************************************************************
    @Description:get all source plan records
    *****************************************************************************************************************************/
    public map<id,list<sourceUnitWrapper>> getAllSourcePlanUnit(set<id> productPlanIds){
        list<IPM_SourcingPlan__c> SourcePlansList = new list<IPM_SourcingPlan__c>();
        SourcePlansList =[SELECT IPM_ProductPlan__r.IPM_Project_Product__c,IPM_CapabilityConfirmed__c,IPM_SourcingUnit__c,IPM_ProductPlan__r.IPM_Country__c,IPM_ProductPlan__r.IPM_Country__r.Country_Name__c FROM IPM_SourcingPlan__c WHERE IPM_ProductPlan__c IN :productPlanIds LIMIT 10000];
        map<string,IPM_SourcingPlan__c> productSourceUnitPlanMap = new map<string,IPM_SourcingPlan__c>();
        map<string,string> productSourceIntoMap = new map<string,string>();
        set<string> sourceUnitSet = new set<string>();
        set<id> ProductIdSet = new set<id>();
        for(IPM_SourcingPlan__c srcPlan:SourcePlansList)
        {
            if(!productSourceUnitPlanMap.containsKey(srcPlan.IPM_ProductPlan__r.IPM_Project_Product__c+srcPlan.IPM_SourcingUnit__c)){
                productSourceUnitPlanMap.put(srcPlan.IPM_ProductPlan__r.IPM_Project_Product__c+srcPlan.IPM_SourcingUnit__c,srcPlan);    
            }
            sourceUnitSet.add(srcPlan.IPM_SourcingUnit__c);
            ProductIdSet.add(srcPlan.IPM_ProductPlan__r.IPM_Project_Product__c);
            assignedSourceCountrySet.add(srcPlan.IPM_ProductPlan__r.IPM_Country__r.Country_Name__c);
        }
        
        for(IPM_SourcingPlan__c srcPlan:SourcePlansList)
        {
            if(!productSourceIntoMap.containsKey(srcPlan.IPM_ProductPlan__r.IPM_Project_Product__c+srcPlan.IPM_SourcingUnit__c))
            {
                productSourceIntoMap.put(srcPlan.IPM_ProductPlan__r.IPM_Project_Product__c+srcPlan.IPM_SourcingUnit__c,IPM_ConstantUtils.BLANK);
            }
            string countries_STR = IPM_ConstantUtils.BLANK;
            countries_STR = productSourceIntoMap.get(srcPlan.IPM_ProductPlan__r.IPM_Project_Product__c+srcPlan.IPM_SourcingUnit__c);
            countries_STR = countries_STR + srcPlan.IPM_ProductPlan__r.IPM_Country__r.Country_Name__c + IPM_ConstantUtils.Delimiter;
            productSourceIntoMap.put(srcPlan.IPM_ProductPlan__r.IPM_Project_Product__c+srcPlan.IPM_SourcingUnit__c,countries_STR); 
         }
        map<id,list<sourceUnitWrapper>> productWrapperMap = new map<id,list<sourceUnitWrapper>>();
        for(id projectProdId: ProductIdSet)
        {
            for(string srcUnit: sourceUnitSet){
                
                if(productSourceIntoMap.containsKey(projectProdId+srcUnit))
                {
                    if(!productWrapperMap.containsKey(projectProdId)){
                        productWrapperMap.put(projectProdId,new list<sourceUnitWrapper>()); 
                    }
                    IPM_SourcingPlan__c srcPlanNew = new IPM_SourcingPlan__c();
                    srcPlanNew = productSourceUnitPlanMap.get(projectProdId+srcUnit);
                    string sourceCountries = productSourceIntoMap.get(projectProdId+srcUnit);                    
                    List<String> lstCountry = sourceCountries.split(IPM_ConstantUtils.Delimiter);
                    lstCountry.sort();
                    sourceCountries = String.join(lstCountry,IPM_ConstantUtils.Delimiter);
                    productWrapperMap.get(projectProdId).add(new sourceUnitWrapper(srcPlanNew,sourceCountries));
                }
                else
                {
                	if(!productWrapperMap.containsKey(projectProdId)){
                        productWrapperMap.put(projectProdId,new list<sourceUnitWrapper>()); 
                    }
                    IPM_SourcingPlan__c srcPlanNew = new IPM_SourcingPlan__c();
                    srcPlanNew = productSourceUnitPlanMap.get(projectProdId+srcUnit);
                    if(srcPlanNew!=null){
                    	productWrapperMap.get(projectProdId).add(new sourceUnitWrapper(srcPlanNew,''));
                    }
                }
            }
            
        }
        return productWrapperMap;
        
    }
    /****************************************************************************************************************************
    @Description:Delete project product from list
    *****************************************************************************************************************************/
    public void deleteProduct(){
        
        id productId =null;
        sourcePlanWrapper sourceClass; 
        sourceClass =sourcePlanMap.get(row_Index);
        if(sourceClass !=null && sourceClass.productPlan.id !=null){
            productId = sourceClass.productPlan.id; 
        }
        if(productId !=null){
            list<IPM_Project_Product__c> productList = new list<IPM_Project_Product__c>();
            productList =[SELECT ID FROM IPM_Project_Product__c WHERE ID =:productId LIMIT 1];
            try{
                delete productList;
            }
            catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_SOURCEPLAN_CLASS_STR,
                        'deleteProduct',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            }
        }
        sourcePlanMap.remove(row_Index);
        for(sourcePlanWrapper sourcPlan: sourcePlanMap.values())
        {
            sourcPlan.isDuplicateRow = false;
        }
        isDuplicateRow = false;
        sourceUnitMap.remove(row_Index);
        totalRowsInTable = sourcePlanMap.size(); 
        wrapperKeys = sourcePlanMap.keyset();   
        getProductCAfterRowDelete();  
        getUpdatedNotAssignedSUnits();
        getAllSourcingUnits();
    
    }
    /*****************************************************************************************************************************
    @Description:enable edit mode of selected row
    ******************************************************************************************************************************/
    public void editModeRow(){
        
        integer holdIndex = null;
        holdIndex = row_Index;
        row_Index = null;
        for(sourcePlanWrapper sourceClass: sourcePlanMap.values()){
            if(sourceClass.readModeRow){
               row_Index = sourceClass.productProsition ;
               break;
            }
        }

        if(row_Index !=null)
        {
            saveRow();
            if(isSaveSuccess){
                editModeRowAfterSave(holdIndex);
            }
        }else{
            editModeRowAfterSave(holdIndex);
        }
        
       row_Index = holdIndex; 
        
    }
    /*****************************************************************************************************************************
    @Description:enable edit mode of selected row
    ******************************************************************************************************************************/
    public void editModeRowAfterSave(integer holdIndex){
        for(sourcePlanWrapper sourceClass: sourcePlanMap.values()){
            if(sourceClass.productProsition == holdIndex){
                sourceClass.readModeRow = true; 
            }else{
                sourceClass.readModeRow = false; 
            }
        }
    }
    /*****************************************************************************************************************************
    @Description:save edit mode row data
    ******************************************************************************************************************************/
    public void saveEditModeRowData(){
        for(sourcePlanWrapper sourceClass: sourcePlanMap.values()){
            if(sourceClass.readModeRow){
               row_Index = sourceClass.productProsition ;
               break;
            }
        }
    }
     
    /*****************************************************************************************************************************
    @Description:once edit mode is enable then user can save product values
    ******************************************************************************************************************************/
    public void saveRow(){
        savepoint sp = database.setSavepoint();
        list<IPM_Project_Product__c> producList = new list<IPM_Project_Product__c>();
        sourcePlanWrapper duplicateCheckClass = sourcePlanMap.get(row_Index);
        isDuplicateRow = false;
        isSaveSuccess = false;
        string holdProductCountry_STR = IPM_ConstantUtils.BLANK;
        sourcePlanWrapper sourceC = duplicateCheckClass;
        if(sourceC.productPlan.IPM_Of_gTO__c <= 100 && sourceC.productPlan.IPM_Of_gTO__c >= 0){
            producList.add(sourceC.productPlan);
            duplicateCheckClass = sourceC; 
            holdProductCountry_STR = sourceC.countryStr;
            gTOMoreThan = false;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_gTO_Percent));
            gTOMoreThan = true;
        }
        for(sourcePlanWrapper sourceClass: sourcePlanMap.values()){
            if(sourceClass.productProsition != row_Index){
                if(IPM_SourcePlanController_Helper.validateProductData(sourceClass,duplicateCheckClass) && duplicateCheckClass.countryStr == sourceClass.countryStr && IPM_SourcePlanController_Helper.validateSourceUnit(row_Index,sourceUnitMap,sourceClass.productProsition)
                ){
                    isDuplicateRow = true;
                    sourceClass.isDuplicateRow =true;
                }else{
                    sourceClass.isDuplicateRow =false;
                }
                
            }
        } 
      try{
            if(!isDuplicateRow && !gTOMoreThan)
            {
                upsert producList;
                //call a method to save product country mapping
                saveProductCountry(producList,holdProductCountry_STR);
                //call a method to save source unit and source into
                saveSourceUnit(producList);
                isSaveSuccess = true;
                getAllSourcingUnits();
                for(sourcePlanWrapper sourceClass: sourcePlanMap.values()){
                    if(sourceClass.productProsition == row_Index){
                        sourceClass.readModeRow = false;
                    }
                 }
                deleteProductPlanWithBlankCountry(producList[0].id);
            }
     }
       catch(exception ex){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
                database.rollback(sp);
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_SOURCEPLAN_CLASS_STR,
                        'saveRow',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
            }
    }
    
    public void deleteProductPlanWithBlankCountry(id projectProductID)
    {
		List<IPM_ProductPlan__c> lstProductPlan =[SELECT IPM_Country__c,IPM_Country__r.Country_Name__c,IPM_Country_Null__c,(Select ID From IPM_SourcingPlanProducts__r) FROM IPM_ProductPlan__c WHERE IPM_Project_Product__c =:projectProductID and IPM_Country_Null__c=true LIMIT 500];
		List<IPM_ProductPlan__c> lstProductPlanToDelete = new List<IPM_ProductPlan__c>();
		for(IPM_ProductPlan__c oProductPlan : lstProductPlan)
		{
			List<IPM_SourcingPlan__c> lstSourcingPlan = oProductPlan.IPM_SourcingPlanProducts__r;
			if(lstSourcingPlan.isEmpty()){
				lstProductPlanToDelete.add(oProductPlan);
			}
		}
		if(!lstProductPlanToDelete.isEmpty()){
			delete lstProductPlanToDelete;
		}
    }
    
    /***************************************************************************************************************************
    @Description:save product country mapping data
    ****************************************************************************************************************************/
    public void saveProductCountry(list<IPM_Project_Product__c> producList,string holdProductCountry_STR){
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
    /***************************************************************************************************************************
    @Description:save product country mapping data
    ****************************************************************************************************************************/
    public void saveSourceUnit(list<IPM_Project_Product__c> producList){
        list<sourceUnitWrapper> srcUnitList = new list<sourceUnitWrapper>();
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
        saveSourceUnitPartOne(countryProductPalnMap,producList,srcUnitList,countrySourcePlanMap);
         
    }
    /***************************************************************************************************************************
    @Description:save product country mapping data
    ****************************************************************************************************************************/
    public void saveSourceUnitPartOne(map<string,id> countryProductPalnMap,list<IPM_Project_Product__c> producList,list<sourceUnitWrapper> srcUnitList,Map<string,IPM_SourcingPlan__c> countrySourcePlanMap){
        list<IPM_SourcingPlan__c> sourcePlansList = new list<IPM_SourcingPlan__c>();
        list<IPM_SourcingPlan__c> sourcePlansListToUpdate = new list<IPM_SourcingPlan__c>();
        list<IPM_SourcingPlan__c> lstSourcingPlanWithBlankCountry=new  list<IPM_SourcingPlan__c>();
        list<IPM_ProductPlan__c> lstProductPlansToInsert = new list<IPM_ProductPlan__c>();
        list<string> getSourceinto = new list<string>(); 
        set<id> uniqueSourcePId = new set<id>();
        for(sourceUnitWrapper srcUnitClass:srcUnitList){ 
            getSourceinto = new list<string>(); 
            getSourceinto = srcUnitClass.sourceCountries.split(IPM_ConstantUtils.Delimiter);
            if(!string.IsBlank(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c) && !String.isBlank(srcUnitClass.sourceCountries) ){            	
            	srcUnitClass.sourceCountriesToDisplay = srcUnitClass.sourceCountries.replace(IPM_ConstantUtils.Delimiter, IPM_ConstantUtils.Delimiter+IPM_ConstantUtils.EMPTY_STRING_DELIMITER);
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
                        if(srcUnitClass.sourcingPlan.id !=null && !uniqueSourcePId.contains(srcUnitClass.sourcingPlan.id))
                        {
                            sourcePlansListToUpdate.add(srcUnitClass.sourcingPlan);
                            uniqueSourcePId.add(srcUnitClass.sourcingPlan.id); 
                        }
                    }
                }
            }
            else
            {            	
            	if(allSourceUnitsMap.get(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c)!=null)
            	{
	            	IPM_ProductPlan__c objProductPlan = new IPM_ProductPlan__c();
	            	objProductPlan.IPM_Project_Product__c = producList[0].Id;
	            	lstProductPlansToInsert.add(objProductPlan);
	            	IPM_SourcingPlan__c sourPlan = new IPM_SourcingPlan__c();
	               	sourPlan.IPM_SourcingUnit__c = srcUnitClass.sourcingPlan.IPM_SourcingUnit__c;
	               	sourPlan.IPM_Sourcing_Unit__c = allSourceUnitsMap.get(srcUnitClass.sourcingPlan.IPM_SourcingUnit__c);
	               	sourPlan.IPM_CapabilityConfirmed__c = srcUnitClass.sourcingPlan.IPM_CapabilityConfirmed__c;
	               	sourPlan.IPM_ProductPlan__c= objProductPlan.Id;
	               	lstSourcingPlanWithBlankCountry.add(sourPlan);
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
        insertProductPlansWithBlankSourcingUnit(lstProductPlansToInsert,lstSourcingPlanWithBlankCountry);         
    }
    
    public void insertProductPlansWithBlankSourcingUnit(list<IPM_ProductPlan__c> lstProductPlansToInsert,list<IPM_SourcingPlan__c> lstSourcingPlanWithBlankCountry)
    {
    	 if(!lstProductPlansToInsert.isEmpty() && !lstSourcingPlanWithBlankCountry.isEmpty())
        {
        	List<Database.SaveResult> lstResult = Database.Insert(lstProductPlansToInsert);
        	 for (Integer i = 0; i < lstResult.size(); i++) {
        	 	lstSourcingPlanWithBlankCountry[i].IPM_ProductPlan__c= lstResult[i].getId();
        	 }
        	 insert lstSourcingPlanWithBlankCountry;
        }      
    }
    /***************************************************************************************************************************
    @Description:clone product record row and enable edit mode
    ****************************************************************************************************************************/
    public void getUpdatedNotAssignedSUnits(){
        
        list<string> allSCountryList = new list<string>();
        allSCountryList.add(holdSelectedProCountry);
        for(list<sourceUnitWrapper> srcUnitClass:sourceUnitMap.values()){
            for(sourceUnitWrapper sUnit:srcUnitClass){
                allSCountryList.add(sUnit.sourceCountries);
            }   
        }  
        list<string> holdAllCList = new list<string>();
        set<string> holdAllSet = new set<string>();
        for(string c_STR: allSCountryList)
        {
            holdAllCList = c_STR.split(IPM_ConstantUtils.Delimiter);
            for(string countryName:holdAllCList)
            {
                holdAllSet.add(countryName);
            }
        }
        list<string> getProdCList = new list<string>();
        set<string> getProdCSet = new set<string>();
        for(sourcePlanWrapper sourceClass: sourcePlanMap.values()){
            getProdCList = sourceClass.countryStr.split(IPM_ConstantUtils.Delimiter);
            for(string prodc_STR: getProdCList)
            {
                getProdCSet.add(prodc_STR); 
            }
        }
        notAssignedSourceCountrySet.clear();
        for(string pCountry:getProdCSet)
        {
            if(!holdAllSet.contains(pCountry))
            {
                notAssignedSourceCountrySet.add(pCountry);
            }
        } 
        
        holdSelectedProCountry = IPM_ConstantUtils.BLANK;
        
    }
    /***************************************************************************************************************************
    @Description:clone product record row and enable edit mode
    ****************************************************************************************************************************/
    public void cloneProjectProduct(){
        
        integer holdIndex = null;
        holdIndex = row_Index;
        row_Index = null;
        for(sourcePlanWrapper sourceClass: sourcePlanMap.values()){
            if(sourceClass.readModeRow){
               row_Index = sourceClass.productProsition ;
               break;
            }
        }
        if(row_Index !=null)
        {
            saveRow();
            if(isSaveSuccess)
            {
                cloneProjectProductAfterSave(holdIndex);
            }
        }else{
            cloneProjectProductAfterSave(holdIndex);
        }
        row_Index = holdIndex;
        totalRowsInTable = sourcePlanMap.size(); 
        wrapperKeys = sourcePlanMap.keyset();   
        
        
    }
     /***************************************************************************************************************************
    @Description:clone product record row and enable edit mode
    ****************************************************************************************************************************/
    public void cloneProjectProductAfterSave(integer holdIndex){
        IPM_Project_Product__c projectProduct = new IPM_Project_Product__c ();
        string countryStr = IPM_ConstantUtils.BLANK;
        list<string> sourceIntoList = new list<string>();
        for(sourcePlanWrapper sourceClass: sourcePlanMap.values()){
            if(sourceClass.productProsition == holdIndex){
                projectProduct.IPM_Of_gTO__c = sourceClass.productPlan.IPM_Of_gTO__c;
                projectProduct.IPM_Format__c = sourceClass.productPlan.IPM_Format__c;
                projectProduct.IPM_Formulation__c = sourceClass.productPlan.IPM_Formulation__c;
                projectProduct.IPM_GoldenPrototype__c = sourceClass.productPlan.IPM_GoldenPrototype__c;
                projectProduct.IPM_Project__c = sourceClass.productPlan.IPM_Project__c;
                projectProduct.IPM_Packing__c = sourceClass.productPlan.IPM_Packing__c;
                projectProduct.IPM_Product_Name__c = sourceClass.productPlan.IPM_Product_Name__c;
                projectProduct.IPM_ProductSize__c = sourceClass.productPlan.IPM_ProductSize__c;
                projectProduct.IPM_ProductSizeMetrics__c = sourceClass.productPlan.IPM_ProductSizeMetrics__c;
                countryStr = sourceClass.countryStr;
                sourceIntoList = sourceClass.sourceIntoList;
            }
            sourceClass.readModeRow = false; 
        }
        
        list<sourceUnitWrapper> sourceUnitList = new list<sourceUnitWrapper>();
        
        for(sourceUnitWrapper sUnit:sourceUnitMap.get(holdIndex)){
            IPM_SourcingPlan__c sourcePlan = new IPM_SourcingPlan__c();
            sourcePlan.IPM_SourcingUnit__c = sUnit.sourcingPlan.IPM_SourcingUnit__c;
            sourcePlan.IPM_CapabilityConfirmed__c = sUnit.sourcingPlan.IPM_CapabilityConfirmed__c;
            sourceUnitList.add(new sourceUnitWrapper(sourcePlan,sUnit.sourceCountries));
        }
        sourceUnitMap.put(wrapperPosition, sourceUnitList);
        sourcePlanMap.put(wrapperPosition,new sourcePlanWrapper(wrapperPosition,true,false,projectProduct,countryStr,sourceIntoList));
        wrapperPosition++;  
    }
    
    /*****************************************************************************************************************************
    @Description-download product and sourcing plan table as PDF
    ******************************************************************************************************************************/
    public PageReference exportToPdf(){ 
        
        PageReference url = null;
        url = Page.IPM_Download_Source_Plan;
        url.setRedirect(false); 
        //PDF Download Parameters
        Apexpages.currentPage().getHeaders().put(IPM_ConstantUtils.ATTACHMENT_CONTENT_DISPOSITION, IPM_ConstantUtils.ATTACHMENT_FILE_NAME+project.IPM_Project_Name__c+ '_'+Label.IPM_Product_Sourcing_Plan+system.today().format()+IPM_ConstantUtils.ATTACHMENT_FILE_TYPE);
        return url;
        
    }
    
    /***************************************************************************************************************************
    @Description:get all product country when user delete a row
    ****************************************************************************************************************************/
    public void getProductCAfterRowDelete(){
        transient List<string> productCountryList = new List<string>();
        for(sourcePlanWrapper sourceClass: sourcePlanMap.Values()){
            productCountryList.add(sourceClass.countryStr);
        }
        getProductCountryNames(productCountryList);
     }
    /***************************************************************************************************************************
    @Description:get all product country which is not assigned yet
    ****************************************************************************************************************************/
    public set<string> getProductCountryNames(List<string> productCountryList){
        notAssoProductCntrySet.clear();
        transient List<string> getProdCList= new list<string>();
        set<string> getProdCSet = new set<string>();
        for(string prodc: productCountryList ){
            getProdCList = prodc.split(IPM_ConstantUtils.Delimiter);
            for(string prodc_STR: getProdCList)
            {
                getProdCSet.add(prodc_STR);
            }
        }
        for(IPM_Country__c allCountry:allCountryList)
        {
            if(!getProdCSet.contains(allCountry.Country_Name__c))
            {
                notAssoProductCntrySet.add(allCountry.Country_Name__c);
            }
        }
        return getProdCSet;
    }   
    /*****************************************************************************************************************************
    @Description-remove source unit from map of source unit
    ******************************************************************************************************************************/
    public void removeSourceUnit(){
        try
        {
            sourceUnitMap.get(row_Index).remove(sourceUnitIndex);
        }
        catch(exception ex)
        {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.IPM_Generic_ErrorMessage));
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_SOURCEPLAN_CLASS_STR,
                        'removeSourceUnit',ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, null);
       }
        
    } 
    /*****************************************************************************************************************************
    @Description-create a wrapper class for project product and product plan related records
    ******************************************************************************************************************************/
    public class sourcePlanWrapper{
        public IPM_Project_Product__c productPlan{get;set;}
        public map<id,set<string>> productNCountryMap{get;set;}
        public integer productProsition{get;set;}
        public boolean readModeRow{get;set;}
        public Boolean isDuplicateRow {get;set;}
        public string countryStr{get;set;}
        public string countryStrToDisplay{get;set;}
        public list<string> sourceIntoList{get;set;}
        public sourcePlanWrapper(Integer productProsition,Boolean readModeRow,Boolean isDuplicateRow,IPM_Project_Product__c projectProduct,string countryStr, list<string> sourceIntoList){
            this.productPlan = projectProduct;
            this.productNCountryMap = productNCountryMap;
            this.productProsition = productProsition;
            this.readModeRow = readModeRow;
            this.isDuplicateRow = isDuplicateRow;
            this.countryStr = countryStr;
            this.sourceIntoList = sourceIntoList; 
            this.countryStrToDisplay = countryStr.replaceAll(IPM_ConstantUtils.Delimiter, IPM_ConstantUtils.Delimiter+IPM_ConstantUtils.EMPTY_STRING_DELIMITER); 
        }
    }
    /*****************************************************************************************************************************
    @Description-create a wrapper class for sourcePlan with countries
    ******************************************************************************************************************************/
    public class sourceUnitWrapper{
        public IPM_SourcingPlan__c sourcingPlan{get;set;}
        public string sourceCountries{get;set;}
        public string sourceCountriesToDisplay{get;set;} 
        public sourceUnitWrapper(IPM_SourcingPlan__c sourcingPlan,string sourceCountries){
            this.sourcingPlan = sourcingPlan;
            this.sourceCountries = sourceCountries;
            if(this.sourceCountries.Equals('null'))
            	{
            		this.sourceCountriesToDisplay = '';
            		this.sourceCountries='';
            	}
            else
            	this.sourceCountriesToDisplay = sourceCountries.replaceAll(IPM_ConstantUtils.Delimiter, IPM_ConstantUtils.Delimiter+IPM_ConstantUtils.EMPTY_STRING_DELIMITER); 
        }
    }
}