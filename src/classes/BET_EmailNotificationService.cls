/*************************************************************************************
Name : BET_EmailNotificationService

Purpose : Class contains logic used for sending custom notifications

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  28-08-2015  Initial
*************************************************************************************/
public without sharing class BET_EmailNotificationService {

    private static final String PROJECT_TXT = 'Project '; // sonnar related fix

	private static final OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where displayname = 'CB4L'];

	private BET_EmailNotificationService() {}

    /************************************************************
    Purpose: Method  notifies Bet owner that there is a lead project follow request
    Parameters: Id betId,Id projectId
    Returns: -
    Throws: -
    *************************************************************/
    public static void notifyBetOwnerOfLeadProjectFollowRequest(uw_Bet__c bet,IPM_BETWrapper project){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];

        String beturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + bet.id;

        List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);
        mail.setOrgWideEmailAddressId(owea.id);

        mail.setSubject(PROJECT_TXT + project.projectName + ' has linked to your BET ' + bet.name + ' and will become your leading project');

        String body = PROJECT_TXT + project.projectName + ' has linked to your BET ' + bet.name + ' and will become your leading project.';
        body += '<br/> As a reminder, the leading project controls these aspects of a BET:';
        body += '<br/><br/>-  The target launch date (TLD)';
        body += '<br/><br/>-  The BET 1st and Final Release due dates';
        body += '<br/><br/>-  The category and brand position of a BET';
        body += '<br/><br/> If this project has requested access to the BET for it’s members, membership will also be automatically granted with this link.';
        body += '<br/><br/> To DENY this request for membership access and to lead your BET, click here <a href="'+beturl+'">'+bet.name+'</a> within 72 hours of this email.';
        body += '<br/><br/> To manage membership to your BET please open the BET and click on Members <a href="'+beturl+'">'+bet.name+'</a>';
        body += '<br/><br/> To change the lead project, please contact system admin by clicking <a href="mailto:cb4l@unilever.com?subject=BET SYSTEM REQUEST for'+bet.name+'">here</a>';

        mail.setHtmlBody(body);
        if(!Test.isRunningTest()) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        }
    }

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
	public static void notifyBetOwnerThatProjectIsUnlinked(uw_Bet__c bet,IPM_BETWrapper oldProject,IPM_BETWrapper newProject){ // US23
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];

		List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject(PROJECT_TXT + oldProject.projectName + ' has unlinked from your BET ' + bet.name + '.');

        String body = PROJECT_TXT + oldProject.projectName + ' unlinked from your BET ' + bet.name + ' ';
        body += '<br/> As a result, ' + newProject.projectName + ' is now your leading project, as it is the linked project with the earliest target launch date (TLD).';
        body += '<br/> As a reminder, the leading project controls these aspects of a BET:';
        body += '<br/><br/>-  The target launch date (TLD)';
        body += '<br/><br/>-  The BET 1st and Final Release due dates';
        body += '<br/><br/>-  The category and brand position of a BET';
        body += '<br/><br/> To change the lead project, please contact system admin by clicking <a href="mailto:cb4l@unilever.com?subject=BET SYSTEM REQUEST for'+bet.name+'">here</a>';
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
        mail.setSubject(PROJECT_TXT + newProject.projectName + ' has become the new lead project of BET '+ bet.name + '.');

        String body = PROJECT_TXT + newProject.projectName + ' has become the new lead project of BET '+ bet.name + '.';
        body += '<br/> As a reminder, the leading project controls these aspects of a BET:';
        body += '<br/><br/>-  The target launch date (TLD)';
        body += '<br/><br/>-  The BET 1st and Final Release due dates';
        body += '<br/><br/>-  The category and brand position of a BET';
        body += '<br/><br/> To change the lead project, please contact system admin by clicking <a href="mailto:cb4l@unilever.com?subject=BET SYSTEM REQUEST for'+bet.name+'">here</a>';

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
        mail.setSubject(PROJECT_TXT + project.projectName + ' has unlinked from your BET ' + bet.name + '.');

        String beturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + bet.id;

        String body = PROJECT_TXT + project.projectName + ' has unlinked from your BET ' + bet.name + '.'; 
        body += '<br/> As there are now no projects linked to your BET, it has been automatically archived.'; 
        body += '<br/> As a result, the associated Chatter Group will be deactivated and no further changes can be made to this BET.';
        body += '<br/> To unarchive the BET and reactivate the group please open the BET and click on Settings <a href="'+beturl+'">'+bet.name+'</a>';

        mail.setHtmlBody(body);
        if(!Test.isRunningTest()){
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        }
	}
}