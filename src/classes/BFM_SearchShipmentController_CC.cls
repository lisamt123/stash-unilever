public with sharing class BFM_SearchShipmentController_CC{
    public ApexPages.StandardSetController con{get; set;}
    public BFM_Shipment__c searchShipment{get;set;}
    public String shipmentNumber{get;set;}
    public Date shipmentStart{get;set;}
    public String unileverCompanyAccountName{get;set;}
    public String carrierCompanyAccountName{get;set;}
    public String unileverCompanyAccountCNPJ{get;set;}
    public String vendorAccountCNPJ{get;set;}
    
    
    
    public Account unileverCompanyAccount{get;set;}
    public Account vendorAccount{get;set;}
    public string recordscount{get;set;}
    public String plantCode{get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public List<SelectOption> recordsize{get;set;}
    public BFM_Shipment__c invoiceStatement {get;set;}
    
    public BFM_SearchShipmentController_CC(ApexPages.StandardSetController controller) {
        SearchShipment = New BFM_Shipment__c();
        unileverCompanyAccount = new Account();
        vendorAccount = new Account();
        recordsize = new List<SelectOption>(); 
        recordsize.add(new SelectOption('10','10'));
        recordsize.add(new SelectOption('25','25'));
        recordsize.add(new SelectOption('50','50'));
        recordsize.add(new SelectOption('100','100'));
        recordsize.add(new SelectOption('200','200'));
        
        /*
        con = new ApexPages.StandardSetController(Database.getQueryLocator('SELECT id,name,Shipment_Number__c,Shipment_Type__c,Shipment_Start__c,Display__c,'+
                                                                         '(SELECT Name,Origin_city__c, Destination_City__c, Gross_value_from_cost_preview__c FROM Stages__r) '+
                                                                           'FROM BFM_Shipment__c LIMIT 10000'));
        */
        mySearch();
        getshipments();
    }
    
    public List<BFM_Shipment__c> shipList
    {  
        get  
        {  
            if(con != null)
                return (List<BFM_Shipment__c>)con.getRecords();                         
            else  
                return null ;             
        }  
        set;   
    }
    public void mySearch(){       
        
        String ShipmentString = 'SELECT id,name,Shipment_Number__c,Company_Code__c,Shipment_Type__c,Unilever_Company__r.name,Unilever_Company__r.CNPJ__c,Unilever_Company__r.Vendor__c,Shipment_Start__c,Display__c, '+
            ' (SELECT Name, Origin_city__c, Destination_City__c, Gross_value_from_cost_preview__c FROM Stages__r';
        if(plantCode != null){
            String strPlantCode = String.escapeSingleQuotes(plantCode);
            shipmentString += ' WHERE Origin_plant_code__c = \''+ strPlantCode +'\'' ;
        }
        shipmentString += ') FROM BFM_Shipment__c ';
                
        String searchClauses = 'WHERE';
       
        if(!String.isEmpty(shipmentNumber) && shipmentNumber!=null){
            searchClauses += ' Shipment_Number__c = :shipmentNumber AND ';
            system.debug('--->'+shipmentNumber);
        }
        if(shipmentStart!= null){
            //shipmentStart = searchShipment.Shipment_Start__c; 
            searchClauses += ' Shipment_Start__c = :shipmentStart AND ';
        }
        if(!String.isEmpty(unileverCompanyAccountName) && unileverCompanyAccountName!= null){
            //unileverCompanyAccountName = String.escapeSingleQuotes(unileverCompanyAccount.Name);
            searchClauses += ' Unilever_Company__r.Name = :unileverCompanyAccountName AND ';
        }
        if(!String.isEmpty(carrierCompanyAccountName) &&  carrierCompanyAccountName!= null){
            //carrierCompanyAccountName = String.escapeSingleQuotes(vendorAccount.Name);
            searchClauses += ' Unilever_Company__r.CNPJ__c = :carrierCompanyAccountName AND ';
        }
        if(!String.isEmpty(unileverCompanyAccountCNPJ) && unileverCompanyAccountCNPJ!= null){
            //unileverCompanyAccountCNPJ = String.escapeSingleQuotes(unileverCompanyAccount.CNPJ__c);
            searchClauses += ' Carrier_Account__r.CNPJ__c = :unileverCompanyAccountCNPJ AND ';
        }
        if(!String.isEmpty(vendorAccountCNPJ) && vendorAccountCNPJ!= null){
            //vendorAccountCNPJ = String.escapeSingleQuotes(vendorAccountCNPJ);
            searchClauses += ' Carrier_Account__r.CNPJ__c = :vendorAccountCNPJ AND ';
        }
        
        searchClauses = searchClauses.trim().removeEndIgnoreCase('AND');
        if(searchClauses == 'WHERE'){
            searchClauses = '';
        }
        
        shipmentString += searchClauses;
        shipmentString += ' ORDER BY CreatedDate ';
        // Sanitizing to avoid SOQL injection
        
        
        try{
           con = new ApexPages.StandardSetController(Database.getQueryLocator(ShipmentString));
           system.debug('ShipmentString----->'+ShipmentString);
        } catch(QueryException ex){
            String errorMessage = ex.getMessage() + ' ' + ex.getStackTraceString()+' /n \n'+shipmentString;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
            System.debug(errorMessage);
        }
        
        setPaginationSettings();
        //resetSearch();      
    }
    public pageReference redirectPage(){
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        pageRef.setRedirect(true);
        return pageRef;
    }    

    
    public void resetSearch(){
        searchShipment = new BFM_Shipment__c(); 
        unileverCompanyAccount = new Account();
        vendorAccount = new Account();
    }
    
    public void setPaginationSettings(){
        invoiceStatement = new BFM_Shipment__c();        
        statusOptions = new List<SelectOption>();
      
        Schema.DescribeFieldResult statusFieldDescription = BFM_Shipment__c.Display__c.getDescribe();
        for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues())
        {
                statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                // obtain and assign default value
                if (picklistEntry.defaultValue){
                invoiceStatement.Display__c= pickListEntry.getValue();
            }  
        }    
        // sets the number of records in each page set
                if(searchShipment.Display__c != null ){
                con.setPageSize(integer.ValueOf(searchShipment.Display__c));
        } else{
                con.setPageSize(10);
        }
    }
    
    public PageReference redirectFileUpload(){
        PageReference pr = new PageReference('/apex/BFM_Fileupload_VF');
                return pr;
    }
    
    public void getshipments(){
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