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
    public static list<string> lstSubCatPerRecT(string recType){

       list<string> lst = new list<string>(); 
           if(recType == 'Admin'){
               lst.add('ORIGINATION');
               lst.add('ADAPTATIONS and RE-EDITS');
               lst.add('Stimulus requirements');
               lst.add('Cut downs and Tag');
           }
           if(recType == 'Audio Visual'){
               lst.add('ORIGINATION');
           }
           if(recType == 'Static Imagery'){
               lst.add('ORIGINATION');
           }
           if(recType == 'Experiential'){
               lst.add('ORIGINATION');
           }
           if(recType == 'Experiential'){
               lst.add('ORIGINATION');
           }
           if(recType == 'Digital'){
               lst.add('ORIGINATION');
           }          
             
       return lst;   
    }
}