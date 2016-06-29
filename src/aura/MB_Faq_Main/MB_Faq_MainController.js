({
	 getFaqListData : function(component, event, helper) {
		console.log('------------entry----------------');
        var action = component.get("c.getFaqList");
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {  
                component.set("v.faqList",response.getReturnValue());
            }   
              component.set("v.showspinner","false"); 
        });
        $A.enqueueAction(action);
         var action1 = component.get("c.getGAID");
         action1.setCallback(this, function(response) {
             var state = response.getState();
             if (state == "SUCCESS") {
                 //alert(response.getReturnValue());
                 if(response.getReturnValue()!=''){                                         
                     (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                         (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                             m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                                             })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
                     
                     ga('create',response.getReturnValue(), 'auto');
                     ga('send', 'pageview');
                     
                 }
             }                   
         });
         $A.enqueueAction(action1);
	},
    gotoDevices:function(component, event, helper) {
        var backEvent=$A.get("e.c:MB_Back_Evt");
        backEvent.setParams({"month":component.get("v.CurrentMonth"),"pagename":component.get("v.Pagename")}).fire();
                                                    
    },
})