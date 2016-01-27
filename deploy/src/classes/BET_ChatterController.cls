/**********************************************************************
Name: BET_EditAssetController 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Controller for VF BET_Chatter
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Wojciech Migas          20/01/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class BET_ChatterController {
    public String BETGroupId {get; protected set;}
    public String message {get; protected set;}
    public Boolean showChatter {get; protected set;}
    public String entityId {get; set;}

    public BET_ChatterController() {
        String gid = ApexPages.currentPage().getParameters().get('gid');
        BETGroupId = null;
        showChatter = false;        
        message = '';

        if (String.isNotEmpty(gid)) {
            list<CollaborationGroup> chatterGroups = [SELECT IsArchived FROM CollaborationGroup WHERE Id =: gid];
            if (chatterGroups.isEmpty()) {
                message = 'You don\'t have access to this group.';
            } else if (chatterGroups[0].IsArchived) {
                message = 'This chatter group has been archived. Please contact your group owner/manager for reactivation.';
                showChatter = true;
                BETGroupId = gid;
            } else {
                showChatter = true;
                BETGroupId = gid;
            }
        }
    }

    public PageReference UpdateChatterFeed() {
        BETGroupId = entityId;
        return null;
    }
}