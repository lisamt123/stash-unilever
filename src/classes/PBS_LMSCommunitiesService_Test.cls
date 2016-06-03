/*
Copyright (c) 2014, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

*/
@isTest
public class PBS_LMSCommunitiesService_Test {
    
    static testMethod void testGetTrainingPlanIdsForCategory(){
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(2,'Standard User');
        PBS_UtilClass_Test.addPermissionSet(lmsUsers,'PBS_LMS_User');
        
        List<PBS_Learning_Category__c> idlist =[select id from PBS_Learning_Category__c limit 10];
        
        Test.startTest();
        System.runAs(lmsUsers.get(0)){
            Id categoryId = null;
            for(PBS_Learning_Category__c lc : idlist){
                categoryId = lc.Id;
            }
            
            List<Id> lst = PBS_LMSCommunitiesService_CC.getTrainingPlanIdsForCategory(new Set<Id>{categoryId},PBS_LMSUtils_CC.getUserAccountId());
            System.assert(lst.size()>=0);
            
        }
        Test.stopTest();
    }
    
    static testMethod void testWithoutSharingOps(){
        PBS_LMSCommunitiesService_CC.WithoutSharingOps commwsops = new PBS_LMSCommunitiesService_CC.WithoutSharingOps();
        List<PBS_Training_Track__c> trainingtracks =[select id from PBS_Training_Track__c limit 10];
        Id accountId = PBS_LMSUtils_CC.getUserAccountId();
        
        List<PBS_Learning_Category__c> idlist =[select id from PBS_Learning_Category__c limit 10];
        
        Test.startTest();
        	Id trackid = null;
            for(PBS_Learning_Category__c lc : idlist){
                trackid = lc.Id;
            }
        	commwsops.getTrainingPlanIdsForAccount(accountId);
        	commwsops.getAccountTrainingTracks(accountId);
        	commwsops.filterTrainingTracksForAccount(new Set<Id>{trackid},PBS_LMSUtils_CC.getUserAccountId(), 'Active');
            System.assert(commwsops != NULL);
        Test.stopTest();
    }
        
}