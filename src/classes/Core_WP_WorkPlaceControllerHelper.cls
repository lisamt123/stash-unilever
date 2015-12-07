/**********************************************************************
Name: Core_WP_WorkPlaceControllerHelper
Copyright © 2015 Salesforce
Project:
-------
Unilever Salesforce Engagement

Purpose:
-------
For Workplace App

History
-------
VERSION AUTHOR   DATE       DETAIL               Description
1.0     Mindtree 24/11/2015 INITIAL DEVELOPMENT  Helper class for WorkPlace
***********************************************************************/

public with sharing class Core_WP_WorkPlaceControllerHelper{
         
    /*******************************************************************
    Purpose: This method get current user's location
    Parameters: 
    Returns: String
    ********************************************************************/ 
    public static Core_WP_WorkplaceGAWrapperClass getCurrentUserLocation() {
        User user=[SELECT City FROM User where Id=:Userinfo.getUserId()];
        String strLocation='Kingston';
        if(user.City=='100VE')
            strLocation=user.City;
        List<Workplace__c> workPlace=[SELECT Id,Name FROM Workplace__c Where Name=:strLocation ORDER BY CreatedDate DESC];
        Core_WP_WorkplaceGAWrapperClass workplaceGAWrapperClass = new Core_WP_WorkplaceGAWrapperClass ();
        workplaceGAWrapperClass.workplaceId = String.Valueof(workPlace[0].Id);
        if(!Test.IsRunningTest()) workplaceGAWrapperClass.workplaceGaId = CORE_WorkPlace__c.getInstance('GAId').Text_Value__c;
        else workplaceGAWrapperClass.workplaceGaId='UA-70862899-1';
        workplaceGAWrapperClass.userId = String.Valueof(Userinfo.getUserId());
        return workplaceGAWrapperClass ;
    }
    
    /*******************************************************************
    Purpose: This method get the Workplace Id by Name
    Parameters: String workPlaceName
    Returns: String
    ********************************************************************/
    public static String getWorkplaceIdByName(String workPlaceName) {
        List<Workplace__c> workPlace=[SELECT Id FROM Workplace__c Where Name=:workPlaceName ORDER BY CreatedDate DESC];
        return workPlace[0].Id;
    }
    
    /*******************************************************************
    Purpose: This method get the data for WorkplaceDetails 
    Parameters: Id workPlaceId
    Returns: Workplace__c 
    ********************************************************************/ 
    public static Workplace__c getWorkplaceDetails(String workPlaceId) {
        Workplace__c workPlace=[SELECT Address__c,Location__Latitude__s,Location__Longitude__s,Name,Workplace_Image__c,Workplace_Group__c FROM Workplace__c Where Id=:workPlaceId];//Address__c
        return workPlace;
    }
    
    /*******************************************************************
    Purpose: This method get the Key Details for WorkPlace 
    Parameters: String workPlaceId
    Returns: String 
    ********************************************************************/
    public static String getKeyDetails(String workPlaceId) {
        Workplace__c workPlace=[SELECT Key_Contacts__c FROM Workplace__c Where Id=:workPlaceId];
        return workPlace.Key_Contacts__c;
    }
    
    /*******************************************************************
    Purpose: This method get the Department By Floor Details for WorkPlace 
    Parameters: String workPlaceId
    Returns: String 
    ********************************************************************/
    public static String getDepartmentByFloorDetails(String workPlaceId) {
        Workplace__c workPlace=[SELECT Floor_Plan__c FROM Workplace__c Where Id=:workPlaceId];
        return workPlace.Floor_Plan__c;
    }
    
    /*******************************************************************
    Purpose: This method get the Healthy and Safety Details for WorkPlace 
    Parameters: String workPlaceId
    Returns: String 
    ********************************************************************/
    public static String getHealthyAndSafetyDetails(String workPlaceId) {
        Workplace__c workPlace=[SELECT HealthandSafety__c FROM Workplace__c Where Id=:workPlaceId];
        return workPlace.HealthandSafety__c;
    }
    
    /*******************************************************************
    Purpose: This method get the Gym Schedule Details for WorkPlace 
    Parameters: String workPlaceId
    Returns: String  
    ********************************************************************/
    public static String getGymScheduleDetails(String workPlaceId) {
        Workplace__c workPlace=[SELECT Gym__c FROM Workplace__c Where Id=:workPlaceId];
        return workPlace.Gym__c;
    }
    
    /*******************************************************************
    Purpose: This method get the Shop Timings Details for WorkPlace 
    Parameters: String workPlaceId
    Returns: String
    ********************************************************************/
    public static String getShopTimingsDetails(String workPlaceId) {
        Workplace__c workPlace=[SELECT Shop__c FROM Workplace__c Where Id=:workPlaceId];
        return workPlace.Shop__c;
    }
    
    /*******************************************************************
    Purpose: This method get the Transport Details for WorkPlace 
    Parameters: String workPlaceId
    Returns: String 
    ********************************************************************/
    public static String getTransportDetails(String workPlaceId) {
        Workplace__c workPlace=[SELECT Transport__c FROM Workplace__c Where Id=:workPlaceId];
        return workPlace.Transport__c;
    }
    
    /*******************************************************************
    Purpose: This method get list of local groups for WorkPlace 
    Parameters: String workPlaceId
    Returns: List<CollaborationGroup>
    ********************************************************************/
    public static List<CollaborationGroup> getLocalGroups(String workPlaceId) {
        Workplace__c workPlace=[SELECT Workplace_Local_Groups__c FROM Workplace__c Where Id=:workPlaceId];
        List<String> setGroup=workPlace.Workplace_Local_Groups__c.split(',');
        List<CollaborationGroup> colGroup=[SELECT Id,MemberCount,Name,SmallPhotoUrl FROM CollaborationGroup where Id in:setGroup];
        return colGroup;
    }
    
    /*******************************************************************
    Purpose: This method get the Cafeteria Menu Details for WorkPlace 
    Parameters: String workPlaceId
    Returns: string 
    ********************************************************************/
    public static String getCafeteriaMenu(String workPlaceId) {
         List<Attachment> lstAttachment=[SELECT Id FROM Attachment where parentId =:workPlaceId ORDER BY CreatedDate DESC,BodyLength DESC];
         List<Document> lstDocument;
         Id attachmentId;
         if(lstAttachment.isEmpty()){
            lstDocument=[SELECT Id FROM Document where Name=:'WorkPlaceDefault'];
            attachmentId=lstDocument[0].Id;
            
         }
         else attachmentId=lstAttachment[0].Id;
         String imageURL ='/servlet/servlet.FileDownload?file=';
         String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm() + imageURL + attachmentId;  
         return fullFileURL;  
    }
    
    /*******************************************************************
    Purpose: This method get the Sustainability Details for WorkPlace 
    Parameters: String workPlaceId
    Returns: Workplace__c 
    ********************************************************************/
    public static Core_WP_SustaiabilityWrapper getSustainibilityValues(String workPlaceId) {
        Workplace__c workPlace=[SELECT Name,Sustainability_Month1_Label__c,Sustainability_Month1_Value__c,Sustainability_Month2_Label__c,Sustainability_Month2_Value__c,Sustainability_Month3_Label__c,Sustainability_Month3_Value__c,Sustainability_Target_Value__c,Sustainability_Target_Year_Label__c FROM Workplace__c Where Id=:workPlaceId];
        Core_WP_SustaiabilityWrapper sustaibilityWrapper = new Core_WP_SustaiabilityWrapper();
        sustaibilityWrapper.workplaceName=workPlace.Name;
        sustaibilityWrapper.targetYearLabel=workPlace.Sustainability_Target_Year_Label__c;
        sustaibilityWrapper.targetYearValue=workPlace.Sustainability_Target_Value__c.intValue();
        sustaibilityWrapper.firstMonthLabel=workPlace.Sustainability_Month1_Label__c;
        sustaibilityWrapper.firstMonthValue=workPlace.Sustainability_Month1_Value__c.intValue();
        sustaibilityWrapper.secondMonthLabel=workPlace.Sustainability_Month2_Label__c;
        sustaibilityWrapper.secondMonthValue=workPlace.Sustainability_Month2_Value__c.intValue();
        sustaibilityWrapper.thirdMonthLabel=workPlace.Sustainability_Month3_Label__c;
        sustaibilityWrapper.thirdMonthValue=workPlace.Sustainability_Month3_Value__c.intValue();
        if(!Test.IsRunningTest()) sustaibilityWrapper.sustainabilityPageInfo=CORE_WorkPlace__c.getInstance('SustainabilityMessage').Text_Value__c;
        else sustaibilityWrapper.sustainabilityPageInfo='Energy consumed in Kilowatt-hour per occupant';
        if(!Test.IsRunningTest()) sustaibilityWrapper.monthValueLowColor=CORE_WorkPlace__c.getInstance('MonthValueLowColor').Text_Value__c;
        else sustaibilityWrapper.monthValueLowColor='#50B646';
        if(!Test.IsRunningTest()) sustaibilityWrapper.monthValueHighColor=CORE_WorkPlace__c.getInstance('MonthValueHighColor').Text_Value__c;
        else sustaibilityWrapper.monthValueHighColor='#D62B31';
        if(!Test.IsRunningTest()) sustaibilityWrapper.knowledgeSectionHeader=CORE_Workplace__c.getInstance('KnowledgeSectionHeader').Text_Value__c;
        else sustaibilityWrapper.knowledgeSectionHeader='Did you know!';
        if(!Test.IsRunningTest()) sustaibilityWrapper.knowledgeSectionBody=CORE_Workplace__c.getInstance('KnowledgeSectionBody').Text_Value__c;
        else sustaibilityWrapper.knowledgeSectionBody='Kingston is a zero landfill site!';
        if(!Test.IsRunningTest()) sustaibilityWrapper.tooltipSectionHeader=CORE_Workplace__c.getInstance('TooltipSectionHeader').Text_Value__c;
        else sustaibilityWrapper.tooltipSectionHeader='Top tip!';
        if(!Test.IsRunningTest()) sustaibilityWrapper.tooltipSectionBody=CORE_Workplace__c.getInstance('TooltipSectionBody').Text_Value__c;
        else sustaibilityWrapper.tooltipSectionBody='A tip or a recommendation will come here!';
        return sustaibilityWrapper;
    } 
    
}