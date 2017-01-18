({
	showFilePreviewSF1 : function(component, event, helper) {    
    
    var sObjectEvent = $A.get("e.force:navigateToSObject");
    var contentId = component.get("v.contentId");
    sObjectEvent.setParams({
    "recordId": contentId,
    "slideDevName": 'detail'
    })
    sObjectEvent.fire();
    } , 
    
    doInit : function(component, event, helper) { 
        var contentId = component.get("v.contentId");
        var versionId = component.get("v.versionId");
        var urlSegment = '/sfc/servlet.shepherd/version/renditionDownload?rendition=THUMB240BY180&versionId='+ versionId + '&operationContext=CHATTER&contentId=' + contentId + '&page=0';
		component.set("v.previewImageUrl", urlSegment);
    }
    
    
 })