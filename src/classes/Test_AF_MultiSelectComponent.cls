/*****************************************************************************************************************************
@Author :Cognizant
@name : Test_AF_MultiSelectComponent
@Created Date : 09/09/2014.
@Description : This Test class for AF_MultiSelectComponent apex class.
@Version : 1.0
@reference : none
****************************************************************************************************************************/
@istest(seealldata=false)
public class Test_AF_MultiSelectComponent{
	private	static string User_permissonset_user1='AF_Sairam';
	private static string User_permissonset_user2 = 'AF_Martin'; 
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : AF_MultiSelectComponent
*  @param : none
*  @return : none
*************************************************************************/
	static testmethod void AF_MultiSelectComponent()
	{
		test.starttest();
		Profile p=[Select Id from Profile where Name='System Administrator']; 
		List<String> permList =  new List<String>();
		List<String> permSelectedList =  new List<String>();
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=AF_Constants.TEST_USER_EMAIL, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=AF_Constants.TEST_BRAND,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;  
		//insert permission set      
		PermissionSet ps1=new PermissionSet();  
		ps1.Name = User_permissonset_user1;
		ps1.Label = User_permissonset_user1;
		insert ps1; 
		System.Assert(ps1.Id != null, 'The Permission set1 record  inserted');
		PermissionSet ps2=new PermissionSet();
		ps2.Name = User_permissonset_user2;
		ps2.Label = User_permissonset_user2;
		insert ps2;
		System.Assert(ps2.Id != null, 'The Permission set2 record  inserted');
		PermissionSetAssignment psa1 = new PermissionSetAssignment();
		psa1.AssigneeId = u.Id;
		psa1.PermissionSetId = ps1.Id;     
		insert psa1;
		System.Assert(psa1.Id != null, 'The permissionsetAssigment record  inserted');
		/*PermissionSetAssignment psa2 = new PermissionSetAssignment();
psa2.AssigneeId = u.Id;
psa2.PermissionSetId = ps2.Id;     
insert psa2;*/
		//insert group
		Group gr = new Group();
		gr.Name = 'af_reetha';
		insert gr;
		System.Assert(gr.Id != null, 'The Group record1  inserted');
		//insert groupmember
		GroupMember gmember = new GroupMember();
		gmember.UserOrGroupId = u.Id;
		gmember.GroupId = gr.Id;
		insert gmember;
		System.Assert(gmember.Id != null, 'The GroupMember record  inserted');
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
		test.stoptest();
	}
	/**********************************************************************
*  @Description: This method will have Test data.
*  @name : AF_MultiSelectComponent1
*  @param : none
*  @return : none
*************************************************************************/
	static testmethod void AF_MultiSelectComponent1()
	{
		test.starttest();
		Profile p=[Select Id from Profile where Name='System Administrator'];       
		List<String> permList =  new List<String>();
		List<String> permSelectedList =  new List<String>();
		//Insert User 
		User u= new User(Alias = AF_Constants.TEST_Alias, Email=AF_Constants.TEST_USER_EMAIL, 
		EmailEncodingKey=AF_Constants.TEST_EmailEncodingKey, LastName=AF_Constants.TEST_USER_LASTNAME, LanguageLocaleKey=AF_Constants.TEST_LanguageLocaleKey, 
		LocaleSidKey=AF_Constants.LocaleKey, ProfileId = p.Id, 
		TimeZoneSidKey=AF_Constants.TEST_TimeZoneSidKey,AF_Agency_Fees_User_Type__c='Category Finance',isActive=true, 
		UserName=AF_Constants.TEST_UserName,AF_Brand__c=AF_Constants.TEST_BRAND,AF_Category__c=AF_Constants.TEST_AF_Category);
		insert u;
		//insert permission set           
		PermissionSet ps1=new PermissionSet();  
		ps1.Name = User_permissonset_user1;
		ps1.Label = User_permissonset_user1;
		insert ps1; 
		System.Assert(ps1.Id != null, 'The Permission set record  inserted');
		PermissionSet ps2=new PermissionSet();
		ps2.Name = User_permissonset_user2;
		ps2.Label = User_permissonset_user2;
		insert ps2;
		System.Assert(ps2.Id != null, 'The Permission_set record  inserted');
		PermissionSetAssignment psa1 = new PermissionSetAssignment();
		psa1.AssigneeId = u.Id;
		psa1.PermissionSetId = ps1.Id;     
		insert psa1;
		System.Assert(psa1.Id != null, 'The brandEstimate record inserted');
		/*PermissionSetAssignment psa2 = new PermissionSetAssignment();
psa2.AssigneeId = u.Id;
psa2.PermissionSetId = ps2.Id;     
insert psa2;*/
		//insert group
		Group gr = new Group();
		gr.Name = 'af_reetha';
		gr.DeveloperName='af_reetha';
		insert gr;
		System.Assert(gr.Id != null, 'The Group record inserted');
		//insert group member
		GroupMember gmember = new GroupMember();
		gmember.UserOrGroupId = u.Id;
		gmember.GroupId = gr.Id;
		insert gmember;
		System.Assert(gmember.Id != null, 'The GroupMember record not inserted');
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
		test.stoptest();
	}
}// end