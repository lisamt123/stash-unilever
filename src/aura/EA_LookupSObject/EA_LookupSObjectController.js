({
	/**
     * Search an SObject for a match
     */
    search : function(cmp, event, helper) {
        var textToValidate = cmp.find("lookup").get("v.value");
        var patt = /[a-z,A-Z,\\s]/;
        if(!patt.test(textToValidate)){
            cmp.set("v.errorMessage","Please enter valid user name.");
            return;
        }
        cmp.set("v.errorMessage","");
        helper.doSearch(cmp);        
    },
 
    /**
     * Select an SObject from a list
     */
    select: function(cmp, event, helper) {
        helper.handleSelection(cmp, event);
    },
     
    /**
     * Clear the currently selected SObject
     */
    clear: function(cmp, event, helper) {
        console.log("Before clear action:"+ cmp.get('v.selectedUsers'));
        cmp.set('v.selectedUsers',[]);
        cmp.set('v.selectedItem',[]);
        cmp.set("v.errorMessage","");
        helper.clearSelection(cmp);    
        console.log("After Clear action:"+ cmp.get('v.selectedUsers'));
    },
    
    doInit: function(cmp, event, helper){
        cmp.set('v.selectedUsers',[]);
        cmp.set('v.selectedItem',[]);
        helper.getRecentItem(cmp);
    },
    handlePillUpdate : function(cmp, event, helper) {
    	helper.getItemResponse(cmp, event, helper);   
	}
        
})