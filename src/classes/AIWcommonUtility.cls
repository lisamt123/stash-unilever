global with sharing class AIWcommonUtility 
{
    
    public static Map<String, List<String>> configSettingsMap 
        
    {
        get
        {
            if (configSettingsMap == null || configSettingsMap.size() ==0)
            {
                configSettingsMap  = new Map<String, List<String>>();
                for( AIWCustomSettings__c configSetting : AIWCustomSettings__c.getAll().values() )
                {
                    if(configSetting.ParameterKey__c != null)
                    {
                        List<String> valuesList = configSettingsMap.get(configSetting.ParameterKey__c.toLowerCase());
                        
                        if(valuesList == null) 
                        {
                            valuesList = new List<String>();                
                        } 
                        valuesList.add(configSetting.ParameterValue__c);
                        configSettingsMap.put(configSetting.ParameterKey__c.toLowerCase(), valuesList);
                    }
                } 
            }
            return configSettingsMap;
        }        
    }
    
    
    public static List<String> getConfigurationValues(String ParameterName)
    {        
        if (ParameterName == null)
        {
            return new List<string>();
        }
        if (configSettingsMap.get(ParameterName.tolowercase()) != null)
        {
            return configSettingsMap.get(ParameterName.tolowercase());
        }
        return new List<string>();
    }
    
    public static string getUSImage(String strBrandname)
    {
        String USImage;
        if(strBrandname.contains(' '))
        {
            USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_dove.png';
        }
        else
        { 
            USImage='/resource/AIW_Static_Resource_New/AIW_Static_Resource2/images/logo_'+strBrandname.toLowerCase()+'.png';
        }
        return USImage;
    } 
}