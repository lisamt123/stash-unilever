/***************************************************************
Name: UL_TeamConcept
Copyright © 2016 Salesforce
======================================================
Purpose:
Validate user role
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Chandra Reddy      21/11/2016        INITIAL DEV       Validate user role.
*****************************************************************/
public with sharing class UL_TeamConcept{
    
    /*******************************************************************
    Purpose: Validate if the user is with Account Manager role
    Version: 1.0
    Parameters: N/A
    Returns: Boolean
    Throws N/A
    ********************************************************************/
    public static Boolean isAccountManager {
        get {
            if(isAccountManager == null) {
                isAccountManager = isUserAccountManager();
            }
            return isAccountManager;
        }
        private set;
    }
    
    /*******************************************************************
    Purpose: Validate if the user is account set manager
    Version: 1.0
    Parameters: N/A
    Returns: Boolean
    Throws N/A
    ********************************************************************/
    public static Boolean isAccountSetManager {
        get {
            if(isAccountSetManager == null) {
                isAccountSetManager = isUserAccountSetManager();
            }
            return isAccountSetManager;
        }
        private set;
    }
    
    /*******************************************************************
    Purpose: Validate if the user is account manager
    Version: 1.0
    Parameters: UserId, Date
    Returns: Boolean
    Throws N/A
    ********************************************************************/
    public static Boolean isUserAccountManager(Id userId, Date referenceDate) {
        Boolean isManager = false;
        
            if(userId != null && referenceDate != null) {
                for(ACCL__Account_Manager__c accM : [SELECT Id FROM ACCL__Account_Manager__c WHERE ACCL__User__c = :userId AND ACCL__Valid_From__c <= :referenceDate AND ACCL__Valid_Thru__c >= :referenceDate AND ACCL__Active__c = TRUE LIMIT 1]) {
                    isManager = true;
                    break;
                }
            }
        return isManager;
    }
    
    /*******************************************************************
    Purpose: Validate if the user is account set manager
    Version: 1.0
    Parameters: UserId, Date
    Returns: Boolean
    Throws N/A
    ********************************************************************/ 
    public static Boolean isUserAccountSetManager(Id userId, Date referenceDate) {
        Boolean isManager = false;
       
            if( userId != null && referenceDate != null) {
                for(ACCL__Account_Set_Manager__c accSM : [SELECT Id FROM ACCL__Account_Set_Manager__c WHERE ACCL__User__c = :userId AND ACCL__Valid_From__c <= :referenceDate AND ACCL__Valid_Thru__c >= :referenceDate AND ACCL__Active__c = TRUE LIMIT 1]) {
                    isManager = true;
                    break;
                }
            
        }

        return isManager;
    }
    
    /*******************************************************************
    Purpose: Validate if the user is account manager
    Version: 1.0
    Parameters: UserId, Date
    Returns: Boolean
    Throws N/A
    ********************************************************************/
    private static Boolean isUserAccountManager() {
        return isUserAccountManager(UserInfo.getUserId(), Date.Today());
    }

    /*******************************************************************
    Purpose: Validate if the user is account set manager
    Version: 1.0
    Parameters: UserId, Date
    Returns: Boolean
    Throws N/A
    ********************************************************************/
    private static Boolean isUserAccountSetManager() {
        return isUserAccountSetManager(UserInfo.getUserId(), Date.Today());
    }

}