public with sharing class IPM_Utils {
    
    public static Map<String, Integer> monthMap = new Map<String, Integer>{
                                                                            'Jan' => 01, 'Feb' => 02, 'Mar' => 03,
                                                                            'Apr' => 04, 'May' => 05, 'Jun' => 06,
                                                                            'Jul' => 07, 'Aug' => 08, 'Sep' => 09,
                                                                            'Oct' => 10, 'Nov' => 11, 'Dec' => 12};
    
    public static Map<String, String> marketClusterSuffix = new Map<String, String>{'AFR-N&R' => 'AFR/N&R',
                                                                                    'NAS-SAS'=> 'NAS/SAS',
                                                                                    'NAS-SEAA' => 'NAS/SEAA',
                                                                                    'SAS-SEAA' => 'SAS/SEAA',
                                                                                    'NAS-SAS-SEAA' => 'ASIA'};
    public static list<String> marketClustersList = new list<String>{'AFR', 'N&R', 'NAS', 'SAS', 'SEAA'};
    public static Map<String, String> phaseGateDocumentMap = new Map<String, String>{'Ideas' => 'Charter', 'Feasibility' => 'Contract',
                                                                                      'Capability' => 'Market Ready', 'Market Ready' => 'Market Deployment',
                                                                                      'Market Deployment' => 'n/a','PLE' => 'n/a','Stopped' => 'n/a'};
    public static String[] convertJSArrayToLsArray(String str) {
        
        String[] listToReturn = new List<String>();
        if(str != null || str != '') {
            for(String eachStr : str.split(',')) {
                listToReturn.add(eachStr);
            }
        }
        
        return listToReturn;
    }
    
    public static String convertSetToString(Set<String> setStr) {
        
        String strToReturn;
        for(String eachStr : setStr) {
            if(strToReturn == null) {
                strToReturn = eachStr;
            }else {
                strToReturn = strToReturn + ',';
            }
        }
        
        return strToReturn;
    }
    
    public static String convertStrToSoqlList(String str) {
        
        String strToReturn;
        String blank = '';
        String nullString = null;
        
        system.debug('** str : ' + str);
        
        if(!String.isBlank(str)) {
            for(String eachStr : str.split(',')) {
                if(strToReturn == null) {
                    strToReturn = '(\'' + eachStr + '\'';
                } else {
                    strToReturn += ',\'' + eachStr + '\'';
                }
            }
            strToReturn += ')'; 
        }
        return strToReturn;
    }
    
    public static Map<Id, String> getUserProfilePhoto(Set<Id> usersId) {
        
        Map<Id, String> userMapToReturn = new Map<Id, String>();
        List<User> userList = [Select SmallPhotoUrl From User where id IN :usersId];
        for(User eachUser : userList) {
            userMapToReturn.put(eachUser.Id, eachUser.SmallPhotoUrl);
        }
        
        return userMapToReturn;
    }
    
    public static Map<Id, User> getUserDetailsMap(Set<Id> usersId) {
        
        Map<Id, User> userMapToReturn = new Map<Id, User>();
        List<User> userList = [Select Name From User where id IN :usersId];
        for(User eachUser : userList) {
            userMapToReturn.put(eachUser.Id, eachUser);
        }
        
        return userMapToReturn;
    }
    
    public static String getMilestoneRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
    
    public static String getFinancialRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
    
    public static List<String> getPicklistValues(SObject obj, String fld) {
        
        List<String> optionsToReturn = new List<String>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = obj.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values) { 
            optionsToReturn.add(a.getValue()); 
        }
      
        return optionsToReturn;
   }
   
   public static String userRole() {
       
       String strToReturn;
       try {
           IPM_User_Profile__c usrObj = [SELECT IPM_User_Role__c FROM IPM_User_Profile__c WHERE IPM_User__c=:UserInfo.getUserId() limit 1];
           strToReturn = usrObj.IPM_User_Role__c;
           if(strToReturn == 'Supply Chain') {
                strToReturn = 'SC';
           }
       }catch(exception e) {}
       
       return strToReturn;
   }
   
   //Accepts a string and returns its last occurance through a given delimiter
   public static String getSuffixString(String strName, String delimiter) {
   
       return strName.substring(strName.lastIndexOf(delimiter)+1, strName.length());   
   }
   
   public static list<String> convertSetToSortedList(Set<String> strSet) {
       
       String[] lstToReturn = new list<String>();
       lstToReturn.addAll(strSet);
       lstToReturn.sort();
       return lstToReturn;
   }
   
   public static IPM_Project__c getCurrentPhase(String projectId) {
       
       IPM_Project__c prjectObj = [SELECT IPM_Phase__c FROM IPM_Project__c WHERE Id = :projectId];
       return prjectObj;
   }
   
   public static Map<Id, IPM_Project__c> getProjectDetails(Set<Id> projectIds) {
        
        Map<Id, IPM_Project__c> projectMapToReturn = new Map<Id, IPM_Project__c>();
        IPM_Project__c[] projectsList = [SELECT Name, IPM_Project_Leader__c FROM IPM_Project__c WHERE Id IN :projectIds];
        for(IPM_Project__c eachProject : projectsList) {
            projectMapToReturn.put(eachProject.Id, eachProject);
        }
        
        return projectMapToReturn;
   }
   
   public static String removeFirst2Words(String str, String delim) {
        
        String firstLetterRemovedStr = str.substring(str.indexOf(delim)+1, str.length());
        system.debug('** firstLetterRemovedStr : ' + firstLetterRemovedStr);
        system.debug('** firstLetterRemovedStr.indexOf(delim) : ' + firstLetterRemovedStr.indexOf(delim));
        String strToReturn = firstLetterRemovedStr.substring(firstLetterRemovedStr.indexOf(delim)+1, firstLetterRemovedStr.length());
        return strToReturn;
   }
}