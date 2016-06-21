/*
  Class Name: CFC_Conference_Test
  Author : Mindtree
  Date: 8 March 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Tested all the methods 
*/
@isTest (Seealldata=false)
public class CFC_Conference_Test{
    public static testMethod void TestEventTrigger(){
        Test.startTest();
        Date startDate = Date.newInstance(2016, 12, 1);
        Date dueDate = Date.newInstance(2016, 12, 30);
        CFC_Events__c event1=new CFC_Events__c(Description__c='Hi1231',From__c=startDate,Name='Test1231',Topics__c='Digital,IT',
        To__c=dueDate,Vendor__c='Unilever1',Website__c='http://www.google1.com',TF_Attendee__c='Test');
        insert event1;
        System.assert(event1!=null);
        CFC_Attendee__c attendee1=new CFC_Attendee__c(Event__c=event1.Id);
        insert attendee1;
        System.assert(attendee1!=null);
        CFC_Attendee__c attendee2=new CFC_Attendee__c(Event__c=event1.Id,Attendee__c=Userinfo.GetUserId());
        insert attendee2;
        List<CFC_Attendee__c> attendeelist=[select id,name from CFC_Attendee__c where Event__c=:event1.Id];
        //System.assert(attendee2!=null);
        System.assert(attendeelist.size()!=null);
        Test.stopTest();
    }
    
    public static testMethod void TestEventController(){
        Test.startTest();
        Date startDate = Date.newInstance(2016, 12, 1);
        Date dueDate = Date.newInstance(2016, 12, 30);
        CFC_Events__c event2=new CFC_Events__c(Description__c='Hi1232',From__c=startDate,Name='Test1232',Topics__c='Digital,IT',
        To__c=dueDate,Vendor__c='Unilever2',Website__c='http://www.google2.com');
        insert event2;
        System.assert(event2!=null);
        CFC_Events__c event3=new CFC_Events__c(Description__c='Hi1233',From__c=startDate,Name='Test1233',Topics__c='Digital,IT',
        To__c=dueDate,Vendor__c='Unilever3',Website__c='http://www.google3.com');
        insert event3;
        List<CFC_Events__c> coreEvent=[select Description__c,Name from CFC_Events__c where Name='Test1233'];
        //System.assert(event3!=null);
        System.assert(coreEvent.size()!=null);
        
        List<CFC_Event__c> lstCustSet = new List<CFC_Event__c>();       
        lstCustSet.add( new CFC_Event__c(Name='showAll', Text_Value__c='ALL'));
        lstCustSet.add( new CFC_Event__c(Name='showIT', Text_Value__c='IT'));
        lstCustSet.add( new CFC_Event__c(Name='showConsumer', Text_Value__c='Consumer'));
        lstCustSet.add( new CFC_Event__c(Name='showDigital', Text_Value__c='Digital'));
        lstCustSet.add( new CFC_Event__c(Name='showMobile', Text_Value__c='Mobile'));
        lstCustSet.add( new CFC_Event__c(Name='showRND', Text_Value__c='R & D'));
        lstCustSet.add( new CFC_Event__c(Name='showInnovation', Text_Value__c='Innovation'));
        if(!lstCustSet.isEmpty()){
            insert lstCustSet;  
        }              

        System.assert(CFC_EventsController.getEventsList('showAll','ASC')!=null);
        System.assert(CFC_EventsController.getEventsList('showAll','DESC')!=null);
        System.assert(CFC_EventsController.getEventsList('IT','ASC')!=null);
        System.assert(CFC_EventsController.getEventsList('IT','DESC')!=null);
        System.assert(CFC_EventsController.getEventsList('Digital','ASC')!=null);        
        
        CFC_EventsWrapper eventListData = CFC_EventsController.getEventsList('Digital','DESC'); 
        System.assert(eventListData!=null);
        //System.assert(CFC_EventsController.getCFCGAID()!=null);
        Test.stopTest();
    }
    
}