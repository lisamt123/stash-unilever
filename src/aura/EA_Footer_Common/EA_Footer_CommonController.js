({
    commentspage2 :function(cmp, event, helper) {
        helper.scrollToLocation(cmp, "top"); 
        var activity = cmp.get("v.activity");
        var pagename=cmp.get("v.pagename");
        // if(pagename ==='swipe'){
        //     pagename=pagename+'Detailcard';
        // }
        var currentSlide = $('.carousel').slick('slickCurrentSlide');
        cmp.set("v.pageIndex",currentSlide);
        var index=cmp.get("v.index");
        var pageIndex=cmp.get("v.pageIndex");
        var shareEvent=$A.get("e.c:EA_Showshare_Event");
        shareEvent.setParams({"pagename":pagename,"index":index,"activityId":activity,"navigatePageIndex":pageIndex});
        shareEvent.fire();
        
    },
    callfeedback:function(cmp,event,helper){
        helper.scrollToLocation(cmp, "top");  
        var activity = cmp.get("v.activity"); 
        var feedbacevent=$A.get("e.c:EA_Feedback_Event");
        var pagename=cmp.get("v.pagename");
        var themeColors=cmp.get("v.themeColors");
        
        //  if(pagename ==='swipe'){
        //   pagename=pagename+'Detailcard';
        // }
        var currentSlide = $('.carousel').slick('slickCurrentSlide');
        cmp.set("v.pageIndex",currentSlide);
        console.log("Current Slide Index:"+ currentSlide);
        
        var index=cmp.get("v.index");
        var pageIndex=cmp.get("v.pageIndex");
        feedbacevent.setParams({"activityId":activity,"pagename":pagename,"index":index,"navigatePageIndex":pageIndex,"themeColors":themeColors});
        feedbacevent.fire();
    },
    calltodoactivity:function(cmp,event,helper){
        helper.scrollToLocation(cmp, "top");
        var pagename=cmp.get("v.pagename");
        if(pagename ==='swipe'){
            pagename=pagename+'Detailcard';
        }
        var activity = cmp.get("v.activity");
        var pageIndex=cmp.get("v.pageIndex");
        var callactivity=$A.get("e.c:EA_ToDoActivity_Event");
        callactivity.setParams({"activityId":activity,"pagename":pagename,"navigatePageIndex":pageIndex});
        callactivity.fire();
    },
})