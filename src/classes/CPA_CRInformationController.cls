/**********************************************************************
Name: CPA_CRInformationController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: To check whether user has entered data in mandatory fields
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
global with sharing class CPA_CRInformationController {
 public id crId;
 public CPA_CR__c crRec;
 public String mandatoryStringFlag {get; set;}   
 public Map<String,String> RequiredFieldMap {get; set;}
 boolean callFromVF = false;
   
   /*******************************************************************
    Purpose: This constructor will be called from VF page
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_CRInformationController(ApexPages.StandardController controller) {
        callFromVF = true;
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            crId = ApexPages.currentPage().getParameters().get('id');
            CPA_Messages(crId, callFromVF);           
        }
    }
    
    /*******************************************************************
    Purpose: This constructor will be called from webservice call
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_CRInformationController() {
        // 
    }
    
    /*******************************************************************
    Purpose: To check whether user has entered data in all mandatory fields
    Parameters: crRecId, callFromVF
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
     boolean CPA_Messages(id crRecId,boolean callFromVF){  
        mandatoryStringFlag = null;
        RequiredFieldMap = new Map<String,String>();

        crRec = [select id,chk_Contract_Attached__c,chk_Contract_Excel_Attached__c,txt_Accenture_Project_Manager__c , isValidated__c ,mpkl_Change_Record_history__c ,Region_impacted__c  , txt_Change_Record_number__c , dt_CR_End_date__c , dt_CR_Start_Date__c , pkl_Currency__c , dt_Date_raised__c , num_Estimated_Man_days_of_CR__c , pec_Estimated_Off_shore__c , pec_Estimated_On_shore__c , num_Estimated_Value_of_CR__c , pec_Expense__c , num_Expense_charges_of_CR__c , pkl_Phase_change_record_raised__c , pkl_Project_Phases__c , PWO_number__c , pkl_Status__c , num_Target_Blend_Rate__c , txt_Title_of_change__c , num_Total_charge_of_CR__c , eml_Unilever_Content_Approver_Email__c, txt_Unilever_Content_Approver_Name__c, eml_Unilever_Budget_Approver_Email__c, txt_Unilever_Budget_Approver_Name__c, txta_Unilever_Project_Name__c , txt_Unilever_Reference__c , num_Varied_Target_Blend_Rate__c , txt_Other_Currency__c , txt_Other_Phase_change_record_raised__c , txt_Other_Project_Phases__c  from CPA_CR__c where id =:crRecId];
                
        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(crRec.pkl_Status__c);
        if(customSettingStatusMsg.CR_Status_Msg__c != null && callFromVF){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.CR_Status_Msg__c));
        }
        if((crRec.pkl_Status__c == 'Saved')|| !callFromVF){
            //if(crRec.chk_Contract_Excel_Attached__c  != true)
            if(!crRec.chk_Contract_Excel_Attached__c){ 
                 RequiredFieldMap.put( 'Please attach Commercial CSV , with filename prefix with Commercial' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
             //if(crRec.chk_Contract_Attached__c  != true)
            }
             if(!crRec.chk_Contract_Attached__c){
                 RequiredFieldMap.put( 'Please attach Contract PDF , with filename prefix with CR' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
             }
            if(crRec.txt_Accenture_Project_Manager__c  == null){  
                 RequiredFieldMap.put( 'Vendor Project Manager' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.mpkl_Change_Record_history__c  == null){  
                 RequiredFieldMap.put( 'Change Record history' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.txt_Change_Record_number__c  == null){  
                 RequiredFieldMap.put( 'Change Record number ' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.dt_CR_End_date__c  == null){  
                 RequiredFieldMap.put( 'CR End date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.dt_CR_Start_Date__c  == null){  
                 RequiredFieldMap.put( 'CR Start Date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pkl_Currency__c  == null){  
                 RequiredFieldMap.put( 'Currency' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            /*if(crRec.dt_Date_raised__c  == null)  
                 RequiredFieldMap.put( 'Date raised' ,CPA_ConstantsForContractingAppClasses.MANDATORY);*/
            if(crRec.num_Estimated_Man_days_of_CR__c  == null){  
                 RequiredFieldMap.put( 'Estimated Man-days of CR' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pec_Estimated_Off_shore__c  == null){ 
                 RequiredFieldMap.put( 'Estimated Off-shore %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pec_Estimated_On_shore__c  == null){  
                 RequiredFieldMap.put( 'Estimated On-shore %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.num_Estimated_Value_of_CR__c  == null){  
                 RequiredFieldMap.put( 'Estimated Value of CR' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pec_Expense__c  == null){  
                 RequiredFieldMap.put( 'Expense %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.num_Expense_charges_of_CR__c  == null){  
                 RequiredFieldMap.put( 'Expense charges of CR' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pkl_Phase_change_record_raised__c  == null){  
                 RequiredFieldMap.put( 'Phase change record raised' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pkl_Project_Phases__c  == null){  
                 RequiredFieldMap.put( 'Project Phases' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
           /* if(crRec.PWO_number__c  == null)  
                 RequiredFieldMap.put( 'PWO number' ,CPA_ConstantsForContractingAppClasses.MANDATORY);*/
            if(crRec.Region_impacted__c  == null){ 
                 RequiredFieldMap.put( 'Region impacted' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pkl_Status__c  == null){  
                 RequiredFieldMap.put( 'Status' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.num_Target_Blend_Rate__c  == null){  
                 RequiredFieldMap.put( 'Target Blend Rate' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.txt_Title_of_change__c  == null){  
                 RequiredFieldMap.put( 'Title of change' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
           /* if(crRec.num_Total_charge_of_CR__c  == null)  
                 RequiredFieldMap.put( 'Total charge of CR' ,CPA_ConstantsForContractingAppClasses.MANDATORY);*/  // Commentd by Shreyas M on 22nf Feb 2016, This filed is Read Only and value will be populated after Submitaion of CR
           /* if(crRec.lkp_Unilever_budget_approver__c  == null){  
                 RequiredFieldMap.put( 'Unilever budget approver' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.lkp_Unilever_content_approver__c  == null){  
                 RequiredFieldMap.put( 'Unilever content approver' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            */
            if(crRec.eml_Unilever_Content_Approver_Email__c == null){
                RequiredFieldMap.put('Unilever Content Approver Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.txt_Unilever_Content_Approver_Name__c == null){
                RequiredFieldMap.put('Unilever Content Approver Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.eml_Unilever_Budget_Approver_Email__c == null){
                RequiredFieldMap.put('Unilever Budget Approver Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.txt_Unilever_Budget_Approver_Name__c == null){
                RequiredFieldMap.put('Unilever Budget Approver Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            
        
            
            if(crRec.txta_Unilever_Project_Name__c  == null){  
                 RequiredFieldMap.put( 'Unilever Project Name' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.txt_Unilever_Reference__c  == null){  
                 RequiredFieldMap.put( 'Unilever Reference' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            
            if(crRec.num_Varied_Target_Blend_Rate__c  == null){  
                 RequiredFieldMap.put( 'Varied Target Blend Rate' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.txt_Other_Currency__c  == null && crRec.pkl_Currency__c =='OTHER'){ 
                RequiredFieldMap.put( 'Other Currency' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.txt_Other_Phase_change_record_raised__c  == null && crRec.pkl_Phase_change_record_raised__c == 'Other'){ 
                RequiredFieldMap.put( 'Other Phase change record raised' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.txt_Other_Project_Phases__c  == null && crRec.pkl_Project_Phases__c == 'Other'){ 
                RequiredFieldMap.put( 'Other Project Phases' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
        }

        if(RequiredFieldMap != null && !RequiredFieldMap.isEmpty()){
            System.debug('RequiredFieldMap >> '+ RequiredFieldMap); 
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Bellow field are mandatory to Submit the record'));
            mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
            return false;
        }       
        
        return true;        
    }
    
   /*******************************************************************
    Purpose: 
    Parameters: crId
    Returns: boolean
    Throws [Exceptions]: 
    ********************************************************************/
     webService static boolean checkIsValidated(Id crId) {
        boolean flag ;

        CPA_CRInformationController objCR = new CPA_CRInformationController();
        flag = objCR.CPA_Messages(crId,false); 
    
        return flag; 
    }

}