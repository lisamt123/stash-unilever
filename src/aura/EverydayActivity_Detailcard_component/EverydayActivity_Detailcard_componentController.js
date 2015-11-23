({
	getData : function(component, event, helper) {
        
       var action=component.get("c.getActivities");
        //alert(filter); 
      //  action.setParams({"ActivityID" : 'a6kc0000000060PAAQ'});
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()!=''){
                        var items=response.getReturnValue();
                  
                     component.set("v.activities", response.getReturnValue());
                      tabstyle=component.find("myaction") ;
                      $A.util.addClass(tabstyle, "active");
					  helper.getAllThemeColor(component); 
                                             
                      setTimeout(function() {
                      $A.run(function() {
					  $('.carousel').slick();  
                        });
                       });
                      }  
                    }      
                });
            $A.enqueueAction(action);

		
	},
    
 
	applyfilter : function(component, event, helper) {
        var filter=event.getParam("theme");
       //alert(filter);
        if(filter != 'All Theme'){
            component.set("v.selectedfilter",filter);
        var action=component.get("c.getActivitiesonfilter");
       
        action.setParams({"themeName" : filter});
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()!=''){
                        var items=response.getReturnValue();
                      //alert(items.length); 
                      //alert(filter);
                     component.set("v.activities", response.getReturnValue());
                        var items=response.getReturnValue();
                        alert(items[0].Id);
                    
                       setTimeout(function() {
                      $A.run(function() {
					  $('.carousel').slick();  
                        });
                       });  
                       
                   }
                }
                });
            $A.enqueueAction(action);
        }
        
        else{
            component.set("v.selectedfilter",filter);
            var action=component.get("c.getActivities");
     
        //action.setParams({"themeName" : filter});
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()!=''){
                        var items=response.getReturnValue();
                      //alert(items.length); 
                     component.set("v.activities", response.getReturnValue());
                      setTimeout(function() {
                      $A.run(function() {
					  $('.carousel').slick();  
                        });
                       });                           
                       
                   }
                }
                });
            $A.enqueueAction(action);
            
        }
		//component.set("v.filter",filter);
        //component.set("v.showAll",true);
        //component.set("v.showfilter",false);
         //component.set("v.showfilterbutton",false);
         component.set("v.showswipe",true);
        component.set("v.showfilter",false);
	},
    cancelfilter : function(component, event, helper) {
       
		
		//component.set("v.filter",filter);
        //component.set("v.showAll",true);
       // component.set("v.showfilter",false);
        component.set("v.showswipe",true);
        component.set("v.showfilter",false);
        setTimeout(function() {
                      $A.run(function() {
					  $('.carousel').slick();  
                        });
                       });  
		
	},
    callFilterComponent :function(cmp,event){
      var swipe=cmp.get("v.showswipe");
        var filter=cmp.get("v.showfilter");
       
       
       if(swipe === true){
         
        cmp.set("v.showswipe",false);
            
        cmp.set("v.showfilter",true);
         cmp.set("v.showdownarrow",false);
        cmp.set("v.showuparrow",true);
           
        }
        
        if(swipe === false){
      cmp.set("v.showswipe",true);
        cmp.set("v.showfilter",false);
            cmp.set("v.showdownarrow",true);
        cmp.set("v.showuparrow",false);
      }
        
    },
    callShowSwipe:function(cmp,event){
    
        tabstyle=cmp.find("themes");
       	$A.util.removeClass(tabstyle,"inactive_class");
          tabstyle=cmp.find("themes");
       	$A.util.addClass(tabstyle,"active_class");
         tabstyle=cmp.find("myaction");
       	$A.util.removeClass(tabstyle,"active_class");
           tabstyle=cmp.find("myaction");
       	$A.util.addClass(tabstyle,"inactive_class");
       
        
        cmp.set("v.showswipe",true);
        cmp.set("v.MyActions",false);
        cmp.set("v.showfilter",false);
      	cmp.set("v.detailpage",false);
        cmp.set("v.showAllthemebutton",true);
        cmp.set("v.showdownarrow",true);
        cmp.set("v.showuparrow",false);
        
        
        // --------Added By Rajan---------
        setTimeout(function() {
            $A.run(function() {
                $('.carousel').slick();  
            });
        });
        // --------Added By Rajan---------
    },
    callMyAction:function(cmp,event){
      cmp.set("v.showswipe",false);
      cmp.set("v.MyActions",true);
      cmp.set("v.showfilter",false);
      cmp.set("v.detailpage",false);
         cmp.set("v.showAllthemebutton",false);
          tabstyle=cmp.find("themes");
       	$A.util.addClass(tabstyle,"inactive_class");
          tabstyle=cmp.find("themes");
       	$A.util.removeClass(tabstyle,"active_class");
           tabstyle=cmp.find("myaction");
       	$A.util.removeClass(tabstyle,"inactive_class");
        tabstyle=cmp.find("myaction");
       	$A.util.addClass(tabstyle,"active_class");
       
        
    },
    
    gotoDetail : function(cmp,event,helper){
    	var actId=event.getParam("actvityid");
    	cmp.set("v.selectedactivityId",actId);
    	cmp.set("v.detailpage",true);
    	cmp.set("v.MyActions",false);
    	helper.getactivities1(cmp);
    },
})