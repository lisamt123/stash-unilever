({doInit : function(component, event, helper) {
       var action=component.get("c.getUserDetail"); 
        action.setCallback(this, function(response) {
                var state = response.getState();
               if (state === "SUCCESS" && response.getReturnValue()!=='') {
                        var items=response.getReturnValue();
                     component.set("v.userDetail", response.getReturnValue());
               var a=items[0].activity_points ;
                  // alert(a);
                  helper.helperMethod(component,a);
                    
      if(a>=0 && a<10)
      {   component.set("v.newbee0",true);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.NewBee_badge",true); 
          component.set("v.newbee_img_pos",true);
          component.set("v.bronze_img_pos",false);
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);}
      else if(a>=10 && a<20)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",true);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
           component.set("v.NewBee_badge",true); 
          component.set("v.newbee_img_pos",true);
          component.set("v.bronze_img_pos",false);
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false); }  
      else if(a>=20 && a<30)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",true);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.NewBee_badge",true); 
          component.set("v.bronze_img_pos",false);
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",true); }   
      else if(a>=30 && a<40)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",true);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);
          component.set("v.bronze_img_pos",true);}   
       else if(a>=40 && a<50)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",true);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);
          component.set("v.bronze_img_pos",true);}   
      else if(a>=50 && a<60)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",true);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);
          component.set("v.bronze_img_pos",true);} 
         else if(a>=60 && a<70)
      {  component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",true);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Bronze_badge",true); 
          component.set("v.silver_img_pos",false);
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);
          component.set("v.bronze_img_pos",true);} 
                   
           else if(a>=70 && a<80)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",true);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
          component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);} 
                   
        else if(a>=80 && a<90)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",true);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
           component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);} 
         
        else if(a>=90 && a<100)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",true);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",false);
           component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);} 
        else if(a>=100 && a<110)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",true);
          component.set("v.silver4",false);
          component.set("v.gold",false);
           component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);}            
       else if(a>=110 && a<120)
      {  component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",true);
          component.set("v.gold",false);
          component.set("v.Silver_badge",true);
          component.set("v.silver_img_pos",true);
          component.set("v.Bronze_badge",false); 
          component.set("v.gold_img_pos",false);
          component.set("v.newbee_img_pos",false);} 
      else if(a>=120)
      {   component.set("v.newbee0",false);
          component.set("v.newbee1",false);
          component.set("v.newbee2",false);
          component.set("v.bronze0",false);
          component.set("v.bronze1",false);
          component.set("v.bronze2",false);
          component.set("v.bronze3",false);
          component.set("v.silver0",false);
          component.set("v.silver1",false);
          component.set("v.silver2",false);
          component.set("v.silver3",false);
          component.set("v.silver4",false);
          component.set("v.gold",true);
           component.set("v.Gold_badge",true); 
          component.set("v.gold_img_pos",true);
          component.set("v.silver_img_pos",false);
          component.set("v.Bronze_badge",false); 
          component.set("v.newbee_img_pos",false);}    
               
               }});
            $A.enqueueAction(action);},
    removeCSS: function(cmp, event) {
        var cmpTarget = cmp.find("dash");
        $A.util.removeClass(cmpTarget,'dashTitle');}})