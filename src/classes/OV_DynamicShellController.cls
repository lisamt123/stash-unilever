/**********************************************************************
Name: OV_DynamicShellController
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Preview for dynamic reports
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Daniel Harfleet         18/06/2015      INITIAL DEVELOPMENT
1.1 -   Maciej Krol             29/07/2015      CHANGES RELATED TO CONTENT PROXY
**********************************************************************/
public with sharing class OV_DynamicShellController {
    private static final String DEVICE_DESKTOP      = 'Desktop';
    private static final String DEVICE_TABLET       = 'Tablet';
    private static final String DEVICE_MOBILE       = 'Mobile';

    private final OV_Report__c report;    
    public String srcUrl { get; set; }

    public OV_DynamicShellController(ApexPages.StandardController standardController) {
        String deviceType = ApexPages.currentPage().getParameters().get('device');

        if(deviceType != DEVICE_DESKTOP && deviceType != DEVICE_TABLET && deviceType != DEVICE_MOBILE){
            deviceType = DEVICE_DESKTOP;
        }

        this.report = (OV_Report__c)standardController.getRecord();

        OV_Report__c reportFull;
        try {    
            /*SECURITY - CRUD/FLS Enforcement */
            String [] accessFields = new String [] {'Id', 'Desktop_Content_Proxy__r', 'Mobile_Content_Proxy__r', 'Tablet_Content_Proxy__r' };
            OV_SecurityHelper.doPrivilegedOp('OV_Report__c', accessFields);

            String [] proxyAccessFields = new String [] {'Url__c'};
            OV_SecurityHelper.doPrivilegedOp('OV_ContentProxy__c', proxyAccessFields);
            /*SECURITY - CRUD/FLS Enforcement */     

            reportFull = [SELECT Id, Desktop_Content_Proxy__r.Url__c, Mobile_Content_Proxy__r.Url__c, Tablet_Content_Proxy__r.Url__c FROM OV_Report__c WHERE Id = :this.report.Id LIMIT 1];

            if(deviceType == DEVICE_DESKTOP){
                this.srcUrl = reportFull.Desktop_Content_Proxy__r.Url__c;
            }else if(deviceType == DEVICE_MOBILE){
                this.srcUrl = reportFull.Mobile_Content_Proxy__r.Url__c;
            }else if(deviceType == DEVICE_TABLET){
                this.srcUrl = reportFull.Tablet_Content_Proxy__r.Url__c;
            }            
        } catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'OV_DynamicShellController.OV_DynamicShellController.exception:' + e.getMessage());
            ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.WARNING, 'There was a problem trying to load report') );
            this.srcUrl = '';
        }        
    } 
}