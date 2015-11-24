public with sharing class isll_ReturnUrlExtention {
	
	public isll_ReturnUrlExtention(ApexPages.StandardController controller) {
		    
    }
    
    public isll_ReturnUrlExtention(isll_CmsContentComponentController controller){
    	
    }
    
    public isll_ReturnUrlExtention(isll_SustainExpComponentController controller){
    	
    }
    
    public isll_ReturnUrlExtention(isll_ModeratorComponentController controller){
    	
    }
    
    public isll_ReturnUrlExtention(isll_EditPageContentController controller){
    	
    }
    
    public isll_ReturnUrlExtention(isll_AdditionalContentController controller){
    	
    }
    
    public isll_ReturnUrlExtention(isll_ArticleComponentController controller){
    	
    }
    
    public isll_ReturnUrlExtention(isll_USLPBrandTableComponentController controller){
    	
    }
    
    
    public isll_ReturnUrlExtention() {
    	
    }
    
    public String getBackUrl(){
    	return apexpages.currentpage().getURL();
    }
    
    public PageReference extCancel(){
    	PageReference res = null;
    	
    	String retPage = ApexPages.currentPage().getParameters().get('returnPage');
    	
    	if(retPage != null && retPage != ''){
    		res = new PageReference(retPage);
    	}
    	return res;
    }
}