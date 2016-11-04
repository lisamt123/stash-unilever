public With Sharing class UL_AddNewCustomer{
    public List<AccountSetWrapper> customerList {get; set;}
    public List<ACSFUL001__Account_Set_Account__c> selectedCustomer {get; set;}
    
    //Field for search criteria
    public String field1 {get;set;}
    public String field2 {get;set;}
    public String field3 {get;set;}
    public Boolean isInclusive {get;set;}
    public Boolean isFltApplied {get;set;}
    
    private final Id setId {get;set;}
    private final String salesOrgId {get;set;}
    private final String referer{get;set;}
    public final String setName {get;set;}
    
    private final Integer DATA_SIZE = 900;
    //Default constructor
    public UL_AddNewCustomer(){
        setId = ApexPages.currentPage().getParameters().get('setId');
        salesOrgId = ApexPages.currentPage().getParameters().get('orgId');
        referer = ApexPages.currentPage().getParameters().get('referer');
        setName = ApexPages.currentPage().getParameters().get('setName');
        isInclusive = false;
        isFltApplied=false;
        
    }
    
    //Method called in page load event
    public PageReference doPageLoad(){
      getResultSet();
      return null;
    }
    
    //Method called on 'Search' button click event
    public PageReference doSearch(){
      if(string.isEmpty(field1) && string.isEmpty(field2) && string.isEmpty(field3)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter at least one search criteria'));
            
      }else{
          getResultSet();
      }
      return null;
    }
    
    //Method called on 'Clear Filter' button click event
    public PageReference doClearFilter(){
       field1=null;
       field2=null;
       field3=null;
       isFltApplied = false;
       getResultSet();
       return null;
    }
    
    //Method to list out all available records.
    private void getResultSet(){
        customerList = new List<AccountSetWrapper>();
        String searchQuery = 'Select Id, Name, UL_Customer_Group_Description__c, UL_Market_Channel_Description__c,UL_Market_Description__c from Account ' + getFilterClause();
        
        List<sObject> sobjList = Database.query(searchQuery);
        
        if(!sobjList.isEmpty()){
        Account tempAccount;
        Map<Id, Account> accMap = new Map<Id, Account>();
           for(sObject obj: sobjList){
               tempAccount = (Account)obj;
               accMap.put(tempAccount.id, tempAccount);            
           }
           
           //Filter out existing Account(s) in junction object
           List<ACSFUL001__Account_Set_Account__c> accSetList = [Select ACSFUL001__Account__c from ACSFUL001__Account_Set_Account__c where ACSFUL001__Account__c in :accMap.keySet() AND ACSFUL001__Account_Set__c=:setId];
           if(accSetList.size() > 0){
             for(ACSFUL001__Account_Set_Account__c accSet:accSetList){
               accMap.remove(accSet.ACSFUL001__Account__c);
             } 
           }
           
           //Create wrapper object list
           for(Account acc: accMap.values()){
            customerList.add(new AccountSetWrapper(acc));
           }
        }
    }
    
    //Method called on 'Save' button click event
    public PageReference submit(){
        if(setId != null){
            selectedCustomer = new List<ACSFUL001__Account_Set_Account__c>();
            for (AccountSetWrapper customer: customerList) {
                if (customer.selected == true) {
                    ACSFUL001__Account_Set_Account__c  accSet = new ACSFUL001__Account_Set_Account__c();
                    accSet.ACSFUL001__Account__c =  customer.acc.id;
                    accSet.ACSFUL001__Account_Set__c  = setId;          
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
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select record(s) to proceed.'));
             return null;
            }
        }
        
        return backToParent();
    }
    
    //Method called on 'Back' button click event
    public PageReference backToParent(){
        PageReference pageRef = new PageReference('/'+referer);
        pageRef.setRedirect(true);
        return pageRef;
    }

    //Internal method - builds SOQL where clause 
    private String getFilterClause(){
       String result = ' where ACSFUL001__Sales_Org__c=:salesOrgId';
       String filterClause='';
       if(string.isNotEmpty(field1)){
         filterClause += ' UL_Customer_Group_Description__c LIKE ' + '\'%' + String.escapeSingleQuotes(field1.trim()) + '%\' ';
       }
       
       if(string.isNotEmpty(field2)){
         if(string.isNotEmpty(filterClause)){
            filterClause += ' OR ';
         }
         filterClause += ' UL_Market_Channel_Description__c LIKE ' + '\'%' + String.escapeSingleQuotes(field2.trim()) + '%\' ';
       }
       
       if(string.isNotEmpty(field3)){
         if(string.isNotEmpty(filterClause)){
            filterClause += ' OR ';
         }
         filterClause += ' UL_Market_Description__c LIKE ' + '\'%' + String.escapeSingleQuotes(field3.trim()) + '%\' ';
       }
       
        if(string.isNotEmpty(filterClause)){
          if(isInclusive){
            filterClause = filterClause.replace('OR','AND');
          } 
          filterClause = ' AND (' + filterClause + ')';
          isFltApplied = true;
        }
       
       result +=  filterClause + '  LIMIT '+ DATA_SIZE; 
       
       return result;
    }
    
    
    //Wrapper class for Account object to be binded on UI
    public class AccountSetWrapper{
        public Account acc{get; set;}
        public boolean selected {get; set;}
    
        public AccountSetWrapper(Account acc) {
            this.acc= acc;
            selected = false;     
        }
      }
}