public class BFM_ValidateCNPJ {
    public static void defineUnileverAccount(List<BFM_CT_e__c> cteList){
        Set<String> setCnpjServiceTaker = new Set<String>();
        Map<String, BFM_CT_e__c> mapCteCnpjs = new Map<String, BFM_CT_e__c>();
        Map<String, BFM_CT_e__c> mapCteVendor = new Map<String, BFM_CT_e__c>();
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
                
                // Create Map to Validate Company Code (CT-e-> CNPJ Service Taker  vs Account-> CNPJ__c);
                if(!mapCteCnpjs.containsKey(cte.UF_Service_Taker__c+cte.CNPJ_Service_Taker__c)) {
                    System.debug('cte.UF_Service_Taker__c' + cte.UF_Service_Taker__c);
                    System.debug('cte.CNPJ_Service_Taker__c' + cte.CNPJ_Service_Taker__c);
                    mapCteCnpjs.put(cte.UF_Service_Taker__c+cte.CNPJ_Service_Taker__c, cte);
                }
                
                // Create Map to Validate Company Code (Objects Fiscal Docs).vendor_code__c+unilever_company_code__c)
                if(!mapCteCnpjs.containsKey(cte.Vendor_code__c+cte.CNPJ_issuer__c)) {
                    System.debug('cte.Vendor_code__c' + cte.Vendor_code__c);
                    System.debug('cte.CNPJ_issuer__c' + cte.CNPJ_issuer__c);
                    mapCteVendor.put(cte.Vendor_code__c+cte.CNPJ_issuer__c, cte);
                }
            }
            cte.Unilever_Account__c = null;
            cte.Is_Company_Code_Ok__c = false;
            cte.Is_Vendor_Code_Ok__c = false;
        }
        
        Set<String> setCnpj = new Set<String>();
        for(BFM_CT_e__c cteCnpjs: mapCteCnpjs.values()){
            setCnpj.add(cteCnpjs.CNPJ_Service_Taker__c);
        }
        
        /* VALIDATE IF COMPANY CODE IS OK : THAT RULE HAS BEEN ADDED BY PAULO SPREADSHEET ROW NUMBER 5 : COMPANY CODE CHECK*/
        /* MUST BE UNILEVER ACCOUNT */
        System.debug('setCnpj : ' + setCnpj);
        RecordType unileverAccount  = [SELECT id from RecordType where DeveloperName = 'BFM_Unilever_Account'];
        List<Account> accList = [SELECT ID, CNPJ__c, Vendor_UF_State__c FROM Account 
                                 WHERE CNPJ__c =: setCnpj AND RecordType.id =: unileverAccount.id];
        
        System.debug('accList' + accList);
        for(Account acc : accList) {
            System.debug('acc.Vendor_UF_State__c' + acc.Vendor_UF_State__c);
            System.debug('acc.CNPJ__c' + acc.CNPJ__c);
            if(mapCteCnpjs.containsKey(acc.Vendor_UF_State__c+acc.CNPJ__c)) {
                mapCteCnpjs.get(acc.Vendor_UF_State__c+acc.CNPJ__c).Unilever_Account__c = acc.id;
                mapCteCnpjs.get(acc.Vendor_UF_State__c+acc.CNPJ__c).Is_Company_Code_Ok__c = true;
            } 
        }
        
        /* VALIDATE IF VENDOR CODE IS OK : THAT RULE HAS BEEN ADDED BY PAULO SPREADSHEET ROW NUMBER 6 : Vendor x Company Code*/
        /* MUST BE FROM CARRIER */        
        Set<String> setVendor = new Set<String>();
        Set<String> setCarrierCnpj = new Set<String>();
        for(BFM_CT_e__c cteVendor: mapCteVendor.values()){
            setVendor.add(cteVendor.Vendor_code__c);
            setCarrierCnpj.add(cteVendor.CNPJ_issuer__c);
        }    
        System.debug('setVendor' + setVendor);
        
        List<Account> carrierList = [SELECT ID, CNPJ__c, Vendor__c FROM Account WHERE Vendor__c =: setVendor AND CNPJ__C =: setCarrierCnpj];     
        System.debug('carrierList' + carrierList);
        
        System.debug('carrierList' + accList);
        for(Account carrier : carrierList) {
            System.debug('carrier.Vendor__c' + carrier.Vendor__c);
            System.debug('carrier.CNPJ__c' + carrier.CNPJ__c);
            if(mapCteVendor.containsKey(carrier.Vendor__c+carrier.CNPJ__c)) {
                mapCteVendor.get(carrier.Vendor__c+carrier.CNPJ__c).Is_Vendor_Code_Ok__c = true;
            } 
        }        
    }
}