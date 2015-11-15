@echo off
rem ***************************************************************************************************************
rem Description: This bat file used to upsert all IPM NG project Salesforce custom setting data using ANT Targets
rem Author : Velumani Angappan - Cognizant         Version :1.0  	Last Modified Date : 24/10/2015 
rem ***************************************************************************************************************

::Upsert IPM BET Search Custom Setting  
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_BET_Search_Fields__c

::Upsert IPM Category Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant upsertData -propertyfile build.properties -Dobject=IPM_Category__c

::Upsert IPM CMI Color Mapping Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_CMI_Color_Mapping__c

::Upsert IPM CMI Overall Color Mapping Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_CMI_Overall_Color_Mapping__c

::Upsert IPM CompanyCard Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_CompanyCard__c

::Upsert IPM CoreParameter Configuration Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_CoreParameter_Configration__c

::Upsert IPM CoreParameter Graph Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Coreparameter_Graph__c 

::Upsert IPM CoreParameter Questions Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_CoreParameter_Questions__c

::Upsert IPM CoreParameter Strategic help content Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_CoreParameter_Strategic_help_content__c

::Upsert IPM Customer Channel Priority Order Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Customer_Channel_Priority_Order__c

::Upsert IPM Gate CMI KPI Inputs Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Gate_CMI_KPI_Inputs__c

::Upsert IPM Gate Document Section Access Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Gate_Document_Section_Access__c

::Upsert IPM InnovationRenovation Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_InnovationRenovation__c

::Upsert IPM Market Cluster Short Names Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Market_Cluster_Short_Names__c

::Upsert IPM MCO Short Names Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_MCO_Short_Names__c

::Upsert IPM No Notifications Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_No_Notifications__c

::Upsert IPM OTIF Status Custom Setting
call ant upsertData -propertyfile build.properties -Dobject=IPM_OTIF_Status__c

::Upsert IPM POS RQS Mapping Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_POS_RQS_Mapping__c

::Upsert IPM Project MetaData Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_ProjectMetadata__c

::Upsert IPM Project Type Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Project_Type__c

::Upsert IPM Reporting Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Reporting__c

::Upsert IPM Section Copy Mapping Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Section_Copy_Mapping__c

::Upsert IPM BET Valid Categories Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_BET_Valid_Categories__c

::Upsert IPM_Rollout FL Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Rollout_FL_Setting__c

::Upsert IPM Roll-out PL Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant upsertData -propertyfile build.properties -Dobject=IPM_Rollout_PL_Setting__c