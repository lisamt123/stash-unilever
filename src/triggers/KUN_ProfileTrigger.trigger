/**********************************************************************
Name: KUN_ProfileTrigger ()
Copyright  2016  Unilever
======================================================================
======================================================================
Purpose:  Trigger Class                                                
To Handle the extendated Search Requirment & for Apex Sharing 
Rules                                 
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
****************************************************************************/
trigger KUN_ProfileTrigger on KUN_Profile__c (before insert,before update,after Insert, after update) {

    KUN_ProfileTriggerHandler handler = new KUN_ProfileTriggerHandler ();
    if( Trigger.isInsert ) {
       if(Trigger.isBefore)       
          handler.OnBeforeInsert(Trigger.New );   
       else       
          handler.OnAfterInsert(trigger.New);
       }
    else if ( Trigger.isUpdate ){
        if(Trigger.isBefore)        
            handler.OnBeforeUpdate(trigger.New);        
    }
}