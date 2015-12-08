/**********************************************************************
Name: OV_KpiTransactionService
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Interface containing methods Kpi Transaction Services must implement to enforce best practice.
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Pawel Niedziela       08/10/2015          INITIAL DEVELOPMENT
**********************************************************************/
public interface OV_KpiTransactionService {
	Map<String, Object> getKPITransactions(Map<String, Set<Id>> dimensions);
}