global class CPA_PWOInformationController {
 public id pwoId;
 public CPA_PWO__c pwoRec;
 public Map<String,String> RequiredFieldMap {get; set;}
 public String mandatoryStringFlag {get; set;}   

 boolean callFromVF = false;
    
     //below constructor will be call from VF page 
    public CPA_PWOInformationController(ApexPages.StandardController controller) {
        callFromVF = true;
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            pwoId = ApexPages.currentPage().getParameters().get('id');
            CPA_Messages(pwoId,callFromVF);
        }
    } 
    
     //below constructor will be call from webservice call
    public CPA_PWOInformationController(){}
    
    boolean CPA_Messages(id pwoRecId,boolean callFromVF){
    RequiredFieldMap = new Map<String,String>();
        mandatoryStringFlag = null;
        
        pwoRec = [select id,isValidated__c,chk_Excel_Attached__c,chk_PDF_Attached__c,pkl_Status__c,txt_PWO_number__c,pkl_Region__c ,txt_PWO_title__c,mpkl_Project_Classification__c,txt_Unilever_Project_Name__c,mpkl_Unilever_Innovation_Area__c,pkl_Billing_Details__c,txt_Accenture_Project_Manager__c,dt_Date_PWORF_accepted__c,num_Estimated_Man_days_of_PWO__c,num_Estimated_Value_of_PWO__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,lkp_Unilever_Finance_BP_Contact__c,dt_Project_Initiation_Date__c,dt_Expected_Start_Date__c,dt_Expected_End_date__c,mpkl_Project_Phases__c,pkl_Pricing_Model__c,num_Target_Blend_Rate__c,num_Varied_Target_Blend_Rate__c,pec_Variance__c,pec_Estimated_Off_shore__c,pec_Estimated_On_shore__c,pec_Expense__c,num_Expense_charges_of_work_order__c,num_Total_work_order_charge__c,Currency__c,txt_Unilever_Reference__c,fml_Clarity_ID__c from CPA_PWO__c where id =:pwoRecId];
        
        
           CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(pwoRec.pkl_Status__c);
           if(customSettingStatusMsg.PWO_Status_Msg__c != null && callFromVF){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.PWO_Status_Msg__c));
        }
        if((pwoRec.pkl_Status__c == 'Saved' || pwoRec.pkl_Status__c == 'Withhold')  || callFromVF == false){
            if(pwoRec.txt_PWO_number__c == null)
                RequiredFieldMap.put( 'PWO number','Mandatory');
            
            if(pwoRec.txt_PWO_title__c == null)
                RequiredFieldMap.put( 'PWO title' ,'Mandatory');
            if(pwoRec.mpkl_Project_Classification__c == null)
                RequiredFieldMap.put( 'Project Classification' ,'Mandatory');
            if(pwoRec.txt_Unilever_Project_Name__c == null)
                RequiredFieldMap.put( 'Unilever Project Name' ,'Mandatory');
            if(pwoRec.mpkl_Unilever_Innovation_Area__c == null)
                RequiredFieldMap.put( 'Unilever Innovation Area' ,'Mandatory');
            if(pwoRec.pkl_Billing_Details__c == null)
                RequiredFieldMap.put( 'Billing Details' ,'Mandatory');
            if(pwoRec.txt_Accenture_Project_Manager__c == null)
                RequiredFieldMap.put( 'Accenture Project Manager' ,'Mandatory');
            if(pwoRec.dt_Date_PWORF_accepted__c == null)
                RequiredFieldMap.put( 'Date PWORF accepted' ,'Mandatory');
            if(pwoRec.num_Estimated_Man_days_of_PWO__c == null)
                RequiredFieldMap.put( 'Estimated Man-days of PWO' ,'Mandatory');
            if(pwoRec.num_Estimated_Value_of_PWO__c == null)
                RequiredFieldMap.put( 'Estimated Value of PWO' ,'Mandatory');
            if(pwoRec.lkp_Unilever_budget_approver__c == null)
                RequiredFieldMap.put( 'Unilever budget approver' ,'Mandatory');
            if(pwoRec.lkp_Unilever_content_approver__c == null)
                RequiredFieldMap.put( 'Unilever content approver' ,'Mandatory');
            if(pwoRec.lkp_Unilever_Finance_BP_Contact__c == null)
                RequiredFieldMap.put( 'Unilever Finance BP/Contact' ,'Mandatory');
            if(pwoRec.dt_Project_Initiation_Date__c == null)
                RequiredFieldMap.put( 'Project Initiation Date' ,'Mandatory');
            if(pwoRec.mpkl_Project_Phases__c == null)
                RequiredFieldMap.put( 'Project Phases' ,'Mandatory');
            if(pwoRec.pkl_Pricing_Model__c == null)
                RequiredFieldMap.put( 'Pricing Model' ,'Mandatory');
            if(pwoRec.num_Target_Blend_Rate__c == null)
                RequiredFieldMap.put( 'Target Blend Rate' ,'Mandatory');
            if(pwoRec.num_Varied_Target_Blend_Rate__c == null)
                RequiredFieldMap.put( 'Varied Target Blend Rate' ,'Mandatory');
            if(pwoRec.pec_Variance__c == null)
                RequiredFieldMap.put( 'Variance %' ,'Mandatory');
            if(pwoRec.pec_Estimated_Off_shore__c == null)
                RequiredFieldMap.put( 'Estimated Off-shore %' ,'Mandatory');
            if(pwoRec.pec_Estimated_On_shore__c == null)
                RequiredFieldMap.put( 'Estimated On-shore %' ,'Mandatory');
            if(pwoRec.pec_Expense__c == null)
                RequiredFieldMap.put( 'Total work order charge' ,'Mandatory');
            if(pwoRec.num_Expense_charges_of_work_order__c == null)
                RequiredFieldMap.put( 'Expense charges of work order' ,'Mandatory');
            if(pwoRec.num_Total_work_order_charge__c == null)
                RequiredFieldMap.put( 'Expense %' ,'Mandatory');
            if(pwoRec.Currency__c == null)
                RequiredFieldMap.put( 'Currency' ,'Mandatory');
            if(pwoRec.txt_Unilever_Reference__c == null && pwoRec.fml_Clarity_ID__c == null)
                RequiredFieldMap.put( 'Unilever Reference ' ,'Mandatory');
                
                 if(pwoRec.chk_Excel_Attached__c!= true  ||pwoRec.chk_PDF_Attached__c !=true){
                RequiredFieldMap.put( 'Commercial details Not attached  ' ,'Mandatory');              
            }
           if(pwoRec.pkl_Region__c == null)
                RequiredFieldMap.put( 'Region' ,'Mandatory'); 
            if(pwoRec.dt_Expected_Start_Date__c == null || pwoRec.dt_Expected_Start_Date__c < System.today() )
                RequiredFieldMap.put( 'Expected Start Date' ,'Its mandatory and should not be before today');
            if(pwoRec.dt_Expected_End_date__c == null || pwoRec.dt_Expected_End_date__c < pwoRec.dt_Expected_Start_Date__c)
                RequiredFieldMap.put( 'Expected End date' ,'Its mandatory and should not be before Expected Start Date');
        }
        
       if(!RequiredFieldMap.isEmpty()){ 
           // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Bellow field are mandatory to Submit the record'));
                mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
         return false;
        }  
        return true;    
    }
    public void UpdatePwo() {
        if(!RequiredFieldMap.isEmpty()){
            if(pwoRec.isValidated__c != false){
                    pwoRec.isValidated__c = false;  
                    update pwoRec;                   
            }   
        }else if(pwoRec.isValidated__c != true){
                    pwoRec.isValidated__c = true;  
                    update pwoRec;                   
         }
        
    }
    
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;

        CPA_PWOInformationController obj = new CPA_PWOInformationController();
        flag = obj.CPA_Messages(objId,false); 
        system.debug('flag --> '+ flag);
    
        return flag; 
    }

}