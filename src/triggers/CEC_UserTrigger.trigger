/***********************************************************************
 Name:  CEC_UserTrigger 
 Copyright © 2015  Unilever
 =======================================================================
========================================================================
Purpose: This is the Trigger to copy Multi-value picklist to text fields                                                                                                                      
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION  AUTHOR          DATE          DETAIL               Description
   1.0 - Nagesh          3/5/2015      INITIAL DEVELOPMENT  CSR
 
************************************************************************/
trigger CEC_UserTrigger on User (before update) {
    
  CEC_UserTriggerHelper userHelper = new CEC_UserTriggerHelper();
       userHelper.updateLanguageSkillSet(trigger.new,trigger.oldMap);
       userHelper.updateProductCategorySkillSet(trigger.new,trigger.oldMap);
   
}