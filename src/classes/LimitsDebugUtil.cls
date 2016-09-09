/**
 * Name:        -   LimitsDebugUtil
 * @description -   This is a class with Utility method to debug platform limits at the start and end of the methods
 *                  in all the other apex classes in the org
 * @Author      -   Prafull Choudhary    
 */

Public with sharing class LimitsDebugUtil{
    private static Governor_Limits_Debug__c debugFlag;
    /**
     * @date        -   19/08/2016
     * @description -   Static method to be called from all the methods at start and end to debug governer limts. 
     * @param       -   boolean true if start of the else false, name of the class, name of the method  
     * @return      -   None
     */ 
     
    public static void debugLimits(boolean startOfMethod, string className, string methodName){
        
        //Check if debug statements should be executed.
        
        if(debugFlag == null){
            debugFlag = Governor_Limits_Debug__c.getOrgDefaults();
        }
        
        if(debugFlag.Active__c){ 
            string startString = startOfMethod ? 'Starting ': 'Ending ';
            system.debug('************'+startString + 'Debug for class ' +className + ' method ' +methodName +'***************');
            System.debug('************CPU Usage in milliseconds ' + Limits.getCpuTime());
            System.debug('************CPU Limit in milliseconds ' + Limits.getLimitCpuTime());
            System.debug('************SOQL Usage ' + Limits.getQueries());
            System.debug('************SOQL Limit ' + Limits.getLimitQueries());
            System.debug('************SOQL Rows Usage ' + Limits.getQueryRows());
            System.debug('************SOQL Rows Limit ' + Limits.getLimitQueryRows());
            System.debug('************Callout Usage ' + Limits.getCallouts());
            System.debug('************Callout Limit ' + Limits.getLimitCallouts());
            System.debug('************DML Rows Usage ' + Limits.getDMLRows());
            System.debug('************DML Rows Limit ' + Limits.getLimitDMLRows());
            System.debug('************DML Statement Usage ' + Limits.getDMLStatements());
            System.debug('************DML Statement Limit ' + Limits.getLimitDMLStatements());  
        }        
    }
}