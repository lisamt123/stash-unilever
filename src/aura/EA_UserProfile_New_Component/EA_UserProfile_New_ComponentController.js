({
	doInit : function(component, event, helper) {
       var action=component.get("c.getUserDetail"); 
        action.setCallback(this, function(response) {
                var state = response.getState();
               if (state === "SUCCESS" && response.getReturnValue()!=='') {
                        var items=response.getReturnValue();
                     component.set("v.userDetail", response.getReturnValue());
               var a=items[0].activity_points ;
                   if(a>=0 && a<15)
      {
          component.set("v.newbee0",true);
          component.set("v.newbee1",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.gold",false);
          component.set("v.NewBee_badge",true); 
      }
      else if(a>=15 && a<30)
      {
          component.set("v.newbee0",false);
          component.set("v.newbee1",true);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.gold",false);
           component.set("v.NewBee_badge",true); 
      }  
      else if(a>=30 && a<45)
      {
          component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.bronze0",true);
          component.set("v.bronze1",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
      }   
      else if(a>=45 && a<60)
      {
          component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",true);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.gold",false);
           component.set("v.Bronze_badge",true); 
      }   
       else if(a>=60 && a<75)
      {
          component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.silver0",true);
          component.set("v.silver1",false);
          component.set("v.gold",false);
          component.set("v.Silver_badge",true); 
      }   
      else if(a>=75 && a<90)
      {
          component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.silver0",false);
          component.set("v.silver1",true);
          component.set("v.gold",false);
          component.set("v.Silver_badge",true); 
      }     
      else if(a>=90)
      {
          component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.gold",true);
           component.set("v.Gold_badge",true); 
      }      
     
               }
                });
            $A.enqueueAction(action);
	   },
    removeCSS: function(cmp, event) {
        var cmpTarget = cmp.find("dash");
        $A.util.removeClass(cmpTarget,'dashTitle');

    }

	})