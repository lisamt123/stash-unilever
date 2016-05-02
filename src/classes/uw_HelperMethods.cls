public with sharing class uw_HelperMethods {

    // This method is used to check if the current code is running in production
    public static Boolean isProductionOrg()
    {
        return uw_HelperMethods.idsAreEqual(Userinfo.getOrganizationId(),uw_Constants.PRODUCTION_ORG_ID);
    }
    
    public static Boolean isSandboxOrg()
    {
        return !(uw_HelperMethods.idsAreEqual(Userinfo.getOrganizationId(),uw_Constants.PRODUCTION_ORG_ID));
    }

    private static final String PROD_LOGON_SERVER = 'https://login.salesforce.com';
    private static final String SANDBOX_LOGON_SERVER = 'https://test.salesforce.com';
    
    public static String getSalesforceLogonServer() {
    	return (isProductionOrg() ? PROD_LOGON_SERVER : SANDBOX_LOGON_SERVER);
    }

    public static Boolean idsAreEqual(String id1, String id2)
    {
        if (id1 != null && id2 != null)
        {
            return id1.subString(0, 15).equals(id2.subString(0, 15));
        }
        else if (id1 == null && id2 == null)
        {
            return true;
        }
        
        // 1 is null and other is non null - therefore not equal!
        return false;
    }
    
    public static Boolean valueIsNull(Object val)
    {
        if(val == null || String.valueOf(val).length() == 0)
        {
            return true;
        }
        
        return false;
    }

    public static Boolean listIsNull(List<SObject> listUnderTest)
    {
    	Boolean isEmpty = true;
        if(listUnderTest != null && listUnderTest.Size() > 0)
        {
            isEmpty = false;
        }
        
        return isEmpty;
    }

    public static Boolean hasModifyAllData() {
        Boolean hasMAD = false;
        
        try {
            Id profileId = UserInfo.getProfileId();
            if (profileId != null) {
                system.debug('hasModifyAllData: pid: '+profileId);
                Profile p = [SELECT PermissionsModifyAllData FROM Profile WHERE id=:profileId];
                if (p != null) {
                    system.debug('hasModifyAllData: p: '+p); 
                    hasMad = p.PermissionsModifyAllData;                
                }
            }
        } catch (Exception ex){
            system.debug('hasModifyAllData: problem getting perm');         
        }
        
        return hasMAD;
    }
    
    public static Map<String,String> getMapOfLatestPublishedContentVersions(List<String> contentVersionIds)
    {
    	Map<Id,ContentVersion> origVersionMap = new Map<Id,ContentVersion>([Select Id, ContentDocumentId from ContentVersion where Id in :contentVersionIds]);
          
        // Get a list of the content docs ids for the content versions
        List<Id> contentDocIds = new List<Id>();
        for (ContentVersion cVer : origVersionMap.values())
        {
             contentDocIds.add(cVer.ContentDocumentId);
        }
        
        // Get the content docs for the versions  
        Map<Id,ContentDocument> docMap = new Map<Id,ContentDocument>([SELECT Id, LatestPublishedVersionId FROM ContentDocument WHERE Id in  :contentDocIds]);
        
        // So we need to replace the origional version id - with the latest version Id from the doc...
        Map<String,String> oldVerToNewVerMap = new Map<String,String>();
        for (Id cvId: contentVersionIds)
        {
            // Find the Content doc for the content version-
            ContentDocument cDoc = docMap.get(origVersionMap.get(cvId).ContentDocumentId);
              
            // Replace the current version with the latest published version
            oldVerToNewVerMap.put(cvId, cDoc.LatestPublishedVersionId);
        }
        
        return oldVerToNewVerMap;
    }

    public static Boolean isSystemAdminUser()
    {
    	return hasModifyAllData();
        //return uw_HelperMethods.idsAreEqual(uw_Constants.USER_PROFILE_ID_SYSTEM_ADMIN, UserInfo.getProfileId());
    }
    
    /* Neil supplied methods */
    /* start */
    public static Boolean userIsOwner(String ownerId) {
        if (ownerId == null) { 
            return false;
        }
        else return idsAreEqual(UserInfo.getUserId(),ownerId);
    }
    
    
    public static String parseVimeoVideoIdPR(String vidURL)
    {
    	PageReference pr = new PageReference(vidURL);
    	
    	System.debug('Vimeo - Parse Params '+pr.getParameters()+' '+pr.getUrl());
    	
    	// TODO - parse to last slash - and any params and #
    	
    	Integer lastSlash = vidURL.lastIndexOf('/');
    	
    	String idAndRemainder = vidURL.substring(lastSlash+1);
    	System.debug('Vimeo - Remainder: '+idAndRemainder); 
    	
    	if (idAndRemainder.contains('?'))
    	{
    		idAndRemainder = idAndRemainder.substring(0,idAndRemainder.indexOf('?'));  
    	}
    	
    	if (idAndRemainder.contains('#'))
    	{
    		idAndRemainder = idAndRemainder.substring(0,idAndRemainder.indexOf('#'));  
    	}
    	
    	
    	return idAndRemainder;
    }
    
    public static String parseYouTubeVideoIdPR(String ytURL)
    {
    	PageReference pr = new PageReference(ytURL);
    	// pr.getParameters();
    	
    	if (pr.getParameters().keySet().contains('v'))
    	{
    		System.debug('Got Parameter from '+ytURL+' got: '+pr.getParameters().get('v'));
    	}
    	else
    	{
    		
    	}
    	
    	return pr.getParameters().get('v');
    }
    
    /*************
	Method: Method to get all fieldset members based on fieldset name and sObject
	Parameters: String fieldSetName and String sObjectName
	Return value: List<Schema.FieldSetMember>
	Exception: void
	*************/
    public static List<Schema.FieldSetMember> getFieldSet(String fieldSetName, String ObjectName)
	{	
		//store all global describe tokens
	    Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
	    //get object description based on objectName from parameter
	    Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
	    Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
		
		//get all fieldset schema for specific fieldsetname which is passed as parameter
	    Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
	
	    //system.debug('fieldSetMemberList ====>' + fieldSetMemberList);  
	    return fieldSetObj.getFields(); 
	}
	    
    public static TestMethod void testParseYouTubeVideoId()
    {
    	List<String> youtubeTestUrls = new List<String>();
    	youtubeTestUrls.add('http://www.youtube.com/watch?v=t7Ue8630NzE');
    	youtubeTestUrls.add('https://www.youtube.com/watch?v=t7Ue8630NzE');
    	youtubeTestUrls.add('http://www.youtube.com/watch?v=t7Ue8630NzE#t=3s');
    	youtubeTestUrls.add('https://www.youtube.com/watch?v=t7Ue8630NzE#t=3s');
    	youtubeTestUrls.add('http://www.youtube.com/watch?v=t7Ue8630NzE&showparam=2');
    	youtubeTestUrls.add('https://www.youtube.com/watch?v=t7Ue8630NzE&showparam=2');
    	youtubeTestUrls.add('http://www.youtube.com/watch?feature=player_detailpage&v=t7Ue8630NzE#t=3s');
    	youtubeTestUrls.add('https://www.youtube.com/watch?feature=player_detailpage&v=t7Ue8630NzE#t=3s');
    	youtubeTestUrls.add('http://www.youtube.com/watch?feature=player_detailpage&v=t7Ue8630NzE');
    	youtubeTestUrls.add('https://www.youtube.com/watch?feature=player_detailpage&v=t7Ue8630NzE');
    	youtubeTestUrls.add('http://www.youtube.com/embed/t7Ue8630NzE?feature=player_detailpage');
    	youtubeTestUrls.add('https://www.youtube.com/embed/t7Ue8630NzE?feature=player_detailpage');
    	
    	for (String u: youtubeTestUrls)
    	{
    		System.debug('Parsed '+u+' got: '+ uw_HelperMethods.parseYouTubeVideoIdPR(u));
    	}
    	
    	// Vid Urls in format -     	
    	// http://vimeo.com/*
		// http://vimeo.com/channels/*/*
		// http://vimeo.com/groups/*/videos/*
    	List<String> vimeoTestUrls = new List<String>();
    	vimeoTestUrls.add('http://vimeo.com/27038517');
    	vimeoTestUrls.add('https://vimeo.com/27038517');
    	vimeoTestUrls.add('http://player.vimeo.com/video/27038517');
    	vimeoTestUrls.add('https://player.vimeo.com/video/27038517');
    	vimeoTestUrls.add('http://vimeo.com/channels/nicetype#/channels/nicetype/27038517');
    	vimeoTestUrls.add('https://vimeo.com/channels/nicetype#/channels/nicetype/27038517');
    	vimeoTestUrls.add('http://vimeo.com/groups/musicvideographers/videos/27038517');
    	vimeoTestUrls.add('https://vimeo.com/groups/musicvideographers/videos/27038517');
    	
		// Add time
		vimeoTestUrls.add('http://vimeo.com/27038517#t=3');
    	vimeoTestUrls.add('https://player.vimeo.com/video/27038517#t=3');
    	vimeoTestUrls.add('https://vimeo.com/channels/nicetype#/channels/nicetype/27038517#t=3');
    	vimeoTestUrls.add('http://vimeo.com/groups/musicvideographers/videos/27038517#t=3');
    	
    	vimeoTestUrls.add('http://vimeo.com/27038517?prm');
        vimeoTestUrls.add('https://player.vimeo.com/video/27038517?prm');
        vimeoTestUrls.add('https://vimeo.com/channels/nicetype#/channels/nicetype/27038517?prm');
        vimeoTestUrls.add('http://vimeo.com/groups/musicvideographers/videos/27038517?prm');
        vimeoTestUrls.add('http://vimeo.com/groups/musicvideographers/videos/27038517?prm#t=9');
    
    	for (String u: vimeoTestUrls)
    	{
    		System.debug('Parsed '+u+' got: '+ uw_HelperMethods.parseVimeoVideoIdPR(u));
    	}	
    }
    
    
    public static List<SelectOption> getPickListValues(Sobject describeObj, String picklistName)
    {
    	Schema.sObjectType sobjectType = describeObj.getSObjectType(); //get the sobject Type
    	Schema.DescribeSObjectResult sobjectDescribe = sobjectType.getDescribe(); //describe the Object
      	Map<String, Schema.SObjectField> fieldMap = sobjectDescribe.fields.getMap(); //get a map of fields for the Object
      	List<Schema.PicklistEntry> picklistValues = fieldMap.get(picklistName).getDescribe().getPickListValues();
		
		List<SelectOption> selectOptions = new List<SelectOption>();
			
		for (Schema.PicklistEntry ple: picklistValues)
		{
			selectOptions.add(new SelectOption(ple.getValue(), ple.getLabel()));
		}
		return selectOptions;
    }

    public static Set<Id> makeIdSet(List<SObject> soList) {
    	Set<Id> soSet = new Set<Id>();
    	for (SObject so:soList) {
    		soSet.add(so.Id);
    	}
    	return soSet;
    }
    
    public static Set<Id> makeIdSet(List<SObject> soList, String idName) {
        Set<Id> soSet = new Set<Id>();
        for (SObject so:soList) {
            soSet.add((Id)so.get(idName));
        }
        return soSet;
    }

    public static Set<string> makeIdSet(List<SObject> soList, String idName, String link) {
        Set<string> soSet = new Set<string>();
        for (SObject so:soList) {
            soSet.add((String)so.get(idName));
        }
        return soSet;
    }

    public static Set<String> makeStringSetFromMap(Map<Id, SObject> idMap, String fieldName) {
    	Set<String> idSet = new Set<String>();
    	List<SObject> soList = idMap.values();
    	for (SObject so:soList) {
    		idSet.add((String)so.get(fieldName));
    	}
    	
    	return idSet;
    }

    public static Map<Id, SObject> makeMap(List<SObject> soList) {
        Map<Id, SObject> soMap = new Map<Id, SObject>();
        for (SObject so:soList) {
            soMap.put(so.Id, so);
        }
        return soMap;       
    }
    public static Map<Id, SObject> makeMap(List<SObject> soList, String idName) {
        Map<Id, SObject> soMap = new Map<Id, SObject>();
        for (SObject so:soList) {
            soMap.put((Id)so.get(idName), so);
        }
        return soMap;       
    }

    public class MapDiffs {
    	public Set<Id> inCollection1Only;
    	public Set<Id> inCollection2Only;
    	public Set<Id> inBothCollections;
    	
    	public MapDiffs() {
    		inCollection1Only = new Set<Id>();
    		inCollection2Only = new Set<Id>();
    		inBothCollections = new Set<Id>();
    	}
    } 

    public static MapDiffs compareMapList(Map<Id, SObject> map1, List<SObject> list2) {
        MapDiffs md = new MapDiffs();

        Set<Id> set1 = map1.keySet();

        // first iterate over list2
        for (SObject so2:list2) {
            if (map1.containsKey(so2.Id)) {
                system.debug('compareMapList: contains true: '+so2.Id);
                md.inBothCollections.add(so2.Id);
                set1.remove(so2.Id);
            } else {
                system.debug('compareMapList: contains false: '+so2.Id);
                md.inCollection2Only.add(so2.Id);
            }
        }
        // play whatever is left into map1only
        for (Id soId1:set1) {
            md.inCollection1Only.add(soId1);
        }
        system.debug('compareMapList: inCollection1Only: '+md.inCollection1Only);
        system.debug('compareMapList: inCollection2Only: '+md.inCollection2Only);
        system.debug('compareMapList: inBothCollections: '+md.inBothCollections);
        return md;
    }

    public static MapDiffs compareMapMap(Map<Id, SObject> map1, Map<Id, SObject> map2) {
        MapDiffs md = new MapDiffs();

        Set<Id> set1 = map1.keySet();
        Set<Id> set2 = map2.keySet();

        // first iterate over list2
        for (Id id2:set2) {
            if (map1.containsKey(id2)) {
                system.debug('compareMapList: contains true: '+id2);
                md.inBothCollections.add(id2);
                set1.remove(id2);
            } else {
                system.debug('compareMapList: contains false: '+id2);
                md.inCollection2Only.add(id2);
            }
        }
        // play whatever is left into map1only
        for (Id soId1:set1) {
            md.inCollection1Only.add(soId1);
        }
        system.debug('compareMapList: inCollection1Only: '+md.inCollection1Only);
        system.debug('compareMapList: inCollection2Only: '+md.inCollection2Only);
        system.debug('compareMapList: inBothCollections: '+md.inBothCollections);
        return md;
    }

    public static TestMethod void  testHelperMethods()
    {
        String id18Char = '00DA0000000gWvLAAA';
        String id15Char = '00DA0000000gWvL';
        String id15CharDiff = '00DA0000000gWvK';
        
        System.assert(uw_HelperMethods.valueIsNull(null), 'Id should be NULL');
        System.assert(uw_HelperMethods.valueIsNull(''),'Id should be NULL');
        System.assert(!uw_HelperMethods.valueIsNull('Not NULL'),'Id should NOT be NULL');
        System.assert(uw_HelperMethods.idsAreEqual(id18Char,id18Char),'Id should be equal');
        System.assert(uw_HelperMethods.idsAreEqual(id15Char,id15Char),'Id should be equal');
        System.assert(uw_HelperMethods.idsAreEqual(id15Char,id18Char),'Id should be equal');
        System.assert(uw_HelperMethods.idsAreEqual(id18Char,id15Char),'Id should be equal');
        System.assert(!uw_HelperMethods.idsAreEqual(id18Char,id15CharDiff),'Id should be different');
        System.assert(!uw_HelperMethods.idsAreEqual(id15Char,id15CharDiff),'Id should be different');
        System.assert(!uw_HelperMethods.idsAreEqual(null,id15CharDiff),'Null Id should be different');
        System.assert(!uw_HelperMethods.idsAreEqual(id15CharDiff,null),'Null Id should be different');
        System.assert(uw_HelperMethods.idsAreEqual(null,null),'Null Ids should be the same');
        
        uw_HelperMethods.isProductionOrg();
        uw_HelperMethods.isSandboxOrg();
        // HelperMethods.isSystemAdminUser();
        
        // should be true as both are same
        String userId = UserInfo.getUserId();
        User user1 = [SELECT Id FROM User WHERE Id=:userId];
        system.assert(uw_HelperMethods.userIsOwner(userId));
        system.assert(!uw_HelperMethods.userIsOwner('005Lx000000IdIF'));
        system.assert(!uw_HelperMethods.userIsOwner(null));
        
        // should be false as userid never equals orgid
        system.assert(!uw_HelperMethods.userIsOwner(UserInfo.getOrganizationId()));
  
  
        List<SObject> testList = new List<SObject>();
        System.assert(uw_HelperMethods.listIsNull(null),'Null List should be null!');
        System.assert(uw_HelperMethods.listIsNull(testList),'Empty List should be null!');
        testList.add((Sobject)(new uw_Brand__c()));
        System.assert(!uw_HelperMethods.listIsNull(testList),'Populated List should not be null!');
        
        uw_HelperMethods.isSystemAdminUser();
        
         uw_Asset__c descObj = new uw_Asset__c();
         Sobject sObj = (Sobject)descObj;
        uw_HelperMethods.getPickListValues(sObj,'Media_Channel_1__c');

/*
        system.RunAs(user1) {
            uw_BET__c bet1 = new uw_BET__c(Name='testbetxyz', category__c='Foods');
            insert bet1;
            uw_BET__Share betsh1 = new uw_BET__Share();
            betsh1.ParentId=bet1.Id;
            betsh1.UserOrGroupId=userId;
            betsh1.AccessLevel='Read';
            insert betsh1;          
            system.assert(uw_HelperMethods.isBETReadOnly(bet1.Id));
            betsh1.AccessLevel = 'Edit';
            update betsh1;
            
            system.assert(!uw_HelperMethods.isBETReadOnly(bet1.Id));            
        }
*/
    }
    
    static private testmethod void testMakeMethods() {
        // Create two objects
        ContentVersion cv1 = uw_UnitTestDataFactory.initContentVersion();
        ContentVersion cv2 = uw_UnitTestDataFactory.initContentVersion();
        // add to a list
        List<ContentVersion> cvs = new List<ContentVersion>();
        cvs.add(cv1);
        cvs.add(cv2);
        // make a set from the list
        Set<Id> cvSet = uw_HelperMethods.makeIdSet(cvs);
        system.assert(cvSet != null);
        system.assertEquals(cvs.size(),cvSet.size());
        system.assert(cvSet.contains(cv1.Id));
        system.assert(cvSet.contains(cv2.Id));
        // use the set to query the data
        List<ContentVersion> cvList = [SELECT Id FROM ContentVersion WHERE Id IN :cvSet];
        system.assert(cvList!=null);
        system.assertEquals(cvSet.size(), cvList.size());   

        // make 4 more opjects
        ContentVersion cv3 = uw_UnitTestDataFactory.initContentVersion();
        ContentVersion cv4 = uw_UnitTestDataFactory.initContentVersion();
        ContentVersion cv5 = uw_UnitTestDataFactory.initContentVersion();
        ContentVersion cv6 = uw_UnitTestDataFactory.initContentVersion();
            	
        // add some of these values to a list (1,3,4,5)
        List<ContentVersion> cvList2 = new List<ContentVersion>();
        cvlist2.add(cv1);
        cvList2.add(cv3);
        cvList2.add(cv4);
        cvList2.add(cv5);
        system.debug('cv1: '+cv1);
        system.debug('cv2: '+cv2);
        system.debug('cv3: '+cv3);
        system.debug('cv4: '+cv4);
        system.debug('cv5: '+cv5);
        system.debug('cv6: '+cv6);
        
        // add some to our map(1,2,3,6)
        Map<Id, ContentVersion> map2 = new Map<Id, ContentVersion>();
        map2.put(cv1.Id, cv1);
        map2.put(cv2.Id, cv2);
        map2.put(cv3.Id, cv3);
        map2.put(cv6.Id, cv6);
        
        //Added by Dinesh Acharya - for BET 2.0 development for controller named as uw_VFC_AddMembersToBET
        List<Schema.FieldSetMember> fieldset = getFieldSet('BET_Members_to_add', 'User');
               
        // now test the methods
        Set<Id> cvSet2 = uw_HelperMethods.makeIdSet(cvList2, 'Id');
        system.assert(cvSet2 != null);
        system.assertEquals(cvList2.size(), cvset2.size());
        system.assert(cvSet2.contains(cv1.Id));
        system.assert(cvSet2.contains(cv3.Id));
        system.assert(cvSet2.contains(cv4.Id));
        system.assert(cvSet2.contains(cv5.Id));
               
        Map<Id, SObject> mapFrom2 = uw_HelperMethods.makeMap(cvList2);
        system.assert(mapFrom2 != null);
        system.assert(mapFrom2.containsKey(cv1.Id));
        system.assert(mapFrom2.containsKey(cv3.Id));
        system.assert(mapFrom2.containsKey(cv4.Id));
        system.assert(mapFrom2.containsKey(cv5.Id));
        
        // now do the diff
        uw_HelperMethods.MapDiffs md = uw_HelperMethods.compareMapList(map2, cvList2);
        system.assert(md != null);
        system.assert(md.inCollection1Only != null);
        system.assert(md.inCollection2Only != null);
        system.assert(md.inBothCollections != null);
        system.debug('md.inCollection1Only: '+md.inCollection1Only);
        system.debug('md.inCollection2Only: '+md.inCollection2Only);
        system.debug('md.inBothCollections: '+md.inBothCollections);

        // 1,2,3,6 against 1,3,4,5
        // 2,6
        system.assertEquals(2, md.inCollection1Only.size());
        system.assert(md.inCollection1Only.contains(cv2.Id));
        system.assert(md.inCollection1Only.contains(cv6.Id));
        // 4,5
        system.assertEquals(2, md.inCollection2Only.size());
        system.assert(md.inCollection2Only.contains(cv4.Id));
        system.assert(md.inCollection2Only.contains(cv5.Id));
        // 1,3
        system.assertEquals(2, md.inBothCollections.size());
        system.assert(md.inBothCollections.contains(cv1.Id));
        system.assert(md.inBothCollections.contains(cv3.Id));

        // do a quick check for an identical
        md = uw_HelperMethods.compareMapList(mapFrom2, cvList2);
        system.assertEquals(0, md.inCollection1Only.size());
        system.assertEquals(0, md.inCollection2Only.size());
        system.assertEquals(4, md.inBothCollections.size());
        
    }
    
}