/**********************************************************************
Name: OV_KpiController
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Wrapper dedicated for KPI
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela       02/10/2015          INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_KpiWrapper {

	@AuraEnabled
    public String message = null;

    @AuraEnabled
    public String status = null;

    @AuraEnabled
    public Map<String, Object> data = null;

    public OV_KpiWrapper(String cMessage, String cStatus, Map<String, Object> cData) {
        this.message = cMessage;
        this.status = cStatus;
        this.data = cData;
    }

    public class KPIMappingWrapper implements Comparable {
        public OV_GetKPI_Mapping__c mapping;
    
        // Constructor
        public KPIMappingWrapper(OV_GetKPI_Mapping__c mp) {
            mapping = mp;
        }
    
        public Integer compareTo(Object compareTo) {
            // Cast argument to KPIMappingWrapper
            KPIMappingWrapper compareToOppy = (KPIMappingWrapper)compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (mapping.Order__c > compareToOppy.mapping.Order__c) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (mapping.Order__c < compareToOppy.mapping.Order__c) {
                // Set return value to a negative value.
                returnValue = -1;
            }
            
            return returnValue;       
        }
    }

    public class KPITransactionWrapper implements Comparable {
        public Map<String, String> transact;
        public Map<String, OV_GetKPI_Mapping__c> customSettingsMapping;
    
        public KPITransactionWrapper(Map<String, String> trans , Map<String, OV_GetKPI_Mapping__c> customSetting) {
            transact = trans;
            customSettingsMapping = customSetting;
        }
        
        public Integer compareTo(Object compareTo) {
            KPITransactionWrapper compareObj = (KPITransactionWrapper)compareTo;

            Map<String,String> compareToOppy = (Map<String,String>)compareObj.transact;
     
            Integer transactCounter = 0;
            Integer compareCounter  = 0;

            for(OV_GetKPI_Mapping__c cSetting : customSettingsMapping.values()){
                String fieldApiName = cSetting.Field_API_Name__c;                         
                
                if( transact.containsKey(cSetting.Name) && transact.get(cSetting.Name).containsIgnoreCase('total') ){
                    transactCounter = transactCounter + 1;
                }

                if( compareToOppy.containsKey(cSetting.Name) && compareToOppy.get(cSetting.Name).containsIgnoreCase('total') ){
                    compareCounter = compareCounter + 1;
                }
            }

            if (transactCounter < compareCounter) {
                return 1;
            }else if(transactCounter > compareCounter){
                return -1;
            }else{
                return 0;
            } 
        }
    }    
}