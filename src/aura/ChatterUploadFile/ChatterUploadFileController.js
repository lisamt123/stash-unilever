({
	defaultCloseAction : function(component, event, helper) {
        //component.destroy();
        jQuery(".ModalDialogPlaceholder").addClass("slds-hide");
    },
    
    uploadFile : function(component, event, helper) {
        helper.uploadFile(component); 
        jQuery(".ModalDialogPlaceholder").addClass("slds-hide");
    }
})