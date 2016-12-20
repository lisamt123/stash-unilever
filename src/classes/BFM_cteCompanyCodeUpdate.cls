public class BFM_cteCompanyCodeUpdate {
    
    public static void cteCompanycodeupdate(set<id> cteId){
        If(BFM_CheckRecursive.firstRun==true){
            BFM_CheckRecursive.firstRun=false;
            List<BFM_CT_e__c> cteList =[Select id,Company_Code__c, (select Unilever_company_code__c from SESs__r)  from BFM_CT_e__c where id IN:cteId];  
            for(BFM_CT_e__c cte:cteList){
                if(cte.SESs__r.size()>0){
                    cte.Company_Code__c=cte.SESs__r[0].Unilever_company_code__c;
                }
            }
            //update cteList;
            Database.SaveResult[] resultscte = database.update(cteList,false);
            for (Database.SaveResult sr : resultscte ){
                if (sr.isSuccess()){
                    System.debug('----resultscte---'+sr);
                    System.debug('resultscte ' + sr.getId());
                }
                else {
                    for(Database.Error err : sr.getErrors()) {
                        string Msg= ' The following error has occurred.'+err.getStatusCode() +': ' + err.getMessage()+' fields that affected this error: '+ err.getFields();
                        System.debug('Msg--->'+Msg);                           
                        
                    }
                }
            }
        }
    }
}