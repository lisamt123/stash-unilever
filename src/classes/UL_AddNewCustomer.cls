/***************************************************************
Name: UL_AddNewCustomer()
Copyright © 2015 Salesforce
======================================================
Purpose:
Controller for UL_AddNewCustomer apex page.
======================================================
History
-------
VERSION     AUTHOR         DATE              DETAIL            Description
1.0         Ketan Mehta    24/10/2016        INITIAL DEV       Initial data load and search functionality implemented.
***************************************************************/
public with sharing class UL_AddNewCustomer{

    //Static variables
    private final static String LIMIT_CLAUSE = ' LIMIT 900';
    private final static String LIKE_CLAUSE_START = '\'%';
    private final static String LIKE_CLAUSE_END = '%\' ';
    private final static String FILTER_OR_CLAUSE = ' OR ';
    
    /*******************************************************************
    Purpose: Generic enum
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    private enum Params{
        setId,
        orgId,
        retURL,
        setName
    }
    
    //Non-Static Variables
    public List<AccountSetWrapper> customerList {get; set;}
    public List<ACCL__Account_Set_Account__c> selectedCustomer {get; set;}
    public String field1 {get;set;}
    public String field2 {get;set;}
    public String field3 {get;set;}
    public String field4 {get;set;}
    public String field5 {get;set;}
    public Boolean isInclusive {get;set;}
    public Boolean isFltApplied {get;set;}
    public String setName {get;set;}
    
    private final Id setId {get;set;}
    private String salesOrgId {get;set;}
    private String referer{get{return UL_Utility.FORWARD_SLASH + referer;} set;}
    
    /*******************************************************************
    Purpose: Default constructor to access page parameter
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public UL_AddNewCustomer(ApexPages.StandardController controller) {
        setId = ((ACCL__Account_Set_Account__c)controller.getRecord()).ACCL__Account_Set__c;
        isInclusive = false;
        isFltApplied=false; 
    }

    
    /*******************************************************************
    Purpose: Load default set of record - called from page load event 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: System Exception
    ********************************************************************/
    public PageReference doPageLoad(){
        try{  
          setCustomerSetParam();
          getResultSet();
        }catch(Exception ex){
          UL_Utility.logError(ex, UserInfo.getUserId());
        }
    return null;
    }
    
    /*******************************************************************
    Purpose: Method called on 'Search' button click event 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: System Exception
    ********************************************************************/
    public PageReference doSearch(){
      if(string.isEmpty(field1) && string.isEmpty(field2) && string.isEmpty(field3) && string.isEmpty(field4) && string.isEmpty(field5)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.NO_SEARCH_CRITERIA));
      }else{
          try{
              getResultSet();
          }catch(Exception ex){
             UL_Utility.logError(ex, UserInfo.getUserId());
          }
      }
      
      return null;
    }
    
    /*******************************************************************
    Purpose: Method called on 'Clear Filter' button click event 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: System Exception
    ********************************************************************/
    public PageReference doClearFilter(){
       field1=null;
       field2=null;
       field3=null;
       field4=null;
       field5=null;
       
       isFltApplied = false;
       try{
           getResultSet();
       }catch(Exception ex){
         UL_Utility.logError(ex, UserInfo.getUserId());
       }
       return null;
    }
    
    /*******************************************************************
    Purpose: Method called on 'Save' button click event. 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: System Exception
    ********************************************************************/
    public PageReference submit(){
    try{
        if(setId != null){
            selectedCustomer = new List<ACCL__Account_Set_Account__c>();
            for (AccountSetWrapper customer: customerList) {
                if (customer.selected == true) {
                    ACCL__Account_Set_Account__c  accSet = new ACCL__Account_Set_Account__c();
                    accSet.ACCL__Account__c =  customer.acc.id;
                    accSet.ACCL__Account_Set__c  = setId;          
                    selectedCustomer.add(accSet);
                    customer.selected = false;         
                }
            }
            
            if(selectedCustomer.size()> 0){
             Database.SaveResult[] insertResult = Database.insert(selectedCustomer);
             for (Database.SaveResult sr : insertResult) {
                 if (!sr.isSuccess()){
                   break;
                 }
              }
              
            }else
            {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.ACCL.CALL_SELECT_AT_LEAST_ONE));
             return null;
            }
        }
        }catch(Exception ex){
           UL_Utility.logError(ex, UserInfo.getUserId());
       }
       return backToParent();
    }
    
    /*******************************************************************
    Purpose: Method called on 'Back' button click event or Save action completes successfully. Redirects to referer parameter 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws N/A
    ********************************************************************/
    public PageReference backToParent(){
        PageReference pageRef = null; 
        try{ 
            pageRef = new PageReference(referer);
            pageRef.setRedirect(true);
        }catch(Exception ex){
            UL_Utility.logError(ex, userInfo.getUserId());
        }
        
        return pageRef;
    }

    /*******************************************************************
    Purpose: Generic method to be called for search, clear Search public methods. 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws N/A
    ********************************************************************/
    private void getResultSet(){
        customerList = new List<AccountSetWrapper>();
        
        String searchQuery = 'SELECT Id, Name, UL_Customer_Group_Description__c, UL_Market_Channel_Description__c,UL_Market_Description__c FROM Account ' + getFilterClause();
        List<sObject> sobjList = Database.query(searchQuery);
        if(!sobjList.isEmpty()){
            Account tempAccount;
            Map<Id, Account> accMap = new Map<Id, Account>();
               for(sObject obj: sobjList){
                   tempAccount = (Account)obj;
                   accMap.put(tempAccount.id, tempAccount);            
               }
               
               //Filter out existing Account(s) in junction object
               for(ACCL__Account_Set_Account__c accSet: [SELECT ACCL__Account__c FROM ACCL__Account_Set_Account__c WHERE ACCL__Account__c IN :accMap.keySet() AND ACCL__Account_Set__c=:setId]){
                   accMap.remove(accSet.ACCL__Account__c);
               } 
               
               //Create wrapper object list
               for(Account acc: accMap.values()){
                customerList.add(new AccountSetWrapper(acc));
               }
        }
    }
    
    /*******************************************************************
    Purpose: Method to retrive customer set details and set intenal params 
    Version: 1.0
    Parameters: N/A
    Returns: void
    Throws N/A
    ********************************************************************/
    private void setCustomerSetParam(){
        ACCL__Account_Set__c customerSet = [SELECT Name, ACCL__Sales_Org__c FROM ACCL__Account_Set__c WHERE id=:setId LIMIT 1]; 
        salesOrgId = customerSet.ACCL__Sales_Org__c;
        setName = customerSet.Name;
        referer = ApexPages.currentPage().getParameters().get(Params.retURL.name());
    }
    
    /*******************************************************************
    Purpose: Method to builds dynamic SOQL where clause 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws N/A
    ********************************************************************/
    private String getFilterClause(){
       //String result = ' WHERE ACCL__Sales_Org__c=:salesOrgId and UL_Customer_Hierarchy_Level__c=:'+ '\'+UL_Utility.level8 +'\'';
       //String result = ' WHERE ACCL__Sales_Org__c=:salesOrgId and UL_Customer_Hierarchy_Level__c=:ul_utility.level8';
       String result = ' WHERE ACCL__Sales_Org__c=:salesOrgId and UL_Is_Payer__c=true and UL_Customer_Hierarchy_Level__c='+'\'level 8'+'\'';
       String filterClause=UL_Utility.EMPTY_STRING;
       if(string.isNotEmpty(field1)){
         filterClause += ' UL_Customer_Group_Description__c LIKE ' + LIKE_CLAUSE_START + String.escapeSingleQuotes(field1.trim()) + LIKE_CLAUSE_END;
       }
       
       if(string.isNotEmpty(field2)){
         if(string.isNotEmpty(filterClause)){
            filterClause += FILTER_OR_CLAUSE;
         }
         filterClause += ' UL_Market_Channel_Description__c LIKE ' + LIKE_CLAUSE_START + String.escapeSingleQuotes(field2.trim()) + LIKE_CLAUSE_END;
       }
       
       if(string.isNotEmpty(field3)){
         if(string.isNotEmpty(filterClause)){
            filterClause += FILTER_OR_CLAUSE;
         }
         filterClause += ' UL_Market_Description__c LIKE ' + LIKE_CLAUSE_START + String.escapeSingleQuotes(field3.trim()) + LIKE_CLAUSE_END;
       }
       
       if(string.isNotEmpty(field4)){
         if(string.isNotEmpty(filterClause)){
            filterClause += FILTER_OR_CLAUSE;
         }
         filterClause += ' UL_Activity_Sector_Division_Description__c LIKE ' + LIKE_CLAUSE_START + String.escapeSingleQuotes(field4.trim()) + LIKE_CLAUSE_END;
       }
       
       if(string.isNotEmpty(field5)){
         if(string.isNotEmpty(filterClause)){
            filterClause += FILTER_OR_CLAUSE;
         }
         filterClause += ' UL_Territory_Description__c LIKE ' + LIKE_CLAUSE_START + String.escapeSingleQuotes(field5.trim()) + LIKE_CLAUSE_END;
       }
       
        if(string.isNotEmpty(filterClause)){
          if(isInclusive){
            filterClause = filterClause.replace(FILTER_OR_CLAUSE,'AND');
          } 
          filterClause = ' AND (' + filterClause + ')';
          isFltApplied = true;
        }
       
       result +=  filterClause + LIMIT_CLAUSE; 
       
       return result;
    }
    
    /***************************************************************
    Name: AccountSetWrapper()
    Copyright © 2015 Salesforce
    ======================================================
    Purpose:
    Wrapper class for Account object to be binded on UI grid.
    ======================================================
    History
    -------
    VERSION     AUTHOR         DATE              DETAIL            Description
    1.0         Ketan Mehta    24/10/2016        INITIAL DEV       Internal grid binding purpose.
    ***************************************************************/
    public With Sharing class AccountSetWrapper{
        public Account acc{get; set;}
        public boolean selected {get; set;}
        
        /*******************************************************************
        Purpose: Wrapper class default constructor
        Version: 1.0
        Parameters: Instance of Account object
        Returns: Void
        Throws N/A
        ********************************************************************/
        public AccountSetWrapper(Account acc) {
            this.acc= acc;
            selected = false;     
        }
      }
}