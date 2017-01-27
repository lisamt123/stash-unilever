public class BFM_UserCreationAssignPermissions implements Queueable {
   
    BFM_UserCreationRequest__c accessRequest;
    public BFM_UserCreationAssignPermissions(BFM_UserCreationRequest__c accessRequest){
        this.accessRequest = [SELECT Tax_User__c, Finance_User__c, Operational_User__c,Created_User__c,Error_Message__c
                              FROM BFM_UserCreationRequest__c WHERE ID =: accessRequest.Id];
    }
    public void execute(QueueableContext SC){
        Map<String, Id> permissionSetsByName = new Map<String,Id>();
        for(PermissionSet p: [SELECT Name from PermissionSet WHERE Name LIKE 'BFM_%']){
            permissionSetsByName.put(p.Name, p.Id);
        }
        List<PermissionSetAssignment> createdPermissionSetAssignments = new List<PermissionSetAssignment>();
        if(accessRequest.Tax_User__c){
            Id permissionSetTaxUser = permissionSetsByName.get('BFM_Carrier_Tax_User');
        
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = accessRequest.Created_User__c,
                                                                     PermissionSetId = permissionSetTaxUser);
            createdPermissionSetAssignments.add(psa);
        }
        if(accessRequest.Finance_User__c){
            Id permissionSetFinanceUser = permissionSetsByName.get('BFM_Carrier_Finance_User');
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = accessRequest.Created_User__c,
                                                                     PermissionSetId = permissionSetFinanceUser);
            createdPermissionSetAssignments.add(psa);
        }
        if(accessRequest.Operational_User__c){
            Id permissionSetOperationalUser = permissionSetsByName.get('BFM_Carrier_Operational_User');
        
            PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = accessRequest.Created_User__c,
                                                                     PermissionSetId = permissionSetOperationalUser);
            createdPermissionSetAssignments.add(psa);
        }
      /*  if(!createdPermissionSetAssignments.isEmpty()){
            Database.saveResult[] saveResults = Database.insert(createdPermissionSetAssignments, true);
            boolean hadErrors = false;
            for(Database.saveResult sr: saveResults){
                if(!sr.isSuccess()){
                    hadErrors = true;
                    accessRequest.Error_Message__c += sr.getErrors()[0];
                }
            }
            if(hadErrors){
                update accessRequest;
            }
        }*/
    }
}