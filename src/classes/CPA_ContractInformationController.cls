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
        pwoRec = [select chk_First_PWO__c,PWORF_ID__c,txta_reason_for_additiona_PWO__c,id,chk_Excel_Attached__c,chk_PDF_Attached__c,pkl_Status__c,txt_PWO_number__c,pkl_Region__c ,txt_PWO_title__c,mpkl_Project_Classification__c,txt_Unilever_Project_Name__c,mpkl_Unilever_Innovation_Area__c,pkl_Billing_Details__c,txt_Accenture_Project_Manager__c,dt_Date_PWORF_accepted__c,num_Estimated_Man_days_of_PWO__c,num_Estimated_Value_of_PWO__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,lkp_Unilever_Finance_BP_Contact__c,dt_Project_Initiation_Date__c,dt_Expected_Start_Date__c,dt_Expected_End_date__c,mpkl_Project_Phases__c,pkl_Pricing_Model__c,num_Target_Blend_Rate__c,num_Varied_Target_Blend_Rate__c,pec_Variance__c,pec_Estimated_Off_shore__c,pec_Estimated_On_shore__c,pec_Expense__c,num_Expense_charges_of_work_order__c,num_Total_work_order_charge__c,Currency__c,txt_Unilever_Reference__c,fml_Clarity_ID__c,pkl_TNF_Currency__c,txt_TNF_Unilever_Clarity_ID__c,txt_TNF_Approved_by__c,dt_TNF_TD_Date_Notified__c,dt_TNF_TD_Effective_Date__c,txt_TNF_Reason_for_termination__c,txt_TNF_Relocation_of_resources__c,txt_TNF_Comments__c,num_TNF_Variance_in_charges__c,num_TNF_Variance_in_effort__c,num_TNF_Planned_charges__c,num_TNF_Actual_charges__c,txt_TNF_Actual_effort_in_days__c,num_TNF_Planned_effort_in_days__c,txt_TNF_TD_Notice_Required__c,pkl_TNF_Terminated_by__c,txt_TNF_Accenture_Contact__c,lkp_TNF_Unilever_Contact__c,txt_TNF_Other_Currency__c,txt_CNF_Accenture_Project_Manager__c,num_CNF_Actual_Day_rate__c,num_CNF_Actual_expenses__c,num_CNF_Actual_fees_inclusive_of_discoun__c,num_CNF_Actual_man_days__c,num_CNF_Actual_PMO_tax__c,dt_CNF_Actual_PWO_End_Date__c,num_CNF_Actual_total_charges__c,num_CNF_Planned_Day_rate__c,num_CNF_Planned_expenses__c,num_CNF_Planned_fees_inclusive_of_discou__c,num_CNF_Planned_man_days__c,num_CNF_Planned_PMO_tax__c,dt_CNF_Planned_PWO_End_Date__c,num_CNF_Planned_total_charges__c,lkp_CNF_Unilever_budget_approver__c,txt_CNF_Unilever_Clarity_ID__c,lkp_CNF_Unilever_content_approver__c,num_CNF_Variance_number_in_man_days__c,CNF_Status__c,TNF_Status__c,RecordTypeid,mpkl_CNF_Currency__c,chk_isStandalone_PWO__c, txt_Other_Project_Phases__c, txt_Other_Innovation_Area__c, txt_Other_Billing_Details__c,txt_Other_Currency__c  from CPA_project_work_order__c where id =:pwoRecId];
        
        //List<CPA_project_work_order__c> listPriPWO = [Select ID,PWORF_ID__c from CPA_project_work_order__c where PWORF_ID__c =:pwoRec.PWORF_ID__c ];
        Map<string,CPA_Status_Msg__c> customSettingStatusMsg = CPA_Status_Msg__c.getAll();
            
           if(customSettingStatusMsg.get(pwoRec.pkl_Status__c).PWO_Status_Msg__c != null && callFromVF && (pwoRec.CNF_Status__c == null) && (pwoRec.TNF_Status__c == null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.get(pwoRec.pkl_Status__c).PWO_Status_Msg__c));
            } 
            if(pwoRec.CNF_Status__c!=null && customSettingStatusMsg.get(pwoRec.CNF_Status__c).CNF_Status_Msg__c != null && callFromVF && (pwoRec.CNF_Status__c != null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.get(pwoRec.CNF_Status__c).CNF_Status_Msg__c));
            }
            else if(pwoRec.TNF_Status__c!= null && customSettingStatusMsg.get(pwoRec.TNF_Status__c).TNF_Status_Msg__c != null && callFromVF && (pwoRec.TNF_Status__c != null)){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.get(pwoRec.TNF_Status__c).TNF_Status_Msg__c));
            }           
        if(pwoRec.RecordTypeid == label.CPA_PWO_RecordTypeId || pwoRec.RecordTypeid == label.CPA_Standalone_PWO_RecordTypeId){            
            //if(pwoRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || pwoRec.pkl_Status__c == 'CPA_ConstantsForContractingAppClasses.RETURNED' || callFromVF == false){
            if(pwoRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || pwoRec.pkl_Status__c == 'CPA_ConstantsForContractingAppClasses.RETURNED' || !callFromVF){
                if(pwoRec.txt_PWO_number__c == null){
                    RequiredFieldMap.put( 'PWO number',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.txt_PWO_title__c == null){
                    RequiredFieldMap.put( 'PWO title' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.mpkl_Project_Classification__c == null){
                    RequiredFieldMap.put( 'Project Classification' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.txt_Unilever_Project_Name__c == null){
                    RequiredFieldMap.put( 'Unilever Project Name' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.mpkl_Unilever_Innovation_Area__c == null){
                    RequiredFieldMap.put( 'Unilever Innovation Area' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.mpkl_Unilever_Innovation_Area__c != null && pwoRec.mpkl_Unilever_Innovation_Area__c.contains('Other') && pwoRec.txt_Other_Innovation_Area__c == null){
                    RequiredFieldMap.put( 'Other Innovation Area' ,'It is mandatory if Unilever Innovation Area is OTHER' );
                }
                if(pwoRec.mpkl_Unilever_Innovation_Area__c != null && !pwoRec.mpkl_Unilever_Innovation_Area__c.contains('Other') && pwoRec.txt_Other_Innovation_Area__c != null){
                    RequiredFieldMap.put( 'Other Innovation Area' ,'"Other Innovation Area" should be only entered when "Unilever Innovation Area" is Other');
                }
                if(pwoRec.pkl_Billing_Details__c == null){
                    RequiredFieldMap.put( 'Legal Entity To Be Billed' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.pkl_Billing_Details__c != null && pwoRec.pkl_Billing_Details__c.contains('Other') && pwoRec.txt_Other_Billing_Details__c == null){
                    RequiredFieldMap.put( 'Other Billing Details' ,'It is mandatory if Billing Details is OTHER');
                }
                if(pwoRec.pkl_Billing_Details__c != null && !pwoRec.pkl_Billing_Details__c.contains('Other') && pwoRec.txt_Other_Billing_Details__c != null){
                   RequiredFieldMap.put( 'Other Billing Details' ,'"Other Billing Details" should be only entered when "Legal Entity To Be Billed" is Other');
                }
                
                 //if(pwoRec.chk_First_PWO__c != true && pwoRec.txta_reason_for_additiona_PWO__c == null){
                 if(!pwoRec.chk_First_PWO__c && pwoRec.txta_reason_for_additiona_PWO__c == null){
                    RequiredFieldMap.put( 'Reason For Additional PWO' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                
                if(pwoRec.txt_Accenture_Project_Manager__c == null){
                    RequiredFieldMap.put( 'Accenture Project Manager' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                //if(pwoRec.dt_Date_PWORF_accepted__c == null && pwoRec.chk_isStandalone_PWO__c != true)
                if(pwoRec.dt_Date_PWORF_accepted__c == null && !pwoRec.chk_isStandalone_PWO__c){
                    RequiredFieldMap.put( 'Date PWORF accepted' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_Estimated_Man_days_of_PWO__c == null){
                    RequiredFieldMap.put( 'Estimated Man-days of PWO' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_Estimated_Value_of_PWO__c == null){
                    RequiredFieldMap.put( 'Estimated Value of PWO' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.lkp_Unilever_budget_approver__c == null){
                    RequiredFieldMap.put( 'Unilever budget approver' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.lkp_Unilever_content_approver__c == null){
                    RequiredFieldMap.put( 'Unilever content approver' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.lkp_Unilever_Finance_BP_Contact__c == null){
                    RequiredFieldMap.put( 'Unilever Finance BP/Contact' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.dt_Project_Initiation_Date__c == null){
                    RequiredFieldMap.put( 'Project Initiation Date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.mpkl_Project_Phases__c == null){
                    RequiredFieldMap.put( 'Project Phases' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.mpkl_Project_Phases__c != null && pwoRec.mpkl_Project_Phases__c.contains('Other') && pwoRec.txt_Other_Project_Phases__c == null){
                    RequiredFieldMap.put( 'Other Project Phases' ,'It is mandatory if Project Phases is OTHER');
                }
                if(pwoRec.mpkl_Project_Phases__c != null &&  !pwoRec.mpkl_Project_Phases__c.contains('Other') && pwoRec.txt_Other_Project_Phases__c != null){
                    RequiredFieldMap.put( 'Other Project Phases' ,'"Other Project Phases" should be only entered when "Project Phases" is Other');
                }
                if(pwoRec.pkl_Pricing_Model__c == null){
                    RequiredFieldMap.put( 'Pricing Model' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_Target_Blend_Rate__c == null){
                    RequiredFieldMap.put( 'Target Blend Rate' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_Varied_Target_Blend_Rate__c == null){
                    RequiredFieldMap.put( 'Varied Target Blend Rate' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.pec_Variance__c == null){
                    RequiredFieldMap.put( 'Variance %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.pec_Estimated_Off_shore__c == null){
                    RequiredFieldMap.put( 'Estimated Off-shore %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.pec_Estimated_On_shore__c == null){
                    RequiredFieldMap.put( 'Estimated On-shore %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_Total_work_order_charge__c == null){
                    RequiredFieldMap.put( 'Total work order charge' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_Expense_charges_of_work_order__c == null){
                    RequiredFieldMap.put( 'Expense charges of work order' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.pec_Expense__c == null){
                    RequiredFieldMap.put( 'Expense %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.Currency__c == null){
                    RequiredFieldMap.put( 'Currency' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.Currency__c != null && pwoRec.Currency__c == 'OTHER' && pwoRec.txt_Other_Currency__c == null){
                    RequiredFieldMap.put( 'Other Currency' ,'It is mandatory if Currency is OTHER');
                }
                if(pwoRec.Currency__c != null && pwoRec.Currency__c != 'OTHER' && pwoRec.txt_Other_Currency__c != null){
                    RequiredFieldMap.put( 'Other Currency' ,'"Other Currency" should be only entered when "Currency" is Other');
                }
                //if(pwoRec.txt_Unilever_Reference__c == null && pwoRec.fml_Clarity_ID__c == null && pwoRec.chk_isStandalone_PWO__c != true)
                if(pwoRec.txt_Unilever_Reference__c == null && pwoRec.fml_Clarity_ID__c == null && !pwoRec.chk_isStandalone_PWO__c){
                    RequiredFieldMap.put( 'Unilever Reference ' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                //if(pwoRec.chk_Excel_Attached__c!= true )
                if(!pwoRec.chk_Excel_Attached__c){
                    RequiredFieldMap.put( 'Commercial CSV Not attached, Please attach Commercial CSV , with filename prefix with Commercial ' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }                   
                //if(pwoRec.chk_PDF_Attached__c !=true)
                if(!pwoRec.chk_PDF_Attached__c){
                     RequiredFieldMap.put( 'Contract pdf Not attached, Please attach Contract PDF , with filename prefix with PWO  ' ,CPA_ConstantsForContractingAppClasses.MANDATORY); 
                }
                if(pwoRec.pkl_Region__c == null){
                    RequiredFieldMap.put( 'Region' ,CPA_ConstantsForContractingAppClasses.MANDATORY); 
                }
                if(pwoRec.dt_Expected_Start_Date__c == null || pwoRec.dt_Expected_Start_Date__c < System.today() ){
                    RequiredFieldMap.put( 'Expected Start Date' ,'Its mandatory and should not be before today');
                }
                if(pwoRec.dt_Expected_End_date__c == null || pwoRec.dt_Expected_End_date__c < pwoRec.dt_Expected_Start_Date__c){
                    RequiredFieldMap.put( 'Expected End date' ,'Its mandatory and should not be before Expected Start Date');
                }
            }
        }else if(pwoRec.RecordTypeid == label.CPA_PWO_CNF_RecordTypeId){
            
            //if(pwoRec.CNF_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || callFromVF == false){
            if(pwoRec.CNF_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || !callFromVF){
                if(pwoRec.txt_CNF_Accenture_Project_Manager__c== null) {
                    RequiredFieldMap.put('Accenture Project Manager',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Actual_Day_rate__c== null) {
                    RequiredFieldMap.put('Actual Day rate',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Actual_expenses__c== null) {
                    RequiredFieldMap.put('Actual expenses',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Actual_fees_inclusive_of_discoun__c== null){
                    RequiredFieldMap.put('Actual fees (inclusive of discount)',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Actual_man_days__c== null) {
                    RequiredFieldMap.put('Actual man-days',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Actual_PMO_tax__c== null) {
                    RequiredFieldMap.put('Actual PMO tax',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.dt_CNF_Actual_PWO_End_Date__c== null) {
                    RequiredFieldMap.put('Actual PWO End Date',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Actual_total_charges__c== null) {
                    RequiredFieldMap.put('Actual total charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                //if(pwoRec.mpkl_CNF_Currency__c== null) RequiredFieldMap.put('Currency',CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pwoRec.num_CNF_Planned_Day_rate__c== null) {
                    RequiredFieldMap.put('Planned Day rate',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Planned_expenses__c== null) {
                    RequiredFieldMap.put('Planned expenses',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Planned_fees_inclusive_of_discou__c== null){ 
                    RequiredFieldMap.put('Planned fees (inclusive of discount)',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Planned_man_days__c== null){ 
                    RequiredFieldMap.put('Planned man-days',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Planned_PMO_tax__c== null){ 
                    RequiredFieldMap.put('Planned PMO tax',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.dt_CNF_Planned_PWO_End_Date__c== null) {
                    RequiredFieldMap.put('Planned PWO End Date',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Planned_total_charges__c== null){ 
                    RequiredFieldMap.put('Planned total charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.lkp_CNF_Unilever_budget_approver__c== null){ 
                    RequiredFieldMap.put('Unilever budget approver',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                //if(pwoRec.txt_CNF_Unilever_Clarity_ID__c== null && pwoRec.chk_isStandalone_PWO__c != true) RequiredFieldMap.put('Unilever Clarity ID',CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pwoRec.txt_CNF_Unilever_Clarity_ID__c== null && !pwoRec.chk_isStandalone_PWO__c){ 
                    RequiredFieldMap.put('Unilever Clarity ID',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.lkp_CNF_Unilever_content_approver__c== null){ 
                    RequiredFieldMap.put('Unilever content approver',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_CNF_Variance_number_in_man_days__c== null){ 
                    RequiredFieldMap.put('Variance (number in man-days)',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
            }
        }else if(pwoRec.RecordTypeid == label.CPA_PWO_TNF_RecordTypeId){
            
            //if(pwoRec.TNF_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || callFromVF == false){
            if(pwoRec.TNF_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || !callFromVF){
                if(pwoRec.txt_TNF_Approved_by__c == null){
                    RequiredFieldMap.put('Approved by',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.dt_TNF_TD_Date_Notified__c == null){
                    RequiredFieldMap.put('Date Notified',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.dt_TNF_TD_Effective_Date__c == null){
                    RequiredFieldMap.put('Effective Date',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.txt_TNF_Reason_for_termination__c == null){
                    RequiredFieldMap.put('Reason for termination',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.txt_TNF_Relocation_of_resources__c == null){
                    RequiredFieldMap.put('Relocation of resources',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.txt_TNF_Comments__c == null){
                    RequiredFieldMap.put('Comments',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_TNF_Variance_in_charges__c == null){
                    RequiredFieldMap.put('Variance in charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_TNF_Variance_in_effort__c == null){
                    RequiredFieldMap.put('Variance in effort',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_TNF_Planned_charges__c == null){
                    RequiredFieldMap.put('Planned charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }                   
                if(pwoRec.num_TNF_Actual_charges__c == null){
                    RequiredFieldMap.put('Actual charges',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }                   
                if(pwoRec.txt_TNF_Actual_effort_in_days__c == null){
                    RequiredFieldMap.put('Actual effort in days',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.num_TNF_Planned_effort_in_days__c == null){
                    RequiredFieldMap.put('Planned effort in days',CPA_ConstantsForContractingAppClasses.MANDATORY); 
                }
                if(pwoRec.txt_TNF_TD_Notice_Required__c == null){
                    RequiredFieldMap.put('Notice Required',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.pkl_TNF_Terminated_by__c== null){
                    RequiredFieldMap.put('Terminated by',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.txt_TNF_Accenture_Contact__c == null){
                    RequiredFieldMap.put('Accenture Contact',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(pwoRec.lkp_TNF_Unilever_Contact__c == null){
                    RequiredFieldMap.put('Unilever Contact',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
              //  if(pwoRec.txt_TNF_Other_Currency__c == null && pwoRec.pkl_TNF_Currency__c == 'Other') 
                 //   RequiredFieldMap.put('Other Currency',CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
        }

       if(!RequiredFieldMap.isEmpty()){ 
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Bellow field are mandatory to Submit the record'));
                mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
         return false;
        }  
        return true;    
    }
    
    /*******************************************************************
    Purpose: This method check whether all fields are entered data
    Parameters: objId
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;

        CPA_ContractInformationController obj = new CPA_ContractInformationController();
        flag = obj.CPA_Messages(objId,false); 
        system.debug('flag --> '+ flag);
    
        return flag; 
    }

}