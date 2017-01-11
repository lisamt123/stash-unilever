({
	getWorkplaceLocationId : function(component, event, helper) { 
        console.log('------------entry----------------');
        var action = component.get("c.getCurrentUserLocation");
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {                
                var workplaceLocationInfo = response.getReturnValue().workplaceId;
                component.set("v.workplaceGaDetail",response.getReturnValue());
                var destination = "markup://c:CORE_WP_WorkplaceHome"; 
                /*$A.componentService.newComponentAsyn(this, function(view) {
                    var content = component.find("WorkplacePannel");
                    content.set("v.body", view);
                }, {
                    componentDef: destination,
                    attributes: {
                        values: {
                            workplaceLocationId: workplaceLocationInfo
                        }
                    }
                }, component); */
                var content = component.find("WorkplacePannel");
							$A.createComponent(destination,
                               {workplaceLocationId: workplaceLocationInfo},
                               function(cmp) {
                                    content.set("v.body", [cmp]);
                               });
                
                 /* (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');*/
                  var workplaceGaDetail = component.get("v.workplaceGaDetail");
                  ga('create', workplaceGaDetail.workplaceGaId , 'auto');
                  ga('set', 'dimension1', workplaceGaDetail.userId);
                  ga('send', 'pageview'); 
            }        	                   
        });
        $A.enqueueAction(action);
        console.log('------------exit----------------');
	},
    navigateWithinComponent: function(component, event, helper) {         
        //event.getParam("displayWorkplaceHome");        
      helper.scrollToLocation(component);  
        var destination = "markup://c:"+event.getParam("WorkplacePannelType"); 
      /* $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("WorkplacePannel");
            content.set("v.body", view);
        }, {
            componentDef: destination,
           attributes: {
                values: {
                    workplaceLocationId: event.getParam("selectedWrokplaceId")
                }
           }
        }, component); */
        var content = component.find("WorkplacePannel");
							$A.createComponent(destination,
                               {workplaceLocationId: event.getParam("selectedWrokplaceId")},
                               function(cmp) {
                                    content.set("v.body", [cmp]);
                               }); 
    }
})