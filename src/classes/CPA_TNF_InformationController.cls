global with sharing class CPA_TNF_InformationController {
    public id tnfid;
    Public CPA_TNF__c TnfRec;
    public String mandatoryString;
    public String mandatoryStringFlag {get; set;}   
    public Map<String,String> RequiredFieldMap {get; set;}
    boolean callFromVF = false;
    
     //below constructor will be call from VF page
    public CPA_TNF_InformationController(ApexPages.StandardController controller) {
        callFromVF = true;
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            tnfid = ApexPages.currentPage().getParameters().get('id');
            CreateRequiredFieldMessage(tnfid, callFromVF);
        }
    }
    
    //below constructor will be call from webservice call
    public CPA_TNF_InformationController(){}
    
    
    boolean CreateRequiredFieldMessage(id tnfid ,boolean callFromVF){
        RequiredFieldMap = new Map<String,String>();
        mandatoryStringFlag = null;
     TnfRec= [select id,isValidated__c,pkl_Status__c,pkl_Currency__c,txt_Unilever_Clarity_ID__c,txt_Approved_by__c,dt_TD_Date_Notified__c,dt_TD_Effective_Date__c,txt_PWO_number__c,txt_PWO_title__c,txt_Reason_for_termination__c,txt_TNF_ID__c,txt_Relocation_of_resources__c,txt_Comments__c,num_Variance_in_charges__c,num_Variance_in_effort__c,num_Planned_charges__c,num_Actual_charges__c,txt_Actual_effort_in_days__c,num_Planned_effort_in_days__c,txt_TD_Notice_Required__c,pkl_Terminated_by__c,txt_Accenture_Contact__c,lkp_Unilever_Contact__c,txt_Other_Currency__c from CPA_TNF__c where Id=:tnfid];
     system.debug('TnfRec>>>>'+TnfRec);
     
     CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(TnfRec.pkl_Status__c);
      if(customSettingStatusMsg.TNF_Status_Msg__c != null  && callFromVF){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.TNF_Status_Msg__c));
     }
      if(TnfRec!= null){
          if((TnfRec.pkl_Status__c == 'Saved') || callFromVF == false){
              if(TnfRec.pkl_Currency__c == 'Select')
                 RequiredFieldMap.put('Currency',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_Unilever_Clarity_ID__c == null)
                 RequiredFieldMap.put('Unilever Clarity ID',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_Approved_by__c == null)
                 RequiredFieldMap.put('Approved by',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.dt_TD_Date_Notified__c == null)
                 RequiredFieldMap.put('Date Notified',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.dt_TD_Effective_Date__c == null)
                 RequiredFieldMap.put('Effective Date',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_PWO_number__c == null)
                 RequiredFieldMap.put('PWO number',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_PWO_title__c== null)
                 RequiredFieldMap.put('PWO title',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_Reason_for_termination__c == null)
                 RequiredFieldMap.put('Reason for termination',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_TNF_ID__c == null)
                 RequiredFieldMap.put('TNF ID',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_Relocation_of_resources__c == null)
                 RequiredFieldMap.put('Relocation of resources',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_Comments__c == null)
                 RequiredFieldMap.put('Comments',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.num_Variance_in_charges__c == null)
                 RequiredFieldMap.put('Variance in charges',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.num_Variance_in_effort__c == null)
                 RequiredFieldMap.put('Variance in effort',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.num_Planned_charges__c == null)
                 RequiredFieldMap.put('Planned charges',ConstantsForContractingAppClasses.MANDATORY);   
              if(TnfRec.num_Actual_charges__c == null)
                 RequiredFieldMap.put('Actual charges',ConstantsForContractingAppClasses.MANDATORY); 
              if(TnfRec.txt_Actual_effort_in_days__c == null)
                 RequiredFieldMap.put('Actual effort in days',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.num_Planned_effort_in_days__c == null)
                 RequiredFieldMap.put('Planned effort in days',ConstantsForContractingAppClasses.MANDATORY); 
              if(TnfRec.txt_TD_Notice_Required__c == null)
                 RequiredFieldMap.put('Notice Required',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.pkl_Terminated_by__c== null)
                 RequiredFieldMap.put('Terminated by',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_Accenture_Contact__c == null)
                 RequiredFieldMap.put('Accenture Contact',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.lkp_Unilever_Contact__c == null)
                 RequiredFieldMap.put('Unilever Contact',ConstantsForContractingAppClasses.MANDATORY);
              if(TnfRec.txt_Other_Currency__c == null && TnfRec.pkl_Currency__c == 'Other') 
                 RequiredFieldMap.put('Other Currency',ConstantsForContractingAppClasses.MANDATORY);
             }              
        }   
        if(RequiredFieldMap != null && !RequiredFieldMap.isEmpty()){ 
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Bellow field are mandatory to Submit the record'));
            mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
            return false;
        }         
        return true; 
     }  

    public void UpdateTNF() {
               if(!RequiredFieldMap.isEmpty()){
                if(TnfRec.isValidated__c != false){
                        TnfRec.isValidated__c = false;  
                        update TnfRec;                   
                }   
            }else if(TnfRec.isValidated__c != true){
                        TnfRec.isValidated__c = true;  
                        update TnfRec;                   
             }
            
        }  

    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;

        CPA_TNF_InformationController obj = new CPA_TNF_InformationController();
        flag = obj.CreateRequiredFieldMessage(objId,false); 
        system.debug('flag --> '+ flag);
    
        return flag; 
    }
        
                 
}