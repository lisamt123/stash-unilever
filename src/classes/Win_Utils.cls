/*************************************************************** 
    Name: Win_Utils
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Generic Utility Class
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  20/12/2016  Initial Dev     Utility Class
***************************************************************/
public with sharing class Win_Utils {

    public static final String EXCEPTION_LEVEL_ERROR = 'ERROR';
    public static final String EXCEPTION_LEVEL_WARNING = 'WARNING';
    public static final String EXCEPTION_LEVEL_INFO = 'INFO';
    public static final String EXCEPTION_LEVEL_DEBUG = 'DEBUG';

    public static final String APP_NAME = 'WIN';

    /**
     * Default Constructor
     */
    public Win_Utils() {}


    /*********************************************************************************************
        Purpose: Wrap the exception utility
    *********************************************************************************************/
    public static void logException(String className, String methodName, String errorMessage, 
            Exception except, String level) {
        ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), className, methodName, 
            errorMessage, except != null ? except : new Win_Exception(), level, '', '', 0, APP_NAME);
    }

    /*********************************************************************************************
        Purpose: Wrap the exception utility for multiple exceptions
    *********************************************************************************************/
    public static void logExceptions(List<Exception_Log__c> exceptionsToStore) {
        if(exceptionsToStore != null) {
            insert exceptionsToStore;
        }
    }

}