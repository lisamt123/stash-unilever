public class BFM_companyvendorcheck {
    public static void companycodeandvendorcheck(List<BFM_CT_e__c> ctesesRecs){
        List<BFM_CT_e__c> CTelistrecs = new List<BFM_CT_e__c>();
        CTelistrecs =[select id,Unilever_company_code__c,Vendor_code__c,Link_Status__c,CT_e_Type__c,Cte_Emission_date_time__c,
                 (select id,SES_Line_Description__c,Unilever_company_code__c,Vendor_Code__c,Occurrence__r.Approval_Date_1__c,Occurrence__r.Approval_Date_2__c,
                  Occurrence__r.Approval_Date_3__c,Occurrence__r.Approval_Date_4__c,Occurrence__r.Approval_Date_5__c,
                  Occurrence__r.Approval_Date_6__c from SESs__r) from BFM_CT_e__c where id=:ctesesRecs];
        
        Map<id,List<BFM_SES__c>> mapcteses = new Map<id,List<BFM_SES__c>>();
        for(BFM_CT_e__c cte : CTelistrecs){
            mapcteses.put(cte.id, cte.SESs__r);   
        }
        
        for(BFM_CT_e__c cte : ctesesRecs){
            if(cte.Link_Status__c == 'Link OK' && cte.CT_e_Compatible__c != 'Compatible'){
                integer compcode=0, vendorcode=0, datecount=0, compatible=0;
                if(!mapcteses.isEmpty()){                    
                    for(BFM_SES__c sess : mapcteses.get(cte.id)){                    
                        system.debug('--->'+cte.Cte_Emission_date_time__c);
                        system.debug('--->'+sess.Occurrence__r.Approval_Date_1__c);
                        if(cte.Unilever_company_code__c!=null && cte.Unilever_company_code__c == sess.Unilever_company_code__c){
                            compcode++;    
                        }
                        if(cte.Vendor_code__c !=null &&  cte.Vendor_code__c == sess.Vendor_Code__c){
                            vendorcode++;                            
                        }
                        if(cte.Cte_Emission_date_time__c!=null && ((date.valueof(cte.Cte_Emission_date_time__c)<sess.Occurrence__r.Approval_Date_1__c) ||
                        (date.valueof(cte.Cte_Emission_date_time__c)<sess.Occurrence__r.Approval_Date_2__c) || (date.valueof(cte.Cte_Emission_date_time__c)<sess.Occurrence__r.Approval_Date_3__c) ||
                        (date.valueof(cte.Cte_Emission_date_time__c)<sess.Occurrence__r.Approval_Date_4__c) || (date.valueof(cte.Cte_Emission_date_time__c)<sess.Occurrence__r.Approval_Date_5__c) ||
                        (date.valueof(cte.Cte_Emission_date_time__c)<sess.Occurrence__r.Approval_Date_6__c))){
                        datecount++;
                        }
                        if(cte.CT_e_Type__c !=null && cte.CT_e_Type__c == sess.SES_Line_Description__c){
                        compatible++;   
                        }
                    } 
        
        if(compcode>0){
                    cte.Company_Code_Status__c = 'Company Code Ok';
                    cte.Cte_Status__c = 'Company Code Ok'; 
                }
                else{
                    cte.Company_Code_Status__c = 'Wrong Company Code';
                    cte.Cte_Status__c = 'Wrong Company Code'; 
                }
        //if(cte.Company_Code_Status__c == 'Company Code Ok'){
            if(vendorcode>0){
                        cte.Vendor_Code_Status__c = 'Vendor Ok';
                        cte.Cte_Status__c = 'Vendor Ok'; 
                    }
                    else{
                        cte.Vendor_Code_Status__c = 'Wrong Vendor';
                        cte.Cte_Status__c = 'Wrong Vendor'; 
                    }
                //}
                //if(cte.Vendor_Code_Status__c == 'Vendor Ok'){
            if(datecount>0){
                        cte.Date_check_status__c = 'Date Not Ok';
                        cte.Cte_Status__c = 'Date Not Ok'; 
                    }
                    else{
                        cte.Date_check_status__c = 'Date Ok';
                        cte.Cte_Status__c = 'Date Ok'; 
                    }
              // }
            if(compatible>0){
                        cte.CT_e_Compatible__c = 'Compatible';
                        cte.Cte_Status__c = 'Compatible'; 
                    }
                    else{
                        cte.CT_e_Compatible__c = 'Not Compatible'; 
                        cte.Cte_Status__c = 'Not Compatible';    
                    }              
            }
         }
      }
   }
}