@isTest(SeeAllData=false)
public class IPM_CheckRecursive_Test {
    public static testmethod void IPM_CheckRecursive(){
     test.StartTest();

     
     IPM_CheckRecursive.runOnce();
     system.assertEquals(false,IPM_CheckRecursive.run);
     IPM_CheckRecursive.resetCounter();
     system.assertEquals(true,IPM_CheckRecursive.run);
     
     IPM_CheckRecursive.runOnceAgain();
     system.assertEquals(false,IPM_CheckRecursive.runAgain);

     IPM_CheckRecursive.run = false;
     IPM_CheckRecursive.runAgain = false;
     
     
     system.assertEquals(false, IPM_CheckRecursive.runOnce());
     IPM_CheckRecursive.resetCounter();
     system.assertEquals(true, IPM_CheckRecursive.runOnce());
    
     system.assertEquals(false, IPM_CheckRecursive.runOnceAgain());
     
     test.StopTest();
     }
}