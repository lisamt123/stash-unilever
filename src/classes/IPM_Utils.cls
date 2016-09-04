/*
    @Description: General utility class to store frequently used variables and values.
    @Author: Cognizant Technology
    @Date: Sep 2014
    Generic class used to access IPM specific custom setting data, hence kept as Without Sharing.
*/

/* 
This class is running in without sharing because these classes contain various generic methods that are not depending on the user and need access to all fields and records across organisation.
This class covers the below functionality :

1) Get field specific fieldset information for Preparing SOQL 
2) Trigger Skip Logic
3) Financial External Id creation
4) IPM Framework specific methods which make use of Custom Setting for getting Project specific attributes.
5) User specific information and permission access.
6) Generic implementation for Creating SOQL using schema methods.
7) OTIF and Copy Over Custom Setting information.
8) Methods for getting project hierarchy invoked from Queueable Interface. 
*/
public without sharing class IPM_Utils {

    //IPM_ProjectUtility
    public static String ExternalField = 'ExternalField__c';
    
    //IPM_ProjectDocumentHandler
    public static String IPM_Project ='IPM_Project__c';
    public static String IPM_Approval_Date ='IPM_Approval_Date__c';
    
    public static String pdf = 'pdf';

    
    public static String Y1 = 'Y1';
    public static String n0 = '0';
    public static String n1 = '1';
    public static String n2 = '2';
    public static String n3 = '3';
    public static String valueGlobal = 'Global';
    public static String amp  = ' & ';
    public static String Charter = 'Charter';
    public static String Contract = 'Contract';
    public static String MarketReady = 'Market Ready';
    public static String MarketDeployment = 'Market Deployment';
    public static String PLELearnings= 'PLE/Learnings';
    public static String Original = 'Original';
    public static String Rollout = 'Rollout';
    public static String Local = 'Local';
    public static String CONSOLIDATED = '_CONSOLIDATED';
    public static String Innovation = 'Innovation';
    public static String Gross = 'Gross';
    public static String Regional = 'Regional';
    public static String Incremental = 'Incremental';
    public static String Calendar = 'Calendar';
    public static String dueIN='is due in';
    public static String off='of';
    public static String ShiptoTrade = 'Ship to Trade';
    public static String IPM_IC = 'IC';
    public static String IPM_IC_NBU = 'NBU'; 

    //IPM_MyList
    public static String truevalue = 'true';
    public static String t = 't';
    public static String f = 'f';
    public static String thisFld  = 'thisFld';
    public static String Yes = 'Yes';
    public static String No = 'No';
    public static String IPM_Due_Date1 = 'IPM_Due_Date1__c';
    
    //IPM_HomePageController
    public static String IPM_Fast_Track_Project = 'IPM_Fast_Track_Project__c';
    public static String YYYYMMdd = 'YYYY-MM-dd';
    public static String daysfor  = ' days for ';
    public static String Createnewproject = 'Create new project';
    public static String Createnewbosscard = 'Create new bosscard';
    
    //IPM_UpdateChildIpmProjects
    public static String ipmglobal = 'Global';
    public static String ipmRegional = 'Regional';

    //IPM_Taskview
    public static String Id = 'Id';
    public static String Capability = 'Capability';
    public static String Feasibility = 'Feasibility';
    public static String Developing = 'Developing';
    public static String months4 = '4 months';
    public static String DevelopingEmerging = 'Developing & Emerging';
    public static String months6 = '6 months';
    public static String Guest = 'Guest';
    public static String BDMarketing = 'BD Marketing';
    public static String BD = 'BD';
    public static String CMI = 'CMI';
    public static String CD = 'CD';
    public static String Finance = 'Finance';
    public static String IPM_Central_Team = 'IPM_Central_Team';
    public static String IPM_Business_Partners = 'IPM_Business_Partners';
    public static String IPM_MarketReadyGate = 'Market Ready Gate';
    public static String IPM_MarketDeploymentGate = 'Market Deployment Gate';
    public static String IPM_Stopped = 'Stopped';
    public static String IPM_PLE = 'PLE';

    //IPM_Milestone
    public static Set<String> mileNames=new Set<String>{'Charter Gate Approval','Contract Gate Approval','Market Ready Gate Approval',
                       'Post Launch Evaluation','Target Launch Date(Ship to Trade)','Market Deployment Gate Approval','Ship To Trade'};
    public static String isEdit='isEdit';
    public static String isDateEdit='isDateEdit';
    public static String Wizard='Wizard';
    public static String Standard='Standard';
    public static String IPMProjectMilestones='IPM Project Milestones';
    public static String ContractGateApproval='Contract Gate Approval';
    public static String CharterGateApproval='Charter Gate Approval';
    public static String DueDatecannotbelessthanCharterGateApproval='Due Date cannot be less than Charter Gate Approval';
    public static String MarketReadyGateApproval='Market Ready Gate Approval';
    public static String DueDatecannotbelessthanContractGateApproval='Due Date cannot be less than Contract Gate Approval';
    public static String MarketDeploymentGateApproval='Market Deployment Gate Approval';
    public static String DueDatecannotbelessthanMarketReadyGateApproval='Due Date cannot be less than Market Ready Gate Approval';
    public static String DueDatecannotbeafterContractGate='Due Date cannot be after Contract Gate';
    public static String PostLaunchEvaluation='Post Launch Evaluation';
    public static String TargetLaunchDateShiptoTrade='Target Launch Date(Ship to Trade)';
    public static String DueDatecannotbelessthanShiptotrade='Due Date cannot be less than Ship to trade';
    public static String DueDatecannotbelessthanMarketDeploymentGateApproval='Due Date cannot be less than Market Deployment Gate Approval';
    public static String Duedate='Due date';
    public static String Optional='Optional';
    public static String BETFirstRelease='BET First Release';
    public static String BETFinalReleasecompletewithApprovedCommunication ='BET Final Release (complete with Approved Communication)';
    public static String IPMMilestones='IPM Milestones';
    public static String PleaseenterMileStonename='Please enter MileStone name';
    public static String PleaseenterPhase='Please enter Phase';
    public static String DueDateshouldnotbenull='Due Date should not be null';
    public static String Ideas ='Ideas';
    
    //IPM_NewTask Class
    public static String hyphen ='-';
    public static String projectWizard ='Wizard';
    public static String IPM_NewTaskIPM_FunctionalRole ='SC';
    public static String projDocSecId = 'projDocSecId'; 
    public static String IPM_NewTaskprojectId = 'projectId';
    public static String ProjectLeader ='Project Leader';
    public static String roleForProjectLeader ='PL';
    public static String TechnicalLeader = 'Technical Leader';
    public static String DeputyProjectLeader ='Deputy Project Leader';
    public static String Invalidproject ='Invalid project';
    public static String taskId ='taskId';
    public static String External = 'External';
    public static String LocaleVsDateFormate = 'LocaleVsDateFormate';
    public static String IPM_STANDARD_TASKS ='IPM Tasks';
    public static String IPMProjectTasks ='IPM Project Tasks';
    public static String SupplyChain ='Supply Chain';
    public static String eightvalue ='8';
    public static String milePMRecordType ='IPM Project Milestones';
    public static String mileMRecordType ='IPM Milestones';
    public static String DevelopingIPM_Market_Type ='Developed';
    public static String mileSnapRecordType ='IPM_Snapshot';
    public static String EmergingIPM_Market_Type ='Developing & Emerging';
    public static String IPM_Type_of_Milestone ='Standard';
    public static String recordTypeName ='IPM Project Tasks';
    public static String Internal = 'Internal';
    public static List<String> lstphaseValue = new List<String>{Ideas,Feasibility,Capability,MarketReady};
    public static String notapplicable = 'n/a';
    public static String duplicateTaskError ='Task already exists.';
    //batch finish email subject and body strings
    public static String emailSubject = 'Apex Sharing Recalculation ';
    public static String emailBody1 = 'The batch Apex job processed ';
    public static String emailBody2 = ' batches with ';
    public static String emailBody3 = ' failures.';
     
    //Monthly wise map ordering
    public static Map<String, Integer> monthMap = new Map<String, Integer>{
                                                                            'Jan' => 01, 'Feb' => 02, 'Mar' => 03,
                                                                            'Apr' => 04, 'May' => 05, 'Jun' => 06,
                                                                            'Jul' => 07, 'Aug' => 08, 'Sep' => 09,
                                                                            'Oct' => 10, 'Nov' => 11, 'Dec' => 12};
   
    //All the phases & their respective Gates
    public static Map<String, String> phaseGateDocumentMap = new Map<String, String>{Ideas => Charter, Feasibility => Contract,
                                                                                      Capability => MarketReady, MarketReady => MarketDeployment,
                                                                                      MarketDeployment => notapplicable,IPM_PLE => notapplicable,IPM_Stopped => notapplicable};
    
    public static final String FORUPDATE_STRING = ' FOR UPDATE ';
    public static final String LIMIT_STRING = ' LIMIT 50000 ';
    public static String GATE_KEEPING_MODEL_1 = 'GKM1';
    public static String GATE_KEEPING_MODEL_2 = 'GKM2';
	public static final String CLASS_NAME = IPM_Utils.Class.getName(); //Class Name for Exception Logging
    public static final String UPDATE_FINANCIAL_YEAR_STR='updateFinancialYear';
    
    /*******************************************************************************************************
    * @description: Convert Javascript array sent to apex in the form of string to apex array
    * @param1 : String input for the conversion
    * @return : Array
    */
    public static String[] convertJSArrayToLsArray(String str) {
        
        String[] listToReturn = new List<String>();
        if(String.isNotBlank(str)) {
            for(String eachStr : str.split(',')) {
                listToReturn.add(eachStr);
            }
        }
        return listToReturn;
    }
    
    /*******************************************************************************************************
    * @description: Convert Set to String
    * @param1 : Set of strings
    * @return : String
    */
    public static String convertSetToString(Set<String> setStr) {
        
        String strToReturn = null;
        for(String eachStr : setStr) {
            if(strToReturn == null) {
                strToReturn = eachStr;
            }else {
                strToReturn = strToReturn + ',' + eachStr;
            }
        }
        
        return strToReturn;
    }
    
    /*********************************************************************
    * @description: convert string format with commas delimited to a string which is used in SOQL IN
    * @param1 : String input for the conversion
    * @return : String again
    */
    public static String convertStrToSoqlList(String str) {
        
        String strToReturn = null;
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
    
    /*******************************************************************************************************
    * @description: Get user details which general functions doesnt give
    * @param1 : Set of user ids
    * @return : profile fotos user wise.
    */
    public static Map<Id, String> getUserProfilePhoto(Set<Id> usersId) {
        
        Map<Id, String> userMapToReturn = new Map<Id, String>();
        if(usersId != null && !usersId.isEmpty()){
            List<User> userList = [Select SmallPhotoUrl From User where id IN :usersId limit 1000];
            if(userList != null && !userList.isEmpty()){
                for(User eachUser : userList) {
                    userMapToReturn.put(eachUser.Id, eachUser.SmallPhotoUrl);
                }
            }
        }
        return userMapToReturn;
    }
    
    /*******************************************************************************************************
    * @description: RT id of the MS object
    * @param1 : RT name
    * @return : RT id
    */
    public static String getMilestoneRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Milestone__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
    
    /*********************************************************
    * @description: RT id of the Financials object
    * @param1 : RT name
    * @return : RT id
    */
    public static String getFinancialRecordType(String pRecordType) {
        return Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(pRecordType).getRecordTypeId();
    }
    
    /*********************************************************
    * @description: Get picklist values of a field
    * @param1 : Object name
    * @param2 : Field
    * @return : String list
    */
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
    
    /*********************************************************
    * @description: Get the user role of the current persona
    */
    public static String userRole() {
       
       String strToReturn = '';
       try {
           IPM_User_Profile__c usrObj = [SELECT IPM_User_Role__c FROM IPM_User_Profile__c WHERE IPM_User__c=:UserInfo.getUserId() limit 1];
           strToReturn = usrObj.IPM_User_Role__c;
           if(strToReturn == 'Supply Chain') {
                strToReturn = 'SC';
           }
       }catch(exception ex) { 
            ApexPages.Message myMsg = new  ApexPages.Message(ApexPages.Severity.ERROR,Label.IPM_Generic_ErrorMessage);
            ApexPages.addMessage(myMsg); 
        }
       
       return strToReturn;
   }
   
   /**********************************************************************
    * @description: Get user details in a map
    * @param1 : Set of user ids
    * @return : user details
    */
    public static Map<Id, User> getUserDetailsMap(Set<Id> usersId) {
        
        Map<Id, User> userMapToReturn = new Map<Id, User>();
        List<User> userList = [Select Name From User where id IN :usersId];
        for(User eachUser : userList) {
            userMapToReturn.put(eachUser.Id, eachUser);
        }
        
        return userMapToReturn;
    }
    
    /**********************************************************************
    * @description: Accepts a string and returns its last occurance through a given delimiter
    * @param1 : separating the suffix for a strings
    * @param2 : a delimiter which separates from the actual string from the suffix
    * @return : Suffix ofcourse!
    */
    public static String getSuffixString(String strName, String delimiter) {
       return strName.substring(strName.lastIndexOf(delimiter)+1, strName.length());   
    }
   
    /**********************************************************************
    * @description: Convert set to list but a sorted one (don't need to use this method from summer 15 release though)
    * @param1 : Set of the string
    * @return : List
    */
    public static list<String> convertSetToSortedList(Set<String> strSet) {
       
       String[] lstToReturn = new list<String>();
       lstToReturn.addAll(strSet);
       lstToReturn.sort();
       return lstToReturn;
    }
    
    /**********************************************************************
    * @description: Using the project id, find out what phase is it in
    * @param1 : Project id
    * @return : sObject of the IPM project object
    */
    public static IPM_Project__c getCurrentPhase(String projectId) {
       IPM_Project__c prjectObj = [SELECT IPM_Phase__c,IPM_Temporary_Phase__c FROM IPM_Project__c WHERE Id = :projectId];
       return prjectObj;
    } 
    
    /**********************************************************************
    * @description: String function to remove first 2 chars
    * @param1 : String, @param2 : delimiter
    * @return : 2 chars
    */
    public static String removeFirst2Words(String str, String delim) {
        String firstLetterRemovedStr = str.substring(str.indexOf(delim)+1, str.length());
        String strToReturn = firstLetterRemovedStr.substring(firstLetterRemovedStr.indexOf(delim)+1, firstLetterRemovedStr.length());
        return strToReturn;
    }
    
   
   /**********************************************************************
    * @description: Get project details to add them in the map
    * @param1 : Project id
    * @return : project map 
    */
    public static Map<Id, IPM_Project__c> getProjectDetails(Set<Id> projectIds) {
        
        Map<Id, IPM_Project__c> projectMapToReturn = new Map<Id, IPM_Project__c>();
        IPM_Project__c[] projectsList = [SELECT Name, IPM_Project_Leader__c FROM IPM_Project__c WHERE Id IN :projectIds limit 50000];
        for(IPM_Project__c eachProject : projectsList) {
            projectMapToReturn.put(eachProject.Id, eachProject);
        }
        
        return projectMapToReturn;
    }
    
    /**********************************************************************
    * @description: Returns the record id prefix depending on the object type
    * @param1 : sObj sObjectname
    * @return : prefix
    */
    public static String getsObjPrefix(String sObjName){
        
        return Schema.getGlobalDescribe().get(sObjName).getDescribe().getKeyPrefix();
    }
    
   /**********************************************************************
    * @description: to get the user types
    * @param1 : String, @param2 : delimiter
    * @return : 2 chars
    */
    public static boolean getIpmuserType(String projectId, String roleType){

        if(roleType != null){
            list<IPM_Project_Resource__c> lstProjectResource = [SELECT IPM_Role_Type__c, IPM_User__c,IPM_Project_Role_Owner__c,IPM_Project__r.IPM_Project_Leader__c 
                                                     FROM IPM_Project_Resource__c 
                                                     WHERE IPM_Project__c=:projectId 
                                                     AND IPM_User__c=:userinfo.getuserid() AND IPM_Role_Type__c=:roleType AND IPM_Project__r.Is_Archieved__c=false  LIMIT 1];
            if(lstProjectResource!= null && !lstProjectResource.isEmpty()){
                return true;
            }
        }
        list<IPM_Project__c> lstProjectUser =[SELECT IPM_Project_Leader__c, IPM_Project_Name__c ,Deputy_Project_Leader__c 
                                               FROM IPM_Project__c 
                                               WHERE (IPM_Project_Leader__c =: UserInfo.getUserId() or Deputy_Project_Leader__c =: UserInfo.getUserId()) 
                                                     AND  id =: projectId AND Is_Archieved__c=false LIMIT 1];
        if(lstProjectUser!=null && !lstProjectUser.isEmpty()){
            return true;
        }
        //security for central team and BP users
        IPM_CustomPermission cpr = new IPM_CustomPermission();
        boolean isCentralTeam=false;
        boolean isBPUser=false;
        isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
        isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
        if(isCentralTeam || isBPUser){
           return true; 
        }
        return false;  
    }
    /**********************************************************************
    * @description: to get the user types
    * @param1 : String, @param2 : delimiter
    * @return : 2 chars
    */
    public static boolean getIPMRollOutUser(String projectId){

        
        list<IPM_Project__c> lstProjectUser =[SELECT IPM_Project_Type__c, IPM_Project_Name__c ,IPM_Phase__c,IPMProject_Span__c,IPM_Project_Leader__c,Deputy_Project_Leader__c 
                                               FROM IPM_Project__c 
                                               WHERE (IPM_Project_Leader__c =: UserInfo.getUserId() or Deputy_Project_Leader__c =: UserInfo.getUserId()) 
                                                     AND  id =: projectId AND Is_Archieved__c=false  LIMIT 1];
        if(lstProjectUser!=null && !lstProjectUser.isEmpty())
        {
             if(!IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equalsIgnoreCase(lstProjectUser[0].IPMProject_Span__c)){
                 return true;
             }
         }
        //security for central team and BP users
        IPM_CustomPermission cpr = new IPM_CustomPermission();
        boolean isCentralTeam=false;
        boolean isBPUser=false;
        isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
        isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
        if(isCentralTeam || isBPUser){
           return true; 
        }  
        return false;  
    } 
    
    /**********************************************************************
    * @description: to get the master brand data
    * @return : list of strings
    */
    public static Set<String> getMasterBrandData(){
        
        set<String> lstToReturn = new set<String>();
        MDO_BrandPositions__c[] brandPositions = [SELECT brand_position_id__r.Name FROM MDO_BrandPositions__c LIMIT 9999];
        for(MDO_BrandPositions__c eachbrandPos : brandPositions) {
            lstToReturn.add(eachbrandPos.brand_position_id__r.Name);
        }
        return lstToReturn;
    }
    
    public static Boolean checkDataValid(String data) {
        return Pattern.matches('/^0*('+'\\'+'.0+)$?/',data);
    }
    
    /**********************************************************************
    * @description: Increments a string=>integer format map by 1 
    * @return : Map itself
    */
    public static Map<String, Integer> incrementStrIntMap(Map<String, Integer> givenMap, String givenKey) {
        
        Integer tmp = givenMap != null && givenMap.get(givenKey) != null ? Integer.valueOf(givenMap.get(givenKey))+1 : 1;
        givenMap.put(givenKey, tmp);
        
        return givenMap;
    }
    
    public static IPM_Project__c updateProjBETApproved(IPM_Project__c project){
        IPM_Project__c proj = project;
        if(proj.BET_Update__c){
                     //proj.Related_BET__c=proj.BET_Link_Requested__c;
                     proj.BET_Link_Requested__c='';
                     proj.BET_Link_Requested_on_Date__c = null; 
                     proj.BET_Update__c = false;
         }
         return proj;
    }
    
    /**************************************************************
    * @description: Helper method to dynamically add fields for provided Sobject Name.Can additionally provide Child Object API Names.
                    Used for Project back Ground Process.
      @param1 SObjectName : sObject  whose Data is to be fetched.
      @param2 addChild : whether child records are to be fetched.
      @param2 addChild : Child SObject which needs to be fetched.
    */
    
    public static String prepareSOQLQuery(String SObjectName ,Boolean addChild,Set<String> includededChildObjects, Boolean includeSystemFields) 
    { 
        Set<String> mandatoryStandardFieldSet = new Set<String>{'id','recordtypeid'};  
       
        String queryStr = ' Select ';

        Schema.DescribeSObjectResult sObjectDescribe = Schema.getGlobalDescribe().get(SObjectName).getDescribe();
        
        Map<String,Schema.SObjectField> sobjectFieldMap = sObjectDescribe.fields.getMap();
        Map<String, Schema.FieldSet> fieldSetMap = sObjectDescribe.fieldSets.getMap();
        Set<String> excludedFieldSet = new Set<String>();
        if(!fieldSetMap.isEmpty() && fieldSetMap.containsKey('IPM_Exclude_Fields')) 
        {
        	for(Schema.FieldSetMember fieldSetMem : fieldSetMap.get('IPM_Exclude_Fields').getFields()) 
        	{ 
        		excludedFieldSet.add(fieldSetMem.getFieldPath());
        	}
        }
        
        for(String fieldAPIName :  sobjectFieldMap.keySet())
        {   
            Schema.DescribeFieldResult fieldDescribe = sobjectFieldMap.get(fieldAPIName).getDescribe(); 
            if(!mandatoryStandardFieldSet.contains(fieldAPIName) && ( includeSystemFields || fieldDescribe.isCustom() || fieldDescribe.isNameField()) && !excludedFieldSet.contains(fieldAPIName))
            {
                queryStr += ' '+fieldAPIName+',';
            }
        }
        
        if(addChild)
        {
                
                 
            queryStr += getChildRelationshipFields(SObjectName,includededChildObjects,includeSystemFields);    
                
                    
                    
                    
                    
        }
        
        if(!sObjectDescribe.getRecordTypeInfos().isEmpty())
        {
            for(Schema.RecordTypeInfo recordInfo : sObjectDescribe.getRecordTypeInfos())
            {
                if(!recordInfo.isMaster())
                {
                    queryStr += 'recordTypeId,';
                    break;
                }
            }
        }
                    
        queryStr += 'Id from '+SObjectName+' ';

        return queryStr;
    } 
    
    public static String getChildRelationshipFields(String SObjectName,Set<String> includededChildObjects,Boolean includeSystemFields)
    {
    	String queryStr = '';
        Set<String> mandatoryStandardFieldSet = new Set<String>{'id','recordtypeid'};
    	// Get Child Relationships
        for(Schema.ChildRelationship cr : Schema.getGlobalDescribe().get(SObjectName).getDescribe().getChildRelationships())
        {
            // Get Child Relationship Name
            String childRelationShipName = cr.getRelationshipName();
            // Get Child Object Reference
            Schema.SObjectType childObjectSchema = cr.getChildSObject();
            Schema.DescribeSObjectResult childObjectDescibe = childObjectSchema.getDescribe();
            String childObjectAPIName = childObjectDescibe.getName();
            if(childObjectDescibe.isCustom() && childRelationshipName!=null && includededChildObjects.contains(childObjectAPIName))
            {
                Map<String,Schema.SObjectField> childFieldTypeMap = childObjectDescibe.fields.getMap();
                queryStr += ' ( Select ';
                for(String childFieldAPIName : childFieldTypeMap.keySet())
                {
                    Schema.DescribeFieldResult fieldDescribe = childFieldTypeMap.get(childFieldAPIName).getDescribe();
                    if(!mandatoryStandardFieldSet.contains(childFieldAPIName) && ( includeSystemFields || fieldDescribe.isCustom() || fieldDescribe.isNameField()) )
                    {
                        queryStr += ' '+childFieldAPIName+',';
                    }
                } 
                if(!childObjectDescibe.getRecordTypeInfos().isEmpty())
                { 
                    for(Schema.RecordTypeInfo recordInfo : childObjectDescibe.getRecordTypeInfos())
                    {
                        if(!recordInfo.isMaster())
                        {
                            queryStr += 'recordTypeId,';
                            break;
                        }
                    }
                }
                queryStr += 'Id from '+childRelationshipName;
                queryStr = queryStr.removeEnd(IPM_ConstantUtils.COMMA);
                queryStr += '  ),'; 
            }
        }
        return queryStr; 
    }
    
    /**************************************************************
    * @description: Helper method To get current state for the project in its lifecycle.Project Type Framework
        Used for Project back Ground Process.
      @param1 project : Project Object.
    */
    public static IPM_Project_Type__c retrieveProjectType(IPM_Project__c project)
    {
        IPM_Project_Type__c targetProjectType = null;
        // Get incoming Project Type 
        String projectType = project.IPM_Project_Type__c;
        // Get project GateKeeping Model
        String projectGKModel = project.IPM_GateKeeping_Model__c;
        // Get Project Span 
        String projectSpan = project.IPMProject_Span__c;
        // Get project current Phase
        String projectPhase = project.IPM_Phase__c; 
        // Get Source Company Card
        String projectSourceCC = project.IPM_CompanyCardText__c;  
        
        for(IPM_Project_Type__c projectTypeObj : IPM_Project_Type__c.getAll().values())
        {
             if(projectTypeObj.IPM_Project_Type__c == projectType && projectTypeObj.IPM_GateKeeping_Model__c == projectGKModel && 
                projectTypeObj.IPM_Project_Span__c == projectSpan && projectTypeObj.IPM_Phase__c == projectPhase && 
                projectTypeObj.IPM_Source_Company_Card__c == projectSourceCC )
             {
                 targetProjectType = projectTypeObj;
                 break;
             }               
        } 
        
        
        return  targetProjectType;     
    }
    
    /**************************************************************
    * @description: Helper method that recursively invokes and get the Previous phases across Spans.Project Type Framework
        Used for Project back Ground Process.
      @param1 currentProjectType : current Project Type of the incoming Project.
      @param2 originalProjectType: Orignally passed project Type
      @param3 withGate : whether gate has to be considered.
      
    */
    
    /**************************************************************
    * @description: Get previous Phase for the Current Project based on Various Params. Project Type Framework
        Used for Project back Ground Process.
      @param1 currentProjectType : current Project Type of the incoming Project.
      @param2 withGate : whether gate has to be considered.
    */
    
    public static List<IPM_Project_Type__c> getPreviousPhases(IPM_Project_Type__c currentProjectType,Boolean withGate)
    {
        List<IPM_Project_Type__c> previousProjectPhases = new List<IPM_Project_Type__c>();
        if(currentProjectType!=null)
        {  
            // Get Previous Phase for intiation. 
            if(currentProjectType.IPM_Parent_project_Type__c !=null)
            {
                String previousProjectPhase = currentProjectType.IPM_Parent_project_Type__c;
                IPM_Project_Type__c parentProjectType = IPM_Project_Type__c.getValues(previousProjectPhase);
                     
                if(withGate)
                {
                    if(parentProjectType.IPM_Gate_Document__c!=null && !String.isBlank(parentProjectType.IPM_Gate_Document__c) )
                    {
                        previousProjectPhases.add(parentProjectType);
                    }
                }
                else
                {
                    previousProjectPhases.add(parentProjectType);
                }
                previousProjectPhases.addAll(getPreviousPhases(parentProjectType,withGate));
                
            }   
        }
        return previousProjectPhases;  
    }
     
    
    /**************************************************************
    * @description: Get next Phase for the Current Project based on Various Params. Project Type Framework
        Used for Project back Ground Process.
      @param1 currentProjectType : current Project Type of the incoming Project.
      @param2 withGate : whether gate has to be considered.
    */
    
    public static IPM_Project_Type__c getNextPhase(IPM_Project_Type__c currentProjectType,Boolean withGate)
    {
        IPM_Project_Type__c nextProjectPhase = new IPM_Project_Type__c();
      
        if(currentProjectType!=null)
        {
            for(IPM_Project_Type__c projectTypeObj : IPM_Project_Type__c.getAll().values())
            {
                if(projectTypeObj.IPM_Project_Type__c == currentProjectType.IPM_Project_Type__c && 
                    projectTypeObj.IPM_GateKeeping_Model__c == currentProjectType.IPM_GateKeeping_Model__c && 
                    projectTypeObj.IPM_Project_Span__c == currentProjectType.IPM_Project_Span__c && 
                    projectTypeObj.IPM_Source_Company_Card__c == currentProjectType.IPM_Source_Company_Card__c   
                   )
                {
                    if(projectTypeObj.IPM_Gate_Sequence__c == (currentProjectType.IPM_Gate_Sequence__c + 1) && projectTypeObj.IPM_Phase__c !=null)
                    {
                        if(withGate && !String.isBlank(projectTypeObj.IPM_Gate_Document__c) )
                        {
                            nextProjectPhase =  projectTypeObj;
                            break;
                        }
                        else
                        {
                            nextProjectPhase = projectTypeObj;
                            break;
                        } 
                    }
                }
            }
        }
        
        
        return nextProjectPhase;
    } 
    
    /**************************************************************
    * @description: Get next Phases for the Current Project based on Various Params. Project Type Framework
        Used for Project back Ground Process.
      @param1 currentProjectType : current Project Type of the incoming Project.
      @param2 withGate : whether gate has to be considered.
    */
    
    public static List<IPM_Project_Type__c> getNextPhases(IPM_Project_Type__c currentProjectType,Boolean withGate)
    {
        List<IPM_Project_Type__c> nextProjectPhase = new List<IPM_Project_Type__c>();
      
        if(currentProjectType!=null)
        {
            for(IPM_Project_Type__c projectTypeObj : IPM_Project_Type__c.getAll().values())
            {
                if(projectTypeObj.IPM_Project_Type__c == currentProjectType.IPM_Project_Type__c && 
                    projectTypeObj.IPM_GateKeeping_Model__c == currentProjectType.IPM_GateKeeping_Model__c && 
                    projectTypeObj.IPM_Project_Span__c == currentProjectType.IPM_Project_Span__c && 
                    projectTypeObj.IPM_Source_Company_Card__c == currentProjectType.IPM_Source_Company_Card__c
                   )
                {
                    if(projectTypeObj.IPM_Gate_Sequence__c > currentProjectType.IPM_Gate_Sequence__c && projectTypeObj.IPM_Phase__c !=null)
                    {
                        if(withGate && !String.isBlank(projectTypeObj.IPM_Gate_Document__c) )
                        {
                            nextProjectPhase.add(projectTypeObj);
                        }
                        else
                        {
                            nextProjectPhase.add(projectTypeObj);
                        } 
                    }
                }
            }
        }
        
        
        return nextProjectPhase;
    }
    
    /**************************************************************
    * @description: Get Previous Phases for the Current Project based on Various Params. Project Type Framework
     Used for Project back Ground Process.
      @param1 currentProjectType : current Project Type of the incoming Project.
      @param2 withGate : whether gate has to be considered.
    */
    public static IPM_Project_Type__c getPreviousPhase(IPM_Project_Type__c currentProjectType,Boolean withGate)
    {
        if(currentProjectType!=null)
        {  
            // Get Previous Phase for intiation. 
            if(currentProjectType.IPM_Parent_project_Type__c !=null)
            {
                String previousProjectPhaseString = currentProjectType.IPM_Parent_project_Type__c;
                IPM_Project_Type__c parentProjectType = IPM_Project_Type__c.getValues(previousProjectPhaseString);
                
                if(withGate)
                {
                    if(parentProjectType.IPM_Gate_Document__c!=null && !String.isBlank(parentProjectType.IPM_Gate_Document__c) )
                    {
                        return parentProjectType;
                    }
                }
                else
                {
                    return getPreviousPhase(parentProjectType,withGate);
                }       
            }   
        }
        return null;
    }
    
	public static List<IPM_Project_Type__c> getProjectSpanBasedOnGate(IPM_Project__c project,String gateDocument)
    {
    	List<IPM_Project_Type__c> filteredProjectTypeList = new List<IPM_Project_Type__c>();
    	
    	System.debug('project-->>'+project);
    	
    	if(project!=null && project.IPM_SourceProjectType__c !=null && project.IPM_CompanyCardText__c !=null && project.IPM_GateKeeping_Model__c != null )
        {  
            // Get Previous Phase for intiation. 
            List<IPM_Project_Type__c> projectTypeList = IPM_Project_Type__c.getAll().values();
            
            for(IPM_Project_Type__c projectType : projectTypeList)
            {
            	if( String.isNotBlank(projectType.IPM_Gate_Document__c) &&  
            		projectType.IPM_Gate_Document__c == gateDocument && 
             		projectType.Source_Project_Type__c == project.IPM_SourceProjectType__c &&  
               		projectType.IPM_GateKeeping_Model__c == project.IPM_GateKeeping_Model__c && 
                    projectType.IPM_Source_Company_Card__c == project.IPM_CompanyCardText__c &&
                    projectType.IPM_Phase__c == project.IPM_Phase__c )
                    {
                    	filteredProjectTypeList.add(projectType);	
                    }
            } 
        }
        
        System.debug('filteredProjectTypeList-->>'+filteredProjectTypeList);
        return filteredProjectTypeList;
        
    }
	
    /**************************************************************
    * @description: Get Section Copy Mapping from Custom Setting and create a map of GateType => (external ID To Section Mapping).
     Used for Project back Ground Process.
    */

    public static Map<String,Map<String,IPM_Section_Copy_Mapping__c>>  getSectionCopyOverMapping()
    {
        Map<String,Map<String,IPM_Section_Copy_Mapping__c>> gateToSectionCopyOverMap = new Map<String,Map<String,IPM_Section_Copy_Mapping__c>>();
        
        Map<String,IPM_Section_Copy_Mapping__c>  sectionCopyMapping = IPM_Section_Copy_Mapping__c.getAll();  
        
        for(IPM_Section_Copy_Mapping__c sectionCopyMappingObj : sectionCopyMapping.values())
        {
            String gateType = sectionCopyMappingObj.Type_Of_Gate__c;
            Map<String,IPM_Section_Copy_Mapping__c> sectionExtIdToMappingObjMap = new Map<String,IPM_Section_Copy_Mapping__c>();
            
            if(gateToSectionCopyOverMap.containsKey(gateType))
            {
                sectionExtIdToMappingObjMap = gateToSectionCopyOverMap.get(gateType);
            }
            sectionExtIdToMappingObjMap.put(sectionCopyMappingObj.Section_External_Id_To_Copy_Over__c,sectionCopyMappingObj);
            gateToSectionCopyOverMap.put(gateType,sectionExtIdToMappingObjMap); 
        }
        return  gateToSectionCopyOverMap;
    }
    
    /**************************************************************
    * @description: Used for Getting Gate Specific information for OTIF. Used for Project back Ground Process.
    */
    
    public static Map<String,List<IPM_OTIF_Status__c>>  getOTIFMapping()
    {
        Map<String,List<IPM_OTIF_Status__c>> gateToOTIFSectionMap = new Map<String,List<IPM_OTIF_Status__c>>();
        
        Map<String,IPM_OTIF_Status__c>  OTIFMapping = IPM_OTIF_Status__c.getAll();  
        
        for(IPM_OTIF_Status__c OTIFObj : OTIFMapping.values())
        {
            String gateType = OTIFObj.IPM_Gate_Document_Type__c;
            List<IPM_OTIF_Status__c> OTIFSectionList = new List<IPM_OTIF_Status__c>();
            
            if(gateToOTIFSectionMap.containsKey(gateType))
            {
                OTIFSectionList = gateToOTIFSectionMap.get(gateType);
            }
            OTIFSectionList.add(OTIFObj);
            gateToOTIFSectionMap.put(gateType,OTIFSectionList); 
        }
        return  gateToOTIFSectionMap;
    }
    
     /**************************************************************
    * @description: Used for Getting project Metadata information based on UserSelection.Invoked for Bulk Operations.
                    Used for Project back Ground Process.
    * @param1 project : Project Object containing Company Card information
    */
    
    public static List<IPM_Project_Metadata__mdt> getProjectTypeMetadata(List<IPM_Project__c> projectList)
    {
        List<IPM_Project_Metadata__mdt> projectTypeMetadataList = new List<IPM_Project_Metadata__mdt>();
        
        for(IPM_Project__c project : projectList)
        { 
            projectTypeMetadataList.add(retrieveProjectMetadata(project));  
        }
        
        return  projectTypeMetadataList;
    }
    
    /**************************************************************
    * @description: Used for Getting project Metadata information based on UserSelection.
                    Project Metadata config for Project initiation. 
    * @param1 project : Project Object containing Company Card information
    */
    
    public static IPM_Project_Metadata__mdt retrieveProjectMetadata(IPM_Project__c project)
    {
        IPM_Project_Metadata__mdt selectedProjectMetadata = null;
        List<IPM_Project_Metadata__mdt> selectedProjectMetadataList = new List<IPM_Project_Metadata__mdt>();
        
        String projectMetadataQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Metadata__mdt',false,null,true); 
        List<IPM_Project_Metadata__mdt> projectMetadataList = (List<IPM_Project_Metadata__mdt>)database.Query(projectMetadataQuery);
        // Do the First Level of filtering based on Mandatory fields.
        if(project.IPM_Company_Card__c !=null  && String.isNotBlank(project.IPM_CompanyCardText__c) !=null && String.isNotBlank(project.IPM_Category_Text__c) && String.isNotBlank(project.IPM_ProjectSubType__c) )
        {
            for(IPM_Project_Metadata__mdt projectMetadata : projectMetadataList)
            {

                if( projectMetadata.IPM_ApplicableCompanyCard__c == project.IPM_CompanyCardText__c &&  
                    projectMetadata.IPM_ApplicableCategories__c.containsIgnoreCase(project.IPM_Category_Text__c) && 
                    (projectMetadata.IPM_ProjectSubType__c.containsIgnoreCase(project.IPM_ProjectSubType__c) ) )
                {
                    selectedProjectMetadataList.add(projectMetadata); 
                } 
            }
        }
        
        // Check if GateKeeping Questions are applicable. If yes then it is the fourth parameter on which filtering should happen.
        for(IPM_Project_Metadata__mdt shortListedMetadata : selectedProjectMetadataList)            
        {
            if(shortListedMetadata.IPM_GKMQuestionsApplicable__c && String.isNotBlank(shortListedMetadata.IPM_GMKQuesiton__c))
            {
                String gateKeepingFieldAPI = shortListedMetadata.IPM_GMKQuesiton__c; 
                String projectGKMAnswer = (String)project.get(gateKeepingFieldAPI);
                if(String.isNotBlank(projectGKMAnswer) &&  projectGKMAnswer.equalsIgnoreCase(shortListedMetadata.IPM_GMKQuestionAns__c))
                {
                    selectedProjectMetadata = shortListedMetadata;
                    break;
                } 
            }
        }

        if(selectedProjectMetadata == null)
        {
            if(!selectedProjectMetadataList.isEmpty())
            {
                selectedProjectMetadata = selectedProjectMetadataList.get(0);                 
            }
            else
            {
                selectedProjectMetadata = new IPM_Project_Metadata__mdt();         
            }
        }
        return selectedProjectMetadata;
    }
    
    /**************************************************************
    * @description: Used for Getting project Metadata information based on Selected Company Card.Used in Project Initiation. 
    * @param1 project : Project Object containing Company Card information
    */
    
    public static List<IPM_Project_Metadata__mdt> getProjectTypesBasedOnCompanyCard(IPM_Project__c project)
    {
        List<IPM_Project_Metadata__mdt> projectMetadataList = new List<IPM_Project_Metadata__mdt>();
       
        String projectMetadataQuery = IPM_Utils.prepareSOQLQuery('IPM_Project_Metadata__mdt',false,null,true); 
        // As per the new logic, add Category and Sub Project Type to the filtering to get Project Metadata.
        if(project.IPM_Company_Card__c !=null && !String.isBlank(project.IPM_CompanyCardText__c) && !String.isBlank(project.IPM_Category_Text__c) )
        {
            for(IPM_Project_Metadata__mdt projectMetadata : (List<IPM_Project_Metadata__mdt>)database.Query(projectMetadataQuery) ) 
            {
                if(projectMetadata.IPM_ApplicableCompanyCard__c == project.IPM_CompanyCardText__c && 
                    projectMetadata.IPM_ApplicableCategories__c.containsIgnoreCase(project.IPM_Category_Text__c)) 
                {
                    projectMetadataList.add(projectMetadata); 
                } 
            }
        }
        
        return projectMetadataList;
    }
    
    
    //create map of project id and its ITO Year value
    public static Map<Id, Decimal> createProjectITOValueMap() {
        
        Decimal iTOValue = 0.00;
        Map<Id,Decimal> projIdiTOMap =  new Map<Id,Decimal>();
        
        //query financial year and financial deatils
        IPM_Financial_Year__c[] finYearDetails = [SELECT Turnover_Global__c, Turnover_Regional__c,Turnover_Local__c ,IPM_Financial__r.Parent_Project__c,IPM_Financial__r.Regional_Project__c,IPM_Financial__r.Regional_Project__r.IPM_Project_Type__c,IPM_Financial__r.Local_Project__c,IPM_Financial__r.IPM_Project_Rollout__c,
                                                        IPM_Financial__r.RecordTypeId,IPM_Financial__r.Business_Impact_Global__c,IPM_Financial__r.name,IPM_Financial__r.Local_Project__r.IPM_Project_Type__c,IPM_Financial__r.Parent_Project__r.IPM_Phase__c, IPM_Financial__r.Parent_Project__r.IPM_Project_Type__c //SS change
                                                  FROM IPM_Financial_Year__c
                                                  WHERE Year__c = '3' AND Year_Type__c =: IPM_ConstantUtils.YEAR_TYPE_INNOVATION AND PL_Type__c =: IPM_ConstantUtils.PL_TYPE_INCREMENTAL    
                                                  LIMIT 50000];
        if(!finYearDetails.isEmpty()){
            for(IPM_Financial_Year__c finYr :finYearDetails){
                
                //additional condition - Global Project and not Ideas phase then Y3iTO should be from Market Cluster and not from Top Down
                if(finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT) 
                    && finYr.IPM_Financial__r.IPM_Project_Rollout__c == null && finYr.IPM_Financial__r.Regional_Project__c == null && finYr.IPM_Financial__r.Local_Project__c == null
                    && finYr.Turnover_Global__c != null && finYr.IPM_Financial__r.Parent_Project__c != null ) 
                {
                    iTOValue = finYr.IPM_Financial__r.Parent_Project__r.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS ? (finYr.Turnover_Global__c)/1000 : (finYr.Turnover_Regional__c)/1000; 

                    projIdiTOMap.put(finYr.IPM_Financial__r.Parent_Project__c,iTOValue);
                }
                
                //Regional Financial : RT = CONSOLIDATED + Regional Project != null + Local Project = null
                else if(finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT)
                         && finYr.IPM_Financial__r.Regional_Project__c != null && finYr.IPM_Financial__r.Local_Project__c == null
                         && finYr.Turnover_Regional__c != null)
                {
                    iTOValue = (finYr.Turnover_Regional__c)/1000;
                    projIdiTOMap.put(finYr.IPM_Financial__r.Regional_Project__c,iTOValue);
                    
                }
                //Local Financial : RT = Default +  Local Project != null
                else if(finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT)
                        && finYr.IPM_Financial__r.Local_Project__c != null && finYr.Turnover_Local__c != null)
                { 
                    iTOValue = (finYr.Turnover_Local__c)/1000;
                    projIdiTOMap.put(finYr.IPM_Financial__r.Local_Project__c,iTOValue);
                    
                }
                
                //Global Operational
                else if(finYr.Turnover_Global__c != null && finYr.IPM_Financial__r.Parent_Project__c != null 
                            && finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT) 
                            && finYr.IPM_Financial__r.Parent_Project__r.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                    iTOValue = (finYr.Turnover_Global__c)/1000;
                    projIdiTOMap.put(finYr.IPM_Financial__r.Parent_Project__c,iTOValue);
                }
                 //Regional Operational
                else if(finYr.Turnover_Regional__c != null && finYr.IPM_Financial__r.Regional_Project__c != null 
                            && finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT) 
                            && finYr.IPM_Financial__r.Regional_Project__r.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                    iTOValue = (finYr.Turnover_Regional__c)/1000;
                    projIdiTOMap.put(finYr.IPM_Financial__r.Regional_Project__c,iTOValue);
                }
                
            }
        }
        return projIdiTOMap;
    }
    
