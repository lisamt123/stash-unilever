/********************************************************************
 Name:  FAU_Webinar_ParticipantCls()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: This class handles the Webinar_Participant trigger functionality.                                                    
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
public without sharing class FAU_Webinar_ParticipantCls {
    
    //constructor
    public FAU_Webinar_ParticipantCls() {
        
    }
    

    
    /*******************************************************************
        Purpose:  Send Webinar Invitations -  for insert
    *******************************************************************/ 
    public static void insertSendInvitationToWebParts(FAU_Webinar_Participant__c[] lNewWebPart){ 
        System.Debug('#### FAU_Webinar_ParticipantBeforeInsertUpdate - Send Webinar Date/Time');
        FAU_Webinar_Participant__c[] lWebPart =new FAU_Webinar_Participant__c[]{};  
        for(Integer i = (lNewWebPart.size()-1); i >=0 ; i--) { 
          // Removed Boolean expression. 
           if (lNewWebPart[i].FAU_Has_Accepted__c) {
                lWebPart.add(lNewWebPart[i]);   
            }
        }   
        
        System.Debug('#### Send Webinar Date/Time.count: '+lWebPart.size()+' FAU_Webinar_Participant__c');

        if(lWebPart.size()>0){ FAU_EmailSender.sendInvitationToWebParts(lWebPart);
        }else System.Debug('#### Send Webinar Date/Time: '+lWebPart.size()+' FAU_Webinar_Participant__c');  
    }


    /*******************************************************************
        Purpose:  Send Webinar Invitations - for update
    *******************************************************************/ 
    public static void updateSendInvitationToWebParts(FAU_Webinar_Participant__c[] lNewWebPart, FAU_Webinar_Participant__c[] lOldWebPart){ 
        System.Debug('#### FAU_Webinar_ParticipantBeforeInsertUpdate - Send Webinar Date/Time');
        FAU_Webinar_Participant__c[] lWebPart =new FAU_Webinar_Participant__c[]{};  
        for(Integer i = (lNewWebPart.size()-1); i >=0 ; i--) { 
           if ((lNewWebPart[i].FAU_Has_Accepted__c)&&(!lOldWebPart[i].FAU_Has_Accepted__c)) {
                lWebPart.add(lNewWebPart[i]);   
            }
        }   
        
        System.Debug('#### Send Webinar Date/Time.count: '+lWebPart.size()+' FAU_Webinar_Participant__c');

        if(lWebPart.size()>0){ FAU_EmailSender.sendInvitationToWebParts(lWebPart);
        }else System.Debug('#### Send Webinar Date/Time: '+lWebPart.size()+' FAU_Webinar_Participant__c');  
    }






}