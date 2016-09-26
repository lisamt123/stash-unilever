
        $(document).ready(function () {
          window.detailmap=null;
          
          
          window.map = new google.maps.Map(document.getElementById('map'), {
            zoom: 10,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            mapTypeControl: false,
            streetViewControl: false,
            panControl: false,
            zoomControlOptions: {
              position: google.maps.ControlPosition.Bottom_RIGHT
            }
          }
          );
          
          window.locations = [
            ['<h5>Cochin Detergents Factory</h5>', 9.9392, 76.2596,'Cochin Detergents Factory'],
            ['<h5>Chiplun Detergents Factory</h5>', 17.5323, 73.5177,'Chiplun Detergents Factory'],
            ['<h5>Delhi Exports Factory</h5>', 28.6181, 77.2232,'Delhi Exports Factory'],
            ['<h5>Kolkata Beverages Factory</h5>', 22.5726, 88.3457,'Kolkata Beverages Factory'],
            ['<h5>Mangalore Detergents Factory</h5>', 12.9141, 74.8559,'Mangalore Detergents Factory'],
            ['<h5>Assam - Doom Dooma</h5>', 27.662459, 95.530234,'Assam- Doom Dooma'],
            ['<h5>Barotiwala Foods Factory</h5>', 30.931238,76.823496,'Barotiwala Foods Factory'],
            ['<h5>Barotiwala HPC Factory</h5>', 30.922552, 76.831733,'Barotiwala HPC Factory'],
            ['<h5>Chhindwara Detergents Factory</h5>', 21.789191, 78.837762,'Chhindwara Detergents Factory'],
            ['<h5>Etah Beverages Factory</h5>', 27.603131, 78.698065,'Etah Beverages Factory'],
            ['<h5>Etah Export</h5>', 27.574683, 78.657107,'Etah Export'],
            ['<h5>Goa Personal Wash Factory</h5>', 15.460339, 73.994756,'Goa Personal Wash Factory'],
            ['<h5>Haldia Detergents Factory</h5>', 21.700024, 87.519005,'Haldia Detergents Factory'],
            ['<h5>Haridwar HPC Factory</h5>', 29.941307, 78.123659,'Haridwar HPC Factory'],
            ['<h5>Hosur Beverages Factory</h5>', 12.733941, 77.796697,'Hosur Beverages Factory'],
            ['<h5>Kandla Exports Factory</h5>', 23.096802, 70.080086,'Kandla Exports Factory'],
            ['<h5>Khamgaon Detergents Factory</h5>', 20.729392, 76.534372,'Khamgaon Detergents Factory'],
            ['<h5>Mysore Beverages Factory</h5>', 12.361441, 76.600833,'Mysore Beverages Factory'],
            ['<h5>Nalagarh Factory - Ice Creams</h5>', 31.045961,76.664373,'Nalagarh Factory - Ice Creams'],
            ['<h5>Nasik Ice Cream Factory</h5>', 19.861927, 73.972364,'Nasik Ice Cream Factory'],
            ['<h5>Orai Detergents Factory</h5>', 26.008640, 79.447886,'Orai Detergents Factory'],
            ['<h5>Pondicherry Beverages Factory</h5>', 11.744699, 79.768024,'Pondicherry Beverages Factory'],
            ['<h5>Pondicherry Detergents Factory</h5>', 11.899784, 79.731282,'Pondicherry Detergents Factory'],
            ['<h5>Pondicherry PP Factory</h5>', 11.899784, 79.731282,'Pondicherry PP Factory'],
            ['<h5>Pune Exports Factory</h5>', 18.466474, 73.955892,'Pune Exports Factory'],
            ['<h5>Rajpura Detergents Factory</h5>', 30.494883, 76.571941,'Rajpura Detergents Factory'],
            ['<h5>Silvassa Detergents Factory</h5>', 20.276266, 73.008306,'Silvassa Detergents Factory'],
            ['<h5>Silvassa PP Factory</h5>', 20.276266, 73.008306,'Silvassa PP Factory'],
            ['<h5>Sumerpur Detergents Factory</h5>', 25.827162, 80.168587,'Sumerpur Detergents Factory']
            
            
          ];
          
          window.infowindow = new google.maps.InfoWindow({
            maxWidth: 2500
          }
        );
          
          
          
        }
     );
        
      
	  
	  
	  
	  
        function init(isSearch,lat,long)
        {
                              
          var markers = new Array();
          // Define your locations: HTML content for the info window, latitude, longitude          
          
          var lat_center = lat,
              long_center = long;
        
          // Add the markers and infowindows to the map
          for (var i = 0; i < locations.length; i++) {
            
            
            var marker = new google.maps.Marker({
              position: new google.maps.LatLng(locations[i][1], locations[i][2]),
              map: map
            }
                                               );
            if(isSearch=="true")
            {
              if(locations[i][1] == lat_center && locations[i][2] == long_center) {
                marker.setAnimation(google.maps.Animation.DROP);
                marker.setIcon('https://maps.google.com/intl/en_us/mapfiles/ms/micons/purple.png');
              }
            }
            
            markers.push(marker);
            
            google.maps.event.addListener(marker, 'click', (function(marker, i) {
              return function() {
                infowindow.setContent(locations[i][0]);
                infowindow.open(map, marker);
                openFactory(locations[i][3],lat_center,long_center);
                marker.setAnimation(google.maps.Animation.DROP);
                
              }
            }
           )(marker, i));
            
          }
          
          function autoCenter() {
            //  Create a new viewpoint bound
            var bounds = new google.maps.LatLngBounds();
            //  Go through each...
            for (var i = 0; i < markers.length; i++) {
              
              bounds.extend(markers[i].position);
            }
            //  Fit these bounds to the map
            map.fitBounds(bounds);
          }
          
          
          autoCenter();
          
          google.maps.event.addDomListener(window, 'load', init);
        }
      