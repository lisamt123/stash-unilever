/**
 * Name:        -   SAFE_Overview_Test
 * @description -   This is the test class for SAFE_Overview_CC Controller
 * @Author      -   Sibatri Ray, Mindtree Ltd     
 */
@isTest
public class SAFE_Overview_Test {
public static SAFE_Overview__c ovr = new SAFE_Overview__c();
public static  ApexPages.StandardController sc = new ApexPages.StandardController(ovr);   
public static   SAFE_Overview_CC p=new SAFE_Overview_CC (sc);
     public static testMethod void testPagination() 
     { 
     SAFE_Overview__c ovrIns=new SAFE_Overview__c( Question__c='Questionaire1',Is_Active__c=true,Description__c='desc1',Sequence_No__c=1);
     insert ovrIns;
     }     
}