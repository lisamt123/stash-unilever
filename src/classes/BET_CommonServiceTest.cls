/**********************************************************************
Name: BET_CommonServiceTest 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: test for BET_CommonService
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
**********************************************************************/

@isTest
private class BET_CommonServiceTest {
    //hasAccess: admin access in custom settings
    static testMethod void testMethodOne(){
        User adminUser = BET_TestingHelper.createAdminUser('test', 'test@test.com', 'test');

        System.runAs(adminUser){
            System.assertEquals(true, BET_CommonService.hasAccess(true));
            System.assertEquals(true, BET_CommonService.hasAccess(false));
        }
    }

    //canModify: admin access in custom settings
    static testMethod void testMethodTwo(){
        User adminUser = BET_TestingHelper.createAdminUser('test', 'test@test.com', 'test');

        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET1' + system.now(), true);

        System.runAs(adminUser){
            System.assertEquals(true, BET_CommonService.canModify(wrap.BET.Id));
        }
    }

    //canModify: manager
    static testMethod void testMethodThree(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET2' + system.now(), true);
        wrap.addManager();

        System.runAs(wrap.manager){
            System.assertEquals(true, BET_CommonService.canModify(wrap.BET.Id));
        }
    }

    //canModify: owner
    static testMethod void testMethodFour(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET3' + system.now(), true);

        System.runAs(wrap.owner){
            System.assertEquals(true, BET_CommonService.canModify(wrap.BET.Id));
        }
    }

    static testMethod void testMethodFive(){
        BET_Request_Access__c setting = new BET_Request_Access__c(Name = 'Test', From_Name__c='test@test.com', Send_Mail_To_Owner__c = true, Email_Address__c='test@test.com', Logo_Url__c='http://test.com/img.jpg');
        insert setting;

        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET4' + system.now(), true);

        User usr = BET_TestingHelper.getDefaultNotMember();

        System.runAs(usr){
            BET_CommonService.sendApprovalMailToOwner(wrap.BET, usr.Id, setting);
            System.assertEquals(true, BET_CommonService.requestBETAccess(usr.Id, wrap.BET.Id, 'email@test.com'));
            System.assertEquals(false, BET_CommonService.requestBETAccess(usr.Id, wrap.BET.Id, 'email@test.com'));
        }
    }

    static testMethod void testMethodSix(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET5' + system.now(), true);
        wrap.addMember();

        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c, BET__c, BET__r.Studio_Chatter_Group__c, Team_Member__c FROM uw_BET_Team_Member__c];
        System.assertEquals(2, teamMemberList.size());

        System.runAs(wrap.owner){
            BET_CommonService.deleteBetTeamMember(wrap.member.Id, wrap.BET.Id);
            teamMemberList = [SELECT Id, Name, Role__c, BET__c, BET__r.Studio_Chatter_Group__c, Team_Member__c FROM uw_BET_Team_Member__c];
            System.assertEquals(1, teamMemberList.size());
        }
    }

    static testMethod void testMethodSixAndHalf(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET5' + system.now(), true);
        wrap.addMember();

        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c, BET__c, BET__r.Studio_Chatter_Group__c, Team_Member__c FROM uw_BET_Team_Member__c WHERE Role__c = 'Member'];
        System.assertEquals(1, teamMemberList.size());
        //enforce exception
        teamMemberList[0].Role__c = 'Exception';
        update teamMemberList;

        System.runAs(wrap.owner){
            try {
                BET_CommonService.deleteBetTeamMember(wrap.member.Id, wrap.BET.Id);
                System.assert(false, 'Should throw exception');
            } catch (Exception e) {
                System.assert(true);
            }
        }
    }

    static testMethod void testMethodSeven(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET6' + system.now(), true);

        System.runAs(wrap.owner){
            wrap.BET.Name = 'RenamedBet';
            BET_CommonService.updateBET(wrap.BET);
            List<uw_BET__c> betList = [SELECT Name FROM uw_BET__c WHERE id =: wrap.BET.Id];
            System.assertEquals('RenamedBet', betList.get(0).Name);
        }
    }

    //canModify: owner
    static testMethod void testMethodEight(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET3', true);
        User usr = BET_TestingHelper.getDefaultNotMember();

        wrap.BET.OwnerId = usr.Id;
        update wrap.BET;

        System.runAs(usr){
            System.assertEquals(true, BET_CommonService.canModify(wrap.BET.Id));
        }
    }

    
    static testMethod void testMethodNine(){
        
        uw_BET__c bet = BET_TestUtils.getTestBet();
        bet.Sharing__c = 'Public';
        insert bet;

        BET_CommonService.checkAccessForPublicBET(bet.Id, UserInfo.getUserId());

        System.assertEquals(1, [SELECT count() FROM BET_Member_Request__c WHERE Brand_Experience_Toolkit__c =: bet.Id AND UserId__c =: UserInfo.getUserId()]);
        System.assertEquals(1, [SELECT count() FROM uw_BET_Team_Member__c WHERE BET__c =: bet.Id AND Team_Member__c =: UserInfo.getUserId()]);
        System.assertEquals(1, [SELECT count() FROM uw_BET__Share WHERE UserOrGroupId =: UserInfo.getUserId() AND ParentId =: bet.id]);
        
    }

    //cover catch
    static testMethod void testMethodTen(){
        BET_Request_Access__c setting = new BET_Request_Access__c(Name = 'Test', Send_Mail_To_Owner__c = true, Email_Address__c='test@test.com', Logo_Url__c='http://test.com/img.jpg');
        insert setting;

        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET4' + system.now(), true);

        User usr = BET_TestingHelper.getDefaultNotMember();

        try{
            BET_CommonService.requestBETAccess(wrap.BET.Id, wrap.BET.Id, 'email@test.com');
            System.assert(false);
        }catch(Exception e){
            System.debug('Exception ' + e);
            System.assert(true);
        }
    }

    //cover catch
    static testMethod void testMethodEleven(){
        BET_Request_Access__c setting = new BET_Request_Access__c(Name = 'Test', Send_Mail_To_Owner__c = true, Email_Address__c='test@test.com', Logo_Url__c='http://test.com/img.jpg');
        insert setting;

        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET4' + system.now(), true);
        delete wrap.BET;

        User usr = BET_TestingHelper.getDefaultNotMember();
        try{
            BET_CommonService.requestBETAccess(usr.Id, wrap.BET.Id, 'email@test.com');
            System.assert(false);
        }catch(Exception e){
            System.debug('Exception ' + e);
            System.assert(true);
        }
    }
    //cover catch
    static testMethod void testMethodTwelve(){
        BET_TestingHelper.BET_TestingData wrap = BET_TestingHelper.initBET('Test BET5' + system.now(), true);
        wrap.addMember();

        List<uw_BET_Team_Member__c> teamMemberList = [SELECT Id, Name, Role__c, BET__c, BET__r.Studio_Chatter_Group__c, Team_Member__c FROM uw_BET_Team_Member__c];
        System.assertEquals(2, teamMemberList.size());
        delete teamMemberList;

        try{
            BET_CommonService.deleteBetTeamMember(wrap.member.Id, wrap.BET.Id);
            System.assert(false);
        }catch(Exception e){
            System.debug('Exception ' + e);
            System.assert(true);
        }
    }
}