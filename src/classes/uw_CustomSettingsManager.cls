public without sharing class uw_CustomSettingsManager {

    // TODO- remove once we have real values
    public static String TEST_VALUE = 'DEFAULT_THINK_BIG_PACK_ID';
    public static String REDIRECT_NEW_BET_TO_STUDIO_TIME_MINS = 'REDIRECT_NEW_BET_TO_STUDIO_TIME_MINS';
    public static String DEFAULT_THINK_BIG_PACK_ID = 'DEFAULT_THINK_BIG_PACK_ID';
    public static String CHATTER_GROUP_BRAND_IMG   = 'CHATTER_GROUP_BRAND_IMG';
    public static String CHATTER_GROUP_STUDIO_IMG  = 'CHATTER_GROUP_STUDIO_IMG';
    public static String CHATTER_GROUP_TOOLKIT_IMG = 'CHATTER_GROUP_TOOLKIT_IMG';
    public static String ALL_UNILEVER_PUBLIC_GROUP = 'ALL_UNILEVER_PUBLIC_GROUP';
    public static String DEFAULT_BANNER_LOCATION = 'DEFAULT_BANNER_LOCATION';
    public static String SEND_INVITE_BATCH_JOB_ID = 'SEND_INVITE_BATCH_JOB_ID';
    /* start new code (Wojtek 2014.12.11) */
    public static String BET_DISABLE_BRAND_CATEGORY_CHECK = 'BET_DISABLE_BRAND_CATEGORY_CHECK';
    /* end new code (Wojtek 2014.12.11) */
    /* start new code (Wojtek 2015.01.30) */
    public static String BET_TEMPALTE_DOWNLOAD_URL = 'BET_TEMPALTE_DOWNLOAD_URL';
    public static String BET_HELP_URL = 'BET_HELP_URL';
    public static String BET_DISABLE_LOG_CHANGE_TRIGGER = 'BET_DISABLE_LOG_CHANGE_TRIGGER';
    /* end new code (Wojtek 2015.01.30) */
    
    public static Map<String,uw_Custom_Setting__c> getAllCustomSettings()
    {
        return uw_Custom_Setting__c.getAll();
    }
    
    public static Boolean getCustomSettingBooleanVal(String settingName)
    {
        return uw_CustomSettingsManager.getCustomSetting(settingName).Checkbox_Value__c;
    }
    
    /* start new code (Wojtek 2014.12.11) */
    public static Boolean getCustomSettingBooleanVal(String settingName, Boolean defaultValue)
    {
        uw_Custom_Setting__c customSetting = uw_CustomSettingsManager.getCustomSetting(settingName);
        if (customSetting == null) {
            return defaultValue;
        } else {
            return customSetting.Checkbox_Value__c;
        }
    }
    /* end code (Wojtek 2014.12.11) */

    /* start new code (Wojtek 2015.01.30) */
    public static String getCustomSettingStringVal(String settingName, String defaultValue)
    {
        uw_Custom_Setting__c customSetting = uw_CustomSettingsManager.getCustomSetting(settingName);
        if (customSetting == null) {
            return defaultValue;
        } else {
            return customSetting.Text_Value__c;
        }
    }
    /* end new code (Wojtek 2015.01.30) */
    
    public static String getCustomSettingStringVal(String settingName)
    {
        return uw_CustomSettingsManager.getCustomSetting(settingName).Text_Value__c;
    }
    
    public static Decimal getCustomSettingNumberVal(String settingName)
    {
        return uw_CustomSettingsManager.getCustomSetting(settingName).Number_Value__c;
    }
    
    public static Integer getCustomSettingIntegerVal(String settingName)
    {
    	Decimal d = uw_CustomSettingsManager.getCustomSetting(settingName).Number_Value__c;
    	Integer intVal = Integer.valueOf(d);
        return intVal;
    }
    
    public static uw_Custom_Setting__c getCustomSetting(String settingName)
    {
       	return uw_Custom_Setting__c.getAll().get(settingName);
    }

    @IsTest(SeeAllData=true)
    public static void testCustomSettingsManager()
    {
        uw_CustomSettingsManager.getAllCustomSettings();
        uw_CustomSettingsManager.getCustomSettingBooleanVal(uw_CustomSettingsManager.TEST_VALUE);
        uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.TEST_VALUE);
        uw_CustomSettingsManager.getCustomSetting(uw_CustomSettingsManager.TEST_VALUE);
        uw_CustomSettingsManager.getCustomSettingNumberVal(uw_CustomSettingsManager.TEST_VALUE);
        uw_CustomSettingsManager.getCustomSettingIntegerVal(uw_CustomSettingsManager.TEST_VALUE);
        
        List<String> requiredSettings = new List<String>();

        // requiredSettings.add(uw_CustomSettingsManager.TEST_VALUE);
        requiredSettings.add(uw_CustomSettingsManager.REDIRECT_NEW_BET_TO_STUDIO_TIME_MINS);
        requiredSettings.add(DEFAULT_THINK_BIG_PACK_ID);
        requiredSettings.add(CHATTER_GROUP_TOOLKIT_IMG);
        requiredSettings.add(CHATTER_GROUP_STUDIO_IMG);
        requiredSettings.add(CHATTER_GROUP_BRAND_IMG);
        requiredSettings.add(ALL_UNILEVER_PUBLIC_GROUP);
        requiredSettings.add(DEFAULT_BANNER_LOCATION);
        requiredSettings.add(SEND_INVITE_BATCH_JOB_ID);
        
        for (String setting: requiredSettings)
        {
            try{
                System.assert(null != uw_CustomSettingsManager.getCustomSetting(setting), 'Cannot Find Custom Setting '+setting);
            } catch (Exception e)
            {
                System.assert(false,'Exception thrown: Cannot Find Custom Setting '+setting);
            }
        }
    }
}