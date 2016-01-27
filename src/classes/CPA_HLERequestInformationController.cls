public class CPA_HLERequestInformationController {
 //Public id hleId; 
 Public id hleReqId;
 //Public CPA_CR__c crRec;
 Public CPA_HLE_Request__c hleReqRec;
 Public String mandatoryString;
 
 
    
    public CPA_HLERequestInformationController(ApexPages.StandardController controller) {
        mandatoryString = '';
        if(ApexPages.currentPage().getParameters().get('id') != null) {      
            hleReqId = ApexPages.currentPage().getParameters().get('id');
            CPA_Messages(hleReqId);           
        }
    } 
    void CPA_Messages(id hleReqRecId){  
        hleReqRec = [SELECT pkl_Status__c,dt_Date_raised__c,dt_Planned_end_date__c,dt_Planned_start_date__c,eml_AAL_Email__c,eml_UBPR_Email__c,eml_UIOS_Email__c,Id,mpkl_PFS_If_yes_what_is_the_source__c,Name,OwnerId,PFS_Is_there_approved_funding_for_this__c,ph_AAL_Contact_No__c,ph_UBPR_Contact_No__c,ph_UIOS_Contact_No__c,pkl_Business_area__c,pkl_HLE_type__c,txt_AAL_Name__c,txt_Accenture_skill_types_required__c,txt_Additional_information__c,txt_Assumptions__c,txt_Background__c,txt_Dependencies__c,txt_NA_Notes__c,txt_Project_description_specification__c,txt_Project_type__c,txt_Request_ID__c,txt_Risks_and_issues__c,txt_RQ_Query__c,txt_Software_Licensing_requirements__c,txt_Status__c,txt_Support_impact__c,txt_Technologies__c,txt_Title__c,txt_UBPR_Name__c,txt_UIOS_Name__c,txt_UL_reference__c FROM CPA_HLE_Request__c where id =:hleReqRecId];
                
        CPA_Status_Msg__c customSettingStatusMsg = CPA_Status_Msg__c.getInstance(hleReqRec.pkl_Status__c);
        if(customSettingStatusMsg.CR_Status_Msg__c != null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, customSettingStatusMsg.CR_Status_Msg__c));
        }
        if((hleReqRec.pkl_Status__c == 'Saved')){
            if(hleReqRec.txt_Assumptions__c == null)  
                 mandatoryString = mandatoryString + 'Assumptions' + ', ';
            if(hleReqRec.txt_Background__c  == null)  
                 mandatoryString = mandatoryString + 'Background' + ', ';
            if(hleReqRec.ph_UBPR_Contact_No__c  == null)  
                 mandatoryString = mandatoryString + 'UBPR Contact Number ' + ', ';
            if(hleReqRec.ph_UIOS_Contact_No__c  == null)  
                 mandatoryString = mandatoryString + 'UIOS Contact Number' + ', ';
            if(hleReqRec.ph_AAL_Contact_No__c  == null)  
                 mandatoryString = mandatoryString + 'AAL Contact Number' + ', ';
            if(hleReqRec.dt_Date_raised__c  == null)  
                 mandatoryString = mandatoryString + 'Date Raised' + ', ';
            if(hleReqRec.txt_Dependencies__c  == null)  
                 mandatoryString = mandatoryString + 'Dependencies' + ', ';
            if(hleReqRec.eml_UBPR_Email__c  == null)  
                 mandatoryString = mandatoryString + 'EML UBPR Email' + ', ';
            if(hleReqRec.eml_UIOS_Email__c  == null)  
                 mandatoryString = mandatoryString + 'EML UIOS Email' + ', ';
            if(hleReqRec.eml_AAL_Email__c  == null)  
                 mandatoryString = mandatoryString + 'AAL Email' + ', ';
            if(hleReqRec.txt_UBPR_Name__c  == null)  
                 mandatoryString = mandatoryString + 'UBPR Name' + ', ';
            if(hleReqRec.txt_UIOS_Name__c  == null)  
                 mandatoryString = mandatoryString + 'UIOS Name' + ', ';
            if(hleReqRec.txt_AAL_Name__c  == null)  
                 mandatoryString = mandatoryString + 'AAL Name' + ', ';
            if(hleReqRec.dt_Planned_end_date__c  == null)  
                 mandatoryString = mandatoryString + 'Planned End Date' + ', ';
            if(hleReqRec.dt_Planned_start_date__c  == null)  
                 mandatoryString = mandatoryString + 'Planned Start Date' + ', ';
            if(hleReqRec.txt_Project_description_specification__c  == null)  
                 mandatoryString = mandatoryString + 'Project Description Specification' + ', ';
            if(hleReqRec.txt_Project_type__c  == null)  
                 mandatoryString = mandatoryString + 'Project Type' + ', ';
            if(hleReqRec.txt_Request_ID__c  == null)  
                 mandatoryString = mandatoryString + 'Request ID' + ', ';
            if(hleReqRec.txt_Risks_and_issues__c  == null)  
                 mandatoryString = mandatoryString + 'Risks And Issues' + ', ';
            if(hleReqRec.txt_Software_Licensing_requirements__c  == null)  
                 mandatoryString = mandatoryString + 'Software Licensing Requirements' + ', ';
            if(hleReqRec.txt_Status__c  == null)  
                 mandatoryString = mandatoryString + 'Status' + ', ';
            if(hleReqRec.txt_Support_impact__c  == null)  
                 mandatoryString = mandatoryString + 'Support Impact' + ', ';
            if(hleReqRec.txt_Technologies__c  == null)  
                 mandatoryString = mandatoryString + 'Technologies' + ', ';
            if(hleReqRec.txt_Title__c  == null)  
                 mandatoryString = mandatoryString + 'Title' + ', ';
            if(hleReqRec.txt_UL_reference__c  == null)  
                 mandatoryString = mandatoryString + 'UL Reference' + ', ';

        }

        if(mandatoryString!= null && mandatoryString.length()>0){ 
           mandatoryString = mandatoryString.substring(0,mandatoryString.length()-2);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Below fields are mandatory to Submit the record'));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, mandatoryString));
        }                 
    }
    /*public void UpdatePworf() {
        if(mandatoryString!= null && mandatoryString.length()>0){
            if(hleReqRec.isValidated__c != false){
                    hleReqRec.isValidated__c = false;  
                    update hleReqRec;                   
            }   
        }else if(hleReqRec.isValidated__c != true){
                    hleReqRec.isValidated__c = true;  
                    update hleReqRec;                   
         }
        
    }*/

}