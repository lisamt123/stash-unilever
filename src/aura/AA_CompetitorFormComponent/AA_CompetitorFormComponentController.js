({
    
    saveImage : function(component, event, helper) {               
        alert('save image');
        helper.save(component,"Cam");
    },
    
    saveFile : function(component, event, helper) {               
        alert('hi');
        helper.save(component,"File");
    },
    
    doInit: function(component, event, helper) { 
        component.set("v.contentId",null);
        component.set("v.versionId",null);
        /*if(helper.checkMobileBrowser(component)){
        	helper.handleCompetitorBrandChange(component,event);   
        }*/
        var img=document.getElementsByClassName("img").visibility='hidden';
        
        var action = component.get("c.getSourceRetailerTopicCountry_CompetitorReport");
        action.setCallback(this, function(a) {
            console.log("ClusterList==>" + JSON.stringify(a.getReturnValue()));
            var responseData = a.getReturnValue();
            component.set("v.objGetAgentDataResponse", responseData);
            component.set("v.clusterList",responseData.clusterList);
            component.set("v.countryList",responseData.countryList);
            component.set("v.allCountryList", responseData.countryList);
            component.set("v.sourceList", responseData.sourcePicklistValues);
            component.set("v.topicList", responseData.topicList );
            component.set("v.competitorNameList", responseData.competitorNameList);
            component.set("v.categoryList", responseData.categoryList);
            
        });
        $A.enqueueAction(action);
        
    /*   var actionCluster = component.get("c.getGlobalClusterId");
        actionCluster.setCallback(this, function(a) {
            var responseId = a.getReturnValue();
            console.log("global id ==>"+responseId);
            component.set("v.globalClusterId",responseId);
        });
        $A.enqueueAction(actionCluster);
        
        var otherCompetitorBrandId = component.get("c.getOtherCompetitorBrandId");
        otherCompetitorBrandId.setCallback(this, function(a) {
            var responseId = a.getReturnValue();
            console.log("CompetitorBrand id ==>"+responseId);
            component.set("v.otherCompetitorBrandId",responseId);
        });
        $A.enqueueAction(otherCompetitorBrandId);*/
        
          var actionIds = component.get("c.getfiterDataIds");
        actionIds.setCallback(this, function(a) {
            var responseId = a.getReturnValue();
            component.set("v.globalClusterId",responseId.GlobalClusterId);
			component.set("v.otherCompetitorBrandId",responseId.OtherCompetitorBrandId);
        });
        
        $A.enqueueAction(actionIds);
        
        
    },
    onSelectChangeCountry : function(component, event, helper) {
        
        var clusterId = component.find("clusterId").get("v.value");
        
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
        if(clusterId=="Select Cluster")
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
    
    onSelectTopic : function(component, event, helper) {       
        var topicId = component.find("topic").get("v.value");  
        var topicList =component.get("v.topicList");
        var subTopicList= component.get("v.subTopicList");
        var nullTopicList= [];
        
        //to display the subTopic list based on the topic selected
        if(topicId =="Select Topic")
        {	
            component.set("v.SubTopiccheck","true");
            component.set("v.subTopicList", nullTopicList);
            component.set("v.SubTopicNull", false);
            
        }
        else
        {	 component.set("v.SubTopicNull", false);
         for (var ctry in topicList) {             
             var ob = topicList[ctry];              
             if(ob.Id==topicId && ob.Sub_Topic__c != null){
                 subTopicList = ob.Sub_Topic__c.split('\;');                                                       
             }
         }
         component.set("v.subTopicList", subTopicList);
         component.set("v.SubTopiccheck", false);
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
    
    //Handler to receive the competitor Brand change.
    handleCompetitorBrandChange: function(component, event, helper) {
        //To display the other competetor name if Other brand selected
        
        var brandId=component.get("v.competitorBrandId");
        if(brandId===component.get("v.otherCompetitorBrandId"))
        {
            component.set("v.others",true);
            component.set("v.Brand",false);
        }
        else
        {	
            component.set("v.others",false);
            component.set("v.Brand",true);
        }
        
        //To display the competitor name according to brand selection
        
        if(brandId !=='null')
        {
            var action = component.get("c.getCompetitorCategory");
            action.setParams({ "competitorBrand" : brandId});
            var newBrandNameList= [];
            var newCategoryList= [];
            
            
            action.setCallback(this, function(a) {
                var brandList = a.getReturnValue();
                component.set("v.competitorNameList", brandList.Agent_Competitor_Id__c);
                console.log("competitorNameList==>" + JSON.stringify(brandList));
                
                for(var brand in brandList){
                    if (brandList.hasOwnProperty(brand)) {
                        var ob = brandList[brand];
                        var singleName = new Object();
                        var singleCategory = new Object();
                        //console.log("competitorNameList==>"+JSON.stringify(ob.Agent_Competitor_Id__r.Name));
                        //console.log("competitorNameList==>"+JSON.stringify(ob.Category_Id__r.Name));
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
                
                
                
            });
            $A.enqueueAction(action);
        }        
        else
        {
            console.log("inside brandId==null condition")
            var competitorName=component.get("v.allCompetitorNameList");
            var categoryList=component.get("v.allCategoryList");
            
            component.set("v.competitorNameList", competitorName);
            component.set("v.categoryList", categoryList);
            component.set("v.disableOnBrandChange", false);
        }
    },
    
    cancel: function(component, event, helper) {
        var selectEvent = $A.get("e.c:AA_NavigateToPageDetail");
        selectEvent.setParams({"navigate":"AA_LandingPageComponent","filterType":component.get("v.filterType"),"sortType":component.get("v.sortType"),"limitRecords":component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
    },
    
    /*globalTask:function(component, event, helper){
        var cmpTarget = component.find('navigate');
        $A.util.addClass(cmpTarget, 'active_class');
        $A.util.removeClass(cmpTarget, 'inactive_class');
        var tasks = component.find('tasks');
        $A.util.addClass(tasks, 'inactive_class');
        $A.util.removeClass(tasks, 'active_class');
    },
    myTask:function(component, event, helper) {
        var cmpTarget = component.find('tasks');
        $A.util.addClass(cmpTarget, 'active_class');
        $A.util.removeClass(cmpTarget, 'inactive_class');
        var tasks = component.find('navigate');
        $A.util.addClass(tasks, 'inactive_class');
        $A.util.removeClass(tasks, 'active_class');
    },*/
    
    handleSelectedUsers : function(component, event, helper) {
        
        // Get the list of the selected users
        var selectedUser=event.getParam("selectedUser");
        component.set("V.selectedUsers",selectedUser);    
    },
    goToConfirm: function(component, event, helper) {
       /* if(helper.checkMobileBrowser(component)){
            helper.scrollToLocation(component, "top");
        }*/
        if(navigator.userAgent.match(/Android/i)
            || navigator.userAgent.match(/webOS/i)
            || navigator.userAgent.match(/iPhone/i)
            || navigator.userAgent.match(/iPad/i)
            || navigator.userAgent.match(/iPod/i)
            || navigator.userAgent.match(/BlackBerry/i)
            || navigator.userAgent.match(/Windows Phone/i)){
        	helper.scrollToLocation(component, "top");
    	}
        var title=component.find("reportTitles");
        var titleVal=title.get("v.value");
        var source=component.find("Source");
        var sourceVal=source.get("v.value");
        var cluster=component.find("clusterId");
        var clusterVal=cluster.get("v.value");
        var country=component.find("countryId");
        var countryVal=country.get("v.value");
        if(titleVal === '' && sourceVal=== "source" && (clusterVal==="Select Cluster" && countryVal === "Select Country"))
        {
            title.set("v.errors", [{message:"This field is required."}]);
            source.set("v.errors", [{message:"This field is required."}]);
            cluster.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
            country.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
        }
        else if(titleVal === '' || sourceVal=== "source" || (clusterVal==="Select Cluster" && countryVal === "Select Country"))
        {
            if(titleVal === '' )
            {
                if(sourceVal=== "source")
                {
                    cluster.set("v.errors", null);
                    country.set("v.errors", null);
                    title.set("v.errors", [{message:"This field is required."}]);
                    source.set("v.errors", [{message:"This field is required."}]);
                }
                else if(clusterVal==="Select Cluster" && countryVal === "Select Country")
                {
                    title.set("v.errors", [{message:"This field is required."}]);
                    source.set("v.errors", null);
                    cluster.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
                    country.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
                }
                    else{
                        title.set("v.errors", [{message:"This field is required."}]);
                        source.set("v.errors", null);
                        cluster.set("v.errors", null);
                        country.set("v.errors", null);
                    }
            }
            else if(sourceVal=== "source")
            {
                if(clusterVal==="Select Cluster" && countryVal === "Select Country")
                {
                    source.set("v.errors", [{message:"This field is required."}]);
                    title.set("v.errors", null);
                    cluster.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
                    country.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
                }
                else{
                    source.set("v.errors", [{message:"This field is required."}]);
                    title.set("v.errors", null);
                    cluster.set("v.errors", null);
                    country.set("v.errors", null);
                }
            }
                else 
                {
                    title.set("v.errors", null);
                    source.set("v.errors", null);
                    cluster.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
                    country.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);                  
                }
        }
            else{
                title.set("v.errors", null);
                source.set("v.errors", null);
                cluster.set("v.errors", null);
                country.set("v.errors", null);
               var submitForm = component.find("submitForm");
                $A.util.addClass(submitForm, "hide-form");

                //var confirmForm = component.find("confirmForm");
                
               // $A.util.removeClass(confirmForm, "hide-form");
               // window.scroll(0, 0);
                //var businessPrinciples = component.find("businessPrinciples");
                //$A.util.addClass(businessPrinciples, "hide-form");            
            	//component.set("v.submitForm","false");
                 component.set("v.confirmForm","true");
                component.set("v.businessPrinciples","false");
                component.set("v.successMessage","false");
            }
    },
    showBusinessPrinciples: function(component, event, helper) { 
        //component.set("v.confirmSubmit",false);
        //component.set("v.businessPrinciples",true);
        //var submitForm = component.find("submitForm");
       // $A.util.addClass(submitForm, "hide-form");
        /*var confirmForm = component.find("confirmForm");
        $A.util.addClass(confirmForm, "hide-form");
        var businessPrinciples = component.find("businessPrinciples");
        $A.util.removeClass(businessPrinciples, "hide-form");*/
        component.set("v.submitForm","false");
        component.set("v.confirmForm","false");
        component.set("v.businessPrinciples","true");
        component.set("v.successMessage","false");
        
        
    },
    back: function(component, event, helper) { 
      var submitForm = component.find("submitForm");
        $A.util.addClass(submitForm, "hide-form");
        /*  var confirmForm = component.find("confirmForm");
        $A.util.removeClass(confirmForm, "hide-form");
        var businessPrinciples = component.find("businessPrinciples");
        $A.util.addClass(businessPrinciples, "hide-form");*/
        //component.set("v.confirmSubmit",true);
        // component.set("v.businessPrinciples",false);
        //component.set("v.submitForm","false");
        component.set("v.confirmForm","true");
        component.set("v.businessPrinciples","false");
        component.set("v.successMessage","false");
    },
    cancelSubmit: function(component, event, helper) {
        var submitForm = component.find("submitForm");
        $A.util.removeClass(submitForm, "hide-form");
       /* var confirmForm = component.find("confirmForm");
        $A.util.addClass(confirmForm, "hide-form");
        var businessPrinciples = component.find("businessPrinciples");
        $A.util.addClass(businessPrinciples, "hide-form");*/
        // var confirmForm = component.find("submitForm");
        //$A.util.removeClass(confirmForm, "hide-form");
        // component.set("v.submitButton",true);
        // component.set("v.confirmSubmit",false);
       // component.set("v.submitForm","true");
        component.set("v.confirmForm","false");
        component.set("v.businessPrinciples","false");
        component.set("v.successMessage","false");
    },
    submitReport: function(component, event, helper) {
        //alert("hi");
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
        var competitorId=component.find("competitorName").get("v.value");
        var categoryId=component.find("category").get("v.value");
        var topicId=component.find("topic").get("v.value");
        var	subTopic=component.find("Subtopic").get("v.value");  
        var town=component.find("towns").get("v.value");
        var reportDescription=component.find("reportDesc").get("v.value");
        if(clusterId==="Select Cluster")
        {
            clusterId=null;
        }
        if(countryId==="Select Country")
        {
            countryId=null;
        }
        if(competitorId==="Select Competitor Name")
        {
            competitorId=null;
        }
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
        }
        if(town===''){
            town=null;
        }
        if(reportDescription===''){
            reportDescription=null;
        }

        console.log("clusterId==>"+clusterId);
        console.log("countryId==>"+countryId);
        console.log("town==>"+town);
        console.log("reportName==>"+component.find("reportTitles").get("v.value"));
        console.log("reportDescription==>"+reportDescription);
        console.log("userIds==>"+userIdString);
        console.log("source==>"+component.find("Source").get("v.value"));
        console.log("competitorBrandId==>"+component.get("v.competitorBrandId"));
        console.log("competitorId==>"+competitorId);
        console.log("categoryId==>"+categoryId);
        console.log("retailer==>"+component.get("v.retailerId"));
        console.log("topicId==>"+topicId);
        console.log("subTopic==>"+subTopic);
     
       var action=component.get("c.insertAgentApp_Competitor");
        
        var brandId=component.get("v.competitorBrandId");
        if(brandId===component.get("v.otherCompetitorBrandId"))
        {
            action.setParams({ "clusterId" :clusterId , 
                              "countryId" :countryId ,
                              "town":town ,
                              "reportName":component.find("reportTitles").get("v.value"),
                              "reportDescription": reportDescription,
                              "userIds": userIdString,
                              "source": component.find("Source").get("v.value"),
                              "competitorBrandId": component.get("v.competitorBrandId"),
                              "competitorId":null,
                              "otherBrandName":component.get("v.otherBrandName"),
                              "otherCompetitor":component.get("v.otherCompetitorName"),
                              "categoryId": categoryId,
                              "retailer": component.get("v.retailerId"),
                              "topicId": topicId,
                              "subTopic ": subTopic,
                              "recordType":'Competitor',
                              "status":'ETS Approval Pending',
                              "contentId": component.get("v.contentId"),
                             });
        }
        else
        {
            action.setParams({ "clusterId" :clusterId , 
                              "countryId" :countryId ,
                              "town":town ,
                              "reportName":component.find("reportTitles").get("v.value"),
                              "reportDescription": reportDescription,
                              "userIds": userIdString,
                              "source": component.find("Source").get("v.value"),
                              "competitorBrandId": component.get("v.competitorBrandId"),
                              "competitorId":competitorId,
                              "otherBrandName":null,
                              "otherCompetitor":null,
                              "categoryId": categoryId,
                              "retailer": component.get("v.retailerId"),
                              "topicId": topicId,
                              "subTopic": subTopic,
                              "recordType":'Competitor',
                              "status":'ETS Approval Pending',
                              "contentId": component.get("v.contentId"),
                             });
        }
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set("v.successMessage","true");     
                setTimeout(function() {
                    var selectEvent = $A.get("e.c:AA_NavigateToPageDetail");
                    selectEvent.setParams({"navigate":"AA_LandingPageComponent","filterType":component.get("v.filterType"),"sortType":component.get("v.sortType"),"limitRecords":component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
                },5000);
               // var successMessage = component.find("successMessage");
                //$A.util.removeClass(successMessage, "hide-form");
            }
            else{
                alert("Record Not Saved..!");
            }
        });
        $A.enqueueAction(action);
  
       
   },
   handleContentVersionData:function(component,event,helper){
        component.set("v.contentId",event.getParam("cId"));    
    	component.set("v.versionId",event.getParam("vId"));    
	}, 
})