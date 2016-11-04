/**
@Author - vinod.thupakula@accenture.com
@name - UL_Utility
@CreateDate - 03-10-2016
@Description - this class is helper for all the static variables.
@Version - 1.0
@reference - N/A
*/
public with sharing class UL_Utility{ 
    public static final String level = 'Level 8';
    public static final String promotiontype = 'SellablePromotion';
    public static final String retURL = 'retURL';
    public static final String levelField = 'UL_Level_';
    public static final String accQuery = 'select id,name,UL_Level_8__c,UL_Level_8__r.name ,UL_Customer_Hierarchy_Level__c  from  Account where UL_Customer_Hierarchy_Level__c=\'';
    public static final String andCommand = '\' AND  ';
    public static final String underscoreC= '__c =\'';
    public static final String colon= '\'';
    public static final String space= ' ';
    public static final String hyphen= ' - ';
    public static final String creationpage= '/apex/ACSFUL001__CreatePromotion';
    public static final String promotionplanningpage= '/apex/ACSFUL001__PromotionPlanning?id=';
    public static final String mobility= 'Mobility';
    public static final String promotionPickOne= 'Volume and Value';
    public static final String indirect= 'Indirect';
    public static final String promotionPickTwo= 'Value Only';
    
    
    
   
}