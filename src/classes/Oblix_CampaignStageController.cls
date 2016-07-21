public with sharing class Oblix_CampaignStageController {

	// component attributes set by container
	public Oblix_CampaignStageLogic stage_identifier {get;set;}
	public Boolean b_auto_save {get;set;}

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
		stage_identifier.setCompletionStage(s_completion_stage, stage_identifier.sow_project_in_scope.Completed_Stage__c);
		
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
		stage_identifier.setProjectedStage(s_projection_stage, stage_identifier.sow_project_in_scope.Projected_Stage__c);

		// only commit to database if auto-save is set to true
		if (b_auto_save)
			stage_identifier.saveStage();

		return null;
	}
}