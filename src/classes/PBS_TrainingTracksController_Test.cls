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
private class PBS_TrainingTracksController_Test{

    private static testMethod void testWithoutSharedTracks(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        List<PBS_Params_Test.TrainingTrackParam> params = new List<PBS_Params_Test.TrainingTrackParam>();
        params.add(new PBS_Params_Test.TrainingTrackParam());
        params.add(new PBS_Params_Test.TrainingTrackParam());
        params.add(new PBS_Params_Test.TrainingTrackParam());
        params.add(new PBS_Params_Test.TrainingTrackParam());

        List<PBS_Training_Track__c> tracks = PBS_TrainingTrackData_Test.createTrainingTracks(params);

        Test.startTest();

            System.runAs(lmsUsers.get(0)){
                PBS_TrainingTracksController_CC cont = new PBS_TrainingTracksController_CC();
                System.assertEquals(0,cont.tTracks.size());
            }

        Test.stopTest();

    }

    private static testMethod void testWithSharedTracks(){

        //Create admin users
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(5,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'LMS_User');
        }

        List<PBS_Params_Test.TrainingTrackParam> params = new List<PBS_Params_Test.TrainingTrackParam>();
        params.add(new PBS_Params_Test.TrainingTrackParam());
        params.add(new PBS_Params_Test.TrainingTrackParam());
        params.add(new PBS_Params_Test.TrainingTrackParam());
        params.add(new PBS_Params_Test.TrainingTrackParam());

        List<PBS_Training_Track__c> tracks = PBS_TrainingTrackData_Test.createTrainingTracks(params);
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

            System.runAs(lmsUsers.get(0)){
                PBS_TrainingTracksController_CC cont = new PBS_TrainingTracksController_CC();
                System.assertEquals(4,cont.tTracks.size());
            }

        Test.stopTest();

    }


}