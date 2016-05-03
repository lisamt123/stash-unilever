public class AF_MultiSelectComponent{
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
    public AF_MultiSelectComponent(){
    


        
        
        uid=ApexPages.currentPage().getParameters().get('userid');
        system.debug('uid....'+uid);
        
       searchGroups();
       searchPermissionSet();
    }
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
    Public void GetMyPermissions()
    {
        
        for(PermissionSetAssignment pMy:[SELECT Assignee.name,Id,PermissionSetId,PermissionSet.name FROM PermissionSetAssignment where Assigneeid=:uid and PermissionSetId IN:permissionIds]){
        pmMyListComp.add(new selectOption(pMy.PermissionSet.name,pMy.PermissionSet.name));
        permMyBackupList.add(pMy.PermissionSet.name);
        
        }
        removeExistingprem(permMyBackupList);
        system.debug('pmMyListComp..'+pmMyListComp);
    }
    
     Public void GetUserPermissions()
    {
       permUserBackupList = new List<String>();
       for(PermissionSet pUser:[SELECT Id,Label,Name FROM PermissionSet where name like 'af_%']){
       // pmUserListComp.add(new selectOption(pUser.Name,pUser.Name));
        permUserBackupList.add(pUser.Name);
        permMyBackupSet.add(pUser.Name);
        tobePermDeletedList.add(pUser.Id+'::'+pUser.Name);
        perIdName.add(pUser.Id+'::'+pUser.Name);
        permissionIds.add(pUser.Id);
        }
        
    }
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
            
            //groupListComp.add(new selectOption(g.Name,g.Name));
            avaliableDummyList.add(g.Id+'::'+g.Name);
            
            gmListCompBackup.add(g.Name);
            gmListCompSet.add(g.Name);
            gidComp.add(g.Id);
            //AvailableGroupList.add(g.Name);
            
            //AvailableGroupList.clear();
            system.debug('GroupName....'+g.Name);
        }
        for(GroupMember gm:[SELECT GroupId,Id,group.name,UserOrGroupId FROM GroupMember where UserOrGroupId=:uid and GroupId IN:gidComp]){
            //gmListComp.add(new selectOption(gm.group.name+'::'+gm.id,gm.group.name));
            gmListComp.add(new selectOption(gm.group.name,gm.group.name));
            //selectedGroupList.add(gm.group.Name);
            //groupListCompSet.add(gm.group.Name);
            groupListCompBackup.add(gm.group.Name);
            tobeDeletedList.add(gm.Id+'::'+gm.group.name);
        }
        removeExistingGroups(groupListCompBackup);
    }
    
    public void addgroups(){
      
    selectedGroupListBackup.addAll(AvailableGroupList);
    system.debug('AvailableGroupList..'+AvailableGroupList);
    groupListComp = new list<selectOption>();
    removeExistingGroups(AvailableGroupList);
    for(String s:AvailableGroupList){
        gmListComp.add(new selectOption(s,s));
        
    }
    }
    public void addPermission(){
    
    AvailablePerListBackup.addAll(AvailablePerList);
    
    pmUserListComp = new list<selectOption>();
    removeExistingprem(AvailablePerList);
    for(String s:AvailablePerList){
        pmMyListComp.add(new selectOption(s,s));
        
    }
    }
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
    system.debug('permMyBackupList...'+permMyBackupList);
    system.debug('rGroup...'+rGroup);
    system.debug('permMyBackupSet...'+permMyBackupSet);
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
    
    public void removegroups(){
    
    //gmListComp = new list<selectOption>();
    List<String> listtoRemove= new List<String>();
    deletedGroupListBackup.addAll(selectedGroupList);
    for(selectOption o:gmListComp){
    listtoRemove.add(o.getValue());
    }
    gmListComp = new list<selectOption>();
    system.debug('selectedGroupList...'+selectedGroupList);
    
        //deletedGroupListBackup = selectedGroupList;
        system.debug('listtoRemove...'+listtoRemove);
        groupListCompSet.addAll(listtoRemove);
        //system.debug('selectedGroupList..'+selectedGroupList);
        
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
    
    public void saveGroups(){
        system.debug('selectedGroupListBackup...'+selectedGroupListBackup);
        system.debug('deletedGroupListBackup...'+deletedGroupListBackup);
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
        system.debug('deleteGroupsSet...'+deleteGroupsSet);
        system.debug('addGroupsSet...'+addGroupsSet);
        newSelectedList.addAll(addGroupsSet);
        newDeletedList.addAll(deleteGroupsSet);
        for(String s:newSelectedList){
            GroupMember gm = new GroupMember();
            for(String avG:avaliableDummyList){
                
                if(avg.split('::').get(1)==s){
                    system.debug('avg...'+avg);
                    String gid = avg.split('::').get(0);
                    system.debug('gid..'+gid);
                    gm.GroupId = gid;
                    gm.UserOrGroupId = uid;
                    //gm.group.name = s;
                    gmList.add(gm);
                }
            
         }
        }
        
        if(gmList.size()>0){
            system.debug('gmList...'+gmList);
            insert gmList;
        }
        system.debug('newDeletedList...'+newDeletedList);
        system.debug('tobeDeletedList...'+tobeDeletedList);
        List<String> deletegmIds=new List<String>();
        for(String s:newDeletedList){
            GroupMember gm = new GroupMember();
            for(String avG:tobeDeletedList){
            
                if(avg.split('::').get(1)==s){
                    system.debug('avg...'+avg);
                    deletegmIds.add(avg.split('::').get(0));
                    
                    
                }
            
         }
        }
        system.debug('deletegmIds...'+deletegmIds);
        List<GroupMember> deleteRemovedMem = [select id from GroupMember where id IN :deletegmIds and UserOrGroupId=:uid];
        system.debug('deleteRemovedMem...'+deleteRemovedMem);
        if(deleteRemovedMem.size()>0){
            delete deleteRemovedMem;
        }
    searchGroups();
    }
    
    public void savePermission(){
        system.debug('selectedPerListBackup...'+selectedPerListBackup);
        system.debug('AvailablePerListBackup...'+AvailablePerListBackup);
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
        system.debug('deleteGroupsSet...'+deleteGroupsSet);
        system.debug('addGroupsSet...'+addGroupsSet);
        newSelectedList.addAll(addGroupsSet);
        newDeletedList.addAll(deleteGroupsSet);
        for(String s:newSelectedList){
            PermissionSetAssignment p = new PermissionSetAssignment();
            for(String avG:perIdName){
                
                if(avg.split('::').get(1)==s){
                    system.debug('avg...'+avg);
                    String gid = avg.split('::').get(0);
                    system.debug('gid..'+gid);
                    p.PermissionSetId = gid;
                    p.Assigneeid = uid;
                    pList.add(p);
                }
            
         }
        }
        
        if(pList.size()>0){
            system.debug('pList...'+pList);
            insert pList;
        }
        system.debug('newDeletedList...'+newDeletedList);
        system.debug('tobePermDeletedList...'+tobePermDeletedList);
        List<String> deletepermIds=new List<String>();
        for(String s:newDeletedList){
            
            for(String avG:tobePermDeletedList){
            
                if(avg.split('::').get(1)==s){
                    system.debug('avg...'+avg);
                    deletepermIds.add(avg.split('::').get(0));
                    
                    
                }
            
         }
        }
        system.debug('deletepermIds...'+deletepermIds);
        List<PermissionSetAssignment> deleteRemovedMem = [select id from PermissionSetAssignment where PermissionSetId IN :deletepermIds and Assigneeid=:uid];
        system.debug('deleteRemovedMem...'+deleteRemovedMem);
        if(deleteRemovedMem.size()>0){
            delete deleteRemovedMem;
        }
    searchPermissionSet();
    }
    public pagereference redirectBack(){
    PageReference newocp = new PageReference('/apex/af_usersearchpage');
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