/**
    About
    -----
    Description: Class Utils 
    Created for: Unilever Project
    Create date: 09/ 2015
    Created by Jamal Rida
	Author : @Jamal
    Details
    -------
    This class is  : used as a global class which contains all Global Methods
    					 for better maintenance 
    		
    Update History
    --------------    
*/
public with sharing class Oblix_Utils {
	
	
//Used to Wrap RecordType By Object
	public static Map<string,ID> MapRecordType(String ObjectName){
     
	     List<RecordType> lstRecordType = new List<RecordType>();
	     
	     lstRecordType = [Select ID,SobjectType,Name,DeveloperName from RecordType where SobjectType=:ObjectName];
	     
	     Map<String,ID> MapRTCaseToDeveloperName = new Map<String,ID>();
	     
	     for(RecordType rec:lstRecordType)
	     {
	        MapRTCaseToDeveloperName.put(rec.DeveloperName,rec.ID);
	     }
	     
	     return MapRTCaseToDeveloperName;
        
    }
}