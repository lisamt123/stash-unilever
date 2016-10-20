public class BFM_Link_CCECTE{
   // @invocablemethod
   
    public static void linkCCECTE(List<BFM_CC_e__c> listcce){
        set<string> setCTEids = new set<string>();
        set<string> setNFids = new set<string>();
        set<id> setCCeids = new set<id>();
        for(BFM_CC_e__c cc: listcce){
            setCCeids.add(cc.id);
        }
        List<BFM_CT_e__c> listCte = new List<BFM_CT_e__c>();
        List<BFM_NF_e_DF__c> listNFEDF = new List<BFM_NF_e_DF__c>();
        //List<BFM_CC_e__c> listQcce = new List<BFM_CC_e__c>();
        List<BFM_CC_e__c> listupdatecce = new List<BFM_CC_e__c>();
        map<string,id> mapcte = new map<string,id>();
        for(BFM_CC_e__c cce: listcce){
            if(cce.Related_CT_e_NF_e_DF_Key__c!= null && cce.Reference_Object_Type__c!= null){
                if(cce.Reference_Object_Type__c == 'CTE'){
                    setCTEids.add(cce.Related_CT_e_NF_e_DF_Key__c);
                }
                if(cce.Reference_Object_Type__c == 'NFE'){
                    setNFids.add(cce.Related_CT_e_NF_e_DF_Key__c);
                }
            }
        }
        if(!setCTEids.isEmpty()){
            listCte = [select id,CT_e_key__c from BFM_CT_e__c where CT_e_key__c in: setCTEids and CT_e_type__c = 'Normal'];
        }
        if(!setNFids.isEmpty()){
            listNFEDF = [select id,NF_e_key__c from BFM_NF_e_DF__c where NF_e_key__c in: setNFids];
        }
        if(!listCte.isEmpty()){
            for(BFM_CT_e__c cte : listCte){
                mapcte.put(cte.CT_e_key__c,cte.id);
            }
        }
        if(!listNFEDF.isEmpty()){
            for(BFM_NF_e_DF__c nfe : listNFEDF){
                mapcte.put(nfe.NF_e_key__c,nfe.id);
            }
        }
     //  listQcce = [select id,Related_CT_e_NF_e_DF_Key__c,Reference_Object_Type__c  from BFM_CC_e__c where id in: setCCeids];
         linkCCECTE_ext(listcce,mapcte);
        
        
    }
    public static void linkCCECTE_ext(List<BFM_CC_e__c> listcce, map<string,id> mapcte){
        for(BFM_CC_e__c cce: listcce){
            if(cce.CC_e_Valid_CNPJ_Status__c == 'Valid CNPJ'){
                if(cce.Reference_Object_Type__c == 'CTE' && mapcte.containsKey(cce.Related_CT_e_NF_e_DF_Key__c) && mapcte.get(cce.Related_CT_e_NF_e_DF_Key__c)!=null){
                    cce.CTe__c = mapcte.get(cce.Related_CT_e_NF_e_DF_Key__c);
                    cce.CC_e_Link_Check_Status__c = 'Link Ok';
                    cce.CC_e_Status__c = 'Link Ok';
                }
                if(cce.Reference_Object_Type__c == 'NFE' && mapcte.containsKey(cce.Related_CT_e_NF_e_DF_Key__c) && mapcte.get(cce.Related_CT_e_NF_e_DF_Key__c)!=null){
                    cce.NF_e_DF__c = mapcte.get(cce.Related_CT_e_NF_e_DF_Key__c);
                    cce.CC_e_Link_Check_Status__c = 'Link Ok';
                    cce.CC_e_Status__c = 'Link Ok';
                }
                if(cce.CTe__c==null && cce.NF_e_DF__c==null){
                cce.CC_e_Link_Check_Status__c = 'Pending Link';
                cce.CC_e_Status__c = 'Pending Link';
            }
                //listupdatecce.add(cce);
            }
            
        }
    }
    
}