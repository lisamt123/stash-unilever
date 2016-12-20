public with sharing class BFM_SearchShipmentCTeController_dev1{
    public ApexPages.StandardSetController con{get; set;}
    public BFM_Shipment__c searchShipment{get;set;}
    public BFM_Shipment__c shipments{get;set;}
    public String shipmentNumber{get;set;}
    public Datetime shipmentStart{get;set;}
    public Date shipmentStartTo{get;set;}
    public String unileverCompanyAccountName{get;set;}
    public String carrierCompanyAccountName{get;set;}
    public String unileverCompanyAccountCNPJ{get;set;}
    public List<String> unileverCompanyAccountCNPJList=new List<String>();
    public String vendorAccountCNPJ{get;set;}
    public List<String> vendorAccountCNPJList=new List<String>();
    public id shipmentId{get;set;}
    public string shipId{get;set;}
    public List<Id> selectedShipList = new List<Id>();
    public List<shipwrapper> objAWList {get;set;}
    public List<BFM_Shipment__c> newshiplist{get;set;}
    public List<BFM_Shipment__c> selectedShipments = new List<BFM_Shipment__c>();

    public Account unileverCompanyAccount{get;set;}
    public Account vendorAccount{get;set;}
    public string recordscount{get;set;}
    public String plantCode{get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public List<SelectOption> recordsize{get;set;}
    public BFM_Shipment__c invoiceStatement {get;set;}
        
    public Report cteIssuingReport{get;set;}
    public BFM_SearchShipmentCTeController_dev1(ApexPages.StandardSetController controller) {
        //this.BFM_Shipment__c = (BFM_Shipment__c)controller.getRecord();
        objAWList = new List<shipwrapper>();
        SearchShipment = New BFM_Shipment__c();
        unileverCompanyAccount = new Account();
        vendorAccount = new Account();
        recordsize = new List<SelectOption>(); 
        recordsize.add(new SelectOption('10','10'));
        recordsize.add(new SelectOption('25','25'));
        recordsize.add(new SelectOption('50','50'));
        recordsize.add(new SelectOption('100','100'));
        recordsize.add(new SelectOption('200','200'));
        List<Report> reportsList = [SELECT Id FROM Report WHERE DeveloperName = 'Ct_e_Issuing'];
        if(reportsList.size() == 1){
            cteIssuingReport = reportsList[0];
        }
        mySearch();
        getshipments();
    }
    
    /*public List<BFM_Shipment__c> shipList
    {  
        get  
        {  
            if(con != null)  
                return (List<BFM_Shipment__c>)con.getRecords();            
            else  
                return null ;             
        }  
        set{
            system.debug('list:--->'+value);
        }
        
    }*/
    public List<shipwrapper> getShipList(){
            for(BFM_Shipment__c a: [SELECT id,name,Shipment_Number__c,Last_Shipment_Update__c,Shipment_Type__c,Display__c from BFM_Shipment__c order by Name]) {               
                objAWList.add(new shipwrapper(a));                                       
            }
            system.debug('objAWList-->'+objAWList);
            return objAWList;       
    } 
    public void mySearch(){       
        
        String ShipmentString = 'SELECT id,name,Shipment_Number__c,Last_Shipment_Update__c,Shipment_Type__c,Display__c, '+
            ' (SELECT Name, Origin_city__c, Destination_City__c, Gross_value_from_cost_preview__c FROM Stages__r';
        if(plantCode != null){
            String strPlantCode = String.escapeSingleQuotes(plantCode);
            shipmentString += ' WHERE Origin_plant_code__c = \''+ strPlantCode +'\'' ;
        }
        shipmentString += ') FROM BFM_Shipment__c ';
        
        String searchClauses = 'WHERE';
        
        System.debug('shipmentNumber ' + shipmentNumber);
        if(!String.isEmpty(shipmentNumber)){
            //shipmentNumber = String.escapeSingleQuotes(searchShipment.shipment_Number__c);
            String val = '\'%' + String.escapeSingleQuotes(shipmentNumber.trim()) + '%\'';
            searchClauses += ' Shipment_Number__c LIKE ' + val + ' AND ';
        }
        if(shipmentStart != null){
            //shipmentStart = searchShipment.Shipment_Start__c; 
            //searchClauses += ' Shipment_Start__c >:shipmentStart AND Shipment_Start__c <:shipmentStartTo AND ';
        } else{ 
            System.debug ('shipmentStart wanst null, was ' +shipmentStart);
        }
        /*
        if(!String.isEmpty(unileverCompanyAccountName) ){
            //unileverCompanyAccountName = String.escapeSingleQuotes(unileverCompanyAccount.Name);
            searchClauses += ' Unilever_Company__r.Name = :unileverCompanyAccountName AND ';
        }*/
        if(!String.isEmpty(carrierCompanyAccountName)){
            //carrierCompanyAccountName = String.escapeSingleQuotes(vendorAccount.Name);
            //searchClauses += ' Carrier_Account__r.Name = :carrierCompanyAccountName AND ';
            String val1 = '\'%' + String.escapeSingleQuotes(carrierCompanyAccountName.trim()) + '%\'';
            searchClauses += ' Carrier_Account__r.Name LIKE ' + val1 + ' AND ';
        }
        if(!String.isEmpty(unileverCompanyAccountCNPJ)){
            //unileverCompanyAccountCNPJ = String.escapeSingleQuotes(unileverCompanyAccount.CNPJ__c);
            //searchClauses += ' Unilever_Company__r.Name = :unileverCompanyAccountCNPJ AND ';
            //String val2 = String.escapeSingleQuotes(unileverCompanyAccountCNPJ.trim());
            for(string str:unileverCompanyAccountCNPJ.split(',')){
            string str2= '\''+String.escapeSingleQuotes(str.trim())+'\'' ;
            unileverCompanyAccountCNPJList.add(str2);
                }
            searchClauses += ' Unilever_Company__r.Name IN ' + unileverCompanyAccountCNPJList + ' AND ';
        }
        if(!String.isEmpty(vendorAccountCNPJ)){
            //vendorAccountCNPJ = String.escapeSingleQuotes(vendorAccountCNPJ);
            //String val3 = String.escapeSingleQuotes(vendorAccountCNPJ.trim());
            for(string str:vendorAccountCNPJ.split(',')){
                string str3= '\''+String.escapeSingleQuotes(str.trim())+'\'' ;
            vendorAccountCNPJList.add(str3);
                }
            searchClauses += ' Carrier_Account__r.CNPJ__c IN ' + vendorAccountCNPJList + ' AND ';
        }
        
        searchClauses = searchClauses.trim().removeEndIgnoreCase('AND');
        if(searchClauses == 'WHERE'){
            searchClauses = '';
        }
        
        shipmentString += searchClauses;
        shipmentString += ' ORDER BY CreatedDate ';
        // Sanitizing to avoid SOQL injection
        
        system.debug('ShipmentString----->'+ShipmentString);
        try{
            System.debug('shipments queried ' + database.query(shipmentString));
            con = new ApexPages.StandardSetController(Database.getQueryLocator(ShipmentString));
        } catch(QueryException ex){
            String errorMessage = ex.getMessage() + ' ' + ex.getStackTraceString()+' /n \n'+shipmentString;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
            System.debug(errorMessage);
        }
        
        setPaginationSettings();
        //resetSearch();      
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
    
    public PageReference updateship(){
     Set<Id> ssIds = new Set<Id>();
     for(shipwrapper shwrap : objAWList)
        {
            if(shwrap.selected == true)
            {
                ssIds.add(shwrap.ships.Id);
            }
        }
        system.debug('ssids---->'+ssIds);
        
        /*for(Id ac:selectedShipList)
        {
            ssIds.add(ac);
        }*/
        Id batchJobId = Database.executeBatch(new BFM_BulkShipmentQuery(ssIds), 200);

        system.debug('ssIdssssssssssssssssss--->'+ssIds);
        PageReference pageRef = new PageReference('/apex/BFM_SearchShipmentCTe_VF');
        pageRef.setRedirect(true);
        return pageRef;
   
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
    public Map<Id, boolean> hasCte{get;set;}
    
  /* public Map<String, List<BFM_NFS__c>> nfsByShipment{
        get{
            
            nfsByShipment = new Map<String, List<BFM_NFS__c>>();
            List<BFM_SES__c> theSES = [SELECT NFS__c, Stage__r.Shipment__c FROM BFM_SES__c WHERE Stage__r.Shipment__c IN: shiplist];
            Set<Id> idsNFS = new Set<ID>();
            for(BFM_SES__c ses: theSES){
                idsNFS.add(ses.NFS__c);
            }
            Map<Id, BFM_NFS__c> nfss = new Map<Id, BFM_NFS__c>([SELECT Id, Name FROM BFM_NFS__c WHERE Id IN: idsNFS]);
            Map<String, List<BFM_NFS__c>> returnMap = new Map<String, List<BFM_NFS__c>>();
            for(BFM_SES__c ses : theSES){
                if(!nfsByShipment.containsKey(ses.stage__r.shipment__c)){
                    nfsByShipment.put(ses.stage__r.shipment__c, new List<BFM_NFS__c>());
                }
                BFM_NFS__c relatedNFS = nfss.get(ses.NFS__c);
                nfsByShipment.get(ses.stage__r.shipment__c).add(relatedNFS);
            }
            for(BFM_Shipment__c shipment: this.newshiplist ){
                if(!nfsByShipment.containsKey(shipment.Id)){
                    nfsByShipment.put(shipment.Id,new List<BFM_NFS__c>());
                }
            }
            
            return nfsByShipment;
        } set;
    }
    
    public Map<String, List<BFM_CT_e__c>> ctesByShipment{
        get{
                ctesByShipment = new Map<String, List<BFM_CT_e__c>>();
                List<BFM_SES__c> theSESs = [SELECT CT_e__c, Stage__r.Shipment__c FROM BFM_SES__c WHERE Stage__r.Shipment__c IN: newshiplist];
                Set<Id> idsCtes = new Set<Id>();
                for(BFM_SES__c ses : theSESs){
                    idsCtes.add(ses.CT_e__c);
                }
                Map<Id, BFM_CT_e__c> ctes = new Map<Id, BFM_CT_e__c>([SELECT Id, Name FROM BFM_CT_e__c WHERE Id IN: idsCtes]);
                Map<String, List<BFM_CT_e__c>> returnMap = new Map<String, List<BFM_CT_e__c>>();
                for(BFM_SES__c ses : theSESs){
                    if(!ctesByShipment.containsKey(ses.stage__r.shipment__c)){
                        ctesByShipment.put(ses.stage__r.shipment__c, new List<BFM_CT_e__c>());
                    }
                    BFM_CT_e__c relatedCTe = ctes.get(ses.CT_e__c);
                    ctesByShipment.get(ses.stage__r.shipment__c).add(relatedCTe);
                }
                for(BFM_Shipment__c shipment: this.newshiplist ){
                    System.debug('shipment Id on shiplist' + shipment.Id);
                    if(!ctesByShipment.containsKey(shipment.Id)){
                        ctesByShipment.put(shipment.Id,new List<BFM_CT_e__c>());
                    }
                }
            return ctesByShipment;        
             
        }set;
    }*/
    
    public class shipwrapper
    {
        public BFM_Shipment__c ships{get; set;}
        public Boolean selected {get; set;}
        public shipwrapper(BFM_Shipment__c s)
        {
            ships = s;
            selected = false;
        }
    }
    
}