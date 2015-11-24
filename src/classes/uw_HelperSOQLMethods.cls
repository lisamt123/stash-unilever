public with sharing class uw_HelperSOQLMethods {
    public static String feedItemsToWhereClause(String op, List<FeedItem> fiList) {
        system.debug('feedItemsToWhereClause: entry: ');
        Boolean firstItem = true;
        String whereClause = '';
        
        for (FeedItem fi:fiList) {
           system.debug('feedItemsToWhereClause: fi: '+fi);   
        
            if (fi.LinkUrl != null) {
                
                String clause = '';
                
                String lowerCase = fi.LinkUrl.toLowerCase(fi.LinkUrl);
                system.debug('lowerCase: '+lowerCase);
                try {
                    if (lowerCase.contains('www.youtube.com')) {
                        String id = getYouTubeId(fi.LinkUrl);
                        if (id != null) {
                        	clause = 'url_of_asset__c LIKE \'%' + id + '%\'';
                        } else {
                        	// do nothing
                        }
                        /*
                        List<String> urlParts = fi.LinkUrl.split('//',2);
                        system.debug('urlParts: '+urlParts);
                        if (urlParts.size() == 2) {
                            List<String> urlSubParts = urlParts[1].split('v=',2);
                            system.debug('urlSubParts: '+urlSubParts);
                            if (urlSubParts.size() == 2) {
                            	List<String> urlSubSubParts = urlSubParts[1].split('&',2);
                            	system.debug('urlSubSubParts: '+urlSubSubParts);
                            	if (urlSubSubParts.size() >= 2) {
                                    clause = 'url_of_asset__c LIKE \'%' + urlSubSubParts[0] + '%\'';                                                                                           		
                            	}
                            }
                        }
                        */
                    } else if (lowercase.contains('vimeo.com')) {
                        List<String> urlParts = fi.LinkUrl.split('//',2);
                        system.debug('urlParts: '+urlParts);
                        if (urlParts.size() == 2) {
                            List<String> urlSubParts = urlParts[1].split('vimeo.com/',2);
                            system.debug('urlSubParts: '+urlSubParts);
                            if (urlSubParts.size() == 2) {
                                clause = 'url_of_asset__c LIKE \'%' + urlSubParts[1] + '%\'';                                                               
                            }
                        }                    	
                    } else {
                        clause = 'url_of_asset__c = \'' + fi.LinkUrl + '\'';                        
                    }
                    system.debug('feedItemsToWhereClause: clause: '+clause);   
                	
                } catch (Exception e) {
                    system.debug('exception: '+e);                	
                }
                
                if (clause != '') {
                    if (firstItem) {
                        firstItem = false;
                    } else {
                        whereClause += ' ' + op + ' ';
                    }
                    whereClause += clause;                  
                }
            }
        }
        
        system.debug('feedItemsToWhereClause: exit: '+whereClause);
        return whereClause;
    }
    
    public static String parseURL(String url) {
    	String s = '';
    	Pattern myPattern = Pattern.compile('#^(?:https?://)?(?:www\\.)?(?:youtu\\.be/|youtube\\.com(?:/embed/|/v/|/watch\\?v=|/watch\\?.+&v=))([\\w-]{11})(?:.+)?$#x');
    	// '/^.*((youtu.be\\/)|(v\\/)|(\\/u\\/\\w\\/)|(embed\\/)|(watch\\?))\\??v?=?([^#\\&\\?]*).*/');
        Matcher myMatcher = myPattern.matcher('https://www.youtube.com/watch?v=xW5abat5NEU');
        if (myMatcher.matches()) {
        	for (integer i=0; i < myMatcher.groupCount(); i++) {
        		system.debug(i+':'+myMatcher.group());
        	}
        }
        return s;
    }
    
    // simplistic method that finds the youtube id
    // assumes <url>?<p1>=<v1>&<p2>=<v2>
    private static String getAttrValue(String URL) {
        system.debug('getAttrValue: entry');
        String id = null;
        // first remove the url part
        List<String> params = URL.split('\\?',-1);
        system.debug('params: '+params);
        if (params.size() >= 2) {
            // second split up the params
            List<String> pParts = params[1].split('&',-1);
            system.debug('pParts: '+pParts);
            for (String p:pParts) {
                // last, for each param, split into attr and value
                List<String> attrValue = p.split('=',-1);
                system.debug('attrValue: '+attrValue);
                if (attrValue.size()==2) {
                    // The v param has the id
                    if (attrValue[0] == 'v') {
                       id = attrValue[1];   
                    }
                }
            }
        }
        return id;    	
    }
    
    // could be that we have http://www.youtube.com/v/<id>?version=3&autohide=1
    private static String getURLValue(String URL) {
        system.debug('getURLValue: entry');
    	String id = null;
    	String lastPath = null;
    	
    	List<String> paths = URL.split('/',-1);
    	system.debug('paths: '+paths);
        Integer size = paths.size();
        if (size >= 2) {
        	// look if we had /v/ before the last
            if (paths[size-2] == 'v') {
                lastPath = paths[size-1];            	
            }
        }
        
        if (lastPath != null) {
        	system.debug('lastPath: '+lastPath);
            List<String> params = lastPath.split('\\?',-1);
            system.debug('params: '+params);
            size = params.size();
            if (size >= 2) {
            	id = params[0];
            }
        }
    	
    	system.debug('getURLValue: id: '+id);
    	return id;
    }

    // http://youtu.be/-wtIMTCHWuI
    private static String getYouTuDotBe(String URL) {
        system.debug('getYouTuDotBe: entry');
        String id = null;
        
        String lowerCase = URL.toLowerCase();
        if (lowerCase.contains('youtu.be')) {
        	List<String> paths = URL.split('/');
        	Integer size =  paths.size();
        	if (size >= 2) {
        		id = paths[size-1];
        	}
        }
        
        system.debug('getYouTuDotBe: id: '+id);
        return id;    	
    }

    // could be that we have http://www.youtube.com/oembed?url=http%3A//www.youtube.com/watch?v%3D-wtIMTCHWuI&format=json
    // this has \x36 style characters as you can't have some special charcaters in a paramter.
    private static String getEmbededValue(String URL) {
        system.debug('getEmbededValue: entry');
        String id = null;
        String embededURL = null;
        
        // first remove the url part
        List<String> params = URL.split('\\?',-1);
        system.debug('params: '+params);
        if (params.size() >= 2) {
            // second split up the params
            for (String p:params) {
                // last, for each param, split into attr and value
                List<String> attrValue = p.split('=',-1);
                system.debug('attrValue: '+attrValue);
                if (attrValue.size()==2) {
                    // The v param has the id
                    if (attrValue[0].startsWith('v%3D')) {
                        List<String> parts = attrValue[0].split('&',-1);
                        system.debug('parts: '+parts);
                        if (parts.size() == 2) {
                        	List<String> subParts = parts[0].split('v%3D',-1);
                            system.debug('subParts: '+subParts);
                        	if (subParts.size() == 2) {
                        		id = subParts[1];
                        	}
                        }
                    }
                }
            }

        }
        system.debug('getEmbededValue: id: '+id);
        return id;
    }
    
    // try various permutations, with the most obvious first.
    public static String getYouTubeId(String URL) {
        String id = getAttrValue(URL);
        if (id == null)
            id = getURLValue(URL);
        if (id == null) 
            id = getYouTuDotBe(URL);
        if (id == null) {
        	id = getEmbededValue(URL);
        }
        
        return id;
    }
    
    public static testmethod void test_feedItemsToWhereClause() {
        FeedItem fi1 = new FeedItem(ParentId='0F9L00000008VPNKA2', Type='LinkPost', LinkUrl='http://www.youtube.com/watch?v=xW5abat5NEU', 
                                    ContentData=null, RelatedRecordId=null, Body='funny from olympics', Title='Bond_and_Queen', 
                                    ContentDescription=null, ContentFileName=null);
        List<FeedItem> fiList = new List<FeedItem>();
        fiList.add(fi1);
        String s = uw_HelperSOQLMethods.feedItemsToWhereClause('OR', fiList);
        system.assertEquals('url_of_asset__c LIKE \'%xW5abat5NEU%\'', s);

        FeedItem fi2 = new FeedItem(ParentId='0F9L00000008VPNKA2', Type='LinkPost', LinkUrl='http://www.youtube.com/watch?v=xW5abat5NEV', 
                                    ContentData=null, RelatedRecordId=null, Body='funny from olympics', Title='Bond_and_Queen', 
                                    ContentDescription=null, ContentFileName=null);
        fiList.add(fi2);
        s = uw_HelperSOQLMethods.feedItemsToWhereClause('OR', fiList);
        system.assertEquals('url_of_asset__c LIKE \'%xW5abat5NEU%\' OR url_of_asset__c LIKE \'%xW5abat5NEV%\'', s);
    
        FeedItem fi3 = new FeedItem(ParentId='0F9L00000008VPNKA2', Type='LinkPost', LinkUrl='http://vimeo.com/5471619', 
                                    ContentData=null, RelatedRecordId=null, Body='funny from olympics', Title='Bond_and_Queen', 
                                    ContentDescription=null, ContentFileName=null);
        fiList.add(fi3);
        s = uw_HelperSOQLMethods.feedItemsToWhereClause('OR', fiList);
        system.assertEquals('url_of_asset__c LIKE \'%xW5abat5NEU%\' OR url_of_asset__c LIKE \'%xW5abat5NEV%\' OR url_of_asset__c LIKE \'%5471619%\'', s);
            
    }
    
    // formats I got from 
    // http://www.youtube.com/watch?v=-wtIMTCHWuI
    // http://www.youtube.com/v/-wtIMTCHWuI?version=3&autohide=1
    // http://youtu.be/-wtIMTCHWuI
    // http://www.youtube.com/oembed?url=http%3A//www.youtube.com/watch?v%3D-wtIMTCHWuI&format=json
    //
    public static testmethod void test_getYouTubeId() {
        String url1 = 'http://www.youtube.com/watch?v=xW5abat5NEU';
        system.assertEquals('xW5abat5NEU', uw_HelperSOQLMethods.getYouTubeId(url1));
        String url2 = 'http://www.youtube.com/v/-wtIMTCHWuI?version=3&autohide=1';
        system.assertEquals('-wtIMTCHWuI', uw_HelperSOQLMethods.getYouTubeId(url2));
        String url3 = 'http://youtu.be/-wtIMTCHWuI';
        system.assertEquals('-wtIMTCHWuI', uw_HelperSOQLMethods.getYouTubeId(url3));
        String url4 = 'http://www.youtube.com/oembed?url=http%3A//www.youtube.com/watch?v%3D-wtIMTCHWuI&format=json';
        system.assertEquals('-wtIMTCHWuI', uw_HelperSOQLMethods.getYouTubeId(url4));
        
        // now try some real examples
        String urlA = 'https://www.youtube.com/watch?v=KIiUqfxFttM';
        system.assertEquals('KIiUqfxFttM', uw_HelperSOQLMethods.getYouTubeId(urlA));
        String urlB = 'https://www.youtube.com/watch?v=21cnnmSS3-4&feature=relmfu';
        system.assertEquals('21cnnmSS3-4', uw_HelperSOQLMethods.getYouTubeId(urlB));
        String urlC = 'http://m.youtube.com/watch?gl=US&hl=en&client=mv-google&v=A5DZB5Ih84w';
        system.assertEquals('A5DZB5Ih84w', uw_HelperSOQLMethods.getYouTubeId(urlC));
        
    }
}