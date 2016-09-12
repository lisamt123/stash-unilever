/**
 * Name:        -   LimitsDebugUtil_Test
 * @description -   Test class for LimtsDebugUtil.
 * @Author      -   Prafull Choudhary    
 */
@IsTest 
Private class LimitsDebugUtil_Test{
    // Test execution of debug stetments with custom setting flag on
    static testMethod void executeDebugLimits(){
        Governor_Limits_Debug__c debugSetting = new Governor_Limits_Debug__c();
        debugSetting.Active__c = true;
        insert debugSetting;
        
        Test.startTest();
            LimitsDebugUtil.debugLimits(true,'LimtsDebugUtil_Test', 'executeDebugLimits');
            LimitsDebugUtil.debugLimits(true,'LimtsDebugUtil_Test', 'executeDebugLimits');
        Test.stopTest();   
        
        System.assertEquals(Limits.getDMLStatements(), 1); 
            
        
    }    
}