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
public class PBS_SubFolderCtrl_Test {
    static testMethod void testSubFolderMethods(){
        List<User> adminUsers = PBS_UtilClass_Test.createUsers(2,'System Administrator');
        List<User> lmsUsers = PBS_UtilClass_Test.createUsers(2,'Standard User');

        System.runAs(adminUsers.get(0)){
            //Assign corresponding perm sets
            PBS_UtilClass_Test.addPermissionSet(adminUsers,'PBS_LMS_Admin');
            PBS_UtilClass_Test.addPermissionSet(lmsUsers,'PBS_LMS_User');
        }
        PBS_TrainingPlanData_Test.createSampleData();
		List<PBS_Learning_Category__c> tplanCategories =[Select Id, Name from PBS_Learning_Category__c Order By Name desc ];
        
        PageReference ref = Page.PBS_SubFolder;
        ref.getParameters().put('id',tplanCategories.get(0).Id);
        
        Test.setCurrentPageReference(ref);
        Test.startTest();
            System.runAs(lmsUsers.get(0)){
                PBS_SubFolderController_CC cont = new PBS_SubFolderController_CC();
                System.assert(cont.getCourseTypeOptions().size()>0);
                System.assert(cont.getGeographyOptions().size()>0);
                System.assert(cont.getJobProfileOptions().size()>0);
                System.assert(cont.getWorkLevelOptions().size()>0);
                System.assert(cont.filterResults()!=null);
            }
        Test.stopTest();
    }

}