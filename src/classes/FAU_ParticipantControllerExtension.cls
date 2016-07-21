/********************************************************************
 Name:  FAU_ParticipantControllerExtension()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class is a Controller Extension for FourAcresParticipant Visualforce Page                          
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   0.1   Daniel Harfleet   18/09/2014        INITIAL DEVELOPMENT   
   1.0   Daniel Harfleet   18/09/2014        Coding Standards          
***********************************************************************/
public with sharing class FAU_ParticipantControllerExtension
{
  
  public Boolean declineReasonAvailable {get;set;}
  
    public FAU_ParticipantControllerExtension(ApexPages.StandardController standardController)
    {
        this.webinars = new List<FAU_Webinar_Participant__c>();
        this.standardController = standardController;
        addFieldsTo(standardController); 
        this.participant = (FAU_Participant__c)standardController.getRecord();
        this.program = programForParticipant(participant); 
        setStageBasedOnRecord(this.participant);
        this.webinars = webinarsForParticipant(this.participant);
        this.modules = modulesForParticipant(this.participant);
        this.selectedWebinars = new List<String>();
        this.idWebinarMap = new Map<Id, FAU_Webinar_Participant__c>(this.webinars);
        declineReasonAvailable = false;
    }


    // - - - properties - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    public FAU_Participant__c participant { get; set; }


    public FAU_Program__c program { get; set; }


    public String pageState{ get { return stage; } } 


    // - - - properties (related SObjects) - - - - - - - - - - - - - - - - - - - - -

    public List<FAU_Module_Participant__c> modules
    {
        get;set;
    }

    public List<FAU_Webinar_Participant__c> webinars
    {
        get;set;
    }

    // - - - properties for the webinar selection - - - - - - - - - - - - - - - - - - 

    public List<String> selectedWebinars
    {
        get; set;
    }

    /* use this property if you have a webinar selected list which is multiselect=false */
    public String selectedWebinar
    {
        get; set;
    }

    /* use this property if you have a webinar selected list which is multiselect=true */
    public List<SelectOption> webinarOptions
    {
        get{ return buildWebinarOptions(); }
    }


    // - - - Action Methods - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    /*******************************************************************
       Purpose:     Decline invitation and set page stage and Invite State                                              
    ********************************************************************/
    public PageReference declineInvite()
    {
      if(declineReasonAvailable){
          System.debug('Entering FAU_ParticipantControllerExtension.declineInvite');
          FAU_Participant__c recordToSave = (FAU_Participant__c)this.standardController.getRecord();
          if(recordToSave.FAU_Decline_Reason__c == null || recordToSave.FAU_Decline_Reason__c == '--None--') {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Decline reason is mandatory'));
            return null;
          }
          this.stage = STAGE_DECLINED;
      recordToSave.FAU_Invite_State__c = INVITE_STATE_DECLINED;
          System.debug('Exiting FAU_ParticipantControllerExtension.declineInvite');

          return save();
      } else {
        declineReasonAvailable = true;
        return null;
      }
    }

    /*******************************************************************
       Purpose:     Proceed invitation and set stage                                                 
    ********************************************************************/
    public PageReference proceedWithInvitation()
    {
        this.stage = STAGE_PROCEEDING;
        return save();
    }

    /*******************************************************************
       Purpose:     Defer invitation to PA and set page stage and PA                                             
    ********************************************************************/
    public PageReference deferToPA()
    {
        System.debug('Entering FAU_ParticipantControllerExtension.deferToPA');
        this.stage = STAGE_GIVEN_TO_PA;
        FAU_Participant__c recordToSave = (FAU_Participant__c)this.standardController.getRecord();
        recordToSave.FAU_Is_deferred_To_PA__c = true;

        System.debug('Exiting FAU_ParticipantControllerExtension.deferToPA');

        return save();
    }

    /*******************************************************************
       Purpose:     Set the stage to Registering so the screen allows filling                                             
    ********************************************************************/
    public PageReference selfFill()
    {
        this.stage = STAGE_REGISTERING;
        return save();
    }

    /*******************************************************************
       Purpose:     Set the stage ACCEPTED, the registeration details                                             
    ********************************************************************/
    public PageReference acceptInvite()
    {
        System.debug('Entering FAU_ParticipantControllerExtension.acceptInvite');

        this.stage = STAGE_ACCEPTED;
        FAU_Participant__c recordToSave = (FAU_Participant__c)this.standardController.getRecord();
        recordToSave.FAU_Invite_State__c = INVITE_STATE_ACCEPTED;
        PageReference PgRef = save();

        updateSelectedWebinars();

        System.debug('Exiting FAU_ParticipantControllerExtension.acceptInvite');

        return PgRef;
    }

    /*******************************************************************
       Purpose:     Cancel                                             
    ********************************************************************/
    public PageReference cancel()
    { 
        System.debug('Entering FAU_ParticipantControllerExtension.cancel');

        FAU_Participant__c recordToSave = (FAU_Participant__c)this.standardController.getRecord();

        System.Debug('#### FAU_ParticipantControllerExtension - Id: ' + recordToSave.Id ); 

        PageReference pageRef= Page.FAU_LandingPage;

        pageRef.getParameters().put('Id', recordToSave.Id);

        pageRef.setRedirect(true);
        
        System.debug('Exiting FAU_ParticipantControllerExtension.cancel');

        return pageRef;
    }


    // - - - private helpers - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    /*******************************************************************
       Purpose:     Update Webinar Participant to Accepted                                             
    ********************************************************************/
    private void updateSelectedWebinars()
    {
        System.debug('Entering FAU_ParticipantControllerExtension.updateSelectedWebinars');
        if(this.selectedWebinar != null)
        {
            this.selectedWebinars.add(this.selectedWebinar);
        }

        List<FAU_Webinar_Participant__c> updatedWebinars = new List<FAU_Webinar_Participant__c>();
        for(Id webinarId : selectedWebinars)
        {
            FAU_Webinar_Participant__c webinar =  this.idWebinarMap.get(webinarId);
            if(webinar != null)
            {
                webinar.FAU_Has_Accepted__c = true;
                if(webinar.FAU_Webinar__r.FAU_Recordtype_Developer_Name__c == 'FAU_Registration'){
                   webinar.FAU_Status__c = 'Invited';
                } 
                updatedWebinars.add(webinar);
            }
        } 

        update updatedWebinars;

        System.debug('Entering FAU_ParticipantControllerExtension.updateSelectedWebinars updatedWebinars:' + updatedWebinars);
    }

    /*******************************************************************
       Purpose:     Save Record                                           
    ********************************************************************/
    private PageReference save()
    { 
        System.debug('Entering FAU_ParticipantControllerExtension.save');
        FAU_Participant__c recordToSave = (FAU_Participant__c)this.standardController.getRecord();
        try{
            update recordToSave;
        }
        catch (System.DMLException e) {
            ApexPages.addMessages(e);
            if (this.stage == STAGE_GIVEN_TO_PA){
                this.stage = STAGE_PROCEEDING;
                recordToSave.FAU_Is_deferred_To_PA__c = false;
                recordToSave.FAU_Personal_Assistant__c= null;
            }

            return STAY_ON_SAME_PAGE;
        }

        System.debug('Exiting FAU_ParticipantControllerExtension.save');
        return STAY_ON_SAME_PAGE;
    }

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
       Purpose:     This sets the Page status to hide and show different elements on the page                                    
    ********************************************************************/
    private void setStageBasedOnRecord(FAU_Participant__c participant)
    {
        System.debug('Entering FAU_ParticipantControllerExtension.setStageBasedOnRecord inviteState: ' + participant.FAU_Invite_State__c);
     
        String inviteState = participant.FAU_Invite_State__c;
 
        if(inviteState == INVITE_STATE_INVITED)
        {          
            if (participant.FAU_Is_deferred_To_PA__c){
                this.stage = STAGE_REGISTERING;
            }else{
                this.stage = STAGE_INITIAL; 
            }
        }
        else if(inviteState == INVITE_STATE_ACCEPTED)
        {
            this.stage = STAGE_ACCEPTED;
        }
        else if(inviteState == INVITE_STATE_DECLINED)
        {
            this.stage = STAGE_DECLINED;
        }
        else
        {
            stage = 'Not Known';
            System.debug(LoggingLevel.WARN, 'state not known:' + inviteState);
        }
         System.debug('Exiting FAU_ParticipantControllerExtension.setStageBasedOnRecord this.stage: ' + this.stage);
     
    }

    /*******************************************************************
       Purpose:     Return the Program record for a participant                                   
    ********************************************************************/
    private FAU_Program__c programForParticipant(FAU_Participant__c participant)
    {
        System.debug('Entering FAU_ParticipantControllerExtension.programForParticipant participant: ' + participant);

        List<FAU_Program__c> programs = [SELECT Id, Name, FAU_Start_Date__c, FAU_Primary_Location__c, FAU_Invite_Form_Text__c FROM FAU_Program__c WHERE Id = :participant.FAU_Program_Wave__c LIMIT 1];
        if(programs.size() != 1)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ERROR_PROGRAM_NOT_FOUND));
            return null;
        }

        System.debug('Exiting FAU_ParticipantControllerExtension.programForParticipant programs[0]: ' + programs[0]);

        return programs[0];
    }

    /*******************************************************************
       Purpose:     Return the Modules record for a participant                                    
    ********************************************************************/
    private List<FAU_Module_Participant__c> modulesForParticipant(FAU_Participant__c participant)
    {
        return [ SELECT Id, Name, FAU_Module__r.Name FROM FAU_Module_Participant__c 
                    WHERE FAU_Participant__c = :this.participant.Id ORDER BY FAU_Module_Start_Date__c];
    }

    /*******************************************************************
       Purpose:     Return the Webinars record for a participant                                     
    ********************************************************************/
    private List<FAU_Webinar_Participant__c> webinarsForParticipant(FAU_Participant__c participant)
    {
        return [SELECT Id, Name, FAU_Name__c, FAU_Participant__c, FAU_Start_Time__c, FAU_Title__c, FAU_Webinar__r.FAU_Recordtype_Developer_Name__c
         FROM FAU_Webinar_Participant__c WHERE FAU_Participant__c = :participant.Id ORDER BY FAU_Start_Time__c];  
    }

    /*******************************************************************
       Purpose:     Return the Webinars record for a participant                                     
    ********************************************************************/
    private List<SelectOption> buildWebinarOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        for(FAU_Webinar_Participant__c webinar : webinars)
        {

            options.add(new SelectOption(webinar.Id, formatWebinarName(webinar)));
        }
        return options;
    }

    /*******************************************************************
       Purpose:     Return the Webinars Start Date                                     
    ********************************************************************/
    private static String formatWebinarName(FAU_Webinar_Participant__c webinar)
    {
        return '(' + webinar.FAU_Start_Time__c.formatGmt(DATE_FORMAT_STRING) + ') ' 
            + webinar.FAU_Title__c;        
    }


   // - - - private attributes - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


    private ApexPages.StandardController standardController;
    private String stage;
    private Map<Id, FAU_Webinar_Participant__c> idWebinarMap;


    private static String ERROR_PROGRAM_NOT_FOUND = 'Program could not be found for Participant, try clicking on the link again';
    private static List<String> FIELDS = new List<String> { 'FAU_Program_Wave__c', 'FAU_Invite_Status__c', 'FAU_Invite_State__c', 'FAU_User__c', 'FAU_Is_deferred_To_PA__c'};
    private static PageReference STAY_ON_SAME_PAGE = null;
    private static String DATE_FORMAT_STRING = 'EEE dd MMM HH:mm z';

    private static String STAGE_INITIAL = 'Initial';
    private static String STAGE_PROCEEDING = 'Proceeding';
    private static String STAGE_DECLINED = 'Declined';
    private static String STAGE_REGISTERING = 'Registering';
    private static String STAGE_GIVEN_TO_PA = 'WithPA';
    private static String STAGE_ACCEPTED = 'Accepted';

    private static String INVITE_STATE_INVITED = 'Invited';
    private static String INVITE_STATE_ACCEPTED = 'Accepted';
    private static String INVITE_STATE_DECLINED = 'Declined';


}