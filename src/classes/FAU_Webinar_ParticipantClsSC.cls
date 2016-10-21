/********************************************************************
 Name:  FAU_Webinar_ParticipantClsSC()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Updates FAU Participant                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class FAU_Webinar_ParticipantClsSC {

    /*******************************************************************
        Purpose:  Update PArticipant Webinar Date Time
    *******************************************************************/ 
	public static FAU_Participant__c updateWebinarDateTime(FAU_Webinar_Participant__c oNewWebinarParticpant, set<Id> setPartcipantIds ){ 
        
        if((oNewWebinarParticpant.FAU_Has_Accepted__c == True)&& (setPartcipantIds.contains(oNewWebinarParticpant.FAU_Participant__c)==false)){
            FAU_Participant__c oPartcipant = new FAU_Participant__c(Id = oNewWebinarParticpant.FAU_Participant__c,
	            												 FAU_Webinar_Date_Time__c = oNewWebinarParticpant.FAU_Start_Time__c);
            
         	setPartcipantIds.add(oPartcipant.Id);  
         	return oPartcipant;
    	}else{
    		return null;
    	}
	}

}