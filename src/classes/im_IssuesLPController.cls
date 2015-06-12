/***
Class: im_IssuesLPController
Description: Conrtoller for the Issues LP Page, 
**/

public with sharing class im_IssuesLPController {
    
    public string Introduction {
        get {
            im_TabSettings__c ts = im_TabSettings__c.getInstance('Issues introduction');
            return ts.Value__c;
        }
        
        private set;
    }
    
    public string DashboardId {
        get {
            im_TabSettings__c ts = im_TabSettings__c.getInstance('Issues Dashboard');
            return ts.Value__c;
        }
        
        private set;
    }
    
    public list<CustomLink> Links {get; private set;}
    
    public string SelectedLink {get; set;}
    public boolean IsSelectedLinkExternal {get; set;}


    /**
        The constructor, populates the link list.
    **/
    public im_IssuesLPController(){
        Links = new list<CustomLink>();
        
        for(im_TabCustomLinks__c tcl : [select URL__c, Order__c, ExternalSite__c, Name from im_TabCustomLinks__c order by Order__c LIMIT 5]){
            Links.add(new CustomLink(tcl.URL__c, tcl.Name, tcl.ExternalSite__c));
        }
    }
    
    /**
        converts the selected link in to a page reference
        @return PageReference - page reference containing the selected link
    **/
    public Pagereference OpenLink() {
        string linkPrefix;
        
        if(IsSelectedLinkExternal){
            linkPrefix = 'http://';
        } else {
            linkPrefix = '/';
        }
        Pagereference pr = new Pagereference(linkPrefix + SelectedLink);
        pr.setRedirect(true);
        return pr;
    }
    
    /**
        returns a page reference directing to create new im_issue__c record
        @return PageReference - url to create new im_issue__c
    **/
    public Pagereference NewIssue(){
        Schema.SObjectType sType = Schema.getGlobalDescribe().get('im_Issue__c');
        String issueObjPrefix = sType.getDescribe().getKeyPrefix();        
        Pagereference pr = new Pagereference('/' + issueObjPrefix + '/e');
        return pr;
    }

    /**
        Wrapper class for im_TabCustomLinks__c
    **/
    public class CustomLink{
        public string URL {get; private set;}
        public string LinkText {get; private set;}
        public boolean External {get; private set;}
        
        public CustomLink(string theURL, string theLinkText, boolean isExternal){
            URL = theURL;
            LinkText = theLinkText;
            External = isExternal;
        }
    }
}