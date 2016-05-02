@isTest
private class PBS_ProfileService_Test {

    private static final string LEVEL1 = 'Level 1';
    private static final string EUROPE = 'Europe';
    private static final string GUEST = 'Guest';
    private static final string TESTS = 'Test';
    private static final string UPDATE_NOT_REQUIRED = 'Update should not be required';
    private static final string UPDATE_REQUIRED = 'Update should be required';
    private static final string EN_US = 'en_US';
    private static final string NOT_SHARE = 'There should be no sharing for this user';  
    private static final string SHARE = 'There should be sharing for this user';  
    
    
    @isTest
    static void getPicklistOptions() {
        Test.startTest();

        List<String> result  = PBS_ProfileService.getPicklistOptions('PBS_Profile__c', 'Geography__c', false);
        System.assertEquals(false, result.isEmpty(), 'No picklist value available');

        List<String> result2 = PBS_ProfileService.getPicklistOptions('PBS_Profile__c', 'Geography__c', true);
        System.assertEquals(false, result.size() == result2.size(), 'Second list should have more values then first one');

        Boolean emptyValueFound = false;
        for (String s : result2) {
            if (s == '') {
                emptyValueFound = true;
            }
        }

        System.assertEquals(true, emptyValueFound, 'Empty value was not found');

        Test.stopTest();
    }

    @isTest
    static void getCurrentUserProfile() {
        Test.startTest();

        PBS_Standard_Job_Profile__c sjp  = new PBS_Standard_Job_Profile__c(
            Name = GUEST
        );
        PBS_Standard_Job_Profile__c sjp2 = new PBS_Standard_Job_Profile__c(
            Name = TESTS
        );
        insert new List<PBS_Standard_Job_Profile__c>{sjp, sjp2};

        String userId = UserInfo.getUserId();
        System.assertEquals(0, [SELECT Id FROM PBS_Profile__c WHERE User__c = :userId].size(), 'User profile should not exist');

        PBS_Profile__c profile = PBS_ProfileService.getCurrentUserProfile();
        System.assertEquals(GUEST, profile.Work_Level__c, 'Work Level not initialized to Guest');
        System.assertEquals(GUEST, profile.Geography__c,  'Geography not initialized to Guest');
        System.assertEquals(sjp.Id,  profile.User_Role__c,  'Role not initialized to Guest');

        profile.Work_Level__c = TESTS;
        profile.Geography__c  = TESTS;
        profile.User_Role__c  = sjp2.Id;
        upsert profile;

        profile = PBS_ProfileService.getCurrentUserProfile();
        System.assertEquals(TESTS, profile.Work_Level__c, 'Work Level not valid');
        System.assertEquals(TESTS, profile.Geography__c,  'Geography not valid');
        System.assertEquals(sjp2.Id, profile.User_Role__c,  'Role not valid');

        Test.stopTest();
    }

    @isTest
    static void isUpdateRequiredProfile() {
        Test.startTest();

        PBS_Profile__c p1 = new PBS_Profile__c();
        PBS_Profile__c p2 = new PBS_Profile__c();

        PBS_Standard_Job_Profile__c sjp  = new PBS_Standard_Job_Profile__c(
            Name = GUEST
        );
        insert sjp;

        p1.Work_Level__c = null;
        p1.Geography__c  = null;
        p1.user_role__c  = null;
        p1.user__c       = null;

        p2.Work_Level__c = null;
        p2.Geography__c  = null;
        p2.user_role__c  = null;
        p2.user__c       = null;

        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        p1.Work_Level__c = 'New';
        System.assertEquals(true, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_REQUIRED);
        p1.Work_Level__c = null;
        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        p1.Geography__c  = 'New';
        System.assertEquals(true, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_REQUIRED);
        p1.Geography__c  = null;
        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        p1.user_role__c  = sjp.Id;
        System.assertEquals(true, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_REQUIRED);
        p1.user_role__c  = null;
        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        p1.user__c       = UserInfo.getUserId();
        System.assertEquals(true, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_REQUIRED);
        p1.user__c       = null;
        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        Test.stopTest();
    }

