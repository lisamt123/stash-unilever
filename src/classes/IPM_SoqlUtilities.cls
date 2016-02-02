/************************************************* 
*@Author:Cognizant
*@Date:October 2014
*@Description :  To Query the BOSSCARD details 
**************************************************/
public with sharing class IPM_SoqlUtilities {
    
    //*@Description Holds the project ID which is used in component.
    public static String IPM_ProjectID{get;set;}
    
    /********************************************************************************
    *@Description :Getter values for the getBosscardMap
    *********************************************************************************/
    
    public static Map<Id, IPM_Bosscard__c> getBosscardMap(){
        return getBosscardMap(null);
    }
    
    
    /************************************************************************************
    *@Description : Setter values for the getBosscardMap where we are passing BOSSCARD ID
    *@Param: BOSSCARD ID.
    *@return:BOSSCARD Record.
    *************************************************************************************/
    public static Map<Id, IPM_Bosscard__c> getBosscardMap(String recordId){
        String queryString = 'SELECT ';
        for (String field : Schema.SObjectType.IPM_Bosscard__c.fields.getMap().KeySet())
        {
            if (field != 'Id')
            {
                queryString+= field + ', ';
            }
        }
        queryString+= 'Id,IPM_Gate_Keeper__r.smallphotourl,IPM_Gate_Keeper__r.name,IPM_Project_Leader__r.name,CreatedBy.Name FROM IPM_Bosscard__c';
        if (recordId != null)
        {
            queryString+= ' WHERE Id =: recordId';
        }
        
        queryString+= ' ORDER BY Name ASC ';
        
        return new Map<Id, IPM_Bosscard__c>((List<IPM_Bosscard__c>) Database.query(queryString));
    }    
}