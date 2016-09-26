public class BFM_NFS_CodeValidations{
    public static void nfsCheck(List<BFM_NFS__c> nfsRecords){
        List<BFM_NFS__c> nfsTRecords = new List<BFM_NFS__c>();
        nfsTRecords = [select id, (select id,Unilever_company_code__c,Vendor_Code__c,Occurrence__r.Approval_Date_1__c,Occurrence__r.Approval_Date_2__c,Occurrence__r.Approval_Date_3__c,Occurrence__r.Approval_Date_4__c,Occurrence__r.Approval_Date_5__c,Occurrence__r.Approval_Date_6__c from SESNFSs__r) from BFM_NFS__c where id in : nfsRecords];        
        map<id,List<BFM_SES__c>> mapnfsSes = new map<id,List<BFM_SES__c>>();
        for(BFM_NFS__c nfs: nfsTRecords){
            mapnfsSes.put(nfs.id,nfs.SESNFSs__r);
            system.debug('nnnnnnnnnnnnnnnnnnmmmmmmmmmmmm'+nfs.SESNFSs__r);
        }
         
        for(BFM_NFS__c nfs: nfsRecords){
            if(nfs.NFS_Link_Check_Status__c == 'Link Ok'){
                integer codecount=0,vendorcount=0,datecount=0;
                if(!mapnfsSes.isEmpty()){
                for(BFM_SES__c ses:mapnfsSes.get(nfs.id) ){
                system.debug('nnnnnnnnnnnnnnnnnn'+nfs.Service_Taker_Company_UF__c);
                system.debug('ssssssssssssssssss'+ses.Unilever_company_code__c);
                    if(nfs.Service_Taker_Company_UF__c!=null && nfs.Service_Taker_Company_UF__c==ses.Unilever_company_code__c){
                        codecount++;
                    }
                    if(nfs.Vendor_s_CNPJ_or_CPF__c!=ses.Vendor_Code__c){
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
                }
                else{
                    nfs.NFS_Company_Code_Check_Status__c = 'Wrong Company Code';
                }
                if(nfs.NFS_Company_Code_Check_Status__c == 'Company Code Ok'){
                if(vendorcount==0){
                    nfs.NFS_Vendor_Check_Status__c = 'Vendor Ok';
                }
                
                else{
                    nfs.NFS_Vendor_Check_Status__c = 'Wrong Vendor';
                }
                }
                if(nfs.NFS_Vendor_Check_Status__c == 'Vendor Ok'){
                if(datecount>0){
                    nfs.NFS_Date_Check_Status__c = 'Date Not Ok';
                }
                else{
                    nfs.NFS_Date_Check_Status__c = 'Date Ok';
                }
                }
                
                }
            }
                
            
        }
    }
}