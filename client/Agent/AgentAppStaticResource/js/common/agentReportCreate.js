function init_map(){findUserLocation()}function findUserLocation(){"undefined"!=typeof sforce&&null!=sforce?navigator.geolocation?navigator.geolocation.getCurrentPosition(function(position){currentLatitude=position.coords.latitude,currentLongitude=position.coords.longitude,codeLatLng()},function(position){alert("Geolocation not available")}):alert("navigator.geolocation is not available"):(console.log("mocking a location for browser session"),currentLatitude=52.1899,currentLongitude=.1253,codeLatLng())}function codeLatLng(){currentlocation=new google.maps.LatLng(currentLatitude,currentLongitude);var mapOptions={zoom:13,center:currentlocation,mapTypeId:google.maps.MapTypeId.ROADMAP};map=new google.maps.Map(document.getElementById("map"),mapOptions),geocoder.geocode({latLng:currentlocation},function(results,status){if(status==google.maps.GeocoderStatus.OK)if(results[1]){marker=new google.maps.Marker({position:currentlocation,map:map,icon:"https://maps.google.com/mapfiles/arrow.png",title:"You are Here"}),map.setCenter(currentlocation);var address_components=results[1].address_components,components={};jQuery.each(address_components,function(k,v1){jQuery.each(v1.types,function(k2,v2){components[v2]=v1.long_name,"locality"==v2&&(townName=v1.long_name),"country"==v2&&(countryValue=v1.long_name)})}),infowindow.setContent(results[1].formatted_address),infowindow.open(map,marker)}else alert("No results found");else alert("Geocoder failed due to: "+status)})}var countryValue=null,townName=null,currentlocation,currentLatitude=0,currentLongitude=0,cityMap=null,countryMap=null,rtId,rtName,map,geocoder=new google.maps.Geocoder,marker,infowindow=new google.maps.InfoWindow;