({
	doInit : function(component, event, helper) {
        console.log('Entering <doInit>');
        component.set('v.status', $A.get("$Label.c.ICB_STATUS_GEOLOCATING"));
        
        helper.locateGoldenMinute(component, event, helper);
        helper.locateVisit(component, event, helper);
        console.log('Exit <doInit>');
	},
    setLatLng : function(component, event, helper) {
        console.log('Entering <setLatLng>');
        var mapLat = event.getParam("latitude");
        var mapLng = event.getParam("longitude");
        component.set("v.lat", mapLat);
        component.set("v.lng", mapLng);
        
        console.log('Exit <setLatLng>');
    },
    checkIn : function(component, event, helper){
        console.log('Entering <checkIn>');
        component.set('v.isStatusGM', false);
        component.set('v.showSpinnerCI',true);
        helper.saveCheckIn(component, event, helper, 'c.newCheckIn', 'false');
        console.log('Exit <checkIn>');
    },
    checkOut : function(component, event, helper){
        console.log('Entering <checkOut>');
        component.set('v.isStatusGM', false);
        component.set('v.showSpinnerCI',true);
        helper.saveCheckIn(component, event, helper, 'c.newCheckOut', 'false');
        console.log('Exit <checkOut>');
    },
    confirm : function(component, event, helper){
        console.log('Entering <confirm>');
        component.set('v.showSpinnerCI',true);
        console.log('lastEvent='+component.get('v.lastEvent'));
        var methodName = component.get('v.lastEvent');
        helper.saveCheckIn(component, event, helper, methodName, 'true');
        component.set('v.showAlert', true);
        console.log('Exit <confirm>');
    },
    close : function(comp, event, helper){
        console.log('Entering <close>');
        comp.set('v.isStatusGM', false);
        comp.set('v.checkinReady', true);
        comp.set('v.showAlert', true);
        comp.set('v.showInfo', true);
        console.log('Exit <close>');
    },
    enableCheckButton : function(component, event, helper){
        console.log('Entering <enableCheckButton>');
        component.set('v.goldenMinuteOpen', false);
        console.log('Exit <enableCheckButton>');
    },
    goldenMinute : function(component, event, helper){
        console.log('Entering <goldenMinute>');
        component.set('v.goldenMinuteOpen', true);
        helper.goldenMinute(component, event, helper, 'false');
        console.log('Exit <goldenMinute>');
    },
    confirmGM : function(component, event, helper){
        console.log('Entering <confirmGM>');
    	helper.goldenMinute(component, event, helper, 'true');
        console.log('Exit <confirmGM>');
    }
})