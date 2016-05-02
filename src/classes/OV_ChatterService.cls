/**********************************************************************
Name: OV_ChatterService
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Interface for OV_ChatterServiceImpl object
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/07/2015      INITIAL DEVELOPMENT
**********************************************************************/
public interface OV_ChatterService {
	EntitySubscription followReport(Id reportId);

    void unfollowReport(Id reportId);

	EntitySubscription followReport(OV_Report__c report);

    void unfollowFavouriteReport(Id favouriteObjectId);

    EntitySubscription followFavouriteReport(Id favouriteObjectId);

	EntitySubscription followKPIElement(Id kpiElementId, Boolean insertFlag);

	EntitySubscription followKPIElement(OV_KPI_Element__c kpiElement, Boolean insertFlag);

	EntitySubscription followKPIElementInterest(Id kpiElementInterestId, Boolean insertFlag);

	EntitySubscription followKPIElementInterest(OV_KPI_Element_Interest__c kpiElementInterest, Boolean insertFlag);
}