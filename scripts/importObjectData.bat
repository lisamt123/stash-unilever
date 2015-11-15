@echo off
rem ***************************************************************************************************************
rem Description: This bat file used to upsert all IPM NG project Salesforce custom objects data using ANT Targets
rem Author : Velumani Angappan - Cognizant         Version :1.0  	Last Modified Date : 24/10/2015 
rem Note : Below Data extraction scripts need to be executed in sequence as mentioned below
rem ***************************************************************************************************************

::Upsert 1.IPM Project Template Custom Object Data  
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Project_Template__c

::Upsert 2.IPM Document Template Custom Object Data
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant upsertData -propertyfile build.properties -Dobject=IPM_Document_Template__c

::Upsert 3.IPM Section Custom Object Data
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant upsertData -propertyfile build.properties -Dobject=IPM_Section__c

::Upsert 4.PM Task Custom Object Data
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant upsertData -propertyfile build.properties -Dobject=IPM_Task__c

::Upsert 5.IPM Milestone Custom Object Data
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant upsertData -propertyfile build.properties -Dobject=IPM_Milestone__c

::Upsert 6.IPM Questions Custom Object Data
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant upsertData -propertyfile build.properties -Dobject=IPM_Questionnaire__c