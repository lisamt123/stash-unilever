@echo off
rem ***************************************************************************************************************
rem Description: This bat file used to export aLL IPM NG project Salesforce custom setting data using ANT Targets
rem Author : Velumani Angappan - Cognizant         Version :1.0  	Last Modified Date : 24/10/2015 
rem ***************************************************************************************************************

::Export IPM BET Search Custom Setting  
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_BET_Search_Fields__c -Dsoql="SELECT CreatedById,CreatedDate,Field_Label__c,Field_Name__c,Id,IsDeleted,Is_Date__c,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_BET_Search_Fields__c limit 100"

::Export IPM Category Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample  
call ant exportData -propertyfile build.properties -Dobject=IPM_Category__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_Market__c,IPM_Sub_Sector__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_Category__c limit 100"

::Export IPM CMI Color Mapping Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_CMI_Color_Mapping__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_CMI_Color_Value__c,IPM_CMI_Color__c,IPM_Color_Score_Value__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_CMI_Color_Mapping__c limit 100"

::Export IPM CMI Overall Color Mapping Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_CMI_Overall_Color_Mapping__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_CMI_Gate__c,IPM_CMI_Input_Combination__c,IPM_CMI_Overall_Score_Colour__c,IPM_CMI_Overall_Score__c,IPM_CMI_Test__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_CMI_Overall_Color_Mapping__c limit 100"

::Export IPM CompanyCard Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_CompanyCard__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_Country__c,IPM_Global__c,IPM_Local__c,IPM_Market_Cluster__c,IPM_MCO__c,IPM_Multiple_Geographical_Scope__c,IPM_Multiple_Managed_Catagory__c,IPM_Regional__c,IPM_Single_Geographical_Scope__c,IPM_Single_Managed_Catagory__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_CompanyCard__c limit 100"

::Export IPM CoreParameter Configuration Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_CoreParameter_Configration__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_Additional_Parameters__c,IPM_BET__c,IPM_CVP__c,IPM_ET__c,IPM_FastTrack__c,IPM_Help_Text_Two__c,IPM_Help_Text__c,IPM_MPA__c,IPM_Strategic_Intent__c,IPM_WhiteSpace__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,Project_Type__c,SetupOwnerId,SystemModstamp FROM IPM_CoreParameter_Configration__c limit 100"

::Export IPM Coreparameter Graph Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Coreparameter_Graph__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_Base_Improvement__c,IPM_Base_New_Benefit__c,IPM_Base_New_Core_Product__c,IPM_Base_No_Change__c,IPM_Base_Operational__c,IPM_Base_Variant__c,IPM_BLG_Improvement__c,IPM_BLG_New_Benefit__c,IPM_BLG_New_Core_Product__c,IPM_BLG_No_Change__c,IPM_BLG_Variant__c,IPM_CVP__c,IPM_ET__c,IPM_Incremental_Improvement__c,IPM_Incremental_New_Benefit__c,IPM_Incremental_New_Core_Product__c,IPM_Incremental_No_Change__c,IPM_Incremental_Operational__c,IPM_Incremental_Variant__c,IPM_Next_Generation_Improvement__c,IPM_Next_Generation_New_Benefit__c,IPM_Next_Generation_New_Core_Product__c,IPM_Next_Generation_No_Change__c,IPM_Next_Generation_Operational__c,IPM_Next_Generation_Variant__c,IPM_Radical_Improvement__c,IPM_Radical_New_Benefit__c,IPM_Radical_New_Core_Product__c,IPM_Radical_No_Change__c,IPM_Radical_Operational__c,IPM_Radical_Variant__c,IPM_Strategic_Intent__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_Coreparameter_Graph__c limit 100"

::Export IPM CoreParameter Questions Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_CoreParameter_Questions__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_BLG__c,IPM_Innovation_Renovation__c,IPM_Operational__c,IPM_Option__c,IPM_Project_Type__c,IPM_Question_Number__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_CoreParameter_Questions__c limit 100"

