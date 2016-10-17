@isTest
private class BFM_SendEmailToCarrierApproverTest{  
  private static testMethod void testEmailToApprover(){
     BFM_UserCreationRequest__c userCreationRequest = BFM_TestUtils.createUserCreationRequest();
        insert userCreationRequest;
        
         Account accountOne = BFM_TestUtils.createCarrierAccount();
        accountOne.name = 'Carrier 1';
        Account accountTwo = BFM_TestUtils.createCarrierAccount();
        accountTwo.Name = 'Carrier 2';
        List<Account> accountsList = new List<Account>{accountOne, accountTwo};
        insert accountsList;
        
        
         Account accountThree = BFM_TestUtils.createCarrierAccount();
         accountThree.name='Carrier3';
         List<Account> accountsList1 = new List<Account>{accountThree};
         insert accountsList1 ; 
        
        contact con=new contact();
        con.lastname='shiv';
        con.Email='shiv@capg.com';
        con.Accountid=accountThree.id;
        con.Title='SF_Approver';
        insert con;
        
        
        
        BFM_SendEmailToCarrierApprover apprv=new BFM_SendEmailToCarrierApprover (userCreationRequest,accountsList);
         BFM_SendEmailToCarrierApprover apprv1=new BFM_SendEmailToCarrierApprover (userCreationRequest,accountsList1 );
        apprv.isSuccess();
        apprv.getError();
        apprv.getDesiredCarriers();
        apprv.sendEmail();
        apprv.getEmailContact();
        //apprv.sendTaskToGovernanceTeamNoEmail();
        
         apprv1.isSuccess();
        apprv1.getError();
        apprv1.getDesiredCarriers();
        apprv1.sendEmail();
        apprv1.getEmailContact();
        
  
}
}