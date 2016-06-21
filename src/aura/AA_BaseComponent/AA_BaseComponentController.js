({
    checkBusinessPrinciple : function(component, event, helper) {
        //document.getElementsByClassName("spinner-img")[0].src = "/resource/Lightning_designing_style/assets/images/spinners/slds_spinner.gif";
        //$('.spinner-img').attr('src','/resource/Lightning_designing_style/assets/images/spinners/slds_spinner.gif'); 
        /*$.noConflict();
            jQuery(document).ready(function(){
                
            });*/
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
        component.set("v.businessPrincipleFlag", bgFlag);
    },
    getDetail :function(component, event, helper) {
        var destination = "c:AA_LandingPageComponent";
        var content = component.find("baseComponentContainer");
        $A.createComponent(destination,
                           {"filterType":event.getParam("filterType"),
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
                    "topicId":event.getParam("topicId"), },
                           function(cmp) {
                               content.set("v.body", [cmp]);
                           }); 
        
        /*$A.componentService.newComponentAsync(this, function(view) {
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
        }, component);*/
    },
    getForm :function(component, event, helper) {
        console.log("Event Handled ");
       	//console.log('filterType=================> '+ component.get("v.filterType"));
        console.log('navigate=================> '+ event.getParam("navigate"));
        console.log('filterType=================> '+ event.getParam("filterType"));
        console.log('sortType=================> '+ event.getParam("sortType"));
        console.log('applyFilter=================> '+ event.getParam("applyFilter"));
        console.log('offSet=================> '+ event.getParam("offSet"));
        console.log('limitRecords=================> '+ event.getParam("limitRecords"));
        console.log('countryId=================> '+ event.getParam("countryId"));
        console.log('clusterId=================> '+ event.getParam("clusterId"));
        
        var destination = "c:"+ event.getParam("navigate");
     var content = component.find("baseComponentContainer");
        $A.createComponent(destination,
                           { filterType:event.getParam("filterType"),
                    sortType:event.getParam("sortType"),
                    applyFilter:event.getParam("applyFilter"),
                    offSet:event.getParam("offSet"),
                    limitRecords:event.getParam("limitRecords"),
                    countryId:event.getParam("countryId"),
                    clusterId:event.getParam("clusterId"),  },
                           function(cmp) {
                               content.set("v.body", [cmp]);
                           }); 
       
        
        
          /* $A.componentService.newComponentAsync(this, function(view) {
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
        }, component); */
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
        console.log("Event Handled");
      var showPage=event.getParam("showLandingPage");
        console.log("Showpage__:"+showPage);
		component.set("v.showLandingPageFlag",showPage);
        
    },
    
})