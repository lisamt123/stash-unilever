@isTest
private class BFM_SendEmailToCarrierApproverTest{  
  private static testMethod void testEmailToApprover(){
     //Group g=[select Id from Group Where DeveloperName='MainCarrierPartnerUser' LIMIT 1];
     Profile p = [select id from profile where name='System Administrator'];
      User objUser = new User(alias = 'stan', email='standarduser@test.com', 
                              emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', 
                              localesidkey='en_US', profileid = p.Id, 
                              timezonesidkey='America/Los_Angeles', username='standarduser06@test.com');
      insert objUser ; 
      
       BFM_UserCreationRequest__c userCreationRequest = BFM_TestUtils.createUserCreationRequest();
        insert userCreationRequest;
        
         Account accountOne = BFM_TestUtils.createCarrierAccount();
        accountOne.name = 'Carrier 1';
        accountOne.BFM_CNPJ__c = '94657755000107';
        Account accountTwo = BFM_TestUtils.createCarrierAccount();
        accountTwo.Name = 'Carrier 2';
        List<Account> accountsList = new List<Account>{accountOne, accountTwo};
        insert accountsList;
        
        
         Account accountThree = BFM_TestUtils.createCarrierAccount();
         accountThree.name='Carrier3';
         List<Account> accountsList1 = new List<Account>{accountThree};
         insert accountsList1 ; 
        
        contact con1=new contact();
        con1.lastname='shiv1';
        con1.Email='shiv1@capg.com';
        con1.Accountid=accountOne.id;
        con1.Title='SF_APPROVAL';
        insert con1;
      
        contact con=new contact();
        con.lastname='shiv';
        con.Email='shiv@capg.com';
        con.Accountid=accountThree.id;
        con.Title='SF_APPROVAL';
        insert con;
        
        
        
        BFM_SendEmailToCarrierApprover apprv=new BFM_SendEmailToCarrierApprover (userCreationRequest,accountsList);
         BFM_SendEmailToCarrierApprover apprv1=new BFM_SendEmailToCarrierApprover (userCreationRequest,accountsList1 );
        apprv.isSuccess();
        apprv.getError();
        apprv.getDesiredCarriers();
        try{
          apprv.sendEmail();
            apprv.getEmailContact();
        }catch(exception e){}
        apprv.sendTaskToGovernanceTeamNoEmail();
        //BFM_SendEmailToCarrierApprover.GetUserIdsFromGroup(g);
        //apprv.sendTaskToGovernanceTeamNoEmail();
        
        apprv1.isSuccess();
        apprv1.getError();
        apprv1.getDesiredCarriers();
  }
}