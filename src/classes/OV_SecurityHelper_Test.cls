@isTest (SeeAllData = true)
global class OV_SecurityHelper_Test{

    public static testMethod void runTest(){
         Profile p = [SELECT Id FROM Profile WHERE Name = 'Chatter Only User'];
         User u = OV_TestingHelper.createUser(p, 'test', 'test@mail.com', 'LastName');
         system.runAs(u){
         Boolean isException = false;
         try{
             OV_SecurityHelper.doPrivilegedOp('cec_Store__c', new List<String>{'Country__c'});
         } catch (Exception e){
             isException = true;
         }  
         system.assertEquals(true, isException);
         }
    }
}