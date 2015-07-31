/*************************************************************************************
Name : BET_BETWrapper

Purpose : This wrapper class will act as a service from the IPM NG application which will be accessed by BET application for various purposes. 
          Below are the parameters which will be exposed by the Wrapper class. 


History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      k.szepietowski@polsource.com  31-07-2015  Initial
*************************************************************************************/

public with sharing class IPM_BETWrapper {
	
    //Id of IPM
    public Id ProjectId{get;set;}
    
    //Name of IPM
    public String ProjectName{get;set;}
    
    //Target Launch Date
    public Date TLD{get;set;}
    
    //Project Lead Id
    public Id PLId{get;set;}
    
    //Category group name from Master Data
    public String CategoryGroupName{get;set;}
    
    //Category name from Master Data
    public String CategoryName{get;set;}
    
    //Brand Position from Master Data
    public String BrandPosition{get;set;}
    
    //Unique name for the project
    public String ProjectUniqueName{get;set;}
    
}