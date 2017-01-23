Public class BFM_LoginuserPermissions{
    @future
    public static void assignPermissionset(id userid,id userrequestid){
        BFM_UserCreationRequest__c userRequest = [SELECT userName__c, email__c,firstName__c,cnpj__c,Operational_User__c,
                                                   lastName__c, communityNickname__c, (SELECT Account__c,Account__r.parentid FROM BFM_Access_Requests__r)
                                                   FROM BFM_UserCreationRequest__c WHERE Id = :userRequestId];
    
        string psName ='';
        if(userRequest.Operational_User__c == true){
            psName = 'BFM_Carrier_Operational_User';
        }
        else
        {
            psName = 'BFM_Carrier_Tax_User';
        }
         PermissionSet ps = new PermissionSet();
         if(psName!=''){
             ps = [select id from PermissionSet where name=: psName limit 1];
         }
         if(ps!=null && userid!=null){
             PermissionSetAssignment psa = new PermissionSetAssignment();
             psa.AssigneeId = userid;
             psa.PermissionSetId = ps.id;
             insert psa;
         }
    }
}