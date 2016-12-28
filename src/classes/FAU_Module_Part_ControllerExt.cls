/********************************************************************
 Name:  FAU_Module_Part_ControllerExt()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class is a Controller Extension for FAU_ModuleParticipant                           
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      18/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
public with sharing class FAU_Module_Part_ControllerExt {
    boolean isLocal = false;
    public Boolean isNotCampus {get;set;}
    public Boolean hotelAlreadySetUpInModule {get;set;}
    public Boolean isUL2020 {get;set;}
    public FAU_Module_Participant__c participantmodule { get; set; }
    public FAU_Participant__c participant { get; set; }
    
    // - - - private attributes - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    private ApexPages.StandardController standardController;
    private static String ERROR_PARTICIPANT_NOT_FOUND = 'Participant could not be found for  module Participant';
    private static PageReference STAY_ON_SAME_PAGE = null;  
    private static String LANDING_PAGE = '/apex/FAU_LandingPage?Id=';
    private static List<String> FIELDS = new List<String> { 'FAU_Participant__c','recordType.DeveloperName','FAU_Module__r.FAU_Hotel_Name__c'};
   
  
    
    //Constructors 
    /*******************************************************************
       Purpose:     Sets the isLocal Variable                                                    
    ********************************************************************/
    public FAU_Module_Part_ControllerExt(ApexPages.StandardController standardController)
    {
        /*if(!Test.isRunningTest()){
            standardController.addFields(new List<String>{'FAU_Participant__c'});
        }*/
        addFieldsTo(standardController);

        this.standardController = standardController;
            If ((((FAU_Module_Participant__c)this.standardController.getRecord()).FAU_Is_Local__c) == true){
                isLocal = false;
            }else{
                isLocal = true;
            }  
       
       if(!Test.isRunningTest()) {
            FAU_Module_Participant__c record = (FAU_Module_Participant__c)this.standardController.getRecord();
            if(!String.isBlank(record.FAU_Module__r.FAU_Hotel_Name__c)){
                record.FAU_Hotel_Name__c = record.FAU_Module__r.FAU_Hotel_Name__c;
                hotelAlreadySetUpInModule = true;
                this.standardController = new ApexPages.StandardController(record);
            } else {
                hotelAlreadySetUpInModule = false;
            }
       }
       if(!Test.isRunningTest()) isNotCampus = ((FAU_Module_Participant__c)this.standardController.getRecord()).recordType.DeveloperName != 'FAU_Campus';
       this.participantmodule = (FAU_Module_Participant__c)standardController.getRecord();
       this.participant = participantForParticipantmodule(this.participantmodule); 
       isUL2020 = FAU_Utilities.isRectypeUL2020(this.participant);                     
    } 

    /*******************************************************************
       Purpose:     Return the Participant record for a participant module                                   
    ********************************************************************/
    public FAU_Participant__c participantForParticipantmodule(FAU_Module_Participant__c participantmodule)
    {
        System.debug('Entering FAU_Module_Part_ControllerExt.programForParticipant : ' + participantmodule);

        List<FAU_Participant__c> participant = [SELECT Id, recordtype.name, FAU_Program_Wave__c FROM FAU_Participant__c WHERE Id = :participantmodule.FAU_Participant__c LIMIT 1];
        if(participant.size() != 1)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_PARTICIPANT_NOT_FOUND));
            return null;
        }

        System.debug('Exiting FAU_Module_Part_ControllerExt.programForParticipant programs[0]: ' + participant[0]);

        return participant[0];
    }
    /*******************************************************************
       Purpose:     Saves to the database                                                 
    ********************************************************************/
    public PageReference submitMP()
    { 
        return save();
    }

    /*******************************************************************
       Purpose:     Cancel changes                                              
    ********************************************************************/
    public PageReference cancelMP()
    {  
        return cancel();
    } 
    /*******************************************************************
       Purpose:     Sets the isLocal Variable                                               
    ********************************************************************/
    public PageReference updateisLocal() {
            if ((((FAU_Module_Participant__c)this.standardController.getRecord()).FAU_Is_Local__c) == true){
                isLocal = false;
            }else{
                isLocal = true;
            }
            return null;
    }
    /*******************************************************************
       Purpose:     getter for isLocal                                                
    ********************************************************************/
    public boolean getisLocal() {
        return isLocal;
    }


    // - - - private helpers - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

    /*******************************************************************
       Purpose:     Add fields to standard controller                                        
    ********************************************************************/
    private void addFieldsTo(ApexPages.StandardController standardController)
    {
        if(!Test.isRunningTest())
        {
            standardController.addFields(FIELDS);
        }
    }

    /*******************************************************************
       Purpose:     Saves data and redirects to Landing Page                                               
    ********************************************************************/
    private PageReference save()
    {   
        System.debug('Entering FAU_Module_Part_ControllerExt.save');
        FAU_Module_Participant__c recordToSave = (FAU_Module_Participant__c)this.standardController.getRecord();
        try{
            List<ApexPages.Message> messages = validateCompletion(recordToSave);
            if(messages.isEmpty()){
                update recordToSave;
                FAU_Participant__c recParticipant = [SELECT FAU_UL2020_Travel_details__c from FAU_Participant__c where id IN (SELECT FAU_Participant__c FROM FAU_Module_Participant__c WHERE Id = :recordToSave.Id)];
                recParticipant.FAU_UL2020_Travel_details__c = true;
                update recParticipant; 
            } else {
                for(ApexPages.Message message : messages){
                    ApexPages.addMessage(message);
                }
                return null;
            }
        }catch (System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }

        System.Debug('#### FAU_Module_Part_ControllerExt - Id: ' + recordToSave.Id ); 

        PageReference pageRef= Page.FAU_LandingPage;

        pageRef.getParameters().put('Id', [SELECT Id, FAU_Participant__c FROM FAU_Module_Participant__c WHERE Id = :recordToSave.Id LIMIT 1].FAU_Participant__c);

        pageRef.setRedirect(true);

        System.debug('Exiting FAU_Module_Part_ControllerExt.save');
        
        return pageRef;

    }
    
    private List<ApexPages.Message> validateCompletion(FAU_Module_Participant__c recordToSave){
        List<ApexPages.Message> errorMessages = new List<ApexPages.Message>();
        if(isNotCampus!=null && isNotCampus){
            if(recordToSave.FAU_Accommodation_Type__c == null) errorMessages.add(new ApexPages.Message(Apexpages.Severity.ERROR,'Accommodation Type is mandatory'));
            if(String.isBlank(recordToSave.FAU_Hotel_Name__c) && recordToSave.FAU_Accommodation_Type__c != null && recordToSave.FAU_Accommodation_Type__c != 'Stay Home') errorMessages.add(new ApexPages.Message(Apexpages.Severity.ERROR,'Hotel Name is mandatory'));
        }
        if(recordToSave.FAU_Dietary_Restrictions__c != null){
            if(recordToSave.FAU_Dietary_Restrictions__c.contains('Other')){
                if(String.isBlank(recordToSave.FAU_Dietary_Restrictions_Describe_Other__c)){
                    errorMessages.add(new ApexPages.Message(Apexpages.Severity.ERROR,'Dietary Restrictions (Describe if Other) is mandatory'));
                }
            }
        }
        return errorMessages;
        
    }

    /*******************************************************************
       Purpose:     Cancels data and redirects to Landing Page                                               
    ********************************************************************/
    private PageReference cancel()
    { 
        System.debug('Entering FAU_Module_Part_ControllerExt.cancel');
        FAU_Module_Participant__c recordToSave = (FAU_Module_Participant__c)this.standardController.getRecord();

        PageReference pageRef= Page.FAU_LandingPage;

        pageRef.getParameters().put('Id', recordToSave.FAU_Participant__c);
         
        pageRef.setRedirect(true);

        System.debug('#### FAU_Module_Part_ControllerExt.page URL: ' + pageRef.getUrl());

        System.debug('Exiting FAU_Module_Part_ControllerExt.cancel');
        
        return pageRef;
    }




}