({
    /**
     * Perform the SObject search via an Apex Controller
     */
    doSearch : function(component) {
        
        // Get the search string, input element and the selection container
        var searchString = component.get("v.searchString");
        var inputElement = component.find('lookup');
        var lookupList = component.find("lookuplist");
        var lookupListItems = component.find("lookuplist-items");
        
        // Clear any errors and destroy the old lookup items container
        inputElement.set('v.errors', null);
        lookupListItems.set('v.body', new Array());
        
        // We need at least 2 characters for an effective search
        if ( searchString.charAt(0)!== "@" || typeof searchString === 'undefined' || searchString.length < 3)
        {
            return;
        }
        
        // Show the lookuplist
        $A.util.removeClass(lookupList, 'hide');
              
        // Create an Apex action
        var action = component.get("c.lookup");
        
        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();
        
        // Set the parameters
        action.setParams({ "searchString" : searchString.substring(1, searchString.length), "sObjectAPIName" : "User","recordType":"null"});
        
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            // Callback succeeded
            if (component.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var matches = response.getReturnValue();
                
                // If we have no matches, return
                if (matches.length == 0)
                {
                    return;
                }
                
                // Render the results
                this.renderLookupComponents(component, lookupListItems, matches);
            }
            else if (state === "ERROR") // Handle any error by reporting it
            {
                var errors = response.getError();
                
                if (errors) 
                {
                    if (errors[0] && errors[0].message) 
                    {
                        //this.displayToast('Error', errors[0].message);
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
        var listIconSVGPath = component.get('v.listIconSVGPath');
        var listIconClass = component.get('v.listIconClass');
        
        
        // Array of components to create
        var newComponents = new Array();
        
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
            if (status === "SUCCESS")
            {
                             
                var lookupList = component.find("lookuplist");
                $A.util.removeClass(lookupList, 'slds-hide');
                
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
            }
            else // Report any error
            {
                //this.displayToast('Error', 'Failed to create list components.');]
                console.log("Error: Failed to create list components.");
            }
        });
        
    },
    
    //var newUser = [];//variable that updates the newly added users to the selectedUSers
    /**
     * Handle the Selection of an Item
     */
    handleSelection : function(component, event) {
        // Resolve the Object Id from the events Element Id (this will be the <a> tag)
        var objectId = this.resolveId(event.currentTarget.id);
        
        
        // The Object label is the 2nd child (index 1)
        var objectLabel = event.currentTarget.children[1].innerText;
        
        var selectedUser=component.get("v.selectedUser");
        
        if($A.util.isEmpty(component.get("v.selectedUser")))
        {
            console.log("inside is Empty")
            var newUser=[];
            var singleUser= new Object();
            
            singleUser.Id=objectId;
            singleUser.Name=objectLabel;
            
            newUser.push(singleUser);
            component.set("v.selectedUser",newUser);
        }
        
        else
        {	
            var userList=component.get("v.selectedUser");
            var singleUser= new Object();
            
            for (var selected in userList) {
                if (userList.hasOwnProperty(selected)) {
                    var obj = userList[selected];
                    if(obj.Id===objectId){
                        // Update the Searchstring with the Label
                        component.set("v.searchString", "");
                        
                        component.set("v.selectedUserName",objectLabel);
                        component.set("v.showTag","true");
                        
                        // Hide the Lookup List
                        var lookupList = component.find("lookuplist");
                        $A.util.addClass(lookupList, 'slds-hide');
                        return;
                    }
                    
                }
            }
            
            singleUser.Id=objectId;
            singleUser.Name=objectLabel;
            
            userList.push(singleUser);
            component.set("v.selectedUser",userList);
            
            console.log("selectedUser==>"+JSON.stringify(component.get("v.selectedUser")));
        }
        
        // Update the Searchstring with the Label
        component.set("v.searchString", "");
        
        component.set("v.selectedUserName",objectLabel);
        component.set("v.showTag","true");
        
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