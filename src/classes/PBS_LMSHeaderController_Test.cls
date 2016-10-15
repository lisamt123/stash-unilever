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
public class PBS_LMSHeaderController_Test {

    private static final string STR_TRAINGING ='mytraining';
    private static final string STR_CATALOG ='catalog';
    private static final string STR_PROFILE ='myprofile';
    
    static testmethod void testHeaderAsAdmin(){

      //Create admin users
      List<User> adminUsers = PBS_TestUtilClass.createUsers(1,'System Administrator');

      System.runAs(adminUsers.get(0)){
          //Assign corresponding perm sets
          PBS_TestUtilClass.addPermissionSet(adminUsers,'PBS_LMS_Admin');
      }
       /* removed for sonar fix
      PBS_AlmondNavigation__c mytraining = PBS_TestHelper.createNavItem(STR_TRAINGING, Page.PBS_MyTraining.getUrl(), STR_TRAINGING);
      PBS_AlmondNavigation__c catalog    = PBS_TestHelper.createNavItem(STR_CATALOG, Page.PBS_TrainingCatalogHome.getUrl(), STR_CATALOG);
      PBS_AlmondNavigation__c myprofile  = PBS_TestHelper.createNavItem(STR_PROFILE, Page.PBS_MyProfile.getUrl(), STR_PROFILE);
      */
      
      PBS_TestHelper.createNavItem(STR_TRAINGING, Page.PBS_MyTraining.getUrl(), STR_TRAINGING);
      PBS_TestHelper.createNavItem(STR_CATALOG, Page.PBS_TrainingCatalogHome.getUrl(), STR_CATALOG);
      PBS_TestHelper.createNavItem(STR_PROFILE, Page.PBS_MyProfile.getUrl(), STR_PROFILE);
      Test.startTest();

        System.runAs(adminUsers.get(0)){
            PBS_LMSHeaderController_CC cont;
            Test.setCurrentPageReference(Page.PBS_MyTraining);
            cont = new PBS_LMSHeaderController_CC ();
            System.assertEquals(STR_TRAINGING,cont.section);
            Test.setCurrentPageReference(Page.PBS_MyProfile);
            cont = new PBS_LMSHeaderController_CC ();
            System.assertEquals(STR_PROFILE,cont.section);
            Test.setCurrentPageReference(Page.PBS_TrainingCatalogHome);
            cont = new PBS_LMSHeaderController_CC ();
            System.assertEquals(STR_CATALOG,cont.section);
        }

      Test.stopTest();

    }

    static testmethod void testHeaderAsUser(){

      //Create regular user users
      List<User> adminUsers = PBS_TestUtilClass.createUsers(1,'System Administrator');
      List<User> lmsUsers = PBS_TestUtilClass.createUsers(1,'Standard User');

      System.runAs(adminUsers.get(0)){
          //Assign corresponding perm sets
          PBS_TestUtilClass.addPermissionSet(adminUsers,'PBS_LMS_Admin');
          PBS_TestUtilClass.addPermissionSet(lmsUsers,'PBS_LMS_User');
      }
      /* removed for sonar fix
      PBS_AlmondNavigation__c mytraining = PBS_TestHelper.createNavItem(STR_TRAINGING, Page.PBS_MyTraining.getUrl(), STR_TRAINGING);
      PBS_AlmondNavigation__c catalog    = PBS_TestHelper.createNavItem(STR_CATALOG, Page.PBS_TrainingCatalogHome.getUrl(), STR_CATALOG);
      PBS_AlmondNavigation__c myprofile  = PBS_TestHelper.createNavItem(STR_PROFILE, Page.PBS_MyProfile.getUrl(), STR_PROFILE);
      */
      PBS_TestHelper.createNavItem(STR_TRAINGING, Page.PBS_MyTraining.getUrl(), STR_TRAINGING);
      PBS_TestHelper.createNavItem(STR_CATALOG, Page.PBS_TrainingCatalogHome.getUrl(), STR_CATALOG);
      PBS_TestHelper.createNavItem(STR_PROFILE, Page.PBS_MyProfile.getUrl(), STR_PROFILE);
      
      Test.startTest();

          System.runAs(lmsUsers.get(0)){
              PBS_LMSHeaderController_CC cont;
              Test.setCurrentPageReference(Page.PBS_MyTraining);
              cont = new PBS_LMSHeaderController_CC ();
              System.assertEquals(STR_TRAINGING,cont.section);
              Test.setCurrentPageReference(Page.PBS_MyProfile);
              cont = new PBS_LMSHeaderController_CC ();
              System.assertEquals(STR_PROFILE,cont.section);
              Test.setCurrentPageReference(Page.PBS_TrainingCatalogHome);
              cont = new PBS_LMSHeaderController_CC ();
              System.assertEquals(STR_CATALOG,cont.section);
          }

      Test.stopTest();

    }

}