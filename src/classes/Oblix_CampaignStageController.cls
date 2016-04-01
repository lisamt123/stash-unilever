public with sharing class Oblix_CampaignStageController {

	// component attributes set by container
	public Oblix_CampaignStageLogic stage_identifier {get;set;}
	public Boolean b_auto_save {get;set;}
    public Integer display_mode {
        get{
            if(display_mode == null) {
                return 1;
            }
            return display_mode;
        }
        set;
    }

	// local component attributes 
	public String s_completion_stage {get;set;}
	public String s_projection_stage {get;set;}

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  set the correct attributes for the campaign based on the user click
    ********************************************************************************/
	public PageReference setCompletionStageIdentifier(){
		// check if the stage user clicked on was checked/unchecked before by looking at the status of the campaign in scope
        System.debug('### toggle completion stage: ' + s_completion_stage);
		stage_identifier.toggleCompletionStage(s_completion_stage);
		
		// only commit to database if auto-save is set to true
		if (b_auto_save)
			stage_identifier.saveStage();

		return null;

	}

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  set the correct attributes for the campaign based on the user click
    ********************************************************************************/
	public PageReference setProjectedStageIdentifier(){
		// check if the stage user clicked on was checked/unchecked before by looking at the status of the campaign in scope
		stage_identifier.toggleProjectedStage(s_projection_stage);

		// only commit to database if auto-save is set to true
		if (b_auto_save)
			stage_identifier.saveStage();

		return null;
	}
}