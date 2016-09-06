({
	firenotifications : function(component) {
        var action = component.get("c.fireNotifictions");
        action.setParams({
            "dataTag"    	: component.find('source').get('v.value'),
            "fileVersion" 	: component.find('fileVersion').get('v.value')
        });

        var callback = function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var returnValue = response.getReturnValue();
                if (returnValue.status === '0') {
                    component.find('source').set('v.value', '');
                    component.find('fileVersion').set('v.value', '');
                    component.find('result').set('v.value', 'Notifications fired.');
                } else {
                    component.find('result').set('v.value', 'Error occured: '+returnValue.message);
                }
            }
        };
      
        action.setCallback(this, callback);
        $A.enqueueAction(action);
    }
})