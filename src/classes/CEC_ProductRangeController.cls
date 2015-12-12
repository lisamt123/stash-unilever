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
<!-- VERSION     AUTHOR            DATE            DETAIL               
<!-- 1.0 -   Koti & Goverdhan    Nov-2015      INITIAL DEVELOPMENT      

************************************************************************/

public class CEC_ProductRangeController {
  
    public String CurrentRecordId{get;set;}
    public case caseRecord{get; set;}
    list <mdm_Case_Product__c> cplist = new list<mdm_Case_Product__c>();
    //Instantiate the StandardSetController  
    public ApexPages.StandardSetController con{get; set;}  
    // set to store the CPG code values
    set<string> cpgCodeSet = new set<string>();
    // map to store cpgCode to brand dependency
    map<string, set<string>> cpgCodeToBrandMap = new map<string, set<string>>();
    public set<string> relatedBrands;
    public string code{get; set;}
    public string brand{get; set;}
    //set the size of the page to display the records
    Public Integer pagesize = 0; 
    Public Boolean onPageLoad = False;
    
   //create a Constructor
    Public  CEC_ProductRangeController(){
        CurrentRecordId = ApexPages.CurrentPage().getparameters().get('id');
        
        if(CurrentRecordId!=null){
            
            caseRecord = [Select Id, CEC_Product__c, Product_Code__c, Product_ISO_Country_Code__c, Product_CPG_Code__c, CEC_Product__r.Global_CPG_Code__r.L7_Product_Category__c, CEC_Product__r.Brand__c FROM case WHERE id =:CurrentRecordId]; 
            
            onPageLoad = TRUE;
            
            if(caseRecord.Product_ISO_Country_Code__c != null){
                cplist = [Select Id, Name, Brand__c, ISO_Country_Code__c, Global_CPG_Code__c, Global_CPG_Code__r.L7_Product_Category__c
                        FROM mdm_Case_Product__c 
                        WHERE ISO_Country_Code__c =:caseRecord.Product_ISO_Country_Code__c 
                        AND  Name!=:caseRecord.Product_Code__c
                        AND  Active_for_CEC__c = TRUE
                        AND Brand__c != null
                        AND Global_CPG_Code__c != null
                        AND Global_CPG_Code__c != ''
                        AND Global_CPG_Code__r.L7_Product_Category__c != null
                        ORDER BY Global_CPG_Code__c ASC NULLS LAST
                        LIMIT 50000];
                
                if(!Test.IsRunningtest()){
                    cec_Org_Settings__c cecOrgSet = cec_Org_Settings__c.getInstance();
                    pagesize = (Integer)cecOrgSet.Recommended_Products_Page_Size__c;
                }else{
                    pagesize = 10;
                }
                   
                code = caseRecord.CEC_Product__r.Global_CPG_Code__r.L7_Product_Category__c;
                //brand = caseRecord.CEC_Product__r.Brand__c;
                brand = '-None-';
                fetchRecords();
            }
            else{
                cplist = null;            
            }

        }   
    }
    
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

    public pageReference fetchRecords(){      
        
        for(mdm_Case_Product__c cp :cplist){
        
            set<string> brandSet = new set<string>();
            // if CPG code doesn't exist in the set, add it to set and also populate the cpgCodeToBrandMap map
            if(!cpgCodeSet.contains(cp.Global_CPG_Code__r.L7_Product_Category__c)){
                cpgCodeSet.add(cp.Global_CPG_Code__r.L7_Product_Category__c);
                brandSet.add(cp.Brand__c);
                cpgCodeToBrandMap.put(cp.Global_CPG_Code__r.L7_Product_Category__c, brandSet);
            // else get brandlist from cpgCodeToBrandMap and update it to include any new brands
            }else if(cpgCodeToBrandMap.keyset().contains(cp.Global_CPG_Code__r.L7_Product_Category__c)){
                brandSet = cpgCodeToBrandMap.get(cp.Global_CPG_Code__r.L7_Product_Category__c);
                if(!brandSet.contains(cp.Brand__c)){
                    brandSet.add(cp.Brand__c);
                    cpgCodeToBrandMap.put(cp.Global_CPG_Code__r.L7_Product_Category__c, brandSet);
                }
            }
            
        }
        getCodes();
        getBrands();
        filteredCaseProducts(); 
        
        return null;
    }
    
    public list<SelectOption> getCodes(){
        List<SelectOption> options = new List<SelectOption>();
        for(string cs :cpgCodeSet){
            options.add(new selectOption(cs, cs));
        }
        options.add(new selectOption('-None-','-None-'));
        return options;
    }
    
    public list<SelectOption> getBrands(){
        set<string> brands = new set<string>();
        if(code!='-None-')
        brands = cpgCodeToBrandMap.get(code);
        else{
            for(set<String> bset : cpgCodeToBrandMap.values()){
                brands.addAll(bset);
            }       
        }
        List<SelectOption> options = new List<SelectOption>();
        if(brands != null){
        for(string bs :brands){
            options.add(new selectOption(bs, bs));
        }
        }
        options.add(new selectOption('-None-','-None-'));              
        return options;
    }
    
    Public  PageReference filteredCaseProducts(){
        list<mdm_Case_Product__c> searchList = new list<mdm_Case_Product__c>();
        //if(brand!=null) {
        System.debug('I am here' + onPageLoad + 'Code:' + code);
        
        if(cplist!=null){
                for(mdm_Case_Product__c cp :cplist){  
                    if(onPageLoad == TRUE && cp.Global_CPG_Code__r.L7_Product_Category__c == code)//For initial pageload
                    {
                        searchList.add(cp); 
                    }                          
                    else if(code!= '-None-' && brand != '-None-' && cp.Brand__c == brand && cp.Global_CPG_Code__r.L7_Product_Category__c == code)//For particular code and brand
                    {
                        searchList.add(cp);
                    }               
                    else if(code== '-None-' && brand != '-None-' && cp.Brand__c == brand)//For brand across the different code
                    {     
                        searchList.add(cp);
                    }
                    else if(code!= '-None-' && brand == '-None-' && cp.Global_CPG_Code__r.L7_Product_Category__c == code)//For displaying all brands for a particular CPG code
                    {
                        searchList.add(cp);
                    }
                }
                
         }
            con = new ApexPages.StandardSetController(searchList);  
            // sets the number of records in each page set  
            con.setPageSize(pagesize);
            onPageLoad = FALSE;
        //}  
       // else {  
       //    con = null;  
       // }  
        return null ;
    }
        
}