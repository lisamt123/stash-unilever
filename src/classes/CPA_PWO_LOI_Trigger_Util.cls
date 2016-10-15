/**********************************************************************
Name: CPA_PWO_LOI_Trigger_Util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on PWO and LOI Trigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                     DATE            DETAIL Description
1.0        Pooja Kanani                01/04/2016     INITIAL DEVELOPMENT CSR:
2.0        Shreyas M                   04/04/2016     Fix for Status field for Internal ID
***********************************************************************/
public with sharing class CPA_PWO_LOI_Trigger_Util {
     /** Method Name : getInternalPWOIDFromPWO
    * Parameter   : newLOI
    * Return type : None
    * Author      : Pooja Kanani
    * Created on  : 1/04/2016
    * Description : This method gets internal PWO ID from PWO and maps it to LOI. Calling from before insert trigger
    */
    public static void getInternalPWOIDFromPWO(List<CPA_LOI__c> newLOI){
        Set<ID>PWRFIDSet = new Set<ID>();
        Map<ID,List<CPA_project_work_order__c>> PWORF_PWO_Map = new Map<ID,List<CPA_project_work_order__c>>();
        
        for(CPA_LOI__c loirecord:newLOI){
           PWRFIDSet.add(loirecord.lkp_PWORF__c); 
        }
        
        for (CPA_PWORF__c pworf : [SELECT ID,(SELECT txt_PWO_number__c,name,PWORF_ID__c,pkl_Status__c FROM PWO11__r) FROM CPA_PWORF__c WHERE ID IN :PWRFIDSet]){
            if(pworf.PWO11__r != NULL && pworf.PWO11__r.size()>0){ 
                PWORF_PWO_Map.put(pworf.ID,pworf.PWO11__r);  
            }
        }
        for(CPA_LOI__c loi:newLOI){
            List<CPA_project_work_order__c>relatedAllPWO = new List<CPA_project_work_order__c>();
            relatedAllPWO = PWORF_PWO_Map.get(loi.lkp_PWORF__c);
            if(relatedAllPWO !=null && relatedAllPWO.size()>0 && loi.txt_PWO_number__c != null){
                loi.txt_Internal_PWO_ID__c = SearchForMatchPWONumber(relatedAllPWO,loi.txt_PWO_number__c);
            }else loi.txt_Internal_PWO_ID__c = null;
        }
        
    }
    /** Method Name : SearchForMatchPWONumber
    * Parameter   : PWOList,PWO Number
    * Return type : None
    * Author      : Pooja Kanani
    * Created on  : 1/04/2016
    * Description : This method returns PWO ID
    */
    Public static string  SearchForMatchPWONumber (List<CPA_project_work_order__c> PWOList,String PWONumber){
        for(CPA_project_work_order__c pwo:PWOList){
            if(pwo.txt_PWO_number__c != null && PWONumber !=null &&  pwo.txt_PWO_number__c.equalsIgnoreCase(PWONumber)){
                return pwo.name;
            }                           
        }
        return null;
    }
  /** Method Name : getUpdatedInternalPWOIDFromPWO
    * Parameter   : newLOI,oldLOI
    * Return type : None
    * Author      : Pooja Kanani
    * Created on  : 1/04/2016
    * Description : This method gets internal PWO ID from PWO and maps it to LOI. Calling from before update trigger
    */
public static void getUpdatedInternalPWOIDFromPWO(List<CPA_LOI__c> oldLOI,List<CPA_LOI__c> newLOI){
    List<CPA_LOI__c>lois = new List<CPA_LOI__c>();  
    for(Integer i = 0; i < newLOI.size(); i++){
        if((!newLOI[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.RESUBMITTED) && !newLOI[i].pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED)) || (oldLOI[i].txt_PWO_number__c <> newLOI[i].txt_PWO_number__c)){
            lois.add(newLOI[i]);
        }          
    }
    if(lois!=null && lois.size()>0){ getInternalPWOIDFromPWO(lois); }
}
/** Method Name : UpdateInternalPWOIDForLOI
    * Parameter   : newPWO
    * Return type : None
    * Author      : Pooja Kanani
    * Created on  : 1/04/2016
    * Description : This method gets internal PWO ID and update LOI. Calling from after insert trigger
    */
    public static void UpdateInternalPWOIDForLOI(List<CPA_project_work_order__c> newPWO){
        Set<ID>PWRFIDSet = new Set<ID>();
        Map<ID,List<CPA_LOI__c>> PWORF_LOI_Map = new Map<ID,List<CPA_LOI__c>>();
        List<CPA_LOI__c> loiNeedToUpdated = new List<CPA_LOI__c>(); 
        for(CPA_project_work_order__c PWOrecord:newPWO){
           PWRFIDSet.add(PWOrecord.PWORF_ID__c); 
        }
        system.debug('PWRFIDSet>>'+PWRFIDSet);
        for (CPA_PWORF__c pworf : [SELECT ID,(SELECT txt_PWO_number__c,txt_Internal_PWO_ID__c,lkp_PWORF__c,pkl_Status__c FROM LOI__r) FROM CPA_PWORF__c WHERE ID IN :PWRFIDSet]){
            if(pworf.LOI__r != NULL && pworf.LOI__r.size()>0){ 
                PWORF_LOI_Map.put(pworf.ID,pworf.LOI__r);  
            }
        }
        system.debug('PWORF_LOI_Map>>'+PWORF_LOI_Map);
        for(CPA_project_work_order__c pwo:newPWO){
            if(!pwo.chk_isStandalone_CR__c){
                List<CPA_LOI__c>relatedAllLOI = new List<CPA_LOI__c>();         
                relatedAllLOI = PWORF_LOI_Map.get(pwo.PWORF_ID__c);
                if(relatedAllLOI !=null && relatedAllLOI.size()>0 && pwo.txt_PWO_number__c != null){
                    system.debug('relatedAllLOI>>'+relatedAllLOI + '<<pwo.txt_PWO_number__c' + pwo.txt_PWO_number__c + '>>pwo.name'+pwo.name+'>>loiNeedToUpdated'+loiNeedToUpdated);
                    loiNeedToUpdated = SearchForMatchPWONumber(relatedAllLOI,pwo.txt_PWO_number__c,pwo.name,loiNeedToUpdated);
                }
            }
        }
        system.debug('loiNeedToUpdated>>'+loiNeedToUpdated);
        if(loiNeedToUpdated!=null && loiNeedToUpdated.size()>0){
            update loiNeedToUpdated;
        }   
    }
    /** Method Name : SearchForMatchPWONumber
    * Parameter   : newPWO
    * Return type : None
    * Author      : Pooja Kanani
    * Created on  : 1/04/2016
    * Description : This method update LOI with internal PWO ID when PWO in inserted
    */
    Public static list<CPA_LOI__c>  SearchForMatchPWONumber (List<CPA_LOI__c> LOIList,String PWONumber,String PWOName,List<CPA_LOI__c> updatedLOI){     
        for(CPA_LOI__c loi:LOIList){
            if((!loi.pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.RESUBMITTED) && !loi.pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED)) && PWONumber !=null && loi.txt_PWO_number__c != null &&  loi.txt_PWO_number__c.equalsIgnoreCase(PWONumber)){
                loi.txt_Internal_PWO_ID__c = PWOName;
                updatedLOI.add(loi);
            }                           
        }
        return updatedLOI;
    }
  /** Method Name : getUpdatedInternalPWOIDtoUpdateLOI
    * Parameter   : newLOI,oldLOI
    * Return type : None
    * Author      : Pooja Kanani
    * Created on  : 1/04/2016
    * Description : This method gets internal PWO ID from PWO and maps it to LOI. Calling from after update trigger
    */
    public static void getUpdatedInternalPWOIDtoUpdateLOI(List<CPA_project_work_order__c> oldPWO,List<CPA_project_work_order__c> newPWO){
        Set<ID>PWRFIDSet = new Set<ID>();
        List<CPA_LOI__c> loiNeedToUpdated = new List<CPA_LOI__c>();
        for(Integer i = 0; i < newPWO.size(); i++){
            if(oldPWO[i].txt_PWO_number__c <> newPWO[i].txt_PWO_number__c){
                PWRFIDSet.add(newPWO[i].PWORF_ID__c);
            }          
        }
        system.debug('PWRFIDSet>>'+PWRFIDSet);
        if(PWRFIDSet != null){
            List<CPA_project_work_order__c>relatedAllPWO = new List<CPA_project_work_order__c>();
            relatedAllPWO = [Select txt_PWO_number__c,name,PWORF_ID__c,pkl_Status__c from CPA_project_work_order__c where PWORF_ID__c=: PWRFIDSet];

            for(CPA_LOI__c loi:[SELECT txt_PWO_number__c,txt_Internal_PWO_ID__c,lkp_PWORF__c,pkl_Status__c FROM CPA_LOI__c where lkp_PWORF__c =:PWRFIDSet]){
                if(!loi.pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.RESUBMITTED) && !loi.pkl_Status__c.equalsIgnoreCase(CPA_ConstantsForContractingAppClasses.SUBMITTED)){
                    if(relatedAllPWO !=null && relatedAllPWO.size()>0 && loi.txt_PWO_number__c != null){
                        loi.txt_Internal_PWO_ID__c = SearchForMatchPWONumberOnLOI(relatedAllPWO,loi.txt_PWO_number__c);
                    }else loi.txt_Internal_PWO_ID__c = null;
                    loiNeedToUpdated.add(loi);
                }
            }
            system.debug('loiNeedToUpdated>>'+loiNeedToUpdated);
            if(loiNeedToUpdated!=null && loiNeedToUpdated.size()>0){update loiNeedToUpdated;}
        }
    }
    /** Method Name : SearchForMatchPWONumberOnLOI
    * Parameter   : newPWO
    * Return type : None
    * Author      : Pooja Kanani
    * Created on  : 1/04/2016
    * Description : This method update LOI with internal PWO ID when PWO is updated
    */
    Public static string  SearchForMatchPWONumberOnLOI (List<CPA_project_work_order__c> PWOList,String PWONumber){
        system.debug('PWOList>>'+PWOList);
        system.debug('PWONumber>>'+PWONumber);
        for(CPA_project_work_order__c pwo:PWOList){
            if(pwo.txt_PWO_number__c != null && PWONumber !=null &&  pwo.txt_PWO_number__c.equalsIgnoreCase(PWONumber)){
                return pwo.name;
            }                           
        }
        return null;
    }
}