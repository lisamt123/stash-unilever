public class BFM_RecordutilityController {
    public void cceCheck(Map<string,id> OldKeyMap,Map<string,id> NewRecordMap, string FileType , List<BFM_CC_e__c> CCeRecord ,set<string> CNPJId){
        List<BFM_Error_Log__c> errlist= New List<BFM_Error_Log__c>();
        set<string> accCNPJ = new set<string>();
        List<BFM_CT_e__c> CT_eUpdateRecordList= New List<BFM_CT_e__c>();
        List<BFM_CC_e__c> CC_eUpdateRecordList=New List<BFM_CC_e__c>();
        List<Account> acclist=[Select id,CNPJ__c from Account where CNPJ__c IN:CNPJId];
        for(Account ac : acclist){
            accCNPJ.add(ac.CNPJ__c);
        }
        
        if(FileType == 'CC-e'){
            for(BFM_CC_e__c cce : CCeRecord){
                if(OldKeyMap.containsKey(cce.CC_e_Key__c)){
                    cce.CC_e_Status__c =  Label.BFM_Validation_Error;      
                    cce.Is_Duplicated__c = true;
                }else{
                    cce.CC_e_Status__c =  Label.BFM_Validation_OK;  
                    cce.Is_Duplicated__c = false;
                } 
                
                if(!cce.Is_Duplicated__c){
                    if((cce.CNPJ_Issuer__c!=null && accCNPJ.contains(cce.CNPJ_Issuer__c)) && (cce.CNPJ_Service_Taker__c!=null && accCNPJ.contains(cce.CNPJ_Service_Taker__c)) ){
                        cce.CC_e_Status__c =  Label.BFM_Valid_CNPJ; 
                        cce.Is_CNPJ_Invalid__c = false;
                    } else {
                        cce.CC_e_Status__c =  'Invalid CNPJ';  
                        cce.Is_CNPJ_Invalid__c = true;
                    }
                }
            }
            BFM_Link_CCECTE.linkCCECTE(CCeRecord);
        }
    }
    
    
    public void cteCheck(Map<string,id> OldKeyMap,Map<string,id> NewRecordMap, string FileType , List<BFM_CT_e__c> CTeRecord ,set<string> CNPJId){
        List<BFM_Error_Log__c> errlist = new List<BFM_Error_Log__c>();
        Set<string> accCNPJ = new Set<string>();
        List<BFM_CT_e__c> CT_eUpdateRecordList = new List<BFM_CT_e__c>();
        List<Account> acclist=[Select id,CNPJ__c from Account where CNPJ__c IN:CNPJId];
        
        for(Account ac : acclist){
            accCNPJ.add(ac.CNPJ__c);
        }
        
        string yrString;
        string mnstring;
        string ctekey;
        if(FileType == 'CT-e'){
            for(BFM_CT_e__c cte : CTeRecord){
                cte.Cte_Status__c = 'Pending Link';
                cte.Link_Status__c = 'Pending Link';
                ctekey = cte.CT_e_Key__c;
                if(OldKeyMap.containsKey(cte.CT_e_Key__c)) {
                    //cte.Cte_Status__c = Label.BFM_Validation_Error; 
                    cte.Is_Duplicated__c = true;
                    system.debug('Inside if condition CT_e_Key__c recordutilitycontroller:');
                } else {
                    //cte.Cte_Status__c = Label.BFM_Validation_OK;  
                    cte.is_Duplicated__c = false;
                    system.debug('Inside else condition CT_e_Key__c recordutilitycontroller:');
                } 
                
                if(!cte.is_Duplicated__c) {
                    if((cte.CNPJ_Issuer__c!=null && accCNPJ.contains(cte.CNPJ_Issuer__c)) || (cte.CNPJ_Service_Taker__c!=null && accCNPJ.contains(cte.CNPJ_Service_Taker__c)) ){
                        //cte.Cte_Status__c = Label.BFM_Valid_CNPJ;   
                        cte.Is_CNPJ_Invalid__c = false;
                        system.debug('Inside if condition is_Duplicated__c:');
                    } else {
                        //cte.Cte_Status__c = 'Invalid CNPJ';  
                        cte.Is_CNPJ_Invalid__c = true;
                        system.debug('Inside else condition is_Duplicated__c:');
                    }
                }
                yrString = '20';
                yrString+= ctekey.SubString(2,4);
                system.debug('===>yr'+yrString);                
                mnstring = ctekey.SubString(4,6);
                system.debug('===>mn'+mnstring);
                Date newdate = Date.newInstance(integer.valueOf(yrString), integer.valueOf(mnstring), 01);
                system.debug('===>mn'+newdate);
                Date today1 = Date.today();
				Integer diffDate = newdate.daysBetween(today1) ;
                if(newdate!=null && diffDate >=180){
                	cte.CT_e_6_Months__c = true;    
                }
            }
        }
    }
    
    public void mdfeCheck(Map<string,id> OldKeyMap,Map<string,id> NewRecordMap, string FileType , List<BFM_MDF_e__c> mdfeRecord ,set<string> CNPJId){
        set<string> accCNPJ = new set<string>();
        map<string,account> mapacc = new map<string,account>();
        List<Account> acclist=[Select id,CNPJ__c from Account where CNPJ__c IN:CNPJId];
        for(Account ac : acclist){
            accCNPJ.add(ac.CNPJ__c);
            mapacc.put(ac.CNPJ__c,ac);
        }
        for(BFM_MDF_e__c mdfe : mdfeRecord){
            if(mapacc.containskey(mdfe.Issuer_CNPJ__c) && mapacc.get(mdfe.Issuer_CNPJ__c)!=null){
                //      mdfe.Carrier_Account__c = mapacc.get(mdfe.Issuer_CNPJ__c).id;
            }
            if(mapacc.containskey(mdfe.Taker_CNPJ__c) && mapacc.get(mdfe.Taker_CNPJ__c)!=null){
                //      mdfe.Unilever_Account__c = mapacc.get(mdfe.Taker_CNPJ__c).id;
            }
                
            if(OldKeyMap.containsKey(mdfe.MDFE_Access_Key__c)){
                mdfe.MDF_e_Status__c = Label.BFM_Validation_Error;     
                mdfe.Is_Duplicated__c = true;
            } else{
                mdfe.MDF_e_Status__c = Label.BFM_Validation_Ok;
                mdfe.Is_Duplicated__c = false;
            }
            
            if(!mdfe.Is_Duplicated__c){
                if((mdfe.Issuer_CNPJ__c!=null && accCNPJ.contains(mdfe.Issuer_CNPJ__c)) || (mdfe.Taker_CNPJ__c!=null && accCNPJ.contains(mdfe.Taker_CNPJ__c)) ){
                    mdfe.MDF_e_Status__c = 'Valid CNPJ';
                    mdfe.Is_CNPJ_Invalid__c = false;
                } else{
                    mdfe.MDF_e_Status__c = 'Invalid CNPJ';
                    mdfe.Is_CNPJ_Invalid__c = true;
                }
            }
        }
        
    }
    public void nfsCheck(Map<string,id> OldKeyMap,Map<string,id> NewRecordMap, string FileType , List<BFM_NFS__c> nfsRecord ,set<string> CNPJId){
        set<string> accCNPJ = new set<string>();
        Map<string,Account> mapacc = new Map<string,Account>();
        List<Account> acclist=[Select id,CNPJ__c,Vendor__c,Company_Code__c,Vendor_UF_State__c from Account where CNPJ__c IN:CNPJId];
        for(Account ac : acclist){
            accCNPJ.add(ac.CNPJ__c);
            mapacc.put(ac.CNPJ__c, ac);
        }
        for(BFM_NFS__c nfs : nfsRecord){
            if(mapacc.containskey(nfs.Vendor_s_CNPJ_or_CPF__c)){
                nfs.Carrier__c = mapacc.get(nfs.Vendor_s_CNPJ_or_CPF__c).id;
            }
            
            if(mapacc.containskey(nfs.Service_Taker_CNPJ__c)){
                nfs.Service_Taker__c= mapacc.get(nfs.Service_Taker_CNPJ__c).id;
            }
            
            if(nfs.NFS_Mandatory_Field_Status__c != Label.BFM_Validation_Error){
                if(OldKeyMap.containsKey(nfs.NFS_Number__c+nfs.NFS_Series__c+nfs.Vendor_s_CNPJ_or_CPF__c+nfs.NFS_Emission_Date_Time__c.year())){
                    nfs.NFS_Status__c = Label.BFM_Validation_Error; 
                    nfs.Is_Duplicated__c = true;
                } else{
                    nfs.NFS_Status__c = Label.BFM_Validation_Ok;
                    nfs.Is_Duplicated__c = false;
                }
            }
            
            if(!nfs.Is_Duplicated__c){
                if((nfs.Vendor_s_CNPJ_or_CPF__c!=null && accCNPJ.contains(nfs.Vendor_s_CNPJ_or_CPF__c)) && (nfs.Service_Taker_CNPJ__c!=null && accCNPJ.contains(nfs.Service_Taker_CNPJ__c)) ){
                    nfs.NFS_Status__c = 'Valid CNPJ';
                    nfs.Is_CNPJ_Invalid__c = false;
                    if(nfs.NFS_Link_Check_Status__c == null){
                        nfs.NFS_Link_Check_Status__c = 'Pending Link';
                        nfs.NFS_Status__c = 'Pending Link';
                    }
                } else{
                    nfs.NFS_Status__c = 'Invalid CNPJ';
                    nfs.Is_CNPJ_Invalid__c = true;
                }
            }
        }
        
    }
    
    //Debit Note
    public void debitnoteCheck(Map<string,id> OldKeyMap,Map<string,id> NewRecordMap, string FileType , List<BFM_Debit_Note__c> dnRecord ,set<string> CNPJId){
        set<string> accCNPJ = new set<string>();
        map<string,account> mapAccount = new map<string,account>();
        List<Account> acclist=[Select id,CNPJ__c,Vendor__c,Company_Code__c from Account where CNPJ__c IN:CNPJId];
        for(Account ac : acclist){
            accCNPJ.add(ac.CNPJ__c);
            mapAccount.put(ac.CNPJ__c,ac);
        }
        for(BFM_Debit_Note__c dn : dnRecord){
            if(mapAccount.containsKey(dn.Vendor_s_CNPJ_or_CPF__c)){
                dn.carrier_account__c = mapAccount.get(dn.Vendor_s_CNPJ_or_CPF__c).id;
                dn.Vendor_Code__c = mapAccount.get(dn.Vendor_s_CNPJ_or_CPF__c).Vendor__c;                              
            }
            if(mapAccount.containsKey(dn.Service_Taker_CNPJ__c)){
                dn.Unilever_Account__c = mapAccount.get(dn.Service_Taker_CNPJ__c).id;  
                //dn.Company_Code__c = mapAccount.get(dn.Service_Taker_CNPJ__c).Company_Code__c;                            
            }
            if(OldKeyMap.containsKey(dn.DN_Number__c)){
                dn.Debit_Note_Status__c = Label.BFM_Validation_Error;    
                dn.Is_Duplicated__c = true;
            } else {
                dn.Debit_Note_Status__c = Label.BFM_Validation_Ok;
                dn.Is_Duplicated__c = false;
            }
            if(!dn.Is_Duplicated__c){
                if((dn.Vendor_s_CNPJ_or_CPF__c!=null && accCNPJ.contains(dn.Vendor_s_CNPJ_or_CPF__c)) && (dn.Service_Taker_CNPJ__c!=null && accCNPJ.contains(dn.Service_Taker_CNPJ__c)) ){
                    dn.Debit_Note_Status__c = 'Valid CNPJ';
                    dn.Is_CNPJ_Invalid__c = false;
                } else{
                    dn.Debit_Note_Status__c = 'Invalid CNPJ';
                    dn.Is_CNPJ_Invalid__c = true;                    
                }
            }
        }
        
    }
    
  //POD
    public void podCheck(Map<string,id> OldKeyMap,Map<string,BFM_NF_e__c> nferecordmap, string FileType , List<BFM_POD__c> podRecord ,set<string> CNPJId){
        set<string> accCNPJ = new set<string>();
        //map<string,account> mapAccount = new map<string,account>();
        List<Account> acclist=[Select id,CNPJ__c,Vendor__c,Company_Code__c from Account where CNPJ__c IN:CNPJId];
        for(Account ac : acclist){
            accCNPJ.add(ac.CNPJ__c);
            // mapAccount.put(ac.CNPJ__c,ac);
        }
        
        for(BFM_POD__c pod : podRecord){
            // if(pod.POD_Status__c== 'In Progress'){
            if(pod.NF_e__c==null && nferecordmap.containskey(pod.NF_e_Access_Key__c)){
                pod.NF_e__c = nferecordmap.get(pod.NF_e_Access_Key__c).id;
            }  
            if(OldKeyMap.containsKey(pod.NF_e_Access_Key__c ) || !nferecordmap.containskey(pod.NF_e_Access_Key__c)){
                pod.Is_Duplicated__c = true;
                //pod.POD_Status__c= Label.BFM_Validation_Error;               
            } else{
                pod.Is_Duplicated__c = false;
               // pod.POD_Status__c= Label.BFM_Validation_Ok;
            }
            
            if(!pod.Is_Duplicated__c){
                system.debug(nferecordmap.get(pod.NF_e_Access_Key__c).CNPJ_destination__c);
                if((nferecordmap.get(pod.NF_e_Access_Key__c).CNPJ_destination__c!=null && accCNPJ.contains(nferecordmap.get(pod.NF_e_Access_Key__c).CNPJ_destination__c)) && (nferecordmap.get(pod.NF_e_Access_Key__c).CNPJ_destination__c!=null && accCNPJ.contains(nferecordmap.get(pod.NF_e_Access_Key__c).CNPJ_destination__c)) ){
                    pod.Is_CNPJ_Invalid__c = false;
                   // pod.POD_Status__c = 'Valid CNPJ';
                } else{
                    pod.Is_CNPJ_Invalid__c = true;
                   // pod.POD_Status__c = 'Invalid CNPJ';
                }
            }
            if(!pod.Is_CNPJ_Invalid__c){           
                if(pod.Upload_date__c!=null && pod.Upload_date__c.date()==Date.valueOf(nferecordmap.get(pod.NF_e_Access_Key__c).NF_e_creation_date__c)){                   
                    pod.POD_Date__c= pod.Upload_date__c.date();
                } 
                if(pod.POD_Date__c!=null && pod.NF_e_Access_Key__c!=null && pod.POD_Date__c>=Date.valueOf(nferecordmap.get(pod.NF_e_Access_Key__c).NF_e_creation_date__c)){
                    pod.POD_Date_Check_Status__c = 'Date Ok';
                    //pod.POD_Status__c = 'Date Ok';                   
                }
                else{
                    pod.POD_Date_Check_Status__c = 'Date Not Ok';
                    //pod.POD_Status__c = 'Date Not Ok';
                }
            }
            
            if(pod.POD_Date_Check_Status__c =='Date Ok' && pod.POD_Status__c!=null){           
                
                if(nferecordmap.containskey(pod.NF_e_Access_Key__c) && nferecordmap.get(pod.NF_e_Access_Key__c).SES__c!=null){
                    pod.POD_Link_Check_Status__c = 'Link Ok';
                 //   pod.POD_Status__c = 'Link Ok';
                    
                }
                else{
                    pod.POD_Link_Check_Status__c = 'Pending Link';
                  //  pod.POD_Status__c = 'Pending Link';
                }
            }
            
            // }
        }
    }
}