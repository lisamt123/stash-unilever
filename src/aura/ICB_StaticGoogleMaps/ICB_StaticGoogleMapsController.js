({
	doInit : function(component, event, helper) {
        
		if(navigator.geolocation){
            helper.locateUser(component, event, helper);
        }else{ 
        	 console.log('ERROR');
        }
	}
})