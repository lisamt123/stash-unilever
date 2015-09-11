/*************************************************************************************
Name : BET_CategoryComponentData

Purpose : Class used for comunication between visualforce page and category brand selection component

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/
public with sharing class BET_CategoryComponentData {

	public Id categoryGroup {get;set;}
	public Id category {get;set;}
	public Id brandpositioning {get;set;}
	public Id brand {get;set;}
	public Id impProject {get;set;}
	public Id inoplanProject {get;set;}
	public Boolean categoryMigrated {get;set;}
	public Boolean categoryNotMigrated {get;set;}
	public Boolean leadIPM {get;set;}
	public Boolean fabricConditionerCategory {get;set;}

	public BET_CategoryComponentData() {}

	public BET_CategoryComponentData(uw_BET__c bet) {
		impProject = bet.IPM_Project__c;
		inoplanProject = bet.Inoplan_Project__c;
		categoryGroup = bet.Category_Group__c; 
		category = bet.Product_category__c;
		brandpositioning = bet.Brand_Position__c;
		brand = bet.Product_Brand__c;
		leadIPM = bet.IPM_Project__c == null ? false : true;
	}
}