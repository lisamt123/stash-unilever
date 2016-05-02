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
        Group qu = [select Id,name from Group where name = 'CPA SMT' limit 1];
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
        List<Group> qulist = [select Id,name from Group where name like 'CPA%'];
        for(Group qu:qulist){
         	  gruouIDNameMap.put(qu.name,qu.id);
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
        //map<ID,ID>OwnerIdMap = new map<ID,ID>();
        map<ID,ID>CreatedbyIdMap = new map<ID,ID>();
        for(CPA_Query_comment__c response :responsenewList){
			querySet.add(response.LookupCPA_Queries__c);
            }
        List<CPA_Queries__c> queryList = [select id,Ownerid,createdbyid from CPA_Queries__c where id IN:querySet];
        system.debug('queryList>>>>>>>>>'+queryList);
        for(CPA_Queries__c query:queryList){
            //OwnerIdMap.put(query.Id,query.Ownerid);
            CreatedbyIdMap.put(query.Id,query.createdbyid);
        }
        //system.debug('OwnerIdMap>>>>>>>>>'+OwnerIdMap);
        system.debug('CreatedbyIdMap>>>>>>>>>'+CreatedbyIdMap);
        for(CPA_Query_comment__c response :responsenewList){
            system.debug('response.LookupCPA_Queries__c>>>>>>>>>'+response.LookupCPA_Queries__c);
            if(CreatedbyIdMap.get(response.LookupCPA_Queries__c) != null){
                //system.debug('OwnerIdMap@@@@@@@@@@@@'+OwnerIdMap.get(response.LookupCPA_Queries__c));
                system.debug('CreatedbyIdMap@@@@@@@@@@'+CreatedbyIdMap.get(response.LookupCPA_Queries__c));
				//response.Query_Owner__c = OwnerIdMap.get(response.LookupCPA_Queries__c);
            	response.Query_Creator__c = CreatedbyIdMap.get(response.LookupCPA_Queries__c);

        	}        
    	}      
	}
}