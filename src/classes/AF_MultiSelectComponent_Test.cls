/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_MultiSelectComponent
@Created Date : 09/09/2014.
@Description : This Test class for AF_MultiSelectComponent apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@istest(seealldata=false)
public class AF_MultiSelectComponent_Test{
    private static string User_permissonset_user1='AF_Sairam';
    private static string User_permissonset_user2 = 'AF_Martin'; 
    private static string User_permissonset_SUCCESS1=' The permissionset1 record is created';
    private static string User_permissonset_SUCCESS2=' The permissionset2 record is created';
    private static string User_permissonset_RECORD='The permissionset Assignment record is inserted';
    Private static user userformultiselect;
    private static List<String> permList =  new List<String>();
    private static List<String> permSelectedList =  new List<String>();
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AF_MultiSelectComponent
*  @param : none
*  @return : none
*************************************************************************/
    static testmethod void AF_MultiSelectComponent()
    {
        Test.startTest();
        userformultiselect=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userformultiselect.id LIMIT 1];
        System.runAs(u)
        { 
            //insert permissionset
            List<PermissionSet> permissionsetLst = AF_TestFactory_Helper.insertPermissionset(true,1);
            List<PermissionSet> permissionsetLstQuery = [SELECT ID FROM PermissionSet LIMIT 1];
            system.assert(permissionsetLstQuery[0].Id!=null,User_permissonset_SUCCESS1);
            system.assertEquals(permissionsetLstQuery[0].Id!=null,permissionsetLst[0].Id!=null,User_permissonset_SUCCESS1);
            List<PermissionSet> permissionsetLst1 = AF_TestFactory_Helper.insertPermissionset1(true,1);
            List<PermissionSet> permissionsetLstQuery1 = [SELECT ID FROM PermissionSet where id IN:permissionsetLst1 LIMIT 1];
            system.assert(permissionsetLstQuery1!=null,User_permissonset_SUCCESS2);
            List<PermissionSetAssignment> permassign =AF_TestFactory_Helper.insertpermissionsetassign(true,1);
            List<PermissionSetAssignment> permassignQuery = [SELECT Id FROM PermissionSetAssignment LIMIT 1];
            System.assert(permassignQuery[0].id!=null,User_permissonset_RECORD);
            System.assertEquals(permassignQuery[0].id!=null,permassign[0].id!=null,User_permissonset_RECORD);
            List<Group> grplst = AF_TestFactory_Helper.insertgroup(true,1);
            List<GroupMember> groupmem = AF_TestFactory_Helper.insertgroupmem(true,1);
            System.assertEquals(grplst!=null,groupmem!=null,User_permissonset_RECORD);
            ApexPages.currentPage().getParameters().put('userid', u.id); 
            //Intialize the Class
            AF_MultiSelectComponent af=new AF_MultiSelectComponent();
            //Add parameters to page URL
            permList.add(User_permissonset_user1);
            permList.add(User_permissonset_user2);
            af.selectedPerList.addAll(permList);
            permSelectedList.add(User_permissonset_user2);
            af.AvailablePerList.addAll(permSelectedList);
            //Permission set method
            af.addPermission();
            af.removePermission();
            af.savePermission();
            Test.stoptest();
        }
    }
    /**********************************************************************
*  @Description: This method will have Test data.
*  @name : AF_MultiSelectComponent1
*  @param : none
*  @return : none
*************************************************************************/
    static testmethod void AF_MultiSelectComponent1()
    {
        Test.startTest();
        userformultiselect=AF_TestFactory_Helper.createUserAdmin(true);
        User u=[SELECT id FROM user WHERE id=:userformultiselect.id LIMIT 1];
        System.runAs(u)
        {
            //insert permissionset
            List<PermissionSet> permissionsetLst = AF_TestFactory_Helper.insertPermissionset(true,1);
            List<PermissionSet> permissionsetLstQuery = [SELECT ID FROM PermissionSet LIMIT 1];
            system.assert(permissionsetLstQuery[0].Id!=null,User_permissonset_SUCCESS1);
            system.assertEquals(permissionsetLstQuery[0].Id!=null,permissionsetLst[0].Id!=null,User_permissonset_SUCCESS1);
            List<PermissionSet> permissionsetLst1 = AF_TestFactory_Helper.insertPermissionset1(true,1);
            List<PermissionSet> permissionsetLstQuery1 = [SELECT ID FROM PermissionSet where id IN:permissionsetLst1  LIMIT 1];
            system.assert(permissionsetLstQuery1!=null,User_permissonset_SUCCESS2);
            List<PermissionSetAssignment> permassign =AF_TestFactory_Helper.insertpermissionsetassign(true,1);
            List<PermissionSetAssignment> permassignQuery = [SELECT Id FROM PermissionSetAssignment LIMIT 1];
            System.assert(permassignQuery[0].id!=null,User_permissonset_RECORD);
            System.assertEquals(permassignQuery[0].id!=null,permassign[0].id!=null,User_permissonset_RECORD);
            List<Group> grplst = AF_TestFactory_Helper.insertgroup(true,1);
            List<GroupMember> groupmem = AF_TestFactory_Helper.insertgroupmem(true,1);
            System.assertEquals(grplst!=null,groupmem!=null,User_permissonset_RECORD);
            ApexPages.currentPage().getParameters().put('userid', u.id); 
            //Intialize the Class
            AF_MultiSelectComponent af=new AF_MultiSelectComponent();
            //Add parameters to page URL
            permList.add(User_permissonset_user1);
            permList.add(User_permissonset_user2);
            af.selectedPerList.addAll(permList);
            permSelectedList.add(User_permissonset_user2);
            af.AvailablePerList.addAll(permSelectedList);
            //Permission set method
            af.addPermission();
            af.removePermission();
            af.savePermission();
            af.addgroups();
            af.removegroups();
            af.saveGroups();
            af.redirectBack();
            af.getAssignedGroups();
            af.getAvailableGroups();
            Test.stoptest();
        }
    }
}