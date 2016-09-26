/*  
**********************************************************************
*@Description:This script is used for clusters
*@Author: Cognizant
*@Created Date: 28/05/2015 
**********************************************************************
*/ 

/* Below script is used for the Clusters module */
var jq = jQuery.noConflict();
	jq(document).ready(function(){
		var SelectedCountry = null;
		jq("#ipmRollOut").on("click", ".roMapView", function(){ 
		jq("#vmap").remove();
		var SelectedCountry = new Array(); 
		jq("#roMapView").append('<div id="vmap"></div>');                                   
		jq.each(jq("#ipmCountry input[type=checkbox]:checked"), function() {                                         
			SelectedCountry.push(jq(this).attr("name"));                                          
		});
		jq('#vmap').vectorMap({
			map: 'world_en',
			backgroundColor: '#ffffff',
			borderColor: '#ffffff',
			borderOpacity: 0.25,
			borderWidth: 1,
			color: '#8d8d8d',
			enableZoom: true,
			hoverColor: null,
			hoverOpacity: null,
			normalizeFunction: 'linear',
			scaleColors: ['#b6d6ff', '#005ace'],
			selectedColor: 'green',
			selectedRegions: SelectedCountry,                                               
			showTooltip: true,
			onRegionClick:false,
			multiSelectRegion: true       
		});                   
		jq('#vmap').on('mousewheel', function(event, delta, deltaX, deltaY){
			event.preventDefault();
			if(delta == 1){
				jq('.jqvmap-zoomin').trigger('click');
			}else{
				jq('.jqvmap-zoomout').trigger('click');
			}
		});
	});

});