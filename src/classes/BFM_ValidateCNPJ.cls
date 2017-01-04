public class BFM_ValidateCNPJ {
    public static void defineUnileverAccount(List<BFM_CT_e__c> cteList){
        Set<String> setCnpjServiceTaker = new Set<String>();
        Map <String, BFM_CT_e__c> mapAccountCte = new Map<String, BFM_CT_e__c>();
        for(BFM_CT_e__c cte : cteList) {
            if(cte.Taker_Type__c != null) {
                if(cte.Taker_Type__c == '0' && cte.CNPJ_Goods_Sender__c != null) {
                    cte.CNPJ_Service_Taker__c = cte.CNPJ_Goods_Sender__c;
                    cte.City_Service_Taker__c = cte.City_Goods_Sender__c;
                    cte.City_Code_Service_Taker__c = cte.City_Code_Goods_Sender__c;
                    cte.UF_Service_Taker__c = cte.UF_Goods_Sender__c;                    
                }
                
                if(cte.Taker_Type__c == '1') {
                    if(cte.CNPJ_Cargo_Dispatcher__c != null) {
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Cargo_Dispatcher__c;
                        cte.City_Service_Taker__c = cte.City_Cargo_Dispatcher__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Cargo_Dispatcher__c;
                        cte.UF_Service_Taker__c = cte.UF_Cargo_Dispatcher__c;                         
                    } else if (cte.CNPJ_Goods_Sender__c != null ){
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Goods_Sender__c;
                        cte.City_Service_Taker__c = cte.City_Goods_Sender__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Goods_Sender__c;
                        cte.UF_Service_Taker__c = cte.UF_Goods_Sender__c;                           
                    }
                } 
                
                if(cte.Taker_Type__c == '2')
                    if (cte.CNPJ_Recipient__c != null) {
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Recipient__c;
                        cte.City_Service_Taker__c = cte.City_Recipient__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Recipient__c;
                        cte.UF_Service_Taker__c = cte.UF_Recipient__c;                        
                    } else if (cte.CNPJ_Destination__c != null) {
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Destination__c;
                        cte.City_Service_Taker__c = cte.City_Destination__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Destination__c;
                        cte.UF_Service_Taker__c = cte.UF_Destination__c;                         
                    }
                
                if(cte.Taker_Type__c == '3') {
                    if(cte.CNPJ_Destination__c != null) {
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Destination__c;
                        cte.City_Service_Taker__c = cte.City_Destination__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Destination__c;
                        cte.UF_Service_Taker__c = cte.UF_Destination__c;                         
                    } else if (cte.CNPJ_Recipient__c != null ){
                        cte.CNPJ_Service_Taker__c = cte.CNPJ_Recipient__c;
                        cte.City_Service_Taker__c = cte.City_Recipient__c;
                        cte.City_Code_Service_Taker__c = cte.City_Code_Recipient__c;
                        cte.UF_Service_Taker__c = cte.UF_Recipient__c;                           
                    }
                }
            }
            RecordType unileverAccount  = [SELECT id from RecordType where DeveloperName = 'BFM_Unilever_Account'];
            List<Account> accList = [SELECT CNPJ__c, id from Account where CNPJ__c =: cte.CNPJ_Service_Taker__c AND RecordType.id =: unileverAccount.id];
            
            if(accList.isEmpty()){
                cte.Unilever_Account__c = null;
            }
            
            for(Account acc : accList) {
                cte.Unilever_Account__c = acc.id;
                cte.Is_Company_Code_Ok__c = true;
            }
        }
    }
}