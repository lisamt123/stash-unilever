/*****************************************************************************************
* @author       Shahin Movahedi
* @date         2016-01-14
* @description  This class contains common methods used by subclasses throughout 
*               SWOP application
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    --------------------------------------------------------------------------
*   
*    Shahin Movahedi            2016-01-14          Created

******************************************************************************************/
public virtual class Oblix_SWOPparentController {

    public Marketing_SOW__c selected_sow {get; set;}
    public Oblix_SOW_Projects__c selected_project {get;set;}
    public Oblix_CampaignStageLogic stage_identifier {get;set;}

    public Oblix_SWOPparentController() {
        
    }

    public Pagereference exitSwop(){
        return Oblix_Utils.exitSwop();
    }



}