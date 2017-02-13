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
public with sharing class UL_PromotionContentReplace{
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
        try{
            content=content.replace(ACCLUL,UL);
        }catch(Exception ex){
            throw ex;
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        return content;
    }
}