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

    Set<String> caseSMSTransExtIdSet = new Set<String>();
    Set<String> caseSocialTransExtIdSet = new Set<String>();
    Set<String> caseTransExtIdSet = new Set<String>();
    Map<Id, cec_Case_Brand_Mapping__c> cbmMap;
    Map<String, Id> transCBMMap = new Map<String, Id>();    
    Final String originSocialMedia = 'Social';


    public void updateCaseOwner(List<Case> newCaseList, Map<Id, Case> oldCaseMap){

        try{
            
            System.debug('Inside updateCaseOwner' + newCaseList);
            System.debug('Inside updateCaseOwner' + oldCaseMap);

            if(oldCaseMap == null){

                for(Case caseRec: newCaseList){
                    if(caseRec.Social_Media_External_Id__c != null){
                        caseSocialTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                        caseTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                    }
                    else if(caseRec.SMS_Inbound_Number__c != null){
                        caseSMSTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                        caseTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                    }

                }

            }
            else{

                for(Case caseRec: newCaseList){
                    if(caseRec.Social_Media_External_Id__c != null && OldCaseMap.get(caseRec.Id).Social_Media_External_Id__c == null){
                        caseSocialTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                        caseTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                    }
                    else if(caseRec.SMS_Inbound_Number__c != null && OldCaseMap.get(caseRec.Id).SMS_Inbound_Number__c  == null){
                        caseSMSTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                        caseTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                    }

                }

            }

            System.debug('caseTransExtIdSet    ' + caseTransExtIdSet);

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

                        if(caseSMSTransExtIdSet.contains(caseRec.Transient_External_Id__c.toLowerCase())){
                            caseRec.OwnerId = cbmMap.get(caseRec.Case_Brand_Mapping__c).Country__r.OwnerId;
                        }

                        if(caseSocialTransExtIdSet.contains(caseRec.Transient_External_Id__c.toLowerCase())){
                            caseRec.Origin = originSocialMedia;
                        }

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