Public Class BFM_searchOriginPlantCode{

public BFM_Shipment__c searchShipment{get;set;}
    public ApexPages.StandardSetController con{get; set;}
    public BFM_Shipment__c shipments{get;set;}
    public String shipmentNumber{get;set;}
    public Date shipmentStart{get;set;}
    public Date shipmentStartTo{get;set;}
    public String unileverCompanyAccountName{get;set;}
    public String carrierCompanyAccountName{get;set;}
    public String unileverCompanyAccountCNPJ{get;set;}
    public String vendorAccountCNPJ{get;set;}
    public id shipmentId{get;set;}
    public string shipId{get;set;}
    public List<Id> selectedShipList = new List<Id>();
    public string StageString;
    public Account unileverCompanyAccount{get;set;}
    public Account vendorAccount{get;set;}
    public string recordscount{get;set;}
    public String plantCode{get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public List<SelectOption> recordsize{get;set;}
    public BFM_Shipment__c invoiceStatement {get;set;}
    public string stagePlantCode;

public void searchOriginPlantCode(string plantCode){       
        
        String StageString = 'SELECT id,Shipment__r.name,Shipment__r.Shipment_Number__c,Shipment__r.Last_Shipment_Update__c,Shipment__r.Shipment_Type__c,Shipment__r.Shipment_Start__c,Shipment__r.Display__c ';
            
        StageString += ' FROM BFM_Stage__c ';
        
        String searchClauses = 'WHERE';
        
         this.stagePlantCode= plantCode;
        
        if(!String.isEmpty(plantCode)){
            //shipmentNumber = String.escapeSingleQuotes(searchShipment.shipment_Number__c);
            String val = String.escapeSingleQuotes(stagePlantCode.trim());
            searchClauses += ' Origin_plant_code__c =: ' + val + ' AND ';
        }
        
        if(!String.isEmpty(shipmentNumber)){
            //shipmentNumber = String.escapeSingleQuotes(searchShipment.shipment_Number__c);
            String val = '\'%' + String.escapeSingleQuotes(shipmentNumber.trim()) + '%\'';
            searchClauses += ' Shipment__r.Shipment_Number__c LIKE ' + val + ' AND ';
        }
        if(shipmentStart != null){
            //shipmentStart = searchShipment.Shipment_Start__c; 
            searchClauses += ' Shipment__r.Shipment_Start__c >:shipmentStart AND Shipment__r.Shipment_Start__c <:shipmentStartTo AND ';
        } else{ 
            System.debug ('shipmentStart wanst null, was ' +shipmentStart);
        }
        /*
        if(!String.isEmpty(unileverCompanyAccountName) ){
            //unileverCompanyAccountName = String.escapeSingleQuotes(unileverCompanyAccount.Name);
            searchClauses += ' Shipment__r.Unilever_Company__r.Name = :unileverCompanyAccountName AND ';
        }*/
        if(!String.isEmpty(carrierCompanyAccountName)){
            //carrierCompanyAccountName = String.escapeSingleQuotes(vendorAccount.Name);
            //searchClauses += ' Shipment__r.Carrier_Account__r.Name = :carrierCompanyAccountName AND ';
            String val1 = '\'%' + String.escapeSingleQuotes(carrierCompanyAccountName.trim()) + '%\'';
            searchClauses += ' Shipment__r.Carrier_Account__r.Name LIKE ' + val1 + ' AND ';
        }
        if(!String.isEmpty(unileverCompanyAccountCNPJ)){
            //unileverCompanyAccountCNPJ = String.escapeSingleQuotes(unileverCompanyAccount.CNPJ__c);
            //searchClauses += ' Unilever_Company__r.Name = :unileverCompanyAccountCNPJ AND ';
            String val2 = '\'%' + String.escapeSingleQuotes(unileverCompanyAccountCNPJ.trim()) + '%\'';
            searchClauses += ' Shipment__r.Unilever_Company__r.Name LIKE ' + val2 + ' AND ';
        }
        if(!String.isEmpty(vendorAccountCNPJ)){
            vendorAccountCNPJ = String.escapeSingleQuotes(vendorAccountCNPJ);
            String val3 = '\'%' + String.escapeSingleQuotes(vendorAccountCNPJ.trim()) + '%\'';
            searchClauses += ' Shipment__r.Carrier_Account__r.CNPJ__c Like ' + val3 + ' AND ';
        }
        
        searchClauses = searchClauses.trim().removeEndIgnoreCase('AND');
        if(searchClauses == 'WHERE'){
            searchClauses = '';
        }
        
        StageString += searchClauses;
        StageString += ' ORDER BY CreatedDate ';
        // Sanitizing to avoid SOQL injection
        
        system.debug('StageString----->'+StageString);
        try{
            //System.debug('stage queried ' + database.query(StageString));
            con = new ApexPages.StandardSetController(Database.getQueryLocator(StageString));
        } catch(QueryException ex){
            String errorMessage = ex.getMessage() + ' ' + ex.getStackTraceString()+' /n \n'+StageString;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
            System.debug(errorMessage);
        }
        
        //setPaginationSettings();
        //resetSearch();      
    }

}