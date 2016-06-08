/**********************************************************************
Name: CPA_CNFTNF_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to show CNF/TNF Historical Data
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR         DATE            DETAIL Description
1.0         Pooja Kanani   3/03/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_CNFTNF_TriggerUtil{ 

    public static List<CPA_CNF_TNF__c> cnftnfsupdate;
    public static map<Id,CPA_CNF_TNF__c> cnftnfsInsertmap;
    public static map<Id,CPA_CNF_TNF__c> mapCNFTNF;
    //public static map<String,id> rt;
    /*******************************************************************
    Purpose: This method is used to create CNFTNF historical data
    Parameters: oldPWOList, newPWOList
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void CNFTNF_HistoricalData(List<CPA_project_work_order__c> oldPWOList,List<CPA_project_work_order__c> newPWOList){
        cnftnfsInsertmap = new map<Id,CPA_CNF_TNF__c>();
        cnftnfsupdate = new List<CPA_CNF_TNF__c>();
        mapCNFTNF = new map<id,CPA_CNF_TNF__c>();
        Set<id> pwoidSet = new Set<id>();
        for(CPA_project_work_order__c pwoid:newPWOList){
            pwoidSet.add(pwoid.id);
        }
        List<CPA_CNF_TNF__c> cnftnfList = [select id,dat_CNF_Accepted_Date__c ,num_CNF_Actual_Day_rate__c ,num_CNF_Actual_expenses__c ,num_CNF_Actual_fees_inclusive_of_discoun__c ,num_CNF_Actual_Fixed_Price_Contingency__c ,num_CNF_Actual_man_days__c ,num_CNF_Actual_PMO_tax__c ,dt_CNF_Actual_PWO_End_Date__c ,num_CNF_Actual_total_charges__c ,dat_CNF_Cancelled_Date__c ,ltxta_CNF_Comments__c ,txt_CNF_CR_number__c ,mpkl_CNF_Currency__c ,dat_CNF_Delivered_Date__c ,pkl_CNF_PIR_Status__c ,num_CNF_Planned_Day_rate__c ,num_CNF_Planned_expenses__c ,num_CNF_Planned_fees_inclusive_of_discou__c ,num_CNF_Planned_Fixed_Price_Contingency__c ,num_CNF_Planned_man_days__c ,num_CNF_Planned_PMO_tax__c ,dt_CNF_Planned_PWO_End_Date__c ,num_CNF_Planned_total_charges__c ,ltxta_CNF_Reason_for_Cancellation__c ,txta_CNF_Reason_for_Return__c ,dat_CNF_Resubmitted_Date__c ,dat_CNF_Returned_Date__c ,dat_CNF_Sent_for_Signature_Date__c ,dat_CNF_Signed_Date__c ,CNF_Status__c ,dat_CNF_Submitted_Date__c ,CNF_TAT__c ,eml_CNF_Unilever_Budget_Approver_Email__c ,txt_CNF_Unilever_Budget_Approver_Name__c ,txt_CNF_Unilever_Clarity_ID__c ,eml_CNF_Unilever_Content_Approver_Email__c ,txt_CNF_Unilever_Content_Approver_Name__c ,num_CNF_Variance_number_in_man_days__c,num_TNF_Actual_charges__c ,txt_TNF_Actual_effort_in_days__c ,txt_TNF_Approved_by__c ,TNF_Auto_ID__c ,dat_TNF_Cancelled_Date__c ,txt_TNF_Comments__c ,chk_TNF_Contract_Attached__c ,pkl_TNF_Currency__c ,dt_TNF_TD_Date_Notified__c ,dat_TNF_Delivered_Date__c ,dt_TNF_TD_Effective_Date__c ,txt_TNF_TD_Notice_Required__c ,txt_TNF_Other_Currency__c ,num_TNF_Planned_charges__c ,num_TNF_Planned_effort_in_days__c ,txta_TNF_Reason_for_Cancellation__c ,txta_TNF_Reason_for_Return__c ,txt_TNF_Reason_for_termination__c ,txt_TNF_Relocation_of_resources__c ,dat_TNF_Resubmitted_Date__c ,dat_TNF_Returned_Date__c ,dat_TNF_Sent_for_Signature__c ,dat_TNF_Signed_Date__c ,TNF_Status__c ,dat_TNF_Submitted_Date__c ,pkl_TNF_Terminated_by__c ,txt_TNF_Unilever_Clarity_ID__c ,eml_TNF_Unilever_Contact_Email__c ,txt_TNF_Unilever_Contact_Name__c ,num_TNF_Variance_in_charges__c ,num_TNF_Variance_in_effort__c ,PWO__c from CPA_CNF_TNF__c where PWO__c=: pwoidSet and CNF_Status__c!=:CPA_ConstantsForContractingAppClasses.CANCELLED and TNF_Status__c!=:CPA_ConstantsForContractingAppClasses.CANCELLED];
        
        if(cnftnfList!= null && cnftnfList.size()>0){
            for(CPA_CNF_TNF__c cnftnfrecord:cnftnfList){
                mapCNFTNF.put(cnftnfrecord.PWO__c,cnftnfrecord);
            }
        }
  
        for(Integer i = 0; i < newPWOList.size(); i++){
            if(oldPWOList[i].pkl_Status__c != null && newPWOList[i].pkl_Status__c != null && !oldPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SentForClosure) && newPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SentForClosure) && !oldPWOList[i].CNF_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED) && newPWOList[i].CNF_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED) ){              
                cfnRec(newPWOList[i],true,new CPA_CNF_TNF__c());             
            }
            else if(oldPWOList[i].pkl_Status__c != null &&  newPWOList[i].pkl_Status__c != null && oldPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SentForClosure) && (newPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SentForClosure) || newPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.Closed) || newPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.DELIVERED))){          
                if(mapCNFTNF.get(newPWOList[i].id) != null) {
                    cfnRec(newPWOList[i],false,mapCNFTNF.get(newPWOList[i].id));
                }
            }
            else if(oldPWOList[i].pkl_Status__c != null && newPWOList[i].pkl_Status__c != null && !oldPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SentForTermination) && newPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SentForTermination) && !oldPWOList[i].TNF_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED) && newPWOList[i].TNF_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED)){              
                tnfRec(newPWOList[i],true,new CPA_CNF_TNF__c());             
            }
            else if(oldPWOList[i].pkl_Status__c != null && newPWOList[i].pkl_Status__c != null && oldPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SentForTermination) && (newPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SentForTermination) || newPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.Terminated) || newPWOList[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SIGNED))){              
                if(mapCNFTNF.get(newPWOList[i].id) != null) {
                    tnfRec(newPWOList[i],false,mapCNFTNF.get(newPWOList[i].id));
                }
            }
        }
        if(cnftnfsInsertmap!=null && cnftnfsInsertmap.values()!= null){
            insert cnftnfsInsertmap.values();
        }
        if(cnftnfsupdate!=null && cnftnfsupdate.size()>0){
            update cnftnfsupdate;
        }
    }
    /*******************************************************************
    Purpose: This method is used to create CNF historical data
    Parameters: pwo, insertORupdate, cnftnf
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void cfnRec(CPA_project_work_order__c pwo, boolean insertORupdate,CPA_CNF_TNF__c cnftnf){
        Id CNFTNF_CNF_RecordType = Schema.SObjectType.CPA_CNF_TNF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_CNF_historical_CNF_id ).getRecordTypeId();
        
        //cnftnf.RecordTypeid = label.CPA_CNF_historical_CNF_id;
        cnftnf.RecordTypeid = CNFTNF_CNF_RecordType;
        cnftnf.dat_CNF_Accepted_Date__c=pwo.dat_CNF_Accepted_Date__c;
        cnftnf.num_CNF_Actual_Day_rate__c=pwo.num_CNF_Actual_Day_rate__c;
        cnftnf.num_CNF_Actual_expenses__c=pwo.num_CNF_Actual_expenses__c;
        cnftnf.num_CNF_Actual_fees_inclusive_of_discoun__c=pwo.num_CNF_Actual_fees_inclusive_of_discoun__c;
        cnftnf.num_CNF_Actual_Fixed_Price_Contingency__c=pwo.num_CNF_Actual_Fixed_Price_Contingency__c;
        cnftnf.num_CNF_Actual_man_days__c=pwo.num_CNF_Actual_man_days__c;
        cnftnf.num_CNF_Actual_PMO_tax__c=pwo.num_CNF_Actual_PMO_tax__c;
        cnftnf.dt_CNF_Actual_PWO_End_Date__c=pwo.dt_CNF_Actual_PWO_End_Date__c;
        cnftnf.num_CNF_Actual_total_charges__c=pwo.num_CNF_Actual_total_charges__c;
        cnftnf.dat_CNF_Cancelled_Date__c=pwo.dat_CNF_Cancelled_Date__c;
        cnftnf.ltxta_CNF_Comments__c=pwo.ltxta_CNF_Comments__c;
        cnftnf.txt_CNF_CR_number__c=pwo.txt_CNF_CR_number__c;
        cnftnf.mpkl_CNF_Currency__c=pwo.mpkl_CNF_Currency__c;
        cnftnf.dat_CNF_Delivered_Date__c=pwo.dat_CNF_Delivered_Date__c;
        cnftnf.pkl_CNF_PIR_Status__c=pwo.pkl_CNF_PIR_Status__c;
        cnftnf.num_CNF_Planned_Day_rate__c=pwo.num_CNF_Planned_Day_rate__c;
        cnftnf.num_CNF_Planned_expenses__c=pwo.num_CNF_Planned_expenses__c;
        cnftnf.num_CNF_Planned_fees_inclusive_of_discou__c=pwo.num_CNF_Planned_fees_inclusive_of_discou__c;
        cnftnf.num_CNF_Planned_Fixed_Price_Contingency__c=pwo.num_CNF_Planned_Fixed_Price_Contingency__c;
        cnftnf.num_CNF_Planned_man_days__c=pwo.num_CNF_Planned_man_days__c;
        cnftnf.num_CNF_Planned_PMO_tax__c=pwo.num_CNF_Planned_PMO_tax__c;
        cnftnf.dt_CNF_Planned_PWO_End_Date__c=pwo.dt_CNF_Planned_PWO_End_Date__c;
        cnftnf.num_CNF_Planned_total_charges__c=pwo.num_CNF_Planned_total_charges__c;
        cnftnf.ltxta_CNF_Reason_for_Cancellation__c=pwo.ltxta_CNF_Reason_for_Cancellation__c;
        cnftnf.txta_CNF_Reason_for_Return__c=pwo.txta_CNF_Reason_for_Return__c;
        cnftnf.dat_CNF_Resubmitted_Date__c=pwo.dat_CNF_Resubmitted_Date__c;
        cnftnf.dat_CNF_Returned_Date__c=pwo.dat_CNF_Returned_Date__c;
        cnftnf.dat_CNF_Sent_for_Signature_Date__c=pwo.dat_CNF_Sent_for_Signature_Date__c;
        cnftnf.dat_CNF_Signed_Date__c=pwo.dat_CNF_Signed_Date__c;
        if(!insertORupdate && pwo.CNF_Status__c == null) {cnftnf.CNF_Status__c=CPA_ConstantsForContractingAppClasses.CANCELLED;}
        else {cnftnf.CNF_Status__c=pwo.CNF_Status__c;}
        cnftnf.dat_CNF_Submitted_Date__c=pwo.dat_CNF_Submitted_Date__c;
        cnftnf.CNF_TAT__c=pwo.CNF_TAT__c;
        cnftnf.eml_CNF_Unilever_Budget_Approver_Email__c=pwo.eml_CNF_Unilever_Budget_Approver_Email__c;
        cnftnf.txt_CNF_Unilever_Budget_Approver_Name__c=pwo.txt_CNF_Unilever_Budget_Approver_Name__c;
        cnftnf.txt_CNF_Unilever_Clarity_ID__c=pwo.txt_CNF_Unilever_Clarity_ID__c;
        cnftnf.eml_CNF_Unilever_Content_Approver_Email__c=pwo.eml_CNF_Unilever_Content_Approver_Email__c;
        cnftnf.txt_CNF_Unilever_Content_Approver_Name__c=pwo.txt_CNF_Unilever_Content_Approver_Name__c;
        cnftnf.num_CNF_Variance_number_in_man_days__c=pwo.num_CNF_Variance_number_in_man_days__c;
        cnftnf.PWO__c=pwo.id;

        if(insertORupdate && cnftnfsInsertmap.get(pwo.id) == null) {
            cnftnfsInsertmap.put(pwo.id,cnftnf);        
        }
        else {cnftnfsupdate.add(cnftnf);}
        
    } 
    /*******************************************************************
    Purpose: This method is used to create TNF historical data
    Parameters: pwo, insertORupdate, cnftnf
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void tnfRec(CPA_project_work_order__c pwo, boolean insertORupdate,CPA_CNF_TNF__c cnftnf){
        ID CNFTNF_TNF_RecordType = Schema.SObjectType.CPA_CNF_TNF__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_CNF_historical_TNF_id ).getRecordTypeId();
        //cnftnf.RecordTypeid = label.CPA_CNF_historical_TNF_id;
        cnftnf.RecordTypeid = CNFTNF_TNF_RecordType;
        cnftnf.PWO__c=pwo.id;
        cnftnf.num_TNF_Actual_charges__c=pwo.num_TNF_Actual_charges__c;
        cnftnf.txt_TNF_Actual_effort_in_days__c=pwo.txt_TNF_Actual_effort_in_days__c;
        cnftnf.txt_TNF_Approved_by__c=pwo.txt_TNF_Approved_by__c;
        cnftnf.TNF_Auto_ID__c=pwo.TNF_Auto_ID__c;
        cnftnf.dat_TNF_Cancelled_Date__c=pwo.dat_TNF_Cancelled_Date__c;
        cnftnf.txt_TNF_Comments__c=pwo.txt_TNF_Comments__c;
        cnftnf.chk_TNF_Contract_Attached__c=pwo.chk_TNF_Contract_Attached__c;
        cnftnf.pkl_TNF_Currency__c=pwo.pkl_TNF_Currency__c;
        cnftnf.dt_TNF_TD_Date_Notified__c=pwo.dt_TNF_TD_Date_Notified__c;
        cnftnf.dat_TNF_Delivered_Date__c=pwo.dat_TNF_Delivered_Date__c;
        cnftnf.dt_TNF_TD_Effective_Date__c=pwo.dt_TNF_TD_Effective_Date__c;
        cnftnf.txt_TNF_TD_Notice_Required__c=pwo.txt_TNF_TD_Notice_Required__c;
        cnftnf.txt_TNF_Other_Currency__c=pwo.txt_TNF_Other_Currency__c;
        cnftnf.num_TNF_Planned_charges__c=pwo.num_TNF_Planned_charges__c;
        cnftnf.num_TNF_Planned_effort_in_days__c=pwo.num_TNF_Planned_effort_in_days__c;
        cnftnf.txta_TNF_Reason_for_Cancellation__c=pwo.txta_TNF_Reason_for_Cancellation__c;
        cnftnf.txta_TNF_Reason_for_Return__c=pwo.txta_TNF_Reason_for_Return__c;
        cnftnf.txt_TNF_Reason_for_termination__c=pwo.txt_TNF_Reason_for_termination__c;
        cnftnf.txt_TNF_Relocation_of_resources__c=pwo.txt_TNF_Relocation_of_resources__c;
        cnftnf.dat_TNF_Resubmitted_Date__c=pwo.dat_TNF_Resubmitted_Date__c;
        cnftnf.dat_TNF_Returned_Date__c=pwo.dat_TNF_Returned_Date__c;
        cnftnf.dat_TNF_Sent_for_Signature__c=pwo.dat_TNF_Sent_for_Signature__c;
        cnftnf.dat_TNF_Signed_Date__c=pwo.dat_TNF_Signed_Date__c;
        if(!insertORupdate && pwo.TNF_Status__c == null) {cnftnf.TNF_Status__c=CPA_ConstantsForContractingAppClasses.CANCELLED;}
        else {cnftnf.TNF_Status__c=pwo.TNF_Status__c;}
        cnftnf.dat_TNF_Submitted_Date__c=pwo.dat_TNF_Submitted_Date__c;
        cnftnf.pkl_TNF_Terminated_by__c=pwo.pkl_TNF_Terminated_by__c;
        cnftnf.txt_TNF_Unilever_Clarity_ID__c=pwo.txt_TNF_Unilever_Clarity_ID__c;
        cnftnf.eml_TNF_Unilever_Contact_Email__c=pwo.eml_TNF_Unilever_Contact_Email__c;
        cnftnf.txt_TNF_Unilever_Contact_Name__c=pwo.txt_TNF_Unilever_Contact_Name__c;
        cnftnf.num_TNF_Variance_in_charges__c=pwo.num_TNF_Variance_in_charges__c;
        cnftnf.num_TNF_Variance_in_effort__c=pwo.num_TNF_Variance_in_effort__c;

        if(insertORupdate && cnftnfsInsertmap.get(pwo.id) == null) {
            cnftnfsInsertmap.put(pwo.id,cnftnf);        
        }
        else {cnftnfsupdate.add(cnftnf);}   
    }
}