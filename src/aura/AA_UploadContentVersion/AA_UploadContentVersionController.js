({
    upload : function(component, event, helper) {
        helper.uploadFile(component,event,'file'); 
    },
    uploadAttachement : function(component, event, helper) {
        helper.uploadFile(component,event,'fileAttachment'); 
    },
    uploadImage : function(component, event, helper) {
        helper.uploadFile(component,event,'fileImg'); 
    },
    closeUploadImg : function(component, event, helper){
        var cmpTargetHide = component.find('previewPlaceholder');
        $A.util.removeClass(cmpTargetHide, 'slds-show');
        $A.util.addClass(cmpTargetHide, 'slds-hide');   
    },
    closeUploadMsg : function(component, event, helper){
        var cmpTargetHide = component.find('previewPlaceholderMsg');
        $A.util.removeClass(cmpTargetHide, 'slds-show');
        $A.util.addClass(cmpTargetHide, 'slds-hide');   
    },
    waiting: function(component, event, helper) {
        $A.util.addClass(component.find("uploading").getElement(), "uploading");
        $A.util.removeClass(component.find("uploading").getElement(), "notUploading");
    },
    doneWaiting: function(component, event, helper) {
        $A.util.removeClass(component.find("uploading").getElement(), "uploading");
        $A.util.addClass(component.find("uploading").getElement(), "notUploading");
    }
})