/**********************************************************************
Name: OV_WithoutSharingService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class/service for operations on objects that user cant do because of sharing rules.
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             13/10/2015      INITIAL DEVELOPMENT
**********************************************************************/
public without sharing class OV_WithoutSharingService {
    /*******************************************************************
    Purpose: Method for modifying views counter
    Parameters: [String reportId]
    Throws [Exceptions]: [optional]
    ********************************************************************/
	public static void increaseViewsCounter(OV_Report__c report){
        System.debug(LoggingLevel.DEBUG, 'Entering increaseViewsCounter in class without sharing:');

        report.Views__c = (report.Views__c == null) ? 1 : report.Views__c + 1;
        update report;
               
        System.debug(LoggingLevel.DEBUG, 'Exiting increaseViewsCounter in class without sharing');
    }
}