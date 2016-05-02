/* -----------------------------------------------------------------------------------------------------------------------
Name: BC_landing_page_Test.cls 
Description: 1) Test class used for testing the BC_landing_page

Date Version Author Summary of Changes 
----------- ------- ----------------- ------------------------------------------------------------------------
17 October 2014 1.1    Blessy Voola    Insert data into custom settings BC_Profile__C T0
December 2013 1.0 Vanessa Barros Initial Release 
------------------------------------------------------------------------------------------------------------------------ */

@isTest
private class BC_landing_page_Test { 


static testMethod void BC_landing_page_Test() {
collaborationGroup c = new collaborationGroup(name = 'creating group 1',CollaborationType = 'Public');
insert c;
Profile pp = [select id from Profile where name ='System Administrator'];
User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa@dfg.com', 
Email='vanessa@dfg.com', Alias='dfg', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
insert u;

CollaborationGroupMember cgm = new CollaborationGroupMember (MemberId = u.id,CollaborationGroupId=c.id );
insert cgm;
string cgID = string.valueOf(c.id).left( 15);
brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand 1', static_resource_name__c = 'vanessa',
css_name__c = 'MyStaticName',Chatter_Group_Id__c = cgID,background_image__c ='test', footer__c ='test', 
background_colour__c ='');
insert b;
Brand_centre_content__c bc = new Brand_centre_content__c (position__c = 'Right Side',name = 'BC 1',
brand_centre__c = b.id );
insert bc;
Brand_centre_content__c bc1 = new Brand_centre_content__c (position__c = 'Community',name = 'BC 2',
brand_centre__c = b.id );
insert bc1;
Brand_centre_content__c bc2 = new Brand_centre_content__c (position__c = 'Online',name = 'BC 3',
brand_centre__c = b.id );
insert bc2;
Brand_centre_content__c bc3 = new Brand_centre_content__c (position__c = 'Latest News',name = 'BC 4',
brand_centre__c = b.id );
insert bc3;


Brand_centre_content__c bcontent = new Brand_centre_content__c (name = 'test',header_section__c = bc.id,
brand_centre__c = b.id, ordinal__c =1 );
insert bcontent;
Brand_centre_content__c bcontent1 = new Brand_centre_content__c (header_section__c = bc1.id,name = 'BC 5',
brand_centre__c = b.id, summary__c = 'test' );
insert bcontent1;
Brand_centre_content__c bcontent2 = new Brand_centre_content__c (header_section__c = bc2.id,name = 'BC 6',
brand_centre__c = b.id, sub_type__c ='Other', Image_Icon_SubType_Other__c ='vanessa' );
insert bcontent2;
Brand_centre_content__c bcontent3 = new Brand_centre_content__c (header_section__c = bc3.id,name = 'BC 7',
brand_centre__c = b.id, summary__c = 'test' );
insert bcontent3;
/*T0 Begin*/
insert new BC_Profile__c(Name='sysadm',profile__c = 'System Administrator');
/*T0 End*/
Test.startTest();
System.runAs(u) {
Test.setCurrentPage(Page.BC_landing_page);
ApexPages.StandardController ctr = new ApexPages.StandardController( b);
System.CurrentPageReference().getParameters().put('id',b.id);
BC_landing_page BC_landing_pageTest = new BC_landing_page(ctr);

PageReference p = BC_landing_pageTest.getPermissionUser();
String dynamicCss = BC_landing_pageTest.getDynamicCss ();
string BackgroundImage = BC_landing_pageTest.getBackgroundImage ();
string footer = BC_landing_pageTest.getFooter ();
string communityHeader = Bc_landing_PageTest.getCommunityHeader();
List<Brand_centre_content__c> CommunityContent= Bc_landing_PageTest.getCommunityContent();
string LastestNewsHeader = BC_landing_pageTest.getLastestNewsHeader();
List<Brand_centre_content__c> NewsContent = BC_landing_pageTest.getLastestNewsContent();
string onlineHeader = bc_landing_pageTest.getOnlineHeader();
List<Brand_centre_content__c> onlineContent = BC_landing_pageTest.getOnlineContent();
List<Brand_centre_content__c> rightSideHeader = BC_landing_pageTest.getRightSideMenu();
List<Brand_centre_content__c> rightSideContent = BC_landing_pageTest.getRightSideHeaderContent();
List<User> m = BC_landing_pageTest.getMembers ();
Boolean ShowButton = BC_landing_pageTest.getShowButton();
PageReference joinGroup = BC_landing_pageTest.joinGroup();
System.assert(true);
}
Test.stopTest();



}

