public with sharing class BFM_LinkSES {
    Private static Integer NFecount=0;
    Private static Integer TotNfeSESCount=0;
    
    public static void cteSESLink(List<BFM_CT_e__c> CTeRecord,set<id> setcodevalnf){
        
        Map<string,id> mapCTeNfe = new Map<string,id>();
        list<BFM_CT_e__c> listCTeLinkUpdate = new list<BFM_CT_e__c>();
        set<Id> recId=New set<Id>();

        Id taxCteId ;
        //BFM_CheckRecursive.firstRun = true; // TODO : Before checking if BFM_CheckRecursive is true, is setting it to true  - does it make sense ?
        system.debug('CTeRecord:'+CTeRecord);
        system.debug('BFM_CheckRecursive:'+BFM_CheckRecursive.firstRun);
        If(BFM_CheckRecursive.firstRun){
            BFM_CheckRecursive.firstRun=false;
            for(BFM_CT_e__c cte: CTeRecord){
                recId.add(cte.id);
                taxCteId = cte.id;
                system.debug('ids:'+recId);
            }
            
            list<BFM_CT_e__c> CTeRecordList = [SELECT Id,Cte_Status__c,Link_Status__c,(select NF_e_access_key__c from BFM_NF_es__r) FROM BFM_CT_e__c where id IN:recId];
            system.debug('CTeRecordList:'+CTeRecordList);
            for(BFM_CT_e__c cte: CTeRecordList){
                // if(cte.CT_e_Valid_CNPJ_Status__c=='valid CNPJ' && cte.CT_e_Duplicate_Record_Status__c=='Validation OK'){
                for(integer i=0;i<cte.BFM_NF_es__r.size();i++){
                    mapCTeNfe.put(cte.BFM_NF_es__r[i].NF_e_access_key__c,cte.id);
                }
                //}               
            } 
            system.debug('mapCTeNfe---->'+mapCTeNfe);
            
            if(mapCTeNfe!=null){
                BFM_LinkSES s=new BFM_LinkSES();
                s.SESupdate(mapCTeNfe,'CT-e');
            } 
            
            for(BFM_CT_e__c cte: CTeRecordList){
                system.debug('$$$$$$'+cte.id);
                system.debug('$$$$$$'+setcodevalnf.contains(cte.id)); 
                // if(cte.CT_e_Valid_CNPJ_Status__c=='valid CNPJ' && cte.CT_e_Duplicate_Record_Status__c=='Validation OK'){
                //if(mapCTeNfe.size()!=0 && mapCTeNfe.size()==TotNfeSESCount && setcodevalnf.contains(cte.id)){
                if(mapCTeNfe.size()!=0 && setcodevalnf.contains(cte.id)){
                    system.debug('inside cte entered');
                    cte.Link_Status__c='Link OK';
                    cte.Cte_Status__c='Link OK';
                    listCTeLinkUpdate.add(cte);
                }
                else if(mapCTeNfe.size()<TotNfeSESCount){
                    cte.Link_Status__c='Missing NF-es on the CT-e';
                    cte.Cte_Status__c='Missing NF-es on the CT-e';
                    listCTeLinkUpdate.add(cte);
                }
                else{
                    system.debug('entered else');
                    cte.Link_Status__c='Pending Link';
                    cte.Cte_Status__c='Pending Link';
                    listCTeLinkUpdate.add(cte);
                }
                system.debug('listCTeLinkUpdate'+listCTeLinkUpdate);
                if(listCTeLinkUpdate != null){                        
                    If(BFM_CheckRecursive.firstRun){
                		update listCTeLinkUpdate;
                		system.debug('listCTeLinkUpdate---->'+listCTeLinkUpdate);
                    }
                }
                
            }
            List<BFM_SES__c> sesTaxCode = [SELECT Id, Name, CT_E__c, Tax_Code__c FROM BFM_SES__c where CT_E__c=:recId]; 
            BFM_CT_e__c cteTax = new BFM_CT_e__c();
            for(BFM_SES__c bfmses:sesTaxCode)
            {
                if(bfmses.Tax_Code__c!=null)
                {
                    cteTax.id = taxCteId;
                    cteTax.Tax_Code_id__c = bfmses.Tax_Code__c;                    
                }
            }
            if(cteTax!=null){
                If(BFM_CheckRecursive.firstRun){
                update cteTax;
                }
            }
			            
        }
    }
    
    public static void NFSSESLink(List<BFM_NFS__c> NFSRecord){
        
        Map<string,id> mapNFSNfe = new Map<string,id>();
        list<BFM_NFS__c> listNFSLinkUpdate = new list<BFM_NFS__c>();
        set<Id> recId=New set<Id>();
        
        If(BFM_CheckRecursive.firstRun==true){
            BFM_CheckRecursive.firstRun=false;
            for(BFM_NFS__c cte: NFSRecord){
                recId.add(cte.id);
            }
            
            list<BFM_NFS__c> NFSRecordList = [SELECT Id,(select NF_e_access_key__c from NF_es__r) FROM BFM_NFS__c where id IN:recId];
            for(BFM_NFS__c cte: NFSRecordList){
                // if(cte.CT_e_Valid_CNPJ_Status__c=='valid CNPJ' && cte.CT_e_Duplicate_Record_Status__c=='Validation OK'){
                for(integer i=0;i<cte.NF_es__r.size();i++){
                    mapNFSNfe.put(cte.NF_es__r[i].NF_e_access_key__c,cte.id);
                }
                //}               
            } 
            system.debug('mapNFSNfe---->'+mapNFSNfe);
            
            if(mapNFSNfe!=null){
                BFM_LinkSES s=new BFM_LinkSES();
                s.SESupdate(mapNFSNfe,'NFS');
            } 
            
            for(BFM_NFS__c nfs: NFSRecordList){
                // if(nfs.CT_e_Valid_CNPJ_Status__c=='valid CNPJ' && nfs.CT_e_Duplicate_Record_Status__c=='Validation OK'){
                if(mapNFSNfe.size()!=0 && mapNFSNfe.size()==TotNfeSESCount){
                    nfs.NFS_Link_Check_Status__c='Link OK';   
                    listNFSLinkUpdate.add(nfs);
                }
                else if(mapNFSNfe.size()<TotNfeSESCount){
                    nfs.NFS_Link_Check_Status__c='Missing NF-es on the NFS';   
                    listNFSLinkUpdate.add(nfs);
                }
                else{
                    nfs.NFS_Link_Check_Status__c='Pending Link';
                    listNFSLinkUpdate.add(nfs);
                }
                system.debug('listNFSLinkUpdate'+listNFSLinkUpdate.size());
                if(listNFSLinkUpdate != null){
                    Database.SaveResult[] updateRec = Database.update(listNFSLinkUpdate,false);
                }
            }      
        }
    }
    
    
    public void SESupdate(Map<string,id> mapNfe, string Objectname){
        system.debug('mapnfe---->'+mapNfe);   
        list<BFM_SES__c> listSESupdate = new list<BFM_SES__c>();
        
        list<BFM_SES__c> NfeSesList = [Select id,CT_E__c,NFS__c,(SELECT NF_e_access_key__c FROM NF_es__r) from BFM_SES__c where id IN(SELECT SES__c FROM BFM_NF_e__c WHERE NF_e_access_key__c IN : mapNfe.Keyset())];
        system.debug('NfeSesList---->'+NfeSesList); 
        if(NfeSesList.size()>0){
            for(BFM_SES__c NfeSes: NfeSesList){
                system.debug('CT-eRecord---->'+NfeSes);
                integer NfeSESCount=NfeSes.NF_es__r.size();
                for(integer i=0;i<NfeSes.NF_es__r.size();i++){
                    if(mapNfe.containsKey(NfeSes.NF_es__r[i].NF_e_access_key__c)){
                        NFecount =NFecount+1;
                    }
                }
                system.debug('NFecount---->'+NFecount);
                if(mapNfe.size()>=NFecount && mapNfe.size()>=NfeSESCount){
                    if(Objectname=='CT-e'){
                        NfeSes.CT_E__c = mapNfe.get(NfeSes.NF_es__r[0].NF_e_access_key__c);
                        listSESupdate.add(NfeSes);
                    }
                    if(Objectname=='NFS'){
                        NfeSes.NFS__c = mapNfe.get(NfeSes.NF_es__r[0].NF_e_access_key__c);
                        listSESupdate.add(NfeSes);   
                    }
                }
                TotNfeSESCount=TotNfeSESCount+NfeSESCount;
            }
        }
        system.debug('listSESupdate---->'+listSESupdate);
        
        if(listSESupdate != null){
            Database.SaveResult[] updateRec = Database.update(listSESupdate,false);
        }   
    }
    
}