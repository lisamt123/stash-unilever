@isTest
public class SAJ_SessionNotesCTRL_Test {


    public static testMethod void testMyController() {
    Test.startTest();
        
      //  Programme__c fct = new Programme__c(Description__c= 'Test Function');
      // insert fct; 
   
        PageReference pageRef = Page.SAJ_SessionNotes;
        Test.setCurrentPage(pageRef);
              Business_Solution__c bs = new Business_Solution__c(Name ='test app', 
                                                                 //function__c = fct.id, 
                                                                 status__c = 'IPIX Project');  
   
        insert bs;
        
        Design_Challenge__c dc = new Design_Challenge__c(Business_Solution__c = bs.id);
    	insert dc;
       
        Design_Decision__c dd  = new Design_Decision__c(Design_Challenge__c = dc.Id, 
                                                       Business_solution__c = dc.Business_Solution__c);
		insert dd;
        
        Task t = new Task(Business_Solution__c = dc.Business_Solution__c, 
                        WhatId = dc.Id, 
                        Priority = 'Normal', 
                        ownerId=userinfo.getUserId());
        insert t;
        
        
        /////////
        
        //ContentVersion cv = new ContentVersion(Title = 'Design_Checklist_Salesforce_Platform.pdf'); 
        //insert cv;
        //[select id, versionData, contentDocumentId 
          //       Blob b = v.versionData;
          //       guidance=string2HTML(b);
          
        
        
        ///////////
        
        ApexPages.StandardController stdCtrl = new ApexPages.standardController(dc);
        //stdCtrl.
        
        
        
      
        SAJ_SessionNotesCTRL controller = new SAJ_SessionNotesCTRL(stdCtrl);
       
 // controller.decisions
       //   public SAJ_SessionNotesCTRL(Apexpages.StandardController stdCtrl){
       // designChallenge = (Design_Challenge__c)stdCtrl.getRecord();
       // newTask = generateNewTask();
    //}
    
       // String myString = 'testblob \n \r \b';
		//Blob pB = Blob.valueof(myString);
        //String ret = controller.string2HTML(pB);
        // controller.toggleTask = t.id;
        
        pageReference savnextPage = controller.saveNotes();

        System.assertEquals(null, savnextPage);
        
        pageReference copnextPage = controller.copyGuidance2Notes();
  	    System.assertEquals(null, copnextPage);

        pageReference addnextPage = controller.AddDecision();
  	    System.assertEquals(null, addnextPage);
        
         addnextPage = controller.SaveDecisions();
  	    System.assertEquals(null, addnextPage);
         controller.designDecisionRowNum  = 0;
         addnextPage = controller.delDesignDecision();
  	    System.assertEquals(null, addnextPage);
        
        controller.delTaskId =t.id;
        pageReference crenextPage = controller.createTask();
  	    System.assertEquals(null, crenextPage);
    
        crenextPage = controller.removeTask();
  	    System.assertEquals(null, crenextPage);
        
        pageReference tognextPage = controller.toggleStatus();
  	    System.assertEquals(null, tognextPage);
        
        //controller.rerenderTaskLists();
  	   
 	    
        List<SAJ_SessionNotesCTRL.taskWrap> cTlopen = controller.openTasklist;
        List<SAJ_SessionNotesCTRL.taskWrap> cTlclosed = controller.closedTasklist;
        
        
     



        Test.stopTest();  
     }
}