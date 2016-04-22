/**********************************************************************
Name: CPA_ContractInformationController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This class is used to capture mandatory fields
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
1.1         Shreyas    10/03/2016     Replaceing Custom label with query on line 75,92,87
***********************************************************************/
global with sharing class CPA_ContractInformationController {
    public id pwoId;
    public CPA_project_work_order__c pwoRec;
    public Map<String,String> RequiredFieldMap {get; set;}
    public String mandatoryStringFlag {get; set;}   

    boolean callFromVF = false;
    
    /*******************************************************************
    Purpose: Below constructor will be call from VF page
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public CPA_ContractInformationController(ApexPages.StandardController controller) {
        callFromVF = true;
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            pwoId = ApexPages.currentPage().getParameters().get('id');
            CPA_Messages(pwoId,callFromVF);
        }
    } 
    
    
    /*******************************************************************
    Purpose: Below constructor will be call from webservice call
    Parameters: crId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_ContractInformationController(){}
    
    /* Justification: We need to show warning messages at the top of the page for all mandatory fields, so for that
     * we have used multiple if conditions. If that field is null, flag warning message.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     *  Dev team will fix this in next release.
     */
    /*******************************************************************
    Purpose: This method saves the cancel reason
    Parameters: pwoRecId, callFromVF
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    boolean CPA_Messages(id pwoRecId,boolean callFromVF){
        RequiredFieldMap = new Map<String,String>();
        mandatoryStringFlag = null;
        Id StandaloneRecordtype ;
        Id PWORecordtype ;
        Id CNFRecordtype ;
        Id TNFRecordtype ;
        pwoRec = [select chk_First_PWO__c,mpkl_CNF_Currency__c,PWORF_ID__c,txta_reason_for_additiona_PWO__c,id,chk_Excel_Attached__c,chk_PDF_Attached__c,pkl_Status__c,txt_PWO_number__c,pkl_Region__c ,txt_PWO_title__c,mpkl_Project_Classification__c,txt_Unilever_Project_Name__c,mpkl_Unilever_Innovation_Area__c,pkl_Billing_Details__c,txt_Accenture_Project_Manager__c,dt_Date_PWORF_accepted__c,num_Estimated_Man_days_of_PWO__c,num_Estimated_Value_of_PWO__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,dt_Project_Initiation_Date__c,dt_Expected_Start_Date__c,dt_Expected_End_date__c,mpkl_Project_Phases__c,pkl_Pricing_Model__c,num_Target_Blend_Rate__c,num_Varied_Target_Blend_Rate__c,pec_Variance__c,pec_Estimated_Off_shore__c,pec_Estimated_On_shore__c,pec_Expense__c,num_Expense_charges_of_work_order__c,num_Total_work_order_charge__c,Currency__c,txt_Unilever_Reference__c,fml_Clarity_ID__c,pkl_TNF_Currency__c,txt_TNF_Unilever_Clarity_ID__c,txt_TNF_Approved_by__c,dt_TNF_TD_Date_Notified__c,dt_TNF_TD_Effective_Date__c,txt_TNF_Reason_for_termination__c,txt_TNF_Relocation_of_resources__c,txt_TNF_Comments__c,num_TNF_Planned_charges__c,num_TNF_Actual_charges__c,txt_TNF_Actual_effort_in_days__c,num_TNF_Planned_effort_in_days__c,txt_TNF_TD_Notice_Required__c,pkl_TNF_Terminated_by__c,txt_TNF_Accenture_Contact__c,txt_TNF_Other_Currency__c,txt_CNF_Accenture_Project_Manager__c,num_CNF_Actual_Day_rate__c,num_CNF_Actual_expenses__c,num_CNF_Actual_fees_inclusive_of_discoun__c,num_CNF_Actual_man_days__c,num_CNF_Actual_PMO_tax__c,dt_CNF_Actual_PWO_End_Date__c,num_CNF_Actual_total_charges__c,num_CNF_Planned_Day_rate__c,num_CNF_Planned_expenses__c,num_CNF_Planned_fees_inclusive_of_discou__c,num_CNF_Planned_man_days__c,num_CNF_Planned_PMO_tax__c,dt_CNF_Planned_PWO_End_Date__c,num_CNF_Planned_total_charges__c,txt_CNF_Unilever_Clarity_ID__c,num_CNF_Variance_number_in_man_days__c,CNF_Status__c,TNF_Status__c,RecordTypeid, txt_CNF_Other_Currency__c,chk_isStandalone_PWO__c,eml_Unilever_Content_Approver_Email__c, txt_Unilever_Content_Approver_Name__c, eml_Unilever_Budget_Approver_Email__c, txt_Unilever_Budget_Approver_Name__c, eml_TNF_Unilever_Contact_Email__c, txt_TNF_Unilever_Contact_Name__c, eml_CNF_Unilever_Budget_Approver_Email__c, txt_CNF_Unilever_Budget_Approver_Name__c, eml_CNF_Unilever_Content_Approver_Email__c, txt_CNF_Unilever_Content_Approver_Name__c, eml_Unilever_Finance_BP_Contact_Email__c, txt_Unilever_Finance_BP_Contact_Name__c,  txt_Other_Project_Phases__c, txt_Other_Innovation_Area__c, txt_Other_Billing_Details__c,txt_Other_Currency__c  ,txt_Other_PWORFDelta_Request_Type__c,pkl_PWORFDelta_Process_Office_Area_E2E__c,pkl_PWORFDelta_Request_Type__c,PWORFDelta_OtherProcess_Office_Area_E2E__c,dat_CNF_Sent_for_Signature_Date__c,dat_Sent_for_Signature_Date__c,dat_TNF_Sent_for_Signature__c,txt_Standalone_PWO_clarity_ID__c,Comments__c from CPA_project_work_order__c where id =:pwoRecId];

            
        StandaloneRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_Standalone_PWO_RecordTypeId).getRecordTypeId();        
        PWORecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_PWO_RecordTypeId ).getRecordTypeId();
        CNFRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_CNF_RecordTypeId ).getRecordTypeId();        
        TNFRecordtype = Schema.SObjectType.CPA_project_work_order__c.getRecordTypeInfosByName().get(CPA_ConstantsForContractingAppClasses.CPA_TNF_RecordTypeId  ).getRecordTypeId();
       // if(pwoRec.RecordTypeid == label.CPA_PWO_RecordTypeId || pwoRec.RecordTypeid == label.CPA_Standalone_PWO_RecordTypeId){ //Replaceing Custom label with query : Shreyas 10th March 2016
        if(pwoRec.RecordTypeid == PWORecordtype || pwoRec.RecordTypeid == StandaloneRecordtype){            
            if(pwoRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || pwoRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED || !callFromVF){
                pWOReqFields(pwoRec,RequiredFieldMap);
            }
       // }else if(pwoRec.RecordTypeid == label.CPA_PWO_CNF_RecordTypeId){ //Replaceing Custom label with query : Shreyas 10th March 2016
        }else if(pwoRec.RecordTypeid == CNFRecordtype){
            if(pwoRec.CNF_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || !callFromVF){
               cNFReqFields(pwoRec,RequiredFieldMap);
            }
        //}else if(pwoRec.RecordTypeid == label.CPA_PWO_TNF_RecordTypeId){ //Replaceing Custom label with query : Shreyas 10th March 2016
             }else if(pwoRec.RecordTypeid == TNFRecordtype){
            if(pwoRec.TNF_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || !callFromVF){
                tNFReqFields(pwoRec,RequiredFieldMap);
            }
        }

        
        Map<string,CPA_Status_Msg__c> customSettingStatusMsg = CPA_Status_Msg__c.getAll();
        CPA_Status_Msg__c customSettingStatusMsg1 = CPA_Status_Msg__c.getInstance(CPA_ConstantsForContractingAppClasses.READYTOSUBMIT);
        string PWOreturnFromDocSign = 'PWO' + CPA_ConstantsForContractingAppClasses.RETURNFROMDOCSIGN;
        string CNFreturnFromDocSign = 'CNF' + CPA_ConstantsForContractingAppClasses.RETURNFROMDOCSIGN;
        string TNFreturnFromDocSign = 'TNF' + CPA_ConstantsForContractingAppClasses.RETURNFROMDOCSIGN;  
        
        if(customSettingStatusMsg.get(pwoRec.pkl_Status__c).PWO_Status_Msg__c != null && callFromVF && (pwoRec.CNF_Status__c == null) && (pwoRec.TNF_Status__c == null)){
            if(customSettingStatusMsg1 !=null && customSettingStatusMsg1.PWO_Status_Msg__c != null  && RequiredFieldMap.isEmpty() && pwoRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg1.PWO_Status_Msg__c));
            }else if(callFromVF && PWOreturnFromDocSign != null && pwoRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED && pwoRec.dat_Sent_for_Signature_Date__c !=null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, PWOreturnFromDocSign));
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.get(pwoRec.pkl_Status__c).PWO_Status_Msg__c));
            }
        } 
        if(pwoRec.CNF_Status__c!=null && customSettingStatusMsg.get(pwoRec.CNF_Status__c).CNF_Status_Msg__c != null && callFromVF && (pwoRec.CNF_Status__c != null)){
            
            if(customSettingStatusMsg1 !=null && customSettingStatusMsg1.CNF_Status_Msg__c != null  && RequiredFieldMap.isEmpty() && pwoRec.CNF_Status__c == CPA_ConstantsForContractingAppClasses.SAVED ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg1.CNF_Status_Msg__c));
            }else if(callFromVF && CNFreturnFromDocSign != null && pwoRec.CNF_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED && pwoRec.dat_CNF_Sent_for_Signature_Date__c !=null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, CNFreturnFromDocSign));
            }
            else{           
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.get(pwoRec.CNF_Status__c).CNF_Status_Msg__c));
            }
        }
        else if(pwoRec.TNF_Status__c!= null && customSettingStatusMsg.get(pwoRec.TNF_Status__c).TNF_Status_Msg__c != null && callFromVF && (pwoRec.TNF_Status__c != null)){
            
            if(customSettingStatusMsg1 !=null && customSettingStatusMsg1.TNF_Status_Msg__c != null  && RequiredFieldMap.isEmpty() && pwoRec.TNF_Status__c == CPA_ConstantsForContractingAppClasses.SAVED ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg1.TNF_Status_Msg__c));
            }else if(callFromVF && TNFreturnFromDocSign != null && pwoRec.TNF_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED && pwoRec.dat_TNF_Sent_for_Signature__c !=null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, TNFreturnFromDocSign));
            }else{           
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.get(pwoRec.TNF_Status__c).TNF_Status_Msg__c));
            }
        } 

        if(!RequiredFieldMap.isEmpty()){ 
            mandatoryStringFlag = System.Label.CPA_Mandatory_Fields_Message;
         return false;
        }  
        return true;    
    }
    /* Justification: We need to show warning messages at the top of the page for all mandatory fields, so for that
     * we have used multiple if conditions. If that field is null, flag warning message.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     *  Dev team will fix this in next release.
     */
    /*******************************************************************
    Purpose: This method check requied fields in PWO
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static void pWOReqFields(CPA_project_work_order__c pwoRecord,Map<String,String> RequiredFieldMap) {
        if(pwoRecord.txt_PWO_number__c == null){
            RequiredFieldMap.put( 'PWO number',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.txt_PWO_title__c == null){
            RequiredFieldMap.put( 'PWO title' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.mpkl_Project_Classification__c == null){
            RequiredFieldMap.put( 'Project Classification' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.txt_Unilever_Project_Name__c == null){
            RequiredFieldMap.put( 'Unilever Project Name' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.mpkl_Unilever_Innovation_Area__c == null){
            RequiredFieldMap.put( 'Unilever Innovation Area' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.mpkl_Unilever_Innovation_Area__c != null && pwoRecord.mpkl_Unilever_Innovation_Area__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && pwoRecord.txt_Other_Innovation_Area__c == null){
            RequiredFieldMap.put( 'Other Innovation Area' ,'It is mandatory if Unilever Innovation Area is OTHER' );
        }
        if(pwoRecord.mpkl_Unilever_Innovation_Area__c != null && !pwoRecord.mpkl_Unilever_Innovation_Area__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && pwoRecord.txt_Other_Innovation_Area__c != null){
            RequiredFieldMap.put( 'Other Innovation Area' ,'"Other Innovation Area" should be only entered when "Unilever Innovation Area" is Other');
        }
        if(pwoRecord.pkl_Billing_Details__c == null){
            RequiredFieldMap.put( 'Legal Entity To Be Billed' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.pkl_Billing_Details__c != null && pwoRecord.pkl_Billing_Details__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && pwoRecord.txt_Other_Billing_Details__c == null){
            RequiredFieldMap.put( 'Other Billing Details' ,'It is mandatory if Billing Details is OTHER');
        }
        if(pwoRecord.pkl_Billing_Details__c != null && !pwoRecord.pkl_Billing_Details__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && pwoRecord.txt_Other_Billing_Details__c != null){
           RequiredFieldMap.put( 'Other Billing Details' ,'"Other Billing Details" should be only entered when "Legal Entity To Be Billed" is Other');
        }
         if(!pwoRecord.chk_First_PWO__c && pwoRecord.txta_reason_for_additiona_PWO__c == null){
            RequiredFieldMap.put( 'Reason For Additional PWO' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }                
        if(pwoRecord.txt_Accenture_Project_Manager__c == null){
            RequiredFieldMap.put( 'Vendor Project Manager' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.num_Estimated_Man_days_of_PWO__c == null){
            RequiredFieldMap.put( 'Estimated Man-days of PWO' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.num_Estimated_Value_of_PWO__c == null){
            RequiredFieldMap.put( 'Estimated Value of PWO' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.eml_Unilever_Content_Approver_Email__c == null){
            RequiredFieldMap.put('Unilever Content Approver Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.txt_Unilever_Content_Approver_Name__c == null){
            RequiredFieldMap.put('Unilever Content Approver Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.eml_Unilever_Budget_Approver_Email__c == null){
            RequiredFieldMap.put('Unilever Budget Approver Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.txt_Unilever_Budget_Approver_Name__c == null){
            RequiredFieldMap.put('Unilever Budget Approver Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }                                       
        if(pwoRecord.eml_Unilever_Finance_BP_Contact_Email__c == null){
            RequiredFieldMap.put('Unilever Finance BP/Contact Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.txt_Unilever_Finance_BP_Contact_Name__c == null){
            RequiredFieldMap.put('Unilever Finance BP/Contact Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }      
        if(pwoRecord.dt_Project_Initiation_Date__c == null){
            RequiredFieldMap.put( 'Project Initiation Date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.mpkl_Project_Phases__c == null){
            RequiredFieldMap.put( 'Project Phases' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.mpkl_Project_Phases__c != null && pwoRecord.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && pwoRecord.txt_Other_Project_Phases__c == null){
            RequiredFieldMap.put( 'Other Project Phases' ,'It is mandatory if Project Phases is OTHER');
        }
        if(pwoRecord.mpkl_Project_Phases__c != null &&  !pwoRecord.mpkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && pwoRecord.txt_Other_Project_Phases__c != null){
            RequiredFieldMap.put( 'Other Project Phases' ,'"Other Project Phases" should be only entered when "Project Phases" is Other');
        }
        if(pwoRecord.pkl_Pricing_Model__c == null){
            RequiredFieldMap.put( 'Pricing Model' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.num_Target_Blend_Rate__c == null){
            RequiredFieldMap.put( 'Target Blend Rate' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.num_Varied_Target_Blend_Rate__c == null){
            RequiredFieldMap.put( 'Varied Target Blend Rate' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.pec_Variance__c == null){
            RequiredFieldMap.put( 'Variance %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.pec_Estimated_Off_shore__c == null){
            RequiredFieldMap.put( 'Estimated Off-shore %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.pec_Estimated_On_shore__c == null){
            RequiredFieldMap.put( 'Estimated On-shore %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.num_Total_work_order_charge__c == null){
            RequiredFieldMap.put( 'Total work order charge' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.num_Expense_charges_of_work_order__c == null){
            RequiredFieldMap.put( 'Expense charges of work order' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.pec_Expense__c == null){
            RequiredFieldMap.put( 'Expense %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.Currency__c == null){
            RequiredFieldMap.put( 'Currency' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.Currency__c != null && pwoRecord.Currency__c == CPA_ConstantsForContractingAppClasses.OTHER && pwoRecord.txt_Other_Currency__c == null){
            RequiredFieldMap.put( 'Other Currency' ,'It is mandatory if Currency is OTHER');
        }
        if(pwoRecord.Currency__c != null && pwoRecord.Currency__c != CPA_ConstantsForContractingAppClasses.OTHER && pwoRecord.txt_Other_Currency__c != null){
            RequiredFieldMap.put( 'Other Currency' ,'"Other Currency" should be only entered when "Currency" is Other');
        }/*
        if(pwoRecord.txt_Unilever_Reference__c == null && pwoRecord.fml_Clarity_ID__c == null && !pwoRecord.chk_isStandalone_PWO__c){
            RequiredFieldMap.put( 'Unilever Reference ' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }*/
        if(!pwoRecord.chk_Excel_Attached__c){
            RequiredFieldMap.put( 'Commercial CSV file not attached. Please attach Commercial CSV file with filename prefix with Commercial ' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }                   
        if(!pwoRecord.chk_PDF_Attached__c){
             RequiredFieldMap.put( 'Contract document not attached. Please attach Contract Order as PDF document type with filename prefixed with PWO ' ,CPA_ConstantsForContractingAppClasses.MANDATORY); 
        }
        if(pwoRecord.pkl_Region__c == null){
            RequiredFieldMap.put( 'Region' ,CPA_ConstantsForContractingAppClasses.MANDATORY); 
        }
        if(pwoRecord.dt_Expected_Start_Date__c == null){
            RequiredFieldMap.put( 'Expected Start Date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.dt_Expected_End_date__c == null){
            RequiredFieldMap.put( 'Expected End date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(pwoRecord.dt_Expected_Start_Date__c != null && pwoRecord.dt_Expected_End_date__c != null && pwoRecord.dt_Expected_End_date__c < pwoRecord.dt_Expected_Start_Date__c){
            RequiredFieldMap.put( 'Expected End date' ,CPA_ConstantsForContractingAppClasses.ENDDATECANNOTBEBEFORESTARTDATE);
        }
        if(pwoRecord.chk_isStandalone_PWO__c){
            if(pwoRecord.pkl_PWORFDelta_Request_Type__c != null && pwoRecord.txt_Other_PWORFDelta_Request_Type__c  == null && pwoRecord.pkl_PWORFDelta_Request_Type__c ==CPA_ConstantsForContractingAppClasses.OTHER){ 
                RequiredFieldMap.put( 'Other Request type' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if((pwoRecord.pkl_PWORFDelta_Request_Type__c == null || pwoRecord.pkl_PWORFDelta_Request_Type__c != CPA_ConstantsForContractingAppClasses.OTHER) && pwoRecord.txt_Other_PWORFDelta_Request_Type__c != null){
                RequiredFieldMap.put( 'Other Request type' ,' It should be only entered when "Request Type" is Other');
            }
            if(pwoRecord.pkl_PWORFDelta_Process_Office_Area_E2E__c != null && pwoRecord.PWORFDelta_OtherProcess_Office_Area_E2E__c  == null && pwoRecord.pkl_PWORFDelta_Process_Office_Area_E2E__c ==CPA_ConstantsForContractingAppClasses.OTHER){ 
                RequiredFieldMap.put( 'Other Currency' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if((pwoRecord.pkl_PWORFDelta_Process_Office_Area_E2E__c == null || pwoRecord.pkl_PWORFDelta_Process_Office_Area_E2E__c != CPA_ConstantsForContractingAppClasses.OTHER) && pwoRecord.PWORFDelta_OtherProcess_Office_Area_E2E__c != null){
                RequiredFieldMap.put( 'other Process Office Area E2E' ,' It should be only entered when "Process Office Area E2E" is Other');
            }

            if(pwoRecord.txt_Standalone_PWO_clarity_ID__c == null){
                RequiredFieldMap.put( 'Clarity ID' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(pwoRecord.Comments__c == null){
                RequiredFieldMap.put( 'Comments' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
        
        }
    }
    /* Justification: We need to show warning messages at the top of the page for all mandatory fields, so for that
     * we have used multiple if conditions. If that field is null, flag warning message.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     *  Dev team will fix this in next release.
     */
/*******************************************************************
    Purpose: This method check requied fields in CNF
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static void cNFReqFields(CPA_project_work_order__c cnfRecord,Map<String,String> RequiredFieldMap) {
        if(cnfRecord.txt_CNF_Accenture_Project_Manager__c== null) {
            RequiredFieldMap.put('CNF Vendor Project Manager',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Actual_Day_rate__c== null) {
            RequiredFieldMap.put('CNF Actual Day rate',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Actual_expenses__c== null) {
            RequiredFieldMap.put('CNF Actual expenses',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Actual_fees_inclusive_of_discoun__c== null){
            RequiredFieldMap.put('CNF Actual fees (inclusive of discount)',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Actual_man_days__c== null) {
            RequiredFieldMap.put('CNF Actual man-days',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Actual_PMO_tax__c== null) {
            RequiredFieldMap.put('CNF Actual PMO tax',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.dt_CNF_Actual_PWO_End_Date__c== null) {
            RequiredFieldMap.put('CNF Actual PWO End Date',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Actual_total_charges__c== null) {
            RequiredFieldMap.put('CNF Actual total charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        /*if(cnfRecord.num_CNF_Planned_Day_rate__c== null) {
            RequiredFieldMap.put('CNF Planned Day rate',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Planned_expenses__c== null) {
            RequiredFieldMap.put('CNF Planned expenses',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Planned_fees_inclusive_of_discou__c== null){ 
            RequiredFieldMap.put('CNF Planned fees (inclusive of discount)',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Planned_man_days__c== null){ 
            RequiredFieldMap.put('CNF Planned man-days',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }*/
        if(cnfRecord.num_CNF_Planned_PMO_tax__c== null){ 
            RequiredFieldMap.put('CNF Planned PMO tax',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
       /* if(cnfRecord.dt_CNF_Planned_PWO_End_Date__c== null) {
            RequiredFieldMap.put('CNF Planned PWO End Date',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.num_CNF_Planned_total_charges__c== null){ 
            RequiredFieldMap.put('CNF Planned total charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }*/
        if(cnfRecord.eml_CNF_Unilever_Budget_Approver_Email__c == null){
            RequiredFieldMap.put('CNF Unilever Budget Approver Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.txt_CNF_Unilever_Budget_Approver_Name__c == null){
            RequiredFieldMap.put('CNF Unilever Budget Approver Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.txt_CNF_Unilever_Clarity_ID__c== null && !cnfRecord.chk_isStandalone_PWO__c){ 
            RequiredFieldMap.put('CNF Unilever Clarity ID',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.eml_CNF_Unilever_Content_Approver_Email__c == null){
            RequiredFieldMap.put('CNF Unilever Content Approver Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.txt_CNF_Unilever_Content_Approver_Name__c == null){
            RequiredFieldMap.put('CNF Unilever Content Approver Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }              
        if(cnfRecord.num_CNF_Variance_number_in_man_days__c== null){ 
            RequiredFieldMap.put('CNF Variance (number in man-days)',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(cnfRecord.mpkl_CNF_Currency__c == null){
            RequiredFieldMap.put( 'CNF Currency' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        
        if(cnfRecord.mpkl_CNF_Currency__c != null && cnfRecord.mpkl_CNF_Currency__c == CPA_ConstantsForContractingAppClasses.OTHER && cnfRecord.txt_CNF_Other_Currency__c == null){
            RequiredFieldMap.put( 'CNF Other Currency' ,'It is mandatory if CNF Currency is OTHER');
        }
        if(cnfRecord.mpkl_CNF_Currency__c != null && cnfRecord.mpkl_CNF_Currency__c != CPA_ConstantsForContractingAppClasses.OTHER && cnfRecord.txt_CNF_Other_Currency__c != null){
            RequiredFieldMap.put( 'CNF Other Currency' ,' It should be only entered when "CNF Currency" is Other');
        }
    }
    /* Justification: We need to show warning messages at the top of the page for all mandatory fields, so for that
     * we have used multiple if conditions. If that field is null, flag warning message.
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     *  Dev team will fix this in next release.
     */
/*******************************************************************
    Purpose: This method check requied fields in TNF
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static void tNFReqFields(CPA_project_work_order__c tnfRecord,Map<String,String> RequiredFieldMap) {
        if(tnfRecord.txt_TNF_Approved_by__c == null){
            RequiredFieldMap.put('TNF Approved by',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.dt_TNF_TD_Date_Notified__c == null){
            RequiredFieldMap.put('TNF Date Notified',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.dt_TNF_TD_Effective_Date__c == null){
            RequiredFieldMap.put('TNF Effective Date',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.txt_TNF_Reason_for_termination__c == null){
            RequiredFieldMap.put('TNF Reason for termination',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.txt_TNF_Relocation_of_resources__c == null){
            RequiredFieldMap.put('TNF Relocation of resources',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.txt_TNF_Comments__c == null){
            RequiredFieldMap.put('TNF Comments',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }/*
        if(tnfRecord.num_TNF_Variance_in_charges__c == null){
            RequiredFieldMap.put('TNF Variance in charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.num_TNF_Variance_in_effort__c == null){
            RequiredFieldMap.put('TNF Variance in effort',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.num_TNF_Planned_charges__c == null){
            RequiredFieldMap.put('TNF Planned charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
        } */                  
        if(tnfRecord.num_TNF_Actual_charges__c == null){
            RequiredFieldMap.put('TNF Actual charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }                   
        if(tnfRecord.txt_TNF_Actual_effort_in_days__c == null){
            RequiredFieldMap.put('TNF Actual effort in days',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }/*
        if(tnfRecord.num_TNF_Planned_effort_in_days__c == null){
            RequiredFieldMap.put('TNF Planned effort in days',CPA_ConstantsForContractingAppClasses.MANDATORY); 
        }*/
        if(tnfRecord.txt_TNF_TD_Notice_Required__c == null){
            RequiredFieldMap.put('TNF Notice Required',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.pkl_TNF_Terminated_by__c== null){
            RequiredFieldMap.put('TNF Terminated by',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.txt_TNF_Accenture_Contact__c == null){
            RequiredFieldMap.put('TNF Accenture Contact',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.eml_TNF_Unilever_Contact_Email__c == null){
            RequiredFieldMap.put('TNF Unilever Contact Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        if(tnfRecord.txt_TNF_Unilever_Contact_Name__c == null){
            RequiredFieldMap.put('TNF Unilever Contact Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        
        if(tnfRecord.pkl_TNF_Currency__c == null){
            RequiredFieldMap.put( 'TNF Currency' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        }
        
        if(tnfRecord.pkl_TNF_Currency__c != null && tnfRecord.pkl_TNF_Currency__c == CPA_ConstantsForContractingAppClasses.OTHER && tnfRecord.txt_TNF_Other_Currency__c == null){
            RequiredFieldMap.put( 'TNF Other Currency' ,'It is mandatory if CNF Currency is OTHER');
        }
        if(tnfRecord.pkl_TNF_Currency__c != null && tnfRecord.pkl_TNF_Currency__c != CPA_ConstantsForContractingAppClasses.OTHER && tnfRecord.txt_TNF_Other_Currency__c != null){
            RequiredFieldMap.put( 'TNF Other Currency' ,' It should be only entered when "TNF Currency" is Other');
        }
    }
    
    /*******************************************************************
    Purpose: This method check whether all fields data is entered. This is getting called from custom button javascript code
    Parameters: objId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;

        CPA_ContractInformationController obj = new CPA_ContractInformationController();
        flag = obj.CPA_Messages(objId,false); 
       
    
        return flag; 
    }

}