    @isTest
    static void isUpdateRequiredTrainingTrack() {
        Test.startTest();

        Almond__Training_Track__c p1 = new Almond__Training_Track__c();
        Almond__Training_Track__c p2 = new Almond__Training_Track__c();

        PBS_Standard_Job_Profile__c sjp  = new PBS_Standard_Job_Profile__c(
            Name = GUEST
        );
        insert sjp;

        p1.Work_Level__c = null;
        p1.Geography__c  = null;
        p1.PBS_Standard_Job_Profile__c  = null;

        p2.Work_Level__c = null;
        p2.Geography__c  = null;
        p2.PBS_Standard_Job_Profile__c  = null;

        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        p1.Work_Level__c = 'New';
        System.assertEquals(true, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_REQUIRED);
        p1.Work_Level__c = null;
        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        p1.Geography__c  = 'New';
        System.assertEquals(true, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_REQUIRED);
        p1.Geography__c  = null;
        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        p1.PBS_Standard_Job_Profile__c  = sjp.Id;
        System.assertEquals(true, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_REQUIRED);
        p1.PBS_Standard_Job_Profile__c  = null;
        System.assertEquals(false, PBS_ProfileService.isUpdateRequired(p1, p2), UPDATE_NOT_REQUIRED);

        Test.stopTest();
    }

    @isTest
    static void updateSharingFromProfile()
    {
        User u = new User(
            email             = 'test@test.test.test',
            emailencodingkey  = 'UTF-8',
            lastname          = TESTS,
            FirstName         = TESTS,
            alias             = 'TA',
            languagelocalekey = EN_US,
            localesidkey      = EN_US,
            profileid         = [SELECT id FROM Profile WHERE name = 'Standard User'].id,
            timezonesidkey    = 'GMT',
            username          =  String.valueOf(DateTime.Now()).replace(' ', '').replace(':','') + 'test@test.com'
        );
        insert u;

        PBS_Standard_Job_Profile__c sjp  = new PBS_Standard_Job_Profile__c(
            Name = GUEST
        );
        insert sjp;

        Almond__Training_Track__c t1 = new Almond__Training_Track__c(
            Name                        = 'Test Name',
            Work_Level__c               = LEVEL1,
            Geography__c                = EUROPE,
            PBS_Standard_Job_Profile__c = sjp.Id
        );
        insert t1;

        PBS_Profile__c p1 = new PBS_Profile__c(
            Work_Level__c = 'Level 2', // this does not match so no sharing should be created
            Geography__c  = t1.Geography__c,
            user_role__c  = t1.PBS_Standard_Job_Profile__c,
            user__c       = u.Id
        );
        insert p1;

        PBS_ProfileService.PBS_ProfileWithoutSharing serviceObj = new PBS_ProfileService.PBS_ProfileWithoutSharing();

        Test.startTest();

        System.runAs(u) {
            // change work lave but not save object in order to avoid trigger
            p1.Work_Level__c = t1.Work_Level__c;

            // make sure there are no sharing for our user
            List<Almond__Training_Track__Share> tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(true, tts.isEmpty(), NOT_SHARE);

            // add sharing
            tts.addAll(serviceObj.getNewSharingForProfile(p1));
            serviceObj.updateSharing(tts, null);

            // check if added
            tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(false, tts.isEmpty(), SHARE);

            // remove sharing
            serviceObj.updateSharing(null, tts);
            tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(true, tts.isEmpty(), NOT_SHARE);
        }
        Test.stopTest();
    }