/*************************************************************************************************************************************
    * @description          Method to create project-iTo Map : key-projectId ,value-ITO value
    * @param                Project Ids
    */
     public  static Map<Id, Decimal> createProjectSpecificITOValueMap(List<Id> projList) {    
        Decimal iTOValue = 0.00;
        Map<Id,Decimal> projIdiTOMap =  new Map<Id,Decimal>();
        //query financial year and financial deatils
        IPM_Financial_Year__c[] finYearDetails = [SELECT Turnover_Global__c, Turnover_Regional__c,Turnover_Local__c ,IPM_Financial__r.Parent_Project__c,IPM_Financial__r.Regional_Project__c,IPM_Financial__r.Regional_Project__r.IPM_Project_Type__c,IPM_Financial__r.Local_Project__c,IPM_Financial__r.IPM_Project_Rollout__c,
                                                        IPM_Financial__r.RecordTypeId,IPM_Financial__r.Business_Impact_Global__c,IPM_Financial__r.name,IPM_Financial__r.Local_Project__r.IPM_Project_Type__c,IPM_Financial__r.Parent_Project__r.IPM_Phase__c, IPM_Financial__r.Parent_Project__r.IPM_Project_Type__c //SS change
                                                  FROM IPM_Financial_Year__c
                                                  WHERE (IPM_Financial__r.Parent_Project__c IN : projList OR IPM_Financial__r.Regional_Project__c IN : projList OR IPM_Financial__r.Local_Project__c IN : projList)AND Year__c = '3' AND Year_Type__c =: IPM_ConstantUtils.YEAR_TYPE_INNOVATION AND PL_Type__c =: IPM_ConstantUtils.PL_TYPE_INCREMENTAL    
                                                  LIMIT 50000];
        if(!finYearDetails.isEmpty()){
            for(IPM_Financial_Year__c finYr :finYearDetails){
                //additional condition - Global Project and not Ideas phase then Y3iTO should be from Market Cluster and not from Top Down
                if(finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT) 
                    && finYr.IPM_Financial__r.IPM_Project_Rollout__c == null && finYr.IPM_Financial__r.Regional_Project__c == null && finYr.IPM_Financial__r.Local_Project__c == null
                    && finYr.Turnover_Global__c != null && finYr.IPM_Financial__r.Parent_Project__c != null ) 
                {
                    iTOValue = finYr.IPM_Financial__r.Parent_Project__r.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS ? (finYr.Turnover_Global__c)/1000 : (finYr.Turnover_Regional__c)/1000; 
                    projIdiTOMap.put(finYr.IPM_Financial__r.Parent_Project__c,iTOValue);
                }
                //Regional Financial : RT = CONSOLIDATED + Regional Project != null + Local Project = null
                else if(finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT)
                         && finYr.IPM_Financial__r.Regional_Project__c != null && finYr.IPM_Financial__r.Local_Project__c == null
                         && finYr.Turnover_Regional__c != null)
                {
                    iTOValue = (finYr.Turnover_Regional__c)/1000;
                    projIdiTOMap.put(finYr.IPM_Financial__r.Regional_Project__c,iTOValue);
                }
                //Local Financial : RT = Default +  Local Project != null
                else if(finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT)
                        && finYr.IPM_Financial__r.Local_Project__c != null && finYr.Turnover_Local__c != null)
                { 
                    iTOValue = (finYr.Turnover_Local__c)/1000;
                    projIdiTOMap.put(finYr.IPM_Financial__r.Local_Project__c,iTOValue);
                }
                //Global Operational
                else if(finYr.Turnover_Global__c != null && finYr.IPM_Financial__r.Parent_Project__c != null 
                            && finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT) 
                            && finYr.IPM_Financial__r.Parent_Project__r.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                    iTOValue = (finYr.Turnover_Global__c)/1000;
                    projIdiTOMap.put(finYr.IPM_Financial__r.Parent_Project__c,iTOValue);
                }
                 //Regional Operational
                else if(finYr.Turnover_Regional__c != null && finYr.IPM_Financial__r.Regional_Project__c != null 
                            && finYr.IPM_Financial__r.RecordTypeId == IPM_Utils.getFinancialRecordType(IPM_ConstantUtils.DEFAULT_FINANCIAL_RT) 
                            && finYr.IPM_Financial__r.Regional_Project__r.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                    iTOValue = (finYr.Turnover_Regional__c)/1000;
                    projIdiTOMap.put(finYr.IPM_Financial__r.Regional_Project__c,iTOValue);
                }
            }
        }
     return projIdiTOMap; 
}
/*********************************************************************************************************************
    * @description          Method to  update Y3iTo's of project 
    * @param                Project Ids
    */
