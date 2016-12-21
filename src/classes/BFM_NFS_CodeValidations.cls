public class BFM_NFS_CodeValidations{
    public static void nfsCheck(List<BFM_NFS__c> nfsRecords,set<id> setcodevalnfs){
        List<BFM_NFS__c> nfsTRecords = new List<BFM_NFS__c>();
        nfsTRecords = [select id,Shipment__c,Occurrence__c, (select id,Unilever_company_code__c,Vendor_Code__c,Stage__r.Shipment__r.Carrier_Account__r.cnpj__c,Stage__r.Shipment__r.Unilever_Company__r.region__c,Occurrence__r.Approval_Date_1__c,Occurrence__r.Approval_Date_2__c,Occurrence__r.Approval_Date_3__c,Occurrence__r.Approval_Date_4__c,Occurrence__r.Approval_Date_5__c,Occurrence__r.Approval_Date_6__c from SESNFSs__r) from BFM_NFS__c where id in : nfsRecords];        
        system.debug('--->'+nfsTRecords);
        map<id,List<BFM_SES__c>> mapnfsSes = new map<id,List<BFM_SES__c>>();
        List<id> shipsid = new List<id>();
        List<id> occrid = new List<id>();
        List<BFM_SES__c> seslist = new List<BFM_SES__c>();
        for(BFM_NFS__c nfs: nfsTRecords){
            mapnfsSes.put(nfs.id,nfs.SESNFSs__r);
            if(nfs.Shipment__c!=null){
            	shipsid.add(nfs.Shipment__c);
            }
            if(nfs.Occurrence__c!=null){
            	occrid.add(nfs.Occurrence__c);
            }
            system.debug('nnnnnnnnnnnnnnnnnnmmmmmmmmmmmm'+nfs.SESNFSs__r);
        }
        system.debug('sid--->'+shipsid);
        system.debug('ocid--->'+occrid);
        
        if(shipsid!=null){
           seslist=[SELECT Id, Name, Shipment__c FROM BFM_SES__c where Shipment__c=:shipsid];
           List<BFM_NFS__c> nfslist = new List<BFM_NFS__c>();
           for(BFM_NFS__c nfss: nfsTRecords){
            	//nfss.id =    
           }
        }
        for(BFM_NFS__c nfs: nfsRecords){
            if(nfs.NFS_Link_Check_Status__c == 'Link Ok' && !setcodevalnfs.contains(nfs.id)){
                integer codecount=0,vendorcount=0,datecount=0;
                if(!mapnfsSes.isEmpty()){
                for(BFM_SES__c ses:mapnfsSes.get(nfs.id) ){
                system.debug('nnnnnnnnnnnnnnnnnn'+nfs.Service_Taker_Company_UF__c);
                system.debug('ssssssssssssssssss'+ses.Unilever_company_code__c);
                   if(nfs.Service_Taker_Company_UF__c!=null && nfs.Service_Taker_Company_UF__c==ses.Stage__r.Shipment__r.Unilever_Company__r.region__c){
                        codecount++;
                    }
                    if(nfs.Vendor_s_CNPJ_or_CPF__c!=null && nfs.Vendor_s_CNPJ_or_CPF__c==ses.Stage__r.Shipment__r.Carrier_Account__r.cnpj__c){
                        vendorcount++;
                    }
                    if(nfs.NFS_Emission_Date_Time__c!=null && ((date.valueof(nfs.NFS_Emission_Date_Time__c)<ses.Occurrence__r.Approval_Date_1__c) ||
                    (date.valueof(nfs.NFS_Emission_Date_Time__c)<ses.Occurrence__r.Approval_Date_2__c) || (date.valueof(nfs.NFS_Emission_Date_Time__c)<ses.Occurrence__r.Approval_Date_3__c) ||
                    (date.valueof(nfs.NFS_Emission_Date_Time__c)<ses.Occurrence__r.Approval_Date_4__c) || (date.valueof(nfs.NFS_Emission_Date_Time__c)<ses.Occurrence__r.Approval_Date_5__c) ||
                    (date.valueof(nfs.NFS_Emission_Date_Time__c)<ses.Occurrence__r.Approval_Date_6__c))){
                        datecount++;
                    }    
                
                }
                if(codecount>0){
                    nfs.NFS_Company_Code_Check_Status__c = 'Company Code Ok';
                    nfs.NFS_Status__c = 'Company Code Ok';
                }
                else{
                    nfs.NFS_Company_Code_Check_Status__c = 'Wrong Company Code';
                    nfs.NFS_Status__c = 'Wrong Company Code';
                }
                if(nfs.NFS_Company_Code_Check_Status__c == 'Company Code Ok'){
                if(vendorcount>0){
                    nfs.NFS_Vendor_Check_Status__c = 'Vendor Ok';
                    nfs.NFS_Status__c = 'Vendor Ok';
                }
                
                else{
                    nfs.NFS_Vendor_Check_Status__c = 'Wrong Vendor';
                    nfs.NFS_Status__c = 'Wrong Vendor';
                }
                }
                if(nfs.NFS_Vendor_Check_Status__c == 'Vendor Ok'){
                if(datecount>0){
                    nfs.NFS_Date_Check_Status__c = 'Date Not Ok';
                    nfs.NFS_Status__c = 'Date Not Ok';
                }
                else{
                    nfs.NFS_Date_Check_Status__c = 'Date Ok';
                    nfs.NFS_Status__c = 'Date Ok';
                }
                }
                
                }
                
                system.debug('LLLLLLLLLLLLLLL'+nfs.NFS_Link_Check_Status__c);
            }
                
            
        }
    }
}