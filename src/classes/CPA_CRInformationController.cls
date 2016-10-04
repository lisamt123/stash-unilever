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

        crRec = [select id,chk_Contract_Attached__c,per_Variance__c,chk_Contract_Excel_Attached__c,txt_Accenture_Project_Manager__c , isValidated__c ,mpkl_Change_Record_history__c ,Region_impacted__c  , txt_Change_Record_number__c , dt_CR_End_date__c , dt_CR_Start_Date__c , pkl_Currency__c , dt_Date_raised__c , num_Estimated_Man_days_of_CR__c , pec_Estimated_Off_shore__c , pec_Estimated_On_shore__c , num_Estimated_Value_of_CR__c , pec_Expense__c , num_Expense_charges_of_CR__c , pkl_Phase_change_record_raised__c , pkl_Project_Phases__c , PWO_number__c , pkl_Status__c , num_Target_Blend_Rate__c , txt_Title_of_change__c , num_Total_charge_of_CR__c , eml_Unilever_Content_Approver_Email__c, txt_Unilever_Content_Approver_Name__c, eml_Unilever_Budget_Approver_Email__c, txt_Unilever_Budget_Approver_Name__c, txta_Unilever_Project_Name__c , txt_Unilever_Reference__c , num_Varied_Target_Blend_Rate__c , txt_Other_Currency__c , txt_Other_Phase_change_record_raised__c , txt_Other_Project_Phases__c,PWORFDelta_OtherProcess_Office_Area_E2E__c ,txt_Other_PWORFDelta_Request_Type__c ,txt_PWODelta_Other_Billing_Details__c ,txt_PWODelta_Other_Innovation_Area__c ,pkl_PWORFDelta_Process_Office_Area_E2E__c ,pkl_PWORFDelta_Request_Type__c ,mpkl_PWODelta_Billing_Details__c ,mpkl_PWODelta_Unilever_Innovation_Area__c ,chk_isStandalone_CR__c,dat_Sent_for_Signature_Date__c, ltxta_Comments__c  from CPA_CR__c where id =:crRecId];
                
       
        if((crRec.pkl_Status__c == 'Saved' || crRec.pkl_Status__c == 'Returned')|| !callFromVF){
            //if(crRec.chk_Contract_Excel_Attached__c  != true)
            if(!crRec.chk_Contract_Excel_Attached__c){ 
                 RequiredFieldMap.put( 'Commercial CSV file not attached. Please attach Commercial CSV file with filename prefix with Commercial' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
             //if(crRec.chk_Contract_Attached__c  != true)
            }
             if(!crRec.chk_Contract_Attached__c){
                 RequiredFieldMap.put( 'Contract document not attached. Please attach Contract Order as PDF document type with filename prefixed with CR' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
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
            if(crRec.dt_CR_Start_Date__c  != null && crRec.dt_CR_End_date__c  != null && crRec.dt_CR_End_date__c < crRec.dt_CR_Start_Date__c){  
                 RequiredFieldMap.put( 'CR End date' ,CPA_ConstantsForContractingAppClasses.ENDDATECANNOTBEBEFORESTARTDATE);
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
            /*
            if(crRec.txt_Unilever_Reference__c  == null){  
                 RequiredFieldMap.put( 'Unilever Reference' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            } */
            
            if(crRec.num_Varied_Target_Blend_Rate__c  == null){  
                 RequiredFieldMap.put( 'Varied Target Blend Rate' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pkl_Currency__c!= null && crRec.txt_Other_Currency__c  == null && crRec.pkl_Currency__c ==CPA_ConstantsForContractingAppClasses.OTHER){ 
                RequiredFieldMap.put( 'Other Currency' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pkl_Phase_change_record_raised__c != null && crRec.txt_Other_Phase_change_record_raised__c  == null && crRec.pkl_Phase_change_record_raised__c.contains(CPA_ConstantsForContractingAppClasses.OTHER)){ 
                RequiredFieldMap.put( 'Other Phase change record raised' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pkl_Project_Phases__c != null && crRec.txt_Other_Project_Phases__c  == null && crRec.pkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.OTHER)){ 
                RequiredFieldMap.put( 'Other Project Phases' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            if(crRec.pkl_Currency__c != null && crRec.pkl_Currency__c != CPA_ConstantsForContractingAppClasses.OTHER && crRec.txt_Other_Currency__c != null){
                RequiredFieldMap.put( 'Other Currency' ,' It should be only entered when "Currency" is Other');
            }
            if(crRec.pkl_Phase_change_record_raised__c != null && !crRec.pkl_Phase_change_record_raised__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && crRec.txt_Other_Phase_change_record_raised__c != null){
                RequiredFieldMap.put( 'Other Phase change record raised' ,' It should be only entered when "Phase change record raised" is Other');
            }
            if(crRec.pkl_Project_Phases__c != null && !crRec.pkl_Project_Phases__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && crRec.txt_Other_Project_Phases__c != null){
                RequiredFieldMap.put( 'Other Project Phases' ,' It should be only entered when "Project Phases" is Other');
            }
            if(crRec.per_Variance__c == null){
				RequiredFieldMap.put( 'Variance %' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
			}
            if(crRec.chk_isStandalone_CR__c){
                if(crRec.txt_Unilever_Reference__c  == null){  
                     RequiredFieldMap.put( 'Unilever Reference' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }            
                if(crRec.pkl_PWORFDelta_Process_Office_Area_E2E__c != null && crRec.pkl_PWORFDelta_Process_Office_Area_E2E__c == CPA_ConstantsForContractingAppClasses.OTHER && crRec.PWORFDelta_OtherProcess_Office_Area_E2E__c == null){
                    RequiredFieldMap.put( 'Other Process Office Area E2E' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(crRec.pkl_PWORFDelta_Request_Type__c != null && crRec.pkl_PWORFDelta_Request_Type__c == CPA_ConstantsForContractingAppClasses.OTHER && crRec.txt_Other_PWORFDelta_Request_Type__c == null){
                    RequiredFieldMap.put( 'Other Request Type' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(crRec.mpkl_PWODelta_Billing_Details__c != null && crRec.mpkl_PWODelta_Billing_Details__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && crRec.txt_PWODelta_Other_Billing_Details__c == null){
                    RequiredFieldMap.put( 'Other Billing details' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(crRec.mpkl_PWODelta_Unilever_Innovation_Area__c != null && crRec.mpkl_PWODelta_Unilever_Innovation_Area__c.contains(CPA_ConstantsForContractingAppClasses.OTHER) && crRec.txt_PWODelta_Other_Innovation_Area__c == null){
                    RequiredFieldMap.put( 'Other Unilever Innovation Area' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if((crRec.pkl_PWORFDelta_Process_Office_Area_E2E__c == null || crRec.pkl_PWORFDelta_Process_Office_Area_E2E__c != CPA_ConstantsForContractingAppClasses.OTHER) && crRec.PWORFDelta_OtherProcess_Office_Area_E2E__c != null){
                    RequiredFieldMap.put( 'Other Process Office Area E2E' ,' It should be only entered when "Process Office Area E2E" is Other');
                }
                if((crRec.pkl_PWORFDelta_Request_Type__c == null || crRec.pkl_PWORFDelta_Request_Type__c != CPA_ConstantsForContractingAppClasses.OTHER) && crRec.txt_Other_PWORFDelta_Request_Type__c != null){
                    RequiredFieldMap.put( 'Other Request Type' ,' It should be only entered when "Request Type" is Other');
                }
                if((crRec.mpkl_PWODelta_Billing_Details__c == null || !crRec.mpkl_PWODelta_Billing_Details__c.contains(CPA_ConstantsForContractingAppClasses.OTHER)) && crRec.txt_PWODelta_Other_Billing_Details__c != null){
                    RequiredFieldMap.put( 'Other Billing details' ,' It should be only entered when "Billing details" is Other');
                }
                if((crRec.mpkl_PWODelta_Unilever_Innovation_Area__c == null || !crRec.mpkl_PWODelta_Unilever_Innovation_Area__c.contains(CPA_ConstantsForContractingAppClasses.OTHER)) && crRec.txt_PWODelta_Other_Innovation_Area__c != null){
                    RequiredFieldMap.put( 'Other Unilever Innovation Area' ,' It should be only entered when "Unilever Innovation Area" is Other');
                }
                if(crRec.ltxta_Comments__c  == null){  
                     RequiredFieldMap.put( 'Comments' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                }            
            }
        }

        
        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(crRec.pkl_Status__c);
        CPA_Status_Msg__c customSettingStatusMsg1 = CPA_Status_Msg__c.getInstance(CPA_ConstantsForContractingAppClasses.READYTOSUBMIT);
        string returnFromDocSign = 'CR' + CPA_ConstantsForContractingAppClasses.RETURNFROMDOCSIGN;
        if(customSettingStatusMsg1!=null && customSettingStatusMsg1.CR_Status_Msg__c != null && callFromVF && RequiredFieldMap.isEmpty() && crRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg1.CR_Status_Msg__c));
        }
         else if(callFromVF && returnFromDocSign != null && crRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED && crRec.dat_Sent_for_Signature_Date__c !=null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, returnFromDocSign));
        }
        else if(customSettingStatusMsg.CR_Status_Msg__c != null && callFromVF){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.CR_Status_Msg__c));
        }
        
        if(RequiredFieldMap != null && !RequiredFieldMap.isEmpty()){
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