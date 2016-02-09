/*****************************************************************************************
* @author       Shahin Movahedi
* @date         2016-02-06
* @description  Apex class to determine the user permissions for different activities and also
*				access to fields, buttons, links
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Shahin Movahedi            2016-02-06          Created

******************************************************************************************/
public with sharing class Oblix_PermissionHandler {

	private static Boolean b_is_system_admin;
    private static Boolean b_has_edit_access;

    private static Boolean b_has_ul1_permission_set;
    private static Boolean b_has_ul2_permission_set;
    private static Boolean b_has_ul3_permission_set;
    private static Boolean b_has_ag1_permission_set;
    private static Boolean b_has_ag2_permission_set;
    private static Boolean b_has_super_user_permission_set;

    private static final String UL1_PERMISSION_SET = 'Oblix_SWOP_UL_1_V1';
    private static final String UL2_PERMISSION_SET = 'Oblix_SWOP_UL_2_V1';
    private static final String UL3_PERMISSION_SET = 'Oblix_SWOP_UL_3_V1';
    private static final String AG1_PERMISSION_SET = 'Oblix_SWOP_AG_1_V1';
    private static final String AG2_PERMISSION_SET = 'Oblix_SWOP_AG_2_V1';
    private static final String UL_SUPER_USER_PERMISSION_SET = 'Oblix_SWOP_Super_User_V1';


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  static boolean is system admin, check in memory first to see if the permission is already
					retrieved, if not query it from database, set in memory and return
    ********************************************************************************/
    public static Boolean isSystemAdmin(){

        if (NULL == b_is_system_admin){

            Id systemAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
            Id currentUserProfileId = UserInfo.getProfileId();

            if (systemAdminProfileId == currentUserProfileId){
                b_is_system_admin = true;
            }
            else{
                b_is_system_admin = false;
            }
        }
        return b_is_system_admin;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  If user has UL1, SuperUser permission set or is system admin 
    				then has edit access
    ********************************************************************************/
    public static Boolean hasEditAccess(){
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()){
    		return true;
    	}
    	else{
    		return false;
    	}
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets user can create SOW?
    ********************************************************************************/
    public static Boolean canCreateSOW(){
    	// only UL1, UL2, SuperUser and Sysadmin can create SOW
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasUL3permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and status of SOW
    				determine if the financial fields are visible to user or not
    ********************************************************************************/
    public static Boolean canSeeFinancialField(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can see financial fields
    	// or if the sow is approved by Unilever/awaiting agency approval
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		|| 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER == sow_status)){
    		
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and status of SOW
    				determine if the user can delete SOW
    ********************************************************************************/
    public static Boolean canDeleteSOW(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can delete SOW and only if
    	// the sow is not approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and status of SOW
    				allow user to set completion stage on chevron
    ********************************************************************************/
    public static Boolean canSetCompletionStage(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can set 
    	// the sow is not approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and status of SOW
    				allow user to set projected stage on chevron
    ********************************************************************************/
    public static Boolean canSetProjectedStage(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can set 
    	// the sow is not approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets 
    				allow user to see geographic scale
    ********************************************************************************/
    public static Boolean canSeeGeographicScale(){
    	// only UL1, UL2, SuperUser and Sysadmin can see geographic scale 
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets 
    				allow user to see agency hub fields
    ********************************************************************************/
    public static Boolean canSeeAgencyHubFields(){
    	// only UL1, UL2, SuperUser and Sysadmin can see geographic scale 
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to cancel campaign
    ********************************************************************************/
    public static Boolean canCancelCampaign(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can cancel campaigns
    	// if not already approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to adjust fee
    ********************************************************************************/
    public static Boolean canAdjustFee(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can adjust fee
    	// if not already approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to Add/Update/Delete non campaign items
    ********************************************************************************/
    public static Boolean canManageNonCampaign(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can manage non campaign
    	// if not already approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to Add/Update/Delete campaign items
    ********************************************************************************/
    public static Boolean canManageCampaign(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can manage campaign
    	// if not already approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to Add/Update/Delete Asset Basket Items
    ********************************************************************************/
    public static Boolean canManageAssetBasket(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can manage asset basket
    	// if not already approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to submit SOW for approval
    ********************************************************************************/
    public static Boolean canSubmitForApproval(String sow_status){
    	// only UL1, SuperUser and Sysadmin can send sow for approval
    	// if not already approved
    	if (hasUL1permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin() || hasAG1permissionSet()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status && Oblix_Utils.SOW_STATUS_APPROVED_BY_AGENCY != sow_status
                && Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL != sow_status && Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
                    allow user to return SOW
    ********************************************************************************/
    public static Boolean canRejectSOW(String sow_status){
        // Only allow the user to reject depending on the status of SOW and the user permissionset assigned
        if (
                (hasUL1permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin())
                && 
                (Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL == sow_status)
            ||
                (hasAG1permissionSet())
                &&
                (Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL == sow_status)
        ){
            return true;
        }
        else{
            return false;
        }
    }

    /*******************************************************************************
    * @author       Slavko Skular
    * @date         2016-02-09
    * @description  Depending on the assigned permission sets and sow status
                    allow user to approve SOW
    ********************************************************************************/
    public static Boolean canApproveSOW(String sow_status){
        // Only allow the user to reject depending on the status of SOW and the user permissionset assigned
        if (
                (hasUL1permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin())
                && 
                (Oblix_Utils.SOW_STATUS_AWAITING_UNILEVER_APPROVAL == sow_status)
            ||
                (hasAG1permissionSet())
                &&
                (Oblix_Utils.SOW_STATUS_AWAITING_AGENCY_APPROVAL == sow_status)
        ){
            return true;
        }
        else{
            return false;
        }
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to add attachment to SOW
    ********************************************************************************/
    public static Boolean canAddNewAttachment(String sow_status){
    	// only UL1, UL2, SuperUser, AG1, AG2 and Sysadmin can add attachment to SOW
    	// if not already approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasAG1permissionSet() || hasAG2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to delete other's attachment
    ********************************************************************************/
    public static Boolean canDeleteAttachment(String sow_status){
    	// only UL1, UL2, SuperUser and Sysadmin can delete other people's attachments on SOW 
    	// if not already approved
    	if (hasUL1permissionSet() || hasUL2permissionSet() || hasSuperUserpermissionSet() || isSystemAdmin()
    		&& 
    		(Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status)){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  Depending on the assigned permission sets and sow status
    				allow user to cancel SOW
    ********************************************************************************/
    public static Boolean canCancelSOW(String sow_status){
    	// if not already approved can cancel SOW
    	if (Oblix_Utils.SOW_STATUS_APPROVED_BY_UNILEVER != sow_status){
    		return true;
    	}
    	else{
    		return false;
    	}
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  static boolean has ul1 permission set, check in memory first to see if the permission is already
					retrieved, if not call getUserPermissions(), set in memory and return
    ********************************************************************************/
    public static Boolean hasUL1permissionSet(){
    	if (NULL == b_has_ul1_permission_set){
    		getUserPermissions();
    	}
    	return b_has_ul1_permission_set;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  static boolean has ul2 permission set, check in memory first to see if the permission is already
					retrieved, if not call getUserPermissions(), set in memory and return
    ********************************************************************************/
    public static Boolean hasUL2permissionSet(){
    	if (NULL == b_has_ul2_permission_set){
    		getUserPermissions();
    	}
    	return b_has_ul2_permission_set;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  static boolean has ul3 permission set, check in memory first to see if the permission is already
					retrieved, if not call getUserPermissions(), set in memory and return
    ********************************************************************************/
    public static Boolean hasUL3permissionSet(){
    	if (NULL == b_has_ul3_permission_set){
    		getUserPermissions();
    	}
    	return b_has_ul3_permission_set;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  static boolean has ag1 permission set, check in memory first to see if the permission is already
					retrieved, if not call getUserPermissions(), set in memory and return
    ********************************************************************************/
    public static Boolean hasAG1permissionSet(){
    	if (NULL == b_has_ag1_permission_set){
    		getUserPermissions();
    	}
    	return b_has_ag1_permission_set;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  static boolean has ag2 permission set, check in memory first to see if the permission is already
					retrieved, if not call getUserPermissions(), set in memory and return
    ********************************************************************************/
    public static Boolean hasAG2permissionSet(){
    	if (NULL == b_has_ag2_permission_set){
    		getUserPermissions();
    	}
    	return b_has_ag2_permission_set;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  static boolean has super user permission set, check in memory first to see if the permission is already
					retrieved, if not call getUserPermissions(), set in memory and return
    ********************************************************************************/
    public static Boolean hasSuperUserpermissionSet(){
    	if (NULL == b_has_super_user_permission_set){
    		getUserPermissions();
    	}
    	return b_has_super_user_permission_set;
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-02-02
    * @description  To save multiple queries from Permissionset Object, this method
    				retrieves all permission sets the currently logged in user has assigned
    ********************************************************************************/
    private static void getUserPermissions(){

        b_has_ul1_permission_set = false;
        b_has_ul2_permission_set = false;
        b_has_ul3_permission_set = false;
        b_has_ag1_permission_set = false;
        b_has_ag2_permission_set = false;
        b_has_super_user_permission_set = false;


        List<PermissionSetAssignment> li_permissions_assigned = new List<PermissionSetAssignment>();
        Id currentUserId = UserInfo.getUserId();   

        for (PermissionSetAssignment permission_set_assignment: [SELECT PermissionSet.Name 
            FROM PermissionSetAssignment WHERE AssigneeId = :currentUserId 
                AND (PermissionSet.Name =: UL1_PERMISSION_SET OR PermissionSet.Name =: UL2_PERMISSION_SET OR PermissionSet.Name =: UL3_PERMISSION_SET OR PermissionSet.Name =: UL_SUPER_USER_PERMISSION_SET
                	OR PermissionSet.Name =: AG1_PERMISSION_SET OR PermissionSet.Name =: AG2_PERMISSION_SET )]){

            if (UL1_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                b_has_ul1_permission_set = true;
            }
            else if (UL2_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                b_has_ul2_permission_set = true;
            }
            else if (UL3_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                b_has_ul3_permission_set = true;
            }
            else if (AG1_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                b_has_ag1_permission_set = true;
            }
            else if (AG2_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                b_has_ag2_permission_set = true;
            }
            else if (UL_SUPER_USER_PERMISSION_SET == permission_set_assignment.PermissionSet.Name){
                b_has_super_user_permission_set = true;
            }
        }
    }


}