/**********************************************************************
Name: OV_KpiDimensionService
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Interface containing methods Kpi Dimension Services must implement to enforce best practice.
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela       02/10/2015          INITIAL DEVELOPMENT
**********************************************************************/
public interface OV_KpiDimensionService {

	//Define the method signature to be implemented in classes that implements the interface
	//Example method test
	List<OV_KpiDimensionWrapper> getKpiNames();    
}