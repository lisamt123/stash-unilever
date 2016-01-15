/**
    @Description: Service to update all following IPMs with BET changes
    @Author: Cognizant Technology
    @Date: 7/7/2015
**/

/*
     This class has been defined as Without Sharing as the methods are invoked via BET Integration service methods which needs to 
     access  all related IPM data related to a particular BET.
*/
    
public without sharing class IPM_BETUpdateService{ 
    
    private static string BET_FIELD_STATUS = 'status';
    private static string BET_ARCHIVED = 'archived';
    
    //Return List of IPM following BET
    public static List<IPM_BETWrapper> returnIPM(Id betId){
        if(betId==null){
            throw new IPM_CustomException(Label.IPM_BETIdNullMsg);
        }
        List<IPM_BETWrapper> ipmProjWrapper = new List< IPM_BETWrapper >();
        String query =  getProjectQuery() + ' where BET__c =: betId';
        List<IPM_Project__c> projList = Database.query(query);
        if(projList!=null && !projList.isEmpty()){
            for(IPM_Project__c proj : projList){
                    ipmProjWrapper.add(new IPM_BETWrapper(proj));
            }
        }
        return ipmProjWrapper; 
    }
    
    //Return true if given category is supported by IPM
    public static Boolean categoryCheck(String categoryName){
        if(categoryName==null){
            throw new IPM_CustomException(Label.IPM_CategoryNameNotNull);    
        }
        
        List<MDO_Category__c > CategoryList = [select Name from MDO_Category__c where id =: Id.valueOf(categoryName) limit 1];
        Boolean isSupported = false;
        if(CategoryList != null && !CategoryList.isempty()){
            IPM_BET_Valid_Categories__c catg = IPM_BET_Valid_Categories__c.getValues(CategoryList[0].Name);
            if(catg!=null){
                isSupported = true;    
            }   
        }
        return isSupported;
    }
    
    //Return true if given user has access
    public static Boolean userAccess(Id betId,Id ipmProjectId,Id userId){
        if(betId==null || ipmProjectId==null || userId==null){
            throw new IPM_CustomException(Label.IPM_IdsNotNullMsg);    
        }
        List<Schema.FieldSetMember> projectFields= SObjectType.IPM_Project__c.FieldSets.IPM_BETProjectLeaders.getFields();
        String query = 'SELECT Id,Name, ';  
        for(Schema.FieldSetMember f : projectFields) {
            query += f.getFieldPath() + ', ';
        }
        query += ' (select id,name,IPM_User__c from IPM_Project_Resources__r where IPM_User__c =: userId) from IPM_Project__c where id=:ipmProjectId';
        IPM_Project__c ipmProj = Database.Query(query);
        Boolean hasAccess = false;
        if(ipmProj!=null){
            for(integer i=0;i<projectFields.size();i++){
                if(ipmProj.get(projectFields[i].getFieldPath()) == userId){ 
                    hasAccess = true;
                    break;              
                }
             }
           if(!hasAccess && (ipmProj.IPM_Project_Resources__r)!= null && !(ipmProj.IPM_Project_Resources__r).isEmpty() && ((ipmProj.IPM_Project_Resources__r).size() >= 1)){
                hasAccess = true;
           }
       }
       return hasAccess;        
    }
    
    //Return project wrapper class for given ID
    public static IPM_BETWrapper ipm_Wrapper(Id projectId){
        if(projectId==null){
            throw new IPM_CustomException(Label.IPM_ProjectNotRetrieved);       
        }
        
        String query =  getProjectQuery() + ' where id =: projectId';
        IPM_Project__c proj = Database.Query(query);
        return new IPM_BETWrapper(proj);    
     }
     
    //Service to notify about BET linking request being approved or rejected
    public static void ipm_BETLinkingService(Id projectId ,Id betId,String approvalAction ){
        if(projectId==null || betId==null || approvalAction==null || approvalAction==''){
            throw new   IPM_CustomException(Label.IPM_IdsApprovalNotNullMSg);  
        }
        IPM_Project__c proj = [select id,BET__c,BET_Link_Requested__c,Update_BET__c  from IPM_Project__c where id =: projectId];
        if(ApprovalAction == label.IPM_BET_Link_Approved){
            proj.BET__c=proj.BET_Link_Requested__c;
        }
        else if (ApprovalAction == label.IPM_BET_Link_Rejected){
            proj.BET_Denied_BET_Link__c = ((BET_BETwrapper)BET_BETService.getBet(proj.BET_Link_Requested__c)).betName;
        }
        proj.BET_Link_Requested__c='';
        proj.BET_Link_Requested_on_Date__c = null;
        proj.Update_BET__c = false; 
        update proj ;
    }
    
    //Get project fields from the fieldset
    public static String getProjectQuery(){
        List<Schema.FieldSetMember> projectFields = SObjectType.IPM_Project__c.FieldSets.IPM_BETProjectFields.getFields();
        String query = 'SELECT ';   
        for(Schema.FieldSetMember f :projectFields) {
            query += f.getFieldPath() + ', ';
        }
        query += 'IPM_Phase__c FROM IPM_Project__c';
        return query;
    }
    //Get BET Updates from BET
    public static void updateIPM(Id BETId, BET_BETWrapper BET, list<string> updatedFields, id userId){
        // Call IPM BET helper class method to update BET Milestones Due date for First Release & Final Release Milestones
        for(string betField :updatedFields){
            // Call helper method for BET Status change
            if(betField.tolowercase().indexOf(BET_FIELD_STATUS)!=-1){
                IPM_BETHelper.resetMilestoneMissedFlag(BETId,BET);    
                //Call method to update Phase on Final Release BET Milestone
                if(BET.status == IPM_ConstantUtils.BET_FINAL_RELEASE){
                    IPM_BETHelper.updatePhaseBETMSFinalRelease(BETId);
                }
                //Call method to send Regional/Local Rollout Leaders' Access Request to BET after BET First Release
                else if(BET.status == IPM_ConstantUtils.BET_FIRST_RELEASE){
                    IPM_BETHelper.sendBETAccessRequestonFirstRelease(BETId);    
                }
            }
            //Call method to update Archive BET details on IPM Projects
            else if(betField.tolowercase().indexOf(BET_ARCHIVED)!=-1 && BET.isArchived){
                IPM_BETHelper.setArchiveBET_IPM(BET);       
            }
            
        }
    }
    
    public static void updateBETLink(id projectId,id betId){
        if(betId==null || projectId==null){
            throw new IPM_CustomException(Label.IPM_IdsNotNullMsg);    
        }
        try{
            IPM_Project__c project= [select id,bet__c from IPM_Project__c where id= : projectId];
            project.bet__c = betId;
            update project;
        }catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BETUpdateService.class.getName(),'updateBETLink',ex.getMessage(), Ex,IPM_ConstantUtils.ERROR, null, ex.getStackTraceString(), null, null) ;
            throw new IPM_CustomException(ex.getMessage());     
        }
    }
    
    //Bulk BET Memeber request update service
    public static void updateBETMemberRequest(set<id> lstProjectId){
        if(lstProjectId==null){
            throw new IPM_CustomException(system.label.IPM_BET_List_Project_Not_Empty);    
        }
        try{
            list<IPM_Project__c> lstProj = [select id from IPM_Project__c where id =:lstProjectId];
            if(lstProj!=null && !lstProj.isEmpty()){
                for(IPM_Project__c ipm:lstProj){
                    ipm.Bulk_BET_Member_Request__c = true ;
                }
                update lstProj;
            }
        }catch(Exception ex){
            ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),IPM_BETUpdateService.class.getName(),'updateBETMemberRequest',ex.getMessage(), Ex,IPM_ConstantUtils.ERROR, null, ex.getStackTraceString(), null, null) ;
            throw new IPM_CustomException(ex.getMessage());     
        }
    }
    
    public class IPM_CustomException extends Exception{
        // Custom Exception class
    }
}