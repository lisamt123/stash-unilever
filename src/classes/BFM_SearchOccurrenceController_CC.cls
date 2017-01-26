public with sharing class BFM_SearchOccurrenceController_CC{
    public ApexPages.StandardSetController con{get; set;}
    public BFM_Occurrence__c searchOccurrence{get;set;}
    public List<String> OccurrencesList ;
    List<string> conditions = new List<string>();
    
    public String occurNumber{get;set;}
    public String occCarrierVendor{get;set;}
    public String occStatus{get;set;}
    public String occCarrierAccount{get;set;}
    public String occurCode{get;set;}
    public String occFromAccount{get;set;}
        
    public String vendorName{get;set;}
    public Date occurStart{get;set;}
    public Date occurTo{get;set;}   
    public Boolean secondBlock{get;set;} 
    public string recordscount{get;set;}
    public List<SelectOption> recordsize{get;set;}
    public string occrid;
    public Report cteIssuingReport{get;set;}
    public BFM_SearchOccurrenceController_CC(ApexPages.StandardSetController controller) {
        //occrid = ApexPages.currentPage().getParameters().get('Id');
        searchOccurrence = New BFM_Occurrence__c();
        recordsize = new List<SelectOption>(); 
        recordsize.add(new SelectOption('10','10'));
        recordsize.add(new SelectOption('25','25'));
        recordsize.add(new SelectOption('50','50'));
        recordsize.add(new SelectOption('100','100'));
        recordsize.add(new SelectOption('200','200')); 
            List<Report> reportsList = [SELECT Id FROM Report WHERE DeveloperName = 'BFM_Ct_e_Issuing_Occurrence'];
        if(reportsList.size() == 1){
            cteIssuingReport = reportsList[0];
        }
        searchoccurs();
         getoccurences();
    }
    
    public List<BFM_Occurrence__c> OccList
    {  
        get  
        {  
            if(con != null)  
                return (List<BFM_Occurrence__c>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }
    

    public void searchoccurs(){
        OccurrencesList = new List<String>();
    if(OccList != null && !OccList.isEmpty()){
        OccList = null;
        }
        conditions.clear();
        system.debug('value is'+occurNumber+'dd'+occurStart);
        

       
        String OccurenceString = 'SELECT id,name,Occurrence_Number__c,Created_date__c,Carrier_Vendor_Code__c,Status__c,Carrier_Account__r.Name,Carrier_Account__r.BFM_CNPJ__c,Occurrence_Code__c,Range_of_Extent_of_Occurrence_From__c,Range_of_Extent_of_Occurrence_To__c,Last_Occurrence_Update__c  FROM BFM_Occurrence__c ';
        String searchClauses = 'WHERE'; 
        
        if(!String.isEmpty(occurNumber)){
            for(string str:occurNumber.split(',')){
                string occNumberSplit= '\''+String.escapeSingleQuotes(str.trim())+'\'' ;
                OccurrencesList.add(occNumberSplit);
            }
            searchClauses += ' Occurrence_Number__c IN ' + OccurrencesList + ' AND ';         
        }
        
        if(String.isNotEmpty(occCarrierVendor)){
            searchClauses += ' Carrier_Vendor_Code__c Like \'%' + occCarrierVendor + '%\' AND ';
        }
        
        if(String.isNotEmpty(occStatus)){
            searchClauses += ' Status__c Like \'%' + occStatus + '%\' AND ';
        }
        
        if(!String.isEmpty(occCarrierAccount)){            
            String val1 = '\'%' + String.escapeSingleQuotes(occCarrierAccount.trim()) + '%\'';
            searchClauses += ' Carrier_Account__r.Name LIKE ' + val1 + ' AND ';
        }
        
        if(String.isNotEmpty(occurCode)){
            searchClauses += ' Occurrence_Code__c Like \'%' + occurCode + '%\' AND ';            
        }
        
        if(String.isNotEmpty(occFromAccount)){
            searchClauses += ' Carrier_Account__r.BFM_CNPJ__c Like \'%' +occFromAccount +'%\' AND ';
        }
        system.debug('===>'+occurStart);
        if(occurStart!=null){
			searchClauses += ' Created_date__c >:occurStart AND Created_date__c <:occurTo AND ';            
        }
        
        searchClauses = searchClauses.trim().removeEndIgnoreCase('AND');
    
        if(searchClauses == 'WHERE'){
            searchClauses = '  ';
        }
        
        OccurenceString += searchClauses;
        OccurenceString += ' ORDER BY CreatedDate LIMIT 10000';
        /*
        system.debug('conditions:'+conditions);
        
        if (conditions.size() > 0) {
        OccurenceString += '  WHERE ' + conditions[0];
        for (Integer i = 1; i < conditions.size(); i++)
            OccurenceString += '  AND ' + conditions[i];
        }
        OccurenceString += ' ORDER BY CreatedDate';
		*/
        try{
            system.debug('occ string is '+OccurenceString);
       // OccList = Database.Query(OccurenceString);
       con = new ApexPages.StandardSetController(Database.getQueryLocator(OccurenceString));

        }catch(QueryException ex){
            String errorMessage = ex.getMessage() + ' ' + ex.getStackTraceString()+' /n \n'+OccurenceString;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
            }         
        con.setPageSize(10);
        }
    public pageReference redirectPage(){
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void getoccurences(){
        if(recordscount=='10'){
            con.setPageSize(10);   
        }
        else if(recordscount=='25'){
            con.setPageSize(25);   
        }
        else if(recordscount=='50'){
            con.setPageSize(50);   
        }
        else if(recordscount=='100'){
            con.setPageSize(100);   
        }
        else if(recordscount=='200'){
            con.setPageSize(200);   
        }
    }
    // returns the first page of records
    public void first() {
        con.first();
    }
    
    // returns the last page of records
    public void last() {
        con.last();
    }
    
    // returns the previous page of records
    public void previous() {
        con.previous();
    }
    
    // returns the next page of records
    public void next() {
        con.next();
    }
    
    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        con.cancel();
    }
    public Boolean hasNext  
    {  
        get  
        {  
            return con.getHasNext();  
        }  
        set;  
    }  
    public Boolean hasPrevious  
    {  
        get  
        {  
            return con.getHasPrevious();  
        }  
        set;  
    }  
    
    @RemoteAction
    public static List<String> updateOccurences(String occIds) {
        Set<Id> ssIds = new Set<Id>();
         List<String> lstUrls=new List<String>();
    lstUrls.addAll(occIds.split(','));
        //system.debug('lstUrls'+lstUrls);
        for(String str:lstUrls)
        {
          //system.debug('str'+str);
            ssIds.add(Id.valueOf(str));   
        }
        system.debug('ssIds'+ssIds);
        Id batchJobId = Database.executeBatch(new BFM_BulkOccurrenceQuery(ssIds), 200);

        //system.debug('shipmentParamValue--->'+ssIds);
        return lstUrls; 
    }
}