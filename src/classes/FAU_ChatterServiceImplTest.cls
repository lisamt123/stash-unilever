/**********************************************************************
 Name:  FAU_ChatterServiceImplTest()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Test Methods for FAU_ChatterServiceImpl                                                   
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
@isTest
private class FAU_ChatterServiceImplTest {
    

    @isTest static void testCreateChatterGroups()
    {
        //FAU_ChatterService service = new FAU_ChatterServiceImpl();

        List<FAU_Program__c> programs = new List<FAU_Program__c>();
        Set<String> names = new Set<String>();

        FAU_Program__c program1 = FAU_TestUtil.buildProgram('one', Date.newInstance(2014, 08, 27), 'Singapore');
        programs.add(program1);
        names.add(program1.Name);
        FAU_Program__c program2 = FAU_TestUtil.buildProgram('two', Date.newInstance(2014, 08, 27), 'Singapore');
        programs.add(program2);
        names.add(program2.Name);
        FAU_Program__c program3 = FAU_TestUtil.buildProgram('three', Date.newInstance(2014, 08, 27), 'London');
        programs.add(program3);
        names.add(program3.Name);
        
        Test.startTest();

        insert programs;

        Test.stopTest();

        List<CollaborationGroup> groups = [SELECT Id, Name, CollaborationType, OwnerId FROM CollaborationGroup WHERE Name IN :names];

        System.assertEquals(groups.size(), programs.size(), 'There should be same amount of groups as programs');
        System.assertEquals(groups.size(), 3);

        for(CollaborationGroup chatterGroup : groups) 
        {
            System.assert(names.contains(chatterGroup.Name));
            System.assertEquals(chatterGroup.CollaborationType, 'Private');
        }

        System.assertNotEquals(groups[0].OwnerId, groups[1].OwnerId);
        System.assertNotEquals(groups[1].OwnerId, groups[2].OwnerId);
    }


    @isTest static void testAddParticipantsToProgramChatterGroup()
    {
        //FAU_ChatterService service = new FAU_ChatterServiceImpl();

        FAU_Program__c program = FAU_TestUtil.buildProgram('Brewery Event Organization', Date.newInstance(2014, 08, 27), 'Singapore');

        insert program;

        User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

       // FAU_Webinar__c webinar = FAU_TestUtil.createWebinar(program);

        program.FAU_Status__c = 'Active';
        update program;

        FAU_Participant__c participant = FAU_TestUtil.buildParticipant(user, 'Invited', program);
        participant.FAU_Program_Wave__c = program.Id;

        Test.startTest();

        insert participant;


        List<CollaborationGroupMember> membersBeforeUpdate = [SELECT Id FROM CollaborationGroupMember WHERE MemberId = :user.Id];
        System.assertEquals(membersBeforeUpdate.size(), 0);

        participant.FAU_Invite_State__c = 'Accepted';
        update participant;

        Test.stopTest();

        List<CollaborationGroupMember> membersAferUpdate = [SELECT Id FROM CollaborationGroupMember WHERE MemberId = :user.Id];
        System.debug('#### FAU_ChatterServiceImplTest.membersAferUpdate.Size : ' + membersAferUpdate.size());
        System.assertEquals(membersAferUpdate.size(), 1);

    }


    @isTest static void testSaveErrorHandling()
    {
        FAU_ChatterServiceImpl service = new FAU_ChatterServiceImpl();

        CollaborationGroup chatterGroup = new CollaborationGroup();

        List<CollaborationGroup> groups = new List<CollaborationGroup>();
        groups.add(chatterGroup);

        service.databaseSave(groups);

        List<CollaborationGroup> cgGroups = [SELECT Id FROM CollaborationGroup WHERE Id = :groups];
        System.debug('#### FAU_ChatterServiceImplTest.cgGroups.Size : ' + cgGroups.size());
        System.assertEquals(cgGroups.size(), 0);
    }
    
}