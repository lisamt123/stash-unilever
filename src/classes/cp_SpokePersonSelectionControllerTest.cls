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
private class cp_SpokePersonSelectionControllerTest {

    static testMethod void testAddToList() {
    	cp_Event__c event = buildGlobalEvent();
    	cp_ULE_Contact__c  contact1 = buildRepContact('test1');
    	cp_ULE_Contact__c  contact2 = buildRepContact('test1');
    	Test.startTest();
    	   ApexPages.StandardController stdController = new ApexPages.StandardController(event);
    	   cp_SpokePersonSelectionController ext         = new cp_SpokePersonSelectionController(stdController);
    	   ext.selectedContacts.add( ext.allContacts[0]);
    	   ext.OnSave();
    	Test.stopTest();
    	cp_Event__c anEvent = [Select Id, (Select id, Event__c,UnileverLeadershipExecutive__c, 
                                                UnileverLeadershipExecutive__r.Name from ULE_Event_Reps__r) 
                              from  cp_Event__c 
                             where Id = :event.id];
        System.assertEquals(anEvent.ULE_Event_Reps__r.size(), 1);
    }
    
    static testMethod void testRemovefromList() {
        cp_Event__c event = buildGlobalEvent();
        cp_ULE_Contact__c  contact1 = buildRepContact('test1');
        cp_ULE_Contact__c  contact2 = buildRepContact('test1');
        buildULE(contact2.Id,event.Id);
        Test.startTest();
           ApexPages.StandardController stdController = new ApexPages.StandardController(event);
           cp_SpokePersonSelectionController ext         = new cp_SpokePersonSelectionController(stdController);
           ext.selectedContacts[0] = ext.allContacts[0];
           ext.OnSave();
        Test.stopTest();
        cp_Event__c anEvent = [Select Id, (Select id, Event__c,UnileverLeadershipExecutive__c, 
                                                UnileverLeadershipExecutive__r.Name from ULE_Event_Reps__r) 
                              from  cp_Event__c 
                             where Id = :event.id];
        System.assertEquals(anEvent.ULE_Event_Reps__r.size(), 1);
    }
    
    public static cp_ULE__c buildULE(Id contactId, Id eventId) {
    	cp_ULE__c ule = new cp_ULE__c(UnileverLeadershipExecutive__c = contactId, Event__c = eventId);
    	insert ule;
    	return ule;
    }
    
    public static cp_ULE_Contact__c buildRepContact(String name) {
    	cp_ULE_Contact__c contact = new cp_ULE_Contact__c(Name=name, FirstName__c='firstName', Active_ULE__c = true);
    	insert contact;
    	return contact;
    }
    
     public static cp_Event__c buildGlobalEvent() {
        cp_Event__c event = new cp_Event__c(Activity_Status__c = cp_EventTriggerHandler.EVENT_STATUS_DRAFT,
                                      Global_Events__c   = true,
                                      Self_Reference__c  = '',
                                      Parent_Event__c    = null);
        insert event;
        return event;
    }
}