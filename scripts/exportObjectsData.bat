@echo off
rem ***************************************************************************************************************
rem Description: This bat file used to export aLL IPM NG project Salesforce custom objects data using ANT Targets
rem Author : Velumani Angappan - Cognizant         Version :1.0  	Last Modified Date : 24/10/2015 
rem Note : Below Data extraction scripts need to be executed in sequence as mentioned below
rem ***************************************************************************************************************

::Export 1.IPM Project Template Custom Object Data  
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Project_Template__c -Dsoql="SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,Id,IPM_Category__c,IPM_Project_Type__c,IPM_Project__c,IPM_Template_Complexity__c,IPM_Template_Name__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,SystemModstamp FROM IPM_Project_Template__c limit 100"

::Export 2.IPM Document Template Custom Object Data
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant exportData -propertyfile build.properties -Dobject=IPM_Document_Template__c -Dsoql="SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,Id,IPM_Document_Order__c,IPM_Document_Template_Name__c,IPM_Document_Type__c,IPM_Project_Template__c,IsDeleted,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,SystemModstamp FROM IPM_Document_Template__c limit 100"

::Export 3.IPM Section Custom Object Data
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant exportData -propertyfile build.properties -Dobject=IPM_Section__c -Dsoql="SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,Id,IPM_Document_Template__c,IPM_FunctionalRole__c,IPM_Negotiable__c,IPM_Parent_Section__c,IPM_Section_Help_Text__c,IPM_Section_Label_Type__c,IPM_Section_Name__c,IPM_Section_Sequence__c,IPM_Section_Type__c,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,OwnerId,SystemModstamp FROM IPM_Section__c limit 1000"

::Export 4.PM Task Custom Object Data where RecordType=IPM _Milestones
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant exportData -propertyfile build.properties -Dobject=IPM_Task__c -Dsoql="SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,ExternalField__c,Id,IPM_Active__c,IPM_Assignee__c,IPM_AutoCompletedBySystem__c,IPM_Completed_Date__c,IPM_Completed__c,IPM_Due_Date1__c,IPM_Due_Date__c,IPM_Function__c,IPM_Is_Master__c,IPM_Master_Task__c,IPM_Phase__c,IPM_Project_Document_Section__c,IPM_Project_Template__c,IPM_Project__c,IPM_Section_Number__c,IPM_Section__c,IPM_Task_Complexity__c,IPM_Task_Name__c,IPM_Task_Type__c,IPM_Type_of_Gate__c,IPM_Version_Number__c,IsDeleted,IsSystemGenerated__c,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,RecordTypeId,SystemModstamp FROM IPM_Task__c where IPM_Active__c=true limit 50000"

::Export 5.IPM Milestone Custom Object Data where RecordType=""
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant exportData -propertyfile build.properties -Dobject=IPM_Milestone__c -Dsoql="SELECT BET_Status_Check_Trigger__c,Clone_Record_Id__c,ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,ExternalField__c,Id,IPM_Active__c,IPM_BET__c,IPM_Bosscord_Approval_Date__c,IPM_Category__c,IPM_Completed_On__c,IPM_Completed__c,IPM_Due_Date__c,IPM_is_Master__c,IPM_Market_Type__c,IPM_Milestone__c,IPM_Name__c FROM IPM_Milestone__c where IPM_Active__c=true limit 50000"

::Export 6.IPM Questions Custom Object Data where Is_Master__c=true
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant exportData -propertyfile build.properties -Dobject=IPM_Questionnaire__c -Dsoql="SELECT ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,External_Id__c,Id,IPM_Active_RQS__c,IPM_Comments__c,IPM_GK_Answers__c,IPM_HelpText_Five__c,IPM_HelpText_No__c,IPM_HelpText_Partly__c,IPM_HelpText_Yes__c,IPM_Is_Added_Question__c,IPM_POS_Question_Type__c,IPM_Project_Document_Section__c,IPM_Project__c,IPM_Question_Help_Text__c,IPM_Question__c,IPM_RQS_Gate_Type__c,IPM_RQS_Question_Type__c,IPM_Score__c,IPM_Section_Sequence_Number__c,IPM_Sequence_Number__c,IPM_Show_Create_Link__c,IsDeleted,Is_Master__c,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,RecordTypeId,SystemModstamp FROM IPM_Questionnaire__c where Is_Master__c=true "





