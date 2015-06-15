/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class kof_ContactTriggerHandlerTest {

    static testMethod void testInsert() {
    	kof_Account__c acc1 = new kof_Account__c(Name = 'acc1', BillingCity__c = 'London');
        insert acc1;
        
        Test.startTest();
        kof_Contact__c st1 = new kof_Contact__c(Name = 'sh_1', Organisation__c = acc1.Id);
        kof_Contact__c st2 = new kof_Contact__c(Name = 'sh_2', MailingStreet__c = 'Commercial Street', Organisation__c = acc1.Id);
        insert new List<kof_Contact__c> {st1, st2};
        
        Map<Id, kof_Contact__c> shToVerify = new Map<Id, kof_Contact__c>([SELECT MailingCity__c, MailingStreet__c FROM kof_Contact__c WHERE Id = :st1.Id OR Id = :st2.Id]);
        system.assert(shToVerify.get(st1.Id).MailingCity__c == 'London' && String.isBlank(shToVerify.get(st1.Id).MailingStreet__c));
        system.assert(String.isBlank(shToVerify.get(st2.Id).MailingCity__c) && shToVerify.get(st2.Id).MailingStreet__c == 'Commercial Street');
        
        Test.stopTest();
    }
}