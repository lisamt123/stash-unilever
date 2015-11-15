/******************************************** 
*@Author:Cognizant
*@Date:October 2014
*@Description : To create a BOSSCARD 
*Referring in page ipm_Bosscard page 
*********************************************/
public without sharing class IPM_WithoutShareController {
    /********************************************************************************
    *@Description :get all bosscard name list
    *@param:bosscard id,bosscard name
    *@return:List of Bosscard.
    *********************************************************************************/
    public static List<IPM_Bosscard__c> allBosscardList(id bosscardId,string bossName){
        List<IPM_Bosscard__c>listofBosscardName=new List<IPM_Bosscard__c>();
        if(!string.isBlank(bossName)){
	        string bossNameLike=bossName+'%';
	        listofBosscardName=[SELECT id,name,IPM_BosscardName__c FROM IPM_Bosscard__c WHERE IPM_BosscardName__c !=null 
	        					AND IPM_BosscardName__c Like:bossNameLike AND Id !=:bosscardId 
	                               LIMIT 999];
        }                       
        return listofBosscardName;
        
    }
    /********************************************************************************
    *@Description :get all bosscard name list
    *@return:List of Bosscard.
    *********************************************************************************/
    public static List<IPM_Bosscard__c> duplicateBosscardList(string bossId,String bosscardName){
        string PerStr=IPM_ConstantUtils.PERCENTAGE;
        List<IPM_Bosscard__c>listofBossName=new List<IPM_Bosscard__c>();
        if(String.isNotBlank(bossId)) {
            listofBossName=[SELECT Id  FROM IPM_Bosscard__c WHERE IPM_BosscardName__c Like:  String.escapeSingleQuotes(bosscardName)+ PerStr 
                              and Id !=:bossId Limit 1];
        }
        return listofBossName;
    }
    /********************************************************************************
    *@Description :get all bosscard name list
    *@return:List of Bosscard.
    *********************************************************************************/
    public static List<IPM_Project__c> allProjectList(id projectId,string projectName){
        List<IPM_Project__c>listofProjectName=new List<IPM_Project__c>();
        if(!string.isBlank(projectName)){
        	string projectNameLike=projectName+'%';
        	listofProjectName=[SELECT id,name,IPM_Project_Name__c FROM IPM_Project__c WHERE IPM_Project_Name__c !=null 
                              AND IPM_Project_Name__c Like:projectNameLike AND id !=:projectId LIMIT 999];	
        }
        
        return listofProjectName;
    }
    /********************************************************************************
    *@Description :get all Project name list
    *@return:List of Projects.
    *********************************************************************************/
    public static boolean duplicateProjectList(string proId,String projectName){
        string PerStr=IPM_ConstantUtils.PERCENTAGE;
        boolean isDuplicate=false;
        List<IPM_Project__c>listofProjectName=new List<IPM_Project__c>();
        if(String.isNotBlank(proId)) {
            listofProjectName=[SELECT Id,IPM_IsCompleted__c,IPM_Project_Name__c FROM IPM_Project__c WHERE (IPM_Project_Name__c=:projectName or IPM_Project_Name__c Like :projectName +PerStr) and Id !=:proId 
             and IPM_Parent_Project__c!=:proId and IPM_Parent_Project__r.IPM_Parent_Project__c!=:proId Limit 1000];
            for(IPM_Project__c ipmProject : listofProjectName){
                if(ipmProject .IPM_Project_Name__c.substringBefore(IPM_ConstantUtils.UNDERSCORE).equals(projectName)){
                isDuplicate=true;
                }
            }
            
            
        }
        
        return isDuplicate;
    }
    /********************************************************************************
    *@Description :get all Project name list
    *@return:List of Projects.
    *********************************************************************************/
    public static boolean duplicateCompanyCard(string ccId,String companycardName){
        List<IPM_Company_Card__c>listofCCName=new List<IPM_Company_Card__c>();
        string query='SELECT Id  FROM IPM_Company_Card__c WHERE Name=:companycardName ';
        if(String.isNotBlank(ccId)) {
            query=query+'and Id !=:ccId';  
        }
        query=query+' Limit 1';
        listofCCName=database.Query(query);
        if(listofCCName.isEmpty()){
            return false;   
        }else{
            return true;
        }
        
    }
    
}