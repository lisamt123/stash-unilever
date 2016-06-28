({
    MAX_FILE_SIZE: 4500000,/* 5 MB => Bytes*/
    CHUNK_SIZE: 250000,
    uploadFile : function(component,event,inputFileFieldName) {
        var fileInput = component.find(inputFileFieldName).getElement();
        var file = fileInput.files[0];
        console.log("File type:"+ file.type + '== Size:'+ file.size);
        if (file.size > this.MAX_FILE_SIZE) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": 'File size cannot exceed 4.5 MB'
            });
            toastEvent.fire();
            return;
        }
        var n = file.type.indexOf("image");
        if(n !== -1){
            var fr = new FileReader();
            var self = this;
            fr.onload = function() {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                component.set("v.cafeteriaMenuDetail","data:image/png;base64,"+encodeURIComponent(fileContents));   
                self.upload(component, file, fileContents);
            };
            fr.readAsDataURL(file);
        }else{
            var fr = new FileReader();
            var self = this;
            fr.onload = function() {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                //component.set("v.cafeteriaMenuDetail","data:image/png;base64,"+encodeURIComponent(fileContents));   
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
    uploadChunk : function(component, file, fileContents, fromPos, toPos, attachedId) {
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
    /*uploadFile1 : function(component,event,inputFileFieldName) {

        var fileInput = component.find(inputFileFieldName).getElement();
        var file = fileInput.files[0];
        console.log("File type:"+ file.type + '== Size:'+ file.size);
        var n = file.type.indexOf("image");
        if(n !== -1){
            var fr = new FileReader();
        	var self = this;
        	fr.onload = function() {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                component.set("v.cafeteriaMenuDetail","data:image/png;base64,"+encodeURIComponent(fileContents));   
                self.upload(component, file, fileContents);
            };
            fr.readAsDataURL(file);
           
        }else{
            var fr = new FileReader();
        	var self = this;
        	    fr.onload = function() {
                    var fileContents = fr.result;
                    var base64Mark = 'base64,';
                    var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                    fileContents = fileContents.substring(dataStart);
                    //component.set("v.cafeteriaMenuDetail","data:image/png;base64,"+encodeURIComponent(fileContents));   
                    self.upload(component, file, fileContents);
                    
                };
            fr.readAsDataURL(file);
            
        	
           
        }

    },
    upload: function(component, file, fileContents) {
        var action = component.get("c.uploadNewFile"); 
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.versionId",result.Id);
                console.log("======> Content Id: "+result.ContentDocumentId);
            	component.set("v.contentId",result.ContentDocumentId);
                console.log('===>'+JSON.stringify(result));
                var compEvent = component.getEvent("uploadContentVersion");
                compEvent.setParams({"cId":result.Id,"vId":result.ContentDocumentId}).fire();
                
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
        });
        
        
        $A.run(function() {
            $A.enqueueAction(action); 
        });
    },*/
    
    /* MAX_FILE_SIZE: 100000000, 
     
    uploadFile : function(component,event,inputFileFieldName) {

        var fileInput = component.find(inputFileFieldName).getElement();
        var file = fileInput.files[0];
        console.log("File type:"+ file.type + '== Size:'+ file.size);
        var n = file.type.indexOf("image");
        if(n !== -1){
            var fr = new FileReader();
        	var self = this;
        	fr.onload = function() {
                var fileContents = fr.result;
                var base64Mark = 'base64,';
                var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                fileContents = fileContents.substring(dataStart);
                component.set("v.cafeteriaMenuDetail","data:image/png;base64,"+encodeURIComponent(fileContents));   
                self.upload(component, file, fileContents);
            };
            fr.readAsDataURL(file);
           
        }else{
            var fr = new FileReader();
        	var self = this;
        	    fr.onload = function() {
                    var fileContents = fr.result;
                    var base64Mark = 'base64,';
                    var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
                    fileContents = fileContents.substring(dataStart);
                    //component.set("v.cafeteriaMenuDetail","data:image/png;base64,"+encodeURIComponent(fileContents));   
                    self.upload(component, file, fileContents);
                    
                };
            fr.readAsDataURL(file);
            
        	
           
        }

    },
    upload: function(component, file, fileContents) {
        var action = component.get("c.uploadNewFile"); 
        action.setParams({
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });
		
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                component.set("v.versionId",result.Id);
                console.log("======> Content Id: "+result.ContentDocumentId);
            	component.set("v.contentId",result.ContentDocumentId);
                console.log('===>'+JSON.stringify(result));
                var compEvent = component.getEvent("uploadContentVersion");
                compEvent.setParams({"cId":result.Id,"vId":result.ContentDocumentId}).fire();
                
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
        });
        
        
        $A.run(function() {
            $A.enqueueAction(action); 
        });
    },
     */
})