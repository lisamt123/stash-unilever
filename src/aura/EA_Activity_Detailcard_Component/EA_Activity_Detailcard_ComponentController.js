({
    getData : function(component, event, helper){
         component.set("v.showspinner",true);
        
        var action=component.get("c.getActivities");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!==''){
                var items=response.getReturnValue();
                component.set("v.activities", response.getReturnValue());
                
                tabstyle=component.find("myaction") ;
                $A.util.addClass(tabstyle, "active");
                helper.getBoolean(component);
                component.set("v.showdownarrow",true); 
                helper.getAllThemeColor(component);
                var index=component.get("index");
                setTimeout(function() {
                    $A.run(function() {
                    $('.carousel').slick({'arrows': false});
                    });
                });
           
            }   
        });
        $A.enqueueAction(action);
        var action1 = component.get("c.getGAID");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                if(response.getReturnValue()!=''){                                         
                    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                                            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
                    ga('create', response.getReturnValue(), 'auto');
                    ga('send', 'pageview');
                }
                else {
                    component.set("v.ErrorMessageFlag", true);
                }
            }                   
        });
        $A.enqueueAction(action1);
        setTimeout( "jQuery('.outer_sec').show();",2000 );
        setTimeout( "jQuery('.outer_sec1').hide();",2000 );
        setTimeout( "jQuery('.outer_sec2').show();",2000 );
        component.set("v.showspinner",false);
         
    },
    showmyactions1 : function(cmp,event,helper){
        cmp.set("v.showswipe",false);
        cmp.set("v.showInvitation",true);
        cmp.set("v.showfilter",false);	 
        cmp.set("v.detailpage",true);
        cmp.set("v.showtabs",true);
        cmp.set("v.showAllthemebutton",false);
        cmp.set("v.MyActions",false);
        helper.showTabActive(cmp,event,'themes');
    },
    applyfilter : function(component, event, helper) {
        setTimeout( "jQuery('.outer_sec').hide();",2000);
        $('.outer_sec').hide();
          component.set("v.showspinner",true);
         component.set("v.showdownarrow",true);
        component.set("v.showuparrow",false);
        component.set("v.showDetailCard",false);
        var filter=event.getParam("theme");
        if(filter !== 'All Themes'){
            component.set("v.selectedfilter",filter);
            var action=component.get("c.getActivitiesonfilter");
            var index;
            component.set("v.index",0);
            action.setParams({"themeName" : filter});
            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set("v.showspinner",false);
                //setTimeout( "jQuery('.spinner').hide()",1000);
                if (state === "SUCCESS" && response.getReturnValue()!==''){
                    
                    var items=response.getReturnValue();
                    component.set("v.activities", response.getReturnValue());
                    var items=response.getReturnValue();
                    setTimeout(function() {
                        $A.run(function() {
                            $('.carousel').slick({'arrows': false});   
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
                    component.set("v.showspinner",false);
                    component.set("v.activities", response.getReturnValue());
                    setTimeout(function() {
                        $A.run(function() {
                            $('.carousel').slick({'arrows': false});  
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
                $('.carousel').slick({'arrows': false});  
            });
        });  
    },
    callFilterComponent :function(cmp,event,helper){
        var activity=cmp.get("v.activities");
        activity.splice(0,activity.length);
        var swipe=cmp.get("v.showswipe");
        var filter=cmp.get("v.showfilter");
        if(swipe === true){
            cmp.set("v.showswipe",false);
            cmp.set("v.showfilter",true);
            cmp.set("v.showdownarrow",false);
            cmp.set("v.showuparrow",true);
            cmp.set("v.showDetailCard",false);
            
        }
        if(swipe === false){
            cmp.set("v.showswipe",true);
            cmp.set("v.showfilter",false);
            cmp.set("v.showdownarrow",true);
            cmp.set("v.showuparrow",false);
            cmp.set("v.showDetailCard",false);
            
        }
    },
    callShowSwipe:function(cmp,event,helper){
        // Show tab active
        helper.showTabActive(cmp,event,'themes'); 
        
        // Show or hide component
        cmp.set("v.showfeedback",false);
        cmp.set("v.showDetailCard",false);
        cmp.set("v.showtabs",true);
        cmp.set("v.showswipe",true);
        cmp.set("v.MyActions",false);
        cmp.set("v.showfilter",false);
        cmp.set("v.detailpage",false);
        cmp.set("v.showAllthemebutton",true);
        cmp.set("v.showdownarrow",true);
        cmp.set("v.showuparrow",false);
        cmp.set("v.showfeedback",false); 
        cmp.set("v.showchatter",false);
        
        var index=cmp.get("v.index");
        setTimeout(function() {
            $A.run(function() {
                $('.carousel').slick({'arrows': false}); 
            });
        });
    },
    callMyAction:function(cmp,event,helper){
        cmp.set("v.showswipe",false);
        cmp.set("v.MyActions",true);
        cmp.set("v.showfilter",false);
        cmp.set("v.detailpage",false);
        cmp.set("v.showtabs",true);
        cmp.set("v.showAllthemebutton",false);
        helper.showTabActive(cmp,event,'myaction');
    },
    gotoDetail : function(cmp,event,helper){
        var actId=event.getParam("actvityid");
        var page=event.getParam("pagename");
        var index=event.getParam("index");
        // Page Index for Backbutton
        var pageIndex=event.getParam("navigatePageIndex");
        cmp.set("v.pageIndex",pageIndex);
        cmp.set("v.index",index);
        cmp.set("v.pagename",page);
        cmp.set("v.selectedactivityId",actId);
        cmp.set("v.showInvitation",false);
        cmp.set("v.detailpage",false);
        cmp.set("v.MyActions",false);
        cmp.set("v.showtabs",false);
        cmp.set("v.showfeedback",false);
        cmp.set("v.showchatter",false);
        cmp.set("v.showswipe",false); 
        cmp.set("v.showAllthemebutton",false);
        cmp.set("v.showDetailCard",true);
        cmp.set("v.showchatter",false);
        cmp.set("v.showtodoactpage",false);
    },	
    
    showFeedback :function(cmp,event,helper){
        var actId=event.getParam("activityId");
        var memberid=event.getParam("team_memberid");
        var rating=event.getParam("participant_rating");
        var page=event.getParam("pagename");
        var index=event.getParam("index");
        // Page Index for Backbutton
        var pageIndex=event.getParam("navigatePageIndex");
        cmp.set("v.pageIndex",pageIndex);
        
        cmp.set("v.index",index);
        cmp.set("v.pagename",page);
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
        cmp.set("v.showDetailCard",false);
    },
    showToDoActivityPage : function(component, event, helper) {
         
        var actId=event.getParam("activityId");
        var page=event.getParam("pagename");
        var index=event.getParam("index");
        // Page Index for Backbutton
        var pageIndex=event.getParam("navigatePageIndex");
        component.set("v.pageIndex",pageIndex);
        component.set("v.index",index);
        component.set("v.pagename",page);
        component.set("v.activityId",actId);
        component.set("v.showfeedback",false);
        component.set("v.detailpage",false);
        component.set("v.showswipe",false);
        component.set("v.showtabs",false);
        component.set("v.MyActions",false);
        component.set("v.showAllthemebutton",false);
        component.set("v.showtodoactpage",true);
        component.set("v.showDetailCard",false);
        
    },
    
    gotoInvitation : function(component, event, helper) {
        var actId=event.getParam("activityId");
        var memberid=event.getParam("teamId");
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
    
    gotoDetail2 : function(cmp,event,helper){
        var actId=event.getParam("actvityid");
        var memberid=event.getParam("member_Id");
        var showcontent=event.getParam("showcontent");
        cmp.set("v.memberid",memberid);
        cmp.set("v.selectedactivityId",actId);
        cmp.set("v.showInvitation",false);
        cmp.set("v.detailpage",false);
        cmp.set("v.MyActions",true);
        cmp.set("v.showtabs",true); 
        cmp.set("v.showfeedback",false);
        cmp.set("v.showchatter",false);
        cmp.set("v.showtodoactpage",false); 
        cmp.set("v.showDetailCard",false);
        helper.getactivities1(cmp);
    },
    showShareComp : function(component, event, helper) {
       
        var actvity=event.getParam("activity");
        var id=event.getParam("activityId");
        var page=event.getParam("pagename");
        var index=event.getParam("index");
         // Page Index for Backbutton
         
        var pageIndex=event.getParam("navigatePageIndex");
        component.set("v.pageIndex",pageIndex);
        component.set("v.selectedactivityId",id); 
        component.set("v.index",index); 
        component.set("v.pagename",page);
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
        component.set("v.showDetailCard",false);
         
         
    },
    
    showPrevious : function(cmp,event,helper){
        var pagename=event.getParam("pagename");
        var index=event.getParam("index");
        var pageParamIndex=event.getParam("navigatePageIndex");
        cmp.set("v.pageIndex",pageParamIndex);
        console.log("pagename-->  "+pagename);
        if(pagename === 'swipe'){
            cmp.set("v.index",index);
            cmp.set("v.showfeedback",false);
            cmp.set("v.showDetailCard",false);
            cmp.set("v.showtabs",true);
            cmp.set("v.showswipe",true);
            cmp.set("v.MyActions",false);
            cmp.set("v.showfilter",false);
            cmp.set("v.detailpage",false);
            cmp.set("v.showAllthemebutton",true);
            cmp.set("v.showdownarrow",true);
            cmp.set("v.showuparrow",false);
            cmp.set("v.showfeedback",false); 
            cmp.set("v.showchatter",false);
            cmp.set("v.showtodoactpage",false); 
            var pageIndex = cmp.get("v.pageIndex");
            setTimeout(function() {
                $A.run(function() { 
                    $('.carousel').slick({'arrows': false});
                	$('.carousel').slick('slickGoTo',pageIndex,true);
               });
            });
            helper.showTabActive(cmp,event,'themes');
        }else  if(pagename ==='MyAction')
        {
            cmp.set("v.showfeedback",false);
            cmp.set("v.showswipe",false);
            cmp.set("v.MyActions",true);
            cmp.set("v.showfilter",false);
            cmp.set("v.detailpage",false);
            cmp.set("v.showDetailCard",false);
            cmp.set("v.showtabs",true);
            cmp.set("v.showAllthemebutton",false);
            cmp.set("v.showchatter",false);
            cmp.set("v.showtodoactpage",false); 
            helper.showTabActive(cmp,event,'myaction');
        }else if(pagename ==='Detailcard'){
            var actId=event.getParam("actvityid");
            var page=event.getParam("pagename");
            var index=event.getParam("index");
            cmp.set("v.index",index);
            cmp.set("v.pagename",page);
            cmp.set("v.selectedactivityId",actId);
            cmp.set("v.showInvitation",false);
            cmp.set("v.detailpage",false);
            cmp.set("v.MyActions",false);
            cmp.set("v.showtabs",false);
            cmp.set("v.showfeedback",false);
            cmp.set("v.showchatter",false);
            cmp.set("v.showDetailCard",true);
            cmp.set("v.showswipe",false); 
            cmp.set("v.showAllthemebutton",false);
            cmp.set("v.showDetailCard",true);
            cmp.set("v.showchatter",false);
            cmp.set("v.showtodoactpage",false);
        }else{
            cmp.set("v.showtodoactpage",false); 
            cmp.set("v.showInvitation",false);
            cmp.set("v.showswipe",false);
            cmp.set("v.MyActions",true);
            cmp.set("v.showfilter",false);
            cmp.set("v.detailpage",false);
            cmp.set("v.showDetailCard",false);
            cmp.set("v.showtabs",true);
            cmp.set("v.showAllthemebutton",false);
            cmp.set("v.showchatter",false);
            // Show tab active
            helper.showTabActive(cmp,event,'myaction');
        }
    },
})