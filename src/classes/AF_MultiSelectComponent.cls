/*****************************************************************************************************************************
@Author :Cognizant
@name : AF_MultiSelectComponent
@CreateDate : 21/4/2014
@Description : This is a controller class is used to check the permission set and it's the groups for the users 
@              removes the groups when permission set is removed for the user
@Version : 1.0
@reference : none
***********************************************************************************/
public with sharing class AF_MultiSelectComponent{
	Public list<selectOption> groupListComp;
	Set<String> gidComp = new Set<String>();
	Public list<selectOption> gmListComp;
	public List<String> selectedGroupList{get;set;}
	public List<String> selectedGroupListBackup{get;set;}
	public List<String> AvailableGroupList{get;set;}
	public List<String> deletedGroupListBackup{get;set;}
	public List<String> avaliableDummyList;
	Public list<String> gmListCompBackup;
	Public set<String> gmListCompSet;
	public set<String> groupListCompSet;
	Public list<String> groupListCompBackup;
	public List<String> tobeDeletedList;
	public List<String> tobePermDeletedList;
	public List<String> AvailablePerList{get;set;}
	public List<String> selectedPerList{get;set;}
	public List<String> selectedPerListBackup{get;set;}
	public List<String> AvailablePerListBackup{get;set;}
	public List<String> permMyBackupList;
	public Set<String> permMyBackupSet;
	public List<String> permUserBackupList;
	Public List<selectOption > pmMyListComp {get;set;}
	Public List<selectOption > pmUserListComp {get;set;}
	public List<String> perIdName{get;set;}
	public set<String> permissionIds{get;set;}
	public String uid{get;set;}
	private static string className_STR=AF_AdjustQuater_Homepage_lightbox.class.getName();
	public AF_MultiSelectComponent(){
		uid=ApexPages.currentPage().getParameters().get(AF_Constants.USERID);
		searchGroups();
		searchPermissionSet();
	}
	/***********************************************************************************
*  @Description: this method By setting the values in GetUserPermissions and 
				GetMyPermissions
*  @name : searchPermissionSet
*  @param : none
*  @return: none.
*************************************************************************************/
	public void searchPermissionSet(){
		permissionIds = new Set<String>();
		pmMyListComp = new list<selectOption>();
		pmUserListComp = new list<selectOption>();
		permMyBackupList = new List<String>();
		permMyBackupSet = new Set<String>();
		selectedPerListBackup = new List<String>();
		AvailablePerListBackup = new List<String>();
		perIdName = new List<String>();
		tobePermDeletedList = new List<String>();
		//Intialized and added for Test Class Error--> Start
		AvailablePerList=new list<string>();
		selectedPerList=new List<String>();
		//Intialized and added for Test Class Error--> End
		GetUserPermissions();
		GetMyPermissions();
	}
	/***********************************************************************************
*  @Description: this method is used to query the permission set from the users 
				and add to list           
*  @name : GetMyPermissions
*  @param : none
*  @return: none.
*************************************************************************************/
	Public void GetMyPermissions()
	{
		for(PermissionSetAssignment pMy:[SELECT Assignee.name,Id,PermissionSetId,PermissionSet.name FROM PermissionSetAssignment where Assigneeid=:uid and PermissionSetId IN:permissionIds]){
			pmMyListComp.add(new selectOption(pMy.PermissionSet.name,pMy.PermissionSet.name));
			permMyBackupList.add(pMy.PermissionSet.name);
		}
		removeExistingprem(permMyBackupList);
	}
	/**************************************************************************************
*  @Description: this method is used to query the permission set from the permission set 
				and add to list           
*  @name : GetUserPermissions
*  @param : none
*  @return: none.
*************************************************************************************/   
	Public void GetUserPermissions()
	{
		permUserBackupList = new List<String>();
		for(PermissionSet pUser:[SELECT Id,Label,Name FROM PermissionSet where name like 'af_%']){
			permUserBackupList.add(pUser.Name);
			permMyBackupSet.add(pUser.Name);
			tobePermDeletedList.add(pUser.Id+'::'+pUser.Name);
			perIdName.add(pUser.Id+'::'+pUser.Name);
			permissionIds.add(pUser.Id);
		}
	}
	/**************************************************************************************
*  @Description: this method is used to query the group and group member 
				and add to list           
*  @name : searchGroups
*  @param : none
*  @return: none.
*************************************************************************************/      
	public void searchGroups(){
		selectedGroupListBackup = new List<String>();
		groupListComp = new list<selectOption>();
		//uncommented for test class error---------->start
		selectedGroupList = new List<String>();
		AvailableGroupList = new List<String>();
		//uncommented for test class error----------->end
		gmListComp = new list<selectOption>();
		avaliableDummyList  = new List<String>();
		deletedGroupListBackup = new List<String>();
		gmListCompBackup = new List<String>();
		gmListCompSet = new set<String>();
		groupListCompSet = new set<String>();
		groupListCompBackup = new List<String>();
		tobeDeletedList = new List<String>();
		for(Group g:[SELECT DeveloperName,Id,Name FROM Group where DeveloperName like 'af_%' order by Name]){
			avaliableDummyList.add(g.Id+'::'+g.Name);
			gmListCompBackup.add(g.Name);
			gmListCompSet.add(g.Name);
			gidComp.add(g.Id);
		}
		for(GroupMember gm:[SELECT GroupId,Id,group.name,UserOrGroupId FROM GroupMember where UserOrGroupId=:uid and GroupId IN:gidComp]){
			gmListComp.add(new selectOption(gm.group.name,gm.group.name));
			groupListCompBackup.add(gm.group.Name);
			tobeDeletedList.add(gm.Id+'::'+gm.group.name);
		}
		removeExistingGroups(groupListCompBackup);
	}
	/**************************************************************************************
*  @Description: this method is used to query add group member to the list                         
*  @name : addgroups
*  @param : none
*  @return: none.
*************************************************************************************/          
	public void addgroups(){
		selectedGroupListBackup.addAll(AvailableGroupList);
		groupListComp = new list<selectOption>();
		removeExistingGroups(AvailableGroupList);
		for(String s:AvailableGroupList){
			gmListComp.add(new selectOption(s,s));
		}
	}
	/**************************************************************************************
*  @Description: this method is used to query add group member to the list                         
*  @name : addgroups
*  @param : none
*  @return: none.
*************************************************************************************/ 
	public void addPermission(){
		AvailablePerListBackup.addAll(AvailablePerList);
		pmUserListComp = new list<selectOption>();
		removeExistingprem(AvailablePerList);
		for(String s:AvailablePerList){
			pmMyListComp.add(new selectOption(s,s));
		}
	}
	/**************************************************************************************
*  @Description: this method is check the group member in the existing group member                    
*  @name : addgroups
*  @param : none
*  @return: none.
*************************************************************************************/   
	public void removeExistingGroups(List<String> rGroup){
		for(String s:gmListCompBackup){
			for(String se:rGroup){
				if(s==se){
					gmListCompSet.remove(s);
				}
			}
		}
		for(String s:gmListCompSet){
			groupListComp.add(new selectOption(s,s));
		}
		groupListComp.sort();
	}
	public void removeExistingprem(List<String> rGroup){
		for(String s:permUserBackupList){
			for(String se:rGroup){
				if(s==se){
					permMyBackupSet.remove(s);
				}
			}
		}
		for(String s:permMyBackupSet){
			pmUserListComp.add(new selectOption(s,s));
		}
		pmUserListComp.sort();
	}
	/**************************************************************************************
*  @Description: this method is to remove the groups                       
*  @name : removegroups
*  @param : none
*  @return: none.
*************************************************************************************/      
	public void removegroups(){
		List<String> listtoRemove= new List<String>();
		deletedGroupListBackup.addAll(selectedGroupList);
		for(selectOption o:gmListComp){
			listtoRemove.add(o.getValue());
		}
		gmListComp = new list<selectOption>();
		groupListCompSet.addAll(listtoRemove);
		for(String s:selectedGroupList){
			groupListComp.add(new selectOption(s,s));
		}   
		groupListComp.sort();
		for(String s:listtoRemove){
			for(String se:selectedGroupList){
				if(s==se){
					groupListCompSet.remove(s);
				}
			}
		}
		for(String s:groupListCompSet){
			gmListComp.add(new selectOption(s,s));
		}
		gmListComp.sort();
	}
	/**************************************************************************************
*  @Description: this method is used to remove the permission set                  
*  @name : removePermission
*  @param : none
*  @return: none.
*************************************************************************************/   
	public void removePermission(){
		List<String> listtoRemove= new List<String>();
		Set<String> setRemovePermission = new Set<String>();
		selectedPerListBackup.addAll(selectedPerList);
		for(selectOption o:pmMyListComp){
			listtoRemove.add(o.getValue());
		}
		pmMyListComp = new list<selectOption>();    
		setRemovePermission.addAll(listtoRemove);
		for(String s:selectedPerList){
			pmUserListComp.add(new selectOption(s,s));
		}   
		pmUserListComp.sort();
		for(String s:listtoRemove){
			for(String se:selectedPerList){
				if(s==se){
					setRemovePermission.remove(s);
				}
			}
		}
		for(String s:setRemovePermission){
			pmMyListComp.add(new selectOption(s,s));
		}
		pmMyListComp.sort();
	}
	/**************************************************************************************
*  @Description: this method is used to add and remove users from the public groups.
				 as from UI admin can add and remove user it will update the public group
				 using the below method            
*  @name : saveGroups
*  @param : none
*  @return: none.
*************************************************************************************/     
	public void saveGroups(){
		string saveGroups='saveGroups';
		List<GroupMember> gmList = new List<GroupMember>();
		Set<String> deleteGroupsSet = new Set<String>();
		Set<String> addGroupsSet = new Set<String>();
		List<String> newSelectedList = new List<String>();
		List<String> newDeletedList = new List<String>();
		deleteGroupsSet.addAll(deletedGroupListBackup);
		addGroupsSet.addAll(selectedGroupListBackup);
		for(String d:deletedGroupListBackup){
			for(String s:selectedGroupListBackup){
				if(d==s){
					deleteGroupsSet.remove(d);
					addGroupsSet.remove(s);
				}
			}
		}
		newSelectedList.addAll(addGroupsSet);
		newDeletedList.addAll(deleteGroupsSet);
		for(String s:newSelectedList){
			GroupMember gm = new GroupMember();
			for(String avG:avaliableDummyList){
				if(avg.split('::').get(1)==s){
					String gid = avg.split('::').get(0);
					gm.GroupId = gid;
					gm.UserOrGroupId = uid;
					gmList.add(gm);
				}
			}
		}
		if(gmList.size()>0){
			try{
				insert gmList;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,saveGroups,e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert));
			}
		}
		List<String> deletegmIds=new List<String>();
		for(String s:newDeletedList){
			for(String avG:tobeDeletedList){
				if(avg.split('::').get(1)==s){
					deletegmIds.add(avg.split('::').get(0));
				}
			}
		}
		List<GroupMember> deleteRemovedMem = [select id from GroupMember where id IN :deletegmIds and UserOrGroupId=:uid];
		if(deleteRemovedMem.size()>0){
			try{
				delete deleteRemovedMem;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,saveGroups,e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete)); 
			}
		}
		searchGroups();
	}
	/**************************************************************************************
*  @Description: this method is used to add and remove users from the permission sets.
				 as from UI admin can add and remove user it will update the permission sets
				 using the below method             
*  @name : savePermission
*  @param : none
*  @return: none.
*************************************************************************************/    
	public void savePermission(){
		string savePermission='savePermission';
		List<PermissionSetAssignment> pList = new List<PermissionSetAssignment>();
		Set<String> deleteGroupsSet = new Set<String>();
		Set<String> addGroupsSet = new Set<String>();
		List<String> newSelectedList = new List<String>();
		List<String> newDeletedList = new List<String>();
		deleteGroupsSet.addAll(selectedPerListBackup);
		addGroupsSet.addAll(AvailablePerListBackup);
		for(String d:selectedPerListBackup){
			for(String s:AvailablePerListBackup){
				if(d==s){
					deleteGroupsSet.remove(d);
					addGroupsSet.remove(s);
				}
			}
		}
		newSelectedList.addAll(addGroupsSet);
		newDeletedList.addAll(deleteGroupsSet);
		for(String s:newSelectedList){
			PermissionSetAssignment p = new PermissionSetAssignment();
			for(String avG:perIdName){
				if(avg.split('::').get(1)==s){
					String gid = avg.split('::').get(0);
					p.PermissionSetId = gid;
					p.Assigneeid = uid;
					pList.add(p);
				}
			}
		}
		if(pList.size()>0){
			try{
				insert pList;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,savePermission,e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Insert)); 
			}
		}
		List<String> deletepermIds=new List<String>();
		for(String s:newDeletedList){
			for(String avG:tobePermDeletedList){
				if(avg.split('::').get(1)==s){
					deletepermIds.add(avg.split('::').get(0));
				}
			}
		}
		List<PermissionSetAssignment> deleteRemovedMem = [select id from PermissionSetAssignment where PermissionSetId IN :deletepermIds and Assigneeid=:uid];
		if(deleteRemovedMem.size()>0){
			try{
				delete deleteRemovedMem;
			}
			catch(Exception e)
			{
				AF_ExceptionLoggingHelper.createApplicationLevelErrorLog(AF_Constants.APP_NAME,UserInfo.getUserId(),className_STR,savePermission,e.getMessage(),e.getTypeName(),e.getStackTraceString());
				apexpages.addmessage(new apexpages.message(apexpages.severity.Error,Label.AF_Delete)); 
			}
		}
		searchPermissionSet();
	}
	/**************************************************************************************
*  @Description: this method is to refer the VF page         
*  @name : redirectBack
*  @param : none
*  @return: none.
*************************************************************************************/      
	public pagereference redirectBack(){
		PageReference newocp = new PageReference(AF_Constants.USER_SEARCHPAGE);
		newocp.setRedirect(true);
		return newocp;
	}
	public list<selectOption> getAssignedGroups(){
		return gmListComp;
	}
	public list<selectOption> getAvailableGroups(){
		return groupListComp;
	}
}