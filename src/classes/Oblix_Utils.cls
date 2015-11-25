/**
    About
    -----
    Description: Class Utils
    Created for: Unilever Project
    Create date: 09/ 2015
    Created by Jamal Rida
    Author : @Jamal
    Details
    -------
    This class is  : used as a global class which contains all Global Methods
                         for better maintenance

    Update History
    --------------
*/
public with sharing class Oblix_Utils {

    private static final String PROJECT_BRIEFFING = Label.Oblix_Lbl_UIUX_Utils_Projected_Briefing;
    private static final String COMPLETED_BRIEFFING = Label.Oblix_Lbl_UIUX_Utils_Completed_Briefing;
    private static final String PROJECT_ASSET_NAME = 'Oblix_Project_Assets__c';
    private static final String DIGITAL = 'digital';
    private static final String AUDIO_VISUAL = 'Audio_Visual';
    private static final String EXPERIENTIAL = 'Experiential';
    private static final String STATIC_IMAGERY = 'Static_Imagery';
//Used to Wrap RecordType By Object
    public static Map<string, ID> MapRecordType(String ObjectName) {

        List<RecordType> lstRecordType = new List<RecordType>();

        lstRecordType = [Select ID, SobjectType, Name, DeveloperName from RecordType where SobjectType = :ObjectName and DeveloperName != 'Admin'];

        Map<String, ID> MapRTCaseToDeveloperName = new Map<String, ID>();

        for (RecordType rec : lstRecordType) {
            MapRTCaseToDeveloperName.put(rec.DeveloperName, rec.ID);
        }

        return MapRTCaseToDeveloperName;

    }
    public static list<string> getlstSubCat() {

        list<string> lst = new list<string>();

        lst.add(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Audio_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory);
        lst.add(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory);

        return lst;

    }
    public static list<string> lstSubCatPerRecT(string recType) {

        list<string> lst = new list<string>();
        if (recType == Label.Oblix_Lbl_UIUX_AudioVisuel) {
            lst.add(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Audio_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory);

        }
        if (recType == Label.Oblix_Lbl_UIUX_Digital) {
            lst.add(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory);

        }
        if (recType == Label.Oblix_Lbl_UIUX_Experiential) {
            lst.add(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory);

        }
        if (recType == Label.Oblix_Lbl_UIUX_Static_Img) {
            lst.add(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory);
            lst.add(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory);

        }
        if (recType == Label.Oblix_Lbl_UIUX_Stimulus_Materials) {
            lst.add(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory);
        }

        return lst;
    }

    public static list<string> getStageList() {

        list<string> lstStage = new list<string>();
        Schema.DescribeFieldResult lstProjectStage = Oblix_SOW_Projects__c.Project_Stage__c.getDescribe();
        List<Schema.PicklistEntry> lstStageValues = lstProjectStage.getPicklistValues();
        for (Schema.PicklistEntry a : lstStageValues) {
            lstStage.add(a.getLabel());
        }
        return lstStage;
    }
    public static map<string, list<string>> getMapSubCategOption() {
        map<string, list<string>> mapSubCategOption = new map<string, list<string>>();
        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory).add('1');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory).add('4');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory).add('5');

        mapSubCategOption.put(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory, new list<string>());
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory).add('2');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory).add('3');
        mapSubCategOption.get(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory).add('4');

        return mapSubCategOption;
    }

    public static map<string, string> getmapSubCategOptionDescription() {

        map<string, string> mapSubCategOptionDescription = new map<string, string>();

        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory + 2, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory + 3, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory + 4, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory + 5, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory + 1, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory + 2, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory + 3, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory + 4, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory + 5, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory + 1, Label.Oblix_Lbl_UIUX_Audio_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory + 2, Label.Oblix_Lbl_UIUX_Audio_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory + 3, Label.Oblix_Lbl_UIUX_Audio_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory + 4, Label.Oblix_Lbl_UIUX_Audio_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory + 5, Label.Oblix_Lbl_UIUX_Audio_Score5);

        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory + 1, Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory + 2, Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory + 3, Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory + 4, Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory + 5, Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory + 2, Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory + 3, Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory + 4, Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory + 5, Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory + 1, Label.Oblix_Lbl_UIUX_Digital_campaign_assets_score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory + 2, Label.Oblix_Lbl_UIUX_Digital_campaign_assets_score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory + 3, Label.Oblix_Lbl_UIUX_Digital_campaign_assets_score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory + 4, Label.Oblix_Lbl_UIUX_Digital_campaign_assets_score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory + 5, Label.Oblix_Lbl_UIUX_Digital_campaign_assets_score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory + 1, Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory + 2, Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory + 3, Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory + 4, Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory + 5, Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory + 1, Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory + 2, Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory + 3, Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory + 4, Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory + 5, Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Score5);

        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory + 1, Label.Oblix_Lbl_UIUX_Specialist_Digital_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory + 2, Label.Oblix_Lbl_UIUX_Specialist_Digital_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory + 3, Label.Oblix_Lbl_UIUX_Specialist_Digital_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory + 4, Label.Oblix_Lbl_UIUX_Specialist_Digital_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory + 5, Label.Oblix_Lbl_UIUX_Specialist_Digital_Score5);

        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory + 1, Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory + 2, Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory + 3, Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory + 4, Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory + 5, Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory + 3, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory + 4, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory + 5, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory + 1, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory + 2, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory + 3, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory + 4, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory + 5, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory + 3, Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory + 4, Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory + 5, Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Score5);


        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory + 1, Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Score1);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory + 2, Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory + 3, Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory + 4, Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Score4);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory + 5, Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Score5);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory + 2, Label.Oblix_Lbl_UIUX_Stim_require_Score2);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory + 3, Label.Oblix_Lbl_UIUX_Stim_require_Score3);
        mapSubCategOptionDescription.put(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory + 4, Label.Oblix_Lbl_UIUX_Stim_require_Score4);


        return mapSubCategOptionDescription;
    }

    public static map<string, string> getmapSubCategOptionDefinition() {

        map<string, string> mapSubCategOptionDefinition = new map<string, string>();

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory, Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory, Label.Oblix_Lbl_UIUX_Audio_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory, Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Definition);


        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory, Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory, Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory, Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory, Label.Oblix_Lbl_UIUX_Specialist_Digital_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory, Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory, Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory, Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Definition);


        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory, Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory, Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Definition);

        mapSubCategOptionDefinition.put(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory, Label.Oblix_Lbl_UIUX_Stim_require_Definition);

        return mapSubCategOptionDefinition;

    }

    private static string getProjectedITems(String projected) {
        string projcItems = '';
        if (projected == Label.Oblix_Lbl_UIUX_Projected_Briefing) {
            projcItems = PROJECT_BRIEFFING;
        } else if (projected == Label.Oblix_Lbl_UIUX_Projected_Strategy_Planning) {
            projcItems = PROJECT_BRIEFFING + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Strategy_Planning;
        } else if (projected == Label.Oblix_Lbl_UIUX_Projected_Creative_Ideation) {
            projcItems = PROJECT_BRIEFFING + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Strategy_Planning + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Creative_Ideation;
        } else if (projected == Label.Oblix_Lbl_UIUX_Projected_Creative_Execution) {
            projcItems = PROJECT_BRIEFFING + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Strategy_Planning + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Creative_Ideation
                         + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Creative_Execution;
        } else if (projected == Label.Oblix_Lbl_UIUX_Projected_Production) {
            projcItems = PROJECT_BRIEFFING + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Strategy_Planning + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Creative_Ideation
                         + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Creative_Execution + ',' + Label.Oblix_Lbl_UIUX_Utils_Projected_Production;
        }
        return projcItems;
    }

    private static String getCompletedItems(String completed) {
        string completItems = '';
        if (Completed == Label.Oblix_Lbl_UIUX_Completed_Briefing) {
            completItems = COMPLETED_BRIEFFING ;
        } else if (Completed == Label.Oblix_Lbl_UIUX_Completed_Strategy_Planning) {
            completItems = COMPLETED_BRIEFFING + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Strategy_Planning;
        } else if (Completed == Label.Oblix_Lbl_UIUX_Completed_Creative_Ideation) {
            completItems = COMPLETED_BRIEFFING + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Strategy_Planning + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Creative_Ideation;
        } else if (Completed == Label.Oblix_Lbl_UIUX_Completed_Creative_Execution) {
            completItems = COMPLETED_BRIEFFING + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Strategy_Planning + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Creative_Ideation
                           + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Creative_Execution;
        } else if (Completed == Label.Oblix_Lbl_UIUX_Completed_Production) {
            completItems = COMPLETED_BRIEFFING + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Strategy_Planning + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Creative_Ideation
                           + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Creative_Execution + ',' + Label.Oblix_Lbl_UIUX_Utils_Completed_Production;
        }
        return completItems;
    }

    public static string getSelectedStageCheckbox(string projected, string Completed) {
        string lstProjectedItems = '';
        string lstCompletedItems = '';

        lstProjectedItems = getProjectedITems(projected);
        lstCompletedItems = getCompletedItems(Completed);

        system.debug('###lst Stage :' + lstCompletedItems + ',' + lstProjectedItems);
        if (lstProjectedItems != '' && lstCompletedItems != '') {
            return (lstCompletedItems + ',' + lstProjectedItems) ;
        }
        if (lstProjectedItems == '') {
            return lstCompletedItems ;
        }
        if (lstCompletedItems == '') {
            return lstProjectedItems ;
        }
        return '';

    }


    public static map<string, string> getAbreViationForCardAssets() {

        map<string, string> mapAbreviation = new map<string, string>();

        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory, 'OF');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory, 'OL');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory, 'AU');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory, 'A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory, 'CD');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory, 'CA');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory, 'AR');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory, 'AO');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory, 'DA');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory, 'A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory, 'O');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory, 'A');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory, 'O');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory, 'R');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_AudioVisuel, 'AV');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Digital, 'D');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Experiential, 'E');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Static_Img, 'SI');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Stimulus_Materials, 'SM');

        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Activity, 'ACT');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Communication_Idea, 'BCI');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_USLP, 'USLP');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_equity_development, ' BED');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Leadership_Meetings, 'BLM');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Leadership_Workshops, 'BLW');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Technical_Infrastructure, 'BTI');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Key_Presentations, 'BKP');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Status_Reports, 'SR');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Global_Status_Meetings, 'GSM');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Regional_Status_Meetings, 'RSM');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Network_Co_ordination_other_agencies, 'NC');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Network_Competitive_Reviews, 'CR');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Led_Training, 'BLT');
        mapAbreviation.put(Label.Oblix_Lbl_UIUX_Utils_Brand_Book, 'BBK');


        return mapAbreviation;
    }

    public static map<string, string> getMapRecordTypeDescription() {
        map<string, string> mapRecordTypeDescription = new map<string, string>();
        mapRecordTypeDescription.put(Label.Oblix_Lbl_UIUX_AudioVisuel, ' - ' + Label.Oblix_Lbl_UIUX_AudioVisuel_Description);
        mapRecordTypeDescription.put(Label.Oblix_Lbl_UIUX_Digital, ' - ' + Label.Oblix_Lbl_UIUX_Digital_Description);
        mapRecordTypeDescription.put(Label.Oblix_Lbl_UIUX_Experiential, ' - ' + Label.Oblix_Lbl_UIUX_Experiential_Decription);
        mapRecordTypeDescription.put(Label.Oblix_Lbl_UIUX_Static_Img, ' - ' + Label.Oblix_Lbl_UIUX_Static_Img_Description);
        mapRecordTypeDescription.put(Label.Oblix_Lbl_UIUX_Stimulus_Materials, '');
        return mapRecordTypeDescription;
    }

    public static map<string, integer> getFeePercentages(list<string> lstStage) {
        map<string, integer> feePercentages = new map<string, integer>();
        feePercentages.put(lstStage[0], 10);
        feePercentages.put(lstStage[1], 20);
        feePercentages.put(lstStage[2], 30);
        feePercentages.put(lstStage[3], 25);
        feePercentages.put(lstStage[4], 15);
        return feePercentages;
    }
    //VF09 Non Campaign Items
    public static id CountrryGetId(String Cname) {
        List <MDO_Geography__c> temp = null;
        id x = null;

        temp = [select id from MDO_Geography__c where name = :Cname limit 1];
        system.debug('===========Cname' + Cname);
        system.debug('===========temp' + temp);


        if (temp == null) { return temp[0].id; }
        else { return null; }
    }

    public static set<String> CountriesByFYear(String fYear_loc) {
        List<Oblix_Calculator__c> lstCalculatorBoxNumber = [Select Name from Oblix_Calculator__c  where RecordTypeId = : Oblix_Utils.MapRecordType('Oblix_Calculator__c').get('Country_Box_Number') and Financial_Year__c = :fYear_loc];
        set<String> setCountries = new set<String>();
        if (!lstCalculatorBoxNumber.isEmpty()) {
            for (Oblix_Calculator__c calc : lstCalculatorBoxNumber) {
                setCountries.add(calc.Name);
            }
        }
        return setCountries;
    }
    public static map<string, string> getMapRTforSubCat() {

        map<string, string> mapRTforSubCat = new map<string, string>();
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_F_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(AUDIO_VISUAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_AudioVisual_ORIGINATION_L_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(AUDIO_VISUAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Audio_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(AUDIO_VISUAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Audio_Visual_Adaptation_nd_ReEdits_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(AUDIO_VISUAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Cut_downs_Tag_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(AUDIO_VISUAL));

        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Digital_campaign_assets_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(DIGITAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Digit_adapt_requir_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(DIGITAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Always_on_Social_Digit_requir_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(DIGITAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Data_Ana_Report_Dash_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(DIGITAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Specialist_Digital_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(DIGITAL));

        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ADAPT_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(EXPERIENTIAL));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Experiential_Prom_ideas_ORIGI_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(EXPERIENTIAL));

        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Stat_img_ADAPT_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(STATIC_IMAGERY));
        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Stat_img_ORIG_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get(STATIC_IMAGERY));

        mapRTforSubCat.put(Label.Oblix_Lbl_UIUX_Stim_require_Subcategory, Oblix_Utils.MapRecordType(PROJECT_ASSET_NAME).get('Stimulus_Materials_Research_requirements'));

        return mapRTforSubCat;
    }

    public static list<selectOption> selectOptionSortByLabel(list<selectOption> selectOptionsToSort) {
        if (selectOptionsToSort == null || selectOptionsToSort.size() <= 1) {
            return selectOptionsToSort;
        }
        List<SelectOption> lessSelectOption = new List<SelectOption>();
        List<SelectOption> greaterSelectOption = new List<SelectOption>();
        integer pivot = selectOptionsToSort.size() / 2;

        //save the pivot and remove it from the selectOption list
        SelectOption pivotValue = selectOptionsToSort[pivot];
        selectOptionsToSort.remove(pivot);
        for (selectOption SO : selectOptionsToSort) {
            if (SO.getLabel() <= pivotValue.getLabel()) {
                lessSelectOption.add(SO);
            } else if (SO.getLabel() > pivotValue.getLabel()) {
                greaterSelectOption.add(SO);
            }
        }
        list<selectOption> sortedSelectOptions = new list<selectOption>();
        sortedSelectOptions.addAll(selectOptionSortByLabel(lessSelectOption));
        sortedSelectOptions.add(pivotValue);
        sortedSelectOptions.addAll(selectOptionSortByLabel(greaterSelectOption));
        return SortedSelectOptions;
    }
    public static List<SelectOption> setFirstValue(String value, List<SelectOption> selectedList) {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', value));
        for (SelectOption option : selectedList) {
            options.add(option);
        }
        return options;
    }

    public class CustomException extends Exception {}

    public class AssetDetailWrapper {
        public String assetId;
        public Decimal quantity;
        public String additionalDescription;
        public Date actualDeliveryDate;
        public String assetName;
        public String location;
        
        public AssetDetailWrapper(Oblix_Project_Assets__c asset) {
            this.assetId = asset.Id;
            this.quantity = asset.Quantity__c;
            this.additionalDescription = asset.Additional_Description__c;
            this.actualDeliveryDate = asset.Actual_Delivery_Date__c;
            this.assetName = asset.Asset_Picklist__c;
            this.location =  asset.Location__c;
        }
    }
}