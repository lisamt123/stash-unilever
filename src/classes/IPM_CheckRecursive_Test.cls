@isTest(SeeAllData=false)
private class IPM_CheckRecursive_Test {
  private static string METHOD_ALREADY_CALLED='method is already called before';
  private static string VALUE_NOT_RESET='value not reset properly';
    public static testmethod void IPM_CheckRecursive(){
     test.StartTest();

     
     IPM_CheckRecursive.runOnce();
     system.assertEquals(false,IPM_CheckRecursive.run,METHOD_ALREADY_CALLED);
     IPM_CheckRecursive.resetCounter();
     system.assertEquals(true,IPM_CheckRecursive.run,VALUE_NOT_RESET);
     
     IPM_CheckRecursive.runOnceAgain();
     system.assertEquals(false,IPM_CheckRecursive.runAgain,METHOD_ALREADY_CALLED);

     IPM_CheckRecursive.run = false;
     IPM_CheckRecursive.runAgain = false;
     
     
     system.assertEquals(false, IPM_CheckRecursive.runOnce(),METHOD_ALREADY_CALLED);
     IPM_CheckRecursive.resetCounter();
     system.assertEquals(true, IPM_CheckRecursive.runOnce(),VALUE_NOT_RESET);
    
     system.assertEquals(false, IPM_CheckRecursive.runOnceAgain(),METHOD_ALREADY_CALLED);
     
     test.StopTest();
     }
}