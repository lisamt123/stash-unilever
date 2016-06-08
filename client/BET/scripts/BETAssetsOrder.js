	    function saveOrderRemoteCallBack(event,result){
	    	if (event.status) {
	            	window.top.postMessage({action: 'saveAssetsOrder'},
            		document.location.protocol + '//' + document.domain
            	);
	        } else {
	            
	        }
	    }

		var liOrderedAssets = [];
		jQuery.noConflict(); 
		jQuery(document).ready( function(){
			jQuery( "#liAssets" ).sortable();
			jQuery( "#liAssets" ).disableSelection();
		});
		
		function saveOrder(){
			liOrderedAssets = [];
			jQuery( "#liAssets div div" ).each(function(idx, elem){
			  liOrderedAssets.push(jQuery(elem).data("id"));
			});
			saveOrderRemote(liOrderedAssets);
		}