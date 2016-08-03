/**********************************************************************
Name:  CEC_CaseTriggerHelperExtension()
Copyright ? 2016  Unilever
======================================================================
======================================================================
Purpose:  Trigger Helper Class Extesnion                                               
1. To update the owner of social cases                                  
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Nagesh       25/07/2016       INITIAL DEVELOPMENT      
****************************************************************************/
public with sharing class CEC_CaseTriggerHelperExtension {

    Set<String> caseTransExtIdSet = new Set<String>();
    Map<Id, cec_Case_Brand_Mapping__c> cbmMap;
    Map<String, Id> transCBMMap = new Map<String, Id>();
    Final String originSocialMedia = 'Social';


    public void updateCaseOwner(List<Case> newCaseList, Map<Id, Case> oldCaseMap){

        try{
            System.debug('Inside updateCaseOwner' + newCaseList);
            for(Case caseRec: newCaseList){
                if(caseRec.Social_Media_External_Id__c != null && OldCaseMap.get(caseRec.Id).Social_Media_External_Id__c == null){
                    caseTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                }
            }

            System.debug('CaseTransExtIdSet    ' + caseTransExtIdSet);

            if(caseTransExtIdSet.size()>0){
            
                cbmMap = new Map<Id, cec_Case_Brand_Mapping__c>([Select Id, Inbound_Email__c, Country__c, Country__r.OwnerId from cec_Case_Brand_Mapping__c where Inbound_Email__c IN :caseTransExtIdSet]);

                System.debug('cbm Map    ' + cbmMap);
            
                for(cec_Case_Brand_Mapping__c cbmRec: cbmMap.values()){
                    transCBMMap.put(cbmRec.Inbound_Email__c, cbmRec.Id);
                }
            }

            System.debug('CBMMap    ' + transCBMMap);

            if(transCBMMap.size()>0){
                for(Case caseRec: newCaseList){
                    if(transCBMMap.containsKey(caseRec.Transient_External_Id__c.toLowerCase())){
                        System.debug('Inside For Loop');
                        caseRec.Case_Brand_Mapping__c = transCBMMap.get(caseRec.Transient_External_Id__c.toLowerCase());
                        caseRec.Country__c = cbmMap.get(caseRec.Case_Brand_Mapping__c).Country__c;
                        //caseRec.OwnerId = cbmMap.get(caseRec.Case_Brand_Mapping__c).Country__r.OwnerId;
                        caseRec.Origin = originSocialMedia;
                        System.debug('Updated Case Record' + caseRec);
                    }

                }
            }
        }
        catch(Exception e){
            System.debug('updateCaseOwner Failure :' + e.getMessage());
        }
    }

}