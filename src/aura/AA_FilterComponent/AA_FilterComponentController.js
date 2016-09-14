({   
    filterRecord: function(component,event,helper) { 
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
        var homeEvent =  $A.get("e.c:AA_FilterEventAllReport");
        homeEvent.setParams({"navigate" : "AA_FilterDetail","filterType":component.get("v.filterType"),"limitRecords": component.get("v.limitRecords"),"offSet": component.get("v.offSet"),"applyFilter":component.get("v.applyFilter"),"sortType":component.get("v.sortType"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
    },
})