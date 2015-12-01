/**********************************************************************
Name: WINatPOS_TR_DeleteChatterFile
Copyright © 2015 Unilever.
========================================================================
========================================================================
Purpose: After insert/update trigger on Asset__c
========================================================================
========================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela        23/11/2015      INITIAL DEVELOPMENT
***********************************************************************/
trigger WINatPOS_AssetTrigger on Asset__c (after insert, after update) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            WINatPOSUtilRemoteActions.handleAssetAgenciesShares(Trigger.new);
        }
        
        if(Trigger.isUpdate){
            WINatPOSUtilRemoteActions.handleAssetAgenciesShares(Trigger.new);
        }
    }
}