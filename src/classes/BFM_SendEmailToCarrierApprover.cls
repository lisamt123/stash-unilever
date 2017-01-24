/**
 * Helper class for idenfiying the right Contact responsible for approving User Creation Requests on the carrier side
 * and sending them an email.
 * */
public without sharing class BFM_SendEmailToCarrierApprover {

    BFM_UserCreationRequest__c carrierUserRequest;
    List<Account> desiredCarriers;
    private String errors;
    private boolean isSuccess;
    
    public BFM_SendEmailToCarrierApprover(BFM_UserCreationRequest__c carrierUserRequest, List<Account> desiredCarriers){
        this.carrierUserRequest = carrierUserRequest;
        this.desiredCarriers = desiredCarriers;
        isSuccess = false;
    }
    
    public boolean isSuccess(){
        return isSuccess;
    }
    public String getError(){
        return errors;
    }
    
    public List<Account> getDesiredCarriers(){
        return this.desiredCarriers;
    }
    public String sendEmail(){
        isSuccess = false;
        Contact contactEmail = getEmailContact();
        
        if(contactEmail != null){
            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'BFM_User_Creation_Carrier_Approval' LIMIT 1];
            emailMessage.setTargetObjectId(contactEmail.Id);
            emailMessage.setTemplateId(template.Id);
            emailMessage.setWhatId(carrierUserRequest.Id);
            OrgWideEmailAddress owea= [select id, Address from OrgWideEmailAddress WHERE DisplayName = 'BFM Self-Service email'];
            emailMessage.setOrgWideEmailAddressId(owea.Id);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {emailMessage});
            isSuccess = true;
            return contactEmail.Email;
        } else{
            errors = 'Nenhum email foi encontrado para as operadoras solicitadas. Um fluxo de trabalho interno foi disparado, entre em contato com o e-mail para obter mais informações.';
            sendTaskToGovernanceTeamNoEmail();
        }
        return null;
    }
    
    public Contact getEmailContact(){
        Contact contactEmail;
        String masterCNPJ = desiredCarriers[0].BFM_cnpj__c;
        String cnpjPrefix = '%' + masterCNPJ.substring(0,8) + '%';
        System.debug('cnpjPrefix: ' + cnpjPrefix);
        System.debug('masterCNPJ: ' + masterCNPJ);
        for(Account acc : [SELECT Id, (SELECT email  FROM Contacts WHERE title = 'SF_APPROVAL' AND email != null) 
                           FROM Account
                           WHERE BFM_cnpj__c LIKE : cnpjPrefix]){
                               
                               System.debug('acc' + acc);
                               if(!acc.Contacts.isEmpty()){
                                   contactEmail = acc.Contacts;  
                                   break;
                               }
                           }
        
        System.debug('contactEmail ' + contactEmail);
        if(contactEmail == null){
            errors ='Nenhum email foi encontrado para as operadoras solicitadas. Um fluxo de trabalho interno foi disparado, entre em contato com o e-mail para obter mais informações.';           
        }
        return contactEmail;
    }
    
    /**
     * Sends a task for a governance user in case no email is found for the carrier.
     * */
    @TestVisible
    private void sendTaskToGovernanceTeamNoEmail(){
        Task t = new Task();
        t.whatId = desiredCarriers[0].Id;
        t.subject = 'Review carrier email';
        t.status = 'Open';
        Id groupId = [SELECT Id FROM Group WHERE Name = 'BFM Governance' LIMIT 1].Id;
        Set<Id> idsUsersGovernanceGroup = GetUserIdsFromGroup(groupId);
        List<User> usersGovernanceGroup = [SELECT Id FROM User WHERE Id IN: idsUsersGovernanceGroup ORDER BY username];
        AggregateResult res = [select count(id) from BFM_UserCreationRequest__c];
		Integer count = integer.valueof(res.get('expr0'));
		if(usersGovernanceGroup.size()>0)
        {
        Integer turn = Math.mod(count, usersGovernanceGroup.size());
        t.OwnerId = usersGovernanceGroup[turn].Id;
        }
        t.Description = 'O funcionário da transportadora solicitou acesso, mas nenhum e-mail foi encontrado. Por favor, revise e entre em contato com:' + carrierUserRequest.email__c;
        t.ActivityDate = System.today().addDays(1);
        insert t;
    }
    
    /**
     * Helper method to retrieve Users from the Governance group.
     * CAREFUL: If there are too many nesting levels inside of the Governance group this will reach governor limits.
     * */
    @TestVisible
    private static Set<id> GetUserIdsFromGroup(Id groupId){
        // store the results in a set so we don't get duplicates
        Set<Id> result=new Set<Id>();
        String userType = Schema.SObjectType.User.getKeyPrefix();
        String groupType = Schema.SObjectType.Group.getKeyPrefix();
        
        // Loop through all group members in a group
        for (GroupMember m : [Select Id, UserOrGroupId From GroupMember Where GroupId = :groupId]) {
            // If the user or group id is a user
            if (((String)m.UserOrGroupId).startsWith(userType)) {
                result.add(m.UserOrGroupId);
            }
            // If the user or group id is a group
            // Note: there may be a problem with governor limits if this is called too many times
            else if (((String)m.UserOrGroupId).startsWith(groupType)) {
                // Call this function again but pass in the group found within this group
                result.addAll(GetUSerIdsFromGroup(m.UserOrGroupId));
            }
        }
        
        return result;  
	}
}