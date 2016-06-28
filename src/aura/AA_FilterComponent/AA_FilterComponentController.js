({   
    filterRecord: function(component,event,helper) { 
        var homeEvent =  $A.get("e.c:AA_FilterEventAllReport");
        homeEvent.setParams({"navigate" : "AA_FilterDetail","filterType":component.get("v.filterType"),"limitRecords": component.get("v.limitRecords"),"offSet": component.get("v.offSet"),"applyFilter":component.get("v.applyFilter"),"sortType":component.get("v.sortType"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
    },
})