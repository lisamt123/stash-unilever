/**********************************************************************
Name: OV_Utils
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: Class with util functions
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             18/05/2015      INITIAL DEVELOPMENT
**********************************************************************/
public with sharing class OV_Utils {
    public static final String GEOGRAPHY_ID             = 'geographyId';
    public static final String CATEGORY_ID              = 'categoryId';
    public static final String FUNCTION_ID              = 'functionId';
    public static final String MINE_ONLY                = 'mineOnly';

    private static final String UPDATE_MESSAGE          = 'Update';

    static final String nameLabel = 'Name';

    private static String HTTPS                     = 'https';
    private static String MESSAGE_WARNING_PROTOCOL  = 'Can not create a deep link to a url with this protocol:';
    private static String URL_PART_LIGHTNING        = '.lightning.force.com/one/one.app';

    public class OVException extends Exception {}

    private static Map<String, String> labelToObjectName = new Map<String, String>{
        'function'      =>  'Function__c',
        'category'      =>  'Category__c',
        'geography'     =>  'Geography__c',
        'customer'      =>  'Customer__c'
    };

    public static void generateCategoryNodes(OV_Wrapper.CategoryWrapper element, Map<Id, List<Id>> supp, Map<Id, String> idkToName){
        if(supp.containsKey(element.categoryId)){
            List<Id> childs = supp.get(element.categoryId);
            if( !childs.isEmpty() ){
                for(Id childId : childs){
                    OV_Wrapper.CategoryWrapper childCategory = new OV_Wrapper.CategoryWrapper(childId, idkToName.get(childId));
                    element.addChild(childCategory);
                    generateCategoryNodes(childCategory, supp, idkToName);
                }
            }
        }
    }

    public static void generateGeographyNodes(OV_Wrapper.GeographyWrapper element, Map<Id, List<Id>> supp, Map<Id, String> idkToName){
        if(supp.containsKey(element.geographyId)){
            List<Id> childs = supp.get(element.geographyId);
            if( !childs.isEmpty() ){
                for(Id childId : childs){
                    OV_Wrapper.GeographyWrapper childGeography = new OV_Wrapper.GeographyWrapper(childId, idkToName.get(childId));
                    element.addChild(childGeography);
                    generateGeographyNodes(childGeography, supp, idkToName);
                }
            }
        }
    }

    public static void generateFunctionNodes(OV_Wrapper.FunctionWrapper element, Map<Id, List<Id>> supp, Map<Id, String> idkToName){
        if(supp.containsKey(element.functionId)){
            List<Id> childs = supp.get(element.functionId);
            if( !childs.isEmpty() ){
                for(Id childId : childs){
                    OV_Wrapper.FunctionWrapper childFunction = new OV_Wrapper.FunctionWrapper(childId, idkToName.get(childId));
                    element.addChild(childFunction);
                    generateFunctionNodes(childFunction, supp, idkToName);
                }
            }
        }
    }

    public static void generateCustomerNodes(OV_Wrapper.CustomerWrapper element, Map<Id, List<Id>> supp, Map<Id, String> idkToName){
        if(supp.containsKey(element.customerId)){
            List<Id> childs = supp.get(element.customerId);
            if( !childs.isEmpty() ){
                for(Id childId : childs){
                    OV_Wrapper.CustomerWrapper childCustomer = new OV_Wrapper.CustomerWrapper(childId, idkToName.get(childId));
                    element.addChild(childCustomer);
                    generateCustomerNodes(childCustomer, supp, idkToName);
                }
            }
        }
    }

    public static List<Object> getSortedNestedFilters(String elementName){
        List<Object> result = new List<Object>();

        String objectName = labelToObjectName.get(elementName);
        String objectNameParent = 'Parent_' + objectName;

        String soql = 'SELECT Id, Name, '+objectNameParent+' FROM OV_'+objectName+' ORDER BY Name ASC';
        List<sObject> elements = Database.query(soql);

        Map<Id, String> idkToName = new Map<Id, String>();
        Map<Id, List<Id>> mapOfLists = new Map<Id, List<Id>>();
        List<Id> topNodes = new List<Id>();

        for(sObject element : elements){
            Id elementId = (Id)element.get('Id');
            if(! idkToName.containsKey(elementId)){
                idkToName.put( elementId, (String)element.get(nameLabel));
            }

            if(! mapOfLists.containsKey(elementId)){
                mapOfLists.put(elementId, new List<Id>());
            }

            Id elementObjectParentId = (Id) element.get(objectNameParent);

            if( elementObjectParentId == null ){
                topNodes.add(elementId);
            }else{
                if( ! mapOfLists.containsKey(elementObjectParentId) ){
                    mapOfLists.put( elementObjectParentId , new List<Id>());
                }
                mapOfLists.get( elementObjectParentId ).add(elementId);
            }
        }

        for(Id topId : topNodes){
            String wrappedName = idkToName.get(topId);
            if(elementName == 'category'){
                OV_Wrapper.CategoryWrapper topNode = new OV_Wrapper.CategoryWrapper(topId, wrappedName);
                generateCategoryNodes(topNode, mapOfLists, idkToName);
                result.add(topNode);
            }else if(elementName == 'geography'){
                OV_Wrapper.GeographyWrapper topNode = new OV_Wrapper.GeographyWrapper(topId, wrappedName);
                generateGeographyNodes(topNode, mapOfLists, idkToName);
                result.add(topNode);
            }else if(elementName == 'customer'){
                OV_Wrapper.CustomerWrapper topNode = new OV_Wrapper.CustomerWrapper(topId, wrappedName);
                generateCustomerNodes(topNode, mapOfLists, idkToName);
                result.add(topNode);
            }else{
                OV_Wrapper.FunctionWrapper topNode = new OV_Wrapper.FunctionWrapper(topId, wrappedName);
                generateFunctionNodes(topNode, mapOfLists, idkToName);
                result.add(topNode);
            }
        }

        return result;
    }

    public static List<Object> getBrands(){
        List<Object> result = new List<Object>();

        String soql = 'SELECT Id, Name FROM OV_Brand__c ORDER BY Name ASC';
        List<OV_Brand__c> elements = Database.query(soql);

        for(OV_Brand__c g : elements){
            result.add(new OV_Wrapper.BrandWrapper(g.Id, g.Name));
        }

        return result;
    }

    public static List<Object> getComparators(){
        List<Object> result = new List<Object>();

        String soql = 'SELECT Id, Name FROM OV_Comparator__c ORDER BY Name ASC';
        List<OV_Comparator__c> elements = Database.query(soql);

        for(OV_Comparator__c g : elements){
            result.add(new OV_Wrapper.ComparatorWrapper(g.Id, g.Name));
        }

        return result;
    }

    public static List<Object> getTimespans(){
        List<Object> result = new List<Object>();

        Schema.DescribeFieldResult fieldMediaType = OV_KPI_Element__c.TimeSpan__c.getDescribe();
        for(Schema.PicklistEntry f : fieldMediaType.getPicklistValues()) {
            result.add(new OV_Wrapper.TimespanWrapper(f.getLabel()));
        }

        return result;
    }

    public static List<Object> getChannels(){
        List<Object> result = new List<Object>();

        Schema.DescribeFieldResult fieldMediaType = OV_KPI_Element__c.Channel__c.getDescribe();
        for(Schema.PicklistEntry f : fieldMediaType.getPicklistValues()) {
            result.add(new OV_Wrapper.ChannelWrapper(f.getLabel()));
        }

        return result;
    }

    public static List<Object> getReportHeadings(){
        List<Object> result = new List<Object>();

        Schema.DescribeFieldResult fieldMediaType = OV_Report__c.Report_Heading__c.getDescribe();
        for(Schema.PicklistEntry f : fieldMediaType.getPicklistValues()) {
            result.add(new OV_Wrapper.HeadingWrapper(f.getLabel()));
        }

        return result;
    }

    public static void saveFilters(String geographyId, String categoryId, String functionId, Boolean mineOnly){
        Map<String, String> mapOfFilters = new Map<String, String>();
        mapOfFilters.put(GEOGRAPHY_ID, geographyId);
        mapOfFilters.put(CATEGORY_ID, categoryId);
        mapOfFilters.put(FUNCTION_ID, functionId);
        mapOfFilters.put(MINE_ONLY, String.valueOf(mineOnly));

        Id currentUserId = UserInfo.getUserId();
        List<OV_Profile__c> profile = [SELECT Id, Filters__c FROM OV_Profile__c WHERE User__c = :currentUserId LIMIT 1];

        if( !profile.isEmpty() ){
            profile[0].Filters__c = JSON.serialize(mapOfFilters);
        }
        update profile;
    }

    public static List<sObject> getFilterSavedStructure(String elementName, String elementId){
        String elem = elementId;
        String objectName = labelToObjectName.get(elementName);
        String objectNameParent = 'Parent_' + objectName;
        String soql = 'SELECT Id, Name, '+objectNameParent+' FROM OV_'+objectName+' ORDER BY Name ASC';
        List<sObject> elements = Database.query(soql);

        Map<Id, sObject> elementsMap = new Map<Id, sObject>();
        for(sObject element : elements){
            elementsMap.put((Id)element.get('Id'), element);
        }

        List<sObject> res = new List<sObject>();
        if(elementsMap.containsKey(elem)){
            res.add(elementsMap.get(elem));

            while(elementsMap.containsKey(elem) && elementsMap.get(elem).get(objectNameParent) != null){
                elem = (Id)elementsMap.get(elem).get(objectNameParent);
                res.add(elementsMap.get(elem));
            }
        }

        return res;
    }

    public static Map<String, String> getSavedFiltersFromObject(){
        Id currentUserId = UserInfo.getUserId();

        List<OV_Profile__c> profile = [SELECT Id, Filters__c FROM OV_Profile__c WHERE User__c = :currentUserId];

        Map<String, String> results = new Map<String, String>();
        if( !profile.isEmpty() && profile[0].Filters__c != null && profile[0].Filters__c != ''){
            Map<String, Object> filters = (Map<String, Object>)JSON.deserializeUntyped(profile[0].Filters__c);

            if(filters.containsKey(FUNCTION_ID) && filters.get(FUNCTION_ID) != null && String.valueOf(filters.get(FUNCTION_ID)) != ''){
                results.put(FUNCTION_ID, String.valueOf(filters.get(FUNCTION_ID)));
            }

            if(filters.containsKey(CATEGORY_ID) && filters.get(CATEGORY_ID) != null && String.valueOf(filters.get(CATEGORY_ID)) != ''){
                results.put(CATEGORY_ID, String.valueOf(filters.get(CATEGORY_ID)));
            }

            if(filters.containsKey(GEOGRAPHY_ID) && filters.get(GEOGRAPHY_ID) != null && String.valueOf(filters.get(GEOGRAPHY_ID)) != '' ){
                results.put(GEOGRAPHY_ID, String.valueOf(filters.get(GEOGRAPHY_ID)));
            }

            if(filters.containsKey(MINE_ONLY)){
                results.put(MINE_ONLY, String.valueOf(filters.get(MINE_ONLY)));
            }
        }
        return results;
    }

    public static Map<String, String> getSavedFilters(){
        String geographyId = '';
        String categoryId = '';
        String functionId = '';
        Boolean mineOnly = false;

        Id currentUserId = UserInfo.getUserId();

        List<OV_Profile__c> profile = [SELECT Id, Filters__c FROM OV_Profile__c WHERE User__c = :currentUserId];

        if( !profile.isEmpty() && profile[0].Filters__c != null && profile[0].Filters__c != ''){
            Map<String, Object> filters = (Map<String, Object>)JSON.deserializeUntyped(profile[0].Filters__c);

            Map<String, String> results = new Map<String, String>();

            if(filters.containsKey(FUNCTION_ID) && filters.get(FUNCTION_ID) != null && String.valueOf(filters.get(FUNCTION_ID)) != ''){
                functionId = String.valueOf(filters.get(FUNCTION_ID));
                List<sObject> functionFiltersList = getFilterSavedStructure(OV_RemoteController.FILTER_FUNCTION, functionId);
                results.put(FUNCTION_ID, (String)functionFiltersList[0].get('Id'));
                results.put('functionIdLabel', (String)functionFiltersList[0].get(nameLabel));
            }

            if(filters.containsKey(CATEGORY_ID) && filters.get(CATEGORY_ID) != null && String.valueOf(filters.get(CATEGORY_ID)) != ''){
                categoryId = String.valueOf(filters.get(CATEGORY_ID));
                List<sObject> categoryFiltersList = getFilterSavedStructure(OV_RemoteController.FILTER_CATEGORY, categoryId);
                if(categoryFiltersList.size() > 1){
                    results.put('category1Id', (String)categoryFiltersList[1].get('Id'));
                    results.put('category1IdLabel', (String)categoryFiltersList[1].get(nameLabel));

                    results.put('category2Id', (String)categoryFiltersList[0].get('Id'));
                    results.put('category2IdLabel', (String)categoryFiltersList[0].get(nameLabel));
                }else{
                    results.put('category1Id', (String)categoryFiltersList[0].get('Id'));
                    results.put('category1IdLabel', (String)categoryFiltersList[0].get(nameLabel));
                }
            }

            if(filters.containsKey(GEOGRAPHY_ID) && filters.get(GEOGRAPHY_ID) != null && String.valueOf(filters.get(GEOGRAPHY_ID)) != '' ){
                geographyId = String.valueOf(filters.get(GEOGRAPHY_ID));
                List<sObject> geographyFiltersList = getFilterSavedStructure(OV_RemoteController.FILTER_GEOGRAPHY, geographyId);
                if(geographyFiltersList.size() > 2){
                    results.put('geography1Id', (String)geographyFiltersList[2].get('Id'));
                    results.put('geography1IdLabel', (String)geographyFiltersList[2].get(nameLabel));

                    results.put('geography2Id', (String)geographyFiltersList[1].get('Id'));
                    results.put('geography2IdLabel', (String)geographyFiltersList[1].get(nameLabel));

                    results.put('geography3Id', (String)geographyFiltersList[0].get('Id'));
                    results.put('geography3IdLabel', (String)geographyFiltersList[0].get(nameLabel));
                }else if(geographyFiltersList.size() > 1){
                    results.put('geography1Id', (String)geographyFiltersList[1].get('Id'));
                    results.put('geography1IdLabel', (String)geographyFiltersList[1].get(nameLabel));

                    results.put('geography2Id', (String)geographyFiltersList[0].get('Id'));
                    results.put('geography2IdLabel', (String)geographyFiltersList[0].get(nameLabel));
                }else{
                    results.put('geography1Id', (String)geographyFiltersList[0].get('Id'));
                    results.put('geography1IdLabel', (String)geographyFiltersList[0].get(nameLabel));
                }
            }

            if(filters.containsKey(MINE_ONLY)){
                results.put(MINE_ONLY, String.valueOf(filters.get(MINE_ONLY)));
            }

            return results;
        }else{
            return null;
        }
    }

    private static String getMessageFromObject(String messageType, sObject obj, Boolean isKpi){
        if(isKpi){
            OV_KpiNotificationFormatter formatter = new OV_KpiNotificationFormatter();
            String formatedMessage = formatter.formatMessage((OV_KPI_Transaction_Favorite__c)obj);
            System.debug('getMessageFromObject. Formatted message: '+formatedMessage);
            return formatedMessage;
        }else{
            return (messageType == UPDATE_MESSAGE) ? String.valueOf(obj.get('Chatter_Update_Message__c')) : String.valueOf(obj.get('Chatter_Delete_Message__c'));
        }
    }

    public static ConnectApi.FeedItemInput generateKpiNotification(sObject obj, String messageType) {
        return generateNotification(obj, messageType, true);
    }

    public static ConnectApi.FeedItemInput generateReportNotification(sObject obj, String messageType) {
        return generateNotification(obj, messageType, false);
    }

    private static String generateBaseUrlForLex(){
        URL baseUrl = System.URL.getSalesforceBaseURL();
        String protocol = baseUrl.getProtocol();
        if(protocol != 'https'){
            System.debug(LoggingLevel.WARN,  +'Error while preparing BaseUrl for LEX: '+MESSAGE_WARNING_PROTOCOL + protocol);
            return '';
        }

        String host = baseUrl.getHost();

        Integer endOfMyDomain = host.indexOf('.');
        if(endOfMyDomain > -1){
            String myDomain = host.substring(0, endOfMyDomain);

            String oneViewURL = protocol + '://' + myDomain + URL_PART_LIGHTNING;

            return oneViewURL;
        }else{
            System.debug(LoggingLevel.WARN, 'Error while preparing BaseUrl for LEX');
            return '';
        }        
    }

    public static ConnectApi.FeedItemInput generateNotification(sObject obj, String messageType, Boolean isKpi) {
        System.debug('Generating notifications for '+ String.valueOf(obj.get('Id')) + ', messageType: '+messageType+', is for KPIs?: '+String.valueOf(isKpi) +', for user: '+ String.valueOf(obj.getSObject('User__r').get('User__c')));
        String message = getMessageFromObject(messageType, obj, isKpi);

        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();

        mentionSegment.id = (Id) obj.getSObject('User__r').get('User__c');
        body.messageSegments.add(mentionSegment);

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = '\n ' + message;
        body.messageSegments.add(textSegment);

        ConnectApi.LinkCapabilityInput linkInput = new ConnectApi.LinkCapabilityInput();

        String domainUrl = generateBaseUrlForLex();     
        String url = domainUrl;

        Map<String, Object> target = new Map<String, Object>();
        if(!isKpi){
            String reportId = String.valueOf(obj.get('Report__c'));
            String color = String.valueOf(obj.getSObject('Favourite_From_Shelf_Tile__r').get('Tile_Colour__c'));
            String icon = String.valueOf(obj.getSObject('Favourite_From_Shelf_Tile__r').get('ICON_Label__c'));
            String shelfTileId = String.valueOf(obj.getSObject('Favourite_From_Shelf_Tile__r').get('Id'));
            
            if(color.length() > 7){
                 System.debug(LoggingLevel.DEBUG, 'Color too long:' + color);
            }

            if(icon.length() > 8){
                 System.debug(LoggingLevel.DEBUG, 'Icon too long:' + icon);
            }
            
            Map<String, Object> attributes = new Map<String, Object>{
                'renderBackArrow' => true,
                'wrappedObject'   => new Map<String, Object>{
                    'componentDef'        => 'c:OV_ReportDesktop',
                    'componentAttributes' => new Map<String, Object>{
                        'reportId'    => reportId,
                        'shelfColour' => color,
                        'shelfIcon'   => icon,    
                        'shelfTileId' => shelfTileId
                    }
                }
            };

            // prepare state object
            target = new Map<String, Object>{
                'componentDef' => 'one:auraContainer',
                'attributes'   => new Map<String, Object>{
                    'values' => new Map<String, Object>{
                        'tag'                 => 'c:OV_Navigation',
                        'componentDef'        => 'c:OV_ComponentWrapper',
                        'componentAttributes' => attributes,
                        'attributes'          => attributes
                    }
                }
            };
        }else{
            target = new Map<String, Object>{ 
                'componentDef' => 'one:auraContainer',
                'attributes'   => new Map<String, Object>{
                    'values' => new Map<String, Object>{
                        'tag'                 => 'c:OV_Navigation',
                        'componentDef'        => 'c:OV_Home',
                        'componentAttributes' => new Map<String, String>{'defaultMenuItem' => 'MY VIEW'},
                        'attributes'          => new Map<String, String>{'defaultMenuItem' => 'MY VIEW'}
                    }
                }
            };
        }
        String hash = EncodingUtil.base64Encode(Blob.valueOf(JSON.serialize(target)));
        url  += '#' + hash;
  
        ConnectApi.FeedElementCapabilitiesInput feedElementCapabilitiesInput = new ConnectApi.FeedElementCapabilitiesInput();

        if(domainUrl.length() == 0){
            // TODO - assign a KPI error number to log message
            System.debug(LoggingLevel.WARN, 'Problem with constructing URL');
        }else{
            if(url.length() >= 1000){
                System.debug(LoggingLevel.WARN, 'URL TO LONG FOR:' + (String) obj.get('Id') + ' : ' + url);
            }
            
            linkInput.url = url;
            linkInput.urlName = 'One View';

            feedElementCapabilitiesInput.link = linkInput; 
        }

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.subjectId = (Id) obj.get('Id');
        input.body = body;
        input.feedElementType = ConnectApi.FeedElementType.FeedItem;

        input.capabilities = feedElementCapabilitiesInput;

        return input;
    }

}