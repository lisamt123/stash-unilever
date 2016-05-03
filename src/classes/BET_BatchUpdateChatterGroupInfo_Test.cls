/**********************************************************************
Name: BET_BatchUpdateChatterGroupInfo_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_BatchUpdateChatterGroupInfo
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Wojciech Migas          05/02/2015      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public with sharing class BET_BatchUpdateChatterGroupInfo_Test {
    /*******************************************************************
    Purpose: Method to test if group information has been updated
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void checkIfGroupInformationBodyHasBeenUpdated(){
        String groupInformation = 'This is the external view of the studio.For Unilever Internal users, use the links below to open the toolkit, brand &amp; studio.<br><a href="/apex/brandexperiencestudio?id=a0Cc000000MPVWLEA5" target="_blank"><img width="60" height="60" src="/resource/1349283465000/StudioIcon"></img></a> <a href="/a0Cc000000MPVWLEA5" target="_blank"><img width="60" height="60" src="/resource/1349283465000/ToolkitIcon"></img></a> <a href="/a0EE0000004qtm2MAA" target="_blank"><img width="60" height="60" src="/resource/1349283464000/BrandIcon"></img></a><br><br>';
        String updatedGroupInformation = 'This is the external view of the studio.For Unilever Internal users, use the links below to open the toolkit, brand &amp; studio.<br> <a href="/a0Cc000000MPVWLEA5" target="_blank"><img width="60" height="60" src="/resource/1349283465000/ToolkitIcon"></img></a> <br><br>';

        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        CollaborationGroup chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        chatterGroup.InformationBody = groupInformation;
        update chatterGroup;

		chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        System.assertEquals(groupInformation, chatterGroup.InformationBody);

        // Start test
        Test.startTest();
        BET_BatchUpdateChatterGroupInfo batchMapping = new BET_BatchUpdateChatterGroupInfo();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

		chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        System.assertEquals(updatedGroupInformation, chatterGroup.InformationBody);
    }
    
    /*******************************************************************
    Purpose: Method to test empty group information
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void checkEmptyGroupInformationBody(){
        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        CollaborationGroup chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        chatterGroup.InformationBody = null;
        update chatterGroup;

		chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        System.assertEquals(null, chatterGroup.InformationBody);

        // Start test
        Test.startTest();
        BET_BatchUpdateChatterGroupInfo batchMapping = new BET_BatchUpdateChatterGroupInfo();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

		chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        System.assertEquals(null, chatterGroup.InformationBody);
    }

    /*******************************************************************
    Purpose: Method to test empty group information
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optoinal]
    ********************************************************************/
    static testmethod void checkArchivedGroup(){
        String groupInformation = 'This is the external view of the studio.For Unilever Internal users, use the links below to open the toolkit, brand &amp; studio.<br><a href="/apex/brandexperiencestudio?id=a0Cc000000MPVWLEA5" target="_blank"><img width="60" height="60" src="/resource/1349283465000/StudioIcon"></img></a> <a href="/a0Cc000000MPVWLEA5" target="_blank"><img width="60" height="60" src="/resource/1349283465000/ToolkitIcon"></img></a> <a href="/a0EE0000004qtm2MAA" target="_blank"><img width="60" height="60" src="/resource/1349283464000/BrandIcon"></img></a><br><br>';
        String updatedGroupInformation = 'This is the external view of the studio.For Unilever Internal users, use the links below to open the toolkit, brand &amp; studio.<br> <a href="/a0Cc000000MPVWLEA5" target="_blank"><img width="60" height="60" src="/resource/1349283465000/ToolkitIcon"></img></a> <br><br>';

        BET_TestingHelper.BET_TestingData betWrapper1 = BET_TestingHelper.initBET('Test BET UT', true);
        CollaborationGroup chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        chatterGroup.InformationBody = groupInformation;
        chatterGroup.IsArchived = true;
        update chatterGroup;

		chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        System.assertEquals(groupInformation, chatterGroup.InformationBody);

        // Start test
        Test.startTest();
        BET_BatchUpdateChatterGroupInfo batchMapping = new BET_BatchUpdateChatterGroupInfo();
        Database.executeBatch(batchMapping, 10);
        Test.stopTest();

		chatterGroup = [SELECT Id, InformationBody FROM CollaborationGroup WHERE Id =: betWrapper1.BET.Studio_Chatter_Group__c];
        System.assertEquals(updatedGroupInformation, chatterGroup.InformationBody);
    }
}