/**********************************************************************
Name: OV_ChatterServiceImpl
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class for implemeting OV_ChatterService interface
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_ChatterServiceImpl implements OV_ChatterService {	

    public OV_ChatterServiceImpl() {
        this.currentUserId = UserInfo.getUserId();		
	}

    public OV_ChatterServiceImpl(Id userId) {
        this.currentUserId = userId;
    }
    
    public EntitySubscription followReport(Id reportId) {
        return follow(this.currentUserId, reportId, true);
    }

    public void unfollowReport(Id reportId) {
        unfollow(this.currentUserId, reportId);
    }

    public EntitySubscription followFavouriteReport(Id favouriteObjectId) {
        return follow(this.currentUserId, favouriteObjectId, true);
    }

    public void unfollowFavouriteReport(Id favouriteObjectId) {
        unfollow(this.currentUserId, favouriteObjectId);
    }

    
    public EntitySubscription followReport(OV_Report__c report) {        
        return follow(this.currentUserId, report.Id, true);
    }
    
    public EntitySubscription followKPIElement(Id kpiElementId, Boolean insertFlag) {        
        return follow(this.currentUserId, kpiElementId, insertFlag);
    }
 
    public EntitySubscription followKPIElement(OV_KPI_Element__c kpiElement, Boolean insertFlag) {        
        return follow(this.currentUserId, kpiElement.Id, insertFlag);        
    }
    
    public EntitySubscription followKPIElementInterest(Id kpiElementInterestId, Boolean insertFlag) {        
        return follow(this.currentUserId, kpiElementInterestId, insertFlag);        
    }
    
    public EntitySubscription followKPIElementInterest(OV_KPI_Element_Interest__c kpiElementInterest, Boolean insertFlag) {        
        return follow(this.currentUserId, kpiElementInterest.Id, insertFlag);        
    }

    private Id currentUserId;

    public static EntitySubscription follow(Id userIdOfFollower, Id sobjectToFollowId, Boolean insertFlag) {        
        System.debug(LoggingLevel.DEBUG, 'follow - userIdOfFollower:' + userIdOfFollower + ', sobjectToFollowId:' + sobjectToFollowId);
        
        try {
            EntitySubscription subsciption = new EntitySubscription();
            subsciption.subscriberId = userIdOfFollower;
            subsciption.parentId = sobjectToFollowId;

            if(insertFlag){
                insert subsciption;
                return subsciption;
            }else{
                return subsciption;
            }
            
        } catch(Exception e){
            System.debug(LoggingLevel.ERROR, 'follow catch block:' + e);
            return null;
            // TODO - what can we do to handle an @future exception
        }
    }

    public static void unfollow(Id userIdOfFollower, Id sobjectToFollowId) {        
        System.debug(LoggingLevel.DEBUG, 'unfollow - userIdOfFollower:' + userIdOfFollower + ', sobjectToFollowId:' + sobjectToFollowId);
        
        try{
            EntitySubscription subsciption = [SELECT Id FROM EntitySubscription WHERE subscriberId =:userIdOfFollower AND parentId =:sobjectToFollowId LIMIT 1];
            delete subsciption;
        }catch(Exception e) {
            System.debug(LoggingLevel.ERROR, 'unfollow catch block:' + e);
            // TODO - what can we do to handle an @future exception
        }
    }
}