::Export IPM CoreParameter Strategic help content Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_CoreParameter_Strategic_help_content__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_BLGPartTwo__c,IPM_BLG__c,IPM_InnovationPartTwo__c,IPM_Innovation__c,IPM_Operational_Part_Two__c,IPM_Operational__c,IPM_RenovationPartTwo__c,IPM_Renovation__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_CoreParameter_Strategic_help_content__c limit 100"

::Export IPM Customer Channel Priority Order Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Customer_Channel_Priority_Order__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,Priority_Order_Value__c,SetupOwnerId,SystemModstamp FROM IPM_Customer_Channel_Priority_Order__c limit 100"

::Export IPM Gate CMI KPI Inputs Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Gate_CMI_KPI_Inputs__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_Inputs__c,IPM_KPI__c,IPM_Overall_Colour_Score_Method__c,IPM_Overall_Score_Label__c,IPM_Test__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_Gate_CMI_KPI_Inputs__c limit 100"

::Export IPM Gate Document Section Access Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Gate_Document_Section_Access__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_Gate_Document_Section_Access_1__c,IPM_Gate_Document_Section_Access_2__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_Gate_Document_Section_Access__c limit 100"

::Export IPM InnovationRenovation Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_InnovationRenovation__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_CVP__c,IPM_ET__c,IPM_Innovation__c,IPM_Renovation__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_InnovationRenovation__c limit 100"

::Export IPM Market Cluster Short Names Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Market_Cluster_Short_Names__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,Short_Name__c,SystemModstamp,Unilever_Cluster__c FROM IPM_Market_Cluster_Short_Names__c limit 100"

::Export IPM MCO Short Names Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_MCO_Short_Names__c -Dsoql="SELECT Country_Group__c,CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,Short_Name__c,SystemModstamp FROM IPM_MCO_Short_Names__c limit 100"

::Export IPM No Notifications Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_No_Notifications__c -Dsoql="SELECT CreatedById,CreatedDate,Disabled__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_No_Notifications__c limit 100"

::Export IPM OTIF Status Custom Setting
call ant exportData -propertyfile build.properties -Dobject=IPM_OTIF_Status__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IPM_Carry_GK_Section_Answer__c,IPM_External_Id__c,IPM_Gate_Document_Type__c,IPM_Section_Number__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,OTIF_HelpText_Amber__c,OTIF_HelpText_Green__c,OTIF_HelpText_Red__c,OTIF_Help_Text__c,OTIF_Measure__c,OTIF_No_of_Status__c,OTIF_Responsibility__c,OTIF_Sequence_Number__c,OTIF_Status__c,SetupOwnerId,SystemModstamp FROM IPM_OTIF_Status__c limit 100"

::Export IPM POS RQS Mapping Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_POS_RQS_Mapping__c -Dsoql="SELECT Charter__c,Contract__c,CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,Score__c,SetupOwnerId,SystemModstamp FROM IPM_POS_RQS_Mapping__c limit 100"

::Export IPM Project MetaData Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_ProjectMetadata__c -Dsoql="SELECT BET__c,CreatedById,CreatedDate,Id,IPM_ApplicableCompanyCard__c,IPM_ApplicableGateKeepingModels__c,IPM_Applicable_Phases__c,IPM_Charter_Question_Applicable__c,IPM_Charter_Question_HelpText__c,IPM_DefaultComplexity__c,IPM_DefaultPhase__c,IPM_Default_GateKeeping_Model__c,IPM_FastTrackApplicable__c,IPM_GateKeepingHelpText__c,IPM_GatekeepingModelsApplicable__c,IPM_MadatoryFields__c,IPM_MultipleBrandPosApplicable__c,IPM_ProjectSubType__c,IPM_Project_Span__c,IPM_Project_Type__c,IPM_SubProjectHelpText__c,IPM_TargetLaunchDateDuration__c,IPM_WhiteSpaceApplicable__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_ProjectMetadata__c limit 100"

