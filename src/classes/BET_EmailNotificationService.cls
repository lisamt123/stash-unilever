public with sharing class BET_EmailNotificationService {

	private static final OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where displayname = 'CB4L'];

	private BET_EmailNotificationService() {}

	public static void notifyBetOwnerThatProjectIsUnlinked(uw_Bet__c bet,IPM_Project__c oldProject){ // US23
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		User betOwner = [select email from User where isActive = true and id =: bet.ownerid];

		List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('Project ' + oldProject.name + ' unlinked from your BET');
      	String body = 'Project ' + oldProject.name + ' unlinked from your BET ' + bet.name + ' ';
      	body += '<br/> the next project with the earliest TLD is now your leading/controlling project,';
      	body += '<br/> if you want to change this please contact system admin';
      	mail.setHtmlBody(body);
      	Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
	}

	public static void notifyBetOwnerAndProjectLeadOfNewLeadProject(uw_Bet__c bet, IPM_Project__c newProject){ //US23
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		List<User> usersToBeNofified = [select email from User where isActive = true and (id =: bet.ownerid or id=:newProject.IPM_Project_Leader__c)];

		List<String> sendTo = new List<String>();
        sendTo.add(usersToBeNofified.get(0).email);
        sendTo.add(usersToBeNofified.get(1).email);
        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('Project ' + newProject.name + ' has become new lead/controlling project of BET');
      	String body = 'Project ' + newProject.name + ' has become new lead/controlling project of BET ' + bet.name ;
      	mail.setHtmlBody(body);
      	Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
	}

	public static void notifyBetOwnerOfUnfollow(uw_Bet__c bet, IPM_Project__c project){ //US22, US26
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

		User betOwner = [select email from User where isActive = true and id =: bet.ownerid];

		List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);

        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject('Project ' + project.name + ' unlinked from your BET');
      	String body = 'Project ' + project.name + ' unlinked from your BET ' + bet.name + ' ';
      	body += '<br/> there is no lead/controlling project assigned to your BET. ';
      	body += '<br/> BET has been archived but can be unarchived if required';
      	mail.setHtmlBody(body);
      	Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
	}
}