/**
    * @author Abhinav Ranjan
    * @date 14/09/2016
    * @description: Batch class to link CT-e to SES.                                                                                   
    /Class Header Starts
    //Class Name:[BFM_Batch_LinkSESCTe]
    ---------------------------------------------------------------------------------------------------------------------------------
    //        DateTime           |  Email_id                    |     Description
    ---------------------------------------------------------------------------------------------------------------------------------
    //        14/09/2016     |~:abhinav.ranjan@unilever.com |    Batch class to link CT-e with status as 'Pending Link' to its related SES.    
**/
global class BFM_Batch_LinkSESCTe implements Database.Batchable<sObject>
{  Private Integer NFecount=0;
    Private integer TotNfeSESCount=0;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id,(select NF_e_access_key__c from BFM_NF_es__r) FROM BFM_CT_e__c WHERE Link_Status__c =\'Pending Link\' ';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<BFM_CT_e__c> scope)
    {           
        Map<string,id> mapCTeNfe = new Map<string,id>();
        list<BFM_SES__c> listSESupdate = new list<BFM_SES__c>();
        list<BFM_CT_e__c> listCTeLinkUpdate = new list<BFM_CT_e__c>();
        set<string> NfeSet = new set<string>();
        
        for(BFM_CT_e__c cte: scope){
            for(integer i=0;i<cte.BFM_NF_es__r.size();i++){
                mapCTeNfe.put(cte.BFM_NF_es__r[i].NF_e_access_key__c,cte.id);
            }   
        } 
        system.debug('mapCTeNfe---->'+mapCTeNfe);
        if(!mapCTeNfe.isEmpty()){
                list<BFM_SES__c> NfeSesList = [Select id,CT_E__c,(SELECT NF_e_access_key__c FROM NF_es__r) from BFM_SES__c where id IN(SELECT SES__c FROM BFM_NF_e__c WHERE NF_e_access_key__c IN : mapCTeNfe.Keyset())];
             system.debug('NfeSesList---->'+NfeSesList); 
            if(NfeSesList.size()>0){
              for(BFM_SES__c NfeSes: NfeSesList){
                   system.debug('CT-eRecord---->'+NfeSes);
             integer NfeSESCount=NfeSes.NF_es__r.size();
                    for(integer i=0;i<NfeSes.NF_es__r.size();i++){
                        if(mapCTeNfe.containsKey(NfeSes.NF_es__r[i].NF_e_access_key__c)){
                           NFecount =NFecount+1;


                        }
                    }
            system.debug('NFecount---->'+NFecount);
                    if(mapCTeNfe.size()>=NFecount && mapCTeNfe.size()>=NfeSESCount){
                    NfeSes.CT_E__c = mapCTeNfe.get(NfeSes.NF_es__r[0].NF_e_access_key__c);
                             listSESupdate.add(NfeSes);

                    }
            TotNfeSESCount=TotNfeSESCount+NfeSESCount;


                }
            }
             system.debug('listSESupdate---->'+listSESupdate);
        }
              if(listSESupdate != null){
                    Database.SaveResult[] updateRec = Database.update(listSESupdate,false);
                } 
        for(BFM_CT_e__c cte: scope){
            if(mapCTeNfe.size()==TotNfeSESCount){
            cte.Link_Status__c='Link OK';   
            listCTeLinkUpdate.add(cte);


            }
            else{
            cte.Link_Status__c='Missing NF-es on the CT-e';
            listCTeLinkUpdate.add(cte);


            }
        }
            if(listCTeLinkUpdate != null){
            Database.SaveResult[] updateRec = Database.update(listCTeLinkUpdate,false);

            }
    }     
      
    global void finish(Database.BatchableContext BC)
    {
    }
}