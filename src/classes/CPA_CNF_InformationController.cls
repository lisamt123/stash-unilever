global with sharing class CPA_CNF_InformationController {
public id cnfId;
public CPA_CNF__c cnfRec;
public String mandatoryString;   
public String mandatoryStringFlag {get; set;}   
public Map<String,String> RequiredFieldMap {get; set;}
 
boolean callFromVF = false;
    
     //below constructor will be call from VF page
  public CPA_CNF_InformationController(ApexPages.StandardController controller) {
      callFromVF = true;
      
      RequiredFieldMap = new Map<String,String>();
      if(ApexPages.currentPage().getParameters().get('id') != null) {      
          cnfId= ApexPages.currentPage().getParameters().get('id');
          
          CreateRequiredFieldMessage(cnfId, callFromVF);
      }
  }
  
  //below constructor will be call from webservice call
    public CPA_CNF_InformationController(){}
  
  boolean CreateRequiredFieldMessage(id cnfId ,boolean callFromVF){
    RequiredFieldMap = new Map<String,String>();
    mandatoryStringFlag = null;
    cnfRec = [select id,chkb_isValidated__c,pkl_Status__c,txt_Accenture_Project_Manager__c,num_Actual_Day_rate__c,num_Actual_expenses__c,num_Actual_fees_inclusive_of_discount__c,num_Actual_man_days__c,num_Actual_PMO_tax__c,dt_Actual_PWO_End_Date__c,num_Actual_total_charges__c,mpkl_Currency__c,num_Planned_Day_rate__c,num_Planned_expenses__c,num_Planned_fees_inclusive_of_discount__c,num_Planned_man_days__c,num_Planned_PMO_tax__c,dt_Planned_PWO_End_Date__c,num_Planned_total_charges__c,txt_PWO_number__c,txt_PWO_title__c,lkp_Unilever_budget_approver__c,txt_Unilever_Clarity_ID__c,lkp_Unilever_content_approver__c,num_Variance_number_in_man_days__c from CPA_CNF__c where id =: cnfId];
     //system.debug('cnfRec >>>>'+cnfRec);
    
     CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(cnfRec.pkl_Status__c);
     if(customSettingStatusMsg.CNF_Status_Msg__c != null  && callFromVF){
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.CNF_Status_Msg__c));
     }
     
      if(cnfRec != null){
        if((cnfRec.pkl_Status__c == 'Saved' || cnfRec.pkl_Status__c == 'Withhold')  || callFromVF == false){ 
            if(cnfRec.txt_Accenture_Project_Manager__c== null) RequiredFieldMap.put('Accenture Project Manager','Mandatory');
            if(cnfRec.num_Actual_Day_rate__c== null) RequiredFieldMap.put('Actual Day rate','Mandatory');
            if(cnfRec.num_Actual_expenses__c== null) RequiredFieldMap.put('Actual expenses','Mandatory');
            if(cnfRec.num_Actual_fees_inclusive_of_discount__c== null) RequiredFieldMap.put('Actual fees (inclusive of discount)','Mandatory');
            if(cnfRec.num_Actual_man_days__c== null) RequiredFieldMap.put('Actual man-days','Mandatory');
            if(cnfRec.num_Actual_PMO_tax__c== null) RequiredFieldMap.put('Actual PMO tax','Mandatory');
            if(cnfRec.dt_Actual_PWO_End_Date__c== null) RequiredFieldMap.put('Actual PWO End Date','Mandatory');
            if(cnfRec.num_Actual_total_charges__c== null) RequiredFieldMap.put('Actual total charges','Mandatory');
            if(cnfRec.mpkl_Currency__c== null) RequiredFieldMap.put('Currency','Mandatory');
            if(cnfRec.num_Planned_Day_rate__c== null) RequiredFieldMap.put('Planned Day rate','Mandatory');
            if(cnfRec.num_Planned_expenses__c== null) RequiredFieldMap.put('Planned expenses','Mandatory');
            if(cnfRec.num_Planned_fees_inclusive_of_discount__c== null) RequiredFieldMap.put('Planned fees (inclusive of discount)','Mandatory');
            if(cnfRec.num_Planned_man_days__c== null) RequiredFieldMap.put('Planned man-days','Mandatory');
            if(cnfRec.num_Planned_PMO_tax__c== null) RequiredFieldMap.put('Planned PMO tax','Mandatory');
            if(cnfRec.dt_Planned_PWO_End_Date__c== null) RequiredFieldMap.put('Planned PWO End Date','Mandatory');
            if(cnfRec.num_Planned_total_charges__c== null) RequiredFieldMap.put('Planned total charges','Mandatory');
            if(cnfRec.txt_PWO_number__c== null) RequiredFieldMap.put('PWO number','Mandatory');
            if(cnfRec.txt_PWO_title__c== null) RequiredFieldMap.put('PWO title','Mandatory');
            if(cnfRec.lkp_Unilever_budget_approver__c== null) RequiredFieldMap.put('Unilever budget approver','Mandatory');
            if(cnfRec.txt_Unilever_Clarity_ID__c== null) RequiredFieldMap.put('Unilever Clarity ID','Mandatory');
            if(cnfRec.lkp_Unilever_content_approver__c== null) RequiredFieldMap.put('Unilever content approver','Mandatory');
            if(cnfRec.num_Variance_number_in_man_days__c== null) RequiredFieldMap.put('Variance (number in man-days)','Mandatory');
         
        }           
     }
        if(!RequiredFieldMap.isEmpty()){ 
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Bellow field are mandatory to Submit the record'));
            mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
            return false;
        }  
        return true;
    }//end CreateRequiredFieldMessage(id loiId)

     public void UpdateCnf() {
             if(!RequiredFieldMap.isEmpty()){
                if(cnfRec.chkb_isValidated__c != false){
                        cnfRec.chkb_isValidated__c = false;  
                        update cnfRec;                   
                }   
            }else if(cnfRec.chkb_isValidated__c != true){
                        cnfRec.chkb_isValidated__c = true;  
                        update cnfRec;                   
             }
            
        }
        
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;

        CPA_CNF_InformationController obj = new CPA_CNF_InformationController();
        flag = obj.CreateRequiredFieldMessage(objId,false); 
        system.debug('flag --> '+ flag);
    
        return flag; 
    }
  
} // end class