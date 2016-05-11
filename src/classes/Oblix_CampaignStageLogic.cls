/*******************************************************************
    Purpose: Wrapper class used to set colour for completed/outstanding 
                stages accordingly
    Parameters: Oblix_SOW_Projects__c with Completed_Stage__c and Projected_Stage__c populated
    Returns: an instance of StageIdentifier which contains css and boolean values for the 5 stages
    Throws [Exceptions]: none
********************************************************************/
public with sharing class Oblix_CampaignStageLogic{

    public static final String CAMPIGN_PROJECTED_STAGE_CFY_FIELD_NAME = 'Projected_Stage_CFY__c';
    public static final String CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME = 'Completed_Stage_CFY__c';
    public static final String CAMPIGN_PROJECTED_STAGE_PFY_FIELD_NAME = 'Projected_Stage_PFY__c';
    public static final String CAMPIGN_COMPLETED_STAGE_PFY_FIELD_NAME = 'Completed_Stage_PFY__c';

    // final strings used for stage identifier CSS styling
    public static final String CSS_COMPLETED_GREY = 'chevron_not_started';
    public static final String CSS_COMPLETED_YELLOW = 'chevron_in_progress';
    public static final String CSS_COMPLETED_GREEN = 'chevron_completed';
    public static final String CSS_PROJECTED_GREY = 'chevron_not_projected';
    public static final String CSS_PROJECTED_GREEN = 'chevron_projected';


    //containers for valid project stages and their parameters
    private static List<Oblix_Settings__c> stageList {
        get{
            if (stageList != null) {
                return stageList;
            }
            stageList = Oblix_Utils.getOblixSettingsListNameStartsWith('PROJECT_STAGE_');
            return stageList;
        }
    }

    private static Map<String, Oblix_Settings__c> stagesByLabel {
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

    private static Map<Integer, Oblix_Settings__c> stagesByOrder {
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
    

    public Decimal i_percentage_of_fee_this_year {get;set;}
    public Decimal i_agency_Percentage_of_fees_this_year {get;set;}
    public Decimal cancelCampaignManualPercent {get;set;}
    public Boolean b_is_projection_selectable {get;set;}
    public Boolean b_is_completion_selectable {get;set;}
    public Boolean b_manual_override_on {
        get{
            if (b_manual_override_on == null) {
                b_manual_override_on = false;
            }
            return b_manual_override_on;
        }
        set;
    }
    public Boolean b_cancelled_campaign {
        get{
            try {
                return sow_project_in_scope.Campaign_Status__c == Oblix_Utils.CAMPAIGN_STATUS_CANCELLED;    
            } catch (Exception e) {
                System.debug(e);
            }
            return false;
        }
    }

    //public List<Boolean> liisProjected {get;set;}
    //public List<Boolean> lib_is_stage_completed {get;set;}
    
    public Oblix_SOW_Projects__c sow_project_in_scope {get;set;}

    public String s_selected_projected_stage{get; set;}
    public String s_selected_completed_stage{get; set;}
    public Integer i_fees_for_this_financial_year {get; private set;}

    public Set<String> projectedValueSet {
        get {
            if (projectedValueSet == null) {    
                String currentProjectedValue = (String)sow_project_in_scope.get(CAMPIGN_PROJECTED_STAGE_CFY_FIELD_NAME);
                currentProjectedValue = (currentProjectedValue == null) ? '' : currentProjectedValue;
                List<String> projectedValueList = currentProjectedValue.split(';');
                projectedValueSet = new Set<String>(projectedValueList);
            }
            return projectedValueSet;
        }
        set;
    }


    public Set<String> completedValueSet {
        get {
            if (completedValueSet == null) {
                String currentCompletedValue = (String)sow_project_in_scope.get(CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME);
                currentCompletedValue = (currentCompletedValue == null) ? '' : currentCompletedValue;
                List<String> completedValueList = currentCompletedValue.split(';');
                completedValueSet = new Set<String>(completedValueList);
            }
            return completedValueSet;
        }
        set;
    }


    public Set<String> pastFYProjectedValueSet {
        get {
            if (pastFYProjectedValueSet == null) {
                String pastFYProjectedValue = (String)sow_project_in_scope.get(CAMPIGN_PROJECTED_STAGE_PFY_FIELD_NAME);
                pastFYProjectedValue = (pastFYProjectedValue == null) ? '' : pastFYProjectedValue;
                List<String> pastFYprojectedValueList = pastFYProjectedValue.split(';');
                pastFYProjectedValueSet = new Set<String>(pastFYprojectedValueList);
            }
            return pastFYProjectedValueSet;
        }
        set;
    }


    public Set<String> pastFYCompletedValueSet {
        get {
            if (pastFYCompletedValueSet == null) {
                String pastFYCompletedValue = (String)sow_project_in_scope.get(CAMPIGN_COMPLETED_STAGE_PFY_FIELD_NAME);
                pastFYCompletedValue = (pastFYCompletedValue == null) ? '' : pastFYCompletedValue;
                List<String> pastFYCompletedValueList = pastFYCompletedValue.split(';');
                pastFYCompletedValueSet = new Set<String>(pastFYCompletedValueList);
            }
            return pastFYCompletedValueSet;
        }
        set;
    }
    


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
                    projected_stages.put(i, new Stage(true, i, stagesByOrder.get(i).Label__c, Integer.valueOf(stagesByOrder.get(i).Value__c), true, true, false));
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
                    completed_stages.put(i, new Stage(false, i, stagesByOrder.get(i).Label__c, Integer.valueOf(stagesByOrder.get(i).Value__c), true, false, false));
                }
            }
        return completed_stages;

        }
        set;
    }
    
    
     public Oblix_CampaignStageLogic(Oblix_SOW_Projects__c sow_project, Decimal percentageValue, boolean is_projection_selectable, boolean is_completeion_selectable){
        

        sow_project_in_scope = sow_project;

        b_manual_override_on = sow_project_in_scope.Value_To_BePaid_Manual_Override__c;

        b_is_projection_selectable = is_projection_selectable;
        b_is_completion_selectable = is_completeion_selectable;

        initStages();
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
        sow_project_in_scope.Projected_Stage_CFY__c = String.join(new List<String>(stagesByLabel.keyset()), ';');
        sow_project_in_scope.Completed_Stage_CFY__c = '';
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
        List<Oblix_SOW_Projects__c> liso_projects_for_sow = [SELECT Name, Project_Finish_Date__c, Campaign_Status__c, Platform__c, Project_Stage__c, Projected_Stage_CFY__c, Completed_Stage_CFY__c, 
            Projected_Stage_PFY__c, Completed_Stage_PFY__c, CreatedById, Total_Fees_for_Project__c, Value_to_be_paid_in_Current_FY__c, Project_Start_Date__c, CreatedDate, OblixRegion__c, Project_Priority__c, Campaign_Total_Fees__c
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


        for (Integer i : projected_stages.keySet()) {
            Stage projectedStage = projected_stages.get(i);
            Stage completedStage = completed_stages.get(i);

            initProjectedStages(projectedStage, projectedValueSet, pastFYProjectedValueSet);
            initCompletedStages(completedStage, projectedValueSet, completedValueSet, pastFYProjectedValueSet, pastFYCompletedValueSet);
            
        }

        if (b_manual_override_on || b_cancelled_campaign) {
            i_percentage_of_fee_this_year = sow_project_in_scope.Percentage_of_Fee_for_this_FY__c;
            cancelCampaignManualPercent = i_percentage_of_fee_this_year;
        } else {
            cancelCampaignManualPercent = i_agency_Percentage_of_fees_this_year;
        }

        system.debug('### after - initStages - projected : '+projected_stages);
        system.debug('### after - initStages - completed : '+completed_stages);

        s_selected_projected_stage = (String)sow_project_in_scope.get(CAMPIGN_PROJECTED_STAGE_CFY_FIELD_NAME);
        s_selected_completed_stage = (String)sow_project_in_scope.get(CAMPIGN_COMPLETED_STAGE_CFY_FIELD_NAME);
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
        if (pastFYProjectedValueSet.contains(projectedStage.name)) {
            projectedStage.disabled = true;
        }

        //PARAMETERS affecting selectability: b_is_projection_selectable, pastFYProjectedValueSet and b_manual_override_on
        //DEFAULT from projected_stages getter - true
        if (!b_is_projection_selectable || pastFYProjectedValueSet.contains(projectedStage.name) || b_manual_override_on || b_cancelled_campaign) {
            projectedStage.selectable = false;
        }

        //PARAMETERS affecting selected state: projectedValueSet, pastFYProjectedValueSet
        //DEFAULT from projected_stages getter - true
        //CRITERIA: Projected stage should NOT be selected if:
        //  a) it's not in the projectedValueSet
        //  b) it's not in the pastFYProjectedValueSet
        if (!projectedValueSet.contains(projectedStage.name) && !pastFYProjectedValueSet.contains(projectedStage.name)) {
            projectedStage.selected = false;
        }

        //Update projected stage completion for this FYI
        if (!projectedStage.disabled && projectedStage.selected) {
            i_percentage_of_fee_this_year += projectedStage.percentValue;
        }
    }



    /*******************************************************************************
    * @author       Ivan Ribakov
    * @date         2016-03-30
    * @description  helper method to initialise stage wrapper objects
    ********************************************************************************/
    private void initCompletedStages(Stage completedStage, 
                                     Set<String> projectedValueSet,
                                     Set<String> completedValueSet, 
                                     Set<String> pastFYProjectedValueSet, 
                                     Set<String> pastFYCompletedValueSet) {
        //Completed INIT
        //if (pastFYProjectedValueSet.contains(completedStage.name) || !projectedValueSet.contains(completedStage.name)) {
        if (pastFYCompletedValueSet.contains(completedStage.name) || (!projectedValueSet.contains(completedStage.name) && !pastFYProjectedValueSet.contains(completedStage.name)) ) {
            completedStage.disabled = true;
        }

        //PARAMETERS affecting selectability: b_is_completion_selectable, projectedValueSet and pastFYProjectedValueSet
        //DEFAULT from completed_stages getter - true
        //if (!b_is_completion_selectable || !projectedValueSet.contains(completedStage.name) || pastFYProjectedValueSet.contains(completedStage.name) || b_cancelled_campaign) {
        if (!b_is_completion_selectable || (!projectedValueSet.contains(completedStage.name) && !pastFYProjectedValueSet.contains(completedStage.name)) || pastFYCompletedValueSet.contains(completedStage.name) || b_cancelled_campaign) {
            completedStage.selectable = false;
        }

        //PARAMETERS affecting selected state: completedValueSet and pastFYCompletedValueSet
        //DEFAULT from projected_stages getter - false
        if (completedValueSet.contains(completedStage.name) || pastFYCompletedValueSet.contains(completedStage.name)) {
            completedStage.selected = true;
        }

        if (completedStage.selectable && completedStage.selected) {
            i_agency_Percentage_of_fees_this_year += completedStage.percentValue;
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
            if (!b_manual_override_on) {
                i_percentage_of_fee_this_year -= projected_stage_wrapper.percentValue;
            }
            projected_stage_wrapper.selected = false;
            currentValueSet.remove(val);
            
            if (completed_stage_wrapper.selected) {
                i_agency_Percentage_of_fees_this_year -= completed_stage_wrapper.percentValue;
            }
            completed_stage_wrapper.disabled = true;
            completed_stage_wrapper.selectable = false;
            completed_stage_wrapper.selected = false;
            currentCompletedValueSet.remove(val);
        } else {
            //Ticked
            if (!b_manual_override_on) {
                i_percentage_of_fee_this_year += projected_stage_wrapper.percentValue;
            }
            projected_stage_wrapper.selected = true;
            currentValueSet.add(val);

            completed_stage_wrapper.disabled = false;
            completed_stage_wrapper.selectable = true;
            completed_stage_wrapper.selected = false;
            currentCompletedValueSet.remove(val);
        }

        //if (!b_manual_override_on) {
        //    cancelCampaignManualPercent = i_agency_Percentage_of_fees_this_year;
        //}

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
            i_agency_Percentage_of_fees_this_year -= stage_wrapper.percentValue;
            currentValueSet.remove(val);
            stage_wrapper.selected = false;
        } else {
            i_agency_Percentage_of_fees_this_year += stage_wrapper.percentValue;
            currentValueSet.add(val);
            stage_wrapper.selected = true;
        }

        //if (!b_manual_override_on) {
        //    cancelCampaignManualPercent = i_agency_Percentage_of_fees_this_year;
        //}

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
        
        public Integer stageNumber {get;set;}
        public String name {get;set;}
        public Boolean isProjected {get;set;} //TRUE  if wrapper represents projected stage,
                                                       //FALSE if wrapper represents completed stage

        public Boolean disabled {
            get;
            set{
                disabled = value;
                calculateCSS();
            }
        }
        public Boolean selectable {
            get;
            set{
                selectable = value;
                calculateCSS();
            }
        }
        public Boolean selected {
            get;
            set{
                System.debug('### stage ' + name + ' selected: ' + value);
                selected = value;
                calculateCSS();
            }
        }

        public String cssClass {get;set;}
        public Integer percentValue {get;set;}

        public Stage(Boolean is_projected, Integer stage_number, String stage_name, Integer stage_percentage, Boolean is_selectable, boolean is_complete, boolean past_fy ){
            isProjected = is_projected;
            stageNumber = stage_number;
            name = stage_name;
            selectable = is_selectable;
            selected = is_complete;
            percentValue = stage_percentage;
            disabled = past_fy;
        }

        private void calculateCSS() {
            
            if (isProjected) { //CSS styles for projected chevrons
                if (disabled != null && selected != null && !disabled && selected) {
                    cssClass = CSS_PROJECTED_GREEN;
                } else {
                    cssClass = CSS_PROJECTED_GREY;
                }
            } else { //CSS styles for completed chevrons
                if (disabled != null && disabled) {
                    cssClass = CSS_COMPLETED_GREY;
                } else if (selected != null && !selected) {
                    cssClass = CSS_COMPLETED_YELLOW;
                } else if (selected != null && selected) {
                    cssClass = CSS_COMPLETED_GREEN;
                }
            }
        }
    }




}