::Export IPM Project Type Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Project_Type__c -Dsoql="SELECT CreatedById,CreatedDate,Document_Name__c,EcoDesign_Sync_Wait_Time__c,Id,Independent_Project__c,IPM_CompanyCard__c,IPM_CopyMilestoneToGlobal__c,IPM_CopyMilestoneToLocal__c,IPM_CopyMilestoneToRegional__c,IPM_CopyPhase2Global__c,IPM_CopyPhase2Local__c,IPM_CopyPhase2Regional__c,IPM_Copy_Over_Assessments__c,IPM_CreateFinancials__c,IPM_CreateLocalProjectOnStatusChange__c,IPM_CreateLocalProjects__c,IPM_CreateRegionalProjectOnStatusChange__c,IPM_CreateRegionalProjects__c,IPM_Dont_Set_Sync_Flags__c,IPM_Dont_Sync_Proj_To_EcoDesign__c,IPM_EcoDesign_Document_Name__c,IPM_EcoDesign_Sync_Wait_Time__c,IPM_Fast_Forward_Phase_Change__c,IPM_FinancialGateApprovalIndicator__c,IPM_FinancialsInsertPostfix__c,IPM_FinancialsInsertRecordType__c,IPM_FinancialsUpdatePostfix__c,IPM_GateKeeping_Model__c,IPM_Gate_Document__c,IPM_Gate_Sequence__c,IPM_InsertFinancialsAPIName__c,IPM_LocalProjectDefaultPhase__c,IPM_Parent_project_Type__c,IPM_Phase__c,IPM_Project_Span__c,IPM_Project_Type__c,IPM_RegionalProjectDefaultPhase__c,IPM_SourceProjectName__c,IPM_Source_Company_Card__c,IPM_Sync_To_Eco_Design__c,IPM_UpdateFinancialsAPIName__c,IPM_UpdateFinancialsReferences__c,IPM_Update_Child_Project_Status__c,IPM_Update_Parent_Project_Status__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,Source_Project_Type__c,Sync_To_Eco_Design__c,SystemModstamp FROM IPM_Project_Type__c limit 100"

::Export IPM Reporting Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Reporting__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Last_Batch_RunDate__c,Name,SetupOwnerId,SystemModstamp,Y1__c,Y2__c,Y3__c,Y4__c,Y5__c,Y_1__c,Y_2__c,Y_3__c FROM IPM_Reporting__c limit 100"

::Export IPM Section Copy Mapping Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Section_Copy_Mapping__c -Dsoql="SELECT CreatedById,CreatedDate,Gate_To_Copy_From__c,Id,IPM_SourceFieldAPIName__c,IPM_TargetFieldAPIName__c,IsDeleted,LastModifiedById,LastModifiedDate,Name,Section_External_Id_To_Copy_Over__c,SetupOwnerId,SystemModstamp,Type_Of_Gate__c FROM IPM_Section_Copy_Mapping__c limit 100"

::Export IPM BET Valid Categories Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_BET_Valid_Categories__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,SetupOwnerId,SystemModstamp FROM IPM_BET_Valid_Categories__c limit 100"

::Export IPM_Rollout FL Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Rollout_FL_Setting__c -Dsoql="SELECT CreatedById,CreatedDate,FL_Id__c,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,Rollout_Id__c,SetupOwnerId,SystemModstamp FROM IPM_Rollout_FL_Setting__c limit 100"

::Export IPM Roll-out PL Custom Setting
cd c:\Software\SFDC SonarQube\salesforce_ant_33.0\sample
call ant exportData -propertyfile build.properties -Dobject=IPM_Rollout_PL_Setting__c -Dsoql="SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,PL_Id__c,Rollout_Id__c,SetupOwnerId,SystemModstamp FROM IPM_Rollout_PL_Setting__c limit 100"