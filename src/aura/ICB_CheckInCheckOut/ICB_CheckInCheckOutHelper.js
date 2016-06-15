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
                    console.log('returnMSG='+returnMSG);
                    console.log('$A.get("$Label.c.ICB_TEXT_CHECK_IN")='+$A.get("$Label.c.ICB_TEXT_CHECK_IN"));
                    console.log('$A.get("$Label.c.ICB_PREFIX_SOBJECT_EVENT")='+returnMSG);
                    if( returnMSG.indexOf($A.get("$Label.c.ICB_TEXT_CHECK_IN")) > -1 ){
                        console.log('ENTROU RETORNO MSERIES');
                    	sforce.one.navigateToURL($A.get("$Label.c.ICB_SCHEMA_MSERIES"), false);
                    }else{
                        console.log('ENTROU RETORNO TELA VISITAS');
                        sforce.one.navigateToURL($A.get("$Label.c.ICB_PREFIX_SOBJECT_EVENT"), true);
                    }
                }
            }
            component.set('v.showSpinnerCI',false);
        });
        $A.enqueueAction(action);
        return;
    },
    
    locateGoldenMinute : function(component, event, helper){
        
        var action = component.get('c.getCognosFile');
        var idReg = component.get('v.recordId');
        
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
                sforce.one.navigateToURL('/'+goldenMinute.Id, false);
            }else{
                component.set('v.statusGM', $A.get("$Label.c.ICB_STATUS_GOLDEN_MINUTE_NOT_UPDATE"));
                component.set('v.isStatusGM', true);
                component.set('v.isShowButtonsGM', true);
            }
        }else{
            component.set('v.statusGM', $A.get("$Label.c.ICB_STATUS_GOLDEN_MINUTE_NOT_UPLOADED"));
            component.set('v.isStatusGM', true);
        }
    }
})