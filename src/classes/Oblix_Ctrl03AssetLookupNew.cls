/** 
    About
    -----
    Description: Class Oblix_Ctrl03AssetLookupNew
    Created for: Oblix Unilever Project
    Create date: 10/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : Used as a  class to Construct Lookup of Full Description"Asset Scoring"
                        
            Functionnalities : 
                    
    Update History
    --------------    
*/ 
public with sharing class Oblix_Ctrl03AssetLookupNew {
//******************************************************************************************************
//      THE CONTENT OF THIS CLASS HAS BEEN COMMENT OUT AS THIS CLASS IS NO LONGER USED
//      AS PART OF CODE REFACTORING, NEW CLASSES HAVE REPLACED THESE
//      S.M. 2016-03-30
//******************************************************************************************************
 //   public String searchString{get;set;}
 //   public String subCategory{get;set;}
 //   public String assetType{get;set;}
    
 //   public List<Asset_Scoring__c> lstResultAssetScoring{get;set;}
    
 //   public Oblix_Ctrl03AssetLookupNew(){
 //        searchString = System.currentPageReference().getParameters().get('lksrch');
 //        assetType = System.currentPageReference().getParameters().get('assetType');
 //        subCategory = System.currentPageReference().getParameters().get('subCategory');
 //       runSearch();  
 //   }
    
 //   /**
 //    * Search for the Full Description
 //    * runSearch() : Execute the query 
 //    */ 
 //   public void SearchDescription(){
 //       runSearch();
 //       system.debug('###lstResultAssetScoring ActionFunction :' + lstResultAssetScoring );    
 //   }
    
 // /**
 //    * prepare the query and issue the search command
 //    * param : [lstResultAssetScoring] lstOf AssetScoring Result
 //    */ 
 // private void runSearch() {
 //   // TODO prepare query string for complex serarches & prevent injections
 //   lstResultAssetScoring = performSearch();    
 //   system.debug('###lstResultAssetScoring :' + lstResultAssetScoring );           
 // } 
  
 //   /**
 //    * Build the Where part of the query as string.
 //    * @return [the Where part of the query as string] 
 //    */                      
 //   private List<String> buildQueryWhere(){
 //        List<String> lstQueryWhere = new List<String>();
        
 //       String strToAdd = esc(searchString);
 //       if (strToAdd != null && strToAdd != '')
 //       {
 //           lstQueryWhere.add('Name LIKE \'' + strToAdd +'\'');
 //       }
        
 //        strToAdd = esc(assetType);
 //       if (strToAdd != null && strToAdd != '')
 //       {
 //           lstQueryWhere.add('Type__c= \'' + strToAdd +'\'');
 //       }
 //        strToAdd = esc(subCategory);
 //       if (strToAdd != null && strToAdd != '')
 //       {
 //           lstQueryWhere.add('Sub_Category__c = \'' + strToAdd +'\'');
 //       }
 //        return lstQueryWhere;
 //   }
    
 //   /**
 //    * Guard against SOQL injection
 //    */ 
 //   private String esc(String s) 
 //   {
 //       return s != null ? String.escapeSingleQuotes(s) : null;
 //   }
    
 // /**
 //  * run the search and return the records found. 
 //  * @return : lstAssetScoring search
 //  */
 // private List<Asset_Scoring__c> performSearch() {
 
 //   List<String> lstQueryWhere = buildQueryWhere();
 //        system.debug('###lstQueryWhere :' + lstQueryWhere );
         
 //        String WhereQuery = 'select id, name, Type__c, Sub_Category__c,Description__c from Asset_Scoring__c';
 //       if(lstQueryWhere.isEmpty()){
 //           ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please Select Type at least'));
 //           return null;
 //       }else{
 //           WhereQuery += ' where';
 //           for (String andQuery : lstQueryWhere)
 //           {
 //               WhereQuery += '(' + andQuery + ') AND ';
 //           }
    
 //           if (WhereQuery.lastIndexOf('AND') != -1)
 //           {
 //               WhereQuery = WhereQuery.subString(0, WhereQuery.lastIndexOf('AND'));
 //           }
 //            WhereQuery += ' order by Name Limit 999';
 //            system.debug('###WhereQuery:' + WhereQuery);  
 //            return database.query(WhereQuery); 
 //       }
 
 // }
 
 // /**
 //  * used by the visualforce page to send the link to the right dom element
 //  * @return : lstAssetScoring search
 //  */
 // public string getFormTag() {
 //   return System.currentPageReference().getParameters().get('frm');
 // }
 
 ///**
 //  *  used by the visualforce page to send the link to the right dom element for the text box
 //  * @return : lstAssetScoring search
 //  */
 // public string getTextBox() {
 //   return System.currentPageReference().getParameters().get('txt');
 // }
  
  
}