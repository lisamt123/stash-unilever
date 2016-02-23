public with sharing class tabs{
public list<PermissionSetAssignment> perset{get;set;}

public tabs(){

perset=[SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId =:UserInfo.getUserId() AND PermissionSet.Name='CAP'];

}
}