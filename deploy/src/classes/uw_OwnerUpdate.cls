/**********************************************************************
Name: uw_OwnerUpdate 

1.1 -   Dnyaneshwar Kendre      17/06/2015      T0- To remove pending members issue 
**********************************************************************/
public without sharing class uw_OwnerUpdate {
    
    public Boolean addInitialMembersAsStandard(List<uw_BET__Share> toAddRows, String parentId) {
        //system.debug('addInitialMembersAsStandard: entry');
        Boolean ok = false;

        List<uw_BET__Share> bsList = new List<uw_BET__Share>();
        for(uw_BET__Share toAddRow:toAddRows) {
            uw_BET__Share bs = new uw_BET__Share();
            bs.AccessLevel = (toAddRow.AccessLevel == 'All') ? 'Edit' : toAddRow.AccessLevel;
            bs.ParentId = toAddRow.ParentId;
            bs.RowCause = 'Manual';
            bs.UserOrGroupId = toAddRow.UserOrGroupId;
            //system.debug('addInitialMembersAsStandard: toAddRow: '+bs);
            bsList.add(bs);
        }

        try {
            insert bsList;
            ok = true;
        } catch (Exception e) {
            system.debug('addInitialMembersAsStandard: error: '+e);
        }
        //system.debug('addInitialMembersAsStandard: exit: '+ok);
        return ok;      
    }
    
    /* consider retiring - this only works if the bet share has two members
    public Boolean addInitialOwnerAsStandard(String initialUserId, String parentId) {
        //system.debug('addInitialOwnerAsStandard: entry');
        Boolean ok = false;
        try {
            
            uw_BET__Share oldNowAManagerRow = new uw_BET__Share(AccessLevel='Edit',ParentId=parentId,
                                                                RowCause='Manual', UserOrGroupId=initialUserId);
            insert oldNowAManagerRow;
            ok = true;
        } catch (Exception e) {
            system.debug('addInitialOwnerAsStandard: error: '+e);
        }
        //system.debug('addInitialOwnerAsStandard: exit: '+ok);
        return ok;
    }
    */
    public Boolean addInitialSharersAsStandard(uw_BET__c bet, String ownerId, String parentId) {
        //system.debug('addInitialSharersAsStandard: entry');
        Boolean ok = false;
        try {
            List<uw_BET__Share> bsList = getBetShares(bet, ownerId);
            ok = addInitialMembersAsStandard(bsList, parentId);
        } catch (Exception e) {
            system.debug('addInitialSharersAsStandard: error: '+e);
        }
        //system.debug('addInitialSharersAsStandard: exit: '+ok);
        return ok;
    }


    public Boolean updateBETOwner(uw_BET__c bet, String oldUserId, String newUserId) {
        Boolean ok = false;
        
        try {
            List<uw_BET__Share> toAddRows = [SELECT Id,UserOrGroupId,ParentId,AccessLevel FROM uw_BET__Share WHERE ParentId=:bet.id AND UserOrGroupId!=:newUserId];
            if (!uw_HelperMethods.listIsNull(toAddRows))  {
                //system.debug('toAddRows: '+toAddRows);
                
                bet.OwnerId = newUserId;
                update bet;
                    
                // finally re-add the old owner
                ok = addInitialMembersAsStandard(toAddRows, bet.Id);                
            }
            
        } catch (Exception e) {
            system.debug('updateBETOwner: error: '+e);         
        }
        
        return ok;
    }
    
    public Boolean updateTeamOwner(uw_BET__c bet, String oldUserId, String newUserId) {
        Boolean ok = false;

        //system.debug('updateTeamOwner: entry');
        system.debug('updateTeamOwner: oldUserId: '+oldUserId);
        system.debug('updateTeamOwner: newUserId: '+newUserId);
        try {
            // get the rows for the current team owner (old) and the new team owner
            //system.debug('updateTeamOwner: test old');
            List<uw_BET_Team_Member__c> ownerRows = [SELECT Id FROM uw_BET_Team_Member__c WHERE Team_Member__c = :oldUserId AND BET__c =:bet.Id];
            if ((!uw_HelperMethods.listIsNull(ownerRows)) && (ownerRows.size() == 1)) {
                // first modify the existing owner
                uw_BET_Team_Member__c ownerRow = ownerRows[0];
                ownerRow.IsOwner__c = false;
                ownerRow.Role__c = 'Manager';
                update ownerRow;

                //added by maciek
                List<EntitySubscription> entList = [SELECT Id FROM EntitySubscription WHERE SubscriberId = :oldUserId LIMIT 1];  
                if(entList.size() == 0){
                    EntitySubscription entSubscription = new EntitySubscription();
                    entSubscription.SubscriberId = ownerRow.Team_Member__c;
                    entSubscription.ParentId = bet.Id;
                    insert entSubscription;
                }  
                
                //system.debug('updateTeamOwner: test new');
                // second modify the new owner
                List<uw_BET_Team_Member__c> usurperRows = [SELECT Id,Team_Member__c,BET__c FROM uw_BET_Team_Member__c WHERE Team_Member__c = :newUserId AND BET__c =:bet.Id];
                uw_BET_Team_Member__c usurperRow;
                Boolean isNew = false;
                if ((!uw_HelperMethods.listIsNull(usurperRows)) && (usurperRows.size() > 0)) {
                    // it is an update
                    //system.debug('updateTeamOwner: update');
                    usurperRow = usurperRows[0];
                    isNew = false;
                } else {
                    // the new BET owner does not have a Team Member row, we must create one
                    //system.debug('updateTeamOwner: new');
                    usurperRow = new uw_BET_Team_Member__c();
                    usurperRow.Team_Member__c = newUserId;
                    // best guess
                    //usurperRow.RecordTypeId = 'InternalUser';
                    usurperRow.BET__c = bet.Id;
                    isNew = true;
                }               
                // same whether update or insert
                usurperRow.Access_Level__c = uw_Constants.ACCESS_LEVEL_FULL;
                usurperRow.BETEnabled__c = true;
                usurperRow.StudioEnabled__c = true;
                usurperRow.IsOwner__c = true;
                usurperRow.Role__c = uw_Constants.BET_TEAM_ROLE_MANAGER;
                /*T0 start*/
                usurperRow.Pending_Request__c = false;
                /*T0 end*/
                //system.debug('usurperRow: before: '+usurperRow);
                if (isNew) {
                    insert usurperRow;                  
                }
                else {
                    update usurperRow;
                }

                //added by maciek
                entList = [SELECT Id FROM EntitySubscription WHERE SubscriberId = :newUserId LIMIT 1];  
                if(entList.size() == 0){
                    EntitySubscription entSubscription = new EntitySubscription();
                    entSubscription.SubscriberId = newUserId;
                    entSubscription.ParentId = bet.Id;
                    insert entSubscription;
                }

                //system.debug('usurperRow: after: '+usurperRow);
                ok = true;               
            }
        } catch (Exception e) {
            system.debug('updateTeamOwner: error: '+e);         
            
        }
        
        return ok;
    }

    public Boolean updateCollaborationOwner(uw_BET__c bet, String oldUserId, String newUserId) {
        Boolean ok = false;

        //system.debug('updateCollaborationOwner: entry');
        try {
            // get the rows for the current team owner (old) and the new team owner
            //system.debug('updateCollaborationOwner: test old');
            List<CollaborationGroupMember> ownerRows = [SELECT Id, CollaborationGroupId, CollaborationRole, MemberId FROM CollaborationGroupMember WHERE memberId = :oldUserId AND CollaborationGroupId =:bet.Studio_Chatter_Group__c];
            if ((!uw_HelperMethods.listIsNull(ownerRows)) && (ownerRows.size() == 1)) {

                CollaborationGroupMember ownerRow = ownerRows[0];
                // The next line is probably wrong. If the old owner was Admin (i.e. a BET Team Manager) he should remain Admin
                //ownerRow.CollaborationRole = 'Standard';

                // first modify the new owner
                List<CollaborationGroupMember> usurperRows = [SELECT Id, CollaborationGroupId, CollaborationRole, MemberId FROM CollaborationGroupMember WHERE memberId = :newUserId AND CollaborationGroupId =:bet.Studio_Chatter_Group__c];
                CollaborationGroupMember usurperRow;
                Boolean isNew = false;
                if ((!uw_HelperMethods.listIsNull(usurperRows)) && (usurperRows.size() > 0)) {
                    // it is an update
                    system.debug('updateCollaborationOwner: update');
                    usurperRow = usurperRows[0];
                    isNew = false;
                } else {
                    // the new BET owner does not have a Team Member row, we must create one
                    system.debug('updateCollaborationOwner: new');
                    usurperRow = new CollaborationGroupMember();
                    usurperRow.CollaborationGroupId = ownerRow.CollaborationGroupId;
                    usurperRow.MemberId = newUserId;
                    if (uw_HelperMethods.hasModifyAllData()) {
                        usurperRow.NotificationFrequency = 'N';
                    } 
                    isNew = true;
                }               
                // same whether update or insert
                usurperRow.CollaborationRole= 'Admin';
    
                //system.debug('usurperRow: before: '+usurperRow);
                if (isNew) {
                    insert usurperRow;                  
                }
                else {
                    update usurperRow;
                }
                //system.debug('usurperRow: after: '+usurperRow);

                // second modify the existing owner
                update ownerRow;
                
                //system.debug('updateCollaborationOwner: test new');

                // also change the owner of the CollaborationGroup
                List<CollaborationGroup> cgs = [SELECT Id, OwnerId FROM CollaborationGroup WHERE Id=:bet.Studio_Chatter_Group__c];
                if (!uw_HelperMethods.listIsNull(cgs)) {
                    cgs[0].ownerId = newUserId;
                    update cgs;
                }

                ok = true;               
            }
        } catch (Exception e) {
            system.debug('updateTeamOwner: error: '+e);         
            
        }
        
        return ok;
    }

    private List<CollaborationGroupMember> getCollaborationGroupMembers(uw_BET__c bet, String ownerId) {
        List<CollaborationGroupMember> cgmList = [SELECT Id, CollaborationGroupId, CollaborationRole, MemberId FROM CollaborationGroupMember WHERE memberId != :ownerId AND CollaborationGroupId =:bet.Studio_Chatter_Group__c];
        return cgmList;
    }

    // need a method of finding out all the users who were removed from the BET__Share when the ownerId was changed
    private List<uw_BET__Share> getBetShares(uw_BET__c bet, String ownerId) {
        List<CollaborationGroupMember> cgmList = getCollaborationGroupMembers(bet, ownerId);
        List<uw_BET__Share> bsList = new List<uw_BET__Share>();
        
        for (CollaborationGroupMember cgm:cgmList) {
            uw_BET__Share bs = new uw_BET__Share();
            bs.ParentId = bet.Id;
            bs.UserOrGroupId = cgm.memberId;
            bs.RowCause = 'Manual';
            bs.AccessLevel = (cgm.CollaborationRole == 'Admin') ? 'Edit': 'Read';
            bsList.add(bs);
        }
        
       
        return bsList;
    }

    public static CollaborationGroupMember insertCollaborationGroupMember(CollaborationGroupMember cgm) {
        CollaborationGroupMember cgmResult = null;
        try {
            List<CollaborationGroupMember> cgmList = [SELECT Id, MemberId FROM CollaborationGroupMember WHERE CollaborationGroupId=:cgm.CollaborationGroupId];
            for (CollaborationGroupMember cgm1:cgmList) {
                system.debug('cgm1: '+cgm1);            
            }
            system.debug('cgm: '+cgm);
            insert cgm;
            cgmResult =  cgm;
        } catch (Exception ex) {
            system.debug('insertCollaborationGroupMember: exception: '+ex);
        }
        return cgmResult;
    }
    private static void test_CollaborationUpdate() {
        User u1 = uw_UnitTestDataFactory.initInternalUser('a1', 'a1@email.edu.edu', 'jones', 'jones@edu.edu');
        User u2 = uw_UnitTestDataFactory.initInternalUser('a2', 'a2@email.edu.edu', 'smith', 'smith@edu.edu');
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;        

        uw_BET__c bet;
        System.runAs(u1) {
            //bet = uw_UnitTestDataFactory.createBet_New(brand, 'betName'+Math.random(),newProject2);
            //IDC- 14 Jun - new Inoplan parameter added     
            bet = uw_UnitTestDataFactory.initBET('betName',true,inoPlanProject);           
        }
        
        List<CollaborationGroupMember> cgms = [SELECT Id, CollaborationGroupId, CollaborationRole, MemberId FROM CollaborationGroupMember];
        for (CollaborationGroupMember cgm:cgms) {
            //system.debug('cgm: '+cgm);
        } 
        
        uw_OwnerUpdate ou = new uw_OwnerUpdate();
        system.assertEquals(true, ou.updateCollaborationOwner(bet, u1.id, u2.id));
        
        cgms = [SELECT Id, CollaborationGroupId, CollaborationRole, MemberId FROM CollaborationGroupMember];
        boolean st = false;
        for (CollaborationGroupMember cgm:cgms) {
            if (cgm.memberId == u1.Id) {
                system.assertEquals('Admin',cgm.CollaborationRole);
                st = true;
            } else if (cgm.MemberId == u2.Id) {
                system.assertEquals('Admin',cgm.CollaborationRole);             
                st = true;
            } else 
            {
                //system.debug('**** Role ' + cgm.CollaborationRole); 
                //system.assert(false);
                
            }
            

        } 
        
        if(st == false)
        {
            system.assert(false);
        }
        // now try again u2 to u1
        system.assertEquals(true, ou.updateCollaborationOwner(bet, u2.id, u1.id));
        st = false;        
        cgms = [SELECT Id, CollaborationGroupId, CollaborationRole, MemberId FROM CollaborationGroupMember];
        for (CollaborationGroupMember cgm:cgms) {
            if (cgm.memberId == u1.Id) {
                 system.assertEquals('Admin',cgm.CollaborationRole);
                 st = true;
            } else if (cgm.MemberId == u2.Id) {
                system.assertEquals('Admin',cgm.CollaborationRole);
                st = true;             
            } else 
            {
            }
        } 
         if(st == false)
        {
            system.assert(false);
        }
        
        
        
    }
    private static void test_TeamOwnerUpdate() {
        // there are two test case
        // 1. where the new team member does not exist
        // 2. where the new team member already exists
        User u1 = uw_UnitTestDataFactory.initInternalUser('a1', 'a1@email.edu.edu', 'jones', 'jones@edu.edu');
        User u2 = uw_UnitTestDataFactory.initInternalUser('a2', 'a2@email.edu.edu', 'smith', 'smith@edu.edu');
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;       
        uw_BET__c bet;
        System.runAs(u1) {                     
        bet = uw_UnitTestDataFactory.initBET('betName', true,inoPlanProject);           
        }

        String accessLevel1 = uw_Constants.ACCESS_LEVEL_FULL;
        String role1 = uw_Constants.BET_TEAM_ROLE_MANAGER;
                   
        // creating the BET adds u1 as the Team Manager           
        List<uw_BET_Team_Member__c> tml = [SELECT Team_Member__c, isOwner__c, Id, role__c, access_level__c FROM uw_BET_Team_Member__c WHERE bet__C=:bet.id];
        //system.debug('tmlist: after BET Creation');
        //for (uw_BET_Team_Member__c tm:tml) {
        //    system.debug('tm: '+tm);
        //}

        uw_BET_Team_Member__c tm1 = tml[0];
        //system.debug('tm1: '+tm1);

        // test the method hoping u2 gets a tm created
        uw_OwnerUpdate ou = new uw_OwnerUpdate();
        system.assertEquals(true,ou.updateTeamOwner(bet, u1.Id, u2.Id));        
    
        uw_BET_Team_Member__c tm1a = [SELECT isOwner__c, Id, role__c, access_level__c FROM uw_BET_Team_Member__c WHERE team_member__c=:u1.Id AND bet__C=:bet.id];
        system.assert(tm1a != null); 
        system.assertEquals(false, tm1a.IsOwner__c);
        system.assertEquals(uw_Constants.ACCESS_LEVEL_FULL, tm1a.access_level__c);
        system.assertEquals(uw_Constants.BET_TEAM_ROLE_MANAGER, tm1a.role__c);
        
        tml = [SELECT Team_Member__c, isOwner__c, Id, role__c, access_level__c FROM uw_BET_Team_Member__c WHERE bet__C=:bet.id];
        //system.debug('tmlist');
        //for (uw_BET_Team_Member__c tm:tml) {
        //  system.debug('tm: '+tm);
        //}
        
        uw_BET_Team_Member__c tm2a = [SELECT isOwner__c, Id, role__c, access_level__c FROM uw_BET_Team_Member__c WHERE team_member__c=:u2.Id AND bet__C=:bet.id];
        system.debug('tm2a: '+tm2a);
        system.assert(tm2a != null);        
        system.assertEquals(true, tm2a.IsOwner__c);
        system.assertEquals(uw_Constants.ACCESS_LEVEL_FULL, tm2a.access_level__c);
        system.assertEquals(uw_Constants.BET_TEAM_ROLE_MANAGER, tm2a.role__c);
        
        // now let's update u1 and make him somebody with limited permissions
        // the test will be to make u1 the new owner and check that his permissions are elevated
        tm1a.Access_Level__c = uw_Constants.ACCESS_LEVEL_EXTERNAL_VIEW;
        tm1a.BETEnabled__c = false;
        tm1a.Role__c = uw_Constants.BET_TEAM_ROLE_USER;
        tm1a.StudioEnabled__c = false;
        update tm1a;
        
        system.assertEquals(true,ou.updateTeamOwner(bet, u2.Id, u1.Id));        

        uw_BET_Team_Member__c tm1b = [SELECT isOwner__c, Id, role__c, access_level__c FROM uw_BET_Team_Member__c WHERE team_member__c=:u1.Id AND bet__C=:bet.id];
        system.assert(tm1b != null); 
        system.assertEquals(true, tm1b.IsOwner__c);
        system.assertEquals(uw_Constants.ACCESS_LEVEL_FULL, tm1b.access_level__c);
        system.assertEquals(uw_Constants.BET_TEAM_ROLE_MANAGER, tm1b.role__c);
        
        uw_BET_Team_Member__c tm2b = [SELECT isOwner__c, Id, role__c, access_level__c FROM uw_BET_Team_Member__c WHERE team_member__c=:u2.Id AND bet__C=:bet.id];
        system.assert(tm2b != null);        
        system.assertEquals(false, tm2b.IsOwner__c);
        system.assertEquals(uw_Constants.ACCESS_LEVEL_FULL, tm2b.access_level__c);
        system.assertEquals(uw_Constants.BET_TEAM_ROLE_MANAGER, tm2b.role__c);
        
    }

    private static void test_BetShareUpdate() {
        User u1 = uw_UnitTestDataFactory.initInternalUser('a1', 'a1@email.edu.edu', 'jones', 'jones@edu.edu');
        User u2 = uw_UnitTestDataFactory.initInternalUser('a2', 'a2@email.edu.edu', 'smith', 'smith@edu.edu');
        uw_BET__c bet;
        //IDC- 14 Jun - Creating test data for Inoplan object
        uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
        insert inoPlanProject;
        
        
        System.runAs(u1) {
            //IDC- 14 Jun - new Inoplan parameter added     
            bet = uw_UnitTestDataFactory.initBET('betName', true,inoPlanProject);           
            uw_BET__Share bsnew = new uw_BET__Share(AccessLevel='Edit',ParentId=bet.Id,
                                                  RowCause='Manual', UserOrGroupId=u2.Id);
            insert bsnew;       
        }
        
        // get the Bet Share for U1
        List<uw_BET__Share> bs1 = [Select u.UserOrGroupId, u.RowCause, u.ParentId, u.LastModifiedDate, u.LastModifiedById, u.IsDeleted, u.Id, u.AccessLevel From uw_BET__Share u WHERE ParentId=:bet.Id AND userOrGroupId=:u1.id];
        system.debug('bs1: '+bs1);
        system.assert(bs1 != null);
        system.assertEquals(1,bs1.size());
        system.assertEquals('All', bs1[0].AccessLevel);
        system.assertEquals('Owner', bs1[0].RowCause);
        
        // get the Bet Share for U2
        List<uw_BET__Share> bs2 = [Select u.UserOrGroupId, u.RowCause, u.ParentId, u.LastModifiedDate, u.LastModifiedById, u.IsDeleted, u.Id, u.AccessLevel From uw_BET__Share u WHERE ParentId=:bet.Id AND userOrGroupId=:u2.id];
        system.debug('bs2: '+bs2);
        system.assert(bs2 != null);
        system.assertEquals(1,bs2.size());
        system.assertEquals('Edit', bs2[0].AccessLevel);
        system.assertEquals('Manual', bs2[0].RowCause);
        
        // Make u2 the owner
        uw_OwnerUpdate bsu = new uw_OwnerUpdate ();
        system.assertEquals(true, bsu.updateBETOwner(bet, u1.Id, u2.Id));

        // check u1 is not the owner
        bs1 = [Select u.UserOrGroupId, u.RowCause, u.ParentId, u.LastModifiedDate, u.LastModifiedById, u.IsDeleted, u.Id, u.AccessLevel From uw_BET__Share u WHERE ParentId=:bet.Id AND userOrGroupId=:u1.id];
        system.debug('bs1: '+bs1);
        system.assert(bs1 != null);
        system.assertEquals(1,bs1.size());
        system.assertEquals('Edit', bs1[0].AccessLevel);
        system.assertEquals('Manual', bs1[0].RowCause);
        
        // check u2 is the new owner
        bs2 = [Select u.UserOrGroupId, u.RowCause, u.ParentId, u.LastModifiedDate, u.LastModifiedById, u.IsDeleted, u.Id, u.AccessLevel From uw_BET__Share u WHERE ParentId=:bet.Id AND userOrGroupId=:u2.id];
        system.debug('bs2: '+bs2);
        system.assert(bs2 != null);
        system.assertEquals(1,bs2.size());
        system.assertEquals('All', bs2[0].AccessLevel);
        system.assertEquals('Owner', bs2[0].RowCause);

        // now set u1 to be the owner
        bet.OwnerId = u1.Id;
        update bet;
        
        // this should just leave one entry in the BET Share
        bs1 = [Select u.UserOrGroupId, u.RowCause, u.ParentId, u.LastModifiedDate, u.LastModifiedById, u.IsDeleted, u.Id, u.AccessLevel From uw_BET__Share u WHERE ParentId=:bet.Id];
        system.assertEquals(1, bs1.size());
        
        // make sure u1 and u2 belong to a collab group as this is where we work out who to add back in
        //CollaborationGroupMember cgm1 = uw_UnitTestDataFactory.initCollaborationGroupMember(bet.Studio_Chatter_Group__c, u1, 'Standard');
        //CollaborationGroupMember cgm2 = uw_UnitTestDataFactory.initCollaborationGroupMember(bet.Studio_Chatter_Group__c, u2, 'Standard');        
        
        // Now try to add the users (just u2) back in
        system.assertEquals(true, bsu.addInitialSharersAsStandard(bet, u1.Id, bet.Id));

        // check u1 is  the owner
        bs1 = [Select u.UserOrGroupId, u.RowCause, u.ParentId, u.LastModifiedDate, u.LastModifiedById, u.IsDeleted, u.Id, u.AccessLevel From uw_BET__Share u WHERE ParentId=:bet.Id AND userOrGroupId=:u1.id];
        system.debug('bs1: '+bs1);
        system.assert(bs1 != null);
        system.assertEquals(1,bs1.size());
        system.assertEquals('All', bs1[0].AccessLevel);
        system.assertEquals('Owner', bs1[0].RowCause);
        
        // check u2 is now the new owner
        bs2 = [Select u.UserOrGroupId, u.RowCause, u.ParentId, u.LastModifiedDate, u.LastModifiedById, u.IsDeleted, u.Id, u.AccessLevel From uw_BET__Share u WHERE ParentId=:bet.Id AND userOrGroupId=:u2.id];
        system.debug('bs2: '+bs2);
        system.assert(bs2 != null);
        system.assertEquals(1,bs2.size());
        system.assertEquals('Edit', bs2[0].AccessLevel);
        system.assertEquals('Manual', bs2[0].RowCause);
        
    }
    
    private static testmethod void test_CollaborationGroupMemberInsert() {
        User u1 = uw_UnitTestDataFactory.initInternalUser('a1', 'a1@email.edu.edu', 'jones', 'jones@edu.edu');
        User u2 = uw_UnitTestDataFactory.initInternalUser('a2', 'a2@email.edu.edu', 'smith', 'smith@edu.edu');
        CollaborationGroup cg;
        
        System.runAs(u1) {
            cg =  uw_UnitTestDataFactory.initCollaborationGroup('cgName', 'Private');  
            system.assert(cg.Id != null);           
        }
        
        System.runAs(u2) {
            CollaborationGroupMember cgm = new CollaborationGroupMember();
            cgm.CollaborationGroupId = cg.Id;
            cgm.CollaborationRole = 'Standard';
            cgm.MemberId = u2.Id;
            cgm.NotificationFrequency = 'N';
            CollaborationGroupMember cgmResult = uw_OwnerUpdate.insertCollaborationGroupMember(cgm);
            system.assert(cgmResult != null);   
            system.assert(cgmResult.Id != null);            
        }
    }
}