/*******************************************************************
    Purpose: Wrapper class used to set colour for completed/outstanding 
                stages accordingly
    Parameters: Oblix_SOW_Projects__c with Completed_Stage__c and Projected_Stage__c populated
    Returns: an instance of StageIdentifier which contains css and boolean values for the 5 stages
    Throws [Exceptions]: none
********************************************************************/
public with sharing class Oblix_CampaignStageLogic{

    // final strings used for stage identifier CSS styling
    public static final String CSS_PROGRESS_NOT_STARTED = 'chevron_not_started';
    public static final String CSS_PROGRESS_STARTED = 'chevron_in_progress';
    public static final String CSS_PROGRESS_COMPLETED = 'chevron_completed';

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
                    projected_stages.put(i, new Stage(true, i, stagesByOrder.get(i).Label__c, true, true));
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
                    completed_stages.put(i, new Stage(false, i, stagesByOrder.get(i).Label__c, true, false));
                }
            }
        return completed_stages;

        }
        set;
    }
    
    
     public Oblix_CampaignStageLogic(Oblix_SOW_Projects__c sow_project, Integer percentageValue, boolean is_projection_selectable, boolean is_completeion_selectable){
        

        sow_project_in_scope = sow_project;

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

        String currentProjectedValue = (String)sow_project_in_scope.get('Stage_Projected_CFY__c');
        currentProjectedValue = (currentProjectedValue == null) ? '' : currentProjectedValue;
        List<String> currentProjectedValueList = currentProjectedValue.split(';');
        Set<String> currentProjectedValueSet = new Set<String>(currentProjectedValueList);

        String currentCompletedValue = (String)sow_project_in_scope.get('Stage_Completed_CFY__c');
        currentCompletedValue = (currentCompletedValue == null) ? '' : currentCompletedValue;
        List<String> currentCompletedValueList = currentCompletedValue.split(';');
        Set<String> currentCompletedValueSet = new Set<String>(currentCompletedValueList);

        for (Integer i : projected_stages.keySet()) {
            Stage projectedStage = projected_stages.get(i);
            Stage completedStage = completed_stages.get(i);

            //Projected INIT
            //override projected stage selectability if "b_is_projection_selectable" flag is FALSE
            if (!b_is_projection_selectable) {
                projectedStage.b_is_stage_selectable = false;
            } else {
                //TODO: Rollover changes - consider PFY projected stages in order to disable some in CFY
            }
            if (currentProjectedValueSet.contains(projectedStage.s_stage_name)) {
                projectedStage.b_is_stage_selected = true;
                completedStage.b_is_stage_selectable = true; //If stage is projected - ensure that completed stage is "active"
            } else {
                projectedStage.b_is_stage_selected = false;
            }


            //Completed INIT
            //override completed stage selectability if "b_is_completion_selectable" flag is FALSE
            if (!b_is_completion_selectable) {
                completedStage.b_is_stage_selectable = false;
            }
            if (currentCompletedValueSet.contains(completedStage.s_stage_name)) {
                completedStage.b_is_stage_selected = true;
            } else {
                completedStage.b_is_stage_selected = false;
            }            
        }

        s_selected_projected_stage = currentProjectedValue;
        s_selected_completed_stage = currentCompletedValue;
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

        String currentValue = (String)sow_project_in_scope.get('Stage_Projected_CFY__c');
        currentValue = (currentValue == null) ? '' : currentValue;
        List<String> currentValueList = currentValue.split(';');
        Set<String> currentValueSet = new Set<String>(currentValueList);

        String currentCompletedValue = (String)sow_project_in_scope.get('Stage_Completed_CFY__c');
        currentCompletedValue = (currentCompletedValue == null) ? '' : currentCompletedValue;
        List<String> currentCompletedValueList = currentCompletedValue.split(';');
        Set<String> currentCompletedValueSet = new Set<String>(currentCompletedValueList);

        Integer stage_number = Integer.valueOf(stagesByLabel.get(val).Attribute_1__c);
        Stage projected_stage_wrapper = projected_stages.get(stage_number);
        Stage completed_stage_wrapper = completed_stages.get(stage_number);

        if (currentValueSet.contains(val)) {
            currentValueSet.remove(val);
            currentCompletedValueSet.remove(val);
            projected_stage_wrapper.b_is_stage_selected = false;

            completed_stage_wrapper.b_is_stage_selectable = false;
            completed_stage_wrapper.b_is_stage_selected = false;
        } else {
            currentValueSet.add(val);
            projected_stage_wrapper.b_is_stage_selected = true;

            completed_stage_wrapper.b_is_stage_selectable = true;
            completed_stage_wrapper.b_is_stage_selected = false;
        }

        calculateFeesForThisYear();

        // set percentage projection and completion
        sow_project_in_scope.Agency_Percentage_of_Fees_to_this_FY__c = i_agency_Percentage_of_fees_this_year;
        sow_project_in_scope.Percentage_of_Fee_for_this_FY__c = i_percentage_of_fee_this_year;

        //setStageAttributes(false,true);

        String newValue = String.join(new List<String>(currentValueSet), ';');
        sow_project_in_scope.put('Stage_Projected_CFY__c', newValue);

        String newCompletedValue = String.join(new List<String>(currentCompletedValueSet), ';');
        sow_project_in_scope.put('Stage_Completed_CFY__c', newValue);

        s_selected_projected_stage = newValue;
        s_selected_completed_stage = currentCompletedValue;
    }



    /*******************************************************************************
    * @author       Ivan Ribakov
    * @date         2016-03-30
    ********************************************************************************/
    public void toggleCompletionStage(String val){

        String currentValue = (String)sow_project_in_scope.get('Stage_Completed_CFY__c');
        currentValue = (currentValue == null) ? '' : currentValue;
        List<String> currentValueList = currentValue.split(';');
        Set<String> currentValueSet = new Set<String>(currentValueList);

        Integer stage_number = Integer.valueOf(stagesByLabel.get(val).Attribute_1__c);
        Stage stage_wrapper = completed_stages.get(stage_number);

        if (currentValueSet.contains(val)) {
            currentValueSet.remove(val);
            stage_wrapper.b_is_stage_selected = false;
        } else {
            currentValueSet.add(val);
            stage_wrapper.b_is_stage_selected = true;
        }

        calculateFeesForThisYear();

        // set percentage projection and completion
        sow_project_in_scope.Agency_Percentage_of_Fees_to_this_FY__c = i_agency_Percentage_of_fees_this_year;
        sow_project_in_scope.Percentage_of_Fee_for_this_FY__c = i_percentage_of_fee_this_year;

        //setStageAttributes(false,true);

        String newValue = String.join(new List<String>(currentValueSet), ';');
        sow_project_in_scope.put('Stage_Completed_CFY__c', newValue);

        s_selected_completed_stage = newValue;
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
        
        //public Integer i_stage_percentage {get;set;}

        public Stage(Boolean is_projected, Integer stage_number, String stage_name, Boolean is_selectable, boolean is_complete ){
            b_is_stage_projected = is_projected;
            i_stage_number = stage_number;
            s_stage_name = stage_name;
            b_is_stage_selectable = is_selectable;
            b_is_stage_selected = is_complete;
            //i_stage_percentage = stage_percentage;

        }

        private void calculateCSS() {
            
            if (b_is_stage_projected) { //CSS styles for projected chevrons
                //TODO
            } else { //CSS styles for completed chevrons
                if (!b_is_stage_selectable) {
                    s_css_class_name = CSS_PROGRESS_NOT_STARTED;
                } else if (b_is_stage_selectable && !b_is_stage_selected) {
                    s_css_class_name = CSS_PROGRESS_STARTED;
                } else if (b_is_stage_selectable && b_is_stage_selected) {
                    s_css_class_name = CSS_PROGRESS_COMPLETED;
                }
            }
        }
    }




}