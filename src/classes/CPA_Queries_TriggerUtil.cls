/**********************************************************************
Name: CPA_Queries_TriggerUtil()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of Query Trigger
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR                     DATE            DETAIL Description
1.0         Pooja Kanani     15/03/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_Queries_TriggerUtil {
    /*
    * Method Name : assignedToInserted
    * Parameter   : 
    * Return type : None
    * Description : This method is used to assigned the query to the queue
    */
    public static void assignedToInserted(List<CPA_Queries__c> querynewList){
        Group qu = [select Id,DeveloperName from Group where DeveloperName = 'CPA_SMT' limit 1];
        for(CPA_Queries__c query :querynewList){
            if(qu != null){              
                query.ownerid = qu.id;
            }
        }
        
    }  
	/*
    * Method Name : assignedToUpdated
    * Parameter   : 
    * Return type : None
    * Description : This method is used to assigned the query to the queue
    */
    public static void assignedToUpdated(List<CPA_Queries__c> queryOldList,List<CPA_Queries__c> querynewList){
        map<String,id>gruouIDNameMap = new map<String,id>();
        String assignedTo = null;
        List<Group> qulist = [SELECT id,DeveloperName FROM Group WHERE DeveloperName LIKE 'CPA%' OR DeveloperName LIKE 'CAP%'];
        for(Group qu:qulist){
         	  gruouIDNameMap.put(qu.DeveloperName,qu.id);
        }
        Map<string,CPA_Group__c> customSettingGrpName = CPA_Group__c.getAll();       
        for(integer i=0; i < querynewList.size(); i++){
            if(queryOldList[i].Assigned_to__c<>querynewList[i].Assigned_to__c){                
                assignedTo = customSettingGrpName.get(querynewList[i].Assigned_to__c).CPA_Group_Name__c; 
                if(gruouIDNameMap.get(assignedTo) != null){
                 	querynewList[i].ownerid = gruouIDNameMap.get(assignedTo);   
                }               
            }
        }
        
    }
/*
    * Method Name : assigneduser
    * Parameter   : 
    * Return type : None
    * Description : This method is used to get the owner and query assigned user to trigger email alert
    */
    public static void assigneduser(List<CPA_Query_comment__c> responsenewList){
        Set<ID>querySet = new Set<ID>();
        map<ID,ID>CreatedbyIdMap = new map<ID,ID>();
        for(CPA_Query_comment__c response :responsenewList){
			querySet.add(response.LookupCPA_Queries__c);
            }
        List<CPA_Queries__c> queryList = [select id,Ownerid,createdbyid from CPA_Queries__c where id IN:querySet];
        for(CPA_Queries__c query:queryList){
            CreatedbyIdMap.put(query.Id,query.createdbyid);
        }
        for(CPA_Query_comment__c response :responsenewList){
            if(CreatedbyIdMap.get(response.LookupCPA_Queries__c) != null){
            	response.Query_Creator__c = CreatedbyIdMap.get(response.LookupCPA_Queries__c);

        	}        
    	}      
	}
}