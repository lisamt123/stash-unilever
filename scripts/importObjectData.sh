#!/bin/sh
## Description: This shell script file used to upsert all IPM NG project Salesforce custom objects data using ANT Targets
## Usage:  ed from ANT/Jenkins Jobs
## Author : Velumani Angappan - Cognizant         Version :1.0  	Last Modified Date : 24/10/2015 
##

#Upsert 1.IPM Project Template Custom Object Data  

ant upsertData -propertyfile build.properties -Dobject=IPM_Project_Template__c

#Upsert 2.IPM Document Template Custom Object Data

ant upsertData -propertyfile build.properties -Dobject=IPM_Document_Template__c

#Upsert 3.IPM Section Custom Object Data
 
ant upsertData -propertyfile build.properties -Dobject=IPM_Section__c

#Upsert 4.PM Task Custom Object Data
 
ant upsertData -propertyfile build.properties -Dobject=IPM_Task__c

#Upsert 5.IPM Milestone Custom Object Data
 
ant upsertData -propertyfile build.properties -Dobject=IPM_Milestone__c

#Upsert 6.IPM Questions Custom Object Data
 
ant upsertData -propertyfile build.properties -Dobject=IPM_Questionnaire__c