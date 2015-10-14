public with sharing class Oblix_Ctrl03AssetLookupNew {
	public String searchString{get;set;}
	public String assetType {get;set;}
	public String subCategory{get;set;}
	
	public List<Asset_Scoring__c> lstResultAssetScoring{get;set;}
	
	public Oblix_Ctrl03AssetLookupNew(){
		 searchString = System.currentPageReference().getParameters().get('lksrch');
		 assetType = System.currentPageReference().getParameters().get('assetType');
		 subCategory = System.currentPageReference().getParameters().get('subCategory');
    	runSearch();  
	}
	
	
	public void SearchDescription(){
		runSearch();
		system.debug('###lstResultAssetScoring ActionFunction :' + lstResultAssetScoring );    
	}
	
	 // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    lstResultAssetScoring = performSearch();    
    system.debug('###lstResultAssetScoring :' + lstResultAssetScoring );           
  } 
  
    /**
     * Build the Where part of the query as string.
     * @return [the Where part of the query as string] 
     */                      
    private List<String> buildQueryWhere(){
    	 List<String> lstQueryWhere = new List<String>();
        
        String strToAdd = esc(searchString);
        if (strToAdd != null && strToAdd != '')
        {
            lstQueryWhere.add('Name LIKE \'' + strToAdd +'\'');
        }
        
        /* strToAdd = esc(assetType);
        if (strToAdd != null && strToAdd != '')
        {
            lstQueryWhere.add('Type__c= \'' + strToAdd +'\'');
        }*/
         strToAdd = esc(subCategory);
        if (strToAdd != null && strToAdd != '')
        {
            lstQueryWhere.add('Sub_Category__c = \'' + strToAdd +'\'');
        }
         return lstQueryWhere;
    }
    
    /**
     * Guard against SOQL injection
     */ 
    private String esc(String s) 
    {
        return s != null ? String.escapeSingleQuotes(s) : null;
    }
    
  
   // run the search and return the records found. 
  private List<Asset_Scoring__c> performSearch() {
 
    List<String> lstQueryWhere = buildQueryWhere();
         system.debug('###lstQueryWhere :' + lstQueryWhere );
         
         String WhereQuery = 'select id, name, Type__c, Sub_Category__c,Description__c from Asset_Scoring__c';
        if(lstQueryWhere.size() == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please Select Type at least'));
            return null;
        }else{
            WhereQuery += ' where';
            for (String andQuery : lstQueryWhere)
            {
                WhereQuery += '(' + andQuery + ') AND ';
            }
    
            if (WhereQuery.lastIndexOf('AND') != -1)
            {
                WhereQuery = WhereQuery.subString(0, WhereQuery.lastIndexOf('AND'));
            }
             WhereQuery += ' Limit 999';
        	 system.debug('###WhereQuery:' + WhereQuery);  
             return database.query(WhereQuery); 
        }
 
  }
 
   // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
  
  
}