public class BET_TriggerFactory {

	private BET_TriggerFactory(){}

	/****************************************************************************************
	 * Public static method to create and execute a trigger handler
	 * Arguments:	Schema.sObjectType soType - Object type to process (SObject.sObjectType)
	 * Throws a TriggerException if no handler has been coded.
	 ****************************************************************************************/
	public static void createHandler(Schema.sObjectType soType){
		ITrigger handler = getHandler(soType);
		if (handler == null){
			throw new TriggerException('No Trigger Handler registered for Object Type: ' + soType);
		}
		execute(handler);
	}
	
	/**************************************************************************************
	 * private static method to control the execution of the handler
	 * Arguments:	ITrigger handler - A Trigger Handler to execute
	 **************************************************************************************/	
	private static void execute(ITrigger handler){
		if (Trigger.isBefore) {
			handler.bulkBefore();
			if (Trigger.isDelete){
				for (SObject so : Trigger.old){
					handler.beforeDelete(so);
				}
			} else if (Trigger.isInsert) {
				for (SObject so : Trigger.new) {
					handler.beforeInsert(so);
				}
			} else if (Trigger.isUpdate) {
				for (SObject so : Trigger.old) {
					handler.beforeUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
		} else {
			handler.bulkAfter();
			if (Trigger.isDelete){
				for (SObject so : Trigger.old){
					handler.afterDelete(so);
				}
			} else if (Trigger.isInsert){
				for (SObject so : Trigger.new){
					handler.afterInsert(so);
				}
			}else if (Trigger.isUpdate){
				for (SObject so : Trigger.old){
					handler.afterUpdate(so, Trigger.newMap.get(so.Id));
				}
			}
		}
		handler.andFinally();
	}
	
	/************************************************************************************
	 * private static method to get the appropriate handler for the object type.
	 * Modify this method to add any additional handlers.
	 * Arguments:	Schema.sObjectType soType - Object type tolocate (SObject.sObjectType)
	 * Returns:		ITrigger - A trigger handler if one exists or null.
	 ************************************************************************************/
	private static ITrigger getHandler(Schema.sObjectType soType){

		System.debug('get handler soType ' + soType);

		if (soType == uw_BET__c.sObjectType){
			return new BET_BETHandler();
		}
        
        if (soType == BET_Member_Request__c.sObjectType){
			return new BET_Member_RequestHandler();
		}

		if (soType == BET_Follow_Request__c.sObjectType){
			return new BET_FollowRequestTriggerHandler();
		}

		if (soType == uw_BET_Team_Member__c.sObjectType){
			return new BET_Team_MemberHandler();
		}

		if (soType == uw_Asset__c.sObjectType){
			return new BET_AssetHandler();
		}

		return null;
	}
}