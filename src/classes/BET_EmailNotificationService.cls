/*************************************************************************************
Name : BET_EmailNotificationService

Purpose : Class contains logic used for sending custom notifications

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  28-08-2015  Initial
*************************************************************************************/
/* Without sharing due to it is a service class used by external system */
public without sharing class BET_EmailNotificationService {

  private static final OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where displayname = 'Unilever'];

  private BET_EmailNotificationService() {}

    /************************************************************
    Purpose: Method  notifies Bet owner that there is a lead project follow request
    Parameters: Id betId,Id projectId
    Returns: -
    Throws: -
    *************************************************************/
    public static List<Messaging.SingleEmailMessage> notifyBetOwnerOfLeadProjectFollowRequest(uw_Bet__c bet,IPM_BETWrapper project){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];

        String beturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + bet.id;

        List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);
        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject(String.format(Label.BET_LeadProjectRequestNotificationSubject,new List<String>{project.projectName,bet.name}));
        mail.setHtmlBody(String.format(Label.BET_LeadProjectRequestNotification,new List<String>{project.projectName,bet.name,beturl,bet.name,beturl,bet.name,bet.name}));
        
        List<Messaging.SingleEmailMessage> messagesToBeSent = new List<Messaging.SingleEmailMessage> {mail};
        if(!Test.isRunningTest() && !sendTo.isEmpty()) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {mail});
        }
        return messagesToBeSent;
    }

    /************************************************************
    Purpose: Method  notifies Bet owner that there are member requests from IPM
    Parameters: Id betId,Id projectId
    Returns: -
    Throws: -
    *************************************************************/
    public static List<Messaging.SingleEmailMessage> notifyBetOwnerOfMultipleMemberRequestsFromIPM(Id betId,Id projectId){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        uw_Bet__c bet = [select id,name,ownerId from uw_Bet__c where id=:betId];
        IPM_BETWrapper project = IPM_BETUpdateService.ipm_Wrapper(projectId);

        User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];
        String beturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + bet.id;

        List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);
        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject(String.format(Label.BET_MultipleRequestNotificationSubject,new List<String>{bet.name}));
        mail.setHtmlBody(String.format(Label.BET_MultipleRequestNotification,new List<String>{bet.name,project.projectName,beturl,bet.name}));
        List<Messaging.SingleEmailMessage> messagesToBeSent = new List<Messaging.SingleEmailMessage> {mail};
        if(!Test.isRunningTest() && !sendTo.isEmpty()) {
            Messaging.sendEmail(messagesToBeSent);
        }
        return messagesToBeSent;
    }

    /************************************************************
    Purpose: Method  notifies Bet owner that project has been unlinked
    Parameters: uw_Bet__c bet,IPM_BETWrapper oldProject
    Returns: -
    Throws: -
    *************************************************************/
  public static List<Messaging.SingleEmailMessage> notifyBetOwnerThatProjectIsUnlinked(uw_Bet__c bet,IPM_BETWrapper oldProject,IPM_BETWrapper newProject){ // US23
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];

    List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);
        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject(String.format(Label.BET_UnlinkedProjectNotificationSubject,new List<String>{oldProject.projectName,bet.name}));
        mail.setHtmlBody(String.format(Label.BET_UnlinkedProjectNotification,new List<String>{oldProject.projectName,bet.name,newProject.projectName,bet.name}));
        List<Messaging.SingleEmailMessage> messagesToBeSent = new List<Messaging.SingleEmailMessage> {mail};
        if(!Test.isRunningTest() && !sendTo.isEmpty()) {
            Messaging.sendEmail(messagesToBeSent);
        }
        return messagesToBeSent;
  }

    /************************************************************
    Purpose: Method  notifies Bet owner and Project Lead that new lead project has been assigned to bet
    Parameters: uw_Bet__c bet, IPM_Project__c newProject
    Returns: -
    Throws: -
    *************************************************************/
  public static List<Messaging.SingleEmailMessage> notifyBetOwnerOfNewLeadProject(uw_Bet__c bet, IPM_BETWrapper newProject){ //US23
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
        mail.setSubject(String.format(Label.BET_NewLeadProjectNotificationSubject,new List<String>{newProject.projectName,bet.name}));
        mail.setHtmlBody(String.format(Label.BET_NewLeadProjectNotification, new List<String>{newProject.projectName,bet.name,bet.name}));
        List<Messaging.SingleEmailMessage> messagesToBeSent = new List<Messaging.SingleEmailMessage> {mail};
        if(!Test.isRunningTest() && !sendTo.isEmpty()) {
            Messaging.sendEmail(messagesToBeSent);
        }
        return messagesToBeSent;
  }

    /************************************************************
    Purpose: Method notifies Bet owner that project has been unlinked from BET 
    Parameters: uw_Bet__c bet, IPM_BETWrapper project
    Returns: -
    Throws: -
    *************************************************************/
  public static List<Messaging.SingleEmailMessage> notifyBetOwnerOfUnfollow(uw_Bet__c bet, IPM_BETWrapper project){ //US22, US26
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    User betOwner = Test.isRunningTest() ? new User(email = BET_TestUtils.TEST_USER_EMAIL) : [select email from User where isActive = true and id =: bet.ownerid];
        String beturl = URL.getSalesforceBaseUrl().toExternalForm() + '/' + bet.id;

    List<String> sendTo = new List<String>();
        sendTo.add(betOwner.email);
        mail.setToAddresses(sendTo);
        mail.setOrgWideEmailAddressId(owea.id);
        mail.setSubject(String.format(Label.BET_UnfollowNotificationSubject, new List<String>{project.projectName,bet.name}));
        mail.setHtmlBody(String.format(Label.BET_UnfollowNotification, new List<String>{project.projectName,bet.name,beturl,bet.name}));

        List<Messaging.SingleEmailMessage> messagesToBeSent = new List<Messaging.SingleEmailMessage> {mail};
        if(!Test.isRunningTest() && !sendTo.isEmpty()){
            Messaging.sendEmail(messagesToBeSent);
        }
        return messagesToBeSent;
  }
}