public class BFM_Sefazvalidation_CC{
    @future(callout=true)
    public static void sendMDFEtoSefaz(set<id> setids,string objname){
        List<BFM_MDF_e__c> listmdfe = new List<BFM_MDF_e__c>();
        list<BFM_MDF_e__c> listupdatemdfe = new List<BFM_MDF_e__c>();
        List<string> errors = new List<string>();  
        
        listmdfe = [select id,MDFE_Access_Key__c,External_File_Path__c from BFM_MDF_e__c where id in: setids];        
                     
        
                       
        for(BFM_MDF_e__c mdf: listmdfe){            
            string xmlBody = BFM_AmazonConnector.getFile(mdf.External_File_Path__c);
            string accessKey = mdf.MDFE_Access_Key__c;
            system.debug('sssssssssssss'+xmlBody);
            system.debug('sssssssssssss'+accesskey);
            HttpResponse response = BFM_GeneralServiceCalls.publishXMLforValidation(xmlBody,accessKey);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
               // isSuccess = true;
               mdf.MDF_e_Sefaz_Status__c = 'Sefaz Ok';
               mdf.MDF_e_Status__c = 'Sefaz Ok';
               listupdatemdfe.add(mdf);
                    
            } else{
                //isSuccess = false;
                mdf.MDF_e_Sefaz_Status__c = 'Sefaz Invalid';
                mdf.MDF_e_Status__c = 'Sefaz Invalid';
                String errorMessage = String.format(Label.BFM_Integration_Failure, new List<String>{String.valueOf(response.getStatusCode()),  
                                                                                response.getStatus(),
                                                                                response.getBody()});
                errors.add(errorMessage);
                listupdatemdfe.add(mdf);
                
            }
        }
        if(!listupdatemdfe.isEmpty()){
            update listupdatemdfe;
        }
                 
    }
    @future(callout=true)
    public static void sendCCEtoSefaz(set<id> setids,string objname){
        List<BFM_CC_e__c> listcce = new List<BFM_CC_e__c>();
        list<BFM_CC_e__c> listupdatecce = new List<BFM_CC_e__c>();
        List<string> errors = new List<string>();  
        
        listcce = [select id,CC_e_Key__c,External_File_Path__c,CC_e_Status__c,CC_e_Sefaz_Check_Status__c from BFM_CC_e__c where id in: setids];        
                                            
        for(BFM_CC_e__c cce: listcce){            
            string xmlBody = BFM_AmazonConnector.getFile(cce.External_File_Path__c);
            string accessKey = cce.CC_e_Key__c;
            system.debug('sssssssssssss'+xmlBody);
            system.debug('sssssssssssss'+accesskey);
            HttpResponse response = BFM_GeneralServiceCalls.publishXMLforValidation(xmlBody,accessKey);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
               // isSuccess = true;
               cce.CC_e_Sefaz_Check_Status__c = 'Sefaz Ok';
               cce.CC_e_Status__c = 'Sefaz Ok';              
               listupdatecce.add(cce);
                    
            } else{
                //isSuccess = false;
                cce.CC_e_Sefaz_Check_Status__c = 'Sefaz Invalid';
                cce.CC_e_Status__c = 'Sefaz Invalid';
                String errorMessage = String.format(Label.BFM_Integration_Failure, new List<String>{String.valueOf(response.getStatusCode()),  
                                                                                response.getStatus(),
                                                                                response.getBody()});
                errors.add(errorMessage);
                listupdatecce.add(cce);
                
            }
        }
        if(!listupdatecce.isEmpty()){
            update listupdatecce;
        }
                 
    }
     @future(callout=true)
    public static void sendCTEtoSefaz(set<id> setids,string objname){
        List<BFM_CT_e__c> listcte = new List<BFM_CT_e__c>();
        list<BFM_CT_e__c> listupdatecte = new List<BFM_CT_e__c>();
        List<string> errors = new List<string>();  
        
        listcte = [select id,CT_e_key__c,External_File_Path__c,CT_e_Sefaz_Check_Status__c,Cte_Status__c from BFM_CT_e__c where id in: setids];        
                     
        
                       
        for(BFM_CT_e__c cte: listcte){            
            string xmlBody = BFM_AmazonConnector.getFile(cte.External_File_Path__c);
            string accessKey = cte.CT_e_key__c;
            //system.debug('sssssssssssss'+xmlBody);
            //system.debug('sssssssssssss'+accesskey);
            
            HttpResponse response = BFM_GeneralServiceCalls.publishXMLforValidation(xmlBody,accessKey);
            
            
            
            
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201){
               // isSuccess = true;
               cte.CT_e_Sefaz_Check_Status__c= 'Sefaz Ok';
               cte.Cte_Status__c = 'Sefaz Ok';
               listupdatecte.add(cte);
                    
            } else{
                //isSuccess = false;
                cte.CT_e_Sefaz_Check_Status__c = 'Sefaz Invalid';
                cte.Cte_Status__c = 'Sefaz Invalid';
                String errorMessage = String.format(Label.BFM_Integration_Failure, new List<String>{String.valueOf(response.getStatusCode()),  
                                                                                response.getStatus(),
                                                                                response.getBody()});
                errors.add(errorMessage);
                listupdatecte.add(cte);
                
            }
        }
        if(!listupdatecte.isEmpty()){
            update listupdatecte;
        }
                 
    }

}