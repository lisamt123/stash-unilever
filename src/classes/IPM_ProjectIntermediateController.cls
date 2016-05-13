/**
* @author Cognizant(Kannan and Samrat)
* @date 23/01/2015
* @description Handles Redirection to Core Parameters, Task Generation, Project Scope, Team Members Pages,Used in ipmNavMenuRevamp2 Visualforce Component
*/
public virtual with sharing class IPM_ProjectIntermediateController {
    //Initializing Variables
    public IPM_Project__c project {get; set;} //Used for Getting Project Record
    public String projectId{get;set;} //For Getting Project Id from Page URL Parameters
    /**
    * @description Getting Page Parameters and Retrieving Appropriate Project Record
    */ 
    
    public static final Set<String> systemFields = new set<String>{'lastmodifiedbyid','isdeleted','createdbyid', 'lastmodifieddate', 'createddate','isdeleted'};
    
    public static final Set<String> userFields = new Set<String>{'Id','name','email','username'};
    
    public IPM_ProjectIntermediateController()
    {
        Apexpages.currentPage().getHeaders().put(System.Label.IPM_X_UA_Compatible, System.Label.IPM_IE_9);
        projectId=ApexPages.currentPage().getParameters().get(System.Label.IPM_Project_ID);
        if(projectId=='' || projectId==null)
        {
            projectId=ApexPages.currentPage().getParameters().get(System.Label.IPM_Project_PID);
        }
        //Getting Project Record Using Project Id from Page URL Parameters
        if(projectId!=null)
        {
            getProjectInformation(projectId);
        }
    }
    
    public void getProjectInformation(Id projectId)
    {
        
        String queryStr = ' SELECT ';
        
        Map<String,Schema.SObjectField> fieldTypeMap = Schema.SObjectType.IPM_Project__c.fields.getMap();
        
        Map<String,Schema.SObjectField> userFieldTypeMap = Schema.SObjectType.User.fields.getMap();
        
        Set<String> userCustomfieldSet = new Set<String>();
        
        /* Get User Custom Field Information */
        
        for(String userfieldAPIName : userFieldTypeMap.keySet())
        {
            Schema.DescribeFieldResult userfieldDescribe = userFieldTypeMap.get(userfieldAPIName).getDescribe();
            if(userfieldDescribe.isCustom())
            {
                userCustomfieldSet.add(userfieldAPIName);
            }
        } 
        
        /* Get Project Specific Field information */
        
        for(String fieldAPIName : fieldTypeMap.keySet())
        {
            Schema.DescribeFieldResult fieldDescribe = fieldTypeMap.get(fieldAPIName).getDescribe();
            
            if(!fieldDescribe.isNamePointing() &&  !fieldAPIName.equalsIgnoreCase('Id') && !systemFields.contains(fieldAPIName))
            {
                queryStr += ' '+fieldAPIName+',';
            }
            /* Check if it is a Reference field, If yes, get asociated Data */
            if(fieldDescribe.getType() == Schema.DisplayType.Reference && fieldDescribe.isCustom())
            {
                List <Schema.sObjectType> relatedObjectList = fieldDescribe.getReferenceTo();
                String relationshipName = fieldDescribe.getRelationshipName();
                if(relatedObjectList!=null && !relatedObjectList.isEmpty() && relationshipName!=null)
                {
                    Schema.DescribesObjectResult relatedObjDescribe =  relatedObjectList[0].getDescribe();
                    String relatedObjectAPI = relatedObjDescribe.getName();
                    
                        Map<String,Schema.SObjectField> relatedfieldTypeMap = relatedObjDescribe.fields.getMap();     
                        for(String relatedfieldAPIName : relatedfieldTypeMap.keySet())
                        {
                            Schema.DescribeFieldResult relatedFieldDescibe = relatedfieldTypeMap.get(relatedfieldAPIName).getDescribe();
                            if(!relatedFieldDescibe.isNamePointing()  && !systemFields.contains(relatedfieldAPIName) )
                            {
                                if(relatedObjectAPI == 'User' && (userCustomfieldSet.contains(relatedfieldAPIName) || userFields.contains(relatedfieldAPIName) ))
                                {
                                    queryStr += ' ' + relationshipName+'.'+relatedfieldAPIName+',';
                                }
                                else
                                {
                                   queryStr += ' ' + relationshipName+'.'+relatedfieldAPIName+',';
                                }
                            }
                        }
                }
            }
        }
         
        queryStr += 'Id from IPM_Project__c where Id= :projectId';
        List<IPM_Project__c> projectList = Database.query(queryStr);
        if(projectList != null && !projectList.isEmpty())
        {
            project = projectList[0]; 
        }
    } 
}