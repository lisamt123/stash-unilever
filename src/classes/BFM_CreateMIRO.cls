global with sharing class BFM_CreateMIRO {
    private Id invoiceId;
    private boolean cancellationFlag;
    private boolean annulmentFlag;
    private BFM_MIRO_Header__c createdMiro;
    
    webservice static String requestCreateMIRO(Id invoiceId){
        BFM_CreateMIRO miroCreator = new BFM_CreateMIRO(invoiceId, false, false);
        BFM_MIRO_Header__c miroHeader = miroCreator.createMIRO();
        return miroHeader.Id;
    }
    public Map<Id, List<BFM_IVA__c>> getIVAsBySES(List<BFM_SES__c> sesList){
        Map<Id, List<BFM_IVA__c>> ivasBySES = new Map<Id, List<BFM_IVA__c>>();
        for(BFM_IVA__c iva: [SELECT SES__c,Other_Base__c, Excluded_Base__c, Tax_Base__c FROM BFM_IVA__c WHERE SES__c IN: sesList]){
            if(!ivasBySES.containsKey(iva.SES__c)){
                ivasBySES.put(iva.SES__c, new List<BFM_IVA__c>());
            }
            ivasBySes.get(iva.SES__c).add(iva);
        }
        return ivasBySes;
    }
    public BFM_CreateMIRO(Id invoiceId, boolean cancellationFlag, boolean annulmentFlag){
        this.invoiceId = invoiceId;
        this.cancellationFlag = cancellationFlag;
        this.annulmentFlag = annulmentFlag;
    }
    
    public BFM_MIRO_Header__c createMIRO(){
        if(invoiceId.getSobjectType() == BFM_CT_e__c.sObjectType){
            createdMIRO = createMIROforCTe();
            system.debug('Miro Id ' +createdMIRO.Id);
        } else if(invoiceId.getSobjectType() == BFM_CT_e__c.sObjectType){
            createdMIRO = createMIROforNFS(invoiceId);
            system.debug('Miro Id ' +createdMIRO.Id);
        }
        return createdMIRO;
    }
    
    private BFM_MIRO_Header__c createMIROforCTe(){
        Id cteId = this.invoiceId;
        BFM_CT_e__c cte = [SELECT Id,Cte_Emission_date_time__c,CT_e_key__c,CT_e_Number__c,Unilever_Company_Code__c,
                           Receivable_Amount__c,CT_e_Auto_Number__c,Cte_protocol_Number__c,NFe_Access_Key__c,Emission_Type__c,
                           Random_Number__c, CT_e_Serie__c,
                           (Select Id, SES_Number__c,Net_Value__c,Tax_Code__c, CFOP__c, COFINS_Aliquot__c, PIS_Aliquot__c FROM SESs__r)
                           FROM BFM_CT_e__c where Id =: cteId];
        
        BFM_Miro_Header__c miro = new BFM_MIRO_Header__c();
        Map<Id, List<BFM_IVA__c>> ivasBySES = getIVASBySES(cte.SESs__r);
        Map<String, BFM_Miro_Item__c> miroItemBySESNumber = new Map<String,BFM_MIRO_Item__c>();
        if(cte.CT_e_key__c != null){
            miro.Access_Key__c = cte.CT_e_key__c;
            miro.NF_Type__c = 'CE';
            miro.Invoice_Date__c = Date.valueOf(cte.Cte_Emission_date_time__c);
            miro.Invoice_Number__c = cte.CT_e_Number__c;
            miro.Invoice_Serie_Number__c = cte.CT_e_Serie__c;
            miro.Reference_Number__c = miro.Invoice_Number__c + '-' + miro.Invoice_Serie_Number__c;
            miro.Company_Code__c = cte.Unilever_Company_Code__c;
            miro.Reference_Document_Category__c = '4';
            miro.Transaction__c = '1';
            miro.Total_Amount__c = cte.Receivable_Amount__c;
            miro.Header_Text_Summary__c = cte.CT_e_Auto_Number__c;
            miro.Protocol_Number__c = cte.Cte_protocol_Number__c;
            String accessKey = cte.CT_e_key__c;
            miro.Check_Digit_in_Access_Key__c = accessKey.substring(accessKey.length()-1);
            miro.NF_e_Issuing_Type__c = cte.Emission_Type__c;
            miro.Cte_Random_Number__c = cte.Random_Number__c;
            miro.Baseline_Date_for_Due_Date_Calculation__c = getLatestDate(cte);
            miro.Cancellation_Flag__c = false;
            miro.Annulment_Reason__c = '';
            miro.Complement_SES_Flag__c = ' ';
            miro.CT_e__c = cte.id;
            insert miro;
            System.debug('MIRO' + miro);
            if(!cte.SESs__r.isEmpty()){
                for(BFM_SES__c ses : cte.SESs__r){
                    BFM_Miro_Item__c miroItem = new BFM_MIRO_Item__c();
                    miroItem.MIRO_Header__c = miro.Id;
                    //miroItem.MIRO_Header__r.COFINS_Amount__c = cte.Receivable_Amount__c;
                    //miroItem.MIRO_Header__r.PIS_Amount__c =  cte.Receivable_Amount__c;
                    miroItem.Entry_Sheet_Number__c = ses.SES_Number__c;
                    miroItem.Access_Key__c = miro.Access_Key__c + ses.ses_number__c;
                    miroItem.SES_Net_Value__c = ses.Net_Value__c;
                    miroItem.Tax_on_Sales_Purchases_Code__c = ses.Tax_Code__c;
                    miroItemBySESNumber.put(miroItem.access_Key__c, miroItem);
                }
                insert miroItemBySESNumber.values();
                List<BFM_MIRO_Item_Tax__c> miroItemTaxes;
                for(BFM_SES__c ses : cte.SESs__r){
                    if(ivasBySES.containsKey(ses.Id)){
                        miroItemTaxes = new List<BFM_MIRO_Item_Tax__c>();
                        for(BFM_IVA__c iva: ivasBySES.get(ses.Id)){
                            BFM_MIRO_Item_Tax__c miroItemTax = new BFM_MIRO_Item_Tax__c();
                            // get miro Item by it's access key
                            miroItemTax.MIRO_Item__c = miroItemBySESNumber.get(miro.Access_Key__c + ses.ses_number__c).Id;
                            miroItemTax.CFOP_Entry__c = ses.CFOP__c;
                            miroItemTax.Other_Base__c = iva.Other_Base__c;
                            miroItemTax.Excluded_Base__c = iva.Excluded_Base__c;
                            miroItemTax.Original_Tax_Base_Amount__c = iva.Tax_Base__c;
                            miroItemTaxes.add(miroItemTax);
                        }
                    } else {
                        system.debug('couldn\'t find IVA for SES ' + ses.Id);
                    }
                }
                if(miroItemTaxes != null){
                    insert miroItemTaxes;
                } else {
                    System.debug('miroItemTaxes was null');
                }
            }
        } else{
            System.debug('Ct-e access key was null!');
        }
        return miro;
    }
    
    private BFM_MIRO_Header__c createMIROforNFS(id NFSId){
        BFM_NFS__c theNFS = [SELECt Id, Vendor_s_CNPJ_or_CPF__c,NFS_Emission_Date_Time__c,
                             NFS_Number__c,NFS_Series__c FROM BFM_NFS__c WHERE ID =: nfsID];
        Map<String, BFM_Miro_Item__c> miroItemBySESNumber = new Map<String,BFM_MIRO_Item__c>();
        Map<Id, List<BFM_IVA__c>> ivasBySES = new Map<Id, List<BFM_IVA__c>>();
        
        BFM_MIRO_Header__c miroHeader = new BFM_MIRO_Header__c();
        if(theNFS.NFS_Emission_Date_Time__c != null){
            miroHeader.Access_Key__c = theNFS.Vendor_s_CNPJ_or_CPF__c + ''
                +theNFS.NFS_Emission_Date_Time__c.year() +''
                +theNFS.NFS_Emission_Date_Time__c.month() +''
                +theNFS.NFS_Emission_Date_Time__c.day()+''
                +theNFS.NFS_Number__c+''
                +theNFS.NFS_Series__c;
            miroHeader.NF_Type__c = 'ZS';
            miroHeader.Invoice_Date__c = Date.newInstance(theNFS.NFS_Emission_Date_Time__c.year(),
                                                          theNFS.NFS_Emission_Date_Time__c.month(), 
                                                          theNFS.NFS_Emission_Date_Time__c.year());
            miroHeader.Invoice_Number__c = theNFS.NFS_Number__c;
            miroHeader.Company_Code__c = theNFS.Service_Taker__r.Company_Code__c;
            miroHeader.Reference_Document_Category__c = '4';
            miroHeader.Transaction__c = '1';
            miroHeader.Total_Amount__c = theNFS.NFS_Total_Value__c;
            miroHeader.Header_Text_Summary__c = theNFS.NFS_Auto_Number__c;
            //miroHeader.Value_Net__c = ???
            //miroHeader.protocolNumber = N/A;
            //miroHeader.checkDigit = N/A;
            //miroHeader.nfeIssType = N/A;
            //miroHeader.randomNumber = N/A;
            miroHeader.Baseline_Date_for_Due_Date_Calculation__c = getLatestDate(theNfs);    
            //  miroHeader.Cancellation_Flag__c;
            //miroHeader.Annulment_Flag__c
            //miroHeader.Annulment_Reason__c
            //miroHeader.In_State_Out_State__c
            insert miroHeader;
            for(BFM_SES__c ses : theNfs.SESNFSs__r){
                BFM_Miro_Item__c miroItem = new BFM_MIRO_Item__c();
                miroItem.MIRO_Header__c = miroHeader.Id;
                miroItem.Entry_Sheet_Number__c = ses.SES_Number__c;
                miroItem.Access_Key__c = miroHeader.Access_Key__c + ses.ses_number__c;
                miroItem.SES_Net_Value__c = ses.Net_Value__c;
                miroItem.Tax_on_Sales_Purchases_Code__c = ses.Tax_Code__c;
                miroItemBySESNumber.put(miroItem.access_Key__c, miroItem);
            }
            insert miroItemBySESNumber.values();
            List<BFM_MIRO_Item_Tax__c> miroItemTaxes; 
            for(BFM_SES__c ses : theNfs.SESNFSs__r){
                if(ivasBySES.containsKey(ses.Id)){
                    miroItemTaxes = new List<BFM_MIRO_Item_Tax__c>();
                    for(BFM_IVA__c iva: ivasBySES.get(ses.Id)){
                        BFM_MIRO_Item_Tax__c miroItemTax = new BFM_MIRO_Item_Tax__c();
                        // get miro Item by it's access key
                        miroItemTax.MIRO_Item__c = miroItemBySESNumber.get(miroHeader.Access_Key__c + ses.ses_number__c).Id;
                        miroItemTax.CFOP_Entry__c = ses.CFOP__c;
                        miroItemTax.Other_Base__c = iva.Other_Base__c;
                        miroItemTax.Excluded_Base__c = iva.Excluded_Base__c;
                        miroItemTax.Original_Tax_Base_Amount__c = iva.Tax_Base__c;
                        miroItemTaxes.add(miroItemTax);
                    }
                }
            }
            if(miroItemTaxes != null){
                insert miroItemTaxes;
            } else{
                System.debug('There were no taxes!');
            }
        }
        return miroHeader;
    }
    
    private BFM_MIRO_Header__c createMIROforDN(){
        BFM_MIRO_Header__c header = new BFM_MIRO_Header__c();
        BFM_Debit_Note__c debitNote = [SELECT Id FROM BFM_Debit_Note__c WHERE Id =: invoiceId];       
        Map<String, BFM_Miro_Item__c> miroItemBySESNumber = new Map<String,BFM_MIRO_Item__c>();
        Map<Id, List<BFM_IVA__c>> ivasBySES = new Map<Id, List<BFM_IVA__c>>();
        
        header.Access_Key__c = debitNote.Vendor_s_CNPJ_or_CPF__c +
            ''+debitNote.DN_Emission_date_time__c.year()+
            ''+debitNote.DN_Emission_date_time__c.month()+
            ''+debitNote.DN_Emission_date_time__c.year()+
            ''+debitNote.DN_Number__c;
        //header.NF_Type__c = 'N/A'
        header.Invoice_Date__c = Date.newInstance(debitNote.DN_Emission_date_time__c.year(),
                                                  debitNote.DN_Emission_date_time__c.month(),
                                                  debitNote.DN_Emission_date_time__c.day());
        header.Invoice_Number__c = debitNote.DN_Number__c;
        header.Company_Code__c = debitNote.Unilever_Account__r.Company_Code__c;
        header.Reference_Document_Category__c = '4';
        header.Transaction__c = '1';
        //header.Total_Amount__c = debitNote.DN_total_value__c;
        header.Header_Text_Summary__c = debitNote.DN_Auto_Number__c;
        //header.valueNet;
        //header.Baseline_Date_for_Due_Date_Calculation__c = N/A;
        header.Cancellation_Flag__c = this.cancellationFlag;
        //header.Annulment_Flag__c = this.annulmentFlag ? 'x' : ' ';
        //header.Annulment_Reason__c = this.annulmentReason;
        //header.In_State_Out_State__c 
        List<BFM_SES__c> sesList = [SELECT Id FROM BFM_SES__c WHERE Occurrence__c = :debitNote.Occurrence__c];
        
        if(!sesList.isEmpty()){
            for(BFM_SES__c ses : sesList){
                BFM_Miro_Item__c miroItem = new BFM_MIRO_Item__c();
                miroItem.MIRO_Header__c = header.Id;
                miroItem.Entry_Sheet_Number__c = ses.SES_Number__c;
                miroItem.Access_Key__c = header.Access_Key__c + ses.ses_number__c;
                miroItem.SES_Net_Value__c = ses.Net_Value__c;
                miroItem.Tax_on_Sales_Purchases_Code__c = ses.Tax_Code__c;
                miroItemBySESNumber.put(miroItem.access_Key__c, miroItem);
            }
            insert miroItemBySESNumber.values();
            List<BFM_MIRO_Item_Tax__c> miroItemTaxes;
            for(BFM_SES__c ses : sesList){
                if(ivasBySES.containsKey(ses.Id)){
                    miroItemTaxes = new List<BFM_MIRO_Item_Tax__c>();
                    for(BFM_IVA__c iva: ivasBySES.get(ses.Id)){
                        BFM_MIRO_Item_Tax__c miroItemTax = new BFM_MIRO_Item_Tax__c();
                        // get miro Item by it's access key
                        miroItemTax.MIRO_Item__c = miroItemBySESNumber.get(header.Access_Key__c + ses.ses_number__c).Id;
                        miroItemTax.CFOP_Entry__c = ses.CFOP__c;
                        miroItemTax.Other_Base__c = iva.Other_Base__c;
                        miroItemTax.Excluded_Base__c = iva.Excluded_Base__c;
                        miroItemTax.Original_Tax_Base_Amount__c = iva.Tax_Base__c;
                        miroItemTaxes.add(miroItemTax);
                    }
                } else {
                    system.debug('couldn\'t find IVA for SES ' + ses.Id);
                }
            }
            if(miroItemTaxes != null){
                insert miroItemTaxes;
            } else {
                System.debug('miroItemTaxes was null');
            }
        }
        
        return header;
    }
    
    /**
    * Gets most recent date from the related PODs dates
    * */ 
    private Date getLatestDate(BFM_Ct_e__c cte){
        Date latestDate = Date.newInstance(1901, 1, 1);
        for(BFM_POD__c pod: [SELECT id, POD_Date__c FROM BFM_POD__c WHERE NF_e__r.CT_e__c = :cte.Id]){
            if(pod.POD_Date__c != null && pod.POD_Date__c > latestDate){
                latestDate = pod.POD_Date__c;
            }
        }
        return latestDate;
    }
    
    /**
    * Gets most recent date from the related PODs dates
    * */     
    private Date getLatestDate(BFM_NFS__c nfs){
        Date latestDate = Date.newInstance(1901, 1, 1);
        for(BFM_POD__c pod: [SELECT id, POD_Date__c FROM BFM_POD__c WHERE NF_e__r.NFS__c = :nfs.Id]){
            if(pod.POD_Date__c != null && pod.POD_Date__c > latestDate){
                latestDate = pod.POD_Date__c;
            }
        }
        return latestDate;
    } 
}