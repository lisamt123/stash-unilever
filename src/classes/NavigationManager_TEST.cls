@isTest
public class NavigationManager_TEST
{
    private static User runningUser(String aliasId, String profileName)
    {
        Id profId = [SELECT Id FROM Profile WHERE Name=: profileName].Id;

        User userData = new User(FirstName='Test', LastName='User', Alias=aliasId, IsActive=True, Email=aliasId+'@test.com',
                                 ProfileId=profId, Username=aliasId+'@test.com', EmailEncodingKey='UTF-8', CommunityNickname=aliasId,
                                 LanguageLocaleKey='en_US', LocaleSidKey='en_US', TimeZoneSidKey='GMT');

        insert userData;
        
        return userData;
    }
    private static void setPS(Id UserId)
    {
        Id psId = [select id from PermissionSet where name = 'Four_Acres_Participant_User'].id;
        list <PermissionSetAssignment> PSAssignments = new list <PermissionSetAssignment>();
        PSAssignments.add( new PermissionSetAssignment(AssigneeId = UserId,PermissionSetId = psID ) );
        insert PSAssignments;
    }
    static testMethod void testGetPageIndex()
    {
        NavigationElement__c sideNavElement1 = new NavigationElement__c(
                Name = 'all_chatter',
                PageName__c = 'All Chatter', 
                Url__c = '/apex/AllChatter', 
                Disabled__c = false, 
                DisplayOrder__c = 1, 
                PageFilterUrl__c ='Chatter',
                Profile_Access__c = 'FA - Facility Manager',
                Type__c  = 'sidebar'
        );
        
        NavigationElement__c sideNavElement2 = new NavigationElement__c(
                Name = 'my_chatter',
                PageName__c = 'My Chatter', 
                Url__c = '/apex/MyChatter', 
                Disabled__c = false, 
                DisplayOrder__c = 2, 
                PageFilterUrl__c ='Chatter',
                Profile_Access__c = 'Four_Acres_Participant_User',
                Type__c  = 'sidebar'
        );
        
        insert new NavigationElement__c[] {sideNavElement1, sideNavElement2};

        User runUser = runningUser('navTst1','FA - Facility Manager');
        Test.startTest();
        System.runAs(runUser)
        {
            setPS(runUser.id);
            NavigationManager manager = NavigationManager.getInstance();
            Test.setCurrentPage(Page.Chatter);
            Integer pageIndex = manager.getPageIndex('/apex/AllChatter');
            System.debug('%%%%sideNavElement2%%%' + sideNavElement2);
            System.assertEquals(1, pageIndex);
        }


        User runUser1 = runningUser('navTst2','System Administrator');
        System.runAs(runUser1)
        {
            //setPS(runUser.id);
            NavigationManager manager = NavigationManager.getInstance();
            Test.setCurrentPage(Page.Chatter);
            Integer pageIndex = manager.getPageIndex('/apex/AllChatter');
            System.assertEquals(1, pageIndex);
        }
        Test.stopTest();
    }
}