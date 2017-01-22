@isTest
public class BFM_UserCreationRequestAttachment_Test {
	private static testMethod void BFM_UserCreationRequestAttachment_Test(){
        BFM_UserCreationRequest__c bfmuser = new BFM_UserCreationRequest__c();
        bfmuser.userName__c = 'TestUsername';
        bfmuser.email__c = 'Testuseremail@test.com';
        bfmuser.firstName__c = 'first';
        bfmuser.cnpj__c = '';
        bfmuser.Operational_User__c = True;
        bfmuser.lastName__c = 'last';
        bfmuser.communityNickname__c = '';
        insert bfmuser;
        
        bfmuser.Request_Approved__c = false;
        update bfmuser;
        
        Map<Id, BFM_UserCreationRequest__c> oldMap = new Map<Id, BFM_UserCreationRequest__c>();
        oldMap.put(bfmuser.Id,bfmuser);
        
        Attachment attach=new Attachment();   	
    	attach.Name='Unit Test Attachment';
    	Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    	attach.body=bodyBlob;
        attach.parentId=bfmuser.id;
        insert attach;
        
        bfmuser.Request_Approved__c = True;
        update bfmuser;
        
        Map<Id, BFM_UserCreationRequest__c> newMap = new Map<Id, BFM_UserCreationRequest__c>();
        newMap.put(bfmuser.Id,bfmuser);
        
        Set<Id> requestsWithAttachments = new Set<Id>();
        for (Attachment att : [SELECT ParentId FROM Attachment WHERE parentId IN: newMap.keySet()]){
            requestsWithAttachments.add(att.parentId);
        }
        for(Id idRequestUpdated: newMap.keySet()){
			if(!requestsWithAttachments.contains(idRequestUpdated) && oldMap.get(idRequestUpdated).Request_Approved__c == false
               && newMap.get(idRequestUpdated).Request_Approved__c == true){
            }
        }
    }
}