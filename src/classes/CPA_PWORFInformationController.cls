global with sharing class CPA_PWORFInformationController {
 Public id pworfId;
 Public CPA_PWORF__c pworfRec;
 Public CPA_PWORF__c pworfRecord;
 public Map<String,String> objectMap {get; set;}
 public String mandatoryStringFlag {get; set;}   
  
  boolean callFromVF = false;
  
  //below constructor will be call from VF page
    public CPA_PWORFInformationController(ApexPages.StandardController controller) {
        callFromVF = true;
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            pworfId = ApexPages.currentPage().getParameters().get('id');
            system.debug('pworfId>>>>'+pworfId);
            CPA_Messages(pworfId,callFromVF);         
        }
    } 
    
     //below constructor will be call from webservice call
    public CPA_PWORFInformationController(){}
    
    boolean CPA_Messages(id pworfRecId,boolean callFromVF){
        objectMap = new Map<String,String>();
        Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll(); 
        mandatoryStringFlag = null;
       pworfRec = [select id,pkl_Status__c,Business_Case__c,pkl_Business_Area__c ,In_Scope__c,txta_Acceptance_Criteria__c,Analyse_sessions_expected__c,Will_this_project_require_an_LOI_for_Wor__c,RecordTypeid,Out_of_Scope__c,Overall_purpose_or_function_of_the_proje__c,Stakeholder_Expectations__c,txta_Title__c,lkp_Unilever_budget_approver__c,lkp_Unilever_content_approver__c,lkp_Unilever_Finance_BP_Contact__c,lkp_Unilever_project_manager__c,txta_Application_infrastructure__c,txta_Business_critical_milestones__c,Expected_Business_Go_live_date__c,dt_Expected_go_live_date__c,dt_Expected_start_date__c,Expected_Start_Date_for_DBTD_PWO__c,Expected_Start_Date_for_Plan_and_Analyse__c,Impact_if_expected_business_go_live_date__c,Planning_sessions_expected__c,Project_Dependencies__c,Summary_of_requirements_and_deliverables__c,Travel_Arrangements__c,Who_will_support_this_service_once_live__c,pkl_Cost_Centre_Details__c,txt_Cost_Centre__c,txt_ICC_Number__c,pkl_Landscape__c,pkl_Request_Type__c,txta_Other_Request_Type__c,pkl_Pricing_Model__c,pkl_Region__c,dat_Revised_Submission_Date__c,Does_this_project_change_Core_Business_M__c,Does_this_Project_involve_Unilever_conf__c,Governance_Risk_and_Compliance__c,Has_W_R_been_discussed_with_Supplier_Per__c,Interface_to_the_system__c,Interface_to_the_system_Detail__c,Is_Project__c,Is_Project_Require__c,Is_this_a_new_or_re_worked_Integration_R__c,pkl_Is_this_Project_Invasive_in_nature__c,pkl_Process_Office_Area_E2E__c,mpkl_Project_Phases__c,pkl_Project_Scale__c,Role_or_System_Authorisation__c,txta_Project_Invasive_in_nature__c,txta_Role_or_System_Authorisation_detail__c,txta_Project_Require_Performance_Testing__c,Project_Require_Data_Specific_Testing__c,txt_OtherProjectPhases__c,txt_otherProcessOfficeAreaE2E__c,isValidated__c,txt_Role_Level_1_13__c,txt_Resource_Location__c,per_Budget_Expenses_of_Resource_Cost__c,dat_Indicative_timeline_End_date__c,dat_Indicative_timeline_Start_date__c,How_many_man_days_do_you_think_you_requi__c,When_do_you_require_the_Work_at_Risk_to__c,txta_Why_is_Work_at_risk_required__c,txta_What_specific_roles_do_you_require__c,txta_ITC_Resources_Utilisation__c,Which_BP_Innovation_director_has_approve__c ,pkl_Phases_covered_by_the_WAR__c,txta_PWO_linked_to_CR__c from CPA_PWORF__c where id =:pworfRecId];
        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(pworfRec.pkl_Status__c); 
        
        if(customSettingStatusMsg.Status_Message__c != null && callFromVF){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.Status_Message__c));
        }
        if((pworfRec.pkl_Status__c == 'Saved' || pworfRec.pkl_Status__c == 'Withhold')  || !callFromVF){

           
            if(pworfRec.Business_Case__c == null)
                objectMap.put('Business Case',CPA_ConstantsForContractingAppClasses.MANDATORY);              
            if((pworfRec.In_Scope__c ==null))
                objectMap.put('In Scope',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.Out_of_Scope__c == null)
                objectMap.put('Out of Scope',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.Overall_purpose_or_function_of_the_proje__c == null)
                objectMap.put('Overall purpose/function of the project',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.Stakeholder_Expectations__c == null)
                objectMap.put('Stakeholder Expectations',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.txta_Title__c == null )
                objectMap.put('Title',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.lkp_Unilever_budget_approver__c == null)
                objectMap.put('Unilever budget approver',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.lkp_Unilever_content_approver__c == null)
                objectMap.put('Unilever content approver',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.lkp_Unilever_Finance_BP_Contact__c ==null)
                objectMap.put('Unilever Finance BP/Contact',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.lkp_Unilever_project_manager__c ==null)
                objectMap.put('Unilever project manager',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if( pworfRec.pkl_Business_Area__c =='Select' || pworfRec.pkl_Business_Area__c ==null)
                objectMap.put('Business Area',CPA_ConstantsForContractingAppClasses.MANDATORY);       
            if(pworfRec.txt_Cost_Centre__c != null && (pworfRec.pkl_Cost_Centre_Details__c =='Select' || pworfRec.pkl_Cost_Centre_Details__c ==null)) 
                objectMap.put('Cost Centre Details',CPA_ConstantsForContractingAppClasses.MANDATORY);         
            if(pworfRec.txt_Cost_Centre__c ==null && pworfRec.txt_ICC_Number__c ==null){  
                objectMap.put('Cost Center','Mandatory. But if ICC number is provided, CC can be avoided.');
                objectMap.put('ICC Number','Mandatory only when the Cost Center is not provided.');
            }           
            if(pworfRec.pkl_Landscape__c  =='Select' || pworfRec.pkl_Landscape__c  ==null ) 
                objectMap.put('Landscape',CPA_ConstantsForContractingAppClasses.MANDATORY);         
            if(pworfRec.pkl_Pricing_Model__c =='Select' || pworfRec.pkl_Pricing_Model__c ==null)  
                objectMap.put('Pricing Model',CPA_ConstantsForContractingAppClasses.MANDATORY);                            
            if(pworfRec.pkl_Region__c  =='Select' || pworfRec.pkl_Region__c  == null)    
                objectMap.put('Region',CPA_ConstantsForContractingAppClasses.MANDATORY);           
            
            if(pworfRec.pkl_Request_Type__c =='Select' || pworfRec.pkl_Request_Type__c ==null )   
                objectMap.put('Request Type',CPA_ConstantsForContractingAppClasses.MANDATORY);
            if(pworfRec.pkl_Request_Type__c  =='Other' && pworfRec.txta_Other_Request_Type__c  == null )  
                objectMap.put('Other Request Type','Mandatory, If Other is selected in Request Type.'); 
            
            if(pworfRec.txta_PWO_linked_to_CR__c== null  &&  pworfRec.pkl_Request_Type__c== 'Project Scope Change (CR)')
                objectMap.put('PWO linked to CR' ,'Mandatory, If Request Type is Project Scope Change (CR).');
                
            //if(pworfRec.dat_Revised_Submission_Date__c <= date.Today())  
                //objectMap.put('Revised Submission Date',CPA_ConstantsForContractingAppClasses.MANDATORY);
            
            if(pworfRec.RecordTypeid == customSettingPworfRT.get('All').Record_type_id__c ){
                if((pworfRec.txta_Acceptance_Criteria__c==null))
                    objectMap.put('Acceptance Criteria' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if((pworfRec.Analyse_sessions_expected__c==null))
                    objectMap.put('Analyse sessions expected' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.txta_Application_infrastructure__c ==null)
                    objectMap.put('Application infrastructure' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.txta_Business_critical_milestones__c ==null)
                    objectMap.put('Business critical milestones' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Expected_Business_Go_live_date__c  == null)
                    objectMap.put('Expected Business Go live date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.dt_Expected_go_live_date__c  == null)
                    objectMap.put('Expected go-live date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.dt_Expected_start_date__c == null)
                    objectMap.put('Expected start date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Expected_Start_Date_for_DBTD_PWO__c == null)
                    objectMap.put('Expected Start Date for DBTD PWO' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Expected_Start_Date_for_Plan_and_Analyse__c == null)
                    objectMap.put('Expected PA Start Date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Impact_if_expected_business_go_live_date__c == null)
                    objectMap.put('Impact if go live date not met' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Planning_sessions_expected__c ==null)
                    objectMap.put('Planning sessions expected' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Project_Dependencies__c ==null)
                    objectMap.put('Project Dependencies' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Summary_of_requirements_and_deliverables__c ==null)
                    objectMap.put('Summary of requirements and deliverables' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Travel_Arrangements__c ==null)
                    objectMap.put('Travel Arrangements' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Who_will_support_this_service_once_live__c ==null)
                    objectMap.put('Post Go-Live Support Service' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if( pworfRec.Does_this_project_change_Core_Business_M__c =='Select' || pworfRec.Does_this_project_change_Core_Business_M__c ==null)   
                    objectMap.put('Core Business Model changed?' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Does_this_Project_involve_Unilever_conf__c =='Select' || pworfRec.Does_this_Project_involve_Unilever_conf__c ==null) 
                    objectMap.put('3rd Party/Unilever Confidential Data' ,CPA_ConstantsForContractingAppClasses.MANDATORY); 
                //if(pworfRec.Expected_Business_Go_live_date__c <= date.Today())   
                    //objectMap.put('Expected Business Go live date', 'Date should be greater than current date');  
                //if(pworfRec.dt_Expected_start_date__c <= date.Today())   
                    //objectMap.put('Expected start date', 'Date should be greater than current date'); 
                //if(pworfRec.Expected_Start_Date_for_DBTD_PWO__c  <= date.Today())    
                    //objectMap.put('Expected Start Date for DBTD PWO', 'Date should be greater than current date');
                //if(pworfRec.Expected_Start_Date_for_Plan_and_Analyse__c <= date.Today()) 
                    //objectMap.put('Expected Start Date for Plan and Analyse', 'Date should be greater than current date');            
                if(pworfRec.Governance_Risk_and_Compliance__c =='Select' || pworfRec.Governance_Risk_and_Compliance__c ==null)  
                    objectMap.put('Governance Risk and Compliance' ,CPA_ConstantsForContractingAppClasses.MANDATORY);          
                if(pworfRec.Has_W_R_been_discussed_with_Supplier_Per__c =='Select' || pworfRec.Has_W_R_been_discussed_with_Supplier_Per__c ==null)    
                    objectMap.put('Has W@R been discussed with Supplier Per' ,CPA_ConstantsForContractingAppClasses.MANDATORY);        
                if(pworfRec.Interface_to_the_system__c  =='Select' || pworfRec.Interface_to_the_system__c  ==null)    
                    objectMap.put('Interface Introduced/Changed?' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.Interface_to_the_system__c  =='Yes' && pworfRec.Interface_to_the_system_Detail__c == null )    
                    objectMap.put('Interface to the system Detail' ,'Mandatory, If there is Interface to the system');
                if(pworfRec.Is_Project__c  =='Select' || pworfRec.Is_Project__c  ==null)    
                    objectMap.put('Data-specific testing required?' ,CPA_ConstantsForContractingAppClasses.MANDATORY);    
                if(pworfRec.Is_Project_Require__c   =='Select' || pworfRec.Is_Project_Require__c   == null )   
                    objectMap.put('Application Performance Testing Needed' ,CPA_ConstantsForContractingAppClasses.MANDATORY);  
                if(pworfRec.Is_this_a_new_or_re_worked_Integration_R__c =='Select' || pworfRec.Is_this_a_new_or_re_worked_Integration_R__c ==null)   
                    objectMap.put('New or ReWorked Integration Requirement' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.pkl_Is_this_Project_Invasive_in_nature__c  =='Select' || pworfRec.pkl_Is_this_Project_Invasive_in_nature__c  ==null)    
                    objectMap.put('Is this ‘Project’ Invasive in nature?' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.pkl_Process_Office_Area_E2E__c =='Other' && pworfRec.txt_otherProcessOfficeAreaE2E__c == null )  
                    objectMap.put('Other-Process Office area E2E' ,'Mandatory, If Other is selected in Process Office area E2E.');
                if(pworfRec.mpkl_Project_Phases__c =='Other' && pworfRec.txt_OtherProjectPhases__c == null ) 
                    objectMap.put('Other Project Phases' ,'Mandatory, If Other is selected in Project Phases.');            
                if(pworfRec.pkl_Process_Office_Area_E2E__c =='Select' || pworfRec.pkl_Process_Office_Area_E2E__c ==null)    
                    objectMap.put('Process Office Area E2E' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.mpkl_Project_Phases__c ==null )  
                    objectMap.put('Project Phases' ,CPA_ConstantsForContractingAppClasses.MANDATORY);                          
                if(pworfRec.Is_Project__c  =='Yes' && pworfRec.Project_Require_Data_Specific_Testing__c == null ) 
                    objectMap.put('Project Require Data Specific Testing' ,'Mandatory, If Project Require Data Specific Testing');                   
                if(pworfRec.Is_Project_Require__c  =='Yes' && pworfRec.txta_Project_Require_Performance_Testing__c  == null ) 
                    objectMap.put('Project Require Performance Testing' ,'Mandatory, If Project Require Performance Testing');     
                if(pworfRec.pkl_Project_Scale__c  =='Select' || pworfRec.pkl_Project_Scale__c  ==null) 
                    objectMap.put('Project Scale' ,CPA_ConstantsForContractingAppClasses.MANDATORY);    
                if(pworfRec.Role_or_System_Authorisation__c =='Select' || pworfRec.Role_or_System_Authorisation__c ==null )   
                    objectMap.put('Role/Authorisation Introduced/Changed?' ,CPA_ConstantsForContractingAppClasses.MANDATORY);        
                if(pworfRec.Role_or_System_Authorisation__c  =='Yes'&& pworfRec.txta_Role_or_System_Authorisation_detail__c  == null) 
                    objectMap.put('Role or System Authorisation detail' ,'Mandatory, if the project has Role or System Authorization'); 
                if(pworfRec.pkl_Is_this_Project_Invasive_in_nature__c =='Yes' && pworfRec.txta_Project_Invasive_in_nature__c == null) 
                    objectMap.put('Work at Risk required?' ,'Mandatory, If Project is Invasive in nature');
                if(pworfRec.Will_this_project_require_an_LOI_for_Wor__c =='Select' || pworfRec.Will_this_project_require_an_LOI_for_Wor__c ==null)
                    objectMap.put('Work at Risk required?*' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                //if(pworfRec.dt_Expected_go_live_date__c <= date.Today()) 
                    //objectMap.put('Expected go-live date', 'Date should be greater than current date');
                if(pworfRec.Will_this_project_require_an_LOI_for_Wor__c  == 'Yes'){
                    if(pworfRec.How_many_man_days_do_you_think_you_requi__c  == null) objectMap.put('Man Days required for W@R' ,'Mandatory,If this Project require LOI');
                    if(pworfRec.When_do_you_require_the_Work_at_Risk_to__c  == null) objectMap.put('Work at Risk Start Date' ,'Mandatory,If this Project require LOI');
                    if(pworfRec.txta_Why_is_Work_at_risk_required__c  == null) objectMap.put('Why is Work at Risk required?' ,'Mandatory,If this Project require LOI');
                    if(pworfRec.txta_What_specific_roles_do_you_require__c  == null) objectMap.put('What specific roles do you require?' ,'Mandatory,If this Project require LOI');
                    if(pworfRec.txta_ITC_Resources_Utilisation__c  == null) objectMap.put('ITC Resources Utilisation' ,'Mandatory,If this Project require LOI');
                    if(pworfRec.Which_BP_Innovation_director_has_approve__c  == null) objectMap.put('Director who approved W@R spend' ,'Mandatory,If this Project require LOI');
                    if(pworfRec.pkl_Phases_covered_by_the_WAR__c  == null && pworfRec.pkl_Phases_covered_by_the_WAR__c  == 'Select') objectMap.put('Phases covered by the WAR' ,'Mandatory,If this Project require LOI');
                }
                
                if(pworfRec.dt_Expected_go_live_date__c  != null && pworfRec.dt_Expected_go_live_date__c  < pworfRec.dt_Expected_start_date__c )
                       objectMap.put('Expected go-live date','Expected go-live date canot be before Expected start date');
                Boolean user_has_permission = false;                
                List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() ];
                system.debug('##lstcurrentUserPerSet' + lstcurrentUserPerSet);
                for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
                    System.debug('##psa.PermissionSet.Name' + psa.PermissionSet.Name);
                    string permission = psa.PermissionSet.Name;
                    if (permission.CONTAINS('CPA_SMT')){
                        user_has_permission = true;
                        break;
                    }
                }
                if(!user_has_permission){                    
                    if(pworfRec.dt_Expected_start_date__c  != null && pworfRec.dt_Expected_start_date__c  < date.today() )
                       objectMap.put('Expected start date','Expected start date canot be past date');
                    if(pworfRec.dt_Expected_go_live_date__c  != null && pworfRec.dt_Expected_go_live_date__c  < date.today() )
                       objectMap.put('Expected go-live date','Expected go-live date canot be past date');                  
                }
            }else if(pworfRec.RecordTypeid == customSettingPworfRT.get('RA').Record_type_id__c ){
                if(pworfRec.txt_Role_Level_1_13__c == null)
                    objectMap.put('Role (Level 1-13)' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.txt_Resource_Location__c == null)
                    objectMap.put('Resource Location' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.per_Budget_Expenses_of_Resource_Cost__c == null)
                    objectMap.put('Budget Expenses (% of Resource Cost)' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.dat_Indicative_timeline_End_date__c == null)
                    objectMap.put('Indicative timeline end date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
                if(pworfRec.dat_Indicative_timeline_Start_date__c == null)
                    objectMap.put('Indicative timeline start date' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
            }
            //if(callFromVF){
                    PWORFrelatedCheck(pworfRecId);
           // }
            
        }
        if(!objectMap.isEmpty()){ 
                mandatoryStringFlag = 'Below field(s) are mandatory to Submit the record';
            return false;
        }  
        return true; 
        
    }
    void PWORFrelatedCheck(id pworfRecordId){ 
       Map<string,CPA_PWORF_Record_type__c> customSettingPworfRT = CPA_PWORF_Record_type__c.getAll();
        pworfRecord = [SELECT Id,(SELECT PWORF_Requirement_Deliverables__c FROM Requirements_and_Deliverables__r),(select id from PWORF_Key_Contact__r),(SELECT lkp_PWORF__c FROM Risk_Assessment_and_Mitigation__r) FROM CPA_PWORF__c WHERE Id =:pworfRecordId];
        if(pworfRecord.Requirements_and_Deliverables__r.size()==0 ) objectMap.put('Requirements and Deliverables' ,CPA_ConstantsForContractingAppClasses.MANDATORY);
        if(pworfRecord.PWORF_Key_Contact__r.size()==0) objectMap.put('Key Contacts' ,CPA_ConstantsForContractingAppClasses.MANDATORY);        
        /*if(pworfRec.RecordTypeid == customSettingPworfRT.get('RA').Record_type_id__c ){
            if(pworfRecord.Risk_Assessment_and_Mitigation__r.size()==0) objectMap.put('Risk Assessment and Mitigation' ,CPA_ConstantsForContractingAppClasses.MANDATORY);            
        }*/
   }
   
    
    webService static boolean checkIsValidated(Id objId) {
        boolean flag ;
        CPA_PWORFInformationController obj = new CPA_PWORFInformationController();
        flag = obj.CPA_Messages(objId,false); 
        system.debug('flag --> '+ flag);    
        return flag; 
    }

}