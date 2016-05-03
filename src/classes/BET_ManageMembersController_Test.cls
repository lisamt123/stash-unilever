@isTest
private class BET_ManageMembersController_Test {

  private static final String ONE_MEMBER_MESSAGE = 'There should be only one member';
  private static final String ONE_MEMBER_REQUEST_MESSAGE = 'There should be only one member request';
  private static final String NO_MEMBER_REQUEST_MESSAGE = 'There should be no member requests';
  private static final String TWO_MEMBERS_MESSAGE = 'There should be two members';

  private static final String NEW_STATUS = 'New';
  private static final String APROVED_STATUS = 'Approved';
  private static final String REJECTED_STATUS = 'Rejected';

  private static final String BET_PARAM = 'bet';
      
  @isTest private static void constructorTest(){

    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;

    BET_Member_Request__c memberrequest = new BET_Member_Request__c(Brand_Experience_Toolkit__c=testBET.id, Status__c = NEW_STATUS);
    insert memberrequest;

    uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(BET__c = testBET.id,Team_Member__c = UserInfo.getUserId());
    insert member;

    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    Test.startTest();
    System.assertEquals(controller.memberRequests.size(),1,ONE_MEMBER_REQUEST_MESSAGE);
    System.assertEquals(controller.getMembers().size(),2,TWO_MEMBERS_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void addMemberandTest(){

    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;

    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<User> users = BET_TestUtils.createUserSystemAdmin(1);

    List<BET_Member_Request__c> rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__C =: APROVED_STATUS];

    Test.startTest();
    System.assert(rmembers.isEmpty(),NO_MEMBER_REQUEST_MESSAGE);

    controller.betMemberRequest.UserID__c=users.get(0).id;
    controller.betMemberRequest.Role__c = 'Member';
    controller.addMember();

    rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__C =: APROVED_STATUS];
    System.assertEquals(rmembers.size(),1,ONE_MEMBER_REQUEST_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void addExternalMemberTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;

    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<BET_Member_Request__c> rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__C =: APROVED_STATUS];
    Test.startTest();
    System.assert(rmembers.isEmpty(),NO_MEMBER_REQUEST_MESSAGE);

    controller.betMemberRequest.External_User_Email__c = 'm.bluj@polsource.com';
    controller.addExternalMember();

    rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id];
    System.assertEquals(rmembers.size(),1,ONE_MEMBER_REQUEST_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void addExternalMemberUnileverTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;

    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<BET_Member_Request__c> rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__C =: APROVED_STATUS];
    Test.startTest();
    System.assert(rmembers.isEmpty(),NO_MEMBER_REQUEST_MESSAGE);

    controller.betMemberRequest.External_User_Email__c = 'm.bluj@unilever.com';
    controller.addExternalMember();

    rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id];
    System.assertEquals(rmembers.size(),0,NO_MEMBER_REQUEST_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void doApproveTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;
    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<BET_Member_Request__c> rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__C =: APROVED_STATUS];

    Test.startTest();
    System.assert(rmembers.isEmpty(),NO_MEMBER_REQUEST_MESSAGE);

    BET_Member_Request__c memberrequest = new BET_Member_Request__c(Brand_Experience_Toolkit__c=testBET.id, Status__c = NEW_STATUS);
    insert memberrequest;
    controller.selectedRequestId = memberrequest.id;
    controller.doApprove();

    rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__c =: APROVED_STATUS];
    System.assertEquals(rmembers.size(),1,ONE_MEMBER_REQUEST_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void doDenyTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;
    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<BET_Member_Request__c> rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__C =: REJECTED_STATUS];

    Test.startTest();
    System.assert(rmembers.isEmpty(),NO_MEMBER_REQUEST_MESSAGE);

    BET_Member_Request__c memberrequest = new BET_Member_Request__c(Brand_Experience_Toolkit__c=testBET.id, Status__c = NEW_STATUS);
    insert memberrequest;
    controller.selectedRequestId = memberrequest.id;
    controller.doDeny();

    rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__c =: REJECTED_STATUS];
    System.assertEquals(rmembers.size(),1,ONE_MEMBER_REQUEST_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void doMassDenyTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;
    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<BET_Member_Request__c> rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__C =: REJECTED_STATUS];
    Test.startTest();
    System.assert(rmembers.isEmpty(),NO_MEMBER_REQUEST_MESSAGE);

    BET_Member_Request__c memberrequest = new BET_Member_Request__c(Brand_Experience_Toolkit__c=testBET.id, Status__c = NEW_STATUS);
    insert memberrequest;

    controller.selectedRequestId = memberrequest.id;
    BET_ManageMembersController.MemberRequestWrapper wrap = new BET_ManageMembersController.MemberRequestWrapper();
    wrap.obj = memberrequest;
    wrap.isSelected = true;
    controller.memberRequests = new List<BET_ManageMembersController.MemberRequestWrapper>{wrap};
    controller.massDeny();

    rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__c =: REJECTED_STATUS];
    System.assertEquals(rmembers.size(),1,ONE_MEMBER_REQUEST_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void doMassApproveTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;
    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<BET_Member_Request__c> rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__c =: APROVED_STATUS];
    Test.startTest();
    System.assert(rmembers.isEmpty(),NO_MEMBER_REQUEST_MESSAGE);

    BET_Member_Request__c memberrequest = new BET_Member_Request__c(Brand_Experience_Toolkit__c=testBET.id, Status__c = NEW_STATUS);
    insert memberrequest;

    controller.selectedRequestId = memberrequest.id;
    BET_ManageMembersController.MemberRequestWrapper wrap = new BET_ManageMembersController.MemberRequestWrapper();
    wrap.obj = memberrequest;
    wrap.isSelected = true;
    controller.memberRequests = new List<BET_ManageMembersController.MemberRequestWrapper>{wrap};
    controller.massApprove();

    rmembers = [select id from BET_Member_Request__c where Brand_Experience_Toolkit__c=:testBET.id and Status__c =: APROVED_STATUS];
    System.assertEquals(rmembers.size(),1,ONE_MEMBER_REQUEST_MESSAGE);
    Test.stopTest();

  }

  @isTest private static void massDeleteTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;
    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<uw_BET_Team_Member__c> members = [select id from uw_BET_Team_Member__c where BET__C=:testBET.id];
    System.assertEquals(members.size(),1,ONE_MEMBER_MESSAGE);

    List<User> users = BET_TestUtils.createUserSystemAdmin(1);

    uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(BET__C=testBET.id,Team_Member__c=users.get(0).id);
    insert member;

    members = [select id from uw_BET_Team_Member__c where BET__C=:testBET.id];
    Test.startTest();
    System.assertEquals(members.size(),2,TWO_MEMBERS_MESSAGE);

    controller.selectedMemberId = member.id;
    BET_ManageMembersController.MemberWrapper wrap = new BET_ManageMembersController.MemberWrapper();
    wrap.obj = member;
    wrap.isSelected = true;
    controller.members = new List<BET_ManageMembersController.MemberWrapper>{wrap};
    controller.massDelete();

    members = [select id from uw_BET_Team_Member__c where BET__C=:testBET.id];
    System.assertEquals(members.size(),1,ONE_MEMBER_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void doDeleteTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;
    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);

    List<uw_BET_Team_Member__c> members = [select id from uw_BET_Team_Member__c where BET__C=:testBET.id];
    Test.startTest();
    System.assertEquals(members.size(),1,ONE_MEMBER_MESSAGE);

    List<User> users = BET_TestUtils.createUserSystemAdmin(1);

    uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(BET__C=testBET.id,Team_Member__c=users.get(0).id);
    insert member;

    members = [select id from uw_BET_Team_Member__c where BET__C=:testBET.id];
    System.assertEquals(members.size(),2,TWO_MEMBERS_MESSAGE);

    controller.selectedMemberId = member.id;
    controller.doDelete();

    members = [select id from uw_BET_Team_Member__c where BET__C=:testBET.id];
    System.assertEquals(members.size(),1,ONE_MEMBER_MESSAGE);
    Test.stopTest();
  }

  @isTest private static void getRolesTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;
    PageReference pageRef = Page.BET_ManageMembers;  
    Test.setCurrentPage(pageRef);
    ApexPages.currentPage().getParameters().put(BET_PARAM,testBET.Id);
    ApexPages.StandardController ctr = new ApexPages.StandardController(new BET_Member_Request__c());
    BET_ManageMembersController controller = new BET_ManageMembersController(ctr);
    Test.startTest();
    System.assert(!controller.getMemberRequestRoles().isEmpty(),'Member request roles should not be empty');
    System.assert(!controller.getMemberRoles().isEmpty(),'Member roles should not be empty');
    Test.stopTest();
  }

  @isTest private static void updateMemberRoleTest(){
    uw_Bet__c testBET = BET_TestUtils.getTestBet();
    insert testBET;
    List<User> users = BET_TestUtils.createUserSystemAdmin(1);
    uw_BET_Team_Member__c member = new uw_BET_Team_Member__c(BET__C=testBET.id,Team_Member__c=users.get(0).id,Role__c = 'Member');
    insert member;
    BET_ManageMembersController.updateMemberRole(String.valueOf(member.id),'Manager');
    member = [select Role__c from uw_BET_Team_Member__c where id=:member.id];
    Test.startTest();
    System.assertEquals(member.Role__c,'Manager','Member should have Manager role');
    Test.stopTest();
  }

}