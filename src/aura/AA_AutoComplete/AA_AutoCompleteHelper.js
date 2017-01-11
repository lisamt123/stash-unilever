({
    doSearch : function(component, event, helper) {
        component.set("v.wrongBrandName", false);
        var searchString = component.get("v.searchString");
        var inputElement = component.find('lookup');
        var lookupList = component.find("lookuplist");
        var lookupListItems = component.find("lookuplist-items");
        var searchInput=component.find("lookup");
        var searchInputVal=searchInput.get("v.value");
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        lookupListItems.set('v.body',[]);
        searchInput.set("v.errors", null);
        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 3)
        {	
            if(event.getParams().keyCode===13){
                searchInput.set("v.errors", [{message:"Please enter at least three characters to populate the dropdown list"}]);
            }
            // Hide the lookuplist
            $A.util.addClass(lookupList, 'hide');
            var updateEvent = component.getEvent("updateLookupIdEvent");
            // Populate the event with the selected Object Id
            updateEvent.setParams({
                "sObjectId" : "null",
                "sObjAttributeFieldName" : component.get("v.sObjAttributeName"),
            });
            // Fire the event
            updateEvent.fire();
            return;
        }
        if(event.getParams().keyCode===13){
            console.log("Enter key is pressed!!!");
            searchInput.set("v.errors", [{message:"Please select a specific value from the dropdown list"}]);
        }
        // Show the lookuplist
        $A.util.removeClass(lookupList, 'hide');
        // Get the API Name
        var sObjectAPIName = component.get('v.sObjectAPIName');
        //get the record type
        var sObjectRecordType= component.get('v.sObjectRecordType');
        // Create an Apex action
        var action = component.get("c.lookup");
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
        // Set the parameters
        action.setParams({ "searchString" : searchString, "sObjectAPIName" : sObjectAPIName,"recordType":sObjectRecordType});
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            // Callback succeeded
            if (component.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var matches=[];
                matches = response.getReturnValue();
                // If we have no matches, return
                if (matches.length === 0)
                {
                    searchInput.set("v.errors", [{message:"You are trying to enter Values not in our list. Please try again with a different Value."}]);
                    lookupListItems.set('v.body',[]);
                    // component.set("v.wrongBrandName", true);
                    //return;
                }
                // Render the results
                this.renderLookupComponents(component, lookupListItems, matches);
            }
            else if (state === "ERROR")
            {
                var errors = response.getError();
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        console.log("Error: "+errors[0].message);
                    }
                }
                else
                {
                    //this.displayToast('Error', 'Unknown error.');
                    console.log("Error: Unknown error. ");
                }
            }
        });
        // Enqueue the action                  
        $A.enqueueAction(action);                
    },
    /**
     * Render the Lookup List Components
     */   
    renderLookupComponents : function(component, lookupListItems, matches)
    {
        // list Icon SVG Path and Class
        var searchString = component.get("v.searchString");
        var listIconSVGPath = component.get('v.listIconSVGPath');
        var listIconClass = component.get('v.listIconClass');
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
                    "id" : component.getGlobalId() + '_id_' + matches[i].SObjectId, 
                    "role" : "option", 
                    "onclick" : component.getReference("c.select") 
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
            if(searchString.length >= 3){
                if (status === "SUCCESS")
                {
                    // Get the List Component Body
                    lookupListItems.set('v.body',[]);
                    var lookupListItemsBody = lookupListItems.get('v.body');
                    var lookupList = component.find("lookuplist");
                    $A.util.removeClass(lookupList, 'slds-hide');
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
                } else
                {
                    console.log("Error: Failed to create list components.");
                }
            }else{
                lookupListItems.set('v.body',[]);
            }
        });
    },
    /**
     * Handle the Selection of an Item
     */
    handleSelection : function(component, event) {
        // Resolve the Object Id from the events Element Id (this will be the <a> tag)
        var objectId = this.resolveId(event.currentTarget.id);
        // The Object label is the 2nd child (index 1)
        //console.log("handleSelection: "+event.currentTarget.children[1]);
        var objectLabel =event.currentTarget.textContent;
        // Create the UpdateLookupId event
        var updateEvent = component.getEvent("updateLookupIdEvent");
        var searchInput=component.find("lookup");
        var searchInputVal=searchInput.get("v.value");
        searchInput.set("v.errors",null);
        // Populate the event with the selected Object Id
        updateEvent.setParams({
            "sObjectId" : objectId,
            "sObjAttributeFieldName" : component.get("v.sObjAttributeName"),
        });
        // Fire the event
        updateEvent.fire();
        // Update the Searchstring with the Label
        component.set("v.searchString", objectLabel);
        // Hide the Lookup List
        var lookupList = component.find("lookuplist");
        $A.util.addClass(lookupList, 'slds-hide');
    },
    
    /**
     * Resolve the Object Id from the Element Id by splitting the id at the _
     */
    resolveId : function(elmId)
    {
        var i = elmId.lastIndexOf('_');
        return elmId.substr(i+1);
    },
})