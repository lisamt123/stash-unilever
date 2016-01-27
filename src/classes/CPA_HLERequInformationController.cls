public class CPA_HLERequInformationController {
Public id hleReqId;
Public CPA_HLE_Request__c hleRec;
Public String mandatoryString;
 
    public CPA_HLERequInformationController (ApexPages.StandardController controller) {
        mandatoryString = '';
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            hleReqId = ApexPages.currentPage().getParameters().get('id');
            CPA_Messages(hleReqId);           
        }
    } 
    void CPA_Messages(id hleRecId){  
        hleRec = [SELECT pkl_Status__c, isValidated__c, dt_Date_raised__c,dt_Planned_end_date__c,dt_Planned_start_date__c,eml_AAL_Email__c,eml_UBPR_Email__c,eml_UIOS_Email__c,Id,mpkl_PFS_If_yes_what_is_the_source__c,Name,OwnerId,PFS_Is_there_approved_funding_for_this__c,ph_AAL_Contact_No__c,ph_UBPR_Contact_No__c,ph_UIOS_Contact_No__c,pkl_Business_area__c,pkl_HLE_type__c,txt_AAL_Name__c,txt_Accenture_skill_types_required__c,txt_Additional_information__c,txt_Assumptions__c,txt_Background__c,txt_Dependencies__c,txt_NA_Notes__c,txt_Project_description_specification__c,txt_Project_type__c,txt_Request_ID__c,txt_Risks_and_issues__c,txt_RQ_Query__c,txt_Software_Licensing_requirements__c,txt_Status__c,txt_Support_impact__c,txt_Technologies__c,txt_Title__c,txt_UBPR_Name__c,txt_UIOS_Name__c,txt_UL_reference__c FROM CPA_HLE_Request__c where id =:hleRecId];
                
        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(hleRec.pkl_Status__c);
        if(customSettingStatusMsg.HLE_Request_Status_Msg__c != null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.HLE_Request_Status_Msg__c));
        }
        if((hleRec.pkl_Status__c == 'Saved')){
            if(hleRec.txt_Assumptions__c  == null)  
                 mandatoryString = mandatoryString + 'Assumptions' + ', ';
            if(hleRec.txt_Background__c  == null)  
                 mandatoryString = mandatoryString + 'Background' + ', ';
            if(hleRec.ph_UBPR_Contact_No__c  == null)  
                 mandatoryString = mandatoryString + 'UBPR Contact Number' + ', ';
            if(hleRec.ph_UIOS_Contact_No__c  == null)  
                 mandatoryString = mandatoryString + 'UIOS Contact Number' + ', ';
            if(hleRec.ph_AAL_Contact_No__c  == null)  
                 mandatoryString = mandatoryString + 'AAL Contact Number' + ', ';
            if(hleRec.dt_Date_raised__c == null)  
                 mandatoryString = mandatoryString + 'Date raised' + ', ';
            if(hleRec.txt_Dependencies__c  == null)  
                 mandatoryString = mandatoryString + 'Dependencies' + ', ';
            if(hleRec.eml_UBPR_Email__c  == null)  
                 mandatoryString = mandatoryString + 'UBPR Email' + ', ';
            if(hleRec.eml_UIOS_Email__c  == null)  
                 mandatoryString = mandatoryString + 'UIOS Email' + ', ';
            if(hleRec.eml_AAL_Email__c  == null)  
                 mandatoryString = mandatoryString + 'AAL Email' + ', ';
            if(hleRec.txt_UBPR_Name__c  == null)  
                 mandatoryString = mandatoryString + 'UBPR Name' + ', ';
            if(hleRec.txt_UIOS_Name__c  == null)  
                 mandatoryString = mandatoryString + 'UIOS Name' + ', ';
            if(hleRec.txt_AAL_Name__c  == null)  
                 mandatoryString = mandatoryString + 'AAL Name' + ', ';
            if(hleRec.dt_Planned_end_date__c  == null)  
                 mandatoryString = mandatoryString + 'Planned End Date' + ', ';
            if(hleRec.dt_Planned_start_date__c  == null)  
                 mandatoryString = mandatoryString + 'Planned Start Date' + ', ';
            if(hleRec.txt_Project_description_specification__c  == null)  
                 mandatoryString = mandatoryString + 'Project Description Specification' + ', ';
            if(hleRec.txt_Project_type__c  == null)  
                 mandatoryString = mandatoryString + 'Project Type' + ', ';
            if(hleRec.txt_Request_ID__c  == null)  
                 mandatoryString = mandatoryString + 'Request ID' + ', ';
            if(hleRec.txt_Risks_and_issues__c  == null)  
                 mandatoryString = mandatoryString + 'Risks And Issues' + ', ';
            if(hleRec.txt_Software_Licensing_requirements__c  == null)  
                 mandatoryString = mandatoryString + 'Software Licensing Requirements' + ', ';
            if(hleRec.txt_Support_impact__c  == null)  
                 mandatoryString = mandatoryString + 'Support Impact' + ', ';
            if(hleRec.txt_Technologies__c  == null)  
                 mandatoryString = mandatoryString + 'Technologies' + ', ';
            if(hleRec.txt_Title__c  == null)  
                 mandatoryString = mandatoryString + 'Title' + ', ';
            if(hleRec.txt_UL_reference__c  == null)  
                 mandatoryString = mandatoryString + 'UL Reference' + ', ';
            
        }

        if(mandatoryString!= null && mandatoryString.length()>0){ 
           mandatoryString = mandatoryString.substring(0,mandatoryString.length()-2);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Below fields are mandatory to Submit the record'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, mandatoryString));
        }                 
    }
      
    public void UpdateHLEReq() {
        if(mandatoryString!= null && mandatoryString.length()>0){
            if(hleRec.isValidated__c != false){
                    hleRec.isValidated__c = false;  
                    update hleRec;                   
            }   
        }else if(hleRec.isValidated__c != true){
                    hleRec.isValidated__c = true;  
                    update hleRec;                   
         }
        
    }
 
}