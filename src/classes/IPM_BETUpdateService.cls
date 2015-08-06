/**
    @Description: Service to update all following IPMs with Bet changes
    @Author: Cognizant Technology
    @Date: 7/7/2015
**/
public class IPM_BETUpdateService{
    
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
        List<IPM_Project__c> projList = [select id,name,IPM_Category_Text__c from IPM_Project__c where IPM_Category_Text__c =: categoryName limit 1];
        Boolean isSupported = false;
            if(projList != null && !projList.isempty()){
                isSupported = true; 
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
      if(ApprovalAction == IPM_ConstantUtils.BET_APPROVAL_APPROVED){
           proj.BET__c=proj.BET_Link_Requested__c;
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
    public class IPM_CustomException extends Exception{
          
    }
}