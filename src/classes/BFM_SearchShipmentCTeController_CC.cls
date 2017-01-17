public with sharing class BFM_SearchShipmentCTeController_CC{
    public ApexPages.StandardSetController con{get; set;}
    public BFM_Shipment__c searchShipment{get;set;}
    public BFM_Shipment__c shipments{get;set;}
    public List<String> vendorAccountCNPJList=new List<String>();
    public List<String> unileverCompanyAccountCNPJList=new List<String>();
    public List<String> shipmentNumberList ;
    public List<String> plantCodeList = new List<String>();
    public String shipmentNumber{get;set;}
    public Date shipcrdate{get;set;}
    public Date shipcrdateupto{get;set;}
    public Date shipstart{get;set;}
    public Date shipsrtupto{get;set;}
    public Date pricingDateStart{get;set;}
    public Date pricingDateupto{get;set;}
    public String unileverCompanyAccountName{get;set;}
    public List<String> carriervendorList ;
    public string carrieraccvendor{get;set;}
    public string carrieracc{get;set;}
    public String shipCarrierAccount{get;set;}
    public String shpmnttype{get;set;}
    public String shipFromAccount{get;set;}
    public string stageplantcode{get;set;}
    public String carrierCompanyAccountName{get;set;}
    public String unileverCompanyAccountCNPJ{get;set;}
    public String vendorAccountCNPJ{get;set;}
    public id shipmentId{get;set;}
    public string shipId{get;set;}
    public List<Id> selectedShipList = new List<Id>();
    List<accountwrapper> shipWrapperList = new List<accountwrapper>();
    public String profile {get;set;}
    
    public Account unileverCompanyAccount{get;set;}
    public Account vendorAccount{get;set;}
    public string recordscount{get;set;}
    public String plantCode{get;set;}
    public List<SelectOption> statusOptions {get;set;}
    public List<SelectOption> recordsize{get;set;}
    public BFM_Shipment__c invoiceStatement {get;set;}
    
    public Report cteIssuingReport{get;set;}
    public BFM_SearchShipmentCTeController_CC(ApexPages.StandardSetController controller) {
        Profile profileName = [SELECT name from Profile where Id =: UserInfo.getProfileId()];
        profile = profileName.name;
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
    
    public List<BFM_Shipment__c> shipList{  
        get  {  
            if(con != null)  
            {
                system.debug('Inside if condition');
                system.debug('Con data:'+(List<BFM_Shipment__c>)con.getRecords());
                return (List<BFM_Shipment__c>)con.getRecords();            
            }
            else  
            {
                system.debug('Inside else condition');
                return null ;             
            }
                
        }  
        
        set;
    }
    
    public void mySearch(){       
        shipmentNumberList =  new List<String>();
        carriervendorList = new List<string>();
        if(shipList != null && !shipList.isEmpty()){
        shipList = null;
        }
        system.debug('===>shipcrdate'+shipcrdate+'shipstdate==>'+shipstart+'plantcode'+stageplantcode+'shipCarrierAccount'+shipCarrierAccount);
        
        String ShipmentString = 'SELECT id,name,Pricing_Calculation_Date__c,Created_Date__c,Carrier_Account__r.Name,Shipment_Number__c,Carrier_Account_Vendor_Code__c,Last_Shipment_Update__c,Shipment_Status__c,Shipment_Start__c,Display__c, Carrier_Account__c,(select Origin_plant_code__c from Stages__r ) ' +
        ' FROM BFM_Shipment__c ';
        
        String searchClauses = 'WHERE '; 

        if(!String.isEmpty(shipmentNumber)) {
            for(string str:shipmentNumber.split(',')){
                string shipmentNumberSplit= '\''+String.escapeSingleQuotes(str.trim())+'\'' ;
                shipmentNumberList.add(shipmentNumberSplit);
            }
            searchClauses += ' Shipment_Number__c IN ' + shipmentNumberList + ' AND ';
        }
        
        if(!String.isEmpty(carrieraccvendor)) {
            for(string str:carrieraccvendor.split(',')){
                string carervendorSplit= '\''+String.escapeSingleQuotes(str.trim())+'\'' ;
                carriervendorList.add(carervendorSplit);
            }
            searchClauses += ' Carrier_Account_Vendor_Code__c IN ' + carriervendorList + ' AND ';
        }
        system.debug('plant===>'+shipCarrierAccount);
        if(!String.isEmpty(shipCarrierAccount)){            
            String val1 = '\'%' + String.escapeSingleQuotes(shipCarrierAccount.trim()) + '%\'';
            searchClauses += ' Carrier_Account__r.Name LIKE ' + val1 + ' AND ';
        }
        
        if(!String.isEmpty(shpmnttype)){            
            String val1 = '\'%' + String.escapeSingleQuotes(shpmnttype.trim()) + '%\'';
            searchClauses += ' Shipment_Type__c LIKE ' + val1 + ' AND ';
        }
        if(String.isNotEmpty(shipFromAccount)){
            String val1 = '\'%' + String.escapeSingleQuotes(shipFromAccount.trim()) + '%\'';
            searchClauses += ' Carrier_Account__r.CNPJ__c LIKE ' +val1 + ' AND ';
        }
        system.debug('plant===>'+stageplantcode);
        if(String.isNotEmpty(stageplantcode)){
            String val1 = '\'%' + String.escapeSingleQuotes(stageplantcode.trim()) + '%\'';
            searchClauses += ' Stages__r.Origin_plant_code__c LIKE ' + val1 + ' AND ';
        }
         
        system.debug('===>'+shipcrdate);
        if(shipcrdate!= null){
            searchClauses += ' Created_Date__c >=:shipcrdate AND Created_Date__c <=:shipcrdateupto AND ';
        }
        
        system.debug('===>'+shipstart);
        if(shipstart!= null){
            searchClauses += ' Shipment_Start__c >=:shipstart AND Shipment_Start__c <=:shipsrtupto AND ';
        }
        if(pricingDateStart!= null){
            searchClauses += ' Pricing_Calculation_Date__c >=:pricingDateStart AND Pricing_Calculation_Date__c <=:pricingDateupto AND ';
        }
        searchClauses = searchClauses.trim().removeEndIgnoreCase('AND');
        if(searchClauses == 'WHERE'){
            searchClauses = '  ';
        }
        
        shipmentString += searchClauses;
        shipmentString += 'ORDER BY CreatedDate LIMIT 10000';
        // Sanitizing to avoid SOQL injection
        
        try{
            system.debug('ship str is==> '+ShipmentString);
            con = new ApexPages.StandardSetController(Database.getQueryLocator(ShipmentString));
        } catch(QueryException ex){
            String errorMessage = ex.getMessage() + ' ' + ex.getStackTraceString()+' /n \n'+shipmentString;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
            system.debug(errorMessage);
        }        
        setPaginationSettings();
    }
    
    public void setPaginationSettings(){
        invoiceStatement = new BFM_Shipment__c();        
        statusOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult statusFieldDescription = BFM_Shipment__c.Display__c.getDescribe();
        for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues()) {
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
    public pageReference redirectPage(){
        PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
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
    public Boolean hasNext  {  
        get {  
            return con.getHasNext();  
        }  
        set;  
    }  
    public Boolean hasPrevious {  
        get {  
            return con.getHasPrevious();  
        }  
        set;  
    }  
    public Map<Id, boolean> hasCte{get;set;}
    
    public Map<String, List<BFM_NFS__c>> nfsByShipment{
        get{
            
            nfsByShipment = new Map<String, List<BFM_NFS__c>>();
            List<BFM_SES__c> theSES = [SELECT NFS__c, Stage__r.Shipment__c FROM BFM_SES__c WHERE Stage__r.Shipment__c IN: shipList];
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
            for(BFM_Shipment__c shipment: this.shipList ){
                if(!nfsByShipment.containsKey(shipment.Id)){
                    nfsByShipment.put(shipment.Id,new List<BFM_NFS__c>());
                }
            }
            
            return nfsByShipment;
        } 
        
        set;
    }
    
    public Map<String, List<BFM_CT_e__c>> ctesByShipment{
        get{
            ctesByShipment = new Map<String, List<BFM_CT_e__c>>();
            List<BFM_SES__c> theSESs = [SELECT CT_e__c, Stage__r.Shipment__c FROM BFM_SES__c WHERE Stage__r.Shipment__c IN: shipList];
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
            for(BFM_Shipment__c shipment: this.shipList ){
                System.debug('shipment Id on shiplist' + shipment.Id);
                if(!ctesByShipment.containsKey(shipment.Id)){
                    ctesByShipment.put(shipment.Id,new List<BFM_CT_e__c>());
                }
            }
            return ctesByShipment;        
            
        }set;
    }
    
    public PageReference getSelected(){
        selectedShipList.clear();
        for(accountwrapper accwrapper : shipWrapperList){
            if(accwrapper.selected)
            selectedShipList.add(accwrapper.accId);
        }
        return null;
    }
    
    public List<Id> GetSelectedShipments(){
        if(selectedShipList.size()>0) return selectedShipList;
        else return null;
    }    
    
    public class accountwrapper{
        public Id accId{get; set;}
        public Boolean selected {get; set;}
        public accountwrapper(Id sId){
            accId = sId;
            selected = false;
        }
    }
    
    @RemoteAction
    public static List<String> updateShipments(String idShips) {
        System.debug('updateShipments idShips : ' + idShips);
        Set<String> shipIds = new Set<String>();
        List<String> lstUrls = new List<String>();
        lstUrls.addAll(idShips.split(','));
        
        System.debug('updateShipments lstUrls : '+lstUrls);
        for(String str:lstUrls) {
            shipIds.add(str);   
        }
        
        Id batchJobId = Database.executeBatch(new BFM_BulkShipmentQuery(shipIds), 200);
        
        return lstUrls; 
    }

}