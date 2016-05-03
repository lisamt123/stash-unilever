@isTest
private class BET_ManageMembersController_Test2 {

  @isTest private static void dummy(){
    System.debug('This class is not used anymore');
    System.assertEquals(2,1+1, 
    	'This test checks if sfdc can add - This class will be deleted post deployment');
  }
      
}