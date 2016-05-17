/*
Class Name:EA_Wrapper_Class_Test
Author : Mindtree
Date: 11 Nov 2015
Requirement/Project Name: Unilever Salesforce Engagement
Requirement/Description: Test Class For EA_Wrapper_Class
*/
@IsTest
public class EA_Wrapper_Class_Test{
  static testMethod void postive() {
  EA_Wrapper_Class wrapper=new EA_Wrapper_Class();
  EA_Wrapper_Class.EA_FeaturedContent_Wrapper temp1=new  EA_Wrapper_Class.EA_FeaturedContent_Wrapper();
  temp1.userName='mindtree';
  temp1.uerPhotoUrl='https://unilever--chazwa.cs14.my.salesforce.com/_ui/core/userprofile/UserProfilePage?u=005c0000002N2U3&tab=sfdc.ProfilePlatformFeed';
  temp1.description='test.desc';
  temp1.disabled =true;
  temp1.documentUrl='test';
  temp1.createdDate='10/05/1988';
  //temp1.commentuserName='test';
  //temp1.commentuserPhotoUrl='test';
  //temp1.commentdescription='test';
  //temp1.commentcreatedDate='10/6/2015';
      System.assertEquals(temp1.uerPhotoUrl, 'https://unilever--chazwa.cs14.my.salesforce.com/_ui/core/userprofile/UserProfilePage?u=005c0000002N2U3&tab=sfdc.ProfilePlatformFeed');
    EA_Wrapper_Class.EA_UserProfile_Wrapper  temp2=new EA_Wrapper_Class.EA_UserProfile_Wrapper ();
    temp2.acivityId='1222';
    temp2.userPhotoUrl='https://unilever--chazwa.cs14.my.salesforce.com/_ui/core/chatter/groups/GroupProfilePage?g=0F9c00000009s2Z';
    temp2.userName='test';
    temp2.activity_points=5;
    temp2.badgeprogress_color='red';
    temp2.activity_name='test';
    temp2.theme_name='themename';
     EA_Wrapper_Class.EA_RecentlyCompletedUsers temp3=new EA_Wrapper_Class.EA_RecentlyCompletedUsers();
     temp3.userPhotoUrl='https://unilever--chazwa.cs14.my.salesforce.com/_ui/core/chatter/groups/GroupProfilePage?g=0F9c00000009s2Z';
     }
     }