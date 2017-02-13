/*************************************************************** 
    Name: Win_IMetadataService
    Copyright © 2016 Accenture
    ======================================================
    Purpose:
    -------
    Interface that contains the methods the Metadata Service must implement 
    to fully describe the objects used in the mobile App.
    ======================================================
    History
    -------
    VERSION     AUTHOR          DATE        DETAIL          Description
    1.0         Nicola Tassini  20/12/2016  Initial Dev     Metadata interface
***************************************************************/
public interface Win_IMetadataService {
    
    /**
     *  Identify the set of objects managed by the mobile app
     *
     *  @returns List of tracked objects (API Names), sorted by priority
     */
    List<String> trackedObjectsAPINames(String appID);
    
    /**
     *  Understand if current user has permissions to access this object
     *
     *  @returns true if user has profile permissions to access the object, false in other case
     */
     Boolean trackedObjectAccessible(String objectAPIName);
     
    /**
     *  Understand if the layout is needed for a particular object
     *
     *  @returns set of tracked objects (API Names)
     */
    Boolean trackedObjectLayouts(String objectAPIName);
    
    /**
     *  Understand if the object needs to be displayed
     *
     *  @returns set of tracked objects (API Names)
     */
    Boolean trackedObjectDisplayable(String objectAPIName);
      
    /**
     *  Understand if the object needs only metadata to be dowloaded
     *
     *  @returns boolean (API Names)
     */
    Boolean trackedObjectOnlyMetadataNeeded(String objectAPIName);
    
    /**
     *  Retrieve the list of custom index configured for this particular object
     *
     *  @returns set of tracked objects (API Names)
     */
    List<String> trackedObjectCustomIndexList(String objectAPIName);
    
    /**
     *  Identify list of fieldsets used by mobile app
     *
     *  @returns list of fieldsets (API Names)
     */
    List<String> trackedObjectFieldSetList(String objectAPIName);
    
    /**
     *  Identify the set of objects managed by the mobile app
     *
     *  @returns set of tracked objects (API Names)
     */
    Map<String, List<String>> trackedObjectFieldSets(String objectAPIName);

    /**
     *  Identify the set of objects managed by the mobile app
     *
     *  @returns set of tracked objects (API Names)
     */
    List<String> trackedObjectHeaderFieldSet(String objectAPIName);
    
    /**
     *  Returns the sObject containing all the default values inside
     */
    sObject trackedObjectDefaultValues(String objectApiName);

    /**
     *  Returns the set of system fields for current object
     */ 
    Set<String> getSystemFieldSet(String ObjectApiName);
    
    /**
     *  Returns all the accessible fields of an object
     */
    List<String> getAllFieldSet(String objectApiName);
    
    /**
     *  Extend the fieldSet in input with the required, references and system fields - avoiding duplicates
     */
    List<String> getFullRecordFieldSet(String objectApiName, List<String> fieldSet);
    
    /**
     *  Filter the list of fields in input checking if they are creatable
     */
    List<String> getCreateableFieldSet(String objectApiName, List<String> fieldSet);
    
    /**
     *  Filter the list of fields in input checking if they are updatable
     */
    List<String> getUpdateableFieldSet(String objectApiName, List<String> fieldSet);
    
    /**
     *  Returns name field for specified object
     */
    String getNameField (String objectApiName);
}