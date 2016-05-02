/*
*       Class Name:CoreNTConstants
*       Author:Mindtree
*       Date:09 May 2014
*       Description : This class holds all the Constant Variables used in Network Tracking
*                     
*/
public with sharing class CoreNTConstants {
    
    /*Import Related Constants*/
    static public String SUCCESS_PAGE = '/apex/CoreNTUpdateProject';
    static public String IMPORT_PAGE = '/apex/CoreNTImport';
    static public String XML_EXTENSION = '.xml';
    static public String IMPORT_TAB = '/apex/CoreNTImport';
    static public String XML_NAMESPACE = 'http://schemas.microsoft.com/project';
    
    static public String PROJECT_TITLE_TAG = 'Title';
    static public String PROJECT_START_DATE_TAG = 'StartDate';
    static public String PROJECT_FINISH_DATE_TAG = 'FinishDate';
    static public String TASKS_TAG = 'Tasks';
    static public String UID_TAG = 'UID';
    static public String PERCENT_WORK_COMPLETE_TAG = 'PercentWorkComplete';
    static public String NAME_TAG = 'Name';
    static public String SUMMARY_TAG = 'Summary';
    static public String CRITICAL_TAG = 'Critical';
    static public String MILESTONE_TAG = 'Milestone';
    static public String OUTLINENUMBER_TAG = 'OutlineNumber';
    static public String PERCENTCOMPLETE_TAG = 'PercentComplete';
    static public String TASK_START_DATE_TAG = 'Start';
    static public String TASK_FINISH_DATE_TAG = 'Finish';
    static public String PREDECESSOR_LINK_TAG = 'PredecessorLink';
    static public String PREDECESSOR_UID_TAG = 'PredecessorUID';
    static public String RESOURCES_TAG = 'Resources';
    static public String INITIALS_TAG = 'Initials';
    static public String EMAIL_ADDRESS_TAG = 'EmailAddress';
    static public String GROUP_TAG = 'Group';
    static public String ASSIGNMENTS_TAG = 'Assignments';
    static public String RESOURCE_UID_TAG = 'ResourceUID';
    static public String TASK_UID_TAG = 'TaskUID';
    
    
    static public String ERROR_MSG_PROJECT_START_DATE_BLANK = 'Project Start Date not mentioned.';
    static public String ERROR_MSG_PROJECT_FINISH_DATE_BLANK = 'Project Finish Date not mentioned.';
    static public String ERROR_MSG_TASK_NAME_BLANK = 'Task Name not provided for Task with Unique Id: ';
    static public String ERROR_MSG_SUMMARY_BLANK = 'Summary value not provided for Task : '; 
    static public String ERROR_MSG_CRITICAL_BLANK = 'Critical value not provided for Task : ';
    static public String ERROR_MSG_MILESTONE_BLANK = 'Milestone value not provided for Task : ';
    static public String ERROR_MSG_PERCENT_COMPLETE_BLANK = 'Percent Complete not provided for the the Task : ';
    static public String ERROR_MSG_TASK_START_DATE_BLANK = 'Start Date not provided for the task: ';
    static public String ERROR_MSG_TASK_FINISH_DATE_BLANK = 'Finish Date not provided for the task: ';
    static public String ERROR_MSG_PREDECESSOR_UID_BLANK = 'PredecessorUID not provided for the task ';
    static public String ERROR_MSG_EMAIL_ADDRESS_BLANK = 'Email Address not provided for the Resource - ';
    static public String ERROR_MSG_GROUP_BLANK = 'Group not provided for Resource - ';
    static public String ERROR_MSG_RESOURCE_UID_BLANK = 'Resource Id not provided for assignment.';
    static public String ERROR_MSG_TASK_UID_BLANK = 'Task Id not provided for assignment.';
    static public String INFO_MSG_MULTIPLE_RESOURCE_ASSIGNMENT = 'Multiple Resource Assignment found for the task - ';
    
    static public String ROLE_PROJECT_MANAGER = 'Project Manager';
    static public String ROLE_TASK_PERFORMER = 'Task Performer';
    static public String ROLE_SENIOR_LEADER = 'Senior Leader';
    
    
}