/***************************************************************
Name: UL_PromotionClosure
======================================================
Purpose:
Handle closure of one or multiple Promotions
======================================================
History
-------
VERSION     AUTHOR			DATE             DETAIL                 Description
1.0         Marcel Schulz	18/01/2017       Initial Development    Handle closure of one or multiple Promotions (validate whether closure is possible and then call a batchjob that does the closure)
***************************************************************/

global with sharing class UL_PromotionClosure {
	
    /*******************************************************************
        Purpose: closes promotions (used by AJAX Toolkit Button) 
        Version 1.0
        Parameters: List of Promotion Ids
        Returns: Success or Error messages
        Throws : N/A 
    ********************************************************************/
    webService static String closePromotionsWebservice(List<Id> promotionIds) {
        return UL_PromotionClosure.closePromotions(promotionIds,false);
    }
    
	 //closes promotions (used SMART UI)
     /*@RemoteAction	
     global static String closePromotionsRemote(Id promotionId){
         List<Id> promotionIds = new List<Id>{promotionId};
     	return UL_PromotionClosure.closePromotions(promotionIds);
     }*/
    
    //closes promotions (used SMART UI)
    /*
     @RemoteAction	
     global static String invokeWfBOPromotion(String txId, String objectId, String Mode, String Content) {
        if (Mode=='Closed'){
            List<Id> promotionIds = new List<Id>{(Id) objectId};
            return UL_PromotionClosure.closePromotions(promotionIds);
        }
         return null;
     }*/
	
	 /*******************************************************************
        Purpose: receives a list of promotion ids --> sets them to closed
        Version 1.0
        Parameters: List of Promotion Ids, Boolean isCalledByPromotionPage (decides whether an exception is throw in error case or just a String message returned)
        Returns: Success or Error messages
        Throws : UL_CustomException
    ********************************************************************/
     public static String closePromotions(List<Id> promotionIds,Boolean isCalledByPromotionPage){
    	
    	//max number of Promotions to close
    	final Integer maxNumClosure = 3;
    	
    	
        //check that there is at least one Promotion selected
        if (promotionIds.size()==0){
        	if (isCalledByPromotionPage){
        		throw new UL_CustomException(Label.No_Promotions_Selected);
        	}
            return Label.No_Promotions_Selected;
        } else 
        //check if user has necessary rights
        if (!ACCL__Promotion__c.sObjectType.getDescribe().isUpdateable() || !Account.Description.getDescribe().isUpdateable()){
            if (isCalledByPromotionPage){
        		throw new UL_CustomException(Label.User_Profile_No_Right);
        	}
            return Label.User_Profile_No_Right;
        } 
        //check if sharing requirements and logical requirements are fulfilled --> if so, do the update
        else {
        	String message='';
            List<ACCL__Promotion__c> failedPros_Requ = new List<ACCL__Promotion__c>();
            List<ACCL__Promotion__c> failedPros_Share = new List<ACCL__Promotion__c>();
            List<ACCL__Promotion__c> promos = [Select ACCL__Slogan__c, UL_Closed__c, UL_WorkflowState__c, ACCL__Date_Thru__c, UserRecordAccess.HasEditAccess From ACCL__Promotion__c Where Id IN: promotionIds];
            for (ACCL__Promotion__c cPro: promos){
                if (!(cPro.ACCL__Date_Thru__c<Date.today() && cPro.UL_Closed__c != true && cPro.UL_WorkflowState__c=='Approved')){
                    failedPros_Requ.add(cPro);
                    message=Label.Close_Promotion_FailedSingle;
                } else if (cPro.UserRecordAccess.HasEditAccess==false){
                    failedPros_Share.add(cPro);
                    message=Label.Close_Promotion_Missing_SharingSingle;
                }
            }
            
            //execute update if all requirements requirements are fulfilled
            if(failedPros_Requ.size()==0 && failedPros_Share.size()==0){
            	if (promotionIds.size()>maxNumClosure){
            		Database.executeBatch(new UL_PromotionClosureBatch(promos), maxNumClosure);
            		return Label.Close_Promotion_Initiated;
            	} else {
            		//directly close in transaction
            		for (ACCL__Promotion__c cPromo: promos){
            			cPromo.UL_Closed__c = true;
            		}
            		try {
            			update promos;
            		} catch (Exception e){
                        UL_Utility.logError(e, UserInfo.getUserId());
                        if (isCalledByPromotionPage){
			        		throw new UL_CustomException(Label.Promotion_Closure_Internal_Error + e.getMessage());
			        	}
            			return Label.Promotion_Closure_Internal_Error + e.getMessage();
            		}
            		return Label.Promotions_Closed_Successfully;
            	}
            } 
            //send feedback if prerequisits are not fulfilled
            else {
            	if (isCalledByPromotionPage){
            		throw new UL_CustomException(message);
            	} else {
	                message='';
	                if(failedPros_Requ.size()>0){
	                    message+=Label.Promotion_Closure_Failed + '\n';
	                    for (ACCL__Promotion__c cPro: failedPros_Requ){
	                        message+=' -' + cPro.ACCL__Slogan__c+'\n';
	                    }
	                }
	                if(failedPros_Share.size()>0){
	                    if(failedPros_Requ.size()>0){
	                        message+='\n\n';
	                    }
	                    message+=Label.Close_Promotion_Missing_Sharing + '\n';
	                    for (ACCL__Promotion__c cPro: failedPros_Share){
	                        message+=' -' + cPro.ACCL__Slogan__c+'\n';
	                    }
	                }
            	}
                return message;
            }
        }
    }
}