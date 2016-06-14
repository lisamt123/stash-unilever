({
	locateUser : function(component, event, helper) {
        component.set('v.status', $A.get("$Label.c.ICB_STATUS_VIEW_GETTING_GEO"));
        
        navigator.geolocation.getCurrentPosition(
            
            $A.getCallback(function(position){
                
                //Attribute Parent Component
                var compEventLatLng = component.getEvent("mapLatLng_map");
                compEventLatLng.setParams({"latitude" : position.coords.latitude,
                                           "longitude" : position.coords.longitude});
                compEventLatLng.fire();
                
                //Attribute map
                component.set("v.mapsrc",'https://maps.googleapis.com/maps/api/staticmap?markers=color:red%7Clabel:A%7C' + position.coords.latitude + ',' + position.coords.longitude + '&center=' + position.coords.latitude + ',' + position.coords.longitude + '&zoom=16&size=720x720&sensor=false');
                
            }, function(error){console.debug(error)}));
    }
})