/***************************************************************
Name: UL_CannibalisationRateController
Copyright © 2016 Salesforce
======================================================
Purpose:
Handle Canniblisation Rate object trigger events
======================================================
History
-------
VERSION     AUTHOR         DATE             DETAIL                 Description
1.0         Omkar Narkar    2/12/2016       Initial Development    Controller extention class for UL_Create_Cannibalisation_Rate VF page
***************************************************************/
public with sharing class UL_CannibalisationRateController{
    
    private final UL_Cannibalisation_Rate__c record;
    
    //Constructor
    public UL_CannibalisationRateController(ApexPages.StandardController stdController) {
        this.record = (UL_Cannibalisation_Rate__c)stdController.getRecord();
    }
    
    public void updateThruDate(){
        record.UL_Valid_Thru__c = record.UL_Valid_From__c;
    }
}