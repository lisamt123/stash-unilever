/**********************************************************************
Name: BEN_KPIProgress_Generator_Controller Copyright © 2016 Salesforce 
======================================================
======================================================
Purpose: This class is controller class for Visualforce page BEN_KPIProgressReport_Generator
======================================================
======================================================
History
-------
VERSION     AUTHOR        DATE            DETAIL Description
V1.0         mahesh         25/01/2017    Visualforce page COntroller clazz
***********************************************************************/
public with sharing class BEN_KPIProgress_Generator_Controller {
    
    
    public static String renderAsVar {get; set;}
    public static String selectedInputs {get; set;}
    public static List<String> yearQuarter {get; set;}
    public static Category allCategories {get; set;}
    public static Map<String, Category> catWiseDetails {get; set;}
    
    //inner class to support the nested structure of the output
    public class Category{
        
        public Integer totalRecs {set; get;}
        public String CategoryName{ get; set;}
        
        public Decimal dup_totalWin {get; set;}
        public Decimal dup_totalParity {get; set;}
        public Decimal dup_totalLoss {get; set;}
        public Decimal dup_totalsCount {get; set;}
        
        public Category(){
            dup_totalWin = 0;
            dup_totalParity = 0;
            dup_totalLoss = 0;
            dup_totalsCount = 0;
        }
        
        public String totalWinPerc {
            get{
                Decimal temp = 0;
                if(dup_totalsCount!=0.0)
                temp = (dup_totalWin/ dup_totalsCount) * 100;
                return String.valueOf(temp.setScale(1)+ '%');
            }
            set;}
        
        public String totalParityPerc {
            get{
                Decimal temp = 0;
                if(dup_totalsCount!=0.0)
                temp = (dup_totalParity/ dup_totalsCount) * 100;
                return String.valueOf(temp.setScale(1)+ '%');
            } 
            set;}
        
        public String totalLossPerc {
            get{
                Decimal temp = 0;
                if(dup_totalsCount!=0.0)
                temp = (dup_totalLoss/ dup_totalsCount) * 100;
                return String.valueOf(temp.setScale(1)+ '%');
            }
            set;}
        
        public String totalsCount {
            get{
                return String.valueOf(dup_totalsCount);
            }
            set;}
        
        public Map<String, Map<String, Integer>> YearQuarWiseCounts {get; set;}
        
    }
    
    //Main class Controller
    public BEN_KPIProgress_Generator_Controller(){
        Map<String , String> params = ApexPages.currentPage().getParameters();
        selectedInputs = params.get('YearQuarterSelected');
        renderAsVar = params.get('renderAsVar');
       // getKPIProgressReport();
    }
    
    //Parsing the String which has "[option1,option2]" format into List collection.
    public static List<String> parseYearQuarterfromInputs(){
        List<String> catts = new List<String>();
        if(selectedInputs!= null){
            selectedInputs =  selectedInputs.substring(selectedInputs.indexOf('[')+1,selectedInputs.indexOf(']'));
            catts.addAll(selectedInputs.split(', '));
        }
        return catts;
    }
    
    //to get KPI report query into DB based on Inputs and putting the result into Main class variables.
    public static void getKPIProgressReport(){
        
        yearQuarter = parseYearQuarterfromInputs();
        
        List<BEN_Category_Details__c> catDetailsAllYQ = [Select ID, fml_Overall_Score__c,	Product_Category__r.Name, fml_Year_Quarter__c  from BEN_Category_Details__c where fml_Year_Quarter__c IN :yearQuarter AND pkl_Status__c='Approved' Order By Product_Category__r.Name];
        AggregateResult[] categories = [Select Count(ID) catCount, Product_Category__r.Name from BEN_Category_Details__c where fml_Year_Quarter__c IN :yearQuarter AND pkl_Status__c='Approved' Group By Product_Category__r.Name Order By Product_Category__r.Name];
        
        //Concating all category names into one string TempString
        String tempString = '';
        for(Integer test=0; test < catDetailsAllYQ.size(); test++){
            if(tempString != catDetailsAllYQ.get(test).Product_Category__r.Name){
                tempString = catDetailsAllYQ.get(test).Product_Category__r.Name;
            }
        }
        
        catWiseDetails  =  new Map<String, Category>();
        
        // get all Category Names and thier record counts from Aggregate query result
        for (AggregateResult ar : categories) {
            Category newCat = new Category();
            newCat.CategoryName = (String)ar.get('Name');
            newCat.totalRecs = (Integer)ar.get('catCount');
            catWiseDetails.put((String)ar.get('Name'),newCat );
        }
        
        allCategories = new Category();
        allCategories.CategoryName = 'All Categories';
        Map<String, Map<String, Integer>> allCatYQWiseCount = new Map<String, Map<String, Integer>>();
        
        //forlop iteration based on the number of categories return on DB query result.
        Integer it = 0;
        for(String categoryName : catWiseDetails.keySet()){
            Category cat = catWiseDetails.get(categoryName);
            Map<String, Map<String, Integer>> YQWiseCounts = new Map<String, Map<String, Integer>>();
            
            //Forloop iteration based on number of records for each Categories which have at first loop iteration.
            for(Integer i = 0 ; i< cat.totalRecs ; i++){
                BEN_Category_Details__c catDetail = catDetailsAllYQ.get(it);
                Map<String, Integer> detailCounts = null;
                Map<String, Integer> allCatdetailCounts = null;
                
                detailCounts = getMapWithSpeficiedKey(YQWiseCounts, detailCounts, catDetail.fml_Year_Quarter__c );
                allCatdetailCounts = getMapWithSpeficiedKey(allCatYQWiseCount, allCatdetailCounts, catDetail.fml_Year_Quarter__c );
                
                if(catDetail.fml_Overall_Score__c == 'WIN'){
                    incrementIntegerinMap(detailCounts, 'WIN');
                    incrementIntegerinMap(allCatdetailCounts, 'WIN');
                    cat.dup_totalWin += 1;
                    allCategories.dup_totalWin += 1;
                }
                else if(catDetail.fml_Overall_Score__c == 'PARITY'){
                    incrementIntegerinMap(detailCounts, 'PARITY');
                    incrementIntegerinMap(allCatdetailCounts, 'PARITY');
                    cat.dup_totalParity +=1;
                    allCategories.dup_totalParity += 1;
                } 
                else if(catDetail.fml_Overall_Score__c == 'LOSS'){
                    incrementIntegerinMap(detailCounts, 'LOSS');
                    incrementIntegerinMap(allCatdetailCounts, 'LOSS');
                    cat.dup_totalLoss += 1;
                    allCategories.dup_totalLoss += 1;
                }
                
                incrementIntegerinMap(detailCounts, 'TOTAL');
                incrementIntegerinMap(allCatdetailCounts, 'TOTAL');
                cat.dup_totalsCount += 1;
                allCategories.dup_totalsCount += 1;
                it++;
            }
            cat.YearQuarWiseCounts = YQWiseCounts;
            allCategories.YearQuarWiseCounts = allCatYQWiseCount;
        }
        
    }
    
    //Generic method for all results (WIN, PARITY, LOSS), it increments with +1 value.
    public static void incrementIntegerinMap(Map<String, Integer> detailMap, String mapKey ){
        Integer temp;
        if(detailMap.get(mapKey) == null){
            detailMap.put(mapKey, 0);
        }else{
            temp = detailMap.get(mapKey);
            temp = temp+ 1;
            detailMap.put(mapKey, temp);
        }
    }
    
    //method checks for map collection is available for particular key(year/quarter)
    public static Map<String, Integer> getMapWithSpeficiedKey(Map<String, Map<String, Integer>> YQWiseMap, Map<String, Integer> detailCounts, String YQKey){
        
        if(!YQWiseMap.keySet().contains(YQKey)){
            detailCounts = new Map<String, Integer>();
            detailCounts.put('WIN', 0);
            detailCounts.put('PARITY', 0);
            detailCounts.put('LOSS', 0);
            detailCounts.put('TOTAL', 0);
            YQWiseMap.put(YQKey, detailCounts);
        }
        else{
            detailCounts = (Map<String, Integer>)YQWiseMap.get(YQKey);
        }
        return detailCounts;
    }
    
    
}