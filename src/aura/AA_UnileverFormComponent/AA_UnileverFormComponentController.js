({
    doInit: function(component, event, helper) {
        var action = component.get("c.getAutoPopulatedValues_UnileverReport");
        action.setCallback(this, function(a) {
            //console.log("ClusterList==>" + JSON.stringify(a.getReturnValue()));
            var responseData = a.getReturnValue();
            component.set("v.objGetAgentDataResponse", responseData);
            //console.log("objGetAgentDataResponse==>" + JSON.stringify(component.get("v.objGetAgentDataResponse")));
            component.set("v.clusterList",responseData.clusterList);
            component.set("v.countryList",responseData.countryList);
            component.set("v.allCountryList", responseData.countryList);
            component.set("v.reportingOnList",responseData.reportingOnPicklistValues);
        });
        $A.enqueueAction(action);
        
        var actionCluster = component.get("c.getGlobalClusterId");
        actionCluster.setCallback(this, function(a) {
            var responseId = a.getReturnValue();
            console.log("global id ==>"+responseId);
            component.set("v.globalClusterId",responseId);
        });
        $A.enqueueAction(actionCluster);
    },
    
    onSelectChangeCountry : function(component, event, helper) {
        
        var clusterId = component.find("clusterId").get("v.value");
        //var globalclusterId=component.get("v.globalClusterId");
        //alert("Id===>"+ Id);
        component.set("v.countryList",component.get("v.allCountryList"));
        var allCountryList =component.get("v.allCountryList");
        var newCountryList= [];
        
        //to enable and disable country dropdown list when Global cluster has been selected.
        if(clusterId===component.get("v.globalClusterId"))
        {
            component.set("v.check","true");
        }
        else
        {
            component.set("v.check","false");
        }
        
        //to display the country list based on the cluster selected
        if(clusterId=="Select a Cluster")
        {
            component.set("v.countryList", allCountryList) 
        }
        else
        {
            for (var ctry in allCountryList) {
                if (allCountryList.hasOwnProperty(ctry)) {
                    var ob = allCountryList[ctry];
                    var singleObj = new Object();
                    if(clusterId==ob.Cluster_Id__c)
                    {
                        console.log(clusterId +"==>"+ob.Id+"==>"+ ob.Name);
                        singleObj.Id=ob.Id;
                        singleObj.Name=ob.Name;
                        singleObj.Cluster_Id__c=ob.Cluster_Id__c;
                        newCountryList.push(singleObj);
                        
                    }
                    
                }
            }
            
            component.set("v.countryList", newCountryList);
        }
    },
    
    handleIdUpdate : function(component, event, helper) {
        // Get the Id from the Event
        var recordId = event.getParam("sObjectId");
        var sObjAttributeName=event.getParam("sObjAttributeFieldName");
        console.log("Attribute name==>"+sObjAttributeName);
        console.log("recordId ==>"+recordId);
        component.set("v."+sObjAttributeName, recordId);
    },
    
    handleSelectedUsers : function(component, event, helper) {
        
        // Get the list of the selected users
        var selectedUser=event.getParam("selectedUser");
        component.set("V.selectedUsers",selectedUser);    
    },
    
    
    cancel: function(component, event, helper) {
        var selectEvent = $A.get("e.c:AA_FilterEventAllReport");
        selectEvent.setParams({"componentName":"AA_ButtonComponent","sortType":component.get("v.sortType")}).fire(); 
    },
    
    saveImage : function(component, event, helper) {               
        alert('hi');
        helper.save(component,"Cam");
    },
    
    saveFile : function(component, event, helper) {               
        alert('hi');
        helper.save(component,"File");
    },
    
    submitReport: function(component, event, helper) {
        var selectedUsers=component.get("V.selectedUsers");
        //var addIds=[];
        var userIdString="";
        for (var sel in selectedUsers) {
            if (selectedUsers.hasOwnProperty(sel)) {
                var ob = selectedUsers[sel];
                if(userIdString.length === 0)
                {
                    userIdString=ob.Id;
                }
                else{
                    userIdString=userIdString+","+ob.Id;
                }
            }
        }
        
        var action=component.get("c.insertAgentApp");
        
        action.setParams({ "clusterId" :component.find("clusterId").get("v.value") , 
                          "countryId" :component.find("countryId").get("v.value") ,
                          "town":component.find("townValue").get("v.value") ,
                          "reportName":component.find("reportTitle").get("v.value") ,
                          "reportDescription": component.find("reportDesc").get("v.value"),
                          "userIds": userIdString,
                          "unileverBrandId": component.get("v.unileverBrandId"),
                          "retailerId": component.get("v.retailerId"),
                          "reportingOnId": component.find("reportingOnId").get("v.value"),
                          "recordType":'Unilever',
                          "status":'Published (Public)'
                         });
        
        action.setCallback(this, function(a) {
        });
        $A.enqueueAction(action);
    },
    
})