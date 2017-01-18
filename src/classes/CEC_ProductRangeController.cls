/**********************************************************************
 Name:  CEC_ProductRangeController()
 Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the controller class for CEC_ProductRange Vf page                                                                                                    

========================================================================
========================================================================
<!-- History                                                 -->
<!-- ---------------------------------------------------------->
VERSION     AUTHOR              DATE            DETAIL               
  1.0       Koti & Goverdhan    --/Nov/2015     INITIAL DEVELOPMENT      
  1.1       Goverdhan S.        01/Dec/2015     Code refactored to enhance performance
  1.2       Goverdhan S.        03/Feb/2016     CSC-3631 :Included product tag as filter    
  
************************************************************************/

public with sharing class CEC_ProductRangeController{
    
    // to store the caseId from parent page
    public String CurrentRecordId{get; set;}
    // to store queried case record
    public case caseRecord{get; set;}
    // list used to store all case products used for Category and Brand mapping
    static list <mdm_Case_Product__c> cplist = new list<mdm_Case_Product__c>();
    //Instantiate the StandardSetController  
    public ApexPages.StandardSetController con{get; set;}  
    // set to store the CPG code values
    set<string> cpgCodeSet = new set<string>();
    // map to store Product category to brand dependency
    map<string, set<string>> cpgCodeToBrandMap = new map<string, set<string>>();
    // map to store Product category to Tag dependency
    map<string, set<string>> cpgCodeToTagMap = new map<string, set<string>>();
    // stores selected product category from page
    public string code{get; set;}
    // stores selected brand from page
    public string brand{get; set;}
    // stores selected Product Tag from page
    public string productTag{get; set;}
    //set the size of the page to display the records
    Public Integer pagesize = 0;
    // controls initial page load action
    Public Boolean onPageLoad = False;
	// picklist constant
	public final String picklistValueNone = '-None-';
    // initilises caseProduct list
    public List<mdm_Case_Product__c> CaseProducts  
    {  
        get  
        {  
            if(con != null)  
                return (List<mdm_Case_Product__c>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }
    
    
    //Class Constructor
    Public CEC_ProductRangeController(){
        // get case id
        CurrentRecordId = ApexPages.CurrentPage().getparameters().get('id');
        // set page size
        if(!Test.IsRunningtest()){
            cec_Org_Settings__c cecOrgSet = cec_Org_Settings__c.getInstance();
            pagesize = (Integer)cecOrgSet.Recommended_Products_Page_Size__c;
        }else{
            pagesize = 10;
        }
    }
    
    
    // method called on page load. performs actions for initial page load
    public pageReference pageLoadAction(){
        try{
            if(CurrentRecordId!=null){
                // set page load to true            
                onPageLoad = TRUE;
                // query case fields
                caseRecord = queryCase(CurrentRecordId);
                // initialize code variable on page load
                code = caseRecord.CEC_Product__r.Global_CPG_Code__r.L7_Product_Category__c;
                // initialize brand to none
                brand = picklistValueNone;
                productTag = picklistValueNone;
                
                if(caseRecord.Product_ISO_Country_Code__c != null){
                    // query case products to create category and brand map
                    cplist = queryCaseProducts(caseRecord.Product_ISO_Country_Code__c, caseRecord.Product_Code__c);
                    // create brand set and product to brand map
                    createProductToBrandMap();
                    // query and display records based on filters on page
                    filteredCaseProducts(); 
                }
                else{
                    cplist = null;    
                }
                // reset pageload variable
                onPageLoad = FALSE;
            }
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'An error occured. Please try again, if error persists, please contact your administrator'));
        }
        
        return null;
    }
    
    
    // method to query case record
    private Case queryCase(id caseId){
        Case thisCase = new Case();
        thisCase = [Select Id, Product_Code__c, Product_ISO_Country_Code__c, CEC_Product__r.Brand__c,
                                    CEC_Product__r.Global_CPG_Code__r.L7_Product_Category__c                                     
                                    FROM Case WHERE id = :caseId LIMIT 1];
        return thisCase;
    }
    
    
    // method to query case products
    private list<mdm_Case_Product__c> queryCaseProducts(string countryISOCode, string productCode){
        list <mdm_Case_Product__c> cplst = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Category_Search__c, Product_Tag__c
                                            FROM mdm_Case_Product__c 
                                            WHERE ISO_Country_Code__c = :countryISOCode 
                                            AND  Name != :productCode
                                            AND  Active_for_CEC__c = TRUE
                                            AND Brand__c != null
                                            AND Global_CPG_Code__c != null
                                            AND Global_CPG_Code__c != ''
                                            AND Category_Search__c != null
                                            AND IsDeleted = FALSE
                                            ORDER BY Global_CPG_Code__c ASC NULLS LAST
                                            LIMIT 50000];
        return cplst;
    }
    
     
    // method to create brand set and product to brand map
    public pageReference createProductToBrandMap(){
        for(mdm_Case_Product__c cp :cplist){
        
            set<string> brandSet = new set<string>();
            set<string> tagSet = new set<string>();
            // if CPG code doesn't exist in the set, add it to set and also populate the cpgCodeToBrandMap map
            if(!cpgCodeSet.contains(cp.Category_Search__c)){
                cpgCodeSet.add(cp.Category_Search__c);
                brandSet.add(cp.Brand__c);
                tagSet.add(cp.Product_Tag__c);
                cpgCodeToBrandMap.put(cp.Category_Search__c, brandSet);
                cpgCodeToTagMap.put(cp.Category_Search__c, tagSet);
            // else get brandlist from cpgCodeToBrandMap and update it to include any new brands
            }else if(cpgCodeToBrandMap.keyset().contains(cp.Category_Search__c)){
                brandSet = cpgCodeToBrandMap.get(cp.Category_Search__c);
                tagSet = cpgCodeToTagMap.get(cp.Category_Search__c);
                if(!brandSet.contains(cp.Brand__c)){
                    brandSet.add(cp.Brand__c);
                    cpgCodeToBrandMap.put(cp.Category_Search__c, brandSet);
                }
                if(!tagSet.contains(cp.Product_Tag__c)){
                    tagSet.add(cp.Product_Tag__c);
                    cpgCodeToTagMap.put(cp.Category_Search__c, tagSet);
                }
            }            
        }
        return null;
    }
    
    
    // populate code picklist values for vfpage
    public list<SelectOption> getCodes(){
        List<SelectOption> options = new List<SelectOption>();
        for(string cs :cpgCodeSet){
            if(cs != null){
                options.add(new selectOption(cs, cs));
            }
        }
        options.sort();
        options.add(new selectOption(picklistValueNone,picklistValueNone));
        return options;
    }
    
    
    // populate brand picklist values for vfpage
    public list<SelectOption> getBrands(){
        set<string> brands = new set<string>();
        if(code!=picklistValueNone){
            brands = cpgCodeToBrandMap.get(code);
        }else{
            for(set<String> bset : cpgCodeToBrandMap.values()){
                brands.addAll(bset);
            }       
        }
        List<SelectOption> options = new List<SelectOption>();
        if(brands !=null && !brands.isEmpty()){
            for(string bs :brands){
                if(bs != null){
                    options.add(new selectOption(bs, bs));
                }
            }
        }
        options.sort();
        options.add(new selectOption(picklistValueNone,picklistValueNone));
        return options;
    }
    
    
    // populate tag picklist values for vfpage
    public list<SelectOption> getTags(){
        set<string> tags = new set<string>();
        if(code != picklistValueNone){
            tags = cpgCodeToTagMap.get(code);
        }else{
            for(set<String> tset : cpgCodeToTagMap.values()){
                tags.addAll(tset);
            }       
        }
        List<SelectOption> options = new List<SelectOption>();
        if(tags!= null && !tags.isEmpty()){
            for(string ts :tags){
                if(ts != null){
                    options.add(new selectOption(ts, ts));
                }
            }
        }
        options.sort();
        options.add(new selectOption(picklistValueNone,picklistValueNone));
        return options;
    }
    
    
    // method to filter and display records on vf page
    Public  PageReference filteredCaseProducts(){
        list<mdm_Case_Product__c> searchList = new list<mdm_Case_Product__c>();
        
        if(cplist != null){            
            if(onPageLoad){ //For initial pageload
                for(mdm_Case_Product__c cp :cplist){
                    // create list for initial page load
                    if(cp.Category_Search__c == code)
                    {
                        searchList.add(cp);
                    }
                }
            }else{  // create product list based on user filters
                if(code != picklistValueNone && brand != picklistValueNone && productTag != picklistValueNone){    //For selected code, brand and tag
                    searchList = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Category_Search__c, Product_Tag__c
                                    FROM mdm_Case_Product__c 
                                    WHERE ISO_Country_Code__c = :caseRecord.Product_ISO_Country_Code__c 
                                    AND  Name != :caseRecord.Product_Code__c
                                    AND  Active_for_CEC__c = TRUE
                                    AND Brand__c = :brand
                                    AND Category_Search__c = :code
                                    AND Product_Tag__c = :productTag
                                    AND IsDeleted = FALSE
                                    LIMIT 10000];
                }else if(code != picklistValueNone && brand != picklistValueNone && productTag == picklistValueNone){  //For all active codes and brands in the country     
                    searchList = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Category_Search__c, Product_Tag__c
                                    FROM mdm_Case_Product__c 
                                    WHERE ISO_Country_Code__c = :caseRecord.Product_ISO_Country_Code__c 
                                    AND  Name != :caseRecord.Product_Code__c
                                    AND  Active_for_CEC__c = TRUE
                                    AND Brand__c = :brand
                                    AND Category_Search__c = :code
                                    AND IsDeleted = FALSE
                                    LIMIT 10000];
                }else if(code != picklistValueNone && brand == picklistValueNone && productTag != picklistValueNone){  //For all active codes and tags in the country     
                    searchList = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Category_Search__c, Product_Tag__c
                                    FROM mdm_Case_Product__c 
                                    WHERE ISO_Country_Code__c = :caseRecord.Product_ISO_Country_Code__c 
                                    AND  Name != :caseRecord.Product_Code__c
                                    AND  Active_for_CEC__c = TRUE
                                    AND Brand__c != ''
                                    AND Category_Search__c = :code
                                    AND Product_Tag__c = :productTag
                                    AND IsDeleted = FALSE
                                    LIMIT 10000];
                }else if(code != picklistValueNone && brand == picklistValueNone && productTag == picklistValueNone){  //For all active product code
                    searchList = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Category_Search__c, Product_Tag__c
                                    FROM mdm_Case_Product__c 
                                    WHERE ISO_Country_Code__c = :caseRecord.Product_ISO_Country_Code__c 
                                    AND  Name != :caseRecord.Product_Code__c
                                    AND  Active_for_CEC__c = TRUE
                                    AND Brand__c != ''
                                    AND Category_Search__c = :code
                                    AND IsDeleted = FALSE
                                    LIMIT 10000];
                }else if(code == picklistValueNone && brand != picklistValueNone && productTag != picklistValueNone){  //For all active brands and tags in the country     
                    searchList = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Category_Search__c, Product_Tag__c
                                    FROM mdm_Case_Product__c 
                                    WHERE ISO_Country_Code__c = :caseRecord.Product_ISO_Country_Code__c 
                                    AND  Name != :caseRecord.Product_Code__c
                                    AND  Active_for_CEC__c = TRUE
                                    AND Brand__c = :brand
                                    AND Category_Search__c != ''
                                    AND Product_Tag__c = :productTag
                                    AND IsDeleted = FALSE
                                    LIMIT 10000];
                }else if(code == picklistValueNone && brand != picklistValueNone && productTag == picklistValueNone){  //For all active brands in the country     
                    searchList = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Category_Search__c, Product_Tag__c
                                    FROM mdm_Case_Product__c 
                                    WHERE ISO_Country_Code__c = :caseRecord.Product_ISO_Country_Code__c 
                                    AND  Name != :caseRecord.Product_Code__c
                                    AND  Active_for_CEC__c = TRUE
                                    AND Brand__c = :brand
                                    AND Category_Search__c != ''
                                    AND IsDeleted = FALSE
                                    LIMIT 10000];
                }else if(code == picklistValueNone && brand == picklistValueNone && productTag != picklistValueNone){//For all active product tags
                    searchList = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Category_Search__c, Product_Tag__c
                                    FROM mdm_Case_Product__c 
                                    WHERE ISO_Country_Code__c = :caseRecord.Product_ISO_Country_Code__c 
                                    AND  Name != :caseRecord.Product_Code__c
                                    AND  Active_for_CEC__c = TRUE
                                    AND Brand__c != ''
                                    AND Category_Search__c != ''
                                    AND Product_Tag__c = :productTag
                                    AND IsDeleted = FALSE
                                    LIMIT 10000];
                }
            }
                
        }else{  //For no filter
            searchList = null;
        }
        // load results in set controller
        con = new ApexPages.StandardSetController(searchList);  
        // sets the number of records in each page set  
        con.setPageSize(pagesize);
        return null;
    }
        
}