public with sharing class BFM_CTeHandler implements ITrigger {   
    public Map<Id, BFM_Ct_e__c> oldMap;
    public List<BFM_Ct_e__c> newMap;
    
    public BFM_CTeHandler() {    
    }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore() {  
        this.newMap = (List<BFM_CT_e__c>) Trigger.New;
        if(trigger.isinsert) { 
            
            /* Duplicate CHECK (1st validation) */
            System.debug('BFM_CTeHandler bulkBefore isinsert cteDuplicateRecordCheck BEGIN');
            BFM_ValidationController.cteDuplicateRecordCheck(Trigger.New);
            System.debug('BFM_CTeHandler bulkBefore isinsert cteDuplicateRecordCheck END');
            
            defineUnileverAccount(newMap);
        }
        
        if(trigger.isupdate){
            defineUnileverAccount(newMap);
            
            Set<id> setIdForSesLink = new Set<id>();
            Set<String> carriersCNPJs = new Set<String>();
            
            System.debug('BFM_CTeHandler bulkBefore isupdate cteSESLink BEGIN');
            if(newMap!=null){
                for(BFM_CT_E__c cte: this.newMap){
                    if((cte.Link_Status__c != null && cte.Link_Status__c.equalsIgnoreCase('Link Ok')) || 
                       (cte.CT_e_Request_for_Cancel__c != null && cte.CT_e_Request_for_Cancel__c==true) || 
                       (cte.cte_status__c != null && cte.cte_status__c.equalsIgnoreCase('Invoice Posted'))){
                           setIdForSesLink.add(cte.id);
                       }
                }
            }
            
            //TODO : Add query for shipment (to create SESs manually - LIKE IN SHIPMENT)
            if(!setIdForSesLink.isEmpty()){
                System.debug('BFM_CTeHandler bulkAfter isupdate cteSESLink BEGIN');
                BFM_LinkSES.cteSESLink(newMap,setIdForSesLink);
                System.debug('BFM_CTeHandler bulkAfter isupdate cteSESLink END');
            }            
            
            // TODO : IN THAT MOMENT THERE SHOULD ALREADY BE A SES 
            BFM_companyvendorcheck.companycodeandvendorcheck(newMap);
            
        }  
    }
    
    public void bulkAfter() {
        
        if(Trigger.isupdate){
            set<id> setcteids = new set<id>();
            set<id> cteIdSet = new set<id>();
            
            for(BFM_CT_e__c cte: (List<BFM_CT_e__c> )trigger.new){   
                System.debug('BFM_CTeHandler bulkAfter isupdate cte ' + cte);
                if(!cte.Is_CNPJ_Invalid__c && cte.CT_e_Sefaz_Check_Status__c == null){
                    setcteids.add(cte.id);
                }
                System.debug('BFM_CTeHandler bulkAfter isupdate setcteids ' + setcteids);

                if(cte.Link_Status__c != null && cte.Link_Status__c.equalsIgnoreCase('Link Ok')){
                    cteIdSet.add(cte.id);	
                }
                System.debug('BFM_CTeHandler bulkAfter isupdate cteIdSet ' + cteIdSet);
            }
            
            if(!cteIdSet.isEmpty()){
                System.debug('BFM_CTeHandler bulkAfter isupdate cteCompanycodeupdate BEGIN ');
                BFM_cteCompanyCodeUpdate.cteCompanycodeupdate(cteIdSet);
                System.debug('BFM_CTeHandler bulkAfter isupdate cteCompanycodeupdate END');
            }
            
            if(!setcteids.isEmpty()){
                System.debug('BFM_CTeHandler bulkAfter isupdate sendCTEtoSefaz BEGIN');
                BFM_Sefazvalidation_CC.sendCTEtoSefaz(setcteids,'cte');
                System.debug('BFM_CTeHandler bulkAfter isupdate sendCTEtoSefaz END');
            }
            // TODO : Manually update sefaz check (Add a dropdown field - - to update a field in order to trigger a call...)
            //TODO : Add request for Validate Fiscal Document (When sefaz status requested is Ok)

            //TODO : Sefaz should be Ok before calculate validation
            System.debug('BFM_CTeHandler bulkAfter isupdate CteTotalValueValidation BEGIN');
            BFM_TotalValueValidation.CteTotalValueValidation(Trigger.New);
            System.debug('BFM_CTeHandler bulkAfter isupdate CteTotalValueValidation END');
            
            //TODO : Call Tax Code in order to give a first tax calculation and create IVA (Check if there is a SES)
            
        }
    }
    
    public void beforeInsert(SObject so) {

    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
    }
    
    
    public void beforeDelete(SObject so) {
        //This method has been included as the class implements the ITrigger interface   
    }
    
    public void afterInsert(SObject so)  {
        //This method has been included as the class implements the ITrigger interface
        /* BFM_CT_e__c cte = (BFM_CT_e__c) so;
        if(cte.CT_e_Sefaz_Check_Status__c == null){
        BFM_SefazCheck_Utility_CC.sefazcheck(so.id,'ddsfas','CTE',userInfo.getSessionId());
        }*/
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
        BFM_CT_e__c cte = (BFM_CT_e__c) so; 

        //List<BFM_CT_e__c> Mirocount = [select id,(select id from BFM_MIRO_Header__r) from BFM_CT_e__c where id =: cte.id];
        /*if(Mirocount[0].BFM_MIRO_Header__r.size()==0 && cte.Link_Status__c=='Link Ok' && cte.Tax_Status__c!=null && cte.Tax_Status__c.equalsIgnoreCase('Tax Validation Ok') && cte.Cte_Status__c!='Invoice Posted' &&!system.isFuture() && !system.isBatch()){*/
            String bfmMiro = BFM_CreateMIRO.requestCreateMIRO(cte.id); 
            //BFM_InvoiceProcessing.performInvoiceProcessing(bfmMiro,'BFM_CT_e__c'); 
        //}
    }
    
    public void afterDelete(SObject so) {}
    
    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
	*/
    public void andFinally() {
        //This method has been included as the class implements the ITrigger interface    
    }
    
    public void defineUnileverAccount(List<BFM_CT_e__c> cteList) {
        Set<String> cnpjServiceTaker = new Set<String>();
        for(BFM_CT_e__c cte : cteList) {
            if(cte.Taker_Type__c != null) {
                if(cte.Taker_Type__c == '0' && cte.CNPJ_Goods_Sender__c != null) {
                    cte.CNPJ_Service_Taker__c = cte.CNPJ_Goods_Sender__c;
                    cte.City_Service_Taker__c = cte.City_Goods_Sender__c;
                    cte.City_Code_Service_Taker__c = cte.City_Code_Goods_Sender__c;
                    cte.UF_Service_Taker__c = cte.UF_Goods_Sender__c;                    
                }
                
                if(cte.Taker_Type__c == '1') {
                    if(cte.CNPJ_Cargo_Dispatcher__c != null) {
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Cargo_Dispatcher__c;
                        cte.City_Service_Taker__c = cte.City_Cargo_Dispatcher__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Cargo_Dispatcher__c;
                        cte.UF_Service_Taker__c = cte.UF_Cargo_Dispatcher__c;                         
                    } else if (cte.CNPJ_Goods_Sender__c != null ){
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Goods_Sender__c;
                        cte.City_Service_Taker__c = cte.City_Goods_Sender__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Goods_Sender__c;
                        cte.UF_Service_Taker__c = cte.UF_Goods_Sender__c;                           
                    }
                } 
                
                if(cte.Taker_Type__c == '2')
                    if (cte.CNPJ_Recipient__c != null) {
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Recipient__c;
                        cte.City_Service_Taker__c = cte.City_Recipient__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Recipient__c;
                        cte.UF_Service_Taker__c = cte.UF_Recipient__c;                        
                    } else if (cte.CNPJ_Destination__c != null) {
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Destination__c;
                        cte.City_Service_Taker__c = cte.City_Destination__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Destination__c;
                        cte.UF_Service_Taker__c = cte.UF_Destination__c;                         
                    }
                
                if(cte.Taker_Type__c == '3') {
                    if(cte.CNPJ_Destination__c != null) {
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Destination__c;
                        cte.City_Service_Taker__c = cte.City_Destination__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Destination__c;
                        cte.UF_Service_Taker__c = cte.UF_Destination__c;                         
                    } else if (cte.CNPJ_Recipient__c != null ){
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Recipient__c;
                        cte.City_Service_Taker__c = cte.City_Recipient__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Recipient__c;
                        cte.UF_Service_Taker__c = cte.UF_Recipient__c;                           
                    }
                }
                                
                if(cte.CNPJ_Service_Taker__c != null){
                    cnpjServiceTaker.add(cte.CNPJ_Service_Taker__c);
                } else {
                    cte.Is_Company_Code_Ok__c = false;
                }
            }
            
            RecordType recordTypeUnileverAccount = [SELECT id FROM RecordType WHERE DeveloperName = 'BFM_Unilever_Account' LIMIT 1];
            List<Account> accList = [SELECT CNPJ__c, id from Account where CNPJ__c =: cte.CNPJ_Service_Taker__c 
                                     AND RecordType.Id =: recordTypeUnileverAccount.Id];
            
            if(accList.size() > 0){
                for(Account acc : accList) {
                    if(acc.id != null){
                        cte.Unilever_Account__c = acc.id;
                    }
                }
            }
        }
    }
}