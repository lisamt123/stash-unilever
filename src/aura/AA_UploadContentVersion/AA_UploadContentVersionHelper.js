({
    MAX_FILE_SIZE: 4500000,/* 5 MB => Bytes*/
    CHUNK_SIZE: 250000,
    uploadFile : function(component,event,inputFileFieldName) {
        var fileInput = component.find(inputFileFieldName).getElement();
        var file = fileInput.files[0];
        var a = file;
        var filename = a.name;
        var extension = filename.replace(/^.*\./, '');
        extension = extension.toLowerCase();
        
        var n = file.type.indexOf("image");
        if(n !== -1){
        	var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": 'Image file type not allowed.'
            });
            toastEvent.fire();
            return;
        }else{
            if (file.size > this.MAX_FILE_SIZE) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "type":"error",
                    "message": 'Please upload a file size not exceeding 4.5 MB'
                });
                toastEvent.fire();
                return;
        	}
            var fr = new FileReader();
            var self = this;
            fr.onload = function() {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                self.upload(component, file, fileContents);
            };
            fr.readAsDataURL(file);
        }
    },
    upload: function(component, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        // start with the initial chunk
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '');   
    },
    uploadMobile: function(component, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);
        // start with the initial chunk
        this.uploadImageChunk(component, file, fileContents, fromPos, toPos, '');   
    },
    uploadImageChunk : function(component, file, fileContents, fromPos, toPos, attachedId) {
        console.log("inside uploadChunk helper uploadImageChunk "+attachedId);
        fileContents = fileContents.replace("data:image/jpeg;base64,","");
        var action = component.get("c.saveTheChunk"); 
        console.log("calling Action savethechunk");
        //var chunk = fileContents.substring(fromPos, toPos);
         $A.util.addClass(component.find("uploading").getElement(), "uploading");
        $A.util.removeClass(component.find("uploading").getElement(), "notUploading");
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type,
            fileId: attachedId
        });
        var self = this;
        action.setCallback(this, function(a) {
            var attachId = a.getReturnValue(); 
            console.log("attachId==>"+attachId);
            component.set("v.versionId",attachId);
            component.set("v.contentId",attachId);
            component.set("v.attachedId",attachId);
            fromPos = toPos;
            if (fromPos < toPos) {
                //console.log("Inside if frompos");
               // self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
            }else{
                console.log("File Uploaded Successfully.");
                self.showToast();
                var n = file.type.indexOf("image");
                if(n !== -1){
                    var cmpTarget = component.find('previewPlaceholder');
                    $A.util.removeClass(cmpTarget, 'slds-hide');
                    $A.util.addClass(cmpTarget, 'slds-show');
                    var cmpTargetHide = component.find('previewPlaceholderMsg');
                    $A.util.removeClass(cmpTargetHide, 'slds-show');
                    $A.util.addClass(cmpTargetHide, 'slds-hide');  
                }else{
                    var cmpTarget = component.find('previewPlaceholderMsg');
                    $A.util.removeClass(cmpTarget, 'slds-hide');
                    $A.util.addClass(cmpTarget, 'slds-show');
                    var cmpTargetHide = component.find('previewPlaceholder');
                    $A.util.removeClass(cmpTargetHide, 'slds-show');
                    $A.util.addClass(cmpTargetHide, 'slds-hide');        
                }
                urlString = "/sfc/servlet.shepherd/version/download/"+attachId;
                    /*$("#previewFile").html('<img  class="img-responsive pull-left prodImage" id="preview" alt=" " height="100" width="100"/>');
                    $("#previewFile").append('<i class="fa fa-times pull-right" onclick=\'closePrev("#previewFile")\'>');*/
                    $("#preview").attr('src', urlString);
                    $("#preview").show();
            }
            var compEvent = component.getEvent("uploadContentVersion");
            compEvent.setParams({"cId":attachId,"vId":attachId}).fire();
        	$A.util.removeClass(component.find("uploading").getElement(), "uploading");
        	$A.util.addClass(component.find("uploading").getElement(), "notUploading");
        });
        $A.run(function() {
            $A.enqueueAction(action); 
        });
    },
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachedId) {
        console.log("inside uploadChunk helper"+attachedId);
        var n = file.type.indexOf("image");
        var action = component.get("c.saveTheChunk"); 
        var chunk = fileContents.substring(fromPos, toPos);
        
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            fileId: attachedId
        });
        var self = this;
        action.setCallback(this, function(a) {
            var attachId = a.getReturnValue(); 
            console.log("attachId==>"+attachId);
            component.set("v.versionId",attachId);
            component.set("v.contentId",attachId);
            component.set("v.attachedId",attachId);
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);    
            if (fromPos < toPos) {
               	self.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
            }else{
                console.log("File Uploaded Successfully.");
                self.showToast();
                var n = file.type.indexOf("image");
                if(n !== -1){
                    var cmpTarget = component.find('previewPlaceholder');
                    $A.util.removeClass(cmpTarget, 'slds-hide');
                    $A.util.addClass(cmpTarget, 'slds-show');
                    var cmpTargetHide = component.find('previewPlaceholderMsg');
                    $A.util.removeClass(cmpTargetHide, 'slds-show');
                    $A.util.addClass(cmpTargetHide, 'slds-hide');  
                }else{
                    var cmpTarget = component.find('previewPlaceholderMsg');
                    $A.util.removeClass(cmpTarget, 'slds-hide');
                    $A.util.addClass(cmpTarget, 'slds-show');
                    var cmpTargetHide = component.find('previewPlaceholder');
                    $A.util.removeClass(cmpTargetHide, 'slds-show');
                    $A.util.addClass(cmpTargetHide, 'slds-hide');        
                }
              
            }
            var compEvent = component.getEvent("uploadContentVersion");
            compEvent.setParams({"cId":attachId,"vId":attachId}).fire();
        });
        $A.run(function() {
            $A.enqueueAction(action); 
        });
    },
    showToast : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type":"success",
            "message": "File has been uploaded successfully."
        });
        toastEvent.fire();
    }
    
})