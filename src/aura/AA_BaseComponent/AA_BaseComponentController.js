({
    checkBusinessPrinciple : function(component, event, helper) {
        var action = component.get("c.getIsAcceptedTermsAndCondition");
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.businessPrincipleFlag", a.getReturnValue());
            } else if (a.getState() === "ERROR") {
                console.log("Errors"+ a.getError());
            }
        }); 
        $A.enqueueAction(action);
    },
    handleBusinessPrincipleEvent: function(component, event, helper) {
        var bgFlag = event.getParam("bpFlag");
        var showLandingPage = event.getParam("showLandingPage");
        component.set("v.businessPrincipleFlag", bgFlag);
        component.set("v.showLandingPageFlag", showLandingPage);
    },
    getDetail :function(component, event, helper) {
        var destination = "c:AA_LandingPageComponent";
        var content = component.find("baseComponentContainer");
        $A.createComponent(destination,{
            "filterType":event.getParam("filterType"),
            "sortType":event.getParam("sortType"),
            "applyFilter":event.getParam("applyFilter"),
            "previousFilterType":component.get("v.filterType"),
            "offSet":event.getParam("offSet"),
            "limitRecords":event.getParam("limitRecords"),
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
            "startDate":event.getParam("startDate"),
            "endDate":event.getParam("endDate"), 
        },
        function(cmp, status, errorMessage){
            if (status === "SUCCESS") {
                content.set("v.body", [cmp]);
            }else if (status === "INCOMPLETE") {
                console.log("No response from server or client is offline. Component:"+ destination);
            }else if (status === "ERROR") {
                console.log("Error: " + errorMessage + " Component:"+ destination);
            }
        });                   
    },
    getUlForm :function(component, event, helper) {
        var destination = 'c:'+ event.getParam("navigate");
        var baseContent = component.find("baseComponentContainer");
        $A.createComponent(destination,{
            filterType:event.getParam("filterType"),
            sortType:event.getParam("sortType"),
            applyFilter:event.getParam("applyFilter"),
            offSet:event.getParam("offSet"),
            limitRecords:event.getParam("limitRecords"),
            countryId:event.getParam("countryId"),
            clusterId:event.getParam("clusterId"),
        },
        function(cmp, status, errorMessage){
            if (status === "SUCCESS") {
                baseContent.set("v.body", [cmp]);
            }else if (status === "INCOMPLETE") {
                console.log("No response from server or client is offline. Component:"+ destination);
            }else if (status === "ERROR") {
                console.log("Error: " + errorMessage + " Component:"+ destination);
            }
        });
    },
   showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    }, 
    getshowPage: function (component, event, helper){
        var showPage = event.getParam("showLandingPage");
        component.set("v.showLandingPageFlag",showPage);
    },
})