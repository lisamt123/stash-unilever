({
    doInit: function(component, event, helper) {
        var FilterType = component.get("v.filterType");        
        var applyFilter = component.get("v.applyFilter");
        component.set("v.limitRecords",component.get("v.pageRecordCount"));
        helper.getAllData(component);
        if(FilterType ==='AllReports')
        {
            component.set('v.applyFilter','false');
            component.set("v.filterTypeLabel","All Reports");
        }
        if(FilterType ==='FilteredReports')
        {
            component.set('v.applyFilter','false');
            component.set("v.filterTypeLabel","Filtered Reports");
        }
        if(FilterType ==='MyReports')
        {
            component.set('v.applyFilter','false'); 
            component.set("v.filterTypeLabel","My Reports");
        }
        
    },
    changeComponent :function(component, event, helper) {
        var destination = "c:" + event.getParam("navigate");
        var content = component.find("content");
        $A.createComponent(destination,
                           { filterType:event.getParam("filterType"),
                            limitRecords:event.getParam("limitRecords"),
                            offSet:event.getParam("offSet"),
                            sortType:event.getParam("sortType"),
                            applyFilter:event.getParam("applyFilter"),
                            countryId:event.getParam("countryId"),
                            clusterId:event.getParam("clusterId"),
                            unileverBrandId:event.getParam("unileverBrandId"),
                            retailerId:event.getParam("retailerId"),
                            reportingOnId:event.getParam("reportingOnId"),
                            recordType:event.getParam("recordType"),
                            competitorBrandId:event.getParam("competitorBrandId"),
                            competitorId:event.getParam("competitorId"),
                            categoryId:event.getParam("categoryId"),
                            topicId:event.getParam("topicId")    },
                           function(cmp) {
                               content.set("v.body", [cmp]);
                           }); 
    },
    showMore: function(component, event, helper) {
        document.getElementById("loading").style.display="block";
        component.set('v.limitRecords',(component.get("v.limitRecords")+component.get("v.pageRecordCount")));
        helper.getAllData(component);
        setTimeout(function(){ document.getElementById("loading").style.display="none" }, 4000);
        component.set('v.NoReports',true);
       
    },
    goToPopUpFilter: function(component, event, helper) {
        if(navigator.userAgent.match(/Android/i)
           || navigator.userAgent.match(/webOS/i)
           || navigator.userAgent.match(/iPhone/i)
           || navigator.userAgent.match(/iPad/i)){
            helper.scrollToLocation(component, "top");            
        }
        if(navigator.userAgent.match(/iPod/i)
           || navigator.userAgent.match(/BlackBerry/i)
           || navigator.userAgent.match(/Windows Phone/i)){
            helper.scrollToLocation(component, "top");
        }
        var FilterType = component.get("v.filterType");
        component.set("v.filterPopUp",true);
        component.set("v.sortPopUp",false);
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
        var toggleSortPopUp = component.find("sortPopUp");
        $A.util.addClass(toggleSortPopUp, "toggle");
         if(FilterType ==='AllReports')
        {
        var selectedBoldLatest = component.find("showAll");
        $A.util.addClass(selectedBoldLatest, "sort-bold");
        var selectedBoldLiked = component.find("FilteredReports");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        var selectedBoldLiked = component.find("MyReports");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        }
        if(FilterType ==='FilteredReports')
        {
        var selectedBoldLatest = component.find("FilteredReports");
        $A.util.addClass(selectedBoldLatest, "sort-bold");
        var selectedBoldLiked = component.find("showAll");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        var selectedBoldLiked = component.find("MyReports");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        }
        if(FilterType ==='MyReports')
        {
        var selectedBoldLatest = component.find("MyReports");
        $A.util.addClass(selectedBoldLatest, "sort-bold");
        var selectedBoldLiked = component.find("showAll");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        var selectedBoldLiked = component.find("FilteredReports");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        }
        
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
        component.set("v.filterTypeLabel","All Reports");
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
        var selectedBoldLatest = component.find("showAll");
        $A.util.addClass(selectedBoldLatest, "sort-bold");
        var selectedBoldLiked = component.find("FilteredReports");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        var selectedBoldLiked = component.find("MyReports");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
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
        component.set("v.filterTypeLabel","Filtered Reports");
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
        var selectedBoldLatest = component.find("FilteredReports");
        $A.util.addClass(selectedBoldLatest, "sort-bold");
        var selectedBoldLiked = component.find("showAll");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        var selectedBoldLiked = component.find("MyReports");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
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
        component.set("v.filterTypeLabel","My Reports");
        var toggleFilterPopUp = component.find("filterPopUp");
        $A.util.toggleClass(toggleFilterPopUp, "toggle");
        var selectedBoldLatest = component.find("MyReports");
        $A.util.addClass(selectedBoldLatest, "sort-bold");
        var selectedBoldLiked = component.find("showAll");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
        var selectedBoldLiked = component.find("FilteredReports");
        $A.util.removeClass(selectedBoldLiked, "sort-bold");
    },
    gotoPopUpSort: function(component, event, helper) {
        if(navigator.userAgent.match(/Android/i)
           || navigator.userAgent.match(/webOS/i)
           || navigator.userAgent.match(/iPhone/i)
           || navigator.userAgent.match(/iPad/i)){
            helper.scrollToLocation(component, "top");            
        }
        if(navigator.userAgent.match(/iPod/i)
           || navigator.userAgent.match(/BlackBerry/i)
           || navigator.userAgent.match(/Windows Phone/i)){
            helper.scrollToLocation(component, "top");
        }
        component.set("v.filterPopUp",false);
        component.set("v.sortPopUp",true);
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