({
    makeRequest : function(component, event, helper) {
        var map = L.map('map');
       	L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png').addTo(map);
        
        map.locate({setView: true, maxZoom: 16})
        
        var lat;
        var lng;
        
        map.on('locationfound', onLocationFound);
        function onLocationFound(e) {
            lat = e.latlng.lat;
            lng = e.latlng.lng;
       
            component.set("v.latitude",lat);
            component.set("v.longitude",lng)
                
            var latlongString = e.latlng.lat+','+e.latlng.lng;
            
            function onLocationError(e) {
                console.log(e.message);
            }
            map.on('locationerror', onLocationError);
            var action = component.get("c.service");
            action.setParams({
                path: component.get("v.path")+ encodeURIComponent(latlongString),
                method: component.get("v.method"),
                responseFormat: component.get("v.responseFormat"),
                bodyContent: component.get("v.bodyContent"),
                bodyContentType: component.get("v.bodyContentType")
            });
            
            action.setCallback(this, function(a) {
                var resultsObj = a.getReturnValue();
                component.set("v.bodyContent", JSON.parse(resultsObj.body));
                var resultJson = component.get("v.bodyContent");
                
                L.marker([parseFloat(lat),parseFloat(lng)]).addTo(map).bindPopup(resultJson.results[1].formatted_address).openPopup();
                var address_cmps_array = resultJson.results[1].address_components;
                for(i=0; i < address_cmps_array.length; i++){
                    if(address_cmps_array[i].types[0] == "administrative_area_level_2"){
                        component.set("v.townName", address_cmps_array[i].long_name);
                    }
                    if(address_cmps_array[i].types[0] == "country"){
                        component.set("v.countryName", address_cmps_array[i].long_name);
                    }
                }
                
                var cmpEvent = component.getEvent("getCountryCityLatLng");
                cmpEvent.setParams({
                    "latitude":component.get("v.latitude"),
                    "longitude":component.get("v.longitude"),
                    "countryName":component.get("v.countryName"),
                    "townName":component.get("v.townName")
                });
                cmpEvent.fire();
            });
            
        	$A.run(function() {
                $A.enqueueAction(action); 
            });
        }
    }
})