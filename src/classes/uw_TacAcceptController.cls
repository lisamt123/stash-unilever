public with sharing class uw_TacAcceptController {
    private String userName {get {
        if (null == userName) {
            userName = ApexPages.currentPage().getParameters().get('un');
            system.debug('username: '+userName);
        }
        return userName;
    } set;}
    
   private String encodeString(String source) {
        system.debug('encodeString: source: '+source);
        String target = source.replace('$', '%24');
        target = target.replace('&', '%26');
        target = target.replace('+', '%2B');
        target = target.replace(',', '%2C');
        target = target.replace('/', '%2F');
        target = target.replace(':', '%3A');
        target = target.replace(';', '%3B');
        target = target.replace('=', '%3D');
        target = target.replace('?', '%3F');
        target = target.replace('@', '%40');
        
        return target;
    }
    
    public PageReference getLogonPage() {
        Pagereference pr = null;
        String url;
        
        system.debug('getLogonPage: entry');
        String logonServer = uw_HelperMethods.getSalesforceLogonServer();
        if (userName != null) {
            url = logonServer+'?&un='+encodeString(userName);
        } else {
            url = logonServer;
        }
        
        return new PageReference(url);      
    }

    public PageReference doAction() {
        return getLogonPage();
    }
}