public with sharing class BET_EmailNotificationService {

	private static final OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where displayname = 'CB4L'];

	private BET_EmailNotificationService() {}

    public static void notifyAllIPMProjectLeadersOfArchivedBet(List<uw_Bet__c> bets){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(uw_Bet__c bet : bets){
            List<IPM_BETWrapper> ipms =  IPM_BETUpdateService.returnIPM(bet.id);
            List<String> userMails = userEmails(ipms);
            mails.add(buildArchiveMessage(userMails,bet));
        }
        if(!Test.isRunningTest()) {
          Messaging.sendEmail(mails,false);
        }
    }

    public static void notifyAllIPMProjectLeadersOfUnArchivedBet(List<uw_Bet__c> bets){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        for(uw_Bet__c bet : bets){
            List<IPM_BETWrapper> ipms = IPM_BETUpdateService.returnIPM(bet.id);
            List<String> userMails = userEmails(ipms);
            mails.add(buildUnArchiveMessage(userMails,bet));
        }
        if(!Test.isRunningTest()) {
          Messaging.sendEmail(mails,false);
        }
    }

    private static Messaging.SingleEmailMessage buildArchiveMessage(List<String> userMails,uw_Bet__c bet){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(userMails);
        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('BET '+bet.name+' has been archived.');
        String body = 'BET '+bet.name+' has been archived.';
        mail.setHtmlBody(body);
        return mail;
    }

    private static Messaging.SingleEmailMessage buildUnArchiveMessage(List<String> userMails,uw_Bet__c bet){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(userMails);
        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('BET '+bet.name+' has been unarchived.');
        String body = 'BET '+bet.name+' has been unarchived.';
        mail.setHtmlBody(body);
        return mail;
    }

    private static List<String> userEmails(List<IPM_BETWrapper> ipms) {
        Set<Id> userIds = new Set<Id>();
        for(IPM_BETWrapper bwrapper : ipms){
            userIds.add(bwrapper.pLId);
        }
        List<String> emails = new List<String>();
        for(User u : [select email from User where id in: userIds]){
            emails.add(u.email);
        }
        return emails; 
    }

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

	public static void notifyBetOwnerAndProjectLeadOfNewLeadProject(uw_Bet__c bet, IPM_Project__c newProject){ //US23
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		List<User> usersToBeNofified = Test.isRunningTest() ? 
		new List<User> {new User(email = BET_TestUtils.TEST_USER_EMAIL),new User(email = BET_TestUtils.TEST_USER_EMAIL)} : 
		[select email from User where isActive = true and (id =: bet.ownerid or id=:newProject.IPM_Project_Leader__c)];

		List<String> sendTo = new List<String>();
        if(!usersToBeNofified.isEmpty()) {
          sendTo.add(usersToBeNofified.get(0).email);
        }

        if(usersToBeNofified.size() == 2) {
          sendTo.add(usersToBeNofified.get(1).email);
        }

        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('Project ' + newProject.name + ' has become new lead/controlling project of BET');
        final String body = 'Project ' + newProject.name + ' has become new lead/controlling project of BET ' + bet.name ;
        mail.setHtmlBody(body);
        if(!Test.isRunningTest()){
          Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        }
	}

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