public static void updateProjectY3ITOValue(List<Id> projListForY3ITOUpdate) { 
	 Map<Id,Decimal> projIdiTOMap =  IPM_Utils.createProjectSpecificITOValueMap(projListForY3ITOUpdate);
	 List<IPM_Project__c> y3iTOUpdateProjList = new List<IPM_Project__c>();
	 if(projIdiTOMap!=null && !projIdiTOMap.isEmpty()){
	 	for(Id projId :projIdiTOMap.keyset()){
	 		IPM_Project__c projForY3ITOUpdate = new IPM_Project__c(Id=projId , IPM_Project_Y3iTO__c=projIdiTOMap.get(projId)) ;
	 		y3iTOUpdateProjList.add(projForY3ITOUpdate);
	 	}
	 	if(y3iTOUpdateProjList!=Null && !y3iTOUpdateProjList.isEmpty()){
	 		update y3iTOUpdateProjList;
	 	}
	 }
} 
/*******************************************************************************************************************************
    * @description          Method to  update IPM_Sum_Y3iTO__c of project cluster as sum of Y3iTo's pf projects under the cluster
    * @param                cluster Ids
    */
public static void updateclusterSumY3iTOValue(Set<Id> clusterIDsForY3iTOUpdate){   
	List<IPM_Clusters__c> clusterListForY3iTOUpdate = new List<IPM_Clusters__c>();   
	for( AggregateResult aggrResult : [SELECT IPM_Cluster__c  , SUM(IPM_Project_Y3iTO__c) FROM IPM_Project__c where IPM_Project_Type__c=:IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL AND Is_Archieved__c = false  AND IPM_Cluster__c IN :clusterIDsForY3iTOUpdate GROUP BY IPM_Cluster__c ]){
		clusterListForY3iTOUpdate.add(new IPM_Clusters__c(Id=(Id)aggrResult.get('IPM_Cluster__c'),IPM_Sum_Y3iTO__c=(Decimal)aggrResult.get('expr0'))); 
	}
	if(!clusterListForY3iTOUpdate.isEmpty()){ 
		update clusterListForY3iTOUpdate; 
	}
} 
    /**************************************************************
    * @description: Recursive invocation to provide the List of Parents for a specific Project
    * @param1 incomingProjectIds : List of Project Ids.
    */ 
    
    public static Map<Id,IPM_Project__c> populateParentProjectDetails(Set<Id> incomingProjectIds)
    {
        Set<Id> projectIds = new Set<Id>();

        String ProjectDetailSelectQuery = IPM_Utils.prepareSOQLQuery(IPM_Project,false,null,true);
        String ProjectDetailWhereClause = 'Id in :incomingProjectIds';
        
        projectDetailSelectQuery = ProjectDetailSelectQuery  + ' WHERE ' + ProjectDetailWhereClause + LIMIT_STRING +  FORUPDATE_STRING ;
        
        Map<Id,IPM_Project__c> projectDetailedMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(ProjectDetailSelectQuery) );
        
        for(IPM_Project__c project : projectDetailedMap.values() )
        {
            if(project.IPM_Parent_Project__c !=null)
            {
                projectIds.add(project.IPM_Parent_Project__c);   
            }
        }
        
        if(!projectIds.isEmpty())
        {
            projectDetailedMap.putAll(populateParentProjectDetails(projectIds));
        }
        return projectDetailedMap;
    }
    
    /**************************************************************
    * @description: Recursive invocation to provide the List of Children against specific project
    * @param1 incomingProjectIds : List of Project Ids.
    */ 
    public static Map<Id,IPM_Project__c> populateChildProjectDetails(Set<Id> incomingProjectIds)
    {
        Set<Id> projectIds = new Set<Id>();

        String ProjectDetailSelectQuery = IPM_Utils.prepareSOQLQuery(IPM_Project,false,null,true);
        String ProjectDetailWhereClause = 'IPM_Parent_Project__c in :incomingProjectIds';
        
        ProjectDetailSelectQuery = ProjectDetailSelectQuery  + ' WHERE ' + ProjectDetailWhereClause + LIMIT_STRING ;
        
        Map<Id,IPM_Project__c> projectDetailedMap = new Map<Id,IPM_Project__c>( (List<IPM_Project__c>) database.query(ProjectDetailSelectQuery) );
        
        for(IPM_Project__c project : projectDetailedMap.values() )
        {
            projectIds.add(project.Id);   
        }
        
        if(!projectIds.isEmpty())
        {
            projectDetailedMap.putAll(populateChildProjectDetails(projectIds));
        }
        return projectDetailedMap;
    }
    
    /**************************************************************
    * @description: Prepares a map of Project with its Parent. Should be used with populateParentProjectDetails Method.
    * @param1 incomingProjectMap : project Map containing Project Details.
    * @param2 projectDetailMap : complete List of Projects associated with incoming Projects.
    */ 
    public static Map<Id,IPM_Project__c> prepareProjectToParentMapping(Map<Id,IPM_Project__c> incomingProjectMap,Map<Id,IPM_Project__c> projectDetailMap)
    {
        Map<Id,IPM_Project__c> projectToParentMapping = new Map<Id,IPM_Project__c>();
        
        for(IPM_Project__c project : incomingProjectMap.values())
        {
            if(project.IPM_Parent_Project__c !=null && projectDetailMap.containsKey(project.IPM_Parent_Project__c))
            {
                projectToParentMapping.put(project.Id,projectDetailMap.get(project.IPM_Parent_Project__c));
            }        
        }
        
        return projectToParentMapping;
    }
    
    /**************************************************************
    * @description: Prepares a map of Project with its Parent. Should be used with populateParentProjectDetails Method.
    * @param1 projectToParentMapping : Project To Parent Mapping
    * @param2 projectDetailMap : complete List of Projects associated with incoming Projects.
    */ 
    
    public static Map<Id,IPM_Project__c> prepareProjectToGrandParentMapping(Map<Id,IPM_Project__c> projectToParentMapping,Map<Id,IPM_Project__c> projectDetailMap)
    {
        Map<Id,IPM_Project__c> projectToGrandParentMapping = new Map<Id,IPM_Project__c>();
        
        for(Id projectId : projectToParentMapping.KeySet())
        {
            IPM_Project__c parentProject = projectToParentMapping.get(projectId);
            if(parentProject.IPM_Parent_Project__c !=null && projectDetailMap.containsKey(parentProject.IPM_Parent_Project__c))
            {
                projectToGrandParentMapping.put(projectId,projectDetailMap.get(parentProject.IPM_Parent_Project__c));       
            }
        }
        return projectToGrandParentMapping;
    }
    
    /**************************************************************
    * @description: Prepares a map of Project with its Children.
    * @param1 incomingProjectMap : project Map containing Project Details.
    * @param2 projectDetailMap : complete List of Projects associated with incoming Projects.
    */ 
    
    public static Map<Id,Map<Id,IPM_Project__c>> prepareProjectToChildMapping(Map<Id,IPM_Project__c> incomingProjectMap,Map<Id,IPM_Project__c> projectDetailMap)
    {
        Map<Id,Map<Id,IPM_Project__c>> projectToChildMapping = new Map<Id,Map<Id,IPM_Project__c>>();  
        
        for(IPM_Project__c inContextProject : incomingProjectMap.values())
        {
            for(IPM_Project__c projectDetail : projectDetailMap.values())
            {
                if(projectDetail.IPM_Parent_Project__c !=null && projectDetail.IPM_Parent_Project__c == inContextProject.Id)
                {
                    Map<Id,IPM_Project__c> childProjects = new Map<Id,IPM_Project__c>();
                    if(projectToChildMapping.containsKey(inContextProject.Id))
                    {
                       childProjects = projectToChildMapping.get(inContextProject.Id);  
                    }
                    childProjects.put(projectDetail.Id,projectDetail);
                    projectToChildMapping.put(inContextProject.Id,childProjects);
                }
            }
            
        }
        return projectToChildMapping;
    }
    
    /**************************************************************
    * @description: Prepares a map of Project with its Children.
    * @param1 incomingProjectMap : project Map containing Project Details.
    * @param2 projectDetailMap : complete List of Projects associated with incoming Projects.
    */ 
    public static Map<Id,Map<Id,IPM_Project__c>> prepareProjectToGrandChildMapping(Map<Id,Map<Id,IPM_Project__c>> projectToChildMap, Map<Id,IPM_Project__c> projectDetailMap)
    {
        Map<Id,Map<Id,IPM_Project__c>> projectToGrandChildMapping = new Map<Id,Map<Id,IPM_Project__c>>();  
        
        for(Id inContextProjectId : projectToChildMap.KeySet())
        {
            Map<Id,IPM_Project__c> childProjectsMap =  projectToChildMap.get(inContextProjectId);
            
            for(IPM_Project__c projectDetail : projectDetailMap.values())
            {
                if(projectDetail.IPM_Parent_Project__c !=null && childProjectsMap.containsKey(projectDetail.IPM_Parent_Project__c))
                {
                    Map<Id,IPM_Project__c> grandChildProjects = new Map<Id,IPM_Project__c>();
                    if(projectToGrandChildMapping.containsKey(inContextProjectId))
                    {
                       grandChildProjects = projectToGrandChildMapping.get(inContextProjectId);  
                    }
                    grandChildProjects.put(projectDetail.Id,projectDetail);
                    projectToGrandChildMapping.put(inContextProjectId,grandChildProjects);
                }
            } 
        }
        return projectToGrandChildMapping;
    }
    /**************************************************************
    * @description: Prepares a proejct metadata record.
    * @param1 incomingProjectMap : current project(IPM_Project__c) record.
    */ 
    public static IPM_ProjectMetadata__c getPhasesBasedOnProjectType(IPM_Project__c project)
    {
        IPM_ProjectMetadata__c selectedProjectMetadata = null;
        String strProjectType;
        /*if project has no source type value*/
        if(project.IPM_SourceProjectType__c != null ){
            strProjectType = project.IPM_SourceProjectType__c;
        }else if(project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){ // if Project type is Operational 
                strProjectType = IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL;
        }else{ // If project type is not operational, It can be Original or Rollout of Original
            strProjectType = IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL;
        }
        
        // Get the source Project Type and Source Company card to identify the Phase Sequence.
        for(IPM_ProjectMetadata__c projectMetadata : IPM_ProjectMetadata__c.getAll().values())
        {
            
            if(projectMetadata.IPM_ApplicableCompanyCard__c == project.IPM_CompanyCardText__c && projectMetadata.IPM_Project_Type__c == strProjectType)
            {
                selectedProjectMetadata = projectMetadata;
                break;
            }
        }
        return selectedProjectMetadata;    
    }
    /**************************************************************
    * @description: get the apex job sataus and sends an email to the user who has initiated the job.
    * @param1 incomingProjectMap : Database.BatchableContext
    */ 
    public static void sendApexJobStatusMail(Database.BatchableContext bC)
    {
      // Query the AsyncApexJob object to retrieve the current job's information.
       AsyncApexJob apexJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email
                  FROM AsyncApexJob 
                  WHERE Id =:bC.getJobId()];
                  
       // Send an email to the Apex job's submitter notifying of job completion.
      // The below code snippet is sample and can utilze the common email notifcation class for IPM NG project
     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
     String[] toAddresses = new String[] {apexJob.CreatedBy.Email};
     mail.setToAddresses(toAddresses);
     mail.setSubject(emailSubject + apexJob.Status);
     mail.setPlainTextBody(emailBody1 + apexJob.TotalJobItems + emailBody2 + apexJob.NumberOfErrors + emailBody3);
     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
    /**************************************************************
    * @description: find whetehr the project has Section 5.3 (Environmental Section) or not
    * @param1 proj : project record
    */
    public static Boolean isProjectToBeSyncedToEcoDesign(IPM_Project__c proj){
        if( retrieveProjectType(proj).IPM_Dont_Sync_Proj_To_EcoDesign__c || proj.IPM_ProjectSubType__c == IPM_ConstantUtils.IPM_BLG
        ){
            return false;
        }
        else{
            return true;
        }
    }
    
    public static Boolean validateTriggerSkip()
    {
        if(Trigger.isExecuting)
        {
            string CSkey=IPM_ConstantUtils.BLANK;
            List<sObject> sobjectList = Trigger.New;
            if(Trigger.isInsert)
            {
                if(Trigger.New!=null && !Trigger.New.isEmpty())
                {
                    sobjectList = Trigger.New;
                    CSkey = sobjectList[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
                }   
            }
            else
            {
                if(Trigger.old != null && !Trigger.old.isEmpty())
                {
                    sobjectList = Trigger.Old;
                    CSkey = sobjectList[0].getSObjectType().getDescribe().name.replace('__c','')+'Trigger';
                }
            }
            
            if(String.isNotBlank(CSkey))
            {
                IPM_Trigger_Router__c triggerRouter = IPM_Trigger_Router__c.getInstance(CSkey); 
                if(triggerRouter!=null && triggerRouter.is_Disabled__c)
                {
                    return true;
                }
            }  
        } 
        return false;
    } 
    
     /*******************************************************************************************************
    * @description              Method to get Financial External Id
    * @param projectRollout     Rollout for which external id needs o be generated
    * @return                   Financial External Id
    */
    public static String getFinancialExternalId(IPM_Project_Rollout__c projectRollout)
    { 
        if (projectRollout.KeyMCO__c)
        {
            return projectRollout.IPM_Rollout_Project__c;
        }
        else
        { 
            if(projectRollout.Added_At_Stage__c == IPM_ConstantUtils.PHASE_IDEAS)
            {
                return projectRollout.Regional_Rollout_External_Id__c + IPM_ConstantUtils.FINANCIAL_NONKEY;
            }
            else
            {
                return projectRollout.IPM_Rollout_Project__c;
            }
            
        }
    }
    /*******************************************************************************************************
    * @description          Method to get Financial Year
    * @param Set<String>    Local Project Name
    * @return               Map of Financial Year
    */
    public static Map<String,IPM_Financial_Year__c> getRelatedY1InnovationYear(Set<String> externalIdSet) {
        Map<String,IPM_Financial_Year__c> financialYearMap = new Map<String,IPM_Financial_Year__c>(); 
        for(IPM_Financial_Year__c financialYear : [Select Id, Turnover_Regional__c, GM_of_TO_Regional__c, Financial_External_Id__c,
                                                    Global_External_Id__c,External_Id__c
                                             from IPM_Financial_Year__c
                                             where Year__c =: IPM_ConstantUtils.INTRODUCTION_HEADER_SEQUENCE 
                                             AND Year_Type__c =: IPM_ConstantUtils.YEAR_TYPE_INNOVATION
                                             AND PL_Type__c =: IPM_ConstantUtils.PL_TYPE_GROSS 
                                             AND Financial_External_Id__c IN: externalIdSet]) {
            financialYearMap.put(financialYear.Financial_External_Id__c,financialYear);                                     
        }
        return financialYearMap;
    }
    
    /*******************************************************************************************************
    * @description              Method to get Financial Year
    * @param fieldSet Name      Name of the field set
    * @param object name        Name of object from where we need to get fields
    * @param object name        Name of object from where we need get records
    * @return                   Concatinated string with set of fields from FieldSet
    */
    public static String getSOQLQueryFromFieldSet(String fieldSetName,String fieldSetSobjectName,boolean excludePercentageFlds) 
    {
        String queryString = IPM_ConstantUtils.BLANK;
        Map<String,Schema.SobjectType> globalDescribeMap = Schema.getGlobalDescribe();
        Map<String,Schema.SObjectField> sobjFldMap;
        Schema.FieldSet targetFieldSetObject = null;
        if(globalDescribeMap.containsKey(fieldSetSobjectName)) 
        {
            Schema.DescribeSObjectResult sobjectDescResult = globalDescribeMap.get(fieldSetSobjectName).getDescribe(); 
            sobjFldMap = sobjectDescResult.fields.getMap(); 
            Map<String, Schema.FieldSet> associatedFieldSetMap = sobjectDescResult.fieldSets.getMap();
            if(associatedFieldSetMap.containsKey(fieldSetName)) 
            {
                targetFieldSetObject = associatedFieldSetMap.get(fieldSetName); 
                
            }
        }
        if(targetFieldSetObject != null) {
            queryString = 'SELECT ';
            for(Schema.FieldSetMember targetField : targetFieldSetObject.getFields()) {
                if(targetField.getFieldPath() != IPM_ConstantUtils.SF_ID && sobjFldMap.get(targetField.getFieldPath()).getDescribe().getType() != Schema.DisplayType.Percent && excludePercentageFlds) {
                    queryString += targetField.getFieldPath();
                    queryString += ','; 
                }
                if(targetField.getFieldPath() != IPM_ConstantUtils.SF_ID && !excludePercentageFlds) {
                    queryString += targetField.getFieldPath();
                    queryString += ','; 
                }
            }
            queryString += 'Id,External_Id__c FROM '+fieldSetSobjectName;
        }   
        return queryString;
    }

	 /*******************************************************************************************************
    * @description          Method to update Financial Year in Financial Action Standards records
    * @param List<IPM_Financial_Action_Standards__c>    Financial Action Standards Records
    */
    @InvocableMethod
    public static void updateFinancialYear(List<IPM_Financial_Action_Standards__c> finActionStandards){
    	try{
	        Set<Id> projectIdsSet=new Set<Id>();
	        Set<Id> finActionIds=new Set<Id>();
	        for(IPM_Financial_Action_Standards__c finActionStandard:finActionStandards){
	            projectIdsSet.add(finActionStandard.IPM_Project__c);
	            finActionIds.add(finActionStandard.Id);
	        }
	        List<IPM_Financial_Action_Standards__c> updateFinActionList=new List<IPM_Financial_Action_Standards__c>();
	        List<IPM_Financial_Year__c> finYears=new List<IPM_Financial_Year__c>();
	        finYears=[SELECT Id,IPM_Financial__c,IPM_Financial__r.Parent_Project__c,NameYearPLtype__c FROM IPM_Financial_Year__c WHERE IPM_Financial__r.Parent_Project__c In:projectIdsSet AND (NameYearPLtype__c=:IPM_ConstantUtils.Y1InnovationIncremental OR NameYearPLtype__c=:IPM_ConstantUtils.Y1InnovationGross)];
	        for(IPM_Financial_Action_Standards__c updateFinActionStandard:[SELECT Id,IPM_Financial_Year_Y1_Incremental__c,IPM_Financial_Year_Y1_Gross__c,IPM_Project__c FROM IPM_Financial_Action_Standards__c WHERE Id In:finActionIds]){
	            for(IPM_Financial_Year__c finYear:finYears){
	               if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationIncremental && finYear.IPM_Financial__r.Parent_Project__c==updateFinActionStandard.IPM_Project__c){
	                    updateFinActionStandard.IPM_Financial_Year_Y1_Incremental__c=finYear.Id;
	                }
	                if(finYear.NameYearPLtype__c==IPM_ConstantUtils.Y1InnovationGross && finYear.IPM_Financial__r.Parent_Project__c==updateFinActionStandard.IPM_Project__c){
	                    updateFinActionStandard.IPM_Financial_Year_Y1_Gross__c=finYear.Id;
	                }
	            }
	            updateFinActionList.add(updateFinActionStandard);
	        }
	        if(updateFinActionList!=null && !updateFinActionList.isEmpty()){
	            update updateFinActionList;
	        }
    	}
    	catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,
                    UPDATE_FINANCIAL_YEAR_STR,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null, IPM_ConstantUtils.IPM_NG_APPLICATION); 
    	}            
    }    	
    /************************************************************************************************************************
    * @description          Method to  return Map of IPM_Category_Thresholds__mdt with key as concatenation of various fields
    * @param                No param 
    */ 
    public static Map<String ,IPM_Category_Thresholds__mdt> getCategorythresholdMap()
    {
        Map<String ,IPM_Category_Thresholds__mdt> masterCategoryThrshMap = new Map<String ,IPM_Category_Thresholds__mdt>();
        String categoryThresholdQuery = IPM_Utils.prepareSOQLQuery('IPM_Category_Thresholds__mdt',false,null,true); 
        for(IPM_Category_Thresholds__mdt Cat_mdt : (List<IPM_Category_Thresholds__mdt>)database.Query(categoryThresholdQuery) )
        {
              String thrMapKey = Cat_mdt.IPM_Category__c+Cat_mdt.IPM_Category_Group__c+Cat_mdt.IPM_Project_Span__c ;
              
              if(String.isNotBlank(Cat_mdt.IPM_Market_Cluster__c)) 
              {
              	thrMapKey = thrMapKey + Cat_mdt.IPM_Market_Cluster__c;
              }
               
              masterCategoryThrshMap.put(thrMapKey ,Cat_mdt);
        }
        return masterCategoryThrshMap;
    }         	
    public static Map<Id,Set<Id>> getImmediateChildProjects(Set<Id> incrementalProjectSetId)
    {
        Set<Id> tempProjectSetIds = new Set<Id>(incrementalProjectSetId);
        incrementalProjectSetId.clear(); 
        Map<Id,Set<Id>> parentToChildProjectMap = new Map<Id,Set<Id>>();
         //query project to get its parent and child project ids                      
        for(IPM_Project__c project : [SELECT Id,(SELECT Id from IPM_Projects__r) FROM IPM_Project__c WHERE Id IN : tempProjectSetIds])
        {   
            if(!project.IPM_Projects__r.isEmpty()) 
            {
                Map<Id,IPM_Project__c> childProjectMap = new Map<Id,IPM_Project__c>(project.IPM_Projects__r);
                parentToChildProjectMap.put(project.Id,childProjectMap.keySet());
                incrementalProjectSetId.addAll(childProjectMap.keySet()); 
            }
            else
            {
                parentToChildProjectMap.put(project.Id,new Set<Id>());
            }
        }
        return parentToChildProjectMap;
    }
    public static void getAllChildProjects(Id sourceProjectId, Id childProjectId,Map<Id,Set<Id>> immediateProjectChildMap,Set<Id> allChildProject)
    {
        for(Id tempChildProjectId : immediateProjectChildMap.get(childProjectId))  
        {
            getAllChildProjects(sourceProjectId,tempChildProjectId,immediateProjectChildMap,allChildProject);    
            if(sourceProjectId != tempChildProjectId )
            {
                allChildProject.add(tempChildProjectId);    
            }
        }
        if(sourceProjectId != childProjectId)
        {
            allChildProject.add(childProjectId);    
        }
    }
	/**********
	Business partner can reactivate the Stopped(Archieved) projects, Below changes have been added only for Archieved project 
	********/ 
    public static Boolean overrideAccessForBusinessPartner(IPM_Project__c project, Boolean isEditable){
    	Boolean isEditAccess = isEditable; 
    	if(project.Is_Archieved__c && !isEditAccess )
    	{ 
    		IPM_CustomPermission cpr = new IPM_CustomPermission();
        	isEditAccess = cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
    	}
    	return isEditAccess;
	}
}