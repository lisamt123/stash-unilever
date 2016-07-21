/**
 * Test_AFCallingSchedulable_BrandEstimates: This Test class for AFCallingSchedulable_BrandEstimates apex class
 * @author 
 *
 */
@isTest(SeeAlldata=false)
public class Test_AFCallingSchedulable_BrandEstimates
{    
    Static testMethod void AFCallingSchedulable()
    {
    Test.StartTest();
    AF_BrandEstimate_TriggerDate__c be = new AF_BrandEstimate_TriggerDate__c();
     be.AF_Currency_Uploaded__c = true;
     be.AF_Trigger_Date__c = system.today();
     insert be;
    AFCallingSchedulable_BrandEstimates.start();
    Test.stopTest();
    
    }
}