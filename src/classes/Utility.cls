/*
  Class Name: Utility
  Author : Mindtree
  Date: 1 June 2015
  Requirement/Project Name: Unilever Salesforce Engagement
  Requirement/Description: Utility class used for both Chatter Approval and Ideation App
*/
public with sharing class Utility {
	
    
    /*******************************************************************
    // Method returns boolean value based on the passed stringObject is empty
    *******************************************************************/
    
    public static boolean isEmpty(Object obj){
      boolean isEmpty = true;
      if(obj != null){
          isEmpty = false;
      }
      return isEmpty;
    }

    public static boolean isEmpty(String stringObj){
      boolean isEmpty = true;
      if(stringObj != null) {
          if(!stringObj.equals('')){
              isEmpty = false;
          }
      }
      return isEmpty;
    }

    /*public static boolean isEmpty(List<Object> listOfObj ){
      boolean isEmpty = true;
      if(listOfObj  != null) {
          if(listOfObj.size() > 0){
            isEmpty = false;
          }
      }
      return isEmpty;
    }
    public static boolean isEmpty(Map<String,Object> mapOfObj ){
      boolean isEmpty = true;
      if(mapOfObj  != null && !mapOfObj.isEmpty()) {
            isEmpty = false;
      }
      return isEmpty;
    }*/

}