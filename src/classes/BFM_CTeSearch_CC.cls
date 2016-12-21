public with sharing class BFM_CTeSearch_CC {
    public BFM_CT_e__c cte{get;set;}
    public List<BFM_CT_e__c> cteList {get;set;}
    // create a list of strings to hold the conditions
    List<string> conditions = new List<string>();
    private integer totalRecs = 0;
    private integer OffsetSize = 0;
    private integer LimitSize= 10;
    public Date createDate {get;set;}
    public Date toDate {get;set;}
    public BFM_CTeSearch_CC(){
        cte = new BFM_CT_e__c();
        //cteList  = new List<BFM_CT_e__c>();
    }
    
    public void searchCTe(){
        totalRecs = 0;
        OffsetSize = 0;
        if(cteList !=null && cteList.size()>0){
            cteList=null;
        }
        searchCTes ();
        conditions.clear();
    }
    
    
    public Void searchCTes(){
        
        System.debug('Total Records is ==>'+totalRecs);
        System.debug('OffsetSize is ==>'+OffsetSize);
        
        if(cteList != null && !cteList.isEmpty()){
            cteList.clear();
        }
        String strQuery ='SELECT id, name, CNPJ_issuer__c,Cte_Status__c, Is_Duplicated__c, Link_Status__c,CT_e_Sefaz_Check_Status__c,Is_CNPJ_Invalid__c,CNPJ_Service_Taker__c, CT_e_key__c, CT_e_Number__c, Unilever_company_code__c,'+
            'Cte_Emission_date_time__c, CreatedDate from BFM_CT_e__c';
        
        if(cte.Name !=null && cte.Name !=''){
            List<String> iterateItems = cte.Name.split(',') ;
            List<String> name = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                name.add(item);
            }
            conditions.add('Name in' + name);               
        }
        
        if(cte.CT_e_Number__c !=null && cte.CT_e_Number__c !=''){
            List<String> iterateItems = cte.CT_e_Number__c.split(',') ;
            List<String> cteNumber = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                cteNumber.add(item);
            }
            conditions.add('CT_e_Number__c in' + cteNumber);               
        }
        
        if(cte.CNPJ_Service_Taker__c !=null && cte.CNPJ_Service_Taker__c !=''){
            List<String> iterateItems = cte.CNPJ_Service_Taker__c.split(',') ;
            List<String> serviceTaker = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                serviceTaker.add(item);
            }
            conditions.add('CNPJ_Service_Taker__c in' + serviceTaker);              
        }
        
        if(cte.Unilever_company_code__c !=null && cte.Unilever_company_code__c !=''){
            List<String> iterateItems = cte.Unilever_company_code__c.split(',') ;
            List<String> unileverCompanyCode = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                unileverCompanyCode.add(item);
            }
            conditions.add('Unilever_company_code__c in' + unileverCompanyCode);            
        }
        
        if(cte.CT_e_key__c !=null && cte.CT_e_key__c !=''){
            List<String> iterateItems = cte.CT_e_key__c.split(',') ;
            List<String> cteKey = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                cteKey.add(item);
            }
            conditions.add('CT_e_key__c in' + cteKey);
        }     
        
        if(cte.CNPJ_issuer__c !=null && cte.CNPJ_issuer__c !=''){
            List<String> iterateItems = cte.CNPJ_issuer__c.split(',') ;
            List<String> cnpjIssuer = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                cnpjIssuer.add(item);
            }
            conditions.add('CNPJ_issuer__c in' + cnpjIssuer);
        }    
        
        if(cte.Vendor_code__c !=null && cte.Vendor_code__c !=''){
            List<String> iterateItems = cte.Vendor_code__c.split(',') ;
            List<String> vendorCode = new List<String>();
            for(String item : iterateItems) {
                item = '\'' +item+ '\''; 
                vendorCode.add(item);
            }
            conditions.add('Vendor_code__c in' + vendorCode);            
        }     
        
        if(createDate !=null){
            DateTime dt = datetime.newInstance(createDate.year(), createDate.month(),createDate.day());
            String createdDate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
            conditions.add('CreatedDate > ' + createdDate);
        } 
        
        if(createDate !=null && toDate !=null){
            DateTime dt = datetime.newInstance(toDate.year(), toDate.month(),toDate.day());
            String finishedDate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
            conditions.add('Cte_Emission_date_time__c < ' + finishedDate);
        }            
        
        if (conditions.size() > 0) {
            strQuery += '  WHERE ' + conditions[0];
            for (Integer i = 1; i < conditions.size(); i++){
                strQuery += '  AND ' + conditions[i];
            }
        }
        
        System.debug('strQuery' + strQuery);
        if(totalRecs !=null && totalRecs ==0){
            List<BFM_CT_e__c> ctTemp = Database.query(strQuery);
            totalRecs = (ctTemp !=null &&ctTemp.size()>0)?ctTemp.size():0;
        }
        
        system.debug('strQuery ==>'+strQuery );
        // add sort and limits at the end  
        strQuery += ' ORDER BY Name  ASC LIMIT :LimitSize OFFSET :OffsetSize';
        
        cteList  =Database.query(strQuery);
        //conditions.clear();
        //return cteList.size();
    }
    
    public void FirstPage() {
        OffsetSize = 0;
        searchCTes();
    }
    
    public void previous() {
        OffsetSize = (OffsetSize-LimitSize);
        searchCTes();
    }
    
    public void next(){
        OffsetSize = OffsetSize + LimitSize;
        searchCTes();
    }
    
    public void LastPage() {
        OffsetSize = totalrecs - math.mod(totalRecs,LimitSize);
        searchCTes();
    }
    
    public boolean getprev() {
        if(OffsetSize == 0) {
            return true;
        } else {
            
            return false;
        }
    }
    
    public boolean getnxt() {
        if((OffsetSize + LimitSize) > totalRecs) {
            return true;
        } else {
            return false;
        }
    }
}