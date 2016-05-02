public without sharing class uw_futureHandler 
{
    @future
    public static void addChatterGroupMember(String userId, String groupId)
    {
    	// Need to add me at a Chatter Group Member
        CollaborationGroupMember cgm = new CollaborationGroupMember();
        cgm.CollaborationGroupId = groupId;
        cgm.MemberId = userId;
        // P - Post/ D - Daily  / W - Weekly / N - Neve
        // notification freq to have 'Never'
        cgm.NotificationFrequency = 'N';
        insert cgm;
    }
    
    public static TestMethod void testFutureHandler()
    {
    	CollaborationGroup cGroup = uw_UnitTestDataFactory.getTestChatterGroup();
    	
    	User testUser = uw_UnitTestDataFactory.initInternalUser('u1xyz', 'u1xyz@accenture.com', 'Tester1', '1xyz@unileverxyz.com');
    	Test.startTest();
    	uw_futureHandler.addChatterGroupMember(testUser.Id, cGroup.Id);
    	
    	Test.stopTest();
    }   
}