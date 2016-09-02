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
        function dataURItoBlob(a) {
            for (var b = atob(a.split(",")[1]), c = [], d = 0; d < b.length; d++) { c.push(b.charCodeAt(d)); }
            return new Blob([new Uint8Array(c)], {
                type:'image/jpeg'
            })
        }
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
        var n = file.type.indexOf("image");
        if(n !== -1){
            if(extension=='jpg' || extension=='jpeg' || extension=='png' || extension=='gif'){
                var self = this;
                return void loadImage.parseMetaData(a, function(b) {
                    //if (!b.imageHead) return void UploadOtherFile(a);
                    var c = 0;
                    b.exif && (c = b.exif.get("Orientation")), console.log(c);
                    var d = new FileReader;
                    d.onloadend = function() {
                        var b = new Image;
                        b.src = d.result, b.onload = function() {
                            var d = "none";
                            8 === c ? (tempW = b.height, tempH = b.width, d = "left") : 6 === c ? (tempW = b.height, tempH = b.width, d = "right") : 1 === c ? (tempW = b.width, tempH = b.height) : 3 === c ? (tempW = b.width, tempH = b.height, d = "flip") : (tempW = b.width, tempH = b.height);
                            var e = 768,
                                f = 768;
                            tempW / e > tempH / f ? tempW > e && (tempH *= e / tempW, tempW = e) : tempH > f && (tempW *= f / tempH, tempH = f);
                            var g = document.createElement("canvas");
                            g.width = tempW, g.height = tempH;
                            var h = g.getContext("2d");
                            if (h.fillStyle = "white", h.fillRect(0, 0, g.width, g.height), "left" === d) { h.setTransform(0, -1, 1, 0, 0, tempH), h.drawImage(b, 0, 0, tempH, tempW); }
                            else if ("right" === d) { h.setTransform(0, 1, -1, 0, tempW, 0), h.drawImage(b, 0, 0, tempH, tempW); }
                                else if ("flip" === d) {
                                    var i = Math.PI,
                                        j = .5 * g.width,
                                        k = .5 * g.height;
                                    h.translate(j, k), h.rotate(i), h.translate(.5 * -tempW, .5 * -tempH), h.drawImage(b, 0, 0, tempW, tempH)
                                } else { h.setTransform(1, 0, 0, 1, 0, 0), h.drawImage(b, 0, 0, tempW, tempH); }
                            h.setTransform(1, 0, 0, 1, 0, 0);
                            var l = g.toDataURL("image/jpeg"),
                                m = dataURItoBlob(l);
                            console.log(m);
                            console.log("Type:"+ a.type);
                            self.upload(component, a, l);
                        }
                    }, d.readAsDataURL(a)
                })
            }
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
            //toPos = Math.min(fileContents.length, fromPos + self.CHUNK_SIZE);    
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
        //fileContents = fileContents.replace("data:image/jpeg;base64,","");
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
                console.log("Inside if frompos");
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