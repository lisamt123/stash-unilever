({
    doInit: function(component, event, helper) {
        console.log("FilterType After Include:===>"+ event.getParam("filterType"));
		var FilterType = component.get("v.filterType");        
        var applyFilter = component.get("v.applyFilter");
        //component.set("v.newSelectedFilter",FilterType);
        //component.set("v.selectedFilter",FilterType);
        component.set("v.limitRecords",component.get("v.pageRecordCount"));
        helper.getAllData(component);
        
        if(FilterType ==='AllReports')
        {
            component.set('v.applyFilter','false');
            component.set("v.filterTypeLabel","All reports");
        }
        
        if(FilterType ==='FilteredReports')
        {
            component.set('v.applyFilter','false');
            component.set("v.filterTypeLabel","Filtered reports");
        }
        if(FilterType ==='MyReports')
        {
           component.set('v.applyFilter','false'); 
           component.set("v.filterTypeLabel","My reports");
        }
        
    },
    
	/*goTofilter: function(component, event, helper) { 
        var homeEvent =  $A.get("e.c:AA_FilterEventAllReport");
        homeEvent.setParams({"navigate" : "AA_FilterComponentAllReport","filterType":component.get("v.filterType"),"limitRecords": component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"applyFilter":component.get("v.applyFilter")}).fire();
    },
    
    gotoSortFilter: function(component, event, helper) {
        var selectEvent=$A.get("e.c:AA_FilterEventAllReport");
        selectEvent.setParams({"navigate":"AA_SortComponent","filterType":component.get("v.filterType"),"limitRecords": component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"sortType":component.get("v.sortType"),"applyFilter":component.get("v.applyFilter"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId"),
                               "unileverBrandId":component.get("v.unileverBrandId"),
                                "retailerId":component.get("v.retailerId"),
                                "reportingOnId":component.get("v.reportingOnId"),
                               "recordType":component.get("v.recordType"),
                               "competitorBrandId":component.get("v.competitorBrandId"),
                                "competitorId":component.get("v.competitorId"),
                                "categoryId":component.get("v.categoryId"),
                                "topicId":component.get("v.topicId"),
                              }).fire();
	},*/
    changeComponent :function(component, event, helper) {
        console.log("ReportType===>"+ event.getParam("filterType") + 'limitRecords:'+ event.getParam("limitRecords")+'===> Country==>'+event.getParam("countryId") + '===Cluster:==>'+ event.getParam("clusterId"));
        var destination = "markup://c:" + event.getParam("navigate");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("content");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values:{
                    "filterType":event.getParam("filterType"),
                    "limitRecords":event.getParam("limitRecords"),
                    "offSet":event.getParam("offSet"),
                    "sortType":event.getParam("sortType"),
                    "applyFilter":event.getParam("applyFilter"),
                    "countryId":event.getParam("countryId"),
                    "clusterId":event.getParam("clusterId"),
                    "unileverBrandId":event.getParam("unileverBrandId"),
                    "retailerId":event.getParam("retailerId"),
                    "reportingOnId":event.getParam("reportingOnId"),
                    "recordType":event.getParam("recordType"),
                    "competitorBrandId":event.getParam("competitorBrandId"),
                    "competitorId":event.getParam("competitorId"),
                    "categoryId":event.getParam("categoryId"),
                    "topicId":event.getParam("topicId"),                    
                }
            }
        }, component); 
	},
    showMore: function(component, event, helper) {
        component.set('v.limitRecords',(component.get("v.limitRecords")+component.get("v.pageRecordCount")));
        helper.getAllData(component);
    },
    goToPopUpFilter: function(component, event, helper) {
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
        var toggleSortPopUp = component.find("sortPopUp");
        $A.util.addClass(toggleSortPopUp, "toggle");
        //console.log("filterType==>"+component.get("v.filterType"));
       // console.log("previousfilterType==>"+component.get("v.previousFilterType"));
        /*if(component.get("v.filterType")!== component.get("v.previousFilterType")){
            var selectedBoldLatest = component.find("ShowLatestFirst");
            $A.util.removeClass(selectedBoldLatest, "sort-bold");
            var selectedBoldLiked = component.find("ShowMostlikedFirst");
            $A.util.removeClass(selectedBoldLiked, "sort-bold");
        }*/
    },
    showAllActive: function(component, event, helper) {
        component.set("v.previousFilterType",component.get("v.filterType"));
        component.set("v.sortType","ShowLatestFirst");
        component.set("v.filterType","AllReports");
        component.set("v.newSelectedFilter","AllReports");
        if(component.get("v.previousFilterType")!==component.get("v.filterType")){
        helper.getAllData(component);
            }
        component.set('v.applyFilter','false');
        component.set("v.filterTypeLabel","All reports");
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
    },
    FilteredReport: function(component, event, helper) {
        component.set("v.previousFilterType",component.get("v.filterType"));
        component.set("v.sortType","ShowLatestFirst");
        component.set("v.filterType","FilteredReports");
        component.set("v.newSelectedFilter","FilteredReports");
        if(component.get("v.previousFilterType")!==component.get("v.filterType")){
            helper.getAllData(component);
        }
        component.set('v.applyFilter','false');
        component.set("v.filterTypeLabel","Filtered reports");
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
    },     
    MyReport: function(component, event, helper) {
        component.set("v.previousFilterType",component.get("v.filterType"));
        component.set("v.sortType","ShowLatestFirst");
        component.set("v.filterType","MyReports");
        component.set("v.newSelectedFilter","MyReports");
        if(component.get("v.previousFilterType")!==component.get("v.filterType")){
            helper.getAllData(component);
        }
        component.set('v.applyFilter','false');
        component.set("v.filterTypeLabel","My reports");
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
    },
    
    gotoPopUpSort: function(component, event, helper) {
        //component.set("v.filterPopUp","true");
        var toggleSortPopUp = component.find("sortPopUp");
        $A.util.toggleClass(toggleSortPopUp, "toggle");
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.addClass(toggleFilterPopUp, "toggle");
    },
    ShowLatestFirst: function(component, event, helper){
        component.set("v.previousSortType",component.get("v.sortType"));
        component.set("v.sortType","ShowLatestFirst");
        if(component.get("v.previousSortType")!==component.get("v.sortType")){
            helper.getAllData(component);
        } 
        var toggleSortPopUp = component.find("sortPopUp");
        $A.util.toggleClass(toggleSortPopUp, "toggle");
        var selectedBoldLatest = component.find("ShowLatestFirst");
        $A.util.addClass(selectedBoldLatest, "sort-bold");
        var selectedBoldLiked = component.find("ShowMostlikedFirst");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
    },
    ShowMostlikedFirst: function(component, event, helper){
        component.set("v.previousSortType",component.get("v.sortType"));
        component.set("v.sortType","ShowMostlikedFirst");
        if(component.get("v.previousSortType")!==component.get("v.sortType")){
            helper.getAllData(component);
        } 
        var toggleSortPopUp = component.find("sortPopUp");
        $A.util.toggleClass(toggleSortPopUp, "toggle");
        var selectedBoldLatest = component.find("ShowLatestFirst");
        $A.util.removeClass(selectedBoldLatest, "sort-bold");
        var selectedBoldLiked = component.find("ShowMostlikedFirst");
        $A.util.addClass(selectedBoldLiked, "sort-bold");
    },
    removeSortStyle: function(component, event, helper){
       if(component.get("v.filterType")!== component.get("v.previousFilterType")){
            var selectedBoldLatest = component.find("ShowLatestFirst");
            $A.util.removeClass(selectedBoldLatest, "sort-bold");
            var selectedBoldLiked = component.find("ShowMostlikedFirst");
            $A.util.removeClass(selectedBoldLiked, "sort-bold");
        } 
        
    },
})