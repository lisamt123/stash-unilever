({
	eventsListData : function(component, event, helper) {
        console.log('------------start----------------');
        var action = component.get("c.getEventsList");
        component.set("v.displayError",false);
        action.setParams({
			"filterTopic": component.get("v.filterTopic"),
            "sortTopic": component.get("v.sortTopic")
		});
        
        console.log('------------1----------------');
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	console.log('------------2----------------');
        	if (state === "SUCCESS") {      
                if(response.getReturnValue()!='')   {
                    component.set("v.RecordTypeId",response.getReturnValue().DefaultRecordTypeId);
                    var temp = response.getReturnValue().Events;
                    console.log('------------Data-1----'+temp);
                    component.set("v.eventList",temp);
                    if(temp.length>0){
                       
                    	component.set("v.displayData",true);
                    
                    }else
                    {
                        component.set("v.displayData",false);}
                    console.log('------------Data-2----'+component.get("v.eventList"));
                } else
                     {
                     component.set("v.displayData",false); }
            } else
                {
                 component.set("v.displayError",true); }
        });
        $A.enqueueAction(action);        
        console.log('------------3----------------');
        var action1 = component.get("c.getCFCGAID");
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS" && response.getReturnValue()!='') {
              //  if(response.getReturnValue()!=''){                                         
                    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                                            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
                    ga('create', response.getReturnValue(), 'auto');
                    ga('send', 'pageview');
                }               
        });
        $A.enqueueAction(action1);
	},
    gotoFilter: function(component, event, helper) {
		var eventDetail=component.get("v.eventItem");
        var selectEvent=$A.get("e.c:CFC_HandleEvent");
        selectEvent.setParams({"componentName":"CFC_Filter","filterType":component.get("v.filterTopic"),"sortType":component.get("v.sortTopic")}).fire();
	},
    gotoSort: function(component, event, helper) {
		var eventDetail=component.get("v.eventItem");
        var selectEvent=$A.get("e.c:CFC_HandleEvent");
        selectEvent.setParams({"componentName":"CFC_Sort","filterType":component.get("v.filterTopic"),"sortType":component.get("v.sortTopic")}).fire();
	},
    createRecord: function(component, event, helper) {        
		var eventDetail=component.get("v.eventItem");
        var RecTypeId=component.get("v.RecordTypeId");
        var selectEvent=$A.get("e.c:CFC_HandleEvent");
        selectEvent.setParams({"componentName":"Create New","DefaultRecordTypeId":RecTypeId}).fire();        
    }
})