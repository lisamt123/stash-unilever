public with sharing class BFM_linkMDFefuture {
  // @future (callout=true)
    public static void mdfeupdate(List<id> listMdfe,map<id,integer> mapmcte,map<id,integer> mapncte){
         List<BFM_MDF_e__c> listmdfupdate = new List<BFM_MDF_e__c>(); 
        for(id mdf: listMdfe){
            if(mapncte.get(mdf)==null){
                mapncte.put(mdf,0);
            }
            
            system.debug('mmmmmm'+mapncte.get(mdf)+'pppp'+mapmcte.get(mdf));
            if(mapncte.get(mdf)>0 && mapncte.get(mdf)== mapmcte.get(mdf)){
                BFM_MDF_e__c bmdf = new BFM_MDF_e__c(id=mdf);
                bmdf.MDF_e_Status__c ='Link Ok'; 
                listmdfupdate.add(bmdf);   
            }
            else{
                BFM_MDF_e__c bmdf = new BFM_MDF_e__c(id=mdf);
                bmdf.MDF_e_Status__c ='Pending Link'; 
                listmdfupdate.add(bmdf);
            }
        }
         if(!listmdfupdate.isEmpty()){
            update listmdfupdate;
        }
    }
}