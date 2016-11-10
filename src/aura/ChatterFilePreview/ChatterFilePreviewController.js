({
    
    doInit : function(component, event, helper) {
        var versionId = component.get('v.versionId');
        var contentId = component.get('v.contentId');
      
        var urlSegment = '/sfc/servlet.shepherd/version/renditionDownload?rendition=SVGZ\&versionId='+ versionId + '&operationContext=CHATTER&contentId=' + contentId + '&page=';
     
		component.set("v.urlString",urlSegment);    
        component.set("v.ContentPages", "10");    
	},    
	defaultCloseAction1 : function(component, event, helper) {
        var idName = component.get('v.idName');
        //component.destroy();
        jQuery("."+idName).addClass("slds-hide");
    },
    
   showFilePreview : function (component, event){
       var idName = component.get('v.idName');
        jQuery("."+idName).removeClass("slds-hide");
    },
    
    doInitPDFViewer : function(component, helper) {      
        var fieldName = component.get('v.fieldName');
        var idName = component.get('v.idName');
        console.dir('FieldName '+fieldName);
        
        //PDFObject.embed(""+fieldName, "#"+idName);
    }, 
    
    defaultCloseAction : function(component, event, helper) {
    var idName = component.get('v.idName')
    //component.destroy();
    jQuery("."+idName).addClass("slds-hide");
    } ,
    
     mouseOver : function(component, event){
       jQuery(function() { 
	   jQuery(".zoomLG").css({
            display: "block"
        });
       } );
   },
   mouseOut : function(component, event){
       jQuery(function() { 
	   jQuery(".zoomLG").css({
            display: "none"
        });
       } );
   }
})s