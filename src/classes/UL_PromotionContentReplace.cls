/***************************************************************
Name: PromotionContentReplace
Copyright © 2016 Accenture
======================================================
Purpose:
class to replace custom field names in the promotion content
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Badri         16/12/2016     INITIAL DEV            
***************************************************************/
public class UL_PromotionContentReplace{
    final static string ACCLUL = 'ACCL__UL_';
    final static string UL = 'UL_';
    /*******************************************************************
    Purpose: It replace the custom field API Names in the Promotion Content send to Smart UI.
    Version 1.0
    Parameters: String Promotion Content 
    Returns: String Promotion Content
    Throws : N/A 
    ********************************************************************/     
      public static string replaceFieldContent(String Content){
            content=content.replace(ACCLUL,UL);
            /*
            content=content.replace('ACCL__UL_Brand__c','UL_Brand__c');
            content=content.replace('ACCL__UL_Cannibalisation_Override__c','UL_Cannibalisation_Override__c');  
            content=content.replace('ACCL__UL_Category__c','UL_Category__c');      
            content=content.replace('ACCL__UL_Account__c','UL_Account__c');
            content=content.replace('ACCL__Account__c','Account__c')  ;  
            content=content.replace('ACCL__UL_Current_Status__c','UL_Current_Status__c');    
            content=content.replace('ACCL__UL_Delivery_Profile__c','UL_Delivery_Profile__c');   
            content=content.replace('ACCL__UL_Feature__c','UL_Feature__c');    
            content=content.replace('ACCL__UL_Free_Text__c','UL_Free_Text__c');
            content=content.replace('ACCL__UL_Front_Margin__c','UL_Front_Margin__c');
            content=content.replace('ACCL__UL_IIBB_Tax__c','UL_IIBB_Tax__c');
            content=content.replace('ACCL__UL_Lift__c','UL_Lift__c');
            content=content.replace('ACCL__UL_Mechanic__c','UL_Mechanic__c');
            content=content.replace('ACCL__UL_Next_Status__c','UL_Next_Status__c');
            content=content.replace('ACCL__UL_Post_Dip_End_Date__c','UL_Post_Dip_End_Date__c');
            content=content.replace('ACCL__UL_Pre_Evaluation_Comment__c','UL_Pre_Evaluation_Comment__c');
            content=content.replace('ACCL__UL_Primary_Objective__c','UL_Primary_Objective__c');
            content=content.replace('ACCL__UL_Promotion_Name__c','UL_Promotion_Name__c');
            content=content.replace('ACCL__UL_Promotion_Type__c','UL_Promotion_Type__c');
            content=content.replace('ACCL__UL_Sales_Organization__c','UL_Sales_Organization__c');
            content=content.replace('ACCL__UL_Secondary_Objective__c','UL_Secondary_Objective__c');
            content=content.replace('ACCL__UL_Sharing_Type_Form__c','UL_Sharing_Type_Form__c');
            content=content.replace('ACCL__UL_Sharing_Type_Txt__c','UL_Sharing_Type_Txt__c');
            content=content.replace('ACCL__UL_Sub_Mechanic__c','UL_Sub_Mechanic__c');
            content=content.replace('ACCL__UL_Volume_Type__c','UL_Volume_Type__c');
            content=content.replace('ACCL__UL_Cannibalisation_Rate__c','UL_Cannibalisation_Rate__c');
            content=content.replace('ACCL__UL_ThresholdViolated__c','UL_ThresholdViolated__c');
            content = content.replace('ACCL__UL_Threshold_Window_Result__c','UL_Threshold_Window_Result__c');
            content = content.replace('ACCL__UL_Threshold_Result__c','UL_Threshold_Result__c');
            content = content.replace('ACCL__UL_WorkflowState__c','UL_WorkflowState__c');
            content = content.replace('ACCL__UL_Promotion_Content__c','UL_Promotion_Content__c');
            */
  return content;
}

}