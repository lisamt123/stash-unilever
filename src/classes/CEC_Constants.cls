/***********************************************************************************
Name:  CEC_Constants
Copyright@: 2016  Unilever
====================================================================================
====================================================================================
Purpose: All the constants for CEC app.                                                                                        

=====================================================================================
=====================================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sathish           Dec-2015      New class refactored from CEC_AlertActionHelper Class.   
1.1      Koti              Dec-2015      Added updateInactiveAlertTrackerItems() method.
*************************************************************************************/
public with sharing class CEC_Constants {
	public static final String ALERT_ACTION_COUNTRYGROUP = 'CountryChatterGroup';
	public static final String ALERT_ACTION_CATEGORYGROUP = 'CategoryChatterGroup';

	// Alert Action Types.
	public static final String ALERT_ACTION_TYPE_EMAIL = 'Email';
	public static final String ALERT_ACTION_TYPE_CHATTER = 'Chatter Post';
}