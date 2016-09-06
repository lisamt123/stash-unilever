({
	doInit : function(component, event, helper) {
       var action=component.get("c.getUserDetail"); 
        action.setCallback(this, function(response) {
                var state = response.getState();
               if (state === "SUCCESS" && response.getReturnValue()!=='') {
                        var items=response.getReturnValue();
                     component.set("v.userDetail", response.getReturnValue());
                        if(items[0].badgeprogress_color == 'newbee' ){
                            component.set("v.shownewbee1",true);
                             component.set("v.NewBee_badge",true);  
                        }
                       else  if(items[0].badgeprogress_color == 'newbee1' ){
                            component.set("v.shownewbee2",true);
                            component.set("v.NewBee_badge",true); 
                        }
                     else  if(items[0].badgeprogress_color == 'bronz1' ){
                        component.set("v.showbronz1",true);
                        component.set("v.Bronze_badge",true); 
                        }
                       else  if(items[0].badgeprogress_color == 'bronz2' ){
                            component.set("v.showbronz2",true);  
                             component.set("v.Bronze_badge",true); 
                        }
                         else if(items[0].badgeprogress_color == 'silver1'){
                             component.set("v.showsilver1",true); 
                             component.set("v.Silver_badge",true);                        
                        }
                       else  if(items[0].badgeprogress_color == 'silver2' ){
                            component.set("v.showsilver2",true);
                            component.set("v.shownewbee2",false);
                            component.set("v.showbronz2",false); 
                           component.set("v.Silver_badge",true); 
                        }
                           else  if(items[0].badgeprogress_color == 'gold'){
                               component.set("v.showgold",true);
                               component.set("v.Gold_badge",true); 
                                }
                         }
                });
            $A.enqueueAction(action);
	   },
    removeCSS: function(cmp, event) {
        var cmpTarget = cmp.find("dash");
        $A.util.removeClass(cmpTarget,'dashTitle');

    },

	})