({
	getWorkplaceDetail : function(component, event, helper) {
        var workplaceLocationID = component.get("v.workplaceLocationId");
        console.log('-----------------'+workplaceLocationID);
        var action = component.get("c.getWorkplaceDetails");
        action.setParams({
			"workPlaceId": workplaceLocationID
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {      
                if(response.getReturnValue()!='')   {
                    component.set("v.workplaceLocationDetails",response.getReturnValue());
                    var bannerImage = response.getReturnValue().Workplace_Image__c;   
					var result = /<img[^>]+src="([^">]+)/g;                    
                    var sourceResult = result.exec(bannerImage);
                    bannerImage = sourceResult[1];
                    sourceResult = bannerImage.replace(/amp;/g, "");                    
                    component.set("v.workplaceImage",sourceResult);
					console.log('------------image line-----'+sourceResult);
                    setTimeout(function() {
                        var map = L.map('map', {zoomControl: true}).setView([response.getReturnValue().Location__Latitude__s, response.getReturnValue().Location__Longitude__s], 14);
                        L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/{z}/{y}/{x}',{attribution: 'Test'}).addTo(map);                 
                        // Add marker
                        L.marker([response.getReturnValue().Location__Latitude__s, response.getReturnValue().Location__Longitude__s]).addTo(map)
                            .bindPopup(response.getReturnValue().Name);
                    });
                }
                else {
                	component.set("v.displayWorkplaceDetails", false); 
                }
            }
            else {
                component.set("v.displayWorkplaceDetails", false);   
            }     
        });
        $A.enqueueAction(action);
	},
    gotoChangeLocation: function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_ChangeLocation"}).fire();
    },
    
    gotoDepartmentsByFloor : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_DepartmentsByFloor"}).fire();
    },
    gotoHealthAndSafety : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_HealthAndSafety"}).fire();
    },
    gotoShopTimings : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_ShopTimings"}).fire();    
    },
    gotoGymSchedule : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_GymSchedule"}).fire();
    },
    gotoLocalGroups : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_LocalGroups"}).fire();
    },
    gotoKeyContacts : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_KeyContacts"}).fire();
    },
    gotoSustainability : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_Sustainability"}).fire();
    },
    gotoWorkplaceChatter : function(component, event, helper) {
        var workplaceGroupID = component.get("v.workplaceLocationDetails.Workplace_Group__c");
        var urlEvent = $A.get("e.force:navigateToSObject");
        urlEvent.setParams({"recordId": workplaceGroupID,"slideDevName": "related"}).fire();
    },
    gotoCafeteriaMenu : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_CafeteriaMenu"}).fire();
    },
    gotoTransport : function(component, event, helper) {
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_Transport"}).fire();
    },
})