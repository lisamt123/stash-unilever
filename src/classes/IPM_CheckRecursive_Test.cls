@isTest(SeeAllData=false)
private class IPM_CheckRecursive_Test {
  private static final String ASSERTION_STRING= 'function not called properly';
    public static testmethod void IPM_CheckRecursive(){
     test.StartTest();

     
     IPM_CheckRecursive.runOnce();
     system.assertEquals(false,IPM_CheckRecursive.run,ASSERTION_STRING);
     IPM_CheckRecursive.resetCounter();
     system.assertEquals(true,IPM_CheckRecursive.run,ASSERTION_STRING);
     
     IPM_CheckRecursive.runOnceAgain();
     system.assertEquals(false,IPM_CheckRecursive.runAgain,ASSERTION_STRING);

     IPM_CheckRecursive.run = false;
     IPM_CheckRecursive.runAgain = false;
     
     
     system.assertEquals(false, IPM_CheckRecursive.runOnce(),ASSERTION_STRING);
     IPM_CheckRecursive.resetCounter();
     system.assertEquals(true, IPM_CheckRecursive.runOnce(),ASSERTION_STRING);
    
     system.assertEquals(false, IPM_CheckRecursive.runOnceAgain(),ASSERTION_STRING);
     
     test.StopTest();
     }
}