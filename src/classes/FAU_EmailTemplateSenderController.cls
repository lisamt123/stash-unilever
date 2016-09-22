/********************************************************************
 Name:  FAU_PArticipant_BioControllerExtension()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class is a Controller Extension for FAU_EmailTemplateSender                             
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      18/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class FAU_EmailTemplateSenderController {
    String idTemplate;

    //Constructor

    public FAU_EmailTemplateSenderController(ApexPages.StandardSetController standardController) {
        this.standardController = standardController;
        //addFieldsTo(standardController);
        
        // commented by Suman Sarita Mahapatra to avoid "Detects when a local variable is declared and/or assigned, but not used." in Sonar.
      // List<SObject> selectedObjects = (List<SObject>) standardController.getSelected();
 
    }
    
    // Getter and Setters
    public String gettemplate() {
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'GET:' + idTemplate));
        
        return idTemplate;   
    }
    
    public void settemplate(String s) {
        system.debug('##### String s: ' + s);
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'SET:' + s));
        
        idTemplate = s;
    }


    /*******************************************************************
       Purpose:     Retrieves the Email Templates avaiable to the user to be placed in a dropdown                                                
    ********************************************************************/
    public List<SelectOption> getMyPersonalTemplateOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for (EmailTemplate t : [
            select Id,Name 
            from EmailTemplate 
            where FolderId = :UserInfo.getUserId()// uncommented by Suman Sarita Mahapatra 28/04/16 to rectify : "Avoid making queries which dont limit the results " in Sonar.
        ]) {
            options.add(new SelectOption(t.Id,t.Name));
        }
        return options; 
    }

    /*******************************************************************
       Purpose:     Send Emails to the selected list using the template selected                                                
    ********************************************************************/
     public PageReference sendEmails() 
    { 
        //system.debug('##### Template ID: ' + selectedTemplateId); 
        system.debug('##### idTemplate: ' + idTemplate);


        if (idTemplate <> null){
            FAU_EmailSender.sendEmailToParticipants((List<FAU_Participant__c>) standardController.getSelected(), (Id) idTemplate);
    
        }else{

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please Select a Template.'));
        }
        return STAY_ON_SAME_PAGE;
    }


// - - - private attributes - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -     
    /*******************************************************************
       Purpose:     %%%%% Is this Needed?                                               
    ********************************************************************/    
   // private void addFieldsTo(ApexPages.StandardController standardController)
   // {
     //   if(!Test.isRunningTest())
       // {
           // standardController.addFields(FIELDS);
       // }
   // }

//Commented by Suman Sarita Mahapatra 28/04/16 to rectify "Avoid unused private methods such as 'addFieldsTo(ApexPages.StandardController)" in Sonar
    
    private ApexPages.StandardSetController standardController;
    private static PageReference STAY_ON_SAME_PAGE = null;
    private static List<String> FIELDS = new List<String> { 'FAU_Program_Wave__c', 'FAU_Email_Address__c', 'FAU_Invite_Status__c', 'FAU_Invite_State__c', 'FAU_User__c', 'FAU_Is_deferred_To_PA__c'};
    
}