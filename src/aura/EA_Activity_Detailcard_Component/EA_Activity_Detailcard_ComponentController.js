({
	getData : function(component, event, helper) {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-70927869-1', 'auto');
  ga('send', 'pageview');
         var action=component.get("c.getActivities");
                    action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!==''){
                                           var items=response.getReturnValue();
                        component.set("v.activities", response.getReturnValue());
                      tabstyle=component.find("myaction") ;
                      $A.util.addClass(tabstyle, "active");
                          component.set("v.showdownarrow",true); 
					  helper.getAllThemeColor(component); 
                       setTimeout(function() {
                      $A.run(function() {
					  $('.carousel').slick();  
                        });
                       });
                        
                    }      
                });
            $A.enqueueAction(action);
	},
    
    showmyactions1 : function(cmp,event){
      cmp.set("v.showswipe",false);
    cmp.set("v.showInvitation",true);
      cmp.set("v.showfilter",false);	 
      cmp.set("v.detailpage",true);
        cmp.set("v.showtabs",true);
         cmp.set("v.showAllthemebutton",false);
          tabstyle=cmp.find("themes");
       	$A.util.addClass(tabstyle,"inactive_class");
          tabstyle=cmp.find("themes");
       	$A.util.removeClass(tabstyle,"active_class");
           tabstyle=cmp.find("myaction");
       	$A.util.removeClass(tabstyle,"inactive_class");
        tabstyle=cmp.find("myaction");
       	$A.util.addClass(tabstyle,"active_class");
              cmp.set("v.MyActions",false);
           },
 
	applyfilter : function(component, event, helper) {
         component.set("v.showdownarrow",true);
        component.set("v.showuparrow",false);
         component.set("v.showDetailCard",false);
        var filter=event.getParam("theme");
       //alert(filter);
        if(filter != 'All Themes'){
            component.set("v.selectedfilter",filter);
        var action=component.get("c.getActivitiesonfilter");
               action.setParams({"themeName" : filter});
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!==''){
                      var items=response.getReturnValue();
                          component.set("v.activities", response.getReturnValue());
                        var items=response.getReturnValue();
                          setTimeout(function() {
                      $A.run(function() {
					  $('.carousel').slick();  
                        });
                       });  
                                     }
                });
            $A.enqueueAction(action);
        }
             else{
            component.set("v.selectedfilter",filter);
            var action=component.get("c.getActivities");
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS" && response.getReturnValue()!=='') {
                                 var items=response.getReturnValue();
                      
                     component.set("v.activities", response.getReturnValue());
                      setTimeout(function() {
                      $A.run(function() {
					  $('.carousel').slick();  
                        });
                       });                           
                                }
                });
            $A.enqueueAction(action);
               }
	         component.set("v.showswipe",true);
        component.set("v.showfilter",false);
        
	},
    cancelfilter : function(component, event, helper) {
   
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
        cmp.set("v.showDetailCard",false);
        tabstyle=cmp.find("themes");
       	$A.util.removeClass(tabstyle,"inactive_class");
          tabstyle=cmp.find("themes");
       	$A.util.addClass(tabstyle,"active_class");
         tabstyle=cmp.find("myaction");
       	$A.util.removeClass(tabstyle,"active_class");
           tabstyle=cmp.find("myaction");
       	$A.util.addClass(tabstyle,"inactive_class");
        cmp.set("v.showtabs",true);
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
        cmp.set("v.showtabs",true);
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
        cmp.set("v.showInvitation",false);
    	var actId=event.getParam("actvityid");
        var memberid=event.getParam("member_Id");
        var showcontent=event.getParam("showcontent");
        cmp.set("v.showDetailCard",showcontent);
        cmp.set("v.memberid",memberid);
    	cmp.set("v.selectedactivityId",actId);
    	cmp.set("v.detailpage",true);
    	cmp.set("v.MyActions",false);
        cmp.set("v.showtabs",true);
        cmp.set("v.showfeedback",false);
        cmp.set("v.showchatter",false);
        cmp.set("v.showtodoactpage",false); 
    	helper.getactivities1(cmp);
    },
     
    gotoDetail2 : function(cmp,event,helper){
         cmp.set("v.showInvitation",false);
    	var actId=event.getParam("actvityid");
        var memberid=event.getParam("member_Id");
        var showcontent=event.getParam("showcontent");
       // cmp.set("v.showDetailCard",showcontent);
        cmp.set("v.memberid",memberid);
    	cmp.set("v.selectedactivityId",actId);
    	cmp.set("v.detailpage",false);
    	cmp.set("v.MyActions",true);
        cmp.set("v.showtabs",true); 
        cmp.set("v.showfeedback",false);
        cmp.set("v.showchatter",false);
         cmp.set("v.showtodoactpage",false); 
    	helper.getactivities1(cmp);
       
        
    },
    showFeedback :function(cmp,event,helper){
    	var actId=event.getParam("activityId");
        var memberid=event.getParam("team_memberid");
        var rating=event.getParam("participant_rating");
        cmp.set("v.activityId",actId);
        cmp.set("v.memberid",memberid);
        cmp.set("v.participant_rating",rating);
        cmp.set("v.showtabs",false);
        cmp.set("v.showfeedback",true);
        cmp.set("v.detailpage",false);
        cmp.set("v.showswipe",false);
        cmp.set("v.MyActions",false);
        cmp.set("v.showtodoactpage",false); 
        cmp.set("v.showAllthemebutton",false);
        
    },
    showToDoActivityPage : function(component, event, helper) {
       var actId=event.getParam("activityId");
        component.set("v.activityId",actId);
        component.set("v.showfeedback",false);
        component.set("v.detailpage",false);
        component.set("v.showswipe",false);
        component.set("v.showtabs",false);
        component.set("v.MyActions",false);
        component.set("v.showAllthemebutton",false);
        component.set("v.showtodoactpage",true);
    },
    
    gotoInvitation : function(component, event, helper) {
        
        var actId=event.getParam("activityId");
        var memberid=event.getParam("teamId");
       // alert(actId);
        //alert('^'+memberid);
        component.set("v.activityId",actId);
        component.set("v.memberid",memberid);
        component.set("v.showfeedback",false);
        component.set("v.detailpage",false);
        component.set("v.showswipe",false);
        component.set("v.showtabs",false);
        component.set("v.MyActions",false);
        component.set("v.showAllthemebutton",false);
        component.set("v.showtodoactpage",false);
        component.set("v.showInvitation",true);
        component.set("v.showDetailCard",false);
    },
    
    showShareComp : function(component, event, helper) {
        var actvity=event.getParam("activity");
        component.set("v.activityForShare",actvity);
        component.set("v.showfeedback",false);
        component.set("v.detailpage",false);
        component.set("v.showswipe",false);
        component.set("v.showtabs",false);
        component.set("v.MyActions",false);
        component.set("v.showAllthemebutton",false);
        component.set("v.showtodoactpage",false);
        component.set("v.showInvitation",false);
        component.set("v.showchatter",true);
    }
    
})