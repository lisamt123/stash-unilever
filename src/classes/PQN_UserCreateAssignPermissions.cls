public class PQN_UserCreateAssignPermissions implements Queueable {
    PQN_User_Creation_Request__c accessRequest;
    public PQN_UserCreateAssignPermissions(PQN_User_Creation_Request__c accessRequest){
        this.accessRequest = [SELECT User__c,User_Type__c
                              FROM PQN_User_Creation_Request__c WHERE ID =: accessRequest.Id];
    }
     public void execute(QueueableContext SC){
         Map<String, Id> permissionSetsByName = new Map<String,Id>();
        for(PermissionSet p: [SELECT Name from PermissionSet WHERE Name LIKE 'PQN_%']){
            permissionSetsByName.put(p.Name, p.Id);
        }
        List<PermissionSetAssignment> createdPermissionSetAssignments = new List<PermissionSetAssignment>();
        if(accessRequest.User_Type__c=='DC'){
            Id permissionSetDCUser = permissionSetsByName.get('PQN_DC_Community_Set');
        
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = accessRequest.user__c,
                                                                     PermissionSetId = permissionSetDCUser);
            createdPermissionSetAssignments.add(psa);
        }
        if(accessRequest.User_Type__c=='Cluster'){
            Id permissionSetClusterUser = permissionSetsByName.get('PQN_Cluster_Community_Set');
        
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = accessRequest.user__c,
                                                                     PermissionSetId = permissionSetClusterUser);
            createdPermissionSetAssignments.add(psa);
        }
        if(!createdPermissionSetAssignments.isEmpty()){
            insert createdPermissionSetAssignments;
        }
        
     }
}