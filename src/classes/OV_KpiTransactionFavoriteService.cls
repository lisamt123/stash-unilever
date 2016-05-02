/**********************************************************************
Name: OV_KpiTransactionFavoriteServiceImpl
Copyright © 2015 Salesforce.

============================================================================
============================================================================
Purpose: Interface used for methods used agains KPIs (favourites) 
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             15/10/2015      INITIAL DEVELOPMENT
**********************************************************************/
public interface OV_KpiTransactionFavoriteService{
    void addKpisToFavorite(List<OV_Wrapper.KpiFavouriteTransactionWrapper> favouriteTransactions);

	void deleteFavoriteKpi(String kpiTransactionId);
    
    List<Map<String, String>> listFavorites();

    void editKpiTransactionsFavorite(String kpiTransactionFavouriteId, Boolean wantsNotification, String reportId);
}