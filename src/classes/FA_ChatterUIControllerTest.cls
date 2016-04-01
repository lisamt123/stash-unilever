/**
Copyright (c) 2011, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

 *The SEEALL DATA is set to TRUE as the test method requires access to Custom Settings.
*/
@isTest(SeeAllData=true)
public with sharing class FA_ChatterUIControllerTest {

   /** Start of the code to test the ChatterUIController method -RemoveUserFromGroup
    * The following method inserts a Public Chatter Group TestFourAcresSearchGroup
    * and calls searchGroupsByName to search 
    * for the group named TestFourAcresSearchGroup 
    */
    static testMethod void testSearchGroupsByName() {
        CollaborationGroup matchingGroup = new CollaborationGroup(CollaborationType='Public',Name='TestFourAcresSearchGroup');
        insert matchingGroup;

        Test.startTest();

            ChatterUIGroupService.GroupPage groupPage = ChatterUIController.searchGroupsByName('TestFourAcresSearchGroup');

        Test.stopTest();

        System.assertEquals(1, groupPage.totalGroupCount, 'The matching groups should be returned in the JSON object');
        System.assertEquals(matchingGroup.Id, groupPage.groups[0].Id, 'The matching groups should be returned in the JSON String');
    }

   /** Start of the code to test the ChatterUIController method -createGroup
    * The following method inserts a Chatter Group
    * and checks whether the group exists.
    */
    static testMethod void testCreatePublicGroupSucess()
    {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';

        Test.startTest();
            String groupResponse = ChatterUIController.createGroup(expectedName, expectedDescription, UserInfo.getUserId(), true);
        Test.stopTest();

        CollaborationGroupMember createdMember = [SELECT Id
                                                    FROM CollaborationGroupMember
                                                    WHERE MemberId = :UserInfo.getUserId()
                                                    AND CollaborationGroup.Name = :expectedName];

        System.assert(groupResponse.indexOf(expectedName) > -1, 'The created group should be returned in the JSON String');
        System.assert(groupResponse.indexOf(expectedDescription) > -1, 'The created group should be returned in the JSON String');
    }

   /** Start of the code to test the ChatterUIController method -approveGroupMemberRequest
    * The following method inserts a Private Chatter Group and creates a Group request 
    * and checks whether the request id accepted.
    */
    static testMethod void testApproveGroupMemberRequest()
    {
        CollaborationGroup newGroup = createPrivateGroup();

        User requestingUser = UserTestUtil.getTestStandardUser();
        CollaborationGroupMemberRequest groupRequest;

        System.runAs(requestingUser)
        {
            groupRequest = new CollaborationGroupMemberRequest();
            groupRequest.CollaborationGroupId = newGroup.Id;
            groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
          }

        Test.startTest();
            String response = ChatterUIController.approveGroupMemberRequest(groupRequest.Id);
        Test.stopTest();

        System.assert(response.indexOf(ChatterUIGroupService.REQUEST_STATUS_ACCEPTED) > -1, 'The approved status should be returned in the response String');
    }

   /** Start of the code to test the ChatterUIController method -denyGroupMemberRequest
    * The following method inserts a Private Chatter Group and creates a Group request 
    * and checks whether the request id denied.
    */
    static testMethod void testDenyGroupMemberRequest()
    {
        CollaborationGroup newGroup = createPrivateGroup();

        User requestingUser = UserTestUtil.getTestStandardUser();
        CollaborationGroupMemberRequest groupRequest;

        System.runAs(requestingUser) {
            groupRequest = new CollaborationGroupMemberRequest();
            groupRequest.CollaborationGroupId = newGroup.Id;
            groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
        }

        Test.startTest();
            String response = ChatterUIController.denyGroupMemberRequest(groupRequest.Id);
        Test.stopTest();

        System.assert(response.indexOf(ChatterUIGroupService.REQUEST_STATUS_DECLINED) > -1, 'The Declined status should be returned in the response String');
    }

   /** Start of the code to test the ChatterUIController method -createGroup
    * The following method inserts a Chatter Group with an existing Name 
    * and checks whether an error message is thrown.
    */
    static testMethod void testCreatePublicGroupFailure()
    {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        //create group with same name to force error
        ChatterUIController.createGroup(expectedName, expectedDescription, UserInfo.getUserId(), true);

        Test.startTest();
            String groupResponse = ChatterUIController.createGroup(expectedName, expectedDescription, UserInfo.getUserId(), true);
        Test.stopTest();

        Map<String, String> parsedResponse = (Map<String, String>)JSON.deserialize(groupResponse, Map<String, String>.class);
        System.assertEquals('error', parsedResponse.get('status'), 'An error response should be returned.');
    }

   /** Start of the code to test the ChatterUIController method -denyGroupMemberRequest
    * The following method inserts a Private Chatter Group and creates a Group request 
    * and checks whether the request id denied.
    */
    static testMethod void testRequestToJoinPrivateGroup()
    {
        CollaborationGroup newGroup = createPrivateGroup();

        User requestingUser = UserTestUtil.getTestStandardUser();

        Test.startTest();
            String response;
            System.runAs(requestingUser)
            {
                response = ChatterUIController.requestToJoinPrivateGroup(newGroup.Id);
            }
        Test.stopTest();

        System.assert(response.indexOf(newGroup.Id) > -1, 'The group that is being requested  to join should be returned in the response String');
        System.assert(response.indexOf(requestingUser.Id) > -1, 'The requesting user Id should be returned in the response String');
    }

   /** Start of the code to test the ChatterUIController method -requestToJoinPrivateGroup
    * The following method inserts a PUBLIC Chatter Group and creates a Group request 
    * and checks whether the request id denied, as it is a Public group.
    */
    static testMethod void testRequestToJoinPrivateGroupFailure() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A public chatter group');
        newGroup.CollaborationType = 'public';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();

        Test.startTest();

            String response;
            System.runAs(requestingUser) {
                response = ChatterUIController.requestToJoinPrivateGroup(newGroup.Id);
            }

        Test.stopTest();

        Map<String, String> parsedResponse = (Map<String, String>)JSON.deserialize(response, Map<String, String>.class);
        System.assertEquals('error', parsedResponse.get('status'), 'An error response should be returned when trying to rquest to joina public group.');
    }

   /** Start of the code to test the ChatterUIController method -getPendingGroupRequests
    * The following method inserts a Private Chatter Group and creates a Group request 
    * and checks whether the request is present as Pending Request.
    */
    static testMethod void testGetPendingGroupRequests()
    {
        CollaborationGroup newGroup = createPrivateGroup();
        User requestingUser = UserTestUtil.getTestStandardUser();
        CollaborationGroupMemberRequest groupRequest = new CollaborationGroupMemberRequest();

        System.runAs(requestingUser)
        {
            groupRequest.CollaborationGroupId = newGroup.Id;
            groupRequest.RequesterId = requestingUser.Id;

            insert groupRequest;
        }

        Test.startTest();
            List<ChatterUIGroupService.GroupRequest> pendingRequests = ChatterUIController.getPendingGroupRequests(newGroup.Id);
        Test.stopTest();

        System.assertEquals(1, pendingRequests.size(), '1 request should have been returned.');
        System.assertEquals(requestingUser.Id, pendingRequests[0].requester.Id, 'The requesting user should be set tot the user making the request');
        System.assertEquals(groupRequest.Id, pendingRequests[0].requestId, 'The group request Id should be set.');
    }

   /** Start of the code to test the ChatterUIController method -editGroup
    * The following method inserts a Chatter Group and edits the  created group
    * and checks whether the the group details have been edited.
    */
    static testMethod void testEditGroup() {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();

        CollaborationGroup newGroup = new CollaborationGroup(Name='A chatter group');
        newGroup.OwnerId = expectedOwner;
        newGroup.CollaborationType = 'Public';
        insert newGroup;

        Test.startTest();
            String groupResponse = ChatterUIController.editGroup(newGroup.Id, expectedName, expectedDescription, false);
        Test.stopTest();

        System.assertNotEquals(-1, groupResponse.indexOf(expectedDescription), 'The description should be updated.');
        System.assertNotEquals(-1, groupResponse.indexOf(expectedName), 'The name should be updated.');
        System.assertNotEquals(-1, groupResponse.indexOf('Private'), 'The visibility of the group should be updatd.');
    }

   /** Start of the code to test the ChatterUIController method -updateUserInfo
    * The following method updates the user details
    * and checks whether the details have been modified.
    */
    static testMethod void testUpdateUser() {
         Map<String, String> fieldsToUpdate = new Map<String, String> {
            'Phone' => '111-111-1111',
            'Title' => 'new title',
            'AboutMe' => 'new about me',
            'CompanyName' => 'myCompany',
            'MobilePhone' => '1234567890'
          };

         try {
            String updateStatus = ChatterUIController.updateUserInfo(JSON.serialize(fieldsToUpdate));
            Map<String, String> updateStatusMap = (Map<String, String>)JSON.deserialize(updateStatus, Map<String, String>.class);

            System.assert(updateStatusMap.get('status') == 'success');
            System.assert(updateStatusMap.get('statusDesc') == '');

         } catch (Exception e) {
            // catch errors in case the user running the test doesn't have Update permissions on User
            System.debug('error updating user in testUpdateUser: '+e.getMessage());
         }
    }

   /**
    * This is a helper method to create a Private Group
    */
    static CollaborationGroup createPrivateGroup() {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A private chatter group');
        newGroup.CollaborationType = 'private';
        insert newGroup;
        return newGroup;
    }
    /**
    ORIGINAL TEST CLASS ENDS HERE
    */
    
   /** Start of the code to test the ChatterUIController method -getAllFourAcreGroupID
    * The following method checks the value returned by the function for custom settings.
    */
    static testMethod void testgetAllFourAcreGroupID()
    {
        ChatterUIController controller = new ChatterUIController();
        Id CustomSettingIds=controller.getAllFourAcreGroupID();
        String groupName = [SELECT Name FROM CollaborationGroup WHERE id =: CustomSettingIds].name;
        System.assertEquals('All Four Acres',groupName);
    }

   /** Start of the code to test the ChatterUIController method -uploadAttachment
    * The following method uploads an attachment, and checks if the attachment exists. 
    */
    static testMethod void testUploadAttachment()
    {
          ChatterUIController controller = new ChatterUIController();
          String base64BlobValue = EncodingUtil.base64Encode(Blob.valueOf('test string'));
          Map<String, String> resultsMap = ChatterUIController.uploadAttachment(base64BlobValue);
          System.assertNotEquals(null, resultsMap.get(ChatterUIFileUpload.PARAM_UPLOAD_STATUS));
     }

   /** Start of the code to test the ChatterUIController method -searchUsersByName
    * The following method searches if the current user exists, by searching with UserName as key.
    */
     static testMethod void testSearchUsersByName()
    {
        List<User> users = ChatterUIController.searchUsersByName(UserInfo.getName());
        System.assert(!users.isEmpty());
    }

   /**
    * Start of the code to test the ChatterUIController method -getFeedObjectPrefix and getUserObjectPrefix
    * The following method checks for the value returned by these methods.
    */
    static testMethod void testGetObjectPrefix()
    {
        ChatterUIController controller = new ChatterUIController();
        String temp1=controller.getFeedObjectPrefix();
        String temp2=controller.getUserObjectPrefix();
        String temp3=Schema.SObjectType.Account.getKeyPrefix();
        String temp4=Schema.SObjectType.User.getKeyPrefix();
        System.assertEquals(Schema.SObjectType.Account.getKeyPrefix(), controller.getFeedObjectPrefix());
        System.assertEquals(Schema.SObjectType.User.getKeyPrefix(), controller.getUserObjectPrefix());
    }

   /**
    * Start of the code to test the ChatterUIController method -getGroupsForUser
    * The following method creates a chatter group and a user for the group.
    * Then checks if the Group is associated with the user.
    */
    static testMethod void testGetGroupsForUser()
    {
        String expectedName = '1st Chatter group';
        String expectedDescription = 'A test chatter group';
        String expectedOwner = UserInfo.getUserId();

        Test.startTest();
            string returnedGroup = ChatterUIController.createGroup(expectedName, expectedDescription, expectedOwner, true);
            ChatterUIGroupService.GroupPage groupPage = ChatterUIController.getGroupsForUser(expectedOwner);
        Test.stopTest();

        System.assertNotEquals(null, groupPage);
        System.assertEquals(groupPage.groups.size(), groupPage.totalGroupCount);
        System.assert(groupPage.mappedGroups.size() > 0);

    }

   /**
    * Start of the code to test the ChatterUIController method -init
    * The following method for checks for the values of Custom Setting NAVIGATION ELEMENT
    * after invocation of init method.
    */
    static testMethod void testInit()
    {
        ChatterUIController controller = new ChatterUIController();
        PageReference tempPage=controller.init();
        if (!NavigationElement__c.getAll().isEmpty())
            System.assertEquals(null, tempPage);
        else
            System.assertEquals('/apex/ChatterConfig', tempPage.getUrl());
    }
    
   /** Start of the code to test the ChatterUIController method -RemoveUserFromGroup
    * The following method inserts a Course Chatter Group and calls removeUserFromGroup to check 
    * whether the User has been removed from the chatter group 
    */
    static testMethod void testremoveUserFromGroup()
    {
        CollaborationGroup newGroup = new CollaborationGroup(Name='A public chatter group');
        newGroup.CollaborationType = 'public';
        insert newGroup;

        User requestingUser = UserTestUtil.getTestStandardUser();

        CollaborationGroupMember groupMember = new CollaborationGroupMember();
        System.runAs(requestingUser) {
            groupMember.CollaborationGroupId = newGroup.Id;
            groupMember.MemberId = requestingUser.Id;

            insert groupMember;
        }
        Test.startTest();
            ChatterUIController.removeUserFromGroup(newGroup.Id, requestingUser.Id);
        Test.stopTest();

        List<CollaborationGroupMember> groupMembers = [SELECT Id FROM CollaborationGroupMember WHERE Id = :groupMember.Id];
        System.assert(groupMembers.isEmpty(), 'The group member should have been deleted');

    }

    /**Start of Code for Centres Detail Visualforce page
    * The following testMethod tests the Controller
    * functionality for the Apex Page Centres_UF
    * the method tests whether the controller is returning 
    * the list of centres for display on the Apex Page
    */
    static testMethod void testgetCentres()
    {
        Boolean flag;
        PageReference pageRef = new PageReference ('/apex/Centres_UF');

        Test.setCurrentPage(pageRef);

        ChatterUIController controller = new ChatterUIController();
        FA_Training_Venue__c tObj =FA_createTestData.createTrainVenue('TestVenue'); 
        set<String> venueNames=new set<String>();
        List<FA_Training_Venue__c> testVenueList= controller.getCentres();

        for(FA_Training_Venue__c temp:testVenueList)
        {        
            venueNames.add(temp.Name);
        }

        if(venueNames.contains('TestVenue'))
        {   flag=true;  }
        else 
        {   flag=false; }

        System.assertEquals(true,flag);

    }

    /***************************************************
    *Start of test methods that require similar Test Data.
    ***************************************************/
    static FA_Training_Venue__c ObjTrVenue;
    static FA_Training_Room__c ObjTRoom;
    static FA_Course__c objCourse;
    static FA_Course_Occurence__c testCOcc;
    static Course_Attachment__c testCoAttPre;
    static Course_Attachment__c testCoAttPost;
    static Course_Attachment__c testCoAttCoMat;
    static User ObjUser;
    static FA_Occurence_Member__c testOcMem;
    static FA_Pre_Work_Task_Assignment__c newPWTA;
    static FA_Course_ChatterGroup__c testCoChGrp;
    
    static ID testHelpGrpId;
    
    static Boolean boolTestPrgrammeDetail;
    static Boolean boolTestUserRegisProgramme;
    static Boolean boolTestUserCompProgramme;
    static Boolean boolTestPreferences;
    static Boolean boolTestPreWorkTasksPage;
    static Boolean boolTestCalenderComp;
    static Boolean boolTestFeedback;

    /**
    *The main Test method which invokes other Test methods.
    */
    static testMethod void mainFATest()
    {
        FA_ChatterUIControllerTest cT = new FA_ChatterUIControllerTest();
        ChatterUIController controller = new ChatterUIController();
        testHelpGrpId=controller.getFourAcreHelpGroupID();
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser)
        {
            ObjTrVenue =FA_createTestData.createTrainVenue('Test Venue');
            ObjTRoom= FA_createTestData.createTrainRoom(ObjTrVenue.id);
            objCourse = FA_createTestData.createCourse('tPD11');
            testCOcc= FA_createTestData.createCoOcc(objCourse.id,ObjTRoom.id,ObjTrVenue.id);
            testCoAttPre= FA_createTestData.createCoAtt(objCourse.id,'Pre-Work');
            testCoAttPost= FA_createTestData.createCoAtt(objCourse.id,'Post-work');
            testCoAttCoMat= FA_createTestData.createCoAtt(objCourse.id,'Course-Material');
            ObjUser=FA_createTestData.createUser('tstURP');
            testOcMem =FA_createTestData.createOccMem(ObjUser.id,testCOcc.id);
            newPWTA= FA_createTestData.createPWTAssig(testCOcc.id);
            testCoChGrp = FA_createTestData.createCoChatGrp('testURPChatterGrp',testCOcc.id,String.valueOf(testHelpGrpId));

            /** UPSERT THE  Occurrence Member Instance with FA_Participant_Instructor__c as Current User Id.*/
            testOcMem.FA_Participant_Instructor__c=UserInfo.getUserId(); 
            upsert testOcMem;
            
            Test.startTest();
                cT.testPrgrammeDetail();
                cT.testUserRegisProgramme();
                cT.testUserCompProgramme();
                cT.testPreferences();
                cT.testPreWorkTasksPage();
                cT.testCalenderComp();
                cT.testFeedback();
            Test.stopTest();
        }

        System.assertEquals(true, boolTestPrgrammeDetail);
        //System.assertEquals(true, boolTestUserRegisProgramme);
        //System.assertEquals(true, boolTestUserCompProgramme);
        //System.assertEquals(true, boolTestPreferences);
        //System.assertEquals(true, boolTestPreWorkTasksPage);
        //System.assertEquals(true, boolTestCalenderComp);
        //System.assertEquals(true, boolTestFeedback);
    }

   /**
    Start of code for Programmes Visual Force Page
    The following testMethod tests the functionality of the controller 
    for the VF Page Programme which displays required Course detail Registered
    by the Participant.
    */
    void testPrgrammeDetail()
    {
        ChatterUIController controller = new ChatterUIController();
        Boolean boolCoPreAttachment;
        Boolean boolCoPostAttachment;
        Boolean boolCoMaterialAttachment;
            PageReference pageRef = new PageReference ('/apex/Programme');
            pageRef.getParameters().put('Id', testCOcc.Id);
            Test.setCurrentPage(pageRef);

            ChatterUIController.PrgrammeDetail wObjforProgramme=new ChatterUIController.PrgrammeDetail();
            PageReference testPage=controller.showCourseDetail();
            wObjforProgramme=controller.objProDetail;

            boolCoPreAttachment = wObjforProgramme.CoPreAttachment.isEmpty();
            boolCoPostAttachment = wObjforProgramme.CoPostAttachment.isEmpty();
            boolCoMaterialAttachment = wObjforProgramme.CoMaterialAttachment.isEmpty();

        /**
        *The Lists should not be empty as we inserted Pre-Work, Post-Work and Course Attachment Materials for the Course Occurrence.
        * Hence all the list 
        */
        If (!(boolCoPreAttachment || boolCoPostAttachment || boolCoPostAttachment))
            boolTestPrgrammeDetail = true;
        else
            boolTestPrgrammeDetail = false;
    }


    /** The following method tests whether the Courses Registered by the User are displayed in
     * the Upcoming Programme page on the Custom Chatter
     */
    void testUserRegisProgramme()
    {
        ChatterUIController controller = new ChatterUIController();

        Boolean boolCollgrpURL;
        Boolean boolCollgrpName;
        Boolean boolPrivateChatterGrpURL;
        Boolean boolPrivateChatterGrpName;
            PageReference pageRef = new PageReference ('/apex/Programme');
            pageRef.getParameters().put('Id', testOcMem.Id);
            Test.setCurrentPage(pageRef);

            ChatterUIController.ParticipantProgram wtestPartiProg=new ChatterUIController.ParticipantProgram();

            List<ChatterUIController.ParticipantProgram> wObjforPartiProg=new List<ChatterUIController.ParticipantProgram>();

            wObjforPartiProg=controller.getUserRegisProgramme();

            /**Fetch Private Chatter Group Details*/
            List<FA_Member_ChatterGroup__c> expectedPrivateGroup = new List<FA_Member_ChatterGroup__c>();

            expectedPrivateGroup = [SELECT  id,
                                            FA_Chatter_Group_Name__c,
                                            FA_Course_Occurence__c,
                                            FA_Group_ID__c,
                                            FA_Occurence_Member__c 
                                            FROM FA_Member_ChatterGroup__c 
                                            WHERE FA_Course_Occurence__c =: testCOcc.id
                                            AND FA_Occurence_Member__r.FA_Participant_Instructor__c =: UserInfo.getUserID()
                                            LIMIT 1];

            String expectedCollgrpURL = '/apex/Chatter#page=groups&group=' + String.valueOf(testHelpGrpId);
            String expectedGrpName = 'testURPChatterGrp';
            String expectedPrivateChatterGrpURL;
            String expectedPrivateGroupName;
            If(!(expectedPrivateGroup.isEmpty()))
            {
                expectedPrivateChatterGrpURL = '/apex/Chatter#page=groups&group=' + String.valueOf(expectedPrivateGroup[0].FA_Group_ID__c);
                expectedPrivateGroupName = String.valueOf(expectedPrivateGroup[0].FA_Chatter_Group_Name__c);
            }
            boolCollgrpURL = expectedCollgrpURL.equalsIgnoreCase(wObjforPartiProg[0].CollgrpURL);
            boolCollgrpName = expectedGrpName.equalsIgnoreCase(wObjforPartiProg[0].CollgrpName);
            boolPrivateChatterGrpURL = expectedPrivateChatterGrpURL.equalsIgnoreCase(wObjforPartiProg[0].PrivateChatterGrpURL);
            boolPrivateChatterGrpName = expectedPrivateGroupName.equalsIgnoreCase(wObjforPartiProg[0].PrivateChatterGrpName);

        /**The above Boolean values should be TRUE as the END DATE of COURSE OCCURRENCE is GREATER THAN TODAY.
        *We are checking for UPCOMING PROGRAMMES
        */
        if(boolCollgrpURL && boolCollgrpName && boolPrivateChatterGrpURL && boolPrivateChatterGrpName)
            boolTestUserRegisProgramme = true;
        else
            boolTestUserRegisProgramme = false;
    }

    /** The following method tests whether the Courses Registered by the User ,which are completed are displayed in
     * the Completed Programmes page on the Custom Chatter
     */
    void testUserCompProgramme()
    {
        ChatterUIController controller = new ChatterUIController();

        Boolean boolCollgrpURL = false;
        Boolean boolCollgrpName = false;
        Boolean boolPrivateChatterGrpURL = false;
        Boolean boolPrivateChatterGrpName = false;
            PageReference pageRef = new PageReference ('/apex/Programme');
            pageRef.getParameters().put('Id', testOcMem.Id);
            Test.setCurrentPage(pageRef);

            List<ChatterUIController.ParticipantProgram> wObjforCompletProg=new List<ChatterUIController.ParticipantProgram>();
            wObjforCompletProg=controller.getUserCompProgramme();

            /**Fetch Private Chatter Group Details*/
            List<FA_Member_ChatterGroup__c> expectedPrivateGroup = new List<FA_Member_ChatterGroup__c>();

            expectedPrivateGroup = [SELECT  id,
                                            FA_Chatter_Group_Name__c,
                                            FA_Course_Occurence__c,
                                            FA_Group_ID__c,
                                            FA_Occurence_Member__c 
                                            FROM FA_Member_ChatterGroup__c 
                                            WHERE FA_Course_Occurence__c =: testCOcc.id
                                            AND FA_Occurence_Member__r.FA_Participant_Instructor__c =: UserInfo.getUserID()
                                            LIMIT 1];

            String expectedCollgrpURL = '/apex/Chatter#page=groups&group=' + String.valueOf(testHelpGrpId);
            String expectedGrpName = 'testURPChatterGrp';
            String expectedPrivateChatterGrpURL;
            String expectedPrivateGroupName;
            If(!(expectedPrivateGroup.isEmpty()))
            {
                expectedPrivateChatterGrpURL = '/apex/Chatter#page=groups&group=' + String.valueOf(expectedPrivateGroup[0].FA_Group_ID__c);
                expectedPrivateGroupName = String.valueOf(expectedPrivateGroup[0].FA_Chatter_Group_Name__c);
            }
            if(!wObjforCompletProg.isEmpty())
            {
                boolCollgrpURL = expectedCollgrpURL.equalsIgnoreCase(wObjforCompletProg[0].CollgrpURL);
                boolCollgrpName = expectedGrpName.equalsIgnoreCase(wObjforCompletProg[0].CollgrpName);
                boolPrivateChatterGrpURL = expectedPrivateChatterGrpURL.equalsIgnoreCase(wObjforCompletProg[0].PrivateChatterGrpURL);
                boolPrivateChatterGrpName = expectedPrivateGroupName.equalsIgnoreCase(wObjforCompletProg[0].PrivateChatterGrpName);
            }
        /**The above Boolean values should be FALSE as the END DATE of COURSE OCCURRENCE is NOT LESS THAN TODAY.
        *We are checking for COMPLETED PROGRAMMES
        */
        if(!(boolCollgrpURL || boolCollgrpName || boolPrivateChatterGrpURL || boolPrivateChatterGrpName))
            boolTestUserCompProgramme = true;
        else
            boolTestUserCompProgramme = false;
    }


    /** Following class tests the functionality of the Preferences page on the Custom Chatter 
    */
    void testPreferences()
    {
        ChatterUIController controller = new ChatterUIController();

        Boolean boolGetCheckInItems;
        Boolean boolGetCheckOutItems;
        Boolean boolGetDietItems;
        Boolean boolGetCoursesForPref;

        Integer intGetHourTimeValues;
        Integer intGetMinuteTimeValues;

        Boolean boolBackPref;
        Boolean boolDetailsOk;
           List<SelectOption> testOptionsForCheckInItems = controller.getCheckInItems();
           List<SelectOption> testOptionsForCheckOutItems = controller.getCheckOutItems();
           List<SelectOption> testOptionsForDietItems = controller.getDietItems();
           List<SelectOption> testOptionsForCoursePref = controller.getCoursesForPref();
           List<SelectOption> testOptionsForHrTimeValues = controller.gethourTimeValues();
           List<SelectOption> testOptionsForMinuteTimeValues = controller.getminuteTimeValues();

           ChatterUIController.wrapPreferences wObjforPreferences=new ChatterUIController.wrapPreferences();

           PageReference pageRef = new PageReference ('/apex/Programme');
           pageRef.getParameters().put('Id', testOcMem.FA_Course_Occurence__c);
           Test.setCurrentPage(pageRef);

           PageReference testpageRef=controller.initPref(); 
           PageReference testpageRefUpdate=controller.updatePrefDetail();
           PageReference testpageRefForBack=controller.backPref();
           PageReference testpage=controller.initPref();
           PageReference testDetailsOk=controller.detailsOk();

           boolgetCheckInItems =testOptionsForCheckInItems.isEmpty();
           boolgetCheckOutItems = testOptionsForCheckOutItems.isEmpty();
           boolgetDietItems = testOptionsForDietItems.isEmpty();
           boolgetCoursesForPref = testOptionsForCoursePref.isEmpty();

           intGetHourTimeValues =testOptionsForHrTimeValues.size();
           intGetMinuteTimeValues = testOptionsForMinuteTimeValues.size();

           boolBackPref = testpageRefForBack.getURL().equalsIgnoreCase('/apex/Programme');
           boolDetailsOk =  testDetailsOk.getURL().equalsIgnoreCase('/apex/Programme');
        /**None of the lists should be empty. hence all boolean value should be FALSE.
        * boolBackPref & boolDetailsOk should be TRUE as they are for comparing strings.
        * intGetHourTimeValues should have 13 values for 13 different HOURS.
        * intGetMinuteTimeValues should have 12 values for 60/5 minutes in an hour.
        */
        if(
            !(boolgetCheckInItems || boolgetCheckOutItems || boolgetCoursesForPref || boolgetDietItems) &&
            (boolBackPref && boolDetailsOk) &&
            (intGetHourTimeValues == 13) &&
            (intGetMinuteTimeValues == 12)
            )
                boolTestPreferences = true;
        else
                boolTestPreferences = false;
    }

    /** 
    *This method tests the functionality of Pre-Work Task
    */
    void testPreWorkTasksPage()
    {
        ChatterUIController controller = new ChatterUIController();
        Boolean boolGetFetchPreWorkTasks;
        Boolean boolPreWorkTaskName;
            List<SelectOption> testOptionsForCheckInItems = controller.getCheckInItems();
            List<SelectOption> testOptionsForDietItems = controller.getDietItems();
            List<SelectOption> testOptionsForCoursePref = controller.getCoursesForPref();

            ChatterUIController.wrapPreTasks wObjforPreTasks=new ChatterUIController.wrapPreTasks();

            PageReference pageRef = new PageReference ('/apex/FA_PreWorkTasks');
            pageRef.getParameters().put('Id', testOcMem.Id);
            Test.setCurrentPage(pageRef);

            List<ChatterUIController.wrapPreTasks> testFetchPreWorkTasks=controller.getfetchPreWorkTasks();
            PageReference testSavingTasks=controller.saveTheTasks();

            boolGetFetchPreWorkTasks = testFetchPreWorkTasks.isEmpty();
            boolPreWorkTaskName = testFetchPreWorkTasks[0].preWorkTask.FA_Task_Name__c.equalsIgnoreCase('Test Task Name');

        /**The Pre-Work Task list should NOT be empty. Hence boolGetFetchPreWorkTasks should be FALSE.
        * The  Task names should match. Hence boolPreWorkTaskName should be TRUE.
        */
        if((!boolGetFetchPreWorkTasks) && boolPreWorkTaskName)
            boolTestPreWorkTasksPage= true;
        else
            boolTestPreWorkTasksPage= false;
    }

    /**
    *Start of code for Calender Visual Force Page
    *The following testMethod tests the Calender component which displays
    *all the Course schedules for the Courses registered by the Participant
    */
    void testCalenderComp()
    {
        Id objectType = 'a069000000Ivjaj';
        String startField = 'start_time__c';
        String endField   = 'end_time__c';
        String tempid;
            PageReference pageRefForCalender = new PageReference ('/apex/FA_Calendar');
            pageRefForCalender.getParameters().put('Id', testOcMem.Id);
            Test.setCurrentPage(pageRefForCalender);

            ChatterUIController.calendarEvent tempEvent=new ChatterUIController.calendarEvent();

            List<ChatterUIController.calendarEvent> wObjforCalender=new List<ChatterUIController.calendarEvent>();
            wObjforCalender=ChatterUIController.getEvents(objectType,startField,endField);   

            tempid=testOcMem.id;

            for(ChatterUIController.calendarEvent t:wObjforCalender)
            {       
                 if(t.id==tempid)
                        {boolTestCalenderComp=true;}
                 else
                        {boolTestCalenderComp=false;}
            }
    }

    /**
    *Start of the code for the Feedback Visual force Page 
    *The following TestMethod tests the Apex page feedback 
    *which captures the feedback from the user based on Programme 
    *selected User
    */
    void testFeedback()
    {
        ChatterUIController controller = new ChatterUIController();

                FA_Course_Occurence__c testOcc=[select Id,OwnerId,FA_Initiate_Feedback__c,FA_End_Date_Time__c from FA_Course_Occurence__c where   Id=:testOcMem.FA_Course_Occurence__c];

                testOcc.FA_End_Date_Time__c=system.today();

                testOcc.FA_Initiate_Feedback__c =true;
                upsert testOcc;

                PageReference pageRefForFeedback = new PageReference ('/apex/feedback');
                pageRefForFeedback.getParameters().put('Id', testOcc.Id);
                Test.setCurrentPage(pageRefForFeedback );

                ChatterUIController.QuestionWrapper ObjWrapForQuestion=new ChatterUIController.QuestionWrapper();

                List<SelectOption> testSelectOptions=controller.getItems();

                Pagereference testinitFeedPage=controller.initFeedback();

                controller.selectedOne=testOcMem.FA_Course_Occurence__c;
                controller.userid=UserInfo.getUserId();

                PageReference testSavePage=controller.Save();
                boolTestFeedback = testSavePage.getURL().equalsIgnoreCase('/apex/Feedback');
    }

    private static testMethod void testGetUsingMobile()
    {
        ChatterUIController controller = new ChatterUIController();

        PageReference testPage = new PageReference('/apex/test');
        testPage.getHeaders().put('User-Agent', 'Desktop');
        Test.setCurrentPage(testPage);
        System.assertEquals(false, controller.getUsingMobile());
    }
}