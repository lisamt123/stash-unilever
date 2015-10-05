public with sharing class uw_DeleteObjectsHelper {
   // set of guards to prevent a class of objects being deleted more than once
   public static Boolean assetLocked {get {
       if (assetLocked == null) {
           assetLocked = false;
       }
       return assetLocked;
   } set;
   }
   
   private static Boolean contentDocumentLocked {get {
       if (contentDocumentLocked == null) {
           contentDocumentLocked = false;
       }
       return contentDocumentLocked;
   } set;
   }

   public Boolean lockAsset(Boolean flag) {
         assetLocked = flag;
         return assetLocked;
   }

   public Boolean lockContentDocument(Boolean flag) {
        contentDocumentLocked = flag;
        return contentDocumentLocked;
   }

   public Boolean deleteAssets(List<uw_Asset__c> assets) {
        Boolean ok = true;
        
        system.debug('deleteAssets: already done? '+assetLocked);
        if (!assetLocked) {
            assetLocked = true;
            if (!uw_HelperMethods.listIsNull(assets)) {
                try {
                    delete assets;
                } catch (Exception e) {
                    system.debug('deleteAssets: problem: '+e);
                    ok = false;
                }                    
            }
            //assetLocked = false;          
        }
       
        return ok;      
    }
    
    public Boolean updateAssets(List<uw_Asset__c> assets) {
        Boolean ok = true;
        
        system.debug('updateAssets: already done? '+assetLocked);
        if (!assetLocked) {
            assetLocked = true;
            if (!uw_HelperMethods.listIsNull(assets)) {
                try {
                    update assets;
                } catch (Exception e) {
                    system.debug('updateAssets: problem: '+e);
                    ok = false;
                }                    
            }
            //assetLocked = false;          
        }
       
        return ok;      
    }

    public Boolean deleteContentDocuments(List<ContentDocument> documents) {
        Boolean ok = true;
        
        system.debug('deleteContentDocuments: already done? '+contentDocumentLocked);
        if (!contentDocumentLocked) {
            contentDocumentLocked = true;
            if (!uw_HelperMethods.listIsNull(documents)) {
                try {
                    delete documents;              
                } catch (Exception e) {
                  system.debug('deleteContentDocuments: problem: '+e);
                  ok = false;
                }
            }
            //contentDocumentLocked = false;          
        }
       
        return ok;      
    }

    private static testmethod void basic() {
      uw_DeleteObjectsHelper doh = new uw_DeleteObjectsHelper();
        system.assertEquals(true, doh.lockAsset(true));
        system.assertEquals(false, doh.lockAsset(false));
        system.assertEquals(true, doh.lockContentDocument(true));
        system.assertEquals(false, doh.lockContentDocument(false));
    }
        
    private static testmethod void test() {
        User u1 = uw_UnitTestDataFactory.initInternalUser('alias1', 'email1@email.com', 'lastname1', 'user1@test.test.edu');
        User u2 = uw_UnitTestDataFactory.initInternalUser('alias2', 'email2@email.com', 'lastname2', 'user2@test.test.edu');

        System.runAs(u1) {
             
            //IDC- 14 Jun - Creating test data for Inoplan object
            uw_Inoplan_Project__c inoPlanProject = uw_UnitTestDataFactory.createInoplan();
            insert inoPlanProject;
        
            //IDC- 14 Jun - new Inoplan parameter added     
            uw_BET__c b1 = uw_UnitTestDataFactory.initBET('betName', true,inoPlanProject);
            ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
            system.debug('cv1: '+cv1);
          uw_Asset__c a1 = uw_UnitTestDataFactory.initAsset('n', cv1, b1);
          List<uw_Asset__c> assets = new List<uw_Asset__c>();
          assets.add(a1);
          
            uw_DeleteObjectsHelper doh = new uw_DeleteObjectsHelper();
            system.assertEquals(true, doh.deleteAssets(assets));

            ContentVersion cv2 = uw_UnitTestDataFactory.initContentVersion();
            List<ContentVersion> cvs = [SELECT Id,ContentDocumentId FROM ContentVersion];
            system.debug('cvs: '+cvs);
            system.assert(cvs != null);
            system.assert(cvs.size() > 0);
            
            List<ContentDocument> cds = new List<ContentDocument>();
            ContentDocument cd = [SELECT Id FROM ContentDocument WHERE Id=:cvs[0].contentDocumentId LIMIT 1];
            system.assert(cd != null);
          cds.add(cd);
          
          doh.deleteContentDocuments(cds);
          
            ContentVersion cv3 = uw_UnitTestDataFactory.initContentVersion();
            uw_Asset__c a2 = uw_UnitTestDataFactory.initAsset('n2', cv3, b1);
            List<uw_Asset__c> assets3 = new List<uw_Asset__c>();
            assets3.add(a2);
            
            doh.lockAsset(false);
            doh.updateAssets(assets3);
         }

        System.runAs(u2) {
            
        }

    }
}