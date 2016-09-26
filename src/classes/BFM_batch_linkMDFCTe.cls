global class BFM_batch_linkMDFCTe implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,Name,CT_e_Access_Key__c,MDF_e_Status__c ,MDFE_Access_Key__c,(select id from CT_es__r) FROM BFM_MDF_e__c where MDF_e_Status__c =\'Pending Link\' ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<BFM_MDF_e__c> scope)
    {    
        set<string> setctekey = new set<string>();
        List<BFM_CT_e__c> listCTe = new List<BFM_CT_e__c>();
        List<BFM_CT_e__c> listCTeupdate = new List<BFM_CT_e__c>();
        Map<string,BFM_MDF_e__c> mapCTkey = new Map<string,BFM_MDF_e__c>();
        map<id,integer> mapncte = new map<id,integer>();
        map<id,integer> map1cte = new map<id,integer>();
        map<id,List<BFM_CT_e__c>> map2cte = new map<id,List<BFM_CT_e__c>>();
        for(BFM_MDF_e__c mdf: scope){
            if(mdf.CT_e_Access_Key__c!=null){
                List<String> MdfCte = mdf.CT_e_Access_Key__c.split(';');
                mapncte.put(mdf.id,mdfcte.size());
                
                map1cte.put(mdf.id,mdf.CT_es__r.size());
                for(string mc: MdfCte){
                    mapCTkey.put(mc,mdf);
                }
                system.debug('sssssssss'+mapCTkey);  
            }   
        }   
        if(!mapCTkey.isEmpty()){
            listCTe = [select Id,CT_e_key__c,MDF_e__c from BFM_CT_e__c where CT_e_key__c in : mapCTkey.keyset() and MDF_e__c=null ];
        }
        for(BFM_CT_e__c  cte: listCTe){
            cte.MDF_e__c = mapCTkey.get(cte.CT_e_key__c).id;
            listCTeupdate.add(cte);
            List<BFM_CT_e__c> listct = new List<BFM_CT_e__c>();
            integer count=0;
            if(!map2cte.containskey(cte.MDF_e__c)){
                listct.add(cte);
                count = listct.size();
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
        List<BFM_MDF_e__c> listmdfupdate = new List<BFM_MDF_e__c>(); 
        for(BFM_MDF_e__c mdf: scope){
            if(mapncte.get(mdf.id)==null){
                mapncte.put(mdf.id,0);
            }
            if(map1cte.get(mdf.id)==null){
                map1cte.put(mdf.id,0);
            }
            integer updatedcte=0;
            if(map2cte.get(mdf.id)==null){
                updatedcte =0;
            }
            else{
                updatedcte = map2cte.get(mdf.id).size();
            }
            system.debug('mmmmmm'+mapncte.get(mdf.id)+'gggg'+map1cte.get(mdf.id)+'pppp'+map2cte.get(mdf.id));
            if(mdf.CT_e_Access_Key__c!=null && mapncte.get(mdf.id)>0 && mapncte.get(mdf.id)== map1cte.get(mdf.id)+updatedcte){
                mdf.MDF_e_Status__c ='Link Ok'; 
                listmdfupdate.add(mdf);   
            }
        }
        if(!listmdfupdate.isEmpty()){
            update listmdfupdate;
        }
        
                
            
        
        
        
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}