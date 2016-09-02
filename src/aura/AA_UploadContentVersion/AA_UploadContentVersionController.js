({
    uploadImageMobile : function(component, event, helper) {
        //helper.uploadFile(component,event,'file'); 
        console.log("Inside the uploadImageTwo ");
		var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];
        var a = fileInput.files[0];
        var filename = a.name; 
        
        var extArray = ["exe", "svg","xml", "mp4","mp3","ini","dat","avi","gs","jar","bat"];
        //var fileInput = component.find("file").getElement();

        var extension = filename.replace(/^.*\./, '');
        console.log("Extension of the file==> "+extension);
        extension = extension.toLowerCase();
        var checkVal = extArray.indexOf(extension);
        if(checkVal != -1){
            $("#previewFile").html("<p  style='color:red;'>Please select valid file to upload. Valid file format e.g. '.jpg','.png','.gif', '.bmp', '.doc', '.csv', '.xls', '.ppt', '.pdf' etc</p>");
            $("#previewFile").append('<i class="fa fa-times pull-right" onclick=\'closePrev("#previewFile")\'>');
            $("#previewFile").show();
            return false;
        }
        function dataURItoBlob(a) {
            console.log("Error in Custom function");
            for (var b = atob(a.split(",")[1]), c = [], d = 0; d < b.length; d++){ c.push(b.charCodeAt(d));}
            return new Blob([new Uint8Array(c)], {
                type:'image/jpeg'
            })
        }

        if(a.size>0) {
            if(extension=='jpg' || extension=='jpeg' || extension=='png' || extension=='gif'){
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
                            if (h.fillStyle = "white", h.fillRect(0, 0, g.width, g.height), "left" === d) {h.setTransform(0, -1, 1, 0, 0, tempH), h.drawImage(b, 0, 0, tempH, tempW);}
                            else if ("right" === d) { h.setTransform(0, 1, -1, 0, tempW, 0), h.drawImage(b, 0, 0, tempH, tempW);}
                                else if ("flip" === d) {
                                    var i = Math.PI,
                                        j = .5 * g.width,
                                        k = .5 * g.height;
                                    h.translate(j, k), h.rotate(i), h.translate(.5 * -tempW, .5 * -tempH), h.drawImage(b, 0, 0, tempW, tempH)
                                } else { h.setTransform(1, 0, 0, 1, 0, 0), h.drawImage(b, 0, 0, tempW, tempH);}
                            h.setTransform(1, 0, 0, 1, 0, 0);
                            var l = g.toDataURL("image/jpeg"),
                                m = dataURItoBlob(l);
                            console.log(m);
                            console.log("Type:"+ a.type);
                            //helper.upload(component, a, l);
                            helper.uploadMobile(component, a, l);
                        }
                    }, d.readAsDataURL(a)
                })
                
            }
            else {
                //UploadOtherFile(a);
            	/* var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": 'Please upload file of image type only..!!'
            });
            toastEvent.fire();*/
                 helper.uploadFile(component,event,'file');
            }
        }
    },
    uploadAttachement : function(component, event, helper) {
        helper.uploadFile(component,event,'fileAttachment'); 
    },
   
    closeUploadImg : function(component, event, helper){
        var cmpTargetHide = component.find('previewPlaceholder');
        $A.util.removeClass(cmpTargetHide, 'slds-show');
        $A.util.addClass(cmpTargetHide, 'slds-hide');
        //$A.util.removeClass(component.find("uploading").getElement(), "uploading");
        //$A.util.addClass(component.find("uploading").getElement(), "notUploading");
    },
    closeUploadMsg : function(component, event, helper){
        var cmpTargetHide = component.find('previewPlaceholderMsg');
        $A.util.removeClass(cmpTargetHide, 'slds-show');
        $A.util.addClass(cmpTargetHide, 'slds-hide');
        //$A.util.removeClass(component.find("uploading").getElement(), "uploading");
        //$A.util.addClass(component.find("uploading").getElement(), "notUploading");
    },
    waiting: function(component, event, helper) {
        //$A.util.addClass(component.find("uploading").getElement(), "uploading");
        //$A.util.removeClass(component.find("uploading").getElement(), "notUploading");
    },
    doneWaiting: function(component, event, helper) {
        //$A.util.removeClass(component.find("uploading").getElement(), "uploading");
        //$A.util.addClass(component.find("uploading").getElement(), "notUploading");
    },
    uploadImageDesktop: function(component, event, helper){
        console.log("Inside the uploadImageTwo ");
		var fileInput = component.find("fileImg").getElement();
        var file = fileInput.files[0];
        var a = fileInput.files[0];
        var filename = a.name; 
        
        var extArray = ["exe", "svg","xml", "mp4","mp3","ini","dat","avi","gs","jar","bat"];
       

        var extension = filename.replace(/^.*\./, '');
        console.log("Extension of the file==> "+extension);
        extension = extension.toLowerCase();
        var checkVal = extArray.indexOf(extension);
        if(checkVal != -1){
            //alert("Please select valid file.");
            $("#previewFile").html("<p  style='color:red;'>Please select valid file to upload. Valid file format e.g. '.jpg','.png','.gif', '.bmp', '.doc', '.csv', '.xls', '.ppt', '.pdf' etc</p>");
            $("#previewFile").append('<i class="fa fa-times pull-right" onclick=\'closePrev("#previewFile")\'>');
            $("#previewFile").show();
            return false;
        }
        function dataURItoBlob(a) {
            console.log("Error in Custom function");
            for (var b = atob(a.split(",")[1]), c = [], d = 0; d < b.length; d++) { c.push(b.charCodeAt(d)); }
            return new Blob([new Uint8Array(c)], {
                type:'image/jpeg'
            })
        }
        if(a.size>0) {
            if(extension=='jpg' || extension=='jpeg' || extension=='png' || extension=='gif'){
               
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
                            if (h.fillStyle = "white", h.fillRect(0, 0, g.width, g.height), "left" === d) { h.setTransform(0, -1, 1, 0, 0, tempH), h.drawImage(b, 0, 0, tempH, tempW);}
                            else if ("right" === d) { h.setTransform(0, 1, -1, 0, tempW, 0), h.drawImage(b, 0, 0, tempH, tempW);}
                                else if ("flip" === d) {
                                    var i = Math.PI,
                                        j = .5 * g.width,
                                        k = .5 * g.height;
                                    h.translate(j, k), h.rotate(i), h.translate(.5 * -tempW, .5 * -tempH), h.drawImage(b, 0, 0, tempW, tempH)
                                } else { h.setTransform(1, 0, 0, 1, 0, 0), h.drawImage(b, 0, 0, tempW, tempH);}
                            h.setTransform(1, 0, 0, 1, 0, 0);
                            var l = g.toDataURL("image/jpeg"),
                                m = dataURItoBlob(l);
                            console.log(m);
                            console.log("Type:"+ a.type);
                            //helper.upload(component, a, l);
                            helper.uploadMobile(component, a, l);
                        }
                    }, d.readAsDataURL(a)
                })
                
            }
            
            else {	
                var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"error",
                "message": 'Please upload an image only'
            });
            toastEvent.fire();
            }
        }
    }
})