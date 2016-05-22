/*****************************************************************************************
* @author       Execloud ©
* @date         2016-03-04
* @description  This class contains common methods used by Oblix_AssetHandler trigger handler
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Execloud ©                2016-05-20          Created

******************************************************************************************/
public with sharing class Oblix_AssetHandlerLogic {

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2015-12-23
    * @description  In order to ensure before update on parent SOW Campaigns gets fired
                    as part of the child update, Enforce_Trigger_Update__c field is 
                    created and rolled up on parent. This field simply gets populated
                    with a short version of date/time formated integer. This field needs
                    to be unique as changes to the child record will result in a different
                    rollup summary and therefore update trigger fired.
    ********************************************************************************/
    public static void setEnforceTriggerUpdate(Oblix_Project_Assets__c so_asset){
        
            so_asset.Enforce_Trigger_Update__c = Integer.valueOf(datetime.now().format('dhmss'));
    }

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-05-22
    * @description  populate the fields for assets which need to be adjusted
    ********************************************************************************/
    public static void adjustAssetFields(Oblix_Project_Assets__c asset_to_adjust){

        // set asset campaign Id
        asset_to_adjust.Campaign_ID__c = (String) asset_to_adjust.Agency_Projects__c;
    }

}