    @isTest
    static void updateSharingFromProfileTrigger()
    {
        User u = new User(
            email             = 'test@test.test.test',
            emailencodingkey  = 'UTF-8',
            lastname          = TESTS,
            FirstName         = TESTS,
            alias             = 'TA',
            languagelocalekey = EN_US,
            localesidkey      = EN_US,
            profileid         = [SELECT id FROM Profile WHERE name = 'Standard User'].id,
            timezonesidkey    = 'GMT',
            username          =  String.valueOf(DateTime.Now()).replace(' ', '').replace(':','') + 'test@test.com'
        );
        insert u;

        PBS_Standard_Job_Profile__c sjp = PBS_TestHelper.createJobProfile(GUEST);
        Almond__Training_Track__c t1            = PBS_TestHelper.createTrainingTrack('Test Name', LEVEL1, EUROPE, sjp.Id);

        PBS_Profile__c p1 = new PBS_Profile__c(
            Work_Level__c = t1.Work_Level__c,
            Geography__c  = t1.Geography__c,
            user_role__c  = t1.PBS_Standard_Job_Profile__c,
            user__c       = u.Id
        );
        // insert p1;

        PBS_ProfileService.PBS_ProfileWithoutSharing serviceObj = new PBS_ProfileService.PBS_ProfileWithoutSharing();

        Test.startTest();

        System.runAs(u) {
            List<Almond__Training_Track__Share> tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(true, tts.isEmpty(), NOT_SHARE);

            // create sharing
            insert p1;

            // make sure there are sharing for our user
            tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(false, tts.isEmpty(), SHARE);

            p1.Work_Level__c = 'Invalid Level';
            update p1;

            // should be no sharing due to level change
            tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(true, tts.isEmpty(), NOT_SHARE);

            // restore sharing
            p1.Work_Level__c = t1.Work_Level__c;
            update p1;

            // make sure there are sharing for our user
            tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(false, tts.isEmpty(), SHARE);

            // remove profile and therefore remove sharing
            delete p1;

            // should be no sharing due to level change
            tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(true, tts.isEmpty(), NOT_SHARE);

            undelete p1;

            // make sure there are sharing for our user
            tts = serviceObj.getExistingSharingForProfile(p1);
            System.assertEquals(false, tts.isEmpty(), SHARE);
        }

        Test.stopTest();
    }

    @isTest
    static void updateSharingFromTrack()
    {
        User u = new User(
            email             = 'test@test.test.test',
            emailencodingkey  = 'UTF-8',
            lastname          = TESTS,
            FirstName         = TESTS,
            alias             = 'TA',
            languagelocalekey = EN_US,
            localesidkey      = EN_US,
            profileid         = [SELECT id FROM Profile WHERE name = 'Standard User'].id,
            timezonesidkey    = 'GMT',
            username          =  String.valueOf(DateTime.Now()).replace(' ', '').replace(':','') + 'test@test.com'
        );
        insert u;

        PBS_Standard_Job_Profile__c sjp = PBS_TestHelper.createJobProfile(GUEST);

        PBS_Profile__c p1 = new PBS_Profile__c(
            Work_Level__c = 'Level 2',
            Geography__c  = EUROPE,
            user_role__c  = sjp.Id,
            user__c       = u.Id
        );
        insert p1;
        Almond__Training_Track__c t1 = PBS_TestHelper.createTrainingTrack('Test Name', LEVEL1, p1.Geography__c, p1.user_role__c);


        PBS_ProfileService.PBS_ProfileWithoutSharing serviceObj = new PBS_ProfileService.PBS_ProfileWithoutSharing();

        Test.startTest();

        System.runAs(u) {
            // change work lave but not save object in order to avoid trigger
            t1.Work_Level__c = p1.Work_Level__c;

            // make sure there are no sharing for our user
            List<Almond__Training_Track__Share> tts = serviceObj.getExistingSharingForTrainingTrack(t1);
            System.assertEquals(true, tts.isEmpty(), NOT_SHARE);

            // add sharing
            tts.addAll(serviceObj.getNewSharingForTrainingTrack(t1));
            serviceObj.updateSharing(tts, null);

            // check if added
            tts = serviceObj.getExistingSharingForTrainingTrack(t1);
            System.assertEquals(false, tts.isEmpty(), SHARE);

            // remove sharing
            serviceObj.updateSharing(null, tts);
            tts = serviceObj.getExistingSharingForTrainingTrack(t1);
            System.assertEquals(true, tts.isEmpty(), NOT_SHARE);
        }

        Test.stopTest();
    }

