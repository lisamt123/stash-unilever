/********************************************************************
 Name:  FAU_Participant_BioControllerExtension()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class is a Controller Extension for FAU_Participant_Bio                           
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      18/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/

public with sharing class FAU_PArticipant_BioControllerExtension 
{
    // - - - private attributes - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    private ApexPages.StandardController standardController;
    private static PageReference STAY_ON_SAME_PAGE = null;
    private static String LANDING_PAGE = '/apex/FAU_LandingPage?Id=';

    //Constructors
    public FAU_PArticipant_BioControllerExtension(ApexPages.StandardController standardController)
    {
        this.standardController = standardController;
    } 
    
    // Action Methods
    /*******************************************************************
       Purpose:     Saves to the database                                                 
    ********************************************************************/
    public PageReference submitBio()
    { 
        return save();
    }

    /*******************************************************************
       Purpose:     Cancel changes                                              
    ********************************************************************/
    public PageReference cancelBio() 
    { 
        return cancel();
    }


    // - - - private helpers - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   
   /*******************************************************************
       Purpose:     Saves data and redirects to Landing Page                                               
    ********************************************************************/
    private PageReference save()
    { 
        FAU_Participant__c recordToSave = (FAU_Participant__c)this.standardController.getRecord();
        try{
        	if(validate(recordToSave)){
            	update recordToSave;
        	} else {
        		 ApexPages.addMessage(new ApexPages.Message(Apexpages.Severity.ERROR,'All fields are required'));
        		 return null;
        	}
        }
        catch (System.DMLException e) {
            ApexPages.addMessages(e);
            return STAY_ON_SAME_PAGE;
        }

        System.Debug('#### FAU_PArticipant_BioControllerExtension - Id: ' + recordToSave.Id ); 

        PageReference pageRef= Page.FAU_LandingPage;

        pageRef.getParameters().put('Id', recordToSave.Id);

        pageRef.setRedirect(true);
        
        return pageRef;
    }
    
    private Boolean validate(FAU_Participant__c record){
    	return !(String.isBlank(record.FAU_Biography__c) ||
    	String.isBlank(record.FAU_Unilever_Career__c) ||
    	String.isBlank(record.FAU_Prior_Career__c) ||
    	String.isBlank(record.FAU_Education__c) ||
    	String.isBlank(record.FAU_Personal__c));
    }

    /*******************************************************************
       Purpose:     Cancels data and redirects to Landing Page                                               
    ********************************************************************/
    private PageReference cancel()
    { 
        FAU_Participant__c recordToSave = (FAU_Participant__c)this.standardController.getRecord();

        System.Debug('#### FAU_PArticipant_BioControllerExtension - Id: ' + recordToSave.Id ); 
        
        PageReference pageRef= Page.FAU_LandingPage;

        pageRef.getParameters().put('Id', recordToSave.Id);

        pageRef.setRedirect(true);
        
        return pageRef;
    }





}