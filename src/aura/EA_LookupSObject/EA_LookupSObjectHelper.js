({
    getRecentItem : function(cmp){
        var action = cmp.get("c.getRecentlyWorkedWithUsers");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS' && response.getReturnValue()!==''){
                var items = response.getReturnValue();
                console.log("Helper getRecentItem"+JSON.stringify(items));
                cmp.set('v.recentItem',items);
            }
        });
        $A.enqueueAction(action);
    },
    /**
     * Perform the SObject search via an Apex Controller
     */
    doSearch : function(cmp) {
        cmp.set("v.errorMessage",'');
        // Get the search string, input element and the selection container
        var searchString = cmp.get("v.searchString");
        var inputElement = cmp.find('lookup');
        var lookupList = cmp.find("lookuplist");
        var lookupListItems = cmp.find("lookuplist-items");
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        lookupListItems.set('v.body',[]);
        if(inputElement.get('v.value').length < 2){
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 2)
        {
            // Hide the lookuplist
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }
        // Show the lookuplist
        $A.util.removeClass(lookupList, 'slds-hide');
        // Get the API Name
        var sObjectAPIName = cmp.get('v.sObjectAPIName');
        // Create an Apex action
        var action = cmp.get("c.lookup");
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
        // Set the parameters
        action.setParams({ "searchString" : searchString, "sObjectAPIName" : sObjectAPIName});
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            // Callback succeeded
            if (cmp.isValid() && state === "SUCCESS"){
                // Get the search matches
                var matches = response.getReturnValue();
                // If we have no matches, return
                if (matches.length === 0){
                    return;
                }
                // Render the results
                this.renderLookupComponents(cmp, lookupListItems, matches);
            }else if (state === "ERROR"){
                var errors = response.getError();
                console.log(errors);
            }
        });
        // Enqueue the action
        $A.enqueueAction(action);
    },
    /**
     * Render the Lookup List Components
     */
    renderLookupComponents : function(cmp, lookupListItems, matches)
    {
        // list Icon SVG Path and Class
        var listIconSVGPath = cmp.get('v.listIconSVGPath');
        var listIconClass = cmp.get('v.listIconClass');
        // Array of components to create
        var newComponents = [];
        // Add a set of components for each match found
        for (var i=0; i<matches.length; i++)
        {
            // li element
            newComponents.push(["aura:html", {
	                "tag" : "li",
                "HTMLAttributes" : {
                    "class" : "slds-lookup__item"
                }
            }]);
            // a element
            newComponents.push(["aura:html", {
                "tag" : "a",
                "HTMLAttributes" : {
                    "id" : cmp.getGlobalId() + '_id_' + matches[i].SObjectId,
                    "role" : "option",
                    "onclick" : cmp.getReference("c.select")
                }
            }]);
            // svg component
            newComponents.push(["c:svg", {
                "class" : "slds-icon " + listIconClass + " slds-icon--small",
                "xlinkHref" : listIconSVGPath
            }]);
            // output text component
            // For some reason adding an aura:id to this component failed to record the id for subsequent cmp.find requests
            newComponents.push(["ui:outputText", {
                "value" : matches[i].SObjectLabel
            }]);
        }
        // Create the components
        $A.createComponents(newComponents, function(components, status) {
            // Creation succeeded
            if (status === "SUCCESS"){
                // Get the List Component Body
                var lookupListItemsBody = lookupListItems.get('v.body');
                // Iterate the created components in groups of 4, correctly parent them and add them to the list body
                for (var i=0; i<components.length; i+=4)
                {
                    // Identify the releated components
                    var li = components[i];
                    var a = components[i+1];
                    var svg = components[i+2];
                    var outputText = components[i+3];
                    // Add the <a> to the <li>
                    var liBody = li.get('v.body');
                    liBody.push(a);
                    li.set('v.body', liBody);
                    // Add the <svg> and <outputText> to the <a>
                    var aBody = a.get('v.body');
                    aBody.push(svg);
                    aBody.push(outputText);
                    a.set('v.body', aBody);
                    // Add the <li> to the container
                    lookupListItemsBody.push(li);
                }
                // Update the list body
                lookupListItems.set('v.body', lookupListItemsBody);
           }else{
               console.log('Error:Failed to create list components.');
           }
        });
    },
    /**
     * Handle the Selection of an Item
     */
    handleSelection : function(cmp, event) {
        // Check the limit to select item
        var selectedUsers = cmp.get("v.selectedUsers");
        var maxLimit = cmp.get("v.maxLimit");
        var participantCount = cmp.get("v.participantCount");
        
       /* if(maxLimit === 1){
      		cmp.set("v.errorMessage","You can do this activity only with your self.");
             // Hide the Lookup List
            var lookupList = cmp.find("lookuplist");
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }
        */
            if((typeof selectedUsers !== 'undefined' ) && selectedUsers.length >= 10){ 
                var limitMsgBody = cmp.get('v.errorMessage');
                cmp.set("v.errorMessage","You can do this activity only with 10 colleagues(s).");
                // Hide the Lookup List
                var lookupList = cmp.find("lookuplist");
                $A.util.addClass(lookupList, 'slds-hide');
                return;
            }
       
        // Resolve the Object Id from the events Element Id (this will be the <a> tag)
        var objectId = this.resolveId(event.currentTarget.id);
        // The Object label is the 2nd child (index 1)
        var objectLabel = event.currentTarget.children[1].innerText;
        // Created array to store id and its name
        var sMcmp = cmp.get('v.selectedItem');
        var sIMap =[];
        for(k in sMcmp){
            if (sMcmp.hasOwnProperty(k)) {
                sIMap.push({'id':sMcmp[k]['id'],'name':sMcmp[k]['name']});
            }
        }
        sIMap.push({'id':objectId,'name':objectLabel});
        cmp.set('v.selectedItem',sIMap);
        // Create the UpdateLookupId event
        var updateEvent = cmp.getEvent("updateLookupIdEvent");
        // Populate the event with the selected Object Id
        updateEvent.setParams({
            "sObjectId" : objectId
        });
        // Fire the event
        updateEvent.fire();
        // Hide the Lookup List
        var lookupList = cmp.find("lookuplist");
        $A.util.addClass(lookupList, 'slds-hide');
        // Hide the Input Element
        var inputElement = cmp.find('lookup');
        inputElement.set('v.value','');
        // Show the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        this.renderLookupPill(cmp,lookupPill,selectedUsers);
        // Lookup Div has selection
        var inputElement = cmp.find('lookup-div');
        $A.util.addClass(inputElement, 'slds-has-selection');
    },
    selectedItemName : function(cmp,sId){
        var sMcmp = cmp.get('v.selectedItem');
        for(k in sMcmp){
            if(sMcmp[k]['id'] === sId){
                return sMcmp[k]['name'];
            }
        }
    },
    renderLookupPill:function (cmp,lookupPill,selectedUsers){
        lookupPill.set("v.body", []);
        $A.util.removeClass(lookupPill, 'slds-hide');
        // Array of components to create
        var newComponentsPill = [];
        // Add a set of components for each selected user
        for (var i=0; i<selectedUsers.length; i++)
        {
            // li element
            newComponentsPill.push(["aura:html", { "tag" : "span", "HTMLAttributes" : { "class" : "invt_lst" }}]);
            newComponentsPill.push(["ui:outputText", {"value" : this.selectedItemName(cmp,selectedUsers[i]) }]);
            newComponentsPill.push(["ui:button", {
                "HTMLAttributes" : {
                    "aura:id" : cmp.getGlobalId() + '_id_' + selectedUsers[i],
                    "class": "slds-button slds-button--icon-bare",
                    "press" : cmp.getReference("c.clear")
                }
            }]);
            // svg component
            newComponentsPill.push(["c:svg", {
                "class" : "slds-button__icon",
                "xlinkHref" : "/resource/EA_StaticResource/assets/icons/utility-sprite/svg/symbols.svg#close"
            }]);
        }
        // Create the components
        $A.createComponents(newComponentsPill, function(components, status) {
            // Creation succeeded
            if (status === "SUCCESS")
            {
                // Get the List Component Body
                var lookupListItemsBody = lookupPill.get('v.body');
                // Iterate the created components in groups of 4, correctly parent them and add them to the list body
                for (var i=0; i<components.length; i+=4)
                {
                    console.log("inner");
                    // Identify the releated components
                    var li = components[i];
                    var outputText = components[i+1];
                    // Add the <a> to the <li>
                    var liBody = li.get('v.body');
                    liBody.push(outputText);
                    li.set('v.body', liBody);
                    // Add the <li> to the container
                    lookupListItemsBody.push(li);
                }
                // Update the list body
                lookupPill.set('v.body', lookupListItemsBody);
           }
           else
           {
               console.log('Error: Failed to create user pill components.');
           }
        });
    },
    /**
     * Clear the Selection
     */
    clearSelection : function(cmp) {
        // Clear the Searchstring
        cmp.set("v.searchString", '');
        // Hide the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        lookupPill.set('v.body',[]);
        $A.util.addClass(lookupPill, 'slds-hide');
        // Show the Input Element
        var inputElement = cmp.find('lookup');
        $A.util.removeClass(inputElement, 'slds-hide');
        // Lookup Div has no selection
        var inputElement = cmp.find('lookup-div');
        $A.util.removeClass(inputElement, 'slds-has-selection');
    },
    /**
     * Resolve the Object Id from the Element Id by splitting the id at the _
     */
    resolveId : function(elmId)
    {
        var i = elmId.lastIndexOf('_');
        return elmId.substr(i+1);
    },
    getItemResponse : function(cmp, event, helper) {
        var itemId = event.getParam("item");
        var itemName = event.getParam("item_name");
       	// Check the limit to select item
        var selectedUsers = cmp.get("v.selectedUsers");
        var maxLimit = cmp.get("v.maxLimit");
        var participantCount = cmp.get("v.participantCount");
        /*
        if(maxLimit === 1){
      		cmp.set("v.errorMessage","You can do this activity only with your self.");
             // Hide the Lookup List
            var lookupList = cmp.find("lookuplist");
            $A.util.addClass(lookupList, 'slds-hide');
            return;
        }
        */
        if((typeof selectedUsers !== 'undefined' ) && selectedUsers.length >= 10){
            var limitMsgBody = cmp.get('v.errorMessage');
            cmp.set("v.errorMessage","You can do this activity only with 10 colleagues(s).");
            return;
        }
        
        var toDoActivityUser = cmp.get("v.selectedUsers");
        for (var i=0;i<toDoActivityUser.length;i++) {
            if (toDoActivityUser[i] == itemId) {
                //console.log("handleIdUpdate#User:"+ itemId +" already exist");
            	cmp.set("v.errorMessage", '"' + itemName +'" already selected.');
        		return;	 
             }
        }
 		toDoActivityUser.push(itemId);
        cmp.set('v.selectedUsers', toDoActivityUser);
        // Created array to store id and its name
        var sMcmp = cmp.get('v.selectedItem');
        var sIMap =[];
        for(k in sMcmp){
            if (sMcmp.hasOwnProperty(k)) {
                sIMap.push({'id':sMcmp[k]['id'],'name':sMcmp[k]['name']});
            }
        }
        sIMap.push({'id':itemId,'name':itemName});
        cmp.set('v.selectedItem',sIMap);
        // Show the Lookup pill
        var lookupPill = cmp.find("lookup-pill");
        this.renderLookupPill(cmp,lookupPill,selectedUsers);
	},
})