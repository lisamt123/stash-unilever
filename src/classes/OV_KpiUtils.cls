/**********************************************************************
Name: OV_KpiUtils
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Util class to store all methods needed for KPI.
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela       05/10/2015          INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_KpiUtils {

	public OV_KpiUtils() {

	}

    public static Map<String, OV_GetKPI_Mapping__c> getKpiMapping(){
        return OV_GetKPI_Mapping__c.getAll();
    }

    public static Map<String, String> getKpiSearchMapping(){
        Map<String, String> result = new Map<String, String>();
        Map<String, OV_GetKPI_Mapping__c> myKpiMapping = OV_GetKPI_Mapping__c.getAll();

        for(OV_GetKPI_Mapping__c myMapping : myKpiMapping.values()){
            result.put(myMapping.Name, myMapping.Field_API_Name__c);
        }

        return result;
    }

    public static Map<String, OV_GetKPI_Mapping__c> getKpiSearchMappingCS(){

        return OV_GetKPI_Mapping__c.getAll();
    }

    /*******************************************************************
    Purpose: Method resposible for returning hierarchical filters
    Parameters: [String elementName]
    Returns: List<Object>
    SONAR REPORT: npath complexity because using recursion
    ********************************************************************/
	public static List<Object> getSortedNestedFilters(String elementName, Boolean isHierarchical, String objectName){
        List<Object> result = new List<Object>();

		String queryFields = ( isHierarchical != null && isHierarchical ) ? 'Id, Name, Parent_Id__c' : 'Id, Name';

        String soql = 'SELECT ' + queryFields + ' FROM ' + objectName + ' ORDER BY Name ASC';
        List<sObject> elements = Database.query(soql);

        Map<Id, sObject> elementIdToObject = new Map<Id, sObject>();

        Map<Id, List<Id>> objectToChildrenMap = new Map<Id, List<Id>>();
        List<Id> topNodes = new List<Id>();

        for(sObject element : elements){
            Id elementId = (Id)element.get('Id');

            if(! elementIdToObject.containsKey(elementId)){
                elementIdToObject.put( elementId, element);
            }

            if(! objectToChildrenMap.containsKey(elementId)){
                objectToChildrenMap.put(elementId, new List<Id>());
            }

            Id elementObjectParentId = ( isHierarchical != null && isHierarchical ) ? (Id) element.get('Parent_Id__c') : null;

            if( elementObjectParentId == null ){
                topNodes.add(elementId);
            }else{
                if( ! objectToChildrenMap.containsKey(elementObjectParentId) ){
                    objectToChildrenMap.put( elementObjectParentId , new List<Id>());
                }
                objectToChildrenMap.get( elementObjectParentId ).add(elementId);
            }
        }

        for(Id topId : topNodes){
            sObject wrappedObject = elementIdToObject.get(topId);

            OV_KpiDimensionWrapper topNode = new OV_KpiDimensionWrapper(topId, (String)wrappedObject.get('Name'));
            generateNodes(topNode, objectToChildrenMap, elementIdToObject);
            result.add(topNode);
        }

        return result;
    }

    public static void generateNodes(OV_KpiDimensionWrapper element, Map<Id, List<Id>> children, Map<Id, sObject> elementIdToObject){
        if(children.containsKey(element.id)){
            List<Id> childrenList = children.get(element.id);
            if( !childrenList.isEmpty() ){
                for(Id childId : childrenList){
                	sObject wrappedObject = elementIdToObject.get(childId);
                    OV_KpiDimensionWrapper child = new OV_KpiDimensionWrapper(childId, (String)wrappedObject.get('Name'));
                    element.addChild(child);
                    generateNodes(child, children, elementIdToObject);
                }
            }
        }
    }

}