/**********************************************************************
Name: CPA_LOI_InformationController()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to check whether user entered data in all mandatory fields
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR             DATE            DETAIL Description
1.0         Name     12/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
global with sharing class CPA_LOI_InformationController {
    Public id loiId;
    Public CPA_LOI__c LoiRec;
    Public String mandatoryStringFlag {get; set;}   
    public Map<String,String> RequiredFieldMap {get; set;}
    
    boolean callFromVF = false;
    
   /*******************************************************************
    Purpose: This constructor will be called from VF page
    Parameters: ApexPages.StandardController
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public CPA_LOI_InformationController(ApexPages.StandardController controller) {
      callFromVF = true;
      if(ApexPages.currentPage().getParameters().get('id') != null) {      
          loiId = ApexPages.currentPage().getParameters().get('id');
          
          CreateRequiredFieldMessage(loiId,callFromVF);
      }
    }
     //below constructor will be call from webservice call
    public CPA_LOI_InformationController(){}
    /*
     * NPath issue - This method has NPath issues identified in SonarQube. If this is high NPath issue,
     * Dev team will fix this in next release.
     * Justification: We need to show warning messages at the top of the page for all mandatory fields, so for that
     * we have used multiple if conditions. If a particular field is null, flag warning message.
     */
    /*******************************************************************
    Purpose: This method is used to check whether all mandatory fields have data
    Parameters: loiId, callFromVF
    Returns: boolean
    Throws [Exceptions]: 
    ********************************************************************/
    boolean CreateRequiredFieldMessage(id loiId,boolean callFromVF){
        RequiredFieldMap = new Map<String,String>();
        mandatoryStringFlag = null;
         LoiRec = [select id,isValidated__c,cur_Total_value_in_Euro_being_requested__c,txt_Other_Phases_Covered_by_W_R__c,num_Total_value_in_being_requested_for__c,num_Total_number_of_man_days_requested__c,chk_Contract_Attached__c,pkl_Status__c,pkl_Currency__c,num_Expense_charges_of_LOI__c,txt_Internal_PWO_ID__c,dt_LOI_End_date__c,dt_LOI_Start_Date__c,mpkl_Phases_covered_by_WAR__c,txt_PWO_number__c,txt_PWO_title__c,txt_Unilever_Clarity_ID__c, eml_Unilever_Content_Approver_Email__c, txt_Unilever_Content_Approver_Name__c, eml_Unilever_Budget_Approver_Email__c, txt_Unilever_Budget_Approver_Name__c, txt_Other_Currency__c, Total_Number_of_Man_days_being_requested__c,dat_Sent_for_Signature_Date__c from CPA_LOI__c where id =: loiId];
        
         if(LoiRec != null){
              if((LoiRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED || LoiRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED) || !callFromVF){

                if(LoiRec.pkl_Currency__c == null){
                 RequiredFieldMap.put('Currency',CPA_ConstantsForContractingAppClasses.MANDATORY);  
                }
                if(LoiRec.pkl_Currency__c != null && LoiRec.pkl_Currency__c.equalsIgnoreCase('OTHER') && LoiRec.txt_Other_Currency__c == null){
                    RequiredFieldMap.put('Other Currency','It is mandatory if OTHER as Currency');      
                }
                if(LoiRec.pkl_Currency__c != null && !LoiRec.pkl_Currency__c.equalsIgnoreCase('OTHER') && LoiRec.txt_Other_Currency__c != null){
                    RequiredFieldMap.put('Other Currency','It should be only entered when Currency is OTHER');      
                }
                
                if(LoiRec.num_Expense_charges_of_LOI__c == null)
                    RequiredFieldMap.put('Expense charges of LOI',CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(LoiRec.num_Total_number_of_man_days_requested__c == null)
                    RequiredFieldMap.put('W@R total number of man days requested',CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(LoiRec.num_Total_value_in_being_requested_for__c == null)
                    RequiredFieldMap.put('W@R € spend approved at MC Rates',CPA_ConstantsForContractingAppClasses.MANDATORY); 
                if(LoiRec.cur_Total_value_in_Euro_being_requested__c == null)
                    RequiredFieldMap.put('W@R total value in € being requested',CPA_ConstantsForContractingAppClasses.MANDATORY);    
                if(!LoiRec.chk_Contract_Attached__c )
                    RequiredFieldMap.put('Contract has not been attached. Attach the contract as PDF document type and append the file name with a prefix – LOI',CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(LoiRec.mpkl_Phases_covered_by_WAR__c == null)
                    RequiredFieldMap.put('Phases covered by WAR',CPA_ConstantsForContractingAppClasses.MANDATORY);          
                if(LoiRec.txt_PWO_number__c == null)
                    RequiredFieldMap.put('PWO number',CPA_ConstantsForContractingAppClasses.MANDATORY);        
                if(LoiRec.txt_PWO_title__c == null)
                    RequiredFieldMap.put('PWO title',CPA_ConstantsForContractingAppClasses.MANDATORY);          
                if(LoiRec.pkl_Status__c == null)
                    RequiredFieldMap.put('Status',CPA_ConstantsForContractingAppClasses.MANDATORY);         
                if(LoiRec.dt_LOI_Start_Date__c == null)
                    RequiredFieldMap.put('LOI Start Date','LOI Start Date is mandatory');
                
                if(LoiRec.dt_LOI_End_date__c == null)
                    {RequiredFieldMap.put('LOI End date','LOI End Date is mandatory');}
                if(LoiRec.mpkl_Phases_covered_by_WAR__c!=null && LoiRec.mpkl_Phases_covered_by_WAR__c.contains('Other') && LoiRec.txt_Other_Phases_Covered_by_W_R__c== null){
                    RequiredFieldMap.put('Other Phases Covered by W@R','If Other Phase covered is selected then this field is mandatory');
                }
                
                if(LoiRec.mpkl_Phases_covered_by_WAR__c!=null && !LoiRec.mpkl_Phases_covered_by_WAR__c.contains('Other') && LoiRec.txt_Other_Phases_Covered_by_W_R__c != null){
                    RequiredFieldMap.put('Other Phases Covered by W@R','It should be only entered when "Phase covered" contains OTHER');
                }
                
                if(LoiRec.eml_Unilever_Content_Approver_Email__c == null){
                    RequiredFieldMap.put('Unilever Content Approver Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(LoiRec.txt_Unilever_Content_Approver_Name__c == null){
                    RequiredFieldMap.put('Unilever Content Approver Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(LoiRec.eml_Unilever_Budget_Approver_Email__c == null){
                    RequiredFieldMap.put('Unilever Budget Approver Email',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(LoiRec.txt_Unilever_Budget_Approver_Name__c == null){
                    RequiredFieldMap.put('Unilever Budget Approver Name',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                if(LoiRec.Total_Number_of_Man_days_being_requested__c == null){
                    RequiredFieldMap.put('W@R mandays approved at MC Rates',CPA_ConstantsForContractingAppClasses.MANDATORY);
                }
                /* // Commented by JP. 1st April 2016
                if(LoiRec.dt_LOI_Start_Date__c != null && LoiRec.dt_LOI_Start_Date__c < system.today()){
                    RequiredFieldMap.put('LOI Start Date','LOI Start Date can not be a date from the past.');
                }*/
                if(LoiRec.dt_LOI_Start_Date__c != null && LoiRec.dt_LOI_End_date__c != null &&  LoiRec.dt_LOI_End_date__c < LoiRec.dt_LOI_Start_Date__c){
                    RequiredFieldMap.put('LOI End date',CPA_ConstantsForContractingAppClasses.ENDDATECANNOTBEBEFORESTARTDATE);
                }
            }
         }
         

        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(LoiRec.pkl_Status__c);
        CPA_Status_Msg__c customSettingStatusMsg1 = CPA_Status_Msg__c.getInstance(CPA_ConstantsForContractingAppClasses.READYTOSUBMIT);
        string returnFromDocSign = 'LOI' + CPA_ConstantsForContractingAppClasses.RETURNFROMDOCSIGN;
        
        if(customSettingStatusMsg1 !=null && customSettingStatusMsg1.LOI_Status_Msg__c != null && callFromVF && RequiredFieldMap.isEmpty() && LoiRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.SAVED ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg1.LOI_Status_Msg__c));
        }
        else if(callFromVF && returnFromDocSign != null && LoiRec.pkl_Status__c == CPA_ConstantsForContractingAppClasses.RETURNED && LoiRec.dat_Sent_for_Signature_Date__c !=null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, returnFromDocSign));
        }
        else if(customSettingStatusMsg.LOI_Status_Msg__c != null && callFromVF){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.LOI_Status_Msg__c));
        }

         
        if(!RequiredFieldMap.isEmpty()){ 
            mandatoryStringFlag = System.Label.CPA_Mandatory_Fields_Message;
            return false;
        }  
        return true;
    }
 
    /*******************************************************************
    Purpose: This webservice gets called from page. this is to refresh isValidate variable.
    Parameters: objId
    Returns: boolean
    Throws [Exceptions]: 
    ********************************************************************/
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;

        CPA_LOI_InformationController obj = new CPA_LOI_InformationController();
        flag = obj.CreateRequiredFieldMessage(objId,false); 
       
    
        return flag; 
    }
}