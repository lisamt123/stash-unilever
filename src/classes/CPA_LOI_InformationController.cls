global class CPA_LOI_InformationController {
Public id loiId;
Public CPA_LOI__c LoiRec;
Public String mandatoryStringFlag {get; set;}   
public Map<String,String> RequiredFieldMap {get; set;}

boolean callFromVF = false;
    
     //below constructor will be call from VF page
  public CPA_LOI_InformationController(ApexPages.StandardController controller) {
      callFromVF = true;
      if(ApexPages.currentPage().getParameters().get('id') != null) {      
          loiId = ApexPages.currentPage().getParameters().get('id');
          
          CreateRequiredFieldMessage(loiId,callFromVF);
      }
  }
     //below constructor will be call from webservice call
    public CPA_LOI_InformationController(){}
    
    boolean CreateRequiredFieldMessage(id loiId,boolean callFromVF){
        RequiredFieldMap = new Map<String,String>();
        mandatoryStringFlag = null;
         LoiRec = [select id,isValidated__c,cur_Total_value_in_Euro_being_requested__c,txt_Other_Phases_Covered_by_W_R__c,num_Total_value_in_being_requested_for__c,num_Total_number_of_man_days_requested__c,chk_Contract_Attached__c,pkl_Status__c,pkl_Currency__c,num_Expense_charges_of_LOI__c,txt_Internal_PWO_ID__c,dt_LOI_End_date__c,dt_LOI_Start_Date__c,mpkl_Phases_covered_by_WAR__c,txt_PWO_number__c,txt_PWO_title__c,lkp_Unilever_budget_approver__c,txt_Unilever_Clarity_ID__c,lkp_Unilever_content_approver__c, txt_Other_Currency__c from CPA_LOI__c where id =: loiId];
         system.debug('LoiRec>>>>'+LoiRec);

         CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(LoiRec.pkl_Status__c);
         if(customSettingStatusMsg.LOI_Status_Msg__c != null && callFromVF){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.LOI_Status_Msg__c));
         }
         
        System.debug('LoiRec >> ' + LoiRec);
     
         if(LoiRec != null){
            System.debug('Building Map !! ' );
              if((LoiRec.pkl_Status__c == 'Saved' || LoiRec.pkl_Status__c == 'Withhold') || !callFromVF){
             if(LoiRec.pkl_Currency__c == 'Select' || LoiRec.pkl_Currency__c == null)
                 RequiredFieldMap.put('Currency',ConstantsForContractingAppClasses.MANDATORY);  
              if(LoiRec.pkl_Currency__c == 'OTHER'){
                  if(LoiRec.txt_Other_Currency__c == null){
                    RequiredFieldMap.put('Other Currency','It is mandatory if OTHER as Currency');      
                  }
              }
             
             if(LoiRec.num_Expense_charges_of_LOI__c == null)
                 RequiredFieldMap.put('Expense charges of LOI',ConstantsForContractingAppClasses.MANDATORY);
             if(LoiRec.num_Total_number_of_man_days_requested__c == null)
                 RequiredFieldMap.put('Total number of man days requested',ConstantsForContractingAppClasses.MANDATORY);
             if(LoiRec.num_Total_value_in_being_requested_for__c == null)
                 RequiredFieldMap.put('W@R € spend approved at MC Rates',ConstantsForContractingAppClasses.MANDATORY); 
             if(LoiRec.cur_Total_value_in_Euro_being_requested__c == null)
                 RequiredFieldMap.put('Total value in Euro being requested',ConstantsForContractingAppClasses.MANDATORY);    
             //if(LoiRec.chk_Contract_Attached__c != true)
             if(!LoiRec.chk_Contract_Attached__c)
                  RequiredFieldMap.put('Contract has not been attached. Attach the contract and append the file name with a prefix - LOI',ConstantsForContractingAppClasses.MANDATORY);
             if(LoiRec.mpkl_Phases_covered_by_WAR__c == null)
                 RequiredFieldMap.put('Phases covered by WAR',ConstantsForContractingAppClasses.MANDATORY);          
             if(LoiRec.txt_PWO_number__c == null)
                 RequiredFieldMap.put('PWO number',ConstantsForContractingAppClasses.MANDATORY);        
             if(LoiRec.txt_PWO_title__c == null)
                 RequiredFieldMap.put('PWO title',ConstantsForContractingAppClasses.MANDATORY);          
             if(LoiRec.pkl_Status__c == null)
                 RequiredFieldMap.put('Status',ConstantsForContractingAppClasses.MANDATORY);         
             if(LoiRec.txt_Unilever_Clarity_ID__c == null)
                 RequiredFieldMap.put('Unilever Clarity ID',ConstantsForContractingAppClasses.MANDATORY);
             if(LoiRec.dt_LOI_Start_Date__c == null)
                 RequiredFieldMap.put('LOI Start Date','LOI Start Date is mandatory');
             if(LoiRec.dt_LOI_Start_Date__c != null && LoiRec.dt_LOI_Start_Date__c < system.today())
                RequiredFieldMap.put('LOI Start Date','LOI Start Date cannot be a date from the past.');
             if(LoiRec.dt_LOI_End_date__c == null)
                RequiredFieldMap.put('LOI End date','LOI End Date is mandatory');
            if(LoiRec.dt_LOI_End_date__c != null &&  LoiRec.dt_LOI_End_date__c < LoiRec.dt_LOI_Start_Date__c)
                 RequiredFieldMap.put('LOI End date','LOI End Date cannot before Start date');
             if(LoiRec.mpkl_Phases_covered_by_WAR__c!=null && LoiRec.mpkl_Phases_covered_by_WAR__c.contains('Other') && LoiRec.txt_Other_Phases_Covered_by_W_R__c== null)
                 RequiredFieldMap.put('Other Phases Covered by W@R','If Other Phase covered is selected then this field is mandatory');
             System.debug('Building Map Done!! ' );
             System.debug('RequiredFieldMap >> ' + RequiredFieldMap);   
            }
         }
        if(!RequiredFieldMap.isEmpty()){ 
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Bellow field are mandatory to Submit the record'));          
            mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
            return false;
        }  
        return true;
    }
 
 
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;

        CPA_LOI_InformationController obj = new CPA_LOI_InformationController();
        flag = obj.CreateRequiredFieldMessage(objId,false); 
        system.debug('flag --> '+ flag);
    
        return flag; 
    }
}