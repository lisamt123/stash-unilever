@isTest
private class BFM_CPFValidator_Test{   
    private static testMethod void testCPF(){
        list<contact>con=new list<contact>();
        string cpf='87912612017';
        contact con1=new contact();
        con1.LastName='Test';
        con1.BFM_CPF__c=cpf;
        con.add(con1);
     insert con;
    
      BFM_CPFValidator cpfvalidate=new BFM_CPFValidator(cpf);
      cpfvalidate.validateCPF();
      cpfvalidate.getErrorMessage();
      cpfvalidate.getCPF();
    }
}