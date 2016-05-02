public with sharing class uw_TermsConditionsController 
{
    private Boolean encryptEnabled = true;
    private Boolean noTacRecord {get; set;}
    
    private Boolean tncsAccepted = false;
    
    private Boolean showAcceptErrorMessage = false;
    
    private uw_Terms_Conditions__c termsConditions = null;
    
    private String  encodedToken {get {
       if (null == encodedToken) {
            encodedToken = ApexPages.currentPage().getParameters().get('token');        
            system.debug('encodedToken: '+encodedToken);
       }
       return encodedToken;
    } set;}
    
    private String  decodedToken {get {
       if (null == decodedToken) {
           // this is temporary code until we do the real decode
           // decodedToken = encodedToken;
       }
       return decodedToken;
    } set;} 
    
    private uw_TokenHelper tokenHelper { get {
        if (null == tokenHelper) {
            tokenHelper = new uw_TokenHelper();
        }
        return tokenHelper;
    } set;}
     
    private String entryPoint {
        get {
            if (null == entryPoint) {
                entryPoint = ApexPages.currentPage().getParameters().get('entryPoint');             
                system.debug('entryPoint: '+entryPoint);                
            }
            return entryPoint;
        } set;
    }
    
    public PageReference onLoad() {
        system.debug('onLoad: entry');
        encryptEnabled = true;
        PageReference pr = null;
        
        if (tokenHelper.validate(encodedToken)) {
            system.debug('onLoad: token ok');
            decodedToken = tokenHelper.taCId;
            getTermsConditions();
            
            // if we got the object then do some tests
            if (termsConditions != null) {
                // check for an expired token
                pr = (hasTokenExpired()) ? Page.TermsandConditionsExpired : null;
            }
        } else {
            system.debug('onLoad: token not ok');
            pr = Page.TermsandConditionsExpired;    
        }       
        
    return pr;
    }
    
    //
    // Constructor
    //
    public uw_TermsConditionsController()
    {
        noTacRecord = false;
        if (!encryptEnabled) {
            getTermsConditions();           
        }
    }
    
    public Boolean getTncsAccepted()
    {
        return tncsAccepted;
    }
    
    public Boolean getShowAcceptErrorMessage()
    {
        return showAcceptErrorMessage;
    }
    
    public void setTncsAccepted(Boolean b)
    {
        tncsAccepted = b;
    }
    
    public String contentId {get {
        if (contentId == null) {
            try {
                uw_Custom_Setting__c cs = uw_CustomSettingsManager.getCustomSetting('TERMS_AND_CONDITIONS_ID');
                contentId = cs.Text_Value__c;               
            } catch (Exception e) {
                system.debug('Exception getting Custom Setting TERMS_AND_CONDITIONS_ID: '+e);
            }
        }
        return contentId;
    } set;}

    
    public uw_Terms_Conditions__c getTermsConditions()
    {
        system.debug('getTermsConditions: entry');
        if (null == termsConditions)
        {
            if (!uw_HelperMethods.valueIsNull(decodedToken)) {
                try {
                    system.debug('decodedToken: <'+decodedToken+'>');
                    termsConditions = [Select Status__c, Invitee_Email__c, Invite_Token__c, Invite_Expires__c, Invite_Accepted__c, Id, Bet_Name__c, uw_BET__c, Studio_Chatter_Group__c From uw_Terms_Conditions__c where id = :decodedToken];                                   
                } catch (Exception e) {
                    noTacRecord = true;
                    system.debug('getTermsConditions: TaC record no longer exists: '+e);
                }
            }
        }
        
        return termsConditions;
    }
    
    public void setTermsConditions(uw_Terms_Conditions__c tc)
    {
        termsConditions = tc;   
    }
    
    public PageReference continueOnTnCPage()
    {
        // There is an edge case where the token passed in refers to a TaC record that no longer exists.
        // To prevent wierd error messages that could confuse the user, show the generic error page.
        system.debug('noTacRecord: '+noTacRecord);
        if (noTacRecord) {
            return Page.UnauthorizedTac;
        }
        
        if (!tncsAccepted)
        {
            showAcceptErrorMessage = true;
            return null;
        }
        
        if (getTermsConditions().Status__c == 'Sent')
        {
            system.debug('Status__c: sent');
            // this is expected status
            // Check Expiry date... (OR MAYBE NOT! DONE IN onLoad method)
            
            try {
                termsConditions.Status__c = 'Accepted';
                termsConditions.Invite_Accepted__c = System.now();
                update termsConditions;
            } catch(Exception e){
                System.debug('Error Updating TnC'+e); 
            }
        }
        else
        {
            system.debug('Status__c: '+getTermsConditions().Status__c);
            // We may want to redirect to a different page by tac.status__c
            // If it makes a decision then we get a non-null PageReference
            PageReference prByStatus = showNextPageForCurrentStatus();   
            if (prByStatus != null) {
                system.debug('redirect: '+prByStatus);
                return prByStatus;
            }           
        }
        
        // Check the status of the record
        // Find the Studio Chatter Group from the record
        
        showAcceptErrorMessage = false;
        
        PageReference pr = new PageReference('/apex/TermsAndConditionsAcceptPage'); 
        if (entryPoint == '2') {
            pr = new PageReference('/apex/TermsAndConditionsAcceptPage2'); 
        }
        system.debug('exit: '+pr);
        return pr;
    }
    
    private Boolean hasTokenExpired() {
        Boolean expired = true;
        
        DateTime nowDTM = System.now();
        if (termsConditions.Invite_Expires__c != null) {
            system.debug('hasTokenExpired: TaC='+termsConditions.Invite_Expires__c+' Now='+nowDTM);
            expired = (termsConditions.Invite_Expires__c <= nowDTM) ? true : false;
        }
        
        system.debug('hasTokenExpired: '+expired);
        return expired;
    }
    
    private User getInviteeUser() {
        User u = null;
        
        if (termsConditions.Invitee_Email__c != null) {
            List<User> users = [SELECT Id, UserName FROM USER WHERE email=:termsConditions.Invitee_Email__c];
            if (users.size() == 1) {
               u = users[0];
               system.debug('getInviteeUser: '+u.userName);
            }
        }
        return u;
    }

    private PageReference getAlreadyAcceptedPage() {
        PageReference pr = null;
        
        system.debug('getAlreadyAcceptedPage: entry');
        User u = getInviteeUser();
        if (u != null) {
            if (entryPoint == '1') {
                pr = new PageReference('/TermsandConditionsAlreadyAccepted');               
            } else {
                pr = new PageReference('/TermsandConditionsAlreadyAccepted2');
            }
        } else {
            pr = Page.TermsandConditionsAlreadyAccepted;                        
        }
        return pr;      
    }

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

    private PageReference getLogonPage() {
        Pagereference pr = null;
        
        system.debug('getLogonPage: entry');
        String logonServer = uw_HelperMethods.getSalesforceLogonServer();
        User u = getInviteeUser();
        if (u != null) {
            pr = new PageReference(logonServer+'?&un='+encodeString(u.Username));
        } else {
            pr = new PageReference(logonServer);                        
        }
        return pr;      
    }

    private PageReference getAlreadyAccepted2Page() {
        Pagereference pr = null;
        
        system.debug('getAlreadyAccepted2Page: entry');
        User u = getInviteeUser();
        if (u != null) {
            pr = new PageReference('/TermsAndConditionsAcceptPage2?&un='+encodeString(u.Username));
        } else {
            pr = new PageReference('/TermsAndConditionsAcceptPage2');                        
        }
        return pr;              
    }

    private PageReference showNextPageForCurrentStatus() {
        system.debug('showNextPageForCurrentStatus: entry: status: termsConditions.Status__c');
        PageReference pr = null;
        
        // if we already have accepted then show a special page
        if (termsConditions.Status__c == 'Accepted') {
            pr = getAlreadyAcceptedPage();
        } else if (termsConditions.Status__c == 'Invite Sent') {
            pr = getAlreadyAcceptedPage();
        } else if (termsConditions.Status__c == 'User Enabled') {
            pr = getAlreadyAccepted2Page();
        } else if (termsConditions.Status__c == 'Logged In') {
            pr = getLogonPage();            
        }
        return pr;
    }

    private static testmethod void test_Basic() {
        User u1 = uw_UnitTestDataFactory.initInternalUser('aAlias', 'aEmail@yyy.yyy.com', 'aLastname', 'aEmail@yyy.com');
        
        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Name = 'TERMS_AND_CONDITIONS_ID';
        cs.Text_Value__c = '068c00000005aeJAAQ';
        insert cs;
        system.assert(cs.Id != null);
        
        uw_Custom_Setting__c cs2 = new uw_Custom_Setting__c();
        cs2.Name = 'TOKEN_KEY';
        cs2.Text_Value__c = 'GTq2xh0iIt45Pw8Ij8os+rOJNANxAWjJYRtyfhgnUAQ=';
        insert cs2;
        system.assert(cs2.Id != null);

        uw_Terms_Conditions__c tc = new uw_Terms_Conditions__c();
        tc.Invite_Expires__c = System.now()+1;
        tc.Invitee_Email__c = 'aEmail@yyy.yyy.com';
        tc.Status__c = 'Accepted';
        insert tc;
        system.assert(tc.Id != null);
        
        uw_TokenHelper th = new uw_TokenHelper();
        th.taCId = tc.Id;
        
        String encoded = th.encode();               
        
        Test.setCurrentPage(Page.TermsAndConditions);
        ApexPages.currentPage().getParameters().put('token', encoded);

        uw_TermsConditionsController con = new uw_TermsConditionsController();
        system.assert(con!=null);
        
        con.onLoad();
        tc.Status__c = 'Accepted';
        update tc;
        con.onLoad();

        system.assertEquals(cs.Text_Value__c, con.contentId);
        con.contentId = 'test';
        system.assertEquals('test', con.contentId);
        
        con.tokenHelper.taCId = tc.Id;
        ApexPages.currentPage().getParameters().put('entryPoint','1');
        system.assertEquals('1', con.entryPoint);
        con.continueOnTnCPage();
        
        con.getTncsAccepted();
        con.getShowAcceptErrorMessage();
    
        // try a bad token
        ApexPages.currentPage().getParameters().put('token', 'rubbish');
        con.onLoad();
            
        con.setTermsConditions(tc);
        
        con.noTacRecord = false;
        con.tncsAccepted = false;
        con.continueOnTnCPage();
        
        tc.Status__c = 'Sent';
        update tc;
        
        con.tncsAccepted = true;
        con.continueOnTnCPage();
        ApexPages.currentPage().getParameters().put('entryPoint','2');
        con.continueOnTnCPage();

        User u = con.getInviteeUser();
        con.setTncsAccepted(true);
                
        con.hasTokenExpired();      
    } 
    
     private static testmethod void testGetLogonPage() {
         User u1 = uw_UnitTestDataFactory.initInternalUser('aAlias', 'aEmail@yyy.yyy.com', 'aLastname', 'aEmail@yyy.com');
        
        uw_Custom_Setting__c cs = new uw_Custom_Setting__c();
        cs.Name = 'TERMS_AND_CONDITIONS_ID';
        cs.Text_Value__c = '068c00000005aeJAAQ';
        insert cs;
        system.assert(cs.Id != null);
        
        uw_Custom_Setting__c cs2 = new uw_Custom_Setting__c();
        cs2.Name = 'TOKEN_KEY';
        cs2.Text_Value__c = 'GTq2xh0iIt45Pw8Ij8os+rOJNANxAWjJYRtyfhgnUAQ=';
        insert cs2;
        system.assert(cs2.Id != null);

        uw_Terms_Conditions__c tc = new uw_Terms_Conditions__c();
        tc.Invite_Expires__c = System.now()+1;
        tc.Invitee_Email__c = 'aEmail@yyy.yyy.com';
        tc.Status__c = 'Accepted';
        insert tc;
        
        uw_TermsConditionsController con = new uw_TermsConditionsController();
        system.assert(con!=null);
        
        con.onLoad();
        tc.Status__c = 'Accepted';
        update tc;
        con.onLoad();
        
        con.contentId = 'test';
        system.assertEquals('test', con.contentId);
        
        con.tokenHelper.taCId = tc.Id;
        ApexPages.currentPage().getParameters().put('entryPoint','1');
        system.assertEquals('1', con.entryPoint);
        con.continueOnTnCPage();
        
        con.getTncsAccepted();
        con.getShowAcceptErrorMessage();
    
        // try a bad token
        ApexPages.currentPage().getParameters().put('token', 'rubbish');
        con.onLoad();
            
        con.setTermsConditions(tc);
        
        con.noTacRecord = false;
        con.tncsAccepted = false;
        con.continueOnTnCPage();
        
        tc.Status__c = 'Sent';
        update tc;
        
        con.tncsAccepted = true;
        con.continueOnTnCPage();
        ApexPages.currentPage().getParameters().put('entryPoint','2');
        con.continueOnTnCPage();

        User u = con.getInviteeUser();
        System.runAs(u){
            con.getLogonPage();
            con.getAlreadyAccepted2Page();
        }
        tc.Status__c = 'Invite Sent';
        update tc;
        con.showNextPageForCurrentStatus(); 
        
        tc.Status__c = 'User Enabled';
        update tc; 
        con.showNextPageForCurrentStatus();
        
        tc.Status__c = 'Logged In';
        update tc; 
        con.showNextPageForCurrentStatus();        
     }
     
      
}