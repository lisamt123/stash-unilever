({
    doInit: function(component, event, helper) { 
        component.set("v.latitude",null);
        component.set("v.longitude",null);
        component.set("v.contentId",null);
        component.set("v.versionId",null);
        var img=document.getElementsByClassName("img").visibility='hidden';
        var action = component.get("c.getSourceRetailerTopicCountry_CompetitorReport");
        action.setCallback(this, function(a) {
            var responseData = a.getReturnValue();
            component.set("v.objGetAgentDataResponse", responseData);
            component.set("v.clusterList",responseData.clusterList);
            component.set("v.countryList",responseData.countryList);
            component.set("v.allCountryList", responseData.countryList);
            component.set("v.sourceList", responseData.sourcePicklistValues);
            component.set("v.topicList", responseData.topicList );
            component.set("v.competitorNameList", responseData.competitorNameList);
            component.set("v.categoryList", responseData.categoryList);
            component.set("v.allCompetitorNameList", responseData.competitorNameList);
            component.set("v.allCategoryList", responseData.categoryList);
        });
        $A.run(function() {
            $A.enqueueAction(action); 
        });
        var actionIds = component.get("c.getfiterDataIds");
        actionIds.setCallback(this, function(a) {
            var responseId = a.getReturnValue();
            component.set("v.globalClusterId",responseId.GlobalClusterId);
            component.set("v.otherCompetitorBrandId",responseId.OtherCompetitorBrandId);
            component.set("v.showMap",true);
        });
        $A.enqueueAction(actionIds);
        
    },
    onSelectChangeCountry : function(component, event, helper) {
        var clusterId = component.find("clusterId").get("v.value");
        component.set("v.countryList",component.get("v.allCountryList"));
        var allCountryList =component.get("v.allCountryList");
        var newCountryList= [];
        //to enable and disable country dropdown list when Global cluster has been selected.
        if(clusterId===component.get("v.globalClusterId")){
            component.set("v.check","true");
        }else{
            component.set("v.check","false");
        }
        //to display the country list based on the cluster selected
        if(clusterId==="Select Cluster")
        {
            component.set("v.countryList", allCountryList) 
        }
        else
        {
            for (var ctry in allCountryList) {
                if (allCountryList.hasOwnProperty(ctry)) {
                    var ob = allCountryList[ctry];
                    var singleObj = [];
                    if(clusterId===ob.Cluster_Id__c)
                    {
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
    onSelectTopic : function(component, event, helper) {       
        var topicId = component.find("topic").get("v.value");  
        var topicList =component.get("v.topicList");
        var subTopicList= component.get("v.subTopicList");
        var nullTopicList= [];
        //to display the subTopic list based on the topic selected
        if(topicId ==="Select Topic")
        {	
            component.set("v.SubTopiccheck","true");
            component.set("v.subTopicList", nullTopicList);
            component.set("v.SubTopicNull", false);
        }
        else {	 
            component.set("v.SubTopicNull", false);
            component.set("v.SubTopiccheck", false);
            
            for (var topic in topicList) {
                if (topicList.hasOwnProperty(topic)) {
                    var ob = topicList[topic];              
                    if(ob.Id===topicId && ob.Sub_Topic__c != null){
                        var strsubTopic = ob.Sub_Topic__c;
                        var newString = strsubTopic.replace(/(\\r\\n)|( \\r\\n)/g,'');
                        subTopicList = newString.split('\;');
                        break;
                    }
                }
            }
            
            var nST='';
            var newSubTopicList=[];
            for(var sT in subTopicList){
                nST = JSON.stringify(subTopicList[sT]);
                nST = nST.replace(/(\\r\\n)|( \\r\\n)/g,'')
                nST = nST.replace('"','');
                nST = nST.replace('"','');
                newSubTopicList.push(nST);
            }
            component.set("v.subTopicList", newSubTopicList);
            component.set("v.SubTopiccheck", false);
        }
    },
    onSelectChangeSubTopic:function(component, event, helper) {
        //var resultCmp = component.find("Subtopic");
        //console.log("Selected Value====>"+ resultCmp.get("v.value"));
    },    
    handleIdUpdate : function(component, event, helper) {
        // Get the Id from the Event
        var recordId = event.getParam("sObjectId");
        var sObjAttributeName=event.getParam("sObjAttributeFieldName");
        component.set("v."+sObjAttributeName, recordId);
    },
    //Handler to receive the competitor Brand change.
    handleCompetitorBrandChange: function(component, event, helper) {
        //To display the other competetor name if Other brand selected
        var brandId=component.get("v.competitorBrandId");
        console.log("brandId: "+brandId);
        if(brandId===component.get("v.otherCompetitorBrandId"))
        {	console.log("inside other brand");
         component.set("v.others",true);
         component.set("v.Brand",false);
         component.set("v.disableOnBrandChange", true);
        }
        /*else
        {	
            component.set("v.others",false);
            component.set("v.Brand",true);
        }*/
        //To display the competitor name according to brand selection
        else if(brandId !=='null' && brandId !==component.get("v.otherCompetitorBrandId"))
        {	console.log("inside perticular brand");
         component.set("v.others",false);
         component.set("v.Brand",true);
         
         var action = component.get("c.getCompetitorCategory");
         action.setParams({ "competitorBrand" : brandId});
         var newBrandNameList= [];
         var newCategoryList= [];
         action.setCallback(this, function(a) {
             var brandList = a.getReturnValue();
             component.set("v.competitorNameList", brandList.Agent_Competitor_Id__c);
             for(var brand in brandList){
                 if (brandList.hasOwnProperty(brand)) {
                     var ob = brandList[brand];
                     var singleName = [];
                     var singleCategory =[];
                     singleName.Id=ob.Agent_Competitor_Id__r.Id;
                     singleName.Name=ob.Agent_Competitor_Id__r.Name;
                     newBrandNameList.push(singleName);
                     singleCategory.Id=ob.Category_Id__r.Id;
                     singleCategory.Name=ob.Category_Id__r.Name;
                     newCategoryList.push(singleCategory);
                 }
             }
             component.set("v.competitorNameList", newBrandNameList);
             component.set("v.categoryList", newCategoryList);
             component.find("competitorName").set("v.value",newBrandNameList[0].Id);
             component.find("category").set("v.value",newCategoryList[0].Id);
         });
         $A.enqueueAction(action);
        }        
            else
            {	
                
                component.set("v.others",false);
                component.set("v.Brand",true);
                console.log("inside else");
                var competitorName=component.get("v.allCompetitorNameList");
                var categoryList=component.get("v.allCategoryList");
                component.set("v.competitorNameList", competitorName);
                component.set("v.categoryList", categoryList);
                component.set("v.disableOnBrandChange", false);
            }
    },
    cancel: function(component, event, helper) {
        var selectEvent = $A.get("e.c:AA_NavigateToPageDetail");
        selectEvent.setParams({"navigate":"AA_LandingPageComponent","filterType":component.get("v.filterType"),"applyFilter":component.get("v.applyFilter"),"sortType":component.get("v.sortType"),"limitRecords":component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
    },
    handleSelectedUsers : function(component, event, helper) {
        // Get the list of the selected users
        var selectedUser=event.getParam("selectedUser");
        component.set("V.selectedUsers",selectedUser);    
    },
    goToConfirm: function(component, event, helper) { 
        
        var lat=component.get("v.latitude");
        var lng=component.get("v.longitude");
        
         
        var title=component.find("reportTitles");
        var titleVal=title.get("v.value");
        var source=component.find("Source");
        var sourceVal=source.get("v.value");
        var cluster=component.find("clusterId");
        var clusterVal=cluster.get("v.value");
        var country=component.find("countryId");
        var countryVal=country.get("v.value");
        var noErrors = true;
        title.set("v.errors", null);
        source.set("v.errors", null);
        cluster.set("v.errors", null);
        country.set("v.errors", null);
        
        if(component.get("v.showMap")){
            if(lat === null && lng === null  && (clusterVal==="Select Cluster" && countryVal === "Select Country")){
                noErrors=false;
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "mode":"sticky",
                    "message": 'Map view is not working properly. Either Turn off map view to enter manually or Try again.'
                });
                toastEvent.fire();
            }
        }
        if((clusterVal==="Select Cluster" && countryVal === "Select Country"))
        {
            component.set("v.submitButtonError",true);
            cluster.set("v.errors", [{message:"Please select either cluster or country"}]);
            country.set("v.errors", [{message:"Please select either cluster or country"}]);
            noErrors=false;
        }
        if(titleVal === ''){
            component.set("v.submitButtonError",true);
            title.set("v.errors", [{message:"Please enter a report title"}]);
            noErrors=false;
        }
        if(sourceVal=== "source"){
            component.set("v.submitButtonError",true);
            source.set("v.errors", [{message:"Please select a source"}]);
            noErrors=false;
        }
        if(noErrors){
            if(navigator.userAgent.match(/Android/i)
               || navigator.userAgent.match(/webOS/i)
               || navigator.userAgent.match(/iPhone/i)
               || navigator.userAgent.match(/iPad/i)){
                helper.scrollToLocation(component, "top");            
            }
            if(navigator.userAgent.match(/iPod/i)
               || navigator.userAgent.match(/BlackBerry/i)
               || navigator.userAgent.match(/Windows Phone/i)){
               helper.scrollToLocation(component, "top");
            }
            component.set("v.submitButtonError",false);
            title.set("v.errors", null);
            source.set("v.errors", null);
            cluster.set("v.errors", null);
            country.set("v.errors", null);
            var submitForm = component.find("submitForm");
            $A.util.addClass(submitForm, "hide-form");
            component.set("v.confirmForm","true");
            component.set("v.businessPrinciples","false");
            component.set("v.successMessage","false");
        }
    },
    showBusinessPrinciples: function(component, event, helper) {  
        component.set("v.submitForm","false");
        component.set("v.confirmForm","false");
        component.set("v.businessPrinciples","true");
        component.set("v.successMessage","false");
    },
    back: function(component, event, helper) { 
        if(navigator.userAgent.match(/Android/i)
           || navigator.userAgent.match(/webOS/i)
           || navigator.userAgent.match(/iPhone/i)
           || navigator.userAgent.match(/iPad/i)){
            helper.scrollToLocation(component, "top");            
        }
        if(navigator.userAgent.match(/iPod/i)
           || navigator.userAgent.match(/BlackBerry/i)
           || navigator.userAgent.match(/Windows Phone/i)){
            helper.scrollToLocation(component, "top");
        }
        var submitForm = component.find("submitForm");
        $A.util.addClass(submitForm, "hide-form");
        component.set("v.confirmForm","true");
        component.set("v.businessPrinciples","false");
        component.set("v.successMessage","false");
    },
    cancelSubmit: function(component, event, helper) {
        var submitForm = component.find("submitForm");
        $A.util.removeClass(submitForm, "hide-form");
        component.set("v.confirmForm","false");
        component.set("v.businessPrinciples","false");
        component.set("v.successMessage","false");
    },
    submitReport: function(component, event, helper) {
        
        component.set("v.disableButton",true);
        var selectedUsers=component.get("v.selectedUsers");
        var userIdString="";
        for(var sel in selectedUsers){
            if(selectedUsers.hasOwnProperty(sel)){
                var ob=selectedUsers[sel];
                if(userIdString.length === 0){
                    userIdString = ob.Id;
                }
                else{
                    userIdString=userIdString+","+ob.Id;
                }
            }
        }
        var clusterId=component.find("clusterId").get("v.value");
        var countryId=component.find("countryId").get("v.value");
        var competitorId="";
        var otherBrandName="";
        var otherCompetitor="";
        var categoryId=component.find("category").get("v.value");
        var topicId=component.find("topic").get("v.value");
        var	subTopic=component.find("Subtopic").get("v.value"); 
        var town=component.find("towns").get("v.value");
        var reportDescription=component.find("reportDesc").get("v.value");
        var brandId=component.get("v.competitorBrandId");
        if(brandId===component.get("v.otherCompetitorBrandId"))
        {
            competitorId=null;
            otherBrandName=component.get("v.otherBrandName");
            otherCompetitor=component.get("v.otherCompetitorName");
        }else{
            competitorId=component.find("competitorName").get("v.value");
            if(competitorId==="Select Competitor Name") {
                competitorId=null;
            }
            otherBrandName=null;
            otherCompetitor=null;
        }
        if(clusterId==="Select Cluster") {
            clusterId=null;}
        if(countryId==="Select Country"){
            countryId=null; }
        if(categoryId==="Select Category")
        {
            categoryId=null;
        }
        if(topicId==="Select Topic")
        {
            topicId=null;
        }
        if(subTopic==="Select SubTopic")
        {
            subTopic=null;
        }else{
            subTopic=component.find("Subtopic").get("v.value");
        }
        if(town===''){
            town=null;
        }
        if(reportDescription===''){
            reportDescription=null;
        }
        var action=component.get("c.insertAgentApp_Competitor");
        action.setParams({ "clusterId" :clusterId , 
                          "countryId" :countryId ,
                          "town":town ,
                          "reportName":component.find("reportTitles").get("v.value"),
                          "reportDescription": reportDescription,
                          "userIds": userIdString,
                          "source": component.find("Source").get("v.value"),
                          "competitorBrandId": component.get("v.competitorBrandId"),
                          "competitorId":competitorId,
                          "otherBrandName":otherBrandName,
                          "otherCompetitor":otherCompetitor,
                          "categoryId": categoryId,
                          "retailer": component.get("v.retailerId"),
                          "topicId": topicId,
                          "subTopic": subTopic,
                          "recordType":'Competitor',
                          "status":'ETS Approval Pending',
                          "contentId": component.get("v.contentId"),
                         });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set("v.disableButton",false);
                component.set("v.successMessage","true");     
                setTimeout(function() {
                    var selectEvent = $A.get("e.c:AA_NavigateToPageDetail");
                    selectEvent.setParams({"navigate":"AA_LandingPageComponent","filterType":component.get("v.filterType"),"sortType":component.get("v.sortType"),"limitRecords":component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
                },3000);
            }
            else{
                component.set("v.disableButton",false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": 'Your report was not saved successfully. Please try again later'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    handleContentVersionData:function(component,event,helper){
        component.set("v.contentId",event.getParam("cId"));    
        component.set("v.versionId",event.getParam("vId")); 
        component.set("v.attachedId",event.getParam("vId"));
    }, 
    gotoMap: function(component, event, helper) {
        var showMap = component.get("v.showMap");        
        if (showMap == true) {
            component.set("v.showMap",false);
            var manualLocation=component.find("ManualLocation");
            $A.util.removeClass(manualLocation, "hide-form"); 
            component.set("v.townName",'');
            component.find("countryId").set("v.value","Select Country");
        }
        if (showMap == false){
            component.set("v.showMap",true); 
            var manualLocation=component.find("ManualLocation");
            $A.util.addClass(manualLocation, "hide-form"); 
        }                             
    },
    getLocationDetails: function(component, event, helper) {
        var latitude=event.getParam("latitude");
        var Longitude=event.getParam("longitude");
        var countryName=event.getParam("countryName");
        var townName=event.getParam("townName");
        component.set("v.latitude",latitude);
        component.set("v.longitude",Longitude);
        component.set("v.townName",townName);
        var allCountryList=component.get("v.allCountryList");
        for (var ctry in allCountryList) {
            if (allCountryList.hasOwnProperty(ctry)) {
                var ob = allCountryList[ctry];
                var singleObj = [];
                if(countryName===ob.Name)
                {
                    component.find("countryId").set("v.value",ob.Id);
                }
            }
        }
    },
})