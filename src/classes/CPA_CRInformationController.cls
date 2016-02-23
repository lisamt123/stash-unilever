global class CPA_CRInformationController {
 public id crId;
 public CPA_CR__c crRec;
 public String mandatoryStringFlag {get; set;}   
 public Map<String,String> RequiredFieldMap {get; set;}
 boolean callFromVF = false;
   
   //this constructor will be call from VF page
    public CPA_CRInformationController(ApexPages.StandardController controller) {
        callFromVF = true;
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            crId = ApexPages.currentPage().getParameters().get('id');
            CPA_Messages(crId, callFromVF);           
        }
    }
    //this constructor will be call from webservice call
    public CPA_CRInformationController() {
        // 
    }
    
     boolean CPA_Messages(id crRecId,boolean callFromVF){  
        mandatoryStringFlag = null;
        RequiredFieldMap = new Map<String,String>();

        crRec = [select id,chk_Contract_Attached__c,chk_Contract_Excel_Attached__c,txt_Accenture_Project_Manager__c , isValidated__c ,mpkl_Change_Record_history__c ,Region_impacted__c  , txt_Change_Record_number__c , dt_CR_End_date__c , dt_CR_Start_Date__c , pkl_Currency__c , dt_Date_raised__c , num_Estimated_Man_days_of_CR__c , pec_Estimated_Off_shore__c , pec_Estimated_On_shore__c , num_Estimated_Value_of_CR__c , pec_Expense__c , num_Expense_charges_of_CR__c , pkl_Phase_change_record_raised__c , pkl_Project_Phases__c , PWO_number__c , pkl_Status__c , num_Target_Blend_Rate__c , txt_Title_of_change__c , num_Total_charge_of_CR__c , lkp_Unilever_budget_approver__c , lkp_Unilever_content_approver__c , txta_Unilever_Project_Name__c , txt_Unilever_Reference__c , pec_Variance__c , num_Varied_Target_Blend_Rate__c , txt_Other_Currency__c , txt_Other_Phase_change_record_raised__c , txt_Other_Project_Phases__c  from CPA_CR__c where id =:crRecId];
                
        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(crRec.pkl_Status__c);
        if(customSettingStatusMsg.CR_Status_Msg__c != null && callFromVF){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.CR_Status_Msg__c));
        }
        if((crRec.pkl_Status__c == 'Saved')|| !callFromVF){
            //if(crRec.chk_Contract_Excel_Attached__c  != true)  
            if(!crRec.chk_Contract_Excel_Attached__c)
                 RequiredFieldMap.put( 'Please attach Commercial CSV , with filename prefix with Commercial' ,ConstantsForContractingAppClasses.MANDATORY);
             //if(crRec.chk_Contract_Attached__c  != true)
             if(!crRec.chk_Contract_Attached__c)
                 RequiredFieldMap.put( 'Please attach Contract PDF , with filename prefix with CR' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.txt_Accenture_Project_Manager__c  == null)  
                 RequiredFieldMap.put( 'Accenture Project Manager' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.mpkl_Change_Record_history__c  == null)  
                 RequiredFieldMap.put( 'Change Record history' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.txt_Change_Record_number__c  == null)  
                 RequiredFieldMap.put( 'Change Record number ' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.dt_CR_End_date__c  == null)  
                 RequiredFieldMap.put( 'CR End date' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.dt_CR_Start_Date__c  == null)  
                 RequiredFieldMap.put( 'CR Start Date' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.pkl_Currency__c  == null)  
                 RequiredFieldMap.put( 'Currency' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.dt_Date_raised__c  == null)  
                 RequiredFieldMap.put( 'Date raised' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.num_Estimated_Man_days_of_CR__c  == null)  
                 RequiredFieldMap.put( 'Estimated Man-days of CR' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.pec_Estimated_Off_shore__c  == null)  
                 RequiredFieldMap.put( 'Estimated Off-shore %' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.pec_Estimated_On_shore__c  == null)  
                 RequiredFieldMap.put( 'Estimated On-shore %' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.num_Estimated_Value_of_CR__c  == null)  
                 RequiredFieldMap.put( 'Estimated Value of CR' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.pec_Expense__c  == null)  
                 RequiredFieldMap.put( 'Expense %' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.num_Expense_charges_of_CR__c  == null)  
                 RequiredFieldMap.put( 'Expense charges of CR' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.pkl_Phase_change_record_raised__c  == null)  
                 RequiredFieldMap.put( 'Phase change record raised' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.pkl_Project_Phases__c  == null)  
                 RequiredFieldMap.put( 'Project Phases' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.PWO_number__c  == null)  
                 RequiredFieldMap.put( 'PWO number' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.Region_impacted__c  == null)  
                 RequiredFieldMap.put( 'Region impacted' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.pkl_Status__c  == null)  
                 RequiredFieldMap.put( 'Status' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.num_Target_Blend_Rate__c  == null)  
                 RequiredFieldMap.put( 'Target Blend Rate' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.txt_Title_of_change__c  == null)  
                 RequiredFieldMap.put( 'Title of change' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.num_Total_charge_of_CR__c  == null)  
                 RequiredFieldMap.put( 'Total charge of CR' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.lkp_Unilever_budget_approver__c  == null)  
                 RequiredFieldMap.put( 'Unilever budget approver' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.lkp_Unilever_content_approver__c  == null)  
                 RequiredFieldMap.put( 'Unilever content approver' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.txta_Unilever_Project_Name__c  == null)  
                 RequiredFieldMap.put( 'Unilever Project Name' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.txt_Unilever_Reference__c  == null)  
                 RequiredFieldMap.put( 'Unilever Reference' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.pec_Variance__c  == null)  
                 RequiredFieldMap.put( 'Variance %' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.num_Varied_Target_Blend_Rate__c  == null)  
                 RequiredFieldMap.put( 'Varied Target Blend Rate' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.txt_Other_Currency__c  == null && crRec.pkl_Currency__c =='OTHER') 
                RequiredFieldMap.put( 'Other Currency' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.txt_Other_Phase_change_record_raised__c  == null && crRec.pkl_Phase_change_record_raised__c == 'Other') 
                RequiredFieldMap.put( 'Other Phase change record raised' ,ConstantsForContractingAppClasses.MANDATORY);
            if(crRec.txt_Other_Project_Phases__c  == null && crRec.pkl_Project_Phases__c == 'Other') 
                RequiredFieldMap.put( 'Other Project Phases' ,ConstantsForContractingAppClasses.MANDATORY);


        }

        if(RequiredFieldMap != null && !RequiredFieldMap.isEmpty()){
            System.debug('RequiredFieldMap >> '+ RequiredFieldMap); 
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Bellow field are mandatory to Submit the record'));
            mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
        system.debug(' return false');
            return false;
        }       
        system.debug(' return true');
        return true;        
    }
   
     webService static boolean checkIsValidated(Id crId) {
        boolean flag ;

        CPA_CRInformationController objCR = new CPA_CRInformationController();
        flag = objCR.CPA_Messages(crId,false); 
        system.debug('flag --> '+ flag);
    
        return flag; 
    }

}