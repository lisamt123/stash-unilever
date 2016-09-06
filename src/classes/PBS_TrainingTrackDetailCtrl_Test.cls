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
private class PBS_TrainingTrackDetailCtrl_Test{

    static testMethod void testSharedTrackDetail(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'PBS_LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'PBS_LMS_User');
        }

        PBS_TrainingTrackData_Test.createSampleData();

        List<PBS_Training_Track__c> tracks = [select id,name from PBS_Training_Track__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        List<PBS_Training_Track_Level_Item__c> trackItems = [select id,name from PBS_Training_Track_Level_Item__c limit :integer.valueof(System.Label.PBS_soqllimit)];
        System.assertEquals(1,tracks.size());
        System.assert(trackItems.size()>0);

        List<PBS_Training_Track__Share> shares = new List<PBS_Training_Track__Share>();

        for(PBS_Training_Track__c t : tracks){
            PBS_Training_Track__Share tShr  = new PBS_Training_Track__Share();
            tShr.ParentId = t.Id;
            tShr.UserOrGroupId = lmsUsers.get(0).Id;
            tShr.AccessLevel = 'Read';
            shares.add(tShr);
        }

        insert shares;


        Test.startTest();

            PageReference pageRef = Page.PBS_TrainingTrackDetail;
            Test.setCurrentPage(pageRef);
            pageRef.getParameters().put('id', tracks.get(0).Id);

            System.runAs(lmsUsers.get(0)){
                PBS_TrainingTrackDetailCtrl_CC cont = new PBS_TrainingTrackDetailCtrl_CC();
                System.assert(cont.track != null);
            }
             System.runAs(adminUsers.get(0)){
                PBS_TrainingTrackDetailCtrl_CC cont = new PBS_TrainingTrackDetailCtrl_CC();
                System.assert(cont.track != null);
            }
        	// Added below lines to cover pbs_training_track_item_cc
        	System.runAs(adminUsers.get(0)){
                PBS_TrainingTrackDetailCtrl_CC cont = new PBS_TrainingTrackDetailCtrl_CC();
                List<PBS_TrainingTrackLevel_CC> trackLevels = cont.trackLevels;
                for(PBS_TrainingTrackLevel_CC tlevel : trackLevels){
                    List<PBS_TrainingTrackItem_CC> trackItemslist = tlevel.trackItems;
                    for(PBS_TrainingTrackItem_CC titem :trackItemslist){
                        System.assert(titem.getItemURL()==null);
                    }
                }
                
            }

        Test.stopTest();

    }
    
}