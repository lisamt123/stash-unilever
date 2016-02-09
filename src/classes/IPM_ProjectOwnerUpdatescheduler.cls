/*********************************************************************************************************
@Description : This class is used to call IPM_ProjectOwnerUpdate batch class.
@Created Date: 30/06/2014
@Author: Cognizant
@Referenced: IPM_ProjectOwnerUpdate
**********************************************************************************************************/
//considering API enable features

/*  
    This class would initially run in System mode to make sure that it can view all project specific data and associations.
    However internal invocations for Helpers are 'With sharing'. 
*/
global class IPM_ProjectOwnerUpdatescheduler implements Schedulable {

    global set<id> projectidSet;//set of project id's
    global set<id> projecttobeprocessSet;//set of project id's
    
    /****************************************************************************************
    @Description : Constructor
    @Param:set of project id's
    ******************************************************************************************/
    global IPM_ProjectOwnerUpdatescheduler(Set<id> projectid, set<id> projecttobeprocess)
    {
       projectidSet=projectid;
       projecttobeprocessSet=projecttobeprocess;
    }
    /****************************************************************************************
    @Description : batch start method
    @Param:SchedulableContext
    *****************************************************************************************/
    global void execute(SchedulableContext sc) {
        
        if ([SELECT count() FROM AsyncApexJob WHERE JobType=:IPM_ConstantUtils.IPM_BATCHAPEX AND (Status =:IPM_ConstantUtils.IPM_PROCESSING OR Status =:IPM_ConstantUtils.IPM_PREPARE OR Status = :IPM_ConstantUtils.IPM_QUEUED)] < IPM_ConstantUtils.IPM_BATCHLIMIT){ 
            Database.executeBatch(new IPM_ProjectOwnerUpdate_Batch(projectidSet,projecttobeprocessSet));//call batch class
        } else {                    
            IPM_ProjectOwnerUpdatescheduler s = new IPM_ProjectOwnerUpdatescheduler(projectidSet,projecttobeprocessSet);  
            System.schedule(IPM_ConstantUtils.IPM_JOBSTATED_AT + String.valueOf(Datetime.now()), IPM_ConstantUtils.IPM_NEXT_FIRE_TIME, s); //call batch class
        }
    }
}