    @isTest
    static void updateSharingFromTrackTrigger()
    {
        User u = new User(
            email             = 'test@test.test.test',
            emailencodingkey  = 'UTF-8',
            lastname          = TESTS,
            FirstName         = TESTS,
            alias             = 'TA',
            languagelocalekey = EN_US,
            localesidkey      = EN_US,
            profileid         = [SELECT id FROM Profile WHERE name = 'Standard User'].id,
            timezonesidkey    = 'GMT',
            username          =  String.valueOf(DateTime.Now()).replace(' ', '').replace(':','') + 'test@test.com'
        );
        insert u;

        PBS_Standard_Job_Profile__c sjp = PBS_TestHelper.createJobProfile(GUEST);

        PBS_Profile__c p1 = new PBS_Profile__c(
            Work_Level__c = LEVEL1,
            Geography__c  = EUROPE,
            user_role__c  = sjp.Id,
            user__c       = u.Id
        );
        insert p1;

        Almond__Training_Track__c t1 = new Almond__Training_Track__c(
            Name                        = 'Test Name',
            Work_Level__c               = p1.Work_Level__c,
            Geography__c                = p1.Geography__c,
            PBS_Standard_Job_Profile__c = p1.user_role__c
        );

        Test.startTest();

        PBS_ProfileService.PBS_ProfileWithoutSharing serviceObj = new PBS_ProfileService.PBS_ProfileWithoutSharing();

        List<Almond__Training_Track__Share> tts = serviceObj.getExistingSharingForTrainingTrack(t1);
        System.assertEquals(true, tts.isEmpty(), 'There should be no sharing for this track');

        // create sharing - inserting as different user so the test user is not the owner
        insert t1;

        // make sure there are sharing for our user
        tts = serviceObj.getExistingSharingForTrainingTrack(t1);
        System.assertEquals(false, tts.isEmpty(), 'There should be sharing for this track');

        t1.Work_Level__c = 'Invalid Level';
        update t1;

        // should be no sharing due to level change
        tts = serviceObj.getExistingSharingForTrainingTrack(t1);
        System.assertEquals(true, tts.isEmpty(), 'There should be no sharing for this track');

        // restore sharing
        t1.Work_Level__c = p1.Work_Level__c;
        update t1;

        // make sure there are sharing for our user
        tts = serviceObj.getExistingSharingForTrainingTrack(t1);
        System.assertEquals(false, tts.isEmpty(), 'There should be sharing for this track');

        // remove profile and therefore remove sharing
        delete t1;

        // should be no sharing due to level change
        tts = serviceObj.getExistingSharingForTrainingTrack(t1);
        System.assertEquals(true, tts.isEmpty(), 'There should be no sharing for this track');

        undelete t1;

        // make sure there are sharing for our user
        tts = serviceObj.getExistingSharingForTrainingTrack(t1);
        System.assertEquals(false, tts.isEmpty(), 'There should be sharing for this track');

        Test.stopTest();
    }

    @isTest
    static void crippledTrainingTrackShare()
    {
        Test.startTest();
        PBS_Standard_Job_Profile__c sjp = PBS_TestHelper.createJobProfile(GUEST);
        Almond__Training_Track__c t1            = PBS_TestHelper.createTrainingTrack(TESTS, LEVEL1, EUROPE, sjp.Id);

        try {
            PBS_ProfileService.PBS_ProfileWithoutSharing serviceObj = new PBS_ProfileService.PBS_ProfileWithoutSharing();
            // add sharing
            List<Almond__Training_Track__Share> tts = new List<Almond__Training_Track__Share>{
                new Almond__Training_Track__Share(
                    ParentId      = t1.Id,
                    AccessLevel   = 'Read',
                    UserOrGroupId = null /* should cause exception */
                )
            };
            serviceObj.updateSharing(tts, null);
            System.assert(false, 'Exception expected but not thrown');
        } catch (Exception e) {
            System.assert(true, 'Exception expected but not caught');
        }

        Test.stopTest();
    }
}