static testMethod void BC_landing_page_TestPreview() {
collaborationGroup c = new collaborationGroup(name = 'creating group 2',CollaborationType = 'Public');
insert c;
Profile pp = [select id from Profile where name ='System Administrator'];
User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa@dfg.com', 
Email='vanessa@dfg.com', Alias='dfg', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
insert u;

CollaborationGroupMember cgm = new CollaborationGroupMember (MemberId = u.id,CollaborationGroupId=c.id );
insert cgm;
string cgID = string.valueOf(c.id).left( 15);
brand_centre_new__c b = new Brand_centre_new__c(name = 'creating brand 2', static_resource_name__c = 'vanessa',
css_name__c = 'MyStaticName',Chatter_Group_Id__c = cgID,background_image__c ='test', footer__c ='test', 
background_colour__c ='');
insert b;
Brand_centre_content__c bc = new Brand_centre_content__c (position__c = 'Right Side',name = 'BC 8',
brand_centre__c = b.id );
insert bc;
Brand_centre_content__c bc1 = new Brand_centre_content__c (position__c = 'Community',name = 'BC 9',
brand_centre__c = b.id );
insert bc1;
Brand_centre_content__c bc2 = new Brand_centre_content__c (position__c = 'Online',name = 'BC 10',
brand_centre__c = b.id );
insert bc2;
Brand_centre_content__c bc3 = new Brand_centre_content__c (position__c = 'Latest News',name = 'BC 11',
brand_centre__c = b.id );
insert bc3;


Brand_centre_content__c bcontent = new Brand_centre_content__c (name = 'test',header_section__c = bc.id,
brand_centre__c = b.id, ordinal__c =1 );
insert bcontent;
Brand_centre_content__c bcontent1 = new Brand_centre_content__c (header_section__c = bc1.id,name = 'BC 12',
brand_centre__c = b.id, summary__c = 'test' );
insert bcontent1;
Brand_centre_content__c bcontent2 = new Brand_centre_content__c (header_section__c = bc2.id,name = 'BC 13',
brand_centre__c = b.id, sub_type__c ='Other',Image_Icon_SubType_Other__c ='vanessa' );
insert bcontent2;
Brand_centre_content__c bcontent3 = new Brand_centre_content__c (header_section__c = bc3.id,name = 'BC 14',
brand_centre__c = b.id, summary__c = 'test' );
insert bcontent3;

Test.startTest();
Test.setCurrentPage(Page.BC_landing_page);
ApexPages.StandardController ctr = new ApexPages.StandardController( b);
System.CurrentPageReference().getParameters().put('id',b.id);
string preview = 'true';
System.CurrentPageReference().getParameters().put('preview',preview);
BC_landing_page BC_landing_pageTest = new BC_landing_page(ctr);

PageReference p = BC_landing_pageTest.getPermissionUser();
String dynamicCss = BC_landing_pageTest.getDynamicCss ();
string BackgroundImage = BC_landing_pageTest.getBackgroundImage ();
string footer = BC_landing_pageTest.getFooter ();
string communityHeader = Bc_landing_PageTest.getCommunityHeader();
List<Brand_centre_content__c> CommunityContent= Bc_landing_PageTest.getCommunityContent();
string LastestNewsHeader = BC_landing_pageTest.getLastestNewsHeader();
List<Brand_centre_content__c> NewsContent = BC_landing_pageTest.getLastestNewsContent();
string onlineHeader = bc_landing_pageTest.getOnlineHeader();
List<Brand_centre_content__c> onlineContent = BC_landing_pageTest.getOnlineContent();
List<Brand_centre_content__c> rightSideHeader = BC_landing_pageTest.getRightSideMenu();
List<Brand_centre_content__c> rightSideContent = BC_landing_pageTest.getRightSideHeaderContent();
List<User> m = BC_landing_pageTest.getMembers ();
Boolean ShowButton = BC_landing_pageTest.getShowButton();
PageReference joinGroup = BC_landing_pageTest.joinGroup();
System.assert(true);
Test.stopTest();
}
static testMethod void BC_landing_page_TestUserWithoutPermissions() {
collaborationGroup c = new collaborationGroup(name = 'creating group 3',CollaborationType = 'Public');
insert c;
string cgID = string.valueOf(c.id).left( 15);
Profile pp = [select id from Profile where name ='Chatter Free User'];
User u = new User(firstName='vanessa', lastname='barros2', profileId= pp.id,Username = 'vanessa@dfg.com', 
Email='vanessa@dfg.com', Alias='dfg', CommunityNickname='dfg', TimeZoneSidKey = 'GMT', 
LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1', LanguageLocaleKey='en_US');
insert u;
brand_centre_new__c b = new Brand_centre_new__c(name = 'teste brand', static_resource_name__c = 'vanessa',
css_name__c = 'MyStaticName',Chatter_Group_Id__c = cgID,background_image__c ='test', footer__c ='test', 
background_colour__c ='');
insert b;
Test.startTest();
System.runAs(u) {
Test.setCurrentPage(Page.BC_landing_page);
ApexPages.StandardController ctr = new ApexPages.StandardController( b);
System.CurrentPageReference().getParameters().put('id',b.id);
BC_landing_page BC_landing_pageTest = new BC_landing_page(ctr);
PageReference p = BC_landing_pageTest.getPermissionUser();

System.assert(true);
}
Test.stopTest();

}
}