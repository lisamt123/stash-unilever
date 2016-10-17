public without sharing class BFM_Link_MDFCTe_onsave{
  //  @InvocableMethod 
    public static void linkmdfcte(List<BFM_MDF_e__c> listMdfe){
        Map<string,BFM_MDF_e__c> mapCTkey = new Map<string,BFM_MDF_e__c>();
        map<id,List<BFM_CT_e__c>> map2cte = new map<id,List<BFM_CT_e__c>>();
         map<id,integer> mapncte = new map<id,integer>();
        List<BFM_CT_e__c> listCTe = new List<BFM_CT_e__c>();
        List<BFM_CT_e__c> listCTeupdate = new List<BFM_CT_e__c>();
        List<BFM_MDF_e__c> listmdfupdate = new List<BFM_MDF_e__c>();
        if(!listMdfe.isEmpty()){
            for(BFM_MDF_e__c mdf: listMdfe){
                if(mdf.CT_e_Access_Key__c!=null){
                    List<String> MdfCte = mdf.CT_e_Access_Key__c.split(';');
                     mapncte.put(mdf.id,mdfcte.size());
                    for(string mc: MdfCte){
                        mapCTkey.put(mc,mdf);
                    }
                }
            }
        }
        system.debug(mapCTkey.keyset());
        if(!mapCTkey.isEmpty()){
            listCTe = [select Id,CT_e_key__c,MDF_e__c from BFM_CT_e__c where CT_e_key__c in : mapCTkey.keyset() and CT_e_Duplicate_Record_Status__c=:Label.BFM_Validation_OK and CT_e_Valid_CNPJ_Status__c = 'Valid CNPJ'];
        }
        for(BFM_CT_e__c  cte: listCTe){
            if(cte.MDF_e__c==null){
                cte.MDF_e__c = mapCTkey.get(cte.CT_e_key__c).id;
                listCTeupdate.add(cte);
            }
            
            List<BFM_CT_e__c> listct = new List<BFM_CT_e__c>();
             if(!map2cte.containskey(cte.MDF_e__c)){
                listct.add(cte);
                map2cte.put(cte.MDF_e__c,listct);
            }
            else{
                listct = map2cte.get(cte.MDF_e__c);
                listct.add(cte);
                map2cte.put(cte.MDF_e__c,listct);
            }
        }
         if(!listCTeupdate.isEmpty()){
            update listCTeupdate;
        }
        
        List<id> listmdfids = new list<id>();
        map<id,integer> mapMcte = new map<id,integer>();
        
        for(BFM_MDF_e__c mdf: listMdfe){
            if(mapncte.get(mdf.id)==null){
                mapncte.put(mdf.id,0);
            }
            integer updatedcte=0;
            if(map2cte.get(mdf.id)==null){
                updatedcte =0;
            }
            else{
                updatedcte = map2cte.get(mdf.id).size();
            }
            system.debug('mmmmmm'+mapncte.get(mdf.id)+'pppp'+map2cte.get(mdf.id));
            if(mdf.CT_e_Access_Key__c!=null && mapncte.get(mdf.id)>0 && mapncte.get(mdf.id)== updatedcte){
                mdf.MDF_e_Status__c ='Link Ok'; 
                mdf.MDF_e_Link_Check_Status__c = 'Link Ok';
                listmdfupdate.add(mdf);   
            }
            else{
                mdf.MDF_e_Status__c ='Pending Link'; 
                mdf.MDF_e_Link_Check_Status__c = 'Pending Link';
                listmdfupdate.add(mdf);
            }
        }
         if(!listmdfupdate.isEmpty()){
          //  update listmdfupdate;
        }
        
    }
}