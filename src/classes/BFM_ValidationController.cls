public class BFM_ValidationController {
    
    //CC-e Duplicate Record Check
    public static void cceDuplicateRecordCheck(List<BFM_CC_e__c> CCeRecord){
        List<BFM_CC_e__c> CCeRecordQ=New List<BFM_CC_e__c>();
        Map<string,id> OldKeyMap=New Map<string,id>();
        Map<string,id> NewRecordMap=New Map<string,id>(); 
        set<string> CNPJId = new set<string>(); 
        
        for (BFM_CC_e__c rec:CCeRecord){
            NewRecordMap.put(rec.CC_e_Key__c,rec.id);  
            if(rec.CNPJ_Issuer__c!=null){
                CNPJId.add(rec.CNPJ_Issuer__c);
            }
            if(rec.CNPJ_Service_Taker__c!=null){
                CNPJId.add(rec.CNPJ_Service_Taker__c);
            }
            
        }
        CCeRecordQ = [Select id,CC_e_Key__c,CC_e_Status__c from BFM_CC_e__c where CC_e_Key__c IN:NewRecordMap.keySet() and id not in: trigger.new];
        for(BFM_CC_e__c cce:CCeRecordQ){
            OldKeyMap.put(cce.CC_e_Key__c,cce.id);    
        }
        if(NewRecordMap!=null){
            BFM_RecordutilityController utility=new BFM_RecordutilityController();
            utility.cceCheck(OldKeyMap,NewRecordMap,'CC-e',CCeRecord,CNPJId);
        }
    }
    
    //CT-e Duplicate Record Check
    public static void cteDuplicateRecordCheck(List<BFM_CT_e__c> CTeRecord){
        List<BFM_CT_e__c> CTeRecordQ=New List<BFM_CT_e__c>();
        Map<string,id> OldKeyMap=New Map<string,id>();
        Map<string,id> NewRecordMap=New Map<string,id>(); 
        Set<string> CNPJId = new Set<string>();   
        Set<string> setcteoriginal = new Set<string>();
        
        for (BFM_CT_e__c rec : CTeRecord){
            NewRecordMap.put(rec.Ct_e_Key__c, rec.id);  
            
            if(rec.CNPJ_Issuer__c!=null){
                CNPJId.add(rec.CNPJ_Issuer__c);
            }
            if(rec.CNPJ_Service_Taker__c!=null){
                CNPJId.add(rec.CNPJ_Service_Taker__c);
            }
            if(rec.CT_e_key__c!=null){
                setcteoriginal.add(rec.CT_e_key__c);
            }
        }
        List<BFM_CT_e__c> cteOriginal = new List<BFM_CT_e__c>();
        map<string,BFM_CT_e__c> mapcteoriginal = new map<string,BFM_CT_e__c>();
        if(!setcteoriginal.isEmpty()){
            cteOriginal = [select id,CT_e_key__c from BFM_CT_e__c where CT_e_key__c in: setcteoriginal and CT_e_Type__c='Normal'];
        }
        for(BFM_CT_e__c rec:CTeRecord){
            if(rec.CT_e_key__c!=null && mapcteoriginal.containsKey(rec.CT_e_key__c)){
                rec.CT_e__c = mapcteoriginal.get(rec.CT_e_key__c).id;
            }
        }
        for(BFM_CT_e__c ct: cteOriginal ){
            mapcteoriginal.put(ct.CT_e_key__c, ct);
        }
        CTeRecordQ = [Select id,CT_e_Key__c,Cte_Status__c, Is_Duplicated__c  from BFM_CT_e__c 
                      where CT_e_Key__c IN:NewRecordMap.keySet() and Is_Duplicated__c = false and ID NOT IN:Trigger.New];
        for(BFM_CT_e__c cte:CTeRecordQ){
            OldKeyMap.put(cte.CT_e_Key__c,cte.id);    
        }
        if(NewRecordMap!=null){
            BFM_RecordutilityController utility = new BFM_RecordutilityController();
            utility.cteCheck(OldKeyMap, NewRecordMap,'CT-e', CTeRecord, CNPJId);
        }
    }
    
    //MDF-e Duplicate Record Check
    public static void mdfeDuplicateRecordCheck(List<BFM_MDF_e__c> mdfeRecord){
        List<BFM_MDF_e__c> mdfeRecordQ=New List<BFM_MDF_e__c>();
        Map<string,id> OldKeyMap=New Map<string,id>();
        Map<string,id> NewRecordMap=New Map<string,id>(); 
        set<string> CNPJId = new set<string>();   
        for (BFM_MDF_e__c rec: mdfeRecord){
            
            NewRecordMap.put(rec.MDFE_Access_Key__c,rec.id);  
            if(rec.Issuer_CNPJ__c!=null){
                CNPJId.add(rec.Issuer_CNPJ__c);
            }
            if(rec.Taker_CNPJ__c!=null){
                CNPJId.add(rec.Taker_CNPJ__c);
            }
        }
        mdfeRecordQ = [Select id,MDFE_Access_Key__c,MDF_e_Status__c from BFM_MDF_e__c where MDFE_Access_Key__c IN:NewRecordMap.keySet() and
                       Is_Duplicated__c = false and ID NOT IN:Trigger.New];
        for(BFM_MDF_e__c mdfe: mdfeRecordQ){
            OldKeyMap.put(mdfe.MDFE_Access_Key__c,mdfe.id);    
        }
        if(NewRecordMap!=null){
            BFM_RecordutilityController utility=new BFM_RecordutilityController();
            utility.mdfeCheck(OldKeyMap,NewRecordMap,'MDF-e',mdfeRecord,CNPJId);
        }
    }
    
    //nfs duplicate recordcheck
    public static void nfsDuplicateRecordCheck(List<BFM_NFS__c> nfsRecord,set<id> setlinknfs, boolean isInsert){
        List<BFM_NFS__c> nfsRecordQ=New List<BFM_NFS__c>();
        Map<string,id> OldKeyMap=New Map<string,id>();
        Map<string,id> NewRecordMap=New Map<string,id>(); 
        set<string> CNPJId = new set<string>();   
        for (BFM_NFS__c rec: nfsRecord){
            if(isInsert==true || !setlinknfs.contains(rec.id)){
                if(rec.NFS_Emission_Date_Time__c!=null && rec.NFS_Series__c!=null && rec.NFS_Number__c!=null && rec.Vendor_s_CNPJ_or_CPF__c!=null ){
                    NewRecordMap.put(rec.NFS_Number__c+rec.NFS_Series__c+rec.Vendor_s_CNPJ_or_CPF__c+rec.NFS_Emission_Date_Time__c.year(),rec.id);  
                }
                if(rec.Vendor_s_CNPJ_or_CPF__c!=null){
                    CNPJId.add(rec.Vendor_s_CNPJ_or_CPF__c);
                }
                if(rec.Service_Taker_CNPJ__c!=null){
                    CNPJId.add(rec.Service_Taker_CNPJ__c);
                }
            }
        }
        nfsRecordQ = [Select id,NFS_Number__c,NFS_Key__c from BFM_NFS__c where NFS_Key__c IN:NewRecordMap.keySet() and id not in:nfsRecord];
        for(BFM_NFS__c nfs: nfsRecordQ){
            OldKeyMap.put(nfs.NFS_Key__c,nfs.id);    
        }
        if(!NewRecordMap.isEmpty()){
            BFM_RecordutilityController utility=new BFM_RecordutilityController();
            utility.nfsCheck(OldKeyMap,NewRecordMap,'NFS',nfsRecord,CNPJId);
        }
    }
    //debitnote record check
    public static void debitnoteDuplicateRecordCheck(List<BFM_Debit_Note__c> dnRecord,set<id> setdebitnote,boolean isinsert){
        List<BFM_Debit_Note__c> dnRecordQ=New List<BFM_Debit_Note__c>();
        Map<string,id> OldKeyMap=New Map<string,id>();
        Map<string,id> NewRecordMap=New Map<string,id>(); 
        set<string> CNPJId = new set<string>();   
        for (BFM_Debit_Note__c rec: dnRecord){
            if(isinsert == true || !setdebitnote.contains(rec.id)){
                if(rec.DN_Number__c!=null){
                    NewRecordMap.put(rec.DN_Number__c+rec.Vendor_s_CNPJ_or_CPF__c,rec.id);  
                }
                if(rec.Vendor_s_CNPJ_or_CPF__c!=null){
                    CNPJId.add(rec.Vendor_s_CNPJ_or_CPF__c);
                }
                if(rec.Service_Taker_CNPJ__c!=null){
                    CNPJId.add(rec.Service_Taker_CNPJ__c);
                }
            }
        }
        dnRecordQ = [Select id, DN_Number__c from BFM_Debit_Note__c where DN_Number__c IN:NewRecordMap.keySet() and Id not in: dnRecord];
        for(BFM_Debit_Note__c dn: dnRecordQ){
            OldKeyMap.put(dn.DN_Number__c,dn.id);    
        }
        if(!NewRecordMap.isEmpty()){
            BFM_RecordutilityController utility=new BFM_RecordutilityController();
            utility.debitnoteCheck(OldKeyMap,NewRecordMap,'Debit Note',dnRecord,CNPJId);
        }
    }
    
    //POD Duplicate Record Check
    public static void podDuplicateRecordCheck(List<BFM_POD__c> podRecord,boolean podinsert, Map<Id,SObject> podoldmap){
        
        List<BFM_POD__c> podRecordQ=New List<BFM_POD__c>();
        List<BFM_NF_e__c> nfeRecordQ=New List<BFM_NF_e__c>();
        Map<string,id> OldKeyMap=New Map<string,id>();
        Map<string,BFM_NF_e__c> nfeKeyMap=New Map<string,BFM_NF_e__c>(); 
        set<string> CNPJId = new set<string>(); 
        set<string> setnfekey = new set<string>(); 
        List<BFM_NF_e__c> getNfeAccesskey = new List<BFM_NF_e__c>(); 
        string nfeAccessKey='';
        string podstatus='';  
        system.debug('podRecord:'+podRecord);
        system.debug('podinsert:'+podinsert);
        system.debug('podoldmap:'+podoldmap);
        for (BFM_POD__c rec: podRecord){
            BFM_POD__c oldpod = (BFM_POD__c)podoldmap.get(rec.id);
            system.debug('Oldpod:'+oldpod);
            if(rec.NF_e_Access_Key__c !=null && oldpod.NF_e_Access_Key__c != rec.NF_e_Access_Key__c ){
                rec.POD_Status__c = 'In Progress';
            }
            /*
            if(rec.NF_e_Access_Key__c!=null){
            setnfekey.add(rec.NF_e_Access_Key__c);  
            }
            */
            /*nfeAccessKey = rec.NF_e__c;
            if(nfeAccessKey!='')
            {
                getNfeAccesskey = [select NF_e_Access_Key__c from BFM_NF_e__c where id=:nfeAccessKey];
                system.debug('getNfeAccesskey:'+getNfeAccesskey);
                for(BFM_NF_e__c nf : getNfeAccesskey)
                {
                    setnfekey.add(nf.NF_e_Access_Key__c);
                }
            }*/
            nfeAccessKey = rec.NF_e__c;
            if(rec.NF_e_Access_Key__c!='')
            {
                setnfekey.add(rec.NF_e_Access_Key__c);
            }
            
            system.debug('setnfekey:'+setnfekey);
            podstatus = rec.POD_Status__c;
            
        }
        system.debug('setnfekey:'+setnfekey);
        system.debug('podstatus:'+podstatus);
        podRecordQ = [Select id,POD_Number__c,NF_e_Access_Key__c from BFM_POD__c where NF_e_Access_Key__c IN: setnfekey and Id not in: podRecord and Is_Duplicated__c = false];
        nfeRecordQ = [select id,CNPJ_destination__c,Taker_CNPJ__c,NF_e_creation_date__c,NF_e_access_key__c,SES__c from BFM_NF_e__c where NF_e_access_key__c in:setnfekey];
        //nfeRecordQ = [select id,CNPJ_Destination_Account__r.CNPJ__c,Taker_Name__r.CNPJ__c,CNPJ_destination__c,NF_e_creation_date__c,NF_e_access_key__c,SES__c from BFM_NF_e__c where NF_e_access_key__c in:setnfekey];
        system.debug('nfeRecordQ:'+nfeRecordQ);
        
        for(BFM_POD__c pod: podRecordQ){
            OldKeyMap.put(pod.NF_e_Access_Key__c,pod.id);    
        }
        
        for(BFM_NF_e__c nfe: nfeRecordQ){
            nfeKeyMap.put(nfe.NF_e_access_key__c,nfe);  
            if(nfe.CNPJ_destination__c!=null){
                CNPJId.add(nfe.CNPJ_destination__c);
            }
            if(nfe.Taker_CNPJ__c!=null){
                CNPJId.add(nfe.Taker_CNPJ__c);
            }  
        }
        /*
        for(BFM_NF_e__c nfe: nfeRecordQ){
        nfeKeyMap.put(nfe.NF_e_access_key__c,nfe);  
        if(nfe.CNPJ_Destination_Account__r.CNPJ__c!=null){
        CNPJId.add(nfe.CNPJ_Destination_Account__r.CNPJ__c);
        }
        if(nfe.Taker_Name__r.CNPJ__c!=null){
        CNPJId.add(nfe.Taker_Name__r.CNPJ__c);
        }  
        }
        */
        if(podstatus != ''){ 
            BFM_RecordutilityController utility=new BFM_RecordutilityController();
            utility.podCheck(OldKeyMap,nfeKeyMap,'NFE',podRecord,CNPJId);
        }
        
    }
}