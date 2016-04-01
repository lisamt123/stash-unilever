/*******************************************************************
    Purpose: Wrapper class used to set colour for completed/outstanding 
                stages accordingly
    Parameters: Oblix_SOW_Projects__c with Completed_Stage__c and Projected_Stage__c populated
    Returns: an instance of StageIdentifier which contains css and boolean values for the 5 stages
    Throws [Exceptions]: none
********************************************************************/
public with sharing class Oblix_CampaignStageLogic{

    public static final String CAMPIGN_PROJECTED_STAGE_CFY_FIELD_NAME = 'Stage_Projected_CFY__c';
    public static final String CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME = 'Stage_Completed_CFY__c';

    // final strings used for stage identifier CSS styling
    public static final String CSS_COMPLETED_PROGRESS_NOT_STARTED = 'chevron_not_started';
    public static final String CSS_COMPLETED_PROGRESS_STARTED = 'chevron_in_progress';
    public static final String CSS_COMPLETED_PROGRESS_COMPLETED = 'chevron_completed';
    public static final String CSS_PROJECTED_NOT_PROJECTED = 'chevron_not_projected';
    public static final String CSS_PROJECTED_PROJECTED = 'chevron_projected';


    //containers for valid project stages and their parameters
    public static List<Oblix_Settings__c> stageList {
        get{
            if (stageList != null) {
                return stageList;
            }
            stageList = Oblix_Utils.getOblixSettingsListNameStartsWith('PROJECT_STAGE_');
            return stageList;
        }
    }

    public static Map<String, Oblix_Settings__c> stagesByLabel {
        get{
            if (stagesByLabel != null) {
                return stagesByLabel;
            }
            stagesByLabel = new Map<String, Oblix_Settings__c>();
            for (Oblix_Settings__c stage : stageList) {
                stagesByLabel.put(stage.Label__c, stage);
            }
            return stagesByLabel;
        }
        set;
    }

    public static Map<Integer, Oblix_Settings__c> stagesByOrder {
        get {
            if (stagesByOrder != null) {
                return stagesByOrder;
            }
            stagesByOrder = new Map<Integer, Oblix_Settings__c>();
            for (Oblix_Settings__c stage : stageList) {
                stagesByOrder.put(Integer.valueOf(stage.Attribute_1__c), stage);
            }
            return stagesByOrder;
        }
        set;
    }
    

    public Integer i_percentage_of_fee_this_year {get;set;}
    public Integer i_agency_Percentage_of_fees_this_year {get;set;}
    public Boolean b_is_projection_selectable {get;set;}
    public Boolean b_is_completion_selectable {get;set;}
    private Boolean b_manual_override_on = false;
    //public List<Boolean> lib_is_stage_projected {get;set;}
    //public List<Boolean> lib_is_stage_completed {get;set;}
    
    public Oblix_SOW_Projects__c sow_project_in_scope {get;set;}

    public String s_selected_projected_stage{get; set;}
    public String s_selected_completed_stage{get; set;}
    public Integer i_fees_for_this_financial_year {get; private set;}


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  instance list to hold projected stages containing stage object
    ********************************************************************************/
    public Map<Integer, Stage> projected_stages {
        get{
            if (null==projected_stages){
                projected_stages = new Map<Integer, Stage>();

                for (Integer i : stagesByOrder.keySet()){
                    //Default to all selectable and selected (DE218)
                    projected_stages.put(i, new Stage(true, i, stagesByOrder.get(i).Label__c, Integer.valueOf(stagesByOrder.get(i).Value__c), true, true));
                }
            }
        return projected_stages;

        }
        set;
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  instance list to hold completed stages containing stage object
    ********************************************************************************/
    public Map<Integer, Stage> completed_stages {
        get{
            if (null==completed_stages){
                completed_stages = new Map<Integer, Stage>();

                for (Integer i : stagesByOrder.keySet()){
                    //Default to all selectable but not selected
                    completed_stages.put(i, new Stage(false, i, stagesByOrder.get(i).Label__c, Integer.valueOf(stagesByOrder.get(i).Value__c), true, false));
                }
            }
        return completed_stages;

        }
        set;
    }
    
    
     public Oblix_CampaignStageLogic(Oblix_SOW_Projects__c sow_project, Integer percentageValue, boolean is_projection_selectable, boolean is_completeion_selectable){
        

        sow_project_in_scope = sow_project;

        b_manual_override_on = sow_project_in_scope.Value_To_BePaid_Manual_Override__c;

        b_is_projection_selectable = is_projection_selectable;
        b_is_completion_selectable = is_completeion_selectable;

        i_percentage_of_fee_this_year = percentageValue;
        system.debug('###i_percentage_of_fee_this_year : '+i_percentage_of_fee_this_year);
        calculateFeesForThisYear();
             
     }
    
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  Oblix_CampaignStageLogic constructor
    ********************************************************************************/
    public Oblix_CampaignStageLogic(Id sow_id){

        sow_project_in_scope = new Oblix_SOW_Projects__c();
        sow_project_in_scope.Financial_Year__c = sow_id;
        b_manual_override_on = sow_project_in_scope.Value_To_BePaid_Manual_Override__c = false;
        b_is_projection_selectable = true;
        b_is_completion_selectable = true;

        // S.M. all projected stages should be set to true by default DE218
        //sow_project_in_scope.Projected_Stage__c = STAGE_PROJECT_PRODUCTION;
        sow_project_in_scope.Stage_Projected_CFY__c = String.join(new List<String>(stagesByLabel.keyset()), ';');
        sow_project_in_scope.Stage_Completed_CFY__c = '';
        //sow_project_in_scope.Completed_Stage__c = STAGE_PROJECT_BRIEFING;
        sow_project_in_scope.Campaign_Total_Adjustment__c = 0;
        sow_project_in_scope.Percentage_of_Fee_for_this_FY__c = 100;
        
        //setStageAndCSS(sow_project_in_scope.Projected_Stage__c, sow_project_in_scope.Completed_Stage__c,true,true);
        initStages();

        calculateFeesForThisYear();

    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  Oblix_CampaignStageLogic constructor
    ********************************************************************************/
    public Oblix_CampaignStageLogic(Id sow_project_id, boolean is_projection_selectable, boolean is_completeion_selectable){

        // retrieve campaign by Id passed in - to create override constructor
        List<Oblix_SOW_Projects__c> liso_projects_for_sow = [SELECT Name, Project_Finish_Date__c, Campaign_Status__c, Platform__c, Project_Stage__c, Projected_Stage__c, Completed_Stage__c
            , CreatedById, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Campaign_Total_Fees__c
            , Percentage_of_Fee_for_this_FY__c, Project_Completion_Date__c, Description__c, Campaign_Countries__c, First_Air_Date__c, Production_Completion_Date__c, Financial_Year__c, Value_To_BePaid_Manual_Override__c 
            FROM Oblix_SOW_Projects__c WHERE Id = : sow_project_id ];

        if (NULL!=liso_projects_for_sow && !liso_projects_for_sow.isEmpty()){
            this(liso_projects_for_sow[0],is_projection_selectable, is_completeion_selectable) ;
        }
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  Oblix_CampaignStageLogic constructor
    ********************************************************************************/
    public Oblix_CampaignStageLogic(Oblix_SOW_Projects__c sow_project, boolean is_projection_selectable, boolean is_completion_selectable){

        b_is_projection_selectable = is_projection_selectable;
        b_is_completion_selectable = is_completion_selectable;

        sow_project_in_scope = sow_project;
        b_manual_override_on = sow_project_in_scope.Value_To_BePaid_Manual_Override__c;
        //setStageAndCSS(sow_project.Projected_Stage__c, sow_project.Completed_Stage__c,true,true);
        initStages();

        calculateFeesForThisYear();
    }


    /*******************************************************************************
    * @author       Ivan Ribakov
    * @date         2016-03-30
    * @description  helper method to initialise stage wrapper objects
    ********************************************************************************/
    public void initStages() {

        i_percentage_of_fee_this_year = 0;
        i_agency_Percentage_of_fees_this_year = 0;

        String currentProjectedValue = (String)sow_project_in_scope.get(CAMPIGN_PROJECTED_STAGE_CFY_FIELD_NAME);
        currentProjectedValue = (currentProjectedValue == null) ? '' : currentProjectedValue;
        List<String> projectedValueList = currentProjectedValue.split(';');
        Set<String> projectedValueSet = new Set<String>(projectedValueList);

        String currentCompletedValue = (String)sow_project_in_scope.get(CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME);
        currentCompletedValue = (currentCompletedValue == null) ? '' : currentCompletedValue;
        List<String> completedValueList = currentCompletedValue.split(';');
        Set<String> completedValueSet = new Set<String>(completedValueList);

        Set<String> pastFYProjectedValueSet = new Set<String>();
        Set<String> pastFYCompletedValueSet = new Set<String>();

        for (Integer i : projected_stages.keySet()) {
            Stage projectedStage = projected_stages.get(i);
            Stage completedStage = completed_stages.get(i);

            initProjectedStages(projectedStage, projectedValueSet, pastFYProjectedValueSet);
            initCompletedStages(completedStage, completedValueSet, pastFYProjectedValueSet, pastFYCompletedValueSet);
            
        }

        if (b_manual_override_on) {
            i_percentage_of_fee_this_year = sow_project_in_scope.Percentage_of_Fee_for_this_FY__c.intValue();
        }

        system.debug('### after - initStages - projected : '+projected_stages);
        system.debug('### after - initStages - completed : '+completed_stages);

        s_selected_projected_stage = currentProjectedValue;
        s_selected_completed_stage = currentCompletedValue;
    }


    /*******************************************************************************
    * @author       Ivan Ribakov
    * @date         2016-03-30
    * @description  helper method to initialise stage wrapper objects
    ********************************************************************************/
    private void initProjectedStages(Stage projectedStage, 
                                     Set<String> projectedValueSet, 
                                     Set<String> pastFYProjectedValueSet) {
        //Projected INIT
        //PARAMETERS affecting selectability: b_is_projection_selectable, pastFYProjectedValueSet and b_manual_override_on
        //DEFAULT from projected_stages getter - true
        if (!b_is_projection_selectable || pastFYProjectedValueSet.contains(projectedStage.s_stage_name) || b_manual_override_on) {
            projectedStage.b_is_stage_selectable = false;
        }

        //PARAMETERS affecting selected state: projectedValueSet, pastFYProjectedValueSet and b_manual_override_on
        //DEFAULT from projected_stages getter - true
        //CRITERIA: Projected stage should NOT be selected if:
        //  a) it's not in the projectedValueSet
        //  b) it's not in the pastFYProjectedValueSet AND b_manual_override_on is TRUE (maintain selection for past FY stages)
        if (!projectedValueSet.contains(projectedStage.s_stage_name) ||
                (!pastFYProjectedValueSet.contains(projectedStage.s_stage_name) && b_manual_override_on)) {
            projectedStage.b_is_stage_selected = false;
        }

        //Update projected stage completion for this FYI
        if (projectedStage.b_is_stage_selectable && projectedStage.b_is_stage_selected) {
            i_percentage_of_fee_this_year += projectedStage.i_stage_percentage;
        }
    }



    /*******************************************************************************
    * @author       Ivan Ribakov
    * @date         2016-03-30
    * @description  helper method to initialise stage wrapper objects
    ********************************************************************************/
    private void initCompletedStages(Stage completedStage, 
                                     Set<String> completedValueSet, 
                                     Set<String> pastFYProjectedValueSet, 
                                     Set<String> pastFYCompletedValueSet) {
        //Completed INIT
        //PARAMETERS affecting selectability: b_is_completion_selectable and pastFYProjectedValueSet
        //DEFAULT from completed_stages getter - true
        if (!b_is_completion_selectable || pastFYProjectedValueSet.contains(completedStage.s_stage_name)) {
            completedStage.b_is_stage_selectable = false;
        }

        //PARAMETERS affecting selected state: completedValueSet and pastFYCompletedValueSet
        //DEFAULT from projected_stages getter - false
        if (completedValueSet.contains(completedStage.s_stage_name) || pastFYCompletedValueSet.contains(completedStage.s_stage_name)) {
            completedStage.b_is_stage_selected = true;
        }

        if (completedStage.b_is_stage_selectable && completedStage.b_is_stage_selected) {
            i_agency_Percentage_of_fees_this_year += completedStage.i_stage_percentage;
        }
    }





    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  depending on the percentage of fee this year and total fees to be paid
    ********************************************************************************/
    private void calculateFeesForThisYear(){
        system.debug('###is i_percentage_of_fee_this_year : '+i_percentage_of_fee_this_year);
        system.debug('###is sow_project_in_scope.Campaign_Total_Fees__c : '+sow_project_in_scope.Campaign_Total_Fees__c);
        
        i_fees_for_this_financial_year = calculateFeesForThisFY(i_percentage_of_fee_this_year, sow_project_in_scope.Campaign_Total_Fees__c);

        //if (NULL != i_percentage_of_fee_this_year && NULL != sow_project_in_scope.Campaign_Total_Fees__c && i_percentage_of_fee_this_year == 100 ){
        //    i_fees_for_this_financial_year = Integer.valueOf(sow_project_in_scope.Campaign_Total_Fees__c);
        //}
        //else if (NULL != i_percentage_of_fee_this_year && NULL != sow_project_in_scope.Campaign_Total_Fees__c ){
        //    i_fees_for_this_financial_year = Integer.valueOf((i_percentage_of_fee_this_year * sow_project_in_scope.Campaign_Total_Fees__c / 100).round(System.RoundingMode.Up));
        //}
        //else{
        //    i_fees_for_this_financial_year = 0;
        //}
        system.debug('###i_fees_for_this_financial_year : '+i_fees_for_this_financial_year);
    }

    public static Integer calculateFeesForThisFY(Decimal campaign_percentage, Decimal total_fees){
        if (NULL != campaign_percentage && NULL != total_fees && campaign_percentage == 100 ){
            return (Integer) total_fees.round(System.RoundingMode.HALF_EVEN);
        }
        else if (NULL != campaign_percentage && NULL != total_fees ){
            return Integer.valueOf((campaign_percentage * total_fees / 100).round(System.RoundingMode.HALF_EVEN));
        }
        else{
            return 0;
        }
    }


    /********************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-08
    * @description  This method is called from the component when the user
                    changes projected or completions stage of the current
                    instance of Oblix_SOW_Projects__c.
                    The method needs to check for the existing stage and
                    save appropriate stage into database
    *********************************************************************/
    public void saveStage(){
        system.debug('## saving stage for campaign: '  + sow_project_in_scope.name);
        upsert sow_project_in_scope;
    }



    /*******************************************************************************
    * @author       Ivan Ribakov
    * @date         2016-03-30
    ********************************************************************************/
    public void toggleProjectedStage(String val){

        System.debug('### campaign projected %: ' + sow_project_in_scope.Percentage_of_Fee_for_this_FY__c);
        System.debug('### controller projected %: ' + i_percentage_of_fee_this_year);


        String currentValue = (String)sow_project_in_scope.get(CAMPIGN_PROJECTED_STAGE_CFY_FIELD_NAME);
        currentValue = (currentValue == null) ? '' : currentValue;
        List<String> currentValueList = currentValue.split(';');
        Set<String> currentValueSet = new Set<String>(currentValueList);

        String currentCompletedValue = (String)sow_project_in_scope.get(CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME);
        currentCompletedValue = (currentCompletedValue == null) ? '' : currentCompletedValue;
        List<String> currentCompletedValueList = currentCompletedValue.split(';');
        Set<String> currentCompletedValueSet = new Set<String>(currentCompletedValueList);

        Integer stage_number = Integer.valueOf(stagesByLabel.get(val).Attribute_1__c);
        Stage projected_stage_wrapper = projected_stages.get(stage_number);
        Stage completed_stage_wrapper = completed_stages.get(stage_number);

        if (currentValueSet.contains(val)) {
            //Unticked
            i_percentage_of_fee_this_year -= projected_stage_wrapper.i_stage_percentage;
            projected_stage_wrapper.b_is_stage_selected = false;
            currentValueSet.remove(val);
            
            if (completed_stage_wrapper.b_is_stage_selected) {
                i_agency_Percentage_of_fees_this_year -= completed_stage_wrapper.i_stage_percentage;
            }
            completed_stage_wrapper.b_is_stage_selectable = false;
            completed_stage_wrapper.b_is_stage_selected = false;
            currentCompletedValueSet.remove(val);
        } else {
            //Ticked
            i_percentage_of_fee_this_year += projected_stage_wrapper.i_stage_percentage;
            projected_stage_wrapper.b_is_stage_selected = true;
            currentValueSet.add(val);

            completed_stage_wrapper.b_is_stage_selectable = true;
            completed_stage_wrapper.b_is_stage_selected = false;
            currentCompletedValueSet.remove(val);
        }

        calculateFeesForThisYear();

        // set percentage projection and completion
        //sow_project_in_scope.Agency_Percentage_of_Fees_to_this_FY__c = i_agency_Percentage_of_fees_this_year;
        sow_project_in_scope.Percentage_of_Fee_for_this_FY__c = i_percentage_of_fee_this_year;

        //setStageAttributes(false,true);

        String newValue          = String.join(new List<String>(currentValueSet), ';');
        sow_project_in_scope.put(CAMPIGN_PROJECTED_STAGE_CFY_FIELD_NAME, newValue);

        String newCompletedValue = String.join(new List<String>(currentCompletedValueSet), ';');
        sow_project_in_scope.put(CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME, newCompletedValue);

        s_selected_projected_stage = newValue;
        s_selected_completed_stage = newCompletedValue;
    }



    /*******************************************************************************
    * @author       Ivan Ribakov
    * @date         2016-03-30
    ********************************************************************************/
    public void toggleCompletionStage(String val){

        String currentValue = (String)sow_project_in_scope.get(CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME);
        currentValue = (currentValue == null) ? '' : currentValue;
        List<String> currentValueList = currentValue.split(';');
        Set<String> currentValueSet = new Set<String>(currentValueList);

        Integer stage_number = Integer.valueOf(stagesByLabel.get(val).Attribute_1__c);
        Stage stage_wrapper = completed_stages.get(stage_number);

        System.debug('### before - completed_stages: ' + completed_stages);
        System.debug('### before - stage_wrapper: ' + stage_wrapper);

        if (currentValueSet.contains(val)) {
            i_agency_Percentage_of_fees_this_year -= stage_wrapper.i_stage_percentage;
            currentValueSet.remove(val);
            stage_wrapper.b_is_stage_selected = false;
        } else {
            i_agency_Percentage_of_fees_this_year += stage_wrapper.i_stage_percentage;
            currentValueSet.add(val);
            stage_wrapper.b_is_stage_selected = true;
        }

        calculateFeesForThisYear();

        // set percentage projection and completion
        //sow_project_in_scope.Agency_Percentage_of_Fees_to_this_FY__c = i_agency_Percentage_of_fees_this_year;
        sow_project_in_scope.Percentage_of_Fee_for_this_FY__c = i_percentage_of_fee_this_year;

        //setStageAttributes(false,true);

        String newValue = String.join(new List<String>(currentValueSet), ';');
        sow_project_in_scope.put(CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME, newValue);

        s_selected_completed_stage = newValue;

        System.debug('### after - completed_stages: ' + completed_stages);
        System.debug('### after - stage_wrapper: ' + stage_wrapper);
    }








    /*******************************************************************************
    * @author       Ivan Ribakov
    * @date         2016-03-30
    * @description  wrapper class to hold the stage attributes
    ********************************************************************************/
    public class Stage{
        
        public Integer i_stage_number {get;set;}
        public String s_stage_name {get;set;}
        public Boolean b_is_stage_projected {get;set;} //TRUE  if wrapper represents projected stage,
                                                       //FALSE if wrapper represents completed stage

        public Boolean b_is_stage_selectable {
            get;
            set{
                b_is_stage_selectable = value;
                calculateCSS();
            }
        }
        public boolean b_is_stage_selected {
            get;
            set{
                b_is_stage_selected = value;
                calculateCSS();
            }
        }

        public String s_css_class_name {get;set;}
        public Integer i_stage_percentage {get;set;}

        public Stage(Boolean is_projected, Integer stage_number, String stage_name, Integer stage_percentage, Boolean is_selectable, boolean is_complete ){
            b_is_stage_projected = is_projected;
            i_stage_number = stage_number;
            s_stage_name = stage_name;
            b_is_stage_selectable = is_selectable;
            b_is_stage_selected = is_complete;
            i_stage_percentage = stage_percentage;

        }

        private void calculateCSS() {
            
            if (b_is_stage_projected) { //CSS styles for projected chevrons
                if (b_is_stage_selectable != null && b_is_stage_selected != null && b_is_stage_selectable && b_is_stage_selected) {
                    s_css_class_name = CSS_PROJECTED_PROJECTED;
                } else {
                    s_css_class_name = CSS_PROJECTED_NOT_PROJECTED;
                }
            } else { //CSS styles for completed chevrons
                if (b_is_stage_selectable != null && !b_is_stage_selectable) {
                    s_css_class_name = CSS_COMPLETED_PROGRESS_NOT_STARTED;
                } else if (b_is_stage_selectable != null && b_is_stage_selected != null && b_is_stage_selectable && !b_is_stage_selected) {
                    s_css_class_name = CSS_COMPLETED_PROGRESS_STARTED;
                } else if (b_is_stage_selectable != null && b_is_stage_selected != null && b_is_stage_selectable && b_is_stage_selected) {
                    s_css_class_name = CSS_COMPLETED_PROGRESS_COMPLETED;
                }
            }
        }
    }




}