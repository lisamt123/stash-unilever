/**
    @Description: This wrapper class will act as a service from the IPM NG application which will be accessed by BET application for various purposes
    @Author: Cognizant Technology
    @Date: 7/7/2015
**/

/*
    This class has been defined as Without Sharing as the methods are invoked via BET Integration service methods which needs to 
    access  all MDO data for Categories and Brands.
*/    
public without sharing class IPM_BETWrapper{  
    
    //Map containing variable to field mapping
    public Map<String,String> wrapperFieldMap = new Map<String,String>{
                                                                            'projectId'=>'Id','projectName'=>'name','targetLaunchDate'=>'IPM_Target_Launch_Dates__c',
                                                                            'pLId'=>'IPM_Project_Leader__c','categoryGroupName'=>'IPM_Category_Group__c',
                                                                            'categoryName'=>'IPM_Category_Text__c','brandPosition'=>'IPM_Brand_Positioning__c'};

    public Id projectId{get;set;}//Id of IPM
    public String projectName{get;set;}//Name of IPM
    public Date targetLaunchDate{get;set;}//Target Launch Date
    public ID pLId{get;set;}//Project Lead Id
    public String categoryGroupName{get;set;}//Category group name from Master Data
    public String categoryName{get;set;}//Category name from Master Data
    public String brandPosition{get;set;}//Brand Position from Master Data
    private static final string BRAND_STATUS_ACTIVE ='active';
    
    /************************************************************
        Purpose: IPM_BETWrapper constructor
        Parameters: - IPM Project record
        Returns: Wrapper instance
    *************************************************************/
    public IPM_BETWrapper(IPM_Project__c project){
        this.projectId = (Id)project.get(wrapperFieldMap.get('projectId'));
        this.projectName = (String)project.get(wrapperFieldMap.get('projectName'));
        this.targetLaunchDate = (date)project.get(wrapperFieldMap.get('targetLaunchDate'));
        this.pLId = (Id)project.get(wrapperFieldMap.get('pLId'));
        if((String)project.get(wrapperFieldMap.get('categoryName'))!=null ){
            string category = (String)project.get(wrapperFieldMap.get('categoryName'));
            List<MDO_Category__c> categoryGroup = [select id, parent_L2__c  from MDO_Category__c where category_type__c = :IPM_ConstantUtils.CATEGORY_TYPE and name = :category LIMIT 1 ];
            if(!categoryGroup.isEmpty()){
                this.categoryGroupName =categoryGroup.get(0).parent_L2__c;
                this.categoryName = categoryGroup.get(0).id; 
            }
        } 
        if((String)project.get(wrapperFieldMap.get('brandPosition'))!=null ){
            string brandPosition = (String)project.get(wrapperFieldMap.get('brandPosition')); 
            list<MDO_BrandPosition__c> lstBP = [select id from MDO_BrandPosition__c where name=:brandPosition and status__c = :BRAND_STATUS_ACTIVE  LIMIT 1 ];   
            if(!lstBP .isEmpty()){
                this.brandPosition = lstBP .get(0).id;
            }
        }
    }
}