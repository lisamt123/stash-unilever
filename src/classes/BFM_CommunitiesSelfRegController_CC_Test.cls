@isTest
private class BFM_CommunitiesSelfRegController_CC_Test {   
  private static testMethod void testControllerWithMatchingAccount(){
        Test.startTest();
        Account acc = new Account();
        acc.name='carrier';
        acc.cnpj__c = '03189042000100';
        insert acc;
        string testname = 'testname';
        

        list<BFM_UserCreationRequest__c> userlist=new list<BFM_UserCreationRequest__c>();
        list<user> usr=new list<user>();
        BFM_UserCreationRequest__c userreq = new BFM_UserCreationRequest__c();
        userreq.FirstName__c =testname;
        userreq.CPF__c='12345678909';
        userreq.Email__c='test@capg.com';
        userreq.CommunityNickname__c='test879';
        userreq.CNPJ__c='12345678';        
        //insert userreq;
        
        BFM_UserCreationRequest__c userreq1 = new BFM_UserCreationRequest__c();
        userreq1.FirstName__c =testname;
        userreq1.CPF__c='12345678909';
        userreq1.Email__c='test@capg.com';
        userreq1.CommunityNickname__c='test879';
        userreq1.CNPJ__c='12345678';
        
        userlist.add(userreq );
        
        userlist.add(userreq1);
        insert userlist;
         system.assertEquals(testname, userreq.FirstName__c );
        try{
        insert usr;
        }catch(DmlException e){system.debug('test');}
        
        BFM_UserCreationRequest__c userreq2 = new BFM_UserCreationRequest__c();
        userreq2.FirstName__c =testname;
        userreq2.CPF__c='12345678';
        userreq2.Email__c='test@capg.com';
        userreq2.CommunityNickname__c='test';
        userreq2.CNPJ__c='0318';
        insert userreq2;     
        system.assertEquals(testname,userreq2.FirstName__c);
        
        // BFM_CommunitiesSelfRegController_CC controller = new BFM_CommunitiesSelfRegController_CC();
        BFM_CommunitiesSelfRegController_CC controller = new BFM_CommunitiesSelfRegController_CC();
        BFM_CommunitiesSelfRegController_CC controller1 = new BFM_CommunitiesSelfRegController_CC();
        
        
        
        // controller.requestLines.get(acc.Id).isSelected =true;
        controller.firstName='xyz';
        controller.lastName='G';
        controller.cnpj = '03189042';
        controller.cpf='12345678909';
        controller.communityNickname='xyz';
        controller.email='xyz@unilever.com';
        
        
         controller1.firstName='xyz';
        controller1.lastName='G';
        controller1.cnpj = '031';
        controller1.cpf='1234567';
        controller1.communityNickname='rajs';
        controller1.email='xyz@unilever';
        
        controller1.fetchBranches();
        controller1.validateCarrierRequest(userreq);
        controller1.submitNewUserRequest();
        controller1.clearBranchSelection();
        controller1.getDesiredCarriers();
        controller1.resetVF();
         controller1.validateEmail('email');
        
         BFM_CommunitiesSelfRegController_CC.RequestLine wrapreq = new BFM_CommunitiesSelfRegController_CC.RequestLine(true,acc);
         wrapreq.isSelected=true;
      
        BFM_CPFValidator cpfvalidcon = new BFM_CPFValidator('cpf');
        cpfvalidcon.validateCPF();
      
        
        
        BFM_AccountDAO.getAccountsWithCNPJPrefix('03189042');
        controller.fetchBranches();
        controller.validateCarrierRequest(userreq);
        controller.submitNewUserRequest();
        controller.clearBranchSelection();
        controller.getDesiredCarriers();
        controller.resetVF();
        
        controller.validateEmail('email');
        Test.stopTest();
    }
}