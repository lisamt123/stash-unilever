/******************************************************************************************************
Class Name      :       RedirectArticle 
Class Desc.     :       Controller class for VF page: RedirectEditArticle
Author          :       Accenture UK

Change History
****************
Date          Author       version             Description                       Requested By       Tag
--------------------------------------------------------------------------------------------------------------------------
05-Oct-2012   Accenture-UK  0.01            Initial build of class                 Unilever
13-Aug-2013   IDC-Asif      0.02            Formatted code of entire class         Unilever
13-Aug-2013   IDC-Asif      0.03            Added logic to form the URL for        Unilever         T01
                                            new recordtype "Home Page Article"      
***************************************************************************************************************************/
public class uw_RedirectArticle {
 
private ApexPages.StandardController controller;
public String retURL {get; set;}
public String saveNewURL {get; set;}
public String rType {get; set;}
public String cancelURL {get; set;}
public String ent {get; set;}
public String confirmationToken {get; set;}
public String accountID {get; set;}
public String contactID {get; set;}

public uw_RedirectArticle(ApexPages.StandardController controller) {
    this.controller = controller;
    retURL = ApexPages.currentPage().getParameters().get('retURL');
    rType = ApexPages.currentPage().getParameters().get('RecordType');
    cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
    ent = ApexPages.currentPage().getParameters().get('ent');
    confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
    saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
    accountID = ApexPages.currentPage().getParameters().get('def_account_id');
    contactID = ApexPages.currentPage().getParameters().get('def_contact_id');
}

public PageReference redirect() {
    PageReference returnURL;
    // Redirect if Record Type corresponds to custom VisualForce page
    string recordtype;
    try{
        recordtype = [select name from RecordType where id = :rType and SobjectType = 'Article__c' limit 1].name;
    }
    catch(exception e){
    
    }
    system.debug('MFRT' + recordtype);
    if(recordtype == 'Brand Centre Article') {
        returnURL = new PageReference('/apex/ArticleDetail?RecordType=' + rType + '&retURL=' + retURL + '&ent=' + ent);
        returnURL.setRedirect(true); 
        return returnURL;
    }
    else if(recordtype == 'Brilliant Example'){
        returnURL = new PageReference('/apex/BrilliantExampleArticle?RecordType='+ rType + '&retURL=' + retURL + '&ent=' + ent);
        returnURL.setRedirect(true); 
        return returnURL;
    }
    //------------------------------------------------------<T01>
    else if(recordtype == 'Home Page Article'){
        returnURL = new PageReference('/apex/HomePageArticle?RecordType='+ rType + '&retURL=' + retURL + '&ent=' + ent);
        returnURL.setRedirect(true); 
        return returnURL;
    }
    //------------------------------------------------------</T01>    
    return null;
}//end method redirect

public PageReference redirectedit() {    
    Article__c a;
    try {
        a = [Select id, recordtypeid From Article__c Where Id = :ApexPages.currentPage().getParameters().get('id')];
    }
    catch(exception e){
    
    }
    PageReference returnURL;
    string recordtype;    
    // Redirect if Record Type corresponds to custom VisualForce page
    try {
        recordtype = [select name from RecordType where id = :a.recordtypeid and SobjectType = 'Article__c' limit 1].name;
    }
    catch(exception e){
    
    }
    if(recordtype == 'Brand Centre Article') {
        returnURL = new PageReference('/apex/ArticleDetail');
        returnURL.getParameters().put('id', a.id);
        returnURL.setRedirect(true); 
        return returnURL;
    }
    else if(recordtype == 'Brilliant Example') {
        returnURL = new PageReference('/apex/BrilliantExampleArticle');
        returnURL.getParameters().put('id', a.id);
        returnURL.setRedirect(true); 
        return returnURL;
    }  
    //------------------------------------------------------<T01>
    else if(recordtype == 'Home Page Article') {
        returnURL = new PageReference('/apex/HomePageArticle');
        returnURL.getParameters().put('id', a.id);
        returnURL.setRedirect(true); 
        return returnURL;
    }
    //------------------------------------------------------</T01>          
    return null;            
}

private static testmethod void test_basic() {
    Article__c article = new Article__c(name = 'test');
    insert article;  
    ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(article);
    uw_RedirectArticle ra = new uw_RedirectArticle (sc);
    ra.redirect();
    ra.redirectedit();
    }
    
private static testmethod void test_brandcenterarticle()
{
Test.startTest();
RecordType rt =[Select Id From RecordType where Name ='Brand Centre Article' and SobjectType ='Article__C' limit 1]; 
Article__c article = new Article__c(name = 'test',recordtypeid=rt.id); 
insert article; 
ApexPages.PageReference ref = new ApexPages.PageReference('apex/xxxxxx?id='+article.id+'&RecordType='+rt.id+'&retURL=&cancelURL=&ent=&save_new_url=&def_account_id=&def_contact_id=&_CONFIRMATIONTOKEN=');
system.test.setCurrentPage(ref) ;
ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(article); 
uw_RedirectArticle ra = new uw_RedirectArticle (sc); 
ra.redirect(); 
ra.redirectedit(); 
Test.stopTest();
}
/** below lines of code have been commented since tools is deprecated
private static testmethod void test_brilliantexample()
{
Test.startTest();
RecordType rt =[Select Id From RecordType where Name ='Brilliant Example' and SobjectType ='Article__C' limit 1]; 
Article__c article = new Article__c(name = 'test',recordtypeid=rt.id); 
insert article; 
ApexPages.PageReference ref = new ApexPages.PageReference('apex/xxxxxx?id='+article.id+'&RecordType='+rt.id+'&retURL=&cancelURL=&ent=&save_new_url=&def_account_id=&def_contact_id=&_CONFIRMATIONTOKEN=');
system.test.setCurrentPage(ref) ;
ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(article); 
uw_RedirectArticle ra = new uw_RedirectArticle (sc); 
ra.redirect(); 
ra.redirectedit(); 
Test.stopTest();
}
**/

private static testmethod void test_homepagearticle()
{
Test.startTest();
RecordType rt =[Select Id From RecordType where Name ='Home Page Article' and SobjectType ='Article__C' limit 1]; 
Article__c article = new Article__c(name = 'test',recordtypeid=rt.id); 
insert article; 
ApexPages.PageReference ref = new ApexPages.PageReference('apex/xxxxxx?id='+article.id+'&RecordType='+rt.id+'&retURL=&cancelURL=&ent=&save_new_url=&def_account_id=&def_contact_id=&_CONFIRMATIONTOKEN=');
system.test.setCurrentPage(ref) ;
ApexPages.Standardcontroller sc = new ApexPages.Standardcontroller(article); 
uw_RedirectArticle ra = new uw_RedirectArticle (sc); 
ra.redirect(); 
ra.redirectedit(); 
Test.stopTest();
}

}//end class