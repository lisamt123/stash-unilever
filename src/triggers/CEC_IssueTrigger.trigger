/**********************************************************************
 Name:  CEC_IssueTrigger()
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:  Common Trigeer on Issue(Case_Reason__c ) for all events                                                
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
   1.0 -   Aalokkumar       22/08/2014       INITIAL DEVELOPMENT        Issue(Case_Reason__c )  
****************************************************************************/

trigger CEC_IssueTrigger on cec_Issue__c (after insert) {

/**
 * Interface containing methods Trigger Handlers must implement to enforce best practice
 * and bulkification of triggers.
 */



                     if(trigger.isAfter && trigger.isInsert){
system.debug('1~~~~~~~Inside Trigger new map '+trigger.newMap+'  trigger new List  '+trigger.new);      
                //pass maps for Issue 
                    CEC_IssueTriggerHandler oCEC_IssueTriggerHandler = new CEC_IssueTriggerHandler ();
                    oCEC_IssueTriggerHandler.forAfterInsert(trigger.newMap);   
                
                    system.debug('~~~~~~~Inside Trigger new map '+trigger.newMap+'  trigger new List  '+trigger.new);
                    
                    }
                 
                
}