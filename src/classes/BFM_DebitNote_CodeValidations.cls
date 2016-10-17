public class BFM_DebitNote_CodeValidations{
    public static void debitNoteCheck(List<BFM_Debit_Note__c> dnRecords,set<id> setdebitnote,boolean isinsert){
        List<BFM_Debit_Note__c> dnTRecords = new List<BFM_Debit_Note__c>();
        List<BFM_Occurrence__c> occTRecords = new List<BFM_Occurrence__c>();
       // dnTRecords = [select id,Occurrence__c from BFM_Debit_Note__c where id in : dnRecords];
        map<id,BFM_Occurrence__c> mapocc = new map<id,BFM_Occurrence__c>();
        set<id> setoccurenceids = new set<id>();
        for(BFM_Debit_Note__c dn: dnRecords){
            setoccurenceids.add(dn.Occurrence__c);
        }
        if(!setoccurenceids.isEmpty()){
            occTRecords = [select id,(select id,Vendor_Code__c,Unilever_company_code__c from SESOccs__r),Approval_Date_1__c,Approval_Date_2__c,Approval_Date_3__c,Approval_Date_4__c,Approval_Date_5__c,Approval_Date_6__c from BFM_Occurrence__c where id in:setoccurenceids];
        }
        for(BFM_Occurrence__c occ: occTRecords){
            mapocc.put(occ.id,occ);
        }
        for(BFM_Debit_Note__c dn: dnRecords){
            if(isinsert == true || !setdebitnote.contains(dn.id)){
            if(dn.Request_For_Cancellation__c == false && dn.Debit_Note_Status__c!='Cancelled'){
            if(mapocc.containskey(dn.Occurrence__c) && !mapocc.get(dn.Occurrence__c).SESOccs__r.isEmpty()){
                dn.DN_Link_Check_Status__c = 'Link Ok';
                dn.Debit_Note_Status__c = 'Link Ok';
            }
            else{
                dn.DN_Link_Check_Status__c = 'Pending Link';
                dn.Debit_Note_Status__c = 'Pending Link';
            }
            }
            if(dn.DN_Link_Check_Status__c == 'Link Ok' && dn.Request_For_Cancellation__c == false && dn.Debit_Note_Status__c!='Cancelled'){
                integer codecount=0,vendorcount=0,datecount=0;
                if(!mapocc.get(dn.Occurrence__c).SESOccs__r.isEmpty()){
                    for(BFM_SES__c ses: mapocc.get(dn.Occurrence__c).SESOccs__r){
                        if(dn.Company_Code__c!=null && dn.Company_Code__c==ses.Unilever_company_code__c){
                            codecount++;
                        }
                        if(dn.Vendor_Code__c!=ses.Vendor_Code__c){
                            vendorcount++;
                        }                                                                
                    }
                    if(codecount>0){
                        dn.DN_Company_Code_Check_Status__c = 'Company Code Ok';
                        dn.Debit_Note_Status__c = 'Company Code Ok';
                    }
                    else{
                        dn.DN_Company_Code_Check_Status__c = 'Wrong Company Code';
                        dn.Debit_Note_Status__c = 'Wrong Company Code';
                    }
                    if(dn.DN_Company_Code_Check_Status__c == 'Company Code Ok'){
                    if(vendorcount==0){
                        dn.DN_Vendor_Code_Check_Status__c = 'Vendor Ok';
                        dn.Debit_Note_Status__c = 'Vendor Ok';
                    }
                    else{
                        dn.DN_Vendor_Code_Check_Status__c = 'Wrong Vendor';
                        dn.Debit_Note_Status__c = 'Wrong Vendor';
                    }
                    }
                }
                if(mapocc.containskey(dn.Occurrence__c) && dn.DN_Emission_date_time__c!=null && (date.valueof(dn.DN_Emission_date_time__c)>mapocc.get(dn.Occurrence__c).Approval_Date_1__c)){
                    datecount++;
                }
                if(dn.DN_Vendor_Code_Check_Status__c == 'Vendor Ok'){
                if(datecount>0){
                    dn.DN_Date_Check_Status__c = 'Date Ok';
                    dn.Debit_Note_Status__c = 'Date Ok';
                }
                else{
                    dn.DN_Date_Check_Status__c = 'Date Not Ok';
                    dn.Debit_Note_Status__c = 'Date Not Ok';
                }
                }
                
                }
            }
            }
                
            
        
    }
}