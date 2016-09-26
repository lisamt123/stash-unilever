global class BFM_Batch_CTeStatus implements DataBase.Batchable<sobject>{
    global DataBase.QueryLocator start(DataBase.BatchableContext BC){
    	string query= 'select id,name,Cte_Emission_date_time__c,CT_e_Request_for_Cancel__c,Cte_Status__c from BFM_CT_e__c where CT_e_Request_for_Cancel__c=true and Cte_Emission_date_time__c <=:Today()-7';         
        return DataBase.getQueryLocator(query);        
    }
    global void execute(DataBase.BatchableContext BC, List<BFM_CT_e__c> ctes){
        List<BFM_CT_e__c> ctelist = new List<BFM_CT_e__c>();
    	//
 
        for(BFM_CT_e__c objcte : ctes){
        	objcte.Cte_Status__c = 'Cancelled';
            ctelist.add(objcte);
        }
        update ctelist;
    }
    global void finish(Database.BatchableContext BC){
            
    }
}