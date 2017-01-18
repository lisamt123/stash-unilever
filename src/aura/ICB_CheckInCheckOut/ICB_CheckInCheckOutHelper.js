({
	saveCheckIn : function(component, event, helper, type, confirm) {
        
        component.set('v.lastEvent', type);
        var action = component.get(type);
        var idReg = component.get("v.recordId");
        var latitude = component.get("v.lat");
        var longitude = component.get("v.lng");
        
        if( confirm ){
            action.setParams({
                idRecord : idReg,
                latitude : latitude,
                longitude : longitude,
                confirm : confirm
            });
        }else{
            action.setParams({
                idRecord : idReg,
                latitude : latitude,
                longitude : longitude,
                confirm : confirm
            });
        }
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if( state === $A.get("$Label.c.ICB_STATE_RESPONSE_SUCCESS") ){
                var returnMSG = response.getReturnValue();
                
                var alert = $A.get("$Label.c.ICB_TEXT_ALERT");
                var success = $A.get("$Label.c.ICB_TEXT_SUCCESS2");
                var warning = $A.get("$Label.c.ICB_TEXT_WARNING");
                var error = $A.get("$Label.c.ICB_TEXT_ERROR");
                
                if(returnMSG.indexOf(alert) >= 0){
                    component.set('v.status', returnMSG);
                    component.set('v.showAlert', false);
                } else if(returnMSG.indexOf(warning) >= 0 || returnMSG.indexOf(error) >= 0){
                    component.set('v.status', returnMSG);
                	component.set('v.showInfo', false);
                }else{
                    component.set('v.status', returnMSG);
                    component.set('v.checkinReady', false);
                    component.set('v.showSpinnerCI',false);
                    
                    if( returnMSG.indexOf($A.get("$Label.c.ICB_TEXT_CHECK_IN")) > -1 ){
                        
                        var lVisit = component.get('v.visit');
                        var codcustomer = lVisit.ICB_Sales_Area__c;
                		
                        if( codcustomer != null && codcustomer != "undefined" ){
                            console.log('URI MSERIES= '+$A.get("$Label.c.ICB_SCHEMA_MSERIES")+codcustomer);
                    		sforce.one.navigateToURL($A.get("$Label.c.ICB_SCHEMA_MSERIES")+codcustomer, false);
                        }else {
                            sforce.one.navigateToURL($A.get("$Label.c.ICB_SCHEMA_MSERIES"), false);
                        }
                    }else{
                        sforce.one.navigateToURL($A.get("$Label.c.ICB_PREFIX_SOBJECT_EVENT"), true);
                    }
                }
            }
            component.set('v.showSpinnerCI',false);
        });
        $A.enqueueAction(action);
        return;
    },
    
    locateVisit : function(component, event, helper){
		console.log('Entering <locateVisit>');
    	var action = component.get('c.getVisit');
        var idReg = component.get('v.recordId');
        
        action.setParams({ visitId : idReg });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if( state === $A.get("$Label.c.ICB_STATE_RESPONSE_SUCCESS") ){
                var lReturn = response.getReturnValue();
                
                component.set('v.visit', lReturn);
                var lVisit = component.get('v.visit');
                console.log('lVisit= '+JSON.stringify(lVisit));
                
                if( (lVisit.ICB_GeolocationCheckin__Latitude__s != null &&
                     lVisit.ICB_GeolocationCheckin__Latitude__s != 'undefined') || 
                     lVisit.ICB_GoldenMinuteOpen__c ){
                    component.set('v.goldenMinuteOpen', true);
                }
            }
        });
        $A.enqueueAction(action);
        return;
    },
    locateGoldenMinute : function(component, event, helper){
        console.log('Entering <locateGoldenMinute>');
        var action = component.get('c.getCognosFile');
        var idReg = component.get('v.visitId');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if( state === $A.get("$Label.c.ICB_STATE_RESPONSE_SUCCESS") ){
                var lId = response.getReturnValue();
                if( lId == null ){
                    component.set('v.enabledByGM', false);
                }
                component.set('v.golden', lId);
            }
            component.set('v.status', $A.get("$Label.c.ICB_STATUS_VIEW_DONE"));
            component.set('v.checkinReady', true);
            component.set('v.showAlert', true);
            component.set('v.showError', true);
        });
        $A.enqueueAction(action);
        return;
    },
    mseries : function(componente, event, helper){
        sforce.one.navigateToURL($A.get("$Label.c.ICB_SCHEMA_MSERIES"), true);
    },
    
    goldenMinute : function(component, event, helper, confirm){
        console.log('Entering <goldenMinute>');
        var goldenMinute = component.get('v.golden');
        
        if( goldenMinute != null ){
            var txtDate = String(goldenMinute.CreatedDate);
            var gmDate = String(txtDate);
            gmDate = gmDate.substring(0,10);
            
            //Date javascript
            var today = new Date();
            var day = today.getDate();
            var month = today.getMonth()+1; //January is 0!
            var year = today.getFullYear();
            if(day<10){
                day='0'+day;
            } 
            if(month<10){
                month='0'+month;
            }
            var currentDate = year+'-'+month+'-'+day;
            
            if( currentDate == gmDate || confirm == 'true' ){
                //********* CHAMAR O SET GOLDEN MINUTE
                component.set('v.isStatusGM', false);
                component.set('v.isShowButtonsGM', false);
                
                //*****************************************************************************************************
                //*************************************** BEGIN CHANGE ************************************************
                //*****************************************************************************************************
                //Author: Carlos Carvalho - Date: 07-07-2016
                //Description: Some situations the 3G connection doesn't work the call back method.
                //We need to move the method inside this method and transition to golden minute needs to stay inside 
                //the following method
                //ID: 232828 - CHECK-IN AND CHECK-OUT NOT ENABLING WHEN GOLDEN MINUTE BUTTON IS CLICKED.
                //*****************************************************************************************************
                //*****************************************************************************************************
                //helper.setGMinute(component, event, helper, 'c.setGoldenMinuteOpen', goldenMinute.Id);
                var action = component.get('c.setGoldenMinuteOpen');
                var idReg = component.get('v.recordId');
                action.setParams({ idVisit : idReg });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if( state === $A.get("$Label.c.ICB_STATE_RESPONSE_SUCCESS") ){
                        var isChecked = response.getReturnValue();
                        console.log('isChecked= '+isChecked);
                        if( isChecked == 'true' )
                        {
                            component.set('v.isStatusGM', true);
                        }
                        sforce.one.navigateToURL('/'+goldenMinute.Id);
                    }
                });
                $A.enqueueAction(action);
                //*****************************************************************************************************
                //*************************************** END CHANGE **************************************************
                //*****************************************************************************************************
                
            }else{
                component.set('v.statusGM', $A.get("$Label.c.ICB_STATUS_GOLDEN_MINUTE_NOT_UPDATE"));
                component.set('v.isStatusGM', true);
                component.set('v.isShowButtonsGM', true);
            }
        }else{
            component.set('v.statusGM', $A.get("$Label.c.ICB_STATUS_GOLDEN_MINUTE_NOT_UPLOADED"));
            component.set('v.isStatusGM', true);
        }
        console.log('Exit <goldenMinute>');
    },
    setGMinute : function(component, event, helper, method, idGoldenMinute){
        console.log('Entering <setGMinute>');
        var action = component.get(method);
        var idReg = component.get('v.recordId');
        action.setParams({ idVisit : idReg });
    	
        action.setCallback(this, function(response) {
            var state = response.getState();
            if( state === $A.get("$Label.c.ICB_STATE_RESPONSE_SUCCESS") ){
                var isChecked = response.getReturnValue();
                console.log('isChecked= '+isChecked);
                if( isChecked == 'true' )
                {
                    component.set('v.isStatusGM', true);
                }
                sforce.one.navigateToURL('/'+idGoldenMinute);
            }
        });
        $A.enqueueAction(action);
        console.log('Exit <setGMinute>');
        return;
    }
})