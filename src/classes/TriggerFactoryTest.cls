/**********************************************************************
Name: TriggerFactoryTest
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for TriggerFactory
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -                           22/07/2016      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class TriggerFactoryTest {
    static testmethod void testGetHandler(){
        TriggerFactory.getHandler(FAU_Participant__c.sObjectType);
        TriggerFactory.getHandler(FAU_Program__c.sObjectType);
        TriggerFactory.getHandler(Oblix_SOW_Projects__c.sObjectType);
        TriggerFactory.getHandler(Oblix_Marketing_SOW_Project_Splits__c.sObjectType);
        TriggerFactory.getHandler(Marketing_SOW__c.sObjectType);
        TriggerFactory.getHandler(Oblix_Project_Assets__c.sObjectType);
        TriggerFactory.getHandler(Oblix_User_Permission__c.sObjectType);
        TriggerFactory.getHandler(FAU_Webinar_Participant__c.sObjectType);
        TriggerFactory.getHandler(FAU_Module__c.sObjectType);
        TriggerFactory.getHandler(FAU_Milestone__c.sObjectType);
        TriggerFactory.getHandler(FAU_Webinar__c.sObjectType);
        TriggerFactory.getHandler(IPM_User_Profile__c.sObjectType);
        TriggerFactory.getHandler(IPM_Company_Card__c.sObjectType);
        TriggerFactory.getHandler(IPM_Country__c.sObjectType);
        TriggerFactory.getHandler(IPM_Project_Resource__c.sObjectType);
        TriggerFactory.getHandler(IPM_Project_Document__c.sObjectType);
        TriggerFactory.getHandler(IPM_Project_Document_Section_Content__c.sObjectType);
        TriggerFactory.getHandler(IPM_Milestone__c.sObjectType);
        TriggerFactory.getHandler(IPM_Task__c.sObjectType);
        TriggerFactory.getHandler(IPM_Project__c.sObjectType);
        TriggerFactory.getHandler(IPM_Financial__c.sObjectType);
        TriggerFactory.getHandler(IPM_Financial_Year__c.sObjectType);
        TriggerFactory.getHandler(IPM_Project_Rollout__c.sObjectType);
        TriggerFactory.getHandler(IPM_Assessment__c.sObjectType);
        TriggerFactory.getHandler(IPM_Project_Document_Section__c.sObjectType);
        TriggerFactory.getHandler(Core_Approval_Details__c.sObjectType);
        TriggerFactory.getHandler(CFC_Attendee__c.sObjectType);
        TriggerFactory.getHandler(VEP_Visitor__c.sObjectType);
        TriggerFactory.getHandler(AF_Agency_Estimate__c.sObjectType);
        TriggerFactory.getHandler(AF_Bonus_Results__c.sObjectType);
        TriggerFactory.getHandler(AF_Bonus_Threshold__c.sObjectType);
        TriggerFactory.getHandler(AF_Brand_Estimate__c.sObjectType);
        TriggerFactory.getHandler(AF_Currency__c.sObjectType);
        TriggerFactory.getHandler(AF_OOPS_Actual__c.sObjectType);
        TriggerFactory.getHandler(AF_OOPS_Estimate__c.sObjectType);
        TriggerFactory.getHandler(AF_Sub_Result__c.sObjectType);
        TriggerFactory.getHandler(AF_Bonus_Matrix__c.sObjectType);
        TriggerFactory.getHandler(AF_PO_Report__c.sObjectType);
        ITrigger iTriggerMacro = TriggerFactory.getHandler(Macro.sObjectType);
        System.assertEquals(null, iTriggerMacro);
        try {
            TriggerFactory.createHandler(Macro.sObjectType);
        } catch (Exception e) {
            System.assertEquals('No Trigger Handler registered for Object Type: Macro',e.getMessage(),'We should not find a trigger handler for the Macro standard object');
        }
    }
 
}