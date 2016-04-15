/**********************************************************************
Name: OV_KpiDimensionWrapper
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Wrapper for dimensions used in KPIs
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela         02/10/2015          INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_KpiDimensionWrapper {
	@AuraEnabled
	public Id id;
	@AuraEnabled
	public String name;
	@AuraEnabled
	public List<OV_KpiDimensionWrapper> children;

	public OV_KpiDimensionWrapper(String cDimensionId, String cDimensionName){
		this.id = cDimensionId;
		this.name = cDimensionName;
		this.children = new List<OV_KpiDimensionWrapper>();
	}

	public void addChild(OV_KpiDimensionWrapper cDimensionObject){
		this.children.add(cDimensionObject);
	}
}