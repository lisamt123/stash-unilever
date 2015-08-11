/**********************************************************************
Name: BET_ManageMembersContoller
Copyright © 2014 Unilever.
======================================================
==========================================================
Purpose: Apex controller to manage BET members
Used in: BET_ManageMembers VisualForce page
==========================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          12/12/2014      INITIAL DEVELOPMENT
1.1-    Blessy Voola            28 Apr 2015   T0: Fix for the issue: If a user is already added to chatter group, when trying to 
                                                 add the same user to the bet associated it is showing error
1.2    Kendre Dnyaneshwar       27 Apr 2015   T1: Modified the query in getmembers method to remove delete button for BET 
                                                 owner                                      
1.3     Michal Bluj             03/08/2015      Sonar related issues fixes
1.4     Michal Bluj             11/08/2015      IPM Member Related Changes
***********************************************************************/

public without sharing class BET_ManageMembersController {
    public BET_Member_Request__c BETTeamMember {get;set;}
    
    public BET_ManageMembersController(ApexPages.StandardController controller) {
        BETTeamMember = new BET_Member_Request__c();
    }

    public void addMember(){

    }

    public void addExternalMember(){

    }
  
}