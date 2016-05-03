/******************************************************************************************************
Class Name      :       uw_Constants
Class Desc.     :       Apex class for VF page: EditAsset.page                                   
Author          :       Accenture UK

Change History
Date          Author       version             Description                                      Requested By       Tag
--------------------------------------------------------------------------------------------------------------------------
12-Sep-2012   Accenture UK  0.01            Initial build of class                              Unilever
15-Apr-2013   Nikhil        0.02            The mappings changed as per the                     Unilever            T0
                                            new requirements for piclists of Asset object
                                            in maps level3ToLevel1Map & level3ToLevel2Map                                           
***************************************************************************************************************************/

public without sharing class uw_Constants {
    
    public static final String PRODUCTION_ORG_ID = '00DL00000009aws';
    public static final String USER_PROFILE_ID_SYSTEM_ADMIN = '00eE0000000tj05';
    
    public static final String BET_TEAM_ROLE_MANAGER = 'Manager';
    public static final String BET_TEAM_ROLE_USER = 'Member';
    public static final String BET_TEAM_ROLE_EXTERNAL = 'External Agency User';
    
    public static final String ACCESS_LEVEL_TOOLKIT = 'Toolkit Experience (Toolkit only)';
    public static final String ACCESS_LEVEL_FULL = 'Full Brand Experience (Toolkit & Studio)';
    public static final String ACCESS_LEVEL_EXTERNAL_VIEW = 'External View (Chatter group only)';

    /******************************************************************************************************
     Method Name   :   getAssetCategorisationLevel3ToLevel1Map
     Method Type   :   LookUp
     Method Parameters: list<Document_Categorisation__c> lstDCG : List of categorisation fields stored in a custom setting.
                                map<String,String>     : map of categorisation 3 versus categorisation 1 field values      
     Return Type     :   static
     Method Desc.  :   This method gives a categorisation 1 value depending upon the categorisation 3 value selected by user.
    ******************************************************************************************************/
    
    public static Map<String, String> getAssetCategorisationLevel3ToLevel1Map()
    {
        Map<String,String> level3ToLevel1Map = new Map<String,String>();
    
    //-------------------------------------------------------------------------------------------<T0>
        
        // To gather values in custom setting Document Categorisation
        List<Document_Categorisation__c> lstDCG = Document_Categorisation__c.getall().values();
        
        // To iterate and create a 1 on 1 map of level_3 vs level_1 values
        for(Document_Categorisation__c l3l1map : lstDCG)
        {
            level3ToLevel1Map.put(l3l1map.level_3__c, l3l1map.level_1__c );
        }
        
    //-------------------------------------------------------------------------------------------<T0>        
        
        system.debug('The level 3 to level 1 map ----------'+level3ToLevel1Map);
        
        level3ToLevel1Map.put('Other','Other');
                
        return level3ToLevel1Map;
        
        /**
        // New Mapping Values
        level3ToLevel1Map.put('Promotion - Engages people ','Engages people with our brand ');
        level3ToLevel1Map.put('Place - Store as a media channel','People buy'); 
        level3ToLevel1Map.put('Price - Getting and Setting a competitive price','People buy');
        level3ToLevel1Map.put('Proposition - A compelling idea to buy into','Something people want');
        level3ToLevel1Map.put('Pack - Exceptional packaging','Something people want');
        level3ToLevel1Map.put('Product - Phenomenal product experience','Something people want');
        level3ToLevel1Map.put('Place - Know the channels to activate','Unlocks customers’ support ');
        level3ToLevel1Map.put('Place - A trade story to win with','Unlocks customers’ support ');
        **/
        
        /**        
        // Old Mapping Values
        level3ToLevel1Map.put('Concept','Something people want');        
        level3ToLevel1Map.put('Product is Hero proof','Something people want');
        level3ToLevel1Map.put('Impact on Shopper Driven Assortment','Something people want');
        level3ToLevel1Map.put('Visual equities inc. 3D and 2D inc pack clarity','Something people want');
        level3ToLevel1Map.put('Secondary packaging','Something people want');
        level3ToLevel1Map.put('Display packaging','Something people want');
        level3ToLevel1Map.put('Hi-res image for e-commerce','Something people want');
        level3ToLevel1Map.put('Retail Customer Strategy','Unlocks customers’ support ');
        level3ToLevel1Map.put('Channel Strategic Framework','Unlocks customers’ support ');
        level3ToLevel1Map.put('Primary Placement','Unlocks customers’ support ');
        level3ToLevel1Map.put('Secondary Placement','Unlocks customers’ support ');
        level3ToLevel1Map.put('Trade Customer Story','Unlocks customers’ support ');
        level3ToLevel1Map.put('Targets for: on-shelf availability, new product development and share of shelf','Unlocks customers’ support ');  
        level3ToLevel1Map.put('Comms Objectives and Strategy ','Engages people with our brand ');
        level3ToLevel1Map.put('Media Plan inc. reach, frequency, weight targets','Engages people with our brand ');
        level3ToLevel1Map.put('Creative Brand Assets','Engages people with our brand ');
        level3ToLevel1Map.put('ASSIST digital strategy inc. SEO','Engages people with our brand ');
        level3ToLevel1Map.put('Community Involvement','Engages people with our brand ');
        level3ToLevel1Map.put('Price Strategy / Right Price','People buy');
        level3ToLevel1Map.put('Trade Promotional Guidelines','People buy');
        level3ToLevel1Map.put('In-store Brand Activation','People buy');
        level3ToLevel1Map.put('Perfect Launch','People buy');
        level3ToLevel1Map.put('e-commerce selling copy','Unlocks customers’ support ');
        level3ToLevel1Map.put('IBC pyramid brought to life','Engages people with our brand ');
        level3ToLevel1Map.put('Campaign Idea headlines','Engages people with our brand ');
        level3ToLevel1Map.put('Guidelines on assets by media channel','Engages people with our brand ');
        level3ToLevel1Map.put('Call to Action','People buy');   
        level3ToLevel1Map.put('Key Visual','People buy');   
        level3ToLevel1Map.put('Click through to Guggenheim and all eCommerce resources','People buy');
        level3ToLevel1Map.put('Executional Briefs e.g. PR, activation','Engages people with our brand ');
        level3ToLevel1Map.put('Comms Objectives and Strategy','Engages people with our brand ');
        **/ 
    }
    
    public static Map<String, String> getAssetLocalizationMessageMap()
    {
        Map<String,String> localisationMessageMap = new Map<String,String>();
        localisationMessageMap.put('Plug & Play','Minimal localisation required e.g. language');
        localisationMessageMap.put('Adapt & Amplify', 'Some localisation required based on local insight e.g. local celebrity, local host foods, locally appropriate models');
        localisationMessageMap.put('Create a Local Tactic', 'Within Conversation Idea create local assets e.g. customer specific tactics, local shopper engagement');
        localisationMessageMap.put('No localisation required', 'No localisation is required');
        
        return localisationMessageMap;
    }
    

    // T0
    
    /******************************************************************************************************
     Method Name   :   getAssetCategorisationLevel3ToLevel2Map
     Method Type   :   LookUp
     Method Parameters: list<Document_Categorisation__c> lstDCG : List of categorisation fields stored in a custom setting.
                                map<String,String>     : map of categorisation 3 versus categorisation 2 field values      
     Return Type     :   static
     Method Desc.  :   This method gives a categorisation 2 value depending upon the categorisation 3 value selected by user.
    ******************************************************************************************************/
    
    
    public static Map<String, String> getAssetCategorisationLevel3ToLevel2Map()
    {
        Map<String,String> level3ToLevel2Map = new Map<String,String>();

    //-------------------------------------------------------------------------------------------<T0>
        
        // To gather values in custom setting Document Categorisation
        List<Document_Categorisation__c> lstDCG = Document_Categorisation__c.getall().values();
        
        // To iterate and create a 1 on 1 map of level_3 vs level_2 values
        for(Document_Categorisation__c l3l2map : lstDCG)
        {
            level3ToLevel2Map.put(l3l2map.level_3__c, l3l2map.level_2__c );
        }
        
    //-------------------------------------------------------------------------------------------<T0>
        
        system.debug('The level 3 to level 2 map ----------'+level3ToLevel2Map);

        return level3ToLevel2Map;
                
        /**
        // New Mapping
        level3ToLevel2Map.put('Promotion - Engages people','How we will engage with the people we are serving');
        level3ToLevel2Map.put('Place - Store as a media channel','Bringing the brand to life in-store'); 
        level3ToLevel2Map.put('Price - Getting and Setting a competitive price','Getting & setting a competitive price');
        level3ToLevel2Map.put('Proposition - A compelling idea to buy into','A compelling idea to buy into');
        level3ToLevel2Map.put('Pack - Exceptional packaging','Exceptional packaging');
        level3ToLevel2Map.put('Product - Phenomenal product experience','A phenomenal product experience');
        level3ToLevel2Map.put('Place - Know the channels to activate','Know the channels to activate');
        level3ToLevel2Map.put('Place - A trade story to win with','A trade story to win with');
        **/
        /**
        // Old Mapping
        level3ToLevel2Map.put('Concept','A compelling idea to buy into');
        level3ToLevel2Map.put('Brand Communication Idea','A compelling idea to buy into');
        level3ToLevel2Map.put('Product is Hero proof','A phenomenal product experience');
        level3ToLevel2Map.put('Impact on Shopper Driven Assortment','A phenomenal product experience');
        level3ToLevel2Map.put('Visual equities inc. 3D and 2D inc pack clarity','Exceptional packaging');
        level3ToLevel2Map.put('Secondary packaging','Exceptional packaging');
        level3ToLevel2Map.put('Display packaging','Exceptional packaging');
        level3ToLevel2Map.put('Hi-res image for e-commerce','Exceptional packaging');
        level3ToLevel2Map.put('Retail Customer Strategy','Know the channels to activate');
        level3ToLevel2Map.put('Channel Strategic Framework','Know the channels to activate');
        level3ToLevel2Map.put('Primary Placement','Know the channels to activate');
        level3ToLevel2Map.put('Secondary Placement','Know the channels to activate');
        level3ToLevel2Map.put('Targets for: on-shelf availability, new product development and share of shelf','Know the channels to activate');
        level3ToLevel2Map.put('Trade Customer Story','A trade story to win with');
        level3ToLevel2Map.put('e-commerce selling copy','A trade story to win with');
        level3ToLevel2Map.put('Comms Objectives and Strategy','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('IBC pyramid brought to life','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('Campaign Idea headlines','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('Media Plan inc. reach, frequency, weight targets','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('Creative Brand Assets','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('Guidelines on assets by media channel','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('Executional Briefs e.g. PR, activation','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('ASSIST digital strategy inc. SEO','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('Community Involvement','How we’ll engage with the people we’re serving');
        level3ToLevel2Map.put('Price Strategy / Right Price','Getting & setting a competitive price');
        level3ToLevel2Map.put('Trade Promotional Guidelines','Bringing the brand to life in-store');
        level3ToLevel2Map.put('Key Visual','Bringing the brand to life in-store');
        level3ToLevel2Map.put('In-store Brand Activation','Bringing the brand to life in-store');
        level3ToLevel2Map.put('Perfect Launch','Bringing the brand to life in-store');
        level3ToLevel2Map.put('Call to Action','Bringing the brand to life in-store');
        level3ToLevel2Map.put('Click through to Guggenheim and all eCommerce resources','Bringing the brand to life in-store');
        level3ToLevel2Map.put('Other','Other');
        **/    

    }
    
    // TODO - Move to custom settings
    public static List<String> getJwPlayerVideoFileExtensions()
    {
        List<String> jwPlayerVideoFiles = new List<String>();
        jwPlayerVideoFiles.add('.mp4');
        jwPlayerVideoFiles.add('.f4v');
        jwPlayerVideoFiles.add('.flv');
        jwPlayerVideoFiles.add('.3gp');
        jwPlayerVideoFiles.add('.3g2');
        jwPlayerVideoFiles.add('.mov');
        jwPlayerVideoFiles.add('.m4v');
        
        return jwPlayerVideoFiles;
    }
    
    // TODO - Move to custom settings
    public static List<String> getJwPlayerAudioFileExtensions()
    {
        List<String> jwPlayerAudioFiles = new List<String>();
        jwPlayerAudioFiles.add('.mp3');
        jwPlayerAudioFiles.add('.aac');
        jwPlayerAudioFiles.add('.m4a');
        
        return jwPlayerAudioFiles;
    }
     
    // TODO - Move to custom settings   
    public static List<String> getChatterTypeFileExtensions()
    {   
        List<String> chatterTypeFiles = new List<String>();
        chatterTypeFiles.add('doc');
        chatterTypeFiles.add('docx');
        chatterTypeFiles.add('xls');
        chatterTypeFiles.add('xlsx');
        chatterTypeFiles.add('rtf');
        chatterTypeFiles.add('pps');
        chatterTypeFiles.add('ppt');
        chatterTypeFiles.add('pptx');
        chatterTypeFiles.add('pdf');
        chatterTypeFiles.add('pdf');
        chatterTypeFiles.add('gif');
        chatterTypeFiles.add('jpeg');
        chatterTypeFiles.add('jpg');
        chatterTypeFiles.add('bmp');
        chatterTypeFiles.add('png');
        chatterTypeFiles.add('txt');
        
        return chatterTypeFiles;
    }
    
    public static List<String> getPinnovateFileExtensions()
    {
        List<String> pinnovateFileExtensions = new List<String>();
        pinnovateFileExtensions.add('gif');
        pinnovateFileExtensions.add('jpeg');
        pinnovateFileExtensions.add('jpg');
        pinnovateFileExtensions.add('bmp');
        pinnovateFileExtensions.add('png');      
        pinnovateFileExtensions.add('doc');
        pinnovateFileExtensions.add('docx');
        pinnovateFileExtensions.add('xls');
        pinnovateFileExtensions.add('xlsx');
        pinnovateFileExtensions.add('rtf');
        pinnovateFileExtensions.add('pps');
        pinnovateFileExtensions.add('ppt');
        pinnovateFileExtensions.add('pptx');
        pinnovateFileExtensions.add('pdf');
        pinnovateFileExtensions.add('pdf');
        pinnovateFileExtensions.add('txt');
        
        return pinnovateFileExtensions;
    }    
    
    public static TestMethod void testUwConstants()
    {
        uw_Constants.getAssetCategorisationLevel3ToLevel1Map();
        uw_Constants.getAssetCategorisationLevel3ToLevel2Map();
        uw_Constants.getAssetLocalizationMessageMap();
        uw_Constants.getJwPlayerVideoFileExtensions();
        uw_Constants.getJwPlayerAudioFileExtensions();
        uw_Constants.getChatterTypeFileExtensions();
    }
    
    
    
 }