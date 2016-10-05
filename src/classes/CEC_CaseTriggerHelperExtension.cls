/*********************************************************************************************************
Name:  CEC_CaseTriggerHelperExtension()
Copyright ? 2016  Unilever
==========================================================================================================
==========================================================================================================
Purpose:  Trigger Helper Class Extesnion                                               
1. To update the owner of social cases                                  
==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Nagesh       25/07/2016       INITIAL DEVELOPMENT      
1.1 -    Nagesh       15/09/2016       CSC-5059                Automatic assignment of consumer to SMS case
***********************************************************************************************************/
public with sharing class CEC_CaseTriggerHelperExtension {
    
    Set<String> caseSMSTransExtIdSet = new Set<String>();    //To store SMS Case specific Transient External Id
    Set<String> caseSocialTransExtIdSet = new Set<String>(); // To store Social case specific Transient External Id
    Set<String> caseTransExtIdSet = new Set<String>();       // To store all Transient Extenal Id
    Map<Id, cec_Case_Brand_Mapping__c> cbmMap;               // To store CBB related to Transient Id
    Map<String, Id> transCBMMap = new Map<String, Id>();    
    Integer mobNumLen = 0;
    String mobNumber = '', rexMobNum = '', originSocialMedia = 'Social';
    Map<String, Set<String>> smsCaseMobNumMap = new Map<String, Set<String>>();//???
    List<Account> accntList = new List<Account>();
    Map<String, Account> mobRexNumAccntMap = new Map<String, Account>();
    Set<String> dupMobRexNumSet = new Set<String>();
    Set<String> smsAccntTransExtIdSet = new Set<String>();
    Set<String> mobNumSet = new Set<String>();
    Set<String> rexMobNumSet = new Set<String>();
    Map<String, String> mobRexMobMap = new Map<String, String>();

    
    
    public void checkSMSDupAccount(Map<String, Set<String>> caseMobNumMap){
        
        Id recTypeId =[Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id; 
        
        mobNumSet = new Set<String>();
        
        for(Set<String> rexMobNumSet1 : caseMobNumMap.values()){
            mobNumSet.addAll(rexMobNumSet1);
        }
        
        System.debug('Before Query'+ mobNumSet);
        
        //Query for Duplicate Account
        accntList = [Select Id, SMS_Search_Mobile_Number__c, PersonContactId from Account where SMS_Search_Mobile_Number__c LIKE: mobNumSet and RecordTypeId =: recTypeId];
        
        System.debug('$$$$$$$$$$$$$$$'+ accntList);
        
        for(Account accnt: accntList){
            
            for(string mobRexNum : mobNumSet){
                if(Pattern.matches(mobRexNum.Replace('%','[0-9]*'), accnt.SMS_Search_Mobile_Number__c)){
                    if(mobRexNumAccntMap.containsKey(mobRexNum)){
                        dupMobRexNumSet.add(mobRexNum);
                        System.debug('I am here2');
                    }
                    else{                       
                        mobRexNumAccntMap.put(mobRexNum,accnt);
                        System.debug('I am here3');
                    }
                }
            }
            
        }
        
        System.debug('$$$$$ DuplicateSet' + dupMobRexNumSet);
        System.debug('$$$$$ MobRexNumAccntMap' + mobRexNumAccntMap); 
        
    }
    
    
    public void checkSMSCaseDetails(Case caseRec){

        try{
            
            if(caseRec.AccountId == null && caseRec.SMS_Mobile_Number__c != null){
                                
                System.debug('I am here1');
                if(smsCaseMobNumMap.containsKey(caseRec.Transient_External_Id__c.toLowerCase())){
                    mobNumSet = smsCaseMobNumMap.get(caseRec.Transient_External_Id__c.toLowerCase());
                    mobNumSet.add(caseRec.SMS_Mobile_Number__c);
                    smsCaseMobNumMap.put(caseRec.Transient_External_Id__c.toLowerCase(), mobNumSet);
                    System.debug('I am here2');
                }
                else{
                    mobNumSet = new Set<String>{caseRec.SMS_Mobile_Number__c};
                        smsCaseMobNumMap.put(caseRec.Transient_External_Id__c.toLowerCase(), mobNumSet);
                    System.debug('I am here3');
                }
                
                System.debug('I am here4' + smsCaseMobNumMap);
            }
        }
        catch(Exception e){
            System.debug('checkSMSCaseDetails Failure :' + e.getMessage());
        }
    }
    


    public void checkCBMDetails(){
        
        try{

            if(caseTransExtIdSet.size()>0){
                    
                cbmMap = new Map<Id, cec_Case_Brand_Mapping__c>([Select Id, Inbound_Email__c, Country__c, Country__r.OwnerId, Country__r.Consumer_Phone_Search_Digits__c,Country__r.Market__c from cec_Case_Brand_Mapping__c where Inbound_Email__c IN :caseTransExtIdSet]);
                
                System.debug('cbm Map    ' + cbmMap);
                
                for(cec_Case_Brand_Mapping__c cbmRec: cbmMap.values()){
                    transCBMMap.put(cbmRec.Inbound_Email__c, cbmRec.Id);
                    
                    
                    if(smsCaseMobNumMap.containsKey(cbmRec.Inbound_Email__c)){
                        
                        mobNumSet = smsCaseMobNumMap.get(cbmRec.Inbound_Email__c);
                        rexMobNumSet = new Set<String>();
                        for(String mobNumber: mobNumSet){
                            mobNumLen = mobNumber.length();
                            if(cbmRec.Country__r.Consumer_Phone_Search_Digits__c != null){
                                rexMobNum = '%' + mobNumber.Mid(mobNumLen-(integer)cbmRec.Country__r.Consumer_Phone_Search_Digits__c, mobNumLen) + cbmRec.Country__r.Market__c;
                            }
                            else{
                                rexMobNum = mobNumber + cbmRec.Country__r.Market__c;
                            }
                            rexMobNumSet.add(rexMobNum);
                            mobRexMobMap.put(mobNumber,rexMobNum);
                            
                        }
                        
                        smsCaseMobNumMap.put(cbmRec.Inbound_Email__c, rexMobNumSet);
                        
                        
                    }
                }
            }
        }
        catch(Exception e){
            System.debug('checkCBMDetails Failure :' + e.getMessage());
        }       

    }

    public void updateCaseDetails(List<Case> newCaseList){
        try{

                if(transCBMMap.size()>0){
                    for(Case caseRec: newCaseList){
                        
                        if(transCBMMap.containsKey(caseRec.Transient_External_Id__c.toLowerCase())){
                            
                            caseRec.Case_Brand_Mapping__c = transCBMMap.get(caseRec.Transient_External_Id__c.toLowerCase());
                            caseRec.Country__c = cbmMap.get(caseRec.Case_Brand_Mapping__c).Country__c;
                            
                            if(caseSMSTransExtIdSet.contains(caseRec.Transient_External_Id__c.toLowerCase())){
                                caseRec.OwnerId = cbmMap.get(caseRec.Case_Brand_Mapping__c).Country__r.OwnerId;
                                                           
                                if(dupMobRexNumSet.contains(mobRexMobMap.get(caseRec.SMS_Mobile_Number__c))){
                                    caseRec.Matching_Response__c = Label.CEC_MatchingResponse_DuplicateAccountMobileNumber;
                                }
                                else{
                                    try{
                                        caseRec.AccountId = mobRexNumAccntMap.get(mobRexMobMap.get(caseRec.SMS_Mobile_Number__c)).Id;
                                        caseRec.ContactId = mobRexNumAccntMap.get(mobRexMobMap.get(caseRec.SMS_Mobile_Number__c)).PersonContactId;
                                    }
                                    catch(Exception e){
                                        System.debug('Update AccountId or ContactId Failed :' + e.getMessage());    
                                    }
                                }
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
            System.debug('updateCaseDetails Failure :' + e.getMessage());
        }
    }

    
    public void updateCaseOwner(List<Case> newCaseList, Map<Id, Case> oldCaseMap){
        
        try{
            
            System.debug('Inside updateCaseOwner' + newCaseList);
            System.debug('Inside updateCaseOwner' + oldCaseMap);
            
            if(oldCaseMap == null){
                
                for(Case caseRec: newCaseList){
                    
                    System.debug('Inside For Loop' + CaseRec);
                    
                    if(caseRec.Social_Media_External_Id__c != null){
                        caseSocialTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                        caseTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                    }
                    else if(caseRec.SMS_Inbound_Number__c != null){
                        caseSMSTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                        caseTransExtIdSet.add(caseRec.Transient_External_Id__c.toLowerCase());
                        checkSMSCaseDetails(caseRec);
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
                        checkSMSCaseDetails(caseRec);
                    }
                    
                }
                
            }
            
            System.debug('caseTransExtIdSet    ' + caseTransExtIdSet);
            System.debug('smsCaseMobNumMap    ' + smsCaseMobNumMap);
            
            checkCBMDetails();
            
            System.debug('Updated SMS Case Mobile Num Map'+ smsCaseMobNumMap);
            if(smsCaseMobNumMap.size() > 0){
                
                checkSMSDupAccount(smsCaseMobNumMap);
                
            }
            
            System.debug('CBMMap    ' + transCBMMap);

            updateCaseDetails(newCaseList);
            
        }
        catch(Exception e){
            System.debug('updateCaseOwner Failure :' + e.getMessage());
        }
    }
    
}
