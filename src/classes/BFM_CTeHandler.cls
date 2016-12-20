public with sharing class BFM_CTeHandler implements ITrigger {   
    public Map<Id, BFM_Ct_e__c> oldMap;
    public List<BFM_Ct_e__c> newMap;
    public Map<String, Id> carrierIdByCNPJ;
    
    public BFM_CTeHandler() {    
    }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore() {  
        if(trigger.isinsert) { 
            
            System.debug('BFM_CTeHandler bulkBefore isinsert cteDuplicateRecordCheck BEGIN');
            BFM_ValidationController.cteDuplicateRecordCheck(Trigger.New);
            System.debug('BFM_CTeHandler bulkBefore isinsert cteDuplicateRecordCheck END');
            
            //this.oldMap = (Map<Id, BFM_CT_e__c>) trigger.oldMap;
            this.newMap = (List<BFM_CT_e__c>) Trigger.New;
            this.carrierIdByCNPJ = new Map<String, Id>();
            Set<String> carriersCNPJs = new SeT<String>();
            
            if(newMap!=null){
                for(BFM_CT_E__c cte: this.newMap){
                    if(cte.cnpj_Issuer__c != null){
                        carriersCNPJs.add(cte.CNPJ_issuer__c);
                    }
                }
            }
            
            System.debug('BFM_CTeHandler bulkBefore isinsert carriersCNPJs ' + carriersCNPJs);
            for(Account acc: [SELECT Id, CNPJ__c FROM Account WHERE CNPJ__c IN: carriersCNPJs]){
                carrierIdByCNPJ.put(acc.cnpj__c, acc.Id);
            }
            System.debug('BFM_CTeHandler bulkBefore isinsert carrierIdByCNPJ ' + carrierIdByCNPJ);
        }
        
        
        if(trigger.isupdate){
            System.debug('BFM_CTeHandler bulkBefore isupdate companycodeandvendorcheck BEGIN');
            BFM_companyvendorcheck.companycodeandvendorcheck(Trigger.New);
            System.debug('BFM_CTeHandler bulkBefore isupdate companycodeandvendorcheck END');
        }  
    }
    
    public void bulkAfter() {
        
        if(Trigger.isupdate){
            set<id> setcodevalnfs = new set<id>();
            set<id> setcteids = new set<id>();
            set<id> cteIdSet = new set<id>();
            
            for(BFM_CT_e__c cte: (List<BFM_CT_e__c> )trigger.new){   
                System.debug('BFM_CTeHandler bulkAfter isupdate cte ' + cte);
                if(cte.CT_e_Valid_CNPJ_Status__c != null && cte.CT_e_Valid_CNPJ_Status__c.equalsIgnoreCase('Valid CNPJ') && cte.CT_e_Sefaz_Check_Status__c== null){
                    setcteids.add(cte.id);
                }
                System.debug('BFM_CTeHandler bulkAfter isupdate setcteids ' + setcteids);
                
                if((cte.Link_Status__c != null && cte.Link_Status__c.equalsIgnoreCase('Link Ok')) || 
                   (cte.CT_e_Request_for_Cancel__c != null && cte.CT_e_Request_for_Cancel__c==true) || 
                   (cte.cte_status__c != null && cte.cte_status__c.equalsIgnoreCase('Invoice Posted'))){
                       setcodevalnfs.add(cte.id);
                   }
                System.debug('BFM_CTeHandler bulkAfter isupdate setcodevalnfs ' + setcodevalnfs);
                
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

            if(!setcodevalnfs.isEmpty()){
                System.debug('BFM_CTeHandler bulkAfter isupdate cteSESLink BEGIN');
                BFM_LinkSES.cteSESLink(Trigger.New,setcodevalnfs);
                System.debug('BFM_CTeHandler bulkAfter isupdate cteSESLink END');
            }
            
            //TODO : Sefaz should be Ok before calculate validation
            System.debug('BFM_CTeHandler bulkAfter isupdate CteTotalValueValidation BEGIN');
            BFM_TotalValueValidation.CteTotalValueValidation(Trigger.New);
            System.debug('BFM_CTeHandler bulkAfter isupdate CteTotalValueValidation END');
            
        }
    }
    
    public void beforeInsert(SObject so) {
        /*
        // fills Master-Detail on Account based on provided CNPJ, if the CT-e doesn't have an account already
        System.debug('assigning CT-e account');
        BFM_CT_e__c cte = (BFM_CT_e__c) so;
        if(cte.cnpj_issuer__c != null && carrierIdByCNPJ.containsKey(cte.CNPJ_issuer__c) && cte.carrier_account__c == null){
            cte.carrier_account__c =  carrierIdByCNPJ.get(cte.cnpj_issuer__c);
        } else{
            cte.addError(Label.BFM_CT_e_Carrier_Assignment_Erro);
        }*/
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
         //This method has been included as the class implements the ITrigger interface   
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
        //This method has been included as the class implements the ITrigger interface 
        BFM_CT_e__c cte = (BFM_CT_e__c) so;                 
        if(cte.Link_Status__c=='Link Ok' && cte.Tax_Status__c=='Tax Validation Ok' && cte.Cte_Status__c!='Invoice Posted' &&!system.isFuture() && !system.isBatch()){
            String bfmMiro = BFM_CreateMIRO.requestCreateMIRO(cte.id); 
            BFM_InvoiceProcessing.performInvoiceProcessing(bfmMiro,'BFM_CT_e__c'); 
        }
    }
    
    public void afterDelete(SObject so) {
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally() {
        //This method has been included as the class implements the ITrigger interface    
    }
    
}