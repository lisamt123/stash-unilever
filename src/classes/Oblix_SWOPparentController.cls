/*****************************************************************************************
* @author       Shahin Movahedi
* @date         2016-01-14
* @description  This class contains common methods used by subclasses throughout 
*               SWOP application
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    ----------------------------------------s----------------------------------
*   
*    Shahin Movahedi            2016-01-14          Created

******************************************************************************************/
public with sharing virtual class Oblix_SWOPparentController {

    public Marketing_SOW__c selected_sow {get; set;}
    public Oblix_SOW_Projects__c selected_project {get;set;}
    public Oblix_CampaignStageLogic stage_identifier {get;set;}
    public Boolean hasEditAccess { get; set; }
    public Boolean isSystemAdmin {get; set;}

    public Boolean hasUL1permissionSet{ get;set; }
    public Boolean hasUL2permissionSet{ get;set; }
    public Boolean hasULSuperUserPermissionSet{ get;set; }

    private static final String UL1_PERMISSION_SET = 'Oblix_SWOP_UL_1_V1';
    private static final String UL2_PERMISSION_SET = 'Oblix_SWOP_UL_2_V1';
    private static final String UL_SUPER_USER_PERMISSION_SET = 'Oblix_SWOP_Super_User_V1';
    public Oblix_SWOPparentController() {
        checkIsSystemAdmin();
        checkUserHasEditPermission();
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  top link on the page exists SWOP appp
    ********************************************************************************/
    public Pagereference exitSwop(){
        return Oblix_Utils.exitSwop();
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  top link on the page goes to ReportsHome
    ********************************************************************************/
    public Pagereference goToReportsHome(){
        return Oblix_Utils.goToReportsHome();
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  depending on the sow Id in scope and the required fields
    				populate the selected sow in scope - used by sub-classes
    ********************************************************************************/
    public Marketing_SOW__c getSOW(String sow_id, List<String> fields_to_query, String related_query_string){

    	Marketing_SOW__c sow;

    	try{

            if (String.isNotBlank(sow_id) && !fields_to_query.isEmpty()){

                Id converted_sow_id = (Id) sow_id;

                // build SOQL for querying campaign fields
                String s_query_string = buildSOQLquery(fields_to_query, 'Marketing_SOW__c', related_query_string, 'Id = ' + '\'' + converted_sow_id + '\'',null,null );
                sow = Database.query(s_query_string);
            }
            else
            {
                return null;
            }
        }
        catch(Exception ex){
                return null;
        }

        return sow;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  depending on the campaign Id in scope and the required fields
    				populate the selected campaign in scope - used by sub-classes
    ********************************************************************************/
    public Oblix_SOW_Projects__c getCampaign(String campaign_id, List<String> fields_to_query, String related_query_string){

        Oblix_SOW_Projects__c sow_project;

        try{
        	
        	if (String.isNotBlank(campaign_id) && !fields_to_query.isEmpty()){

                Id converted_campaign_id = (Id) campaign_id;

                // build SOQL for querying campaign fields
                String s_query_string = buildSOQLquery(fields_to_query, 'Oblix_SOW_Projects__c', related_query_string, 'Id = ' + '\'' + converted_campaign_id + '\'',null,null );
                    sow_project = Database.query(s_query_string);
            }
            else{
                return null;
                //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Id or you do not have permission to view this record!'));
            }
        }
        catch(Exception ex){
            return null;
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid Id or you do not have permission to view this record!'));
        }
        return sow_project;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  Check if the current context user does not have access to record
                    and redirect to permission denied page
    ********************************************************************************/
    public PageReference checkUserHasPermissionToSOW(){

        if (NULl == selected_sow){
            Pagereference permission_denied_page = Page.Oblix_PermissionDenied;
            permission_denied_page.setRedirect(true);
            return permission_denied_page;            
        }
        else{
            return null;
        }

    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  Check if the current context user does not have access to record
                    and redirect to permission denied page
    ********************************************************************************/
    public PageReference checkUserHasPermissionToProject(){

        if (NULl == selected_project){
            Pagereference permission_denied_page = Page.Oblix_PermissionDenied;
            permission_denied_page.setRedirect(true);
            return permission_denied_page;            
        }
        else{
            return null;
        }

    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  Using the params passed in, build a SOQL query to retrieve records
                    from a given staging table - also pass in the related object soql query if required
    ********************************************************************************/
    protected String buildSOQLquery(List<String> fields_to_query, String object_to_query, String related_object_query, String where_clause, String order_by, String limit_rows){


            // build SOQL for querying different objects and given different criteria. 
            // Select records from Staging table 
            // according to the jobComponent attributes.
            String query_string = 'SELECT ';
            query_string += String.join(fields_to_query,',');
            
            // add the related object query if the string passed in is not empty
            query_string += String.isNotBlank(related_object_query) 
                ? related_object_query
                : '';

            query_string += ' FROM ' + object_to_query;
            
            // add in the where clause
            query_string += String.isNotBlank(where_clause)
                ? ' WHERE ' + where_clause
                : '';
         
            query_string += String.isNotBlank(order_by)
                ? ' ORDER BY ' + order_by
                : '';

            query_string += String.isNotBlank(limit_rows)
                ? ' LIMIT ' + limit_rows
                : '';

            system.debug('## SOQL query is: ' + query_string);

            return query_string;
    }    

    public Boolean checkIsSystemAdmin(){

        if (NULL == isSystemAdmin){

            Id systemAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
            Id currentUserProfileId = UserInfo.getProfileId();

            if (systemAdminProfileId == currentUserProfileId){
                isSystemAdmin = true;
            }
            else{
                isSystemAdmin = false;
            }
        }
        return isSystemAdmin;
    }

    private void checkUserHasEditPermission(){

        // if user has one of the 3 read/write permissions or is system admin then should be able to edit records
        Integer i_permissions_assigned = 0;
        hasEditAccess = false;
        hasUL1permissionSet = false;
        hasUL2permissionSet = false;
        hasULSuperUserPermissionSet = false;

        List<PermissionSetAssignment> li_permissions_assigned = new List<PermissionSetAssignment>();
        Id currentUserId = UserInfo.getUserId();   

        for (PermissionSetAssignment permission_set_assignment: [SELECT PermissionSet.Name 
            FROM PermissionSetAssignment WHERE AssigneeId = :currentUserId 
                AND (PermissionSet.Name =: UL1_PERMISSION_SET OR PermissionSet.Name =: UL2_PERMISSION_SET OR PermissionSet.Name =: UL_SUPER_USER_PERMISSION_SET) ]){
            if (UL1_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                hasUL1permissionSet = true;
            }
            else if (UL2_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                hasUL2permissionSet = true;
            }
            else if (UL_SUPER_USER_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                hasULSuperUserPermissionSet = true;
            }
            i_permissions_assigned ++;
        }
        if(i_permissions_assigned > 0 || checkIsSystemAdmin()){
            hasEditAccess = true;
        }
    }


}