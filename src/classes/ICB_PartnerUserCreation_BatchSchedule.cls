/**********************************************************************
Name: ICB_ContactParnerUserCreation
Copyright © 2016 Unilever

Purpose: Class to create Community Users when new contacts are created.

History 

VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	CARLOS HENRIQUE  25/08/2016  INITIAL DEVELOPMENT.
***********************************************************************/
global with sharing class ICB_PartnerUserCreation_BatchSchedule implements Schedulable {

    global void execute(SchedulableContext schContext) 
    {
        ICB_ContactPartnerUserCreation.getInstance().userCreation();
    }
    
}