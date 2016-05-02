/*
*       Class Name:CoreNTException
*       Author:Mindtree
*       Date:09 May 2014
*       Description : This class holds all the Exceptions used in Network Tracking
*                     
*/
public with sharing class CoreNTException extends Exception {

    public static final String ERROR_NO_FILE_SELECTED = 'No import XML files selected. Please select an XML file to import'; 
    public static final String ERROR_EMPTY_XML = 'The Project cannot be null. This is a critical error during import of XML. Please try exporting and re-importing';   
    public static final String ERROR_INVALID_XML = 'Import Failed -- Invalid File type.';    
    public static final String ERROR_FILESIZE_TOO_LARGE = 'The XML file is too large.';    
    public static final String ERROR_PROJECT_NAME_BLANK ='Import Failed -- Project Name not provided.';
    public static final String ERROR_INVALID_USER = 'Import Failed -- User does not belong to the Project you are trying to Import. Please try again with a valid User.'; 
    public static final String ERROR_PROLOG = 'Content is not allowed in prolog.';
    public static final String ERROR_NOT_NETWORK_OWNER = 'Dear User, you are not currently marked as Network Owner for this Project in the MS Project being imported. Please define your role as Network Owner in the MS project Resources and re-import the project.';
    

}