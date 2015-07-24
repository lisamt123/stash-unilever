/*************************************************************************************
Name : CategoryComponentData

Purpose : Class used for comunication between visualforce page and category brand selection component

History

VERSION  AUTHOR                DATE        DETAIL   Description
1.0      m.bluj@polsource.com  17-07-2015  Initial
*************************************************************************************/
public class CategoryComponentData {

	public String categoryGroup {get;set;}
	public String category {get;set;}
	public String brandpositioning {get;set;}
	public String brand {get;set;}
	public String impProject {get;set;}
	public String inoplanProject {get;set;}
	public Boolean categoryMigrated {get;set;}
	public Boolean categoryNotMigrated {get;set;}
	public Boolean leadIPM {get;set;}

	public CategoryComponentData() {}

	public CategoryComponentData (uw_BET__c bet){
		impProject = bet.IPM_Project__c;
		inoplanProject = bet.Inoplan_Project__c;
		categoryGroup = bet.Category_Group__c; 
		category = bet.Product_category__c;
		brandpositioning = bet.Brand_Position__c;
		brand = bet.Product_Brand__c;
		leadIPM = bet.IPM_Project__c !=null ? true : false;
	}
}