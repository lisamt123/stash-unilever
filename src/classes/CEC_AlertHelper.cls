/**********************************************************************
Name:  CEC_AlertHelper
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: An helper class to delete alert tracker items when retention date
is reached or delete the alert tracker which does not have nay alert tracker items
========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Masood Ansari     Feb-2016     INITIAL DEVELOPMENT   

***********************************************************************/
public with sharing class CEC_AlertHelper {
    
/******************************************************************* 
Purpose: 
To calcute the created date
Returns:
Created date on basis of alert retention days specified in custom setting.
********************************************************************/ 
    public date fetchCreatedDate(){
        cec_Org_Settings__c orgSetting = cec_Org_Settings__c.getInstance();
        Double alertRetentionDays = orgSetting.Alert_Retention_Days__c;
        Date alertCreationDate = System.today()- Integer.ValueOf(alertRetentionDays);
        System.debug('@@@alertCreationDatehelper '+alertCreationDate);
        return alertCreationDate;
    }
    
/******************************************************************* 
Purpose: 
To delete alert tracker item
Parameter:
Alert Tracker Item List
********************************************************************/ 
    public void deleteAlertTrackerItem(List<cec_Alert_Tracker_Item__c> alertTrackerItemList){
        list<cec_Alert_Tracker_Item__c> alertTrackerItemToDelete = new list<cec_Alert_Tracker_Item__c>(alertTrackerItemList);
        System.debug('@@@AlertTrackerItemList' + alertTrackerItemToDelete);
        delete alertTrackerItemToDelete;
    }
    
/******************************************************************* 
Purpose: 
To delete alert tracker 
Parameter:
Alert Tracker List
********************************************************************/ 
    public void deleteAlertTracker(List<cec_Alert_Tracker__c> alertTrackerList){
        list<cec_Alert_Tracker__c> alertTrackerToDelete = new list<cec_Alert_Tracker__c>(alertTrackerList);
        System.debug('@@@@@AlertTracker'+alertTrackerToDelete);
        delete alertTrackerToDelete;
    }
}