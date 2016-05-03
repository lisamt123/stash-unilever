/*
  Class Name: Core_WP_WorkPlaceController
  Author : Mindtree
  Date: 24 Nov 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Common controller class for Workplace App
*/ 
 
public class Core_WP_WorkPlaceController {

    /*******************************************************************
    Purpose: This method get current user's location from helper and send to the Client
    Parameters: 
    Returns: String
    ********************************************************************/ 
    @AuraEnabled
    public static Core_WP_WorkplaceGAWrapperClass getCurrentUserLocation() {
        return Core_WP_WorkPlaceControllerHelper.getCurrentUserLocation();
    } 
    
    /*******************************************************************
    Purpose: This method get the Workplace Id by Name from helper and send to the Client
    Parameters: String workPlaceName
    Returns: String
    ********************************************************************/
    @AuraEnabled
    public static String getWorkplaceIdByName(String workPlaceName) {
        return Core_WP_WorkPlaceControllerHelper.getWorkplaceIdByName(workPlaceName);
    }
    
    /*******************************************************************
    Purpose: This method get the data for WorkplaceDetails from helper and send to the Client
    Parameters: Id workPlaceId
    Returns: Workplace__c 
    ********************************************************************/ 
    @AuraEnabled
    public static Workplace__c getWorkplaceDetails(Id workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getWorkplaceDetails(workPlaceId);
    }
    
    /*******************************************************************
    Purpose: This method get the Key Details for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: String 
    ********************************************************************/
    @AuraEnabled
    public static String getKeyDetails(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getKeyDetails(workPlaceId);
    }
    
    /*******************************************************************
    Purpose: This method get the Department By Floor Details for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: String 
    ********************************************************************/
    @AuraEnabled
    public static String getDepartmentByFloorDetails(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getDepartmentByFloorDetails(workPlaceId);
    }
    
    /*******************************************************************
    Purpose: This method get the Healthy and Safety Details for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: String 
    ********************************************************************/
    @AuraEnabled
    public static String getHealthyAndSafetyDetails(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getHealthyAndSafetyDetails(workPlaceId);
    }
    
    /*******************************************************************
    Purpose: This method get the Gym Schedule Details for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: String  
    ********************************************************************/
    @AuraEnabled
    public static String getGymScheduleDetails(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getGymScheduleDetails(workPlaceId);       
    }
    
    /*******************************************************************
    Purpose: This method get the Shop Timings Details for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: String
    ********************************************************************/
    @AuraEnabled
    public static String getShopTimingsDetails(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getShopTimingsDetails(workPlaceId);
    }
    
    /*******************************************************************
    Purpose: This method get the Transport Details for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: String 
    ********************************************************************/
    @AuraEnabled
    public static String getTransportDetails(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getTransportDetails(workPlaceId);
    }
    
    /*******************************************************************
    Purpose: This method get list of local groups for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: List<CollaborationGroup>
    ********************************************************************/
    @AuraEnabled
    public static List<CollaborationGroup> getLocalGroups(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getLocalGroups(workPlaceId);
    }
    
    /*******************************************************************
    Purpose: This method get the Cafeteria Menu Details for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: string 
    ********************************************************************/
    @AuraEnabled
    public static string getCafeteriaMenuDetails(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getCafeteriaMenu(workPlaceId);
    }
    
    /*******************************************************************
    Purpose: This method get the Sustainability Details for WorkPlace from helper and send to the Client
    Parameters: String workPlaceId
    Returns: Workplace__c 
    ********************************************************************/
    @AuraEnabled
    public static Core_WP_SustaiabilityWrapper getSustainibilityValues(String workPlaceId) {
        return Core_WP_WorkPlaceControllerHelper.getSustainibilityValues(workPlaceId);
    }
}