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
private class PBS_WikiFeedBackController_Test {

    public static List<PBS_Wiki_Feeback__c> createTestLearning(Integer iNum, String recordID, Boolean bSyncProgress, String feedback){
    List<PBS_Wiki_Feeback__c> lResult = new List<PBS_Wiki_Feeback__c>();
       if(feedback!=''){
        for(Integer i = 0; i < iNum; i++){
            PBS_Wiki_Feeback__c olearning = new PBS_Wiki_Feeback__c();
            olearning.Wiki_Feedback__c = feedback;
            olearning.Wiki_ID__c = recordID;
            olearning.Wiki_Name__c ='Article Name';
            olearning.Wiki_Name__c = 'DUMMY_DESCRIPTION';
            lResult.add(olearning); // feedback
        }
       
        insert lResult;
        }
        return lResult;
    }
    
   public static PBS_Wiki__kav createwikikav(){
   PBS_Wiki__kav objPbsWiki = new PBS_Wiki__kav();
        objPbsWiki.Title = 'Wiki Test';
        objPbsWiki.Language = 'en_US';
        objPbsWiki.UrlName = 'Wiki-Test';
        insert objPbsWiki;
        return objPbsWiki;
   }
   
     static testMethod void testSaveMethod(){
       
        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(2,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'PBS_LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'PBS_LMS_User');
        }
       
        
           Test.startTest();
       
        PBS_Wiki__kav objPbsWiki = new PBS_Wiki__kav();
        objPbsWiki.Title = 'Wiki Test';
        objPbsWiki.Language = 'en_US';
        objPbsWiki.UrlName = 'Wiki-Test';
        insert objPbsWiki; 
        createTestLearning(1, objPbsWiki.Id, false, 'Dummy Feedback');
        
        objPbsWiki= [SELECT KnowledgeArticleId FROM PBS_Wiki__kav WHERE Id = :objPbsWiki.Id];    
       KbManagement.PublishingService.publishArticle(objPbsWiki.KnowledgeArticleId, true);
        
        
        Test.setCurrentPageReference(new PageReference('Page.PBS_Wiki_Feedback')); 
        System.currentPageReference().getParameters().put('id', objPbsWiki.Id);

        PBS_WikiFeedBackController_CC pbsWiki = new PBS_WikiFeedBackController_CC();
       PageReference pagerefsave = pbsWiki.save();
        System.assert(pagerefsave!= null);
         PageReference pagerefcan = pbsWiki.cancel();
        System.assert(pagerefcan!= null);
        
        Test.stopTest();
        
     }
     static testMethod void testSaveMethodWithEmptyId(){
     Test.startTest();
       PBS_Wiki__kav objPbsWikikav = new PBS_Wiki__kav();
       objPbsWikikav = createwikikav();
        createTestLearning(1, objPbsWikikav.Id, false,'Feedback');
     objPbsWikikav = [SELECT KnowledgeArticleId FROM PBS_Wiki__kav WHERE Id = :objPbsWikikav.Id];    
      KbManagement.PublishingService.publishArticle(objPbsWikikav.KnowledgeArticleId, true);
        Test.setCurrentPageReference(new PageReference('Page.PBS_Wiki_Feedback')); 
      // System.currentPageReference().getParameters().put('id',NULL);

        PBS_WikiFeedBackController_CC pbsWiki = new PBS_WikiFeedBackController_CC();
       PageReference pagerefsave = pbsWiki.save();
        System.assert(pagerefsave== null);
     Test.stopTest();
     }
     static testMethod void testSaveMethodWithWrongId(){
     Test.startTest();
       PBS_Wiki__kav objPbsWikikav = new PBS_Wiki__kav();
       objPbsWikikav = createwikikav();
        createTestLearning(1, objPbsWikikav.Id, false,'');
     objPbsWikikav = [SELECT KnowledgeArticleId FROM PBS_Wiki__kav WHERE Id = :objPbsWikikav.Id];    
      KbManagement.PublishingService.publishArticle(objPbsWikikav.KnowledgeArticleId, true);
        Test.setCurrentPageReference(new PageReference('Page.PBS_Wiki_Feedback')); 
     System.currentPageReference().getParameters().put('id','1234');

        PBS_WikiFeedBackController_CC pbsWiki = new PBS_WikiFeedBackController_CC();
       PageReference pagerefsave = pbsWiki.save();
        System.assert(pagerefsave!= null);
     Test.stopTest();
     }
}