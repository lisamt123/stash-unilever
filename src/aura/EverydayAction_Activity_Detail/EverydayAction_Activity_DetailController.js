({
	
    /*getThemeColor : function(component, event, helper){
        var action =component.get("c.getThemeColor");
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()!=''){
                     var items=response.getReturnValue();
                     component.set("v.themecolor", response.getReturnValue());
                   }
                }
            });
            $A.enqueueAction(action);
    }, */
  doInit: function(component, event, helper) {
      /* -------- Added By Rajan ----------------*/
        var aid=component.get("v.activity");
           
        var action=component.get("c.getbooleanvalue");
      //  var share=component.find("txt").get("v.value");
        
        // alert(share); 
     action.setParams({"actID":aid.Id});
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    var items = response.getReturnValue();
                
                    if(items === true){
                     //alert(items);
                    component.set("v.check_image",true);
                    }else{
                         component.set("v.check_image",false);
                        //alert(v.check_image);
                    }
                }
            }
        });
        $A.enqueueAction(action);
      
      var rectype=component.get("v.themerecordtype");
        var action=component.get("v.themeColors");
         for (var prop in action) {
             if(prop == rectype){
                console.log("Key:" + prop);
                console.log("Value:" + action[prop]);
                 component.set("v.themecolor", action[prop]);
             }
            }
		/* -------- Added By Rajan ----------------*/
      	/* -------- Added By Ruma ----------------*/
      
      	var actvity=component.get("v.activity");
      
    	var numbers = [];
        for (var i = 0; i < actvity.Rating__c; i++) {
          numbers.push({
            value: i
          });
        }
          var remain = [];
          for (var i = 0; i < 5-actvity.Rating__c; i++) {
          remain.push({
            value: i
          });
      }
     
    component.set("v.numbers", numbers); 
    component.set("v.remain", remain);
      /* -------- end ----------------*/
    },
     getbooleanvalue1 :function(component, event, helper) {
        
        
          var aid=component.get("v.EAactivityid");
        // alert(aid);
        var action=component.get("c.getbooleanvalue");
      //  var share=component.find("txt").get("v.value");
        
        // alert(share); 
     action.setParams({"actID":aid});
         
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    var items = response.getReturnValue();
                   // alert(items);
                    if(items ===false){
                     
                    component.set("v.check_image",true);
                        //alert(v.check_image);
                    }
                }
            }
        });
        $A.enqueueAction(action);
        
    },
 chatterfeeditem1 :function(component, event, helper) {
        
        
       // var chatter = component.get("v.UserId");
        var action=component.get("c.chatterfeeditem");
      //  var share=component.find("txt").get("v.value");
        
        // alert(share); 
        //action.setParams({"comment":share});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    //alert("success");
                    
                    
                }
            }
        });
        $A.enqueueAction(action);
    
},
 


   insertteamrecord1 : function(component, event, helper) {
        var activityid = component.get("v.activity");
      //alert(activityid.Id);
        var action = component.get("c.insertteamrecord");
        action.setParams({"ActivityID" : activityid.Id});
        action.setCallback(this,function(response){
                if (response.getState() === "SUCCESS"){
                  
                }
            
           
        } );
  
        $A.enqueueAction(action);
   },
        showdetail : function(cmp,event,helper){
        var id=event.getParam("activityId");
       
        cmp.set("v.EAactivityid",id);
        
    }
    })