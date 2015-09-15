/*************************************************************************************
Name : BET_EmailNotificationService

Purpose : Class contains logic used for sending custom notifications

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  28-08-2015  Initial
*************************************************************************************/
public with sharing class BET_EmailNotificationService {

	private static final OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where displayname = 'CB4L'];

	private BET_EmailNotificationService() {}


    /************************************************************
    Purpose: Method  notifies Bet owner that there are member requests from IPM
    Parameters: Id betId,Id projectId
    Returns: -
    Throws: -
    *************************************************************/
    public static void notifyBetOwnerOfMultipleMemberRequestsFromIPM(Id betId,Id projectId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        uw_Bet__c bet = [select id,name,ownerId from uw_Bet__c where id=:betId];
        IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper(projectId);

        User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];

        List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('A member access request has been made to BET ' + bet.name);
     
        String beturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + bet.id;

        String body = 'A member access request has been made to BET ' + bet.name + ' from project ' +project.projectName +'.<br/> Please open the BET and click on Members to Approve or Deny,'+
        '<a href="'+beturl+'">'+bet.name+'</a>';

        mail.setHtmlBody(body);

        if(!Test.isRunningTest()) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        }
    }

    /************************************************************
    Purpose: Method  notifies Bet owner that project has been unlinked
    Parameters: uw_Bet__c bet,IPM_BETWrapper oldProject
    Returns: -
    Throws: -
    *************************************************************/
	public static void notifyBetOwnerThatProjectIsUnlinked(uw_Bet__c bet,IPM_BETWrapper oldProject){ // US23
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];

		List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('Project ' + oldProject.projectName + ' unlinked from your BET');
        String body = 'Project ' + oldProject.projectName + ' unlinked from your BET ' + bet.name + ' ';
        body += '<br/> the next project with the earliest TLD is now your leading/controlling project,';
        body += '<br/> if you want to change this please contact system admin';
        mail.setHtmlBody(body);
        if(!Test.isRunningTest()) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        }
	}

    /************************************************************
    Purpose: Method  notifies Bet owner and Project Lead that new lead project has been assigned to bet
    Parameters: uw_Bet__c bet, IPM_Project__c newProject
    Returns: -
    Throws: -
    *************************************************************/
	public static void notifyBetOwnerOfNewLeadProject(uw_Bet__c bet, IPM_BETWrapper newProject){ //US23
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		List<User> usersToBeNofified = Test.isRunningTest() ? 
		new List<User> {new User(email = BET_TestUtils.TEST_USER_EMAIL),new User(email = BET_TestUtils.TEST_USER_EMAIL)} : 
		[select email from User where isActive = true and id =: bet.ownerid];

		List<String> sendTo = new List<String>();
        if(!usersToBeNofified.isEmpty()) {
          sendTo.add(usersToBeNofified.get(0).email);
        }

        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('Project ' + newProject.projectName + ' has become new lead/controlling project of BET');
        final String body = 'Project ' + newProject.projectName + ' has become new lead/controlling project of BET ' + bet.name ;
        mail.setHtmlBody(body);
        if(!Test.isRunningTest()) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        }
	}

    /************************************************************
    Purpose: Method notifies Bet owner that project has been unlinked from BET 
    Parameters: uw_Bet__c bet, IPM_BETWrapper project
    Returns: -
    Throws: -
    *************************************************************/
	public static void notifyBetOwnerOfUnfollow(uw_Bet__c bet, IPM_BETWrapper project){ //US22, US26
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];

		List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('Project ' + project.projectName + ' unlinked from your BET');
        String body = 'Project ' + project.projectName + ' unlinked from your BET ' + bet.name + ' ';
        body += '<br/> there is no lead/controlling project assigned to your BET. ';
        body += '<br/> BET has been archived but can be unarchived if required';
        mail.setHtmlBody(body);
        if(!Test.isRunningTest()){
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        }
	}
}