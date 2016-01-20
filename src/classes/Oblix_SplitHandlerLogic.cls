/*****************************************************************************************
* @author       Shahin Movahedi
* @date         2015-12-23
* @description  This class contains common methods used by Oblix_SplitHandler trigger handler
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Shahin Movahedi            2015-12-23          Created

******************************************************************************************/
public with sharing class Oblix_SplitHandlerLogic {

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
    public static void setEnforceTriggerUpdate(Oblix_Marketing_SOW_Project_Splits__c so_project_split){
    	
    		so_project_split.Enforce_Trigger_Update__c = Integer.valueOf(datetime.now().format('dhmss'));
    }


}