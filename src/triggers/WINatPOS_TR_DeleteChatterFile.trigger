/**********************************************************************
Name: WINatPOS_TR_DeleteChatterFile
Copyright © 2014 Unilever.
========================================================================
========================================================================
Purpose: Before delete trigger on File__c
to delete Chatter files associated with a File_c record that is deleted
========================================================================
========================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

trigger WINatPOS_TR_DeleteChatterFile on File__c (before delete) {
        WINatPOS_TH_DeleteChatterFile deleteChatterFileProcessClass = new WINatPOS_TH_DeleteChatterFile();
        deleteChatterFileProcessClass.processDeleteChatterFile(trigger.old);
}