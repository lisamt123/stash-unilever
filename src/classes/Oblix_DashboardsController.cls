public without sharing class Oblix_DashboardsController extends Oblix_SWOPparentController{

	private static final String NO_FILTERS = 'NO_FILTERS';
	private static final String BLANK = 'BLANK';

	private static final String FY_REPORT_COLUMN_NAME = 'Oblix_SOW_Projects__c.Financial_Year__c.Financial_Year__c';
	private static final String BC_REPORT_COLUMN_NAME = 'Oblix_SOW_Projects__c.Financial_Year__c.BigOblixProductCategory__c.Name';
	private static final String BR_REPORT_COLUMN_NAME = 'Oblix_SOW_Projects__c.Financial_Year__c.OblixBrand__c.Name';

	public String selectedFY {get; set;}
	public String selectedCategory {get; set;}
	public String selectedBrand {get; set;}

	public Oblix_DashboardHandler dbChartSpendShare {
		get{
			if(dbChartSpendShare == null){
				dbChartSpendShare = new Oblix_DashboardHandler(Oblix_Utils.SWOP_DASHBOARD_REPORT_SPEND_SHARE, FY_REPORT_COLUMN_NAME, BC_REPORT_COLUMN_NAME, BR_REPORT_COLUMN_NAME);
			}
			return dbChartSpendShare;
		}
		set;
	}
	public Oblix_DashboardHandler dbChartSpendFee {
		get{
			if(dbChartSpendFee == null){
				dbChartSpendFee = new Oblix_DashboardHandler(Oblix_Utils.SWOP_DASHBOARD_REPORT_SPEND_FEE, FY_REPORT_COLUMN_NAME, BC_REPORT_COLUMN_NAME, BR_REPORT_COLUMN_NAME);
			}
			return dbChartSpendFee;
		}
		set;
	}
	public Oblix_DashboardHandler dbChartNonCampFeeShare {
		get{
			if(dbChartNonCampFeeShare == null){
				dbChartNonCampFeeShare = new Oblix_DashboardHandler(Oblix_Utils.SWOP_DASHBOARD_REPORT_NON_CAMPAIGN_FEES_CFY, FY_REPORT_COLUMN_NAME, BC_REPORT_COLUMN_NAME, BR_REPORT_COLUMN_NAME);
			}
			return dbChartNonCampFeeShare;
		}
		set;
	}

	public String reportFilterSpendShare {
		get{
			return dbChartSpendShare.generateReportFilter(selectedFY, selectedCategory, selectedBrand);
		}
		set;
	}

	public String reportFilterSpendFee {
		get{
			return dbChartSpendFee.generateReportFilter(selectedFY, selectedCategory, selectedBrand);
		}
		set;
	}

	public String reportFilterNonCampFeeShare {
		get{
			return dbChartNonCampFeeShare.generateReportFilter(selectedFY, selectedCategory, selectedBrand);
		}
		set;
	}

	public void resetFilters(){
		System.debug('## ' + reportFilterSpendShare);
		System.debug('## ' + dbChartSpendFee);
		System.debug('## ' + dbChartNonCampFeeShare);
	}


	public Oblix_DashboardsController() {

		dbChartSpendShare = new Oblix_DashboardHandler(Oblix_Utils.SWOP_DASHBOARD_REPORT_SPEND_SHARE, FY_REPORT_COLUMN_NAME, BC_REPORT_COLUMN_NAME, BR_REPORT_COLUMN_NAME);
		dbChartSpendFee = new Oblix_DashboardHandler(Oblix_Utils.SWOP_DASHBOARD_REPORT_SPEND_FEE, FY_REPORT_COLUMN_NAME, BC_REPORT_COLUMN_NAME, BR_REPORT_COLUMN_NAME);
		dbChartNonCampFeeShare = new Oblix_DashboardHandler(Oblix_Utils.SWOP_DASHBOARD_REPORT_NON_CAMPAIGN_FEES_CFY, FY_REPORT_COLUMN_NAME, BC_REPORT_COLUMN_NAME, BR_REPORT_COLUMN_NAME);

		selectedFY = NO_FILTERS;
		selectedCategory = NO_FILTERS;
		selectedBrand = NO_FILTERS;

		Id reportId = [select Id from Report WHERE DeveloperName =: dbChartNonCampFeeShare.reportDeveloperName].Id;
		Reports.ReportDescribeResult descRes = Reports.ReportManager.describeReport(reportId);
		System.debug('report: ' + JSON.serialize(descRes));

	}

	// wrapper class used for json serialization of selecetd filters to pass on to analytics
	public class ColumnFilter {
		public ColumnFilter(String col, String op, String val){
			column = col;
			operator = op;
			value = val;
		}
        //public ColumnFilter(String lab, String col, String dt) {
        //    label = lab;
        //    column = col;
        //    dataType = dt;
        //}
 
        // Values needed for apex:analytics component
        public String column { get; set; }
        public String operator { get; set; }
        public String value { get; set; }
 
        // Values need for display and operator select list
        //public String label { get; set; }
        //public String dataType { get; set; }
 
    }

    public class Oblix_DashboardHandler{

    	public String reportDeveloperName {get; set;}

    	public String fyReportColumnName {get; set;}
    	public String bigCReportColumnName {get; set;}
    	public String brandReportColumnName {get; set;}

    	public Oblix_DashboardHandler(String pReportDeveloperName, String pFyReportColumnName, String pBigCReportColumnName, String pBrandReportColumnName){

    		reportDeveloperName = pReportDeveloperName;

			pFyReportColumnName = pFyReportColumnName;
    		bigCReportColumnName = pBigCReportColumnName;
    		brandReportColumnName = pBrandReportColumnName;

    	}

    	private List<ColumnFilter> getSelectedFilters(String selectedFY, String selectedCategory, String selectedBrand) {
	        List<ColumnFilter> selectedFilters = new List<ColumnFilter>();

	        if(selectedFY != NO_FILTERS){
	        	//ColumnFilter cfFY = new ColumnFilter('Oblix_SOW_Projects__c.Financial_Year__c.Financial_Year__c', 'equals', selectedFY == BLANK ? '' : selectedFY);
	        	ColumnFilter cfFY = new ColumnFilter(fyReportColumnName, 'equals', selectedFY == BLANK ? '' : selectedFY);
	        	selectedFilters.add(cfFY);
	        }

	        if(selectedCategory != NO_FILTERS){
	        	//ColumnFilter cfCat = new ColumnFilter('Oblix_SOW_Projects__c.Financial_Year__c.BigOblixProductCategory__c.Name', 'equals', selectedCategory == BLANK ? '' : selectedCategory);
	        	ColumnFilter cfCat = new ColumnFilter(bigCReportColumnName, 'equals', selectedCategory == BLANK ? '' : selectedCategory);
	        	selectedFilters.add(cfCat);
	        }
	        if(selectedBrand != NO_FILTERS){
	        	//ColumnFilter cfBrand = new ColumnFilter('Oblix_SOW_Projects__c.Financial_Year__c.OblixBrand__c.Name', 'equals', selectedBrand == BLANK ? '' : selectedBrand);
	        	ColumnFilter cfBrand = new ColumnFilter(brandReportColumnName, 'equals', selectedBrand == BLANK ? '' : selectedBrand);
	        	selectedFilters.add(cfBrand);
	        }

	        return selectedFilters;
	    }

	    public String generateReportFilter(String selectedFY, String selectedCategory, String selectedBrand) {
			String filters = JSON.serialize(getSelectedFilters(selectedFY, selectedCategory, selectedBrand));
			System.debug('## ' + filters);
			return filters;
		}
	}










	public List<SelectOption> availableFYs {
		get{

			if(availableFYs == null){
				List<AggregateResult> ars = [SELECT count(Id), Financial_Year__c FROM Marketing_SOW__c GROUP BY Financial_Year__c];
				availableFYs = buildSelectOptions(ars, 'Financial_Year__c', 'Financial_Year__c');
			}
			return availableFYs;

		}
		set;
	}
	public List<SelectOption> availableCategories {
		get{

			//if(availableCategories == null){
				String filterFY = selectedFY == BLANK ? '' : selectedFY;
				String queryString = ' SELECT count(Id), BigOblixProductCategory__r.Name FROM Marketing_SOW__c ';
				if(selectedFY != NO_FILTERS){
					queryString += ' WHERE Financial_Year__c =: filterFY ';
				}
				queryString += ' GROUP BY BigOblixProductCategory__r.Name ';
				List<AggregateResult> ars = Database.query(queryString);
				//List<AggregateResult> ars = [SELECT count(Id), BigOblixProductCategory__c, BigOblixProductCategory__r.Name FROM Marketing_SOW__c WHERE Financial_Year__c =: selectedFY GROUP BY BigOblixProductCategory__c, BigOblixProductCategory__r.Name];
				availableCategories = buildSelectOptions(ars, 'Name', 'Name');
			//}
			return availableCategories;

		}
		set;
	}
	public List<SelectOption> availableBrands {
		get{

			//if(availableBrands == null){
				String filterFY = selectedFY == BLANK ? '' : selectedFY;
				String filterBigC = selectedCategory == BLANK ? '' : selectedCategory;
				String queryString = ' SELECT count(Id), OblixBrand__r.Name FROM Marketing_SOW__c ';
				List<String> conditions = new List<String>();
				if(selectedFY != NO_FILTERS){
					conditions.add(' Financial_Year__c =: filterFY ');
				}
				if(selectedCategory != NO_FILTERS){
					conditions.add(' BigOblixProductCategory__r.Name =: filterBigC ');
				}
				if(!conditions.isEmpty()){
					queryString += ' WHERE ' + String.join(conditions, ' AND ');
				}
				queryString += ' GROUP BY OblixBrand__r.Name ';
				List<AggregateResult> ars = Database.query(queryString);
				//List<AggregateResult> ars = [SELECT count(Id), OblixBrand__c, OblixBrand__r.Name FROM Marketing_SOW__c WHERE Financial_Year__c =: selectedFY AND BigOblixProductCategory__c =: selectedCategory GROUP BY OblixBrand__c, OblixBrand__r.Name ];
				availableBrands = buildSelectOptions(ars, 'Name', 'Name');
			//}
			return availableBrands;

		} 
		set;
	}

	private List<SelectOption> buildSelectOptions(List<AggregateResult> ars, String labelFieldName, String valueFieldName){
		List<SelectOption> retList = new List<SelectOption>();
		retList.add(new SelectOption(NO_FILTERS, '--All--'));
		retList.add(new SelectOption(BLANK,'--Blank--'));
		for(AggregateResult ar : ars){
			if(ar.get(labelFieldName) != null && ar.get(valueFieldName) != null){
				//String value =  String.valueOf(ar.get(valueFieldName));
				String label = String.valueOf(ar.get(labelFieldName));
				retList.add(new SelectOption(label, label));
			}
		}
		return retList;
	}

}