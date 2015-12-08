({
	fireNotifications : function(component, event, helper) {
        if(component.find('source').get('v.value') !== '' && component.find('fileVersion').get('v.value') !== ''){
            helper.firenotifications(component);
        }else{
            component.find('result').set('v.value', 'Please provide data tag and file version.');
        }		
	}
})