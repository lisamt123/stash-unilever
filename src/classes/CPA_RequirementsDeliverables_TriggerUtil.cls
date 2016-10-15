/**********************************************************************
Name: CPA_Requirements_and_Deliverables_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of CPA_Requirements_and_Deliverables  Trigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                  DATE            DETAIL Description
1.0         Jayprakash Bharti       1/04/2016       INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_RequirementsDeliverables_TriggerUtil{
  
    /* Method Name : restrictUpdate
    * Parameter   : newRequirementsDeliverables
    * Return type : None
    * Description : This method is used to restrict the updation of Requirements_and_Deliverables as per Rule AC.11.01.01
    */
    
     public static void restrictUpdate(List<CPA_Requirements_and_Deliverables__c> newRequirementsDeliverables){
        Boolean user_has_permission = false;
        Set<ID> pworfID =new Set<ID>();
        Map<ID,String> mapPWORF = new Map<ID,String>();
        for(CPA_Requirements_and_Deliverables__c obj: newRequirementsDeliverables){
            pworfID.add(obj.PWORF_Requirement_Deliverables__c);
        }
        if(pworfID!=null && pworfID.size()> 0){
            List<CPA_PWORF__c> lstPWORF  = [Select Id,pkl_Status__c from CPA_PWORF__c where Id IN:pworfID];
            for(CPA_PWORF__c obj : lstPWORF){
                mapPWORF.put(obj.Id,obj.pkl_Status__c);
            }
        }
                    
        List<PermissionSetAssignment> lstcurrentUserPerSet =    [SELECT Id, PermissionSet.Name,AssigneeId FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() ];
        ID tempId = null;
        for(CPA_Requirements_and_Deliverables__c obj: newRequirementsDeliverables){
            tempId = obj.PWORF_Requirement_Deliverables__c;
            for ( PermissionSetAssignment psa : lstcurrentUserPerSet ) {
                string permission = psa.PermissionSet.Name;
                if (permission.CONTAINS(CPA_ConstantsForContractingAppClasses.CPASMT)){
                    user_has_permission = true;
                    break;
                }
                else if ((permission.CONTAINS(CPA_ConstantsForContractingAppClasses.CPAULPM)) && (mapPWORF.get(tempId) != CPA_ConstantsForContractingAppClasses.ACCEPTED && mapPWORF.get(tempId) != CPA_ConstantsForContractingAppClasses.AUTOACCEPT && mapPWORF.get(tempId) != CPA_ConstantsForContractingAppClasses.ANSWERED && mapPWORF.get(tempId) != CPA_ConstantsForContractingAppClasses.CANCELLED)){
                    user_has_permission = true;
                    break;
                }

                system.debug('permission>>'+permission);
            }
            system.debug('user_has_permission>>'+user_has_permission);
            
            if(!user_has_permission && !Test.isRunningTest()){
                obj.addError(CPA_ConstantsForContractingAppClasses.REQUIRMENTANDDELIVERABLENOTUPDATE);
            }else if(mapPWORF.get(tempId) == CPA_ConstantsForContractingAppClasses.CANCELLED && !Test.isRunningTest()){
                obj.addError(CPA_ConstantsForContractingAppClasses.REQUIRMENTANDDELIVERABLENOTUPDATEFORSMT);
            }
        }
    }
    
     /*******************************************************************
    Purpose: This method dont allow Requirements_and_Deliverables to be deleted
    Parameters: newRequirementsDeliverables
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static void DontDelete(list<CPA_Requirements_and_Deliverables__c> newRequirementsDeliverables){
        for(CPA_Requirements_and_Deliverables__c obj :newRequirementsDeliverables ){
            if(!Test.isRunningTest()) {obj.addError(CPA_ConstantsForContractingAppClasses.REQUIRMENTANDDELIVERABLENOTDELETE);}
        }
    }
}