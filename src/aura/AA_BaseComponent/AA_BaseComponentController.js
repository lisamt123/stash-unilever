({
    checkBusinessPrinciple : function(component, event, helper) {
        var action = component.get("c.getIsAcceptedTermsAndCondition");
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set("v.businessPrincipleFlag", a.getReturnValue());
                /*if(component.get("v.businessPrincipleFlag") === true){
                   helper.getAllReportsData(component);
                }*/
            } else if (a.getState() === "ERROR") {
                console.log("Errors"+ a.getError());
            }
        });
        $A.enqueueAction(action);
    },
    handleBusinessPrincipleEvent: function(component, event, helper) {
        var bgFlag = event.getParam("bpFlag");
        component.set("v.businessPrincipleFlag", bgFlag);
        /*if(bgFlag === true){
            helper.getAllReportsData(component);
        }*/
    },
    getDetail :function(component, event, helper) {
        //console.log("GetDetail====>"+event.getParam("filterType")+"==CountryId"+event.getParam("countryId")+"==ClusterId==>"+event.getParam("clusterId"));
        // here we can change data based on filter type and filter call helper 
        var destination = "markup://c:AA_LandingPageComponent";
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("baseComponentContainer");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values: {
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
                 }
            }
        }, component);
    },
     getForm :function(component, event, helper) {
        //console.log('=================> '+ component.get("v.filterType"));
        var destination = "markup://c:"+ event.getParam("navigate");
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("baseComponentContainer");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                value:{
                    "filterType":event.getParam("filterType"),
                    "sortType":event.getParam("sortType"),
                    "applyFilter":event.getParam("applyFilter"),
                    "offSet":event.getParam("offSet"),
                    "limitRecords":event.getParam("limitRecords"),
                    "countryId":event.getParam("countryId"),
                    "clusterId":event.getParam("clusterId"),
                    }           
            }
        }, component);
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
})