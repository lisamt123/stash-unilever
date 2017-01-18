public with sharing class BFM_CTeSearch_CC {
    public ApexPages.StandardSetController con{get; set;}
    public List<String> listctes;
    public BFM_CT_e__c ctesearch{get;set;}
    public string ctename{get;set;}
    public string ctenumber{get;set;}
    public string cnpjservice{get;set;}
    public string cnpjemissor{get;set;}
    public string plant{get;set;}
    public string ctekey{get;set;}
    public string suppliercode{get;set;}
    public Date cteemistart{get;set;}
    public Date cteemito{get;set;}
    public Date ctecrdatestart{get;set;}
    public Date ctecrdateto{get;set;}
    public List<SelectOption> recordsize{get;set;}
    public string recordscount{get;set;}
    public string cteid{get;set;}
public BFM_CTeSearch_CC(ApexPages.StandardSetController controller){
    ctesearch = New BFM_CT_e__c();
    recordsize = new List<SelectOption>(); 
    recordsize.add(new SelectOption('10','10'));
    recordsize.add(new SelectOption('25','25'));
    recordsize.add(new SelectOption('50','50'));
    recordsize.add(new SelectOption('100','100'));
    recordsize.add(new SelectOption('200','200'));
    searchctes();
    getctes();
    } 
public List<BFM_CT_e__c> ctelist
    {  
        get  
        {  
            if(con != null)  
            {
                system.debug('recordCount if:'+(List<BFM_CT_e__c>)con.getRecords());
                return (List<BFM_CT_e__c>)con.getRecords();  
            }
            else
            {
                system.debug('recordCount else:'+con);	
                return null ;  
            }
        }  
        set;
    }
    

public void searchctes(){
    listctes = new List<String>();
    if(ctelist != null && !ctelist.isEmpty()){
        ctelist = null;
        }
        system.debug('value is==>'+ctekey);

         String strQuery ='SELECT id, Name, CNPJ_issuer__c,Cte_Status__c, Is_CNPJ_Valid__c,Link_Status__c,Sefaz_Check_Status__c,Is_Not_Duplicated__c,CNPJ_Service_Taker__c, CT_e_key__c, CT_e_Number__c, Unilever_company_code__c,'+
         'Cte_Emission_date_time__c, CreatedDate from BFM_CT_e__c  ';
    
         String searchClauses = 'WHERE'; 
        system.debug('ctename--->'+ctename);
         if(!String.isEmpty(ctename)){            
            String val1 = '\'%' + String.escapeSingleQuotes(ctename.trim()) + '%\'';
            searchClauses += ' Name LIKE ' + val1 + ' AND ';
        }
        system.debug('ctename--->'+ctenumber);
        if(!String.isEmpty(ctenumber)){
            for(string str:ctenumber.split(',')){
                string ctenameSplit= '\'' + String.escapeSingleQuotes(str.trim())+ '\'' ;
                listctes.add(ctenameSplit);
            }
            searchClauses += ' CT_e_Number__c IN ' + listctes + ' AND ';         
        }
        system.debug('serviceCNPJ--->'+cnpjservice);
        if(!String.isEmpty(cnpjservice)){
            String val1 = '\'%' + String.escapeSingleQuotes(cnpjservice.trim()) + '%\'';
            searchClauses += ' CNPJ_Service_Taker__c Like ' + val1 + ' AND ';
        }
        system.debug('ctename--->'+cnpjemissor);
        if(!String.isEmpty(cnpjemissor)){            
            String val1 = '\'%' + String.escapeSingleQuotes(cnpjemissor.trim()) + '%\'';
            searchClauses += ' CNPJ_issuer__c LIKE ' + val1 + ' AND ';
        }
       system.debug('ctename--->'+plant);
        if(String.isNotEmpty(plant)){
            String val1 = '\'%' + String.escapeSingleQuotes(plant.trim()) + '%\'';
            searchClauses += ' Plant_Code__c LIKE ' + val1 + ' AND ';            
        }
        system.debug('keycte--->'+ctekey);
        if(String.isNotEmpty(ctekey)){
            String val1 = '\'%' + String.escapeSingleQuotes(ctekey.trim()) + '%\'';
            searchClauses += ' CT_e_key__c LIKE ' + val1 + ' AND ';
        }
        system.debug('suplier code--->'+suppliercode);
        if(String.isNotEmpty(suppliercode)){
            String val1 = '\'%' + String.escapeSingleQuotes(suppliercode.trim()) + '%\'';
            searchClauses += ' Random_Number__c LIKE ' + val1 + ' AND ';
        }
    
        system.debug('cteemistart===>'+cteemistart);
    	system.debug('cteemito===>'+cteemito);
        if(cteemistart!=null){
            searchClauses += ' Cte_Emission_date_time__c >=:cteemistart AND Cte_Emission_date_time__c <=:cteemito AND ';
            system.debug('datetimeclauses===>'+searchClauses);            
        }
    	
		system.debug('===>'+ctecrdatestart);
        if(ctecrdatestart!=null){
            searchClauses += ' Cte_Emission_date_time__c >=:ctecrdatestart AND Cte_Emission_date_time__c <=:ctecrdateto AND ';            
        }
        
        searchClauses = searchClauses.trim().removeEndIgnoreCase('AND');    
        if(searchClauses == 'WHERE'){
            searchClauses = '  ';
        }
        
        strQuery += searchClauses;
        strQuery += ' ORDER BY CreatedDate LIMIT 10000';
   
        try{
            system.debug('occ string is '+strQuery);
       // OccList = Database.Query(OccurenceString);
       con = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery));

        }catch(QueryException ex){
            String errorMessage = ex.getMessage() + ' ' + ex.getStackTraceString()+' /n \n'+strQuery;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
            system.debug(errorMessage);
            } 
        
        con.setPageSize(10);
        }
    public pageReference redirectPage(){
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public void getctes(){
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
       
}