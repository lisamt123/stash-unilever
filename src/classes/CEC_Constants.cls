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
1.1      Koti              Dec-2015      Added page size values.
1.2      Masood            Jan-2016      Added static values for TASK and Drafts.
*************************************************************************************/
public with sharing class CEC_Constants {
    public static final String ALERT_ACTION_COUNTRYGROUP = 'CountryChatterGroup';
    public static final String ALERT_ACTION_CATEGORYGROUP = 'CategoryChatterGroup';

    // Alert Action Types.
    public static final String ALERT_ACTION_TYPE_EMAIL = 'Email';
    public static final String ALERT_ACTION_TYPE_CHATTER = 'Chatter Post';
    
    //Page size in CEC_IRIProductLocator.
    public static final String VALUE_FIVE = '5';
    public static final String VALUE_TEN = '10';
    public static final String VALUE_TWENTY = '20';
    public static final String VALUE_THIRTY = '30';
    public static final String VALUE_FOURTY = '40';
    public static final String VALUE_FIFTY = '50';
    public static final String VALUE_ZERO = '0';
    public static final String VALUE_TWO = '2';
    public static final String VALUE_FOUR = '4';
    
    //Constants for CEC_TH1_DraftTrigger
    public static final string DRAFT_STATUS ='Approved';
    public static final string PRIORITY ='High';
    public static final string TASK_STATUS='Not Started';

}