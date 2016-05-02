/**********************************************************************
Name: BET_BatchCopyBrandValues_Test
Copyright © 2014 Unilever.
=======================================================
=======================================================
Purpose: Test class for BET_BatchCopyBrandValues_Test 
=======================================================
=======================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Istvan Szegedi          17/09/2014      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class BET_BatchCopyBrandValues_Test { 
    /*******************************************************************
    Purpose: Method to test copy brand values using batch Apex class
    Parameters: Void
    Returns: Void
    Throws [Exceptions]: [optional]
    ********************************************************************/
    static testmethod void copyBrandValues(){
        List<uw_Brand__c> brandList = new List<uw_Brand__c>();
         // Create Test data
         uw_Brand__c brand1= new uw_Brand__c();
         brand1.Name = 'Lipton';
         brand1.Background_Colour__c = '#515151';
         brand1.Banner_Colour__c = '#8C5927';
         brand1.Border_Colour__c = '#E9F5D5';
         brand1.Component_Colour__c = '#E9F5D5';
         brand1.Font_Colour__c = '#DE599B';
         brand1.Brand_Logo_Image_ID__c = '015E0000001IRVJ';
         brandList.add(brand1);
         
         uw_Brand__c brand2= new uw_Brand__c();
         brand2.Name = 'Lipton Tea';
         brandList.add(brand2);
         
         uw_Brand__c brand3 = new uw_Brand__c();
         brand3.Name = 'Axe';
         brand3.Background_Colour__c = '#231F20';
         brand3.Banner_Colour__c = '#231F20';
         brand3.Component_Colour__c = '#8B0045';
         brand3.Font_Colour__c = '#FFFFFF';
         brand3.Brand_Logo_Image_ID__c = '015E0000001IRVO';
         brandList.add(brand3);
         
         insert brandList;
         
         // Start test
         Test.startTest();
         BET_BatchCopyBrandValues batchCopy = new  BET_BatchCopyBrandValues();
         Database.executeBatch(batchCopy, 200);
         Test.stopTest();
         
         // Assert test result
         brandList =  [SELECT Id, Name, Background_Colour__c, Banner_Colour__c, Banner_Location__c, Border_Colour__c, Brand_Logo_Image_Id__C, Component_Colour__c, Font_Colour__c  FROM uw_Brand__c WHERE Name = 'Lipton Tea'];
         System.assertEquals('#515151', brandList[0].Background_Colour__c );
         System.assertEquals('#8C5927', brandList[0].Banner_Colour__c );
         System.assertEquals('#E9F5D5', brandList[0].Border_Colour__c );
         System.assertEquals('#E9F5D5', brandList[0].Component_Colour__c );
         System.assertEquals('#DE599B', brandList[0].Font_Colour__c );
         System.assertEquals('015E0000001IRVJ', brandList[0].Brand_Logo_Image_ID__c );
         
         brandList =  [SELECT Id, Name, Background_Colour__c, Banner_Colour__c, Banner_Location__c, Border_Colour__c, Brand_Logo_Image_Id__C, Component_Colour__c, Font_Colour__c  FROM uw_Brand__c WHERE Name = 'Axe'];
         System.assertEquals('#231F20', brandList[0].Background_Colour__c );
         System.assertEquals('#231F20', brandList[0].Banner_Colour__c );
         System.assertEquals('#8B0045', brandList[0].Component_Colour__c );
         System.assertEquals('#FFFFFF', brandList[0].Font_Colour__c );
         System.assertEquals('015E0000001IRVO', brandList[0].Brand_Logo_Image_ID__c );
         
    }
}