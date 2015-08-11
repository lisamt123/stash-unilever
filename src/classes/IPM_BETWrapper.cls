/**
    @Description: This wrapper class will act as a service from the IPM NG application which will be accessed by BET application for various purposes
    @Author: Cognizant Technology
    @Date: 7/7/2015
**/
public class IPM_BETWrapper{ 
    
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
    	this.categoryGroupName = (String)project.get(wrapperFieldMap.get('categoryGroupName'));
    	this.categoryName = (String)project.get(wrapperFieldMap.get('categoryName'));
    	this.brandPosition = (String)project.get(wrapperFieldMap.get('brandPosition'));    
    }
}