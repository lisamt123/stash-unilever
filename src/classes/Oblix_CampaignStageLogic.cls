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

    // final strings used for stage identifier
    public static final String STAGE_PROJECT_BRIEFING = 'Briefing';
    public static final String STAGE_PROJECT_STRATEGY = 'Strategy & Planning';
    public static final String STAGE_PROJECT_IDEATIOIN = 'Creative Ideation';
    public static final String STAGE_PROJECT_EXECUTION = 'Creative Execution';
    public static final String STAGE_PROJECT_PRODUCTION = 'Production';


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  static map to hold relationship between stage number and stage name
    ********************************************************************************/
    public static Map<Integer, String> mis_stages_number_name {
        get{
            if (NULL == mis_stages_number_name)
                mis_stages_number_name = new Map<Integer, String>{0=>STAGE_PROJECT_BRIEFING, 1=>STAGE_PROJECT_STRATEGY, 2=> STAGE_PROJECT_IDEATIOIN, 3=>STAGE_PROJECT_EXECUTION, 4=>STAGE_PROJECT_PRODUCTION };
            
            return mis_stages_number_name;
        }
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  static map to hold relationship between stage name and stage number
    ********************************************************************************/
    public static Map<String, Integer> mis_stages_name_number {
        get{
            if (NULL == mis_stages_name_number)
                mis_stages_name_number = new Map<String, Integer>{STAGE_PROJECT_BRIEFING=>0, STAGE_PROJECT_STRATEGY=>1, STAGE_PROJECT_IDEATIOIN=>2, STAGE_PROJECT_EXECUTION=>3, STAGE_PROJECT_PRODUCTION=>4 };

            return mis_stages_name_number;
        }
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  static map to hold relationship between stage number and stage percentage
    ********************************************************************************/
    public static Map<Integer, Integer> mii_stage_percentage {
        get{
            if (NULL == mii_stage_percentage)
                mii_stage_percentage = new Map<Integer, Integer>{0=>10, 1=>20, 2=>30, 3=>25, 4=>15};

            return mii_stage_percentage;
        }
    }
    

    public Integer i_percentage_of_fee_this_year {get;set;}
    public Integer i_agency_Percentage_of_fees_this_year {get;set;}
    public Boolean b_is_projection_selectable {get;set;}
    public Boolean b_is_completion_selectable {get;set;}
    //public List<Boolean> lib_is_stage_projected {get;set;}
    //public List<Boolean> lib_is_stage_completed {get;set;}
    
    public Oblix_SOW_Projects__c sow_project_in_scope {get;set;}

    public String s_selected_projected_stage{get; private set;}
    public String s_selected_completed_stage{get; private set;}
    public Integer i_fees_for_this_financial_year {get; private set;}


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  instance list to hold projected stages containing stage object
    ********************************************************************************/
    public List<Stage> li_projected_stages {
        get{
            if (null==li_projected_stages){
                li_projected_stages = new List<Stage>();
                Integer stage_number = 0;

                for (String stage: Oblix_Utils.getStageList()){
                    li_projected_stages.add(new Stage(false, stage, stage_number, false));
                    stage_number ++;
                }
            }
        return li_projected_stages;

        }
        set;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  instance list to hold projected stages containing stage object
    ********************************************************************************/
    public List<StageCSS> lis_stage_css_class {
        get{
            if (null==lis_stage_css_class){
                lis_stage_css_class = new List<StageCSS>();
                Integer stage_number = 0;

                for (String stage: Oblix_Utils.getStageList()){
                    lis_stage_css_class.add(new StageCSS(stage_number,CSS_PROGRESS_NOT_STARTED));
                    stage_number ++;
                }
            }
        return lis_stage_css_class;

        }
        set;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  instance list to hold completed stages containing stage object
    ********************************************************************************/
    public List<Stage> li_completed_stages {
        get{
            if (null==li_completed_stages){
                li_completed_stages = new List<Stage>();
                Integer stage_number = 0;

                for (String stage: Oblix_Utils.getStageList()){
                    li_completed_stages.add(new Stage(false, stage,stage_number, true));
                    stage_number ++;
                }
            }
        return li_completed_stages;

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
        sow_project_in_scope.Projected_Stage__c = STAGE_PROJECT_PRODUCTION;
        //sow_project_in_scope.Completed_Stage__c = STAGE_PROJECT_BRIEFING;
        sow_project_in_scope.Campaign_Total_Adjustment__c = 0;
        sow_project_in_scope.Percentage_of_Fee_for_this_FY__c = 100;
        
        setStageAndCSS(sow_project_in_scope.Projected_Stage__c, sow_project_in_scope.Completed_Stage__c,true,true);
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
    public Oblix_CampaignStageLogic(Oblix_SOW_Projects__c sow_project, boolean is_projection_selectable, boolean is_completeion_selectable){

        b_is_projection_selectable = is_projection_selectable;
        b_is_completion_selectable = is_completeion_selectable;

        sow_project_in_scope = sow_project;
        setStageAndCSS(sow_project.Projected_Stage__c, sow_project.Completed_Stage__c,true,true);
        calculateFeesForThisYear();

    }

    private Integer getStageLevel(String stage_name){

        if (NULL!=mis_stages_name_number && mis_stages_name_number.containsKey(stage_name))
            return mis_stages_name_number.get(stage_name);
        else
            return -1;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  for the given projected and completion stages set the correct
                    CSS class, selected and selectable checkboxes
    ********************************************************************************/
    private void setStageAndCSS(String projected_stage, String completion_stage, Boolean set_projected, Boolean set_completion ){
        
        // get the stage number for completion and projection stages
        Integer i_projection_level = getStageLevel(projected_stage);

        Integer i_completion_level =  getStageLevel(completion_stage);

        system.debug('##1 i_projection_level:  ' + i_projection_level + ' ## i_completion_level:  ' + i_completion_level + ' - projected_stage: ' + projected_stage + ' - completion_stage: ' + completion_stage) ;

        Boolean force_recalculate_completion = false;
        //if the projected is set lower than completion need to recalculate
        if (i_projection_level < i_completion_level){
            i_completion_level = i_projection_level;
            force_recalculate_completion = true;
        }

        system.debug('##2 i_projection_level:  ' + i_projection_level + ' ## i_completion_level:  ' + i_completion_level + ' force_recalculate_completion: ' + force_recalculate_completion) ;

        // set the percentage of fee for this year to zero and calculate in the correct value in the loop below
        i_percentage_of_fee_this_year = set_projected 
            ? 0
            : i_percentage_of_fee_this_year;

        i_agency_Percentage_of_fees_this_year = set_completion || force_recalculate_completion
            ? 0
            : i_agency_Percentage_of_fees_this_year;

        for (Integer i=0; i < 5; i++){


            // if set projected TRUE is passed in, set the values
            if (set_projected){
                setProjectedAttributes(i, i_projection_level);
            }
            
            // if set completion TRUE is passed in, set the values also if the projected is set lower than completion re-calculate
            if (set_completion ||  force_recalculate_completion){
                setCompletionAttributes(i,i_completion_level);
            }

            setCompletionCSS(i, i_projection_level, i_completion_level);

            // also set projection seletable value by checking b_is_projection_selectable
            li_projected_stages[i].b_is_stage_selectable = b_is_projection_selectable;

            // also set completion selectable value by checkig b_is_completion_selectable
            li_completed_stages[i].b_is_stage_selectable = b_is_completion_selectable && li_projected_stages[i].b_is_stage_selected
                ? true
                : false;
            //li_completed_stages[i].b_is_stage_selectable = false;

        }
        if(sow_project_in_scope.Value_To_BePaid_Manual_Override__c){
                i_percentage_of_fee_this_year = Integer.valueOf(sow_project_in_scope.Percentage_of_Fee_for_this_FY__c);
                i_fees_for_this_financial_year = Integer.valueOf(sow_project_in_scope.Value_to_be_paid_in_Current_FY__c);
                system.debug('###i_fees_for_this_financial_year : '+i_fees_for_this_financial_year);
        }

        s_selected_projected_stage = mis_stages_number_name.get(i_projection_level);// sow_project_in_scope.Projected_Stage__c;
        s_selected_completed_stage = mis_stages_number_name.get(i_completion_level); //sow_project_in_scope.Completed_Stage__c;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  depending on the percentage of fee this year and total fees to be paid
    ********************************************************************************/
    private void calculateFeesForThisYear(){
        system.debug('###is i_percentage_of_fee_this_year : '+i_percentage_of_fee_this_year);
        system.debug('###is sow_project_in_scope.Campaign_Total_Fees__c : '+sow_project_in_scope.Campaign_Total_Fees__c);
        
        if (NULL != i_percentage_of_fee_this_year && NULL != sow_project_in_scope.Campaign_Total_Fees__c && i_percentage_of_fee_this_year == 100 ){
            i_fees_for_this_financial_year = Integer.valueOf(sow_project_in_scope.Campaign_Total_Fees__c);
        }
        else if (NULL != i_percentage_of_fee_this_year && NULL != sow_project_in_scope.Campaign_Total_Fees__c ){
            i_fees_for_this_financial_year = Integer.valueOf((i_percentage_of_fee_this_year * sow_project_in_scope.Campaign_Total_Fees__c / 100).round(System.RoundingMode.Up));
        }
        else{
            i_fees_for_this_financial_year = 0;
        }
        system.debug('###i_fees_for_this_financial_year : '+i_fees_for_this_financial_year);
    }
    
    /********************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-08
    * @description  Depending on the item index set completion CSS and completed
                    stages
    *********************************************************************/
    private void setCompletionAttributes(Integer index_to_check, Integer i_completion_level){
           
        // set completion css and boolean
        if (index_to_check <= i_completion_level){
            li_completed_stages[index_to_check].b_is_stage_selected = true;
            i_agency_Percentage_of_fees_this_year += mii_stage_percentage.get(index_to_check);
        }
        else{   
            li_completed_stages[index_to_check].b_is_stage_selected = false;
        } 

        // resetting the values if -1 is passed in
        if (-1 == i_completion_level){
            li_completed_stages[index_to_check].b_is_stage_selected = false;
        }


    }


    
    /********************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-08
    * @description  Depending on the item index set projected CSS and projected
                    stages
    *********************************************************************/
    private void setProjectedAttributes(Integer index_to_check, Integer i_projection_level){

        // set projected css and boolean
        if (index_to_check <= i_projection_level){
            li_projected_stages[index_to_check].b_is_stage_selected = true;
            //li_completed_stages[index_to_check].b_is_stage_selectable = true;
            i_percentage_of_fee_this_year += mii_stage_percentage.get(index_to_check);
 
        }
        else{
            li_projected_stages[index_to_check].b_is_stage_selected = false;
        }
    }
    
    /********************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-08
    * @description  Set CSS based on Projection and Completion stages
    *********************************************************************/
    private void setCompletionCSS(Integer index_to_check, Integer i_projection_level, Integer i_completion_level){

        // set projected css and boolean
        if (index_to_check <= i_completion_level){
            lis_stage_css_class[index_to_check].s_css_class_name = CSS_PROGRESS_COMPLETED;
        }
        else if (index_to_check <= i_projection_level){
            lis_stage_css_class[index_to_check].s_css_class_name = CSS_PROGRESS_STARTED;   
        }
        else{
            lis_stage_css_class[index_to_check] = new StageCSS(index_to_check,CSS_PROGRESS_NOT_STARTED);        
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

    public void setStageAttributes(Boolean set_projected, Boolean set_completion ){

        // ensure that the i_completion_level is never greater than i_projection_level !
        // if it is set the to the highest projection level
        //sow_project_in_scope.Completed_Stage__c = mis_stages_name_number.get(sow_project_in_scope.Completed_Stage__c) > mis_stages_name_number.get(sow_project_in_scope.Projected_Stage__c)
        //    ? sow_project_in_scope.Projected_Stage__c
        //    : sow_project_in_scope.Completed_Stage__c;

        system.debug('## sow_project_in_scope.Projected_Stage__c: ' + sow_project_in_scope.Projected_Stage__c + ' - sow_project_in_scope.Completed_Stage__c: ' + sow_project_in_scope.Completed_Stage__c);

        // workout the stage by the attributes
        setStageAndCSS(s_selected_projected_stage, s_selected_completed_stage, set_projected,set_completion);
        calculateFeesForThisYear();

        // set percentage projection and completion
        sow_project_in_scope.Agency_Percentage_of_Fees_to_this_FY__c = i_agency_Percentage_of_fees_this_year;
        sow_project_in_scope.Percentage_of_Fee_for_this_FY__c = i_percentage_of_fee_this_year;


        system.debug('## saved stage: ' + sow_project_in_scope);
    }
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  The logic to work out the correct checkboxes depending on the
                    user selection and the prior value of the checkbox
    ********************************************************************************/
    private String getStageNameByValues(String new_val, String old_val){
        // 1) the current stage name is the same as the one being set, means the user unchecking the stage
        //      this means the stage prior to the one user clicked on needs to be passed back
        // 2) the current stage number is greater than the one the user selected
        //      this means the stage prior to the one user clicked on needs to be passed back

        if (new_val == old_val && mis_stages_name_number.get(old_val) == 0){
            return null;
        }
        else if (mis_stages_name_number.get(old_val) > mis_stages_name_number.get(new_val) || (new_val == old_val)){
            // get the stage prior to the one clicked on
            return mis_stages_number_name.get(mis_stages_name_number.get(new_val)-1);
        }
        else{
            return new_val;
        }
    }
    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  depending on prior stage status and the new selection, need to 
                    select the correct set of stage numbers in the sequence or 
                    deselect the stages if not in the correct sequence
    ********************************************************************************/
    public void setCompletionStage(String new_val, String old_val){

        s_selected_completed_stage = getStageNameByValues(new_val, old_val);
        system.debug('## sow_project_in_scope.Completed_Stage__c: ' + sow_project_in_scope.Completed_Stage__c + ' - new_val: ' + new_val + ' - old_val: ' + old_val);
        setStageAttributes(false,true);
        sow_project_in_scope.Completed_Stage__c = s_selected_completed_stage;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  depending on prior stage status and the new selection, need to 
                    select the correct set of stage numbers in the sequence or 
                    deselect the stages if not in the correct sequence
    ********************************************************************************/
    public void setProjectedStage(String new_val, String old_val){
        sow_project_in_scope.Value_To_BePaid_Manual_Override__c = false;
        s_selected_projected_stage = getStageNameByValues(new_val, old_val);
        system.debug('## sow_project_in_scope.Projected_Stage__c: ' + sow_project_in_scope.Projected_Stage__c + ' - new_val: ' + new_val + ' - old_val: ' + old_val);
        setStageAttributes(true,false);
        sow_project_in_scope.Projected_Stage__c = s_selected_projected_stage;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  wrapper class to hold the stage attributes
    ********************************************************************************/
    public class Stage{
        public boolean b_is_stage_selected {get;set;}
        public String s_stage_name {get;set;}
        public Integer i_stage_number {get;set;}
        public boolean b_is_stage_selectable {get;set;}
        //public Integer i_stage_percentage {get;set;}

        public Stage(boolean is_complete, String stage_name, Integer stage_number, Boolean is_selectable ){
            b_is_stage_selected = is_complete;
            s_stage_name = stage_name;
            i_stage_number = stage_number;
            b_is_stage_selectable = is_selectable;
            //i_stage_percentage = stage_percentage;

        }
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-09
    * @description  wrapper class to hold the stage CSS number and class name
    ********************************************************************************/
    public class StageCSS{
        public Integer i_stage_number {get;set;}
        public String s_css_class_name {get;set;}

        public StageCSS(Integer stage_number, String css_class){
            i_stage_number = stage_number;
            s_css_class_name = css_class;
        }
    }
}