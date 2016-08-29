({
   
  	sharePost : function(component) {
    
    var textToPost = component.get("v.textToPost");
    var subjectId  = component.get("v.subjectId");
    var fileContentId = component.get("v.recordId");
        this.showSpinner(component);
        if (fileContentId != null && fileContentId != "") {
            //existing file
            var fileContentId = component.get("v.recordId");
            var action = component.get("c.postFeedElementWithExistingFile");
            action.setParams({
                "subjectId" : subjectId,
                "textSegment": textToPost,
                "contentDocumentId" : fileContentId
                 });	
            //Set up the callback
            var self = this;
            action.setCallback(this, function(actionResult) {
                component.set("v.textToPost", "");  
                component.set("v.recordId", ""); 
                var evt1 = $A.get("e.c:ChatterRefreshFeed");
   				evt1.fire();
                var evt2 = $A.get("e.c:ClearLookup");
     			evt2.fire();
                this.hideSpinner(component);
            });
                
            $A.enqueueAction(action);
            jQuery('#filename').empty();
        } else if(component.find("file").getElement().files[0]) {
            // new uploaded file
            var self = this;
            self.uploadFile(component);
            jQuery('#filename').empty();
        } else  {
            var action = component.get("c.postFeedElement");
            action.setParams({
                "messageToPost" : textToPost,
                "subjectId": subjectId
                 });	
            //Set up the callback
            var self = this;
            action.setCallback(this, function(actionResult) {
                component.set("v.textToPost", "");
                var evt1 = $A.get("e.c:ChatterRefreshFeed");
   				evt1.fire();
                this.hideSpinner(component);
            });
               
            $A.enqueueAction(action);
        }
        
    component.find("attachNewFileB").getElement().disabled = false; 
    
    
  } ,
    
   
    
    showPopUp : function(component) {
        jQuery(".ModalDialogPlaceholderFileUpload").removeClass("slds-hide");
        //Added by AES
        jQuery("#file").change(function(){
          jQuery(".ModalDialogPlaceholderFileUpload").addClass("slds-hide");
       });
       jQuery(".searchInput").focus();
       var dropZoneId = "drop-zone";
        //var buttonId = "clickHere";
        var mouseOverClass = "mouse-over";
        
        var dropZone = jQuery("#" + dropZoneId);
        var ooleft = dropZone.offset().left;
        var ooright = dropZone.outerWidth() + ooleft;
        var ootop = dropZone.offset().top;
        var oobottom = dropZone.outerHeight() + ootop;
        var inputFile = dropZone.find("input");
        document.getElementById(dropZoneId).addEventListener("dragover", function (e) {
        e.preventDefault();
        e.stopPropagation();
        dropZone.addClass(mouseOverClass);
        var x = e.pageX;
        var y = e.pageY;

        if (!(x < ooleft || x > ooright || y < ootop || y > oobottom)) {
            inputFile.offset({
                top: y - 15,
                left: x - 100
            });
        } else {
            inputFile.offset({
                top: -400,
                left: -400
            });
        }

    }, true); 

   /* if (buttonId != "") {
        var clickZone = jQuery("#" + buttonId);

        var oleft = clickZone.offset().left;
        var oright = clickZone.outerWidth() + oleft;
        var otop = clickZone.offset().top;
        var obottom = clickZone.outerHeight() + otop;

        jQuery("#" + buttonId).mousemove(function (e) {
            var x = e.pageX;
            var y = e.pageY;
            if (!(x < oleft || x > oright || y < otop || y > obottom)) {
                inputFile.offset({
                    top: y - 15,
                    left: x - 160
                });
            } else {
                inputFile.offset({
                    top: -400,
                    left: -400
                });
            }
        });
    }*/

    document.getElementById(dropZoneId).addEventListener("drop", function (e) {
        jQuery("#" + dropZoneId).removeClass(mouseOverClass);
    }, true);

    inputFile.on('change', function (e) {
        jQuery('#filename').html("");
        var fileNum = this.files.length,
            initial = 0,
            counter = 0,
            fileNames = "";
                              
        for (initial; initial < fileNum; initial++) {
            counter = counter + 1;
            fileNames += this.files[initial].name + '&nbsp;';
        }
        if(fileNum > 1)
            fileNames = 'Files selected...';
        else
        	fileNames = this.files[0].name + '&nbsp;';
            jQuery(".attachmentContainer").show();
            jQuery('#filename').append(''+fileNames);
       		// add remove event
           jQuery('.closePreviewFile').click(function(){
              jQuery('#filename').empty();
              jQuery(".attachmentContainer").hide();
              inputFile.val('');
              component.find("attachNewFileB").getElement().disabled = false;
          });
        jQuery(".ModalDialogPlaceholderFileUpload").addClass("slds-hide");
        var evt = $A.get("e.c:ClearLookup");
        evt.fire();
        component.find("attachNewFileB").getElement().disabled = true;
        jQuery(".lookup-input").focus();

      ///End change 
    });
	
   //END AES
    }  ,
    
     doInit : function(component) {
        var subjectId  = component.get("v.subjectId");
        var action = component.get("c.getSubjectNameById");
        action.setParams({
            "subjectId": subjectId
         });
        var self = this;
   		 action.setCallback(this, function(actionResult) {
        component.set("v.to", actionResult.getReturnValue());            
    	});
        $A.enqueueAction(action);
        
         
    } ,
    
    
    
   // MAX_FILE_SIZE: 4 500 000, /* 6 000 000 * 3/4 to account for base64 */
   // CHUNK_SIZE: 475 000, /* Use a multiple of 4 */
    //
    MAX_FILE_SIZE: 1 000 000,
    CHUNK_SIZE: 1 000 000,
    
    uploadFile : function(component) {

       var fileInput = component.find("file").getElement();
       var file = fileInput.files[0];
   
     	if (file.size > this.MAX_FILE_SIZE) {
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
    		  'Selected file size: ' + file.size);
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

    },
        
    upload: function(component, file, fileContents) {
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);

        // start with the initial chunk
        this.uploadChunk(component, file, fileContents, fromPos, toPos, '');
        
    },
        
    uploadChunk: function(component, file, fileContents, fromPos, toPos, attachId) {
         var action = component.get("c.uploadNewFile");
         var textToPost = component.get("v.textToPost");
    	 var subjectId  = component.get("v.subjectId");
         var chunk = fileContents.substring(fromPos, toPos);

        action.setParams({
            parentId: component.get("v.parentId"),
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            contentType: file.type,
            subjectId : subjectId,
            textToPost : textToPost,
            fileId: attachId
        });

        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + this.CHUNK_SIZE);  
            if (fromPos < toPos) {
                this.uploadChunk(component, file, fileContents, fromPos, toPos, attachId);  
            }
            component.set("v.textToPost", "");
            component.find("file").getElement().value='';
            var evt = $A.get("e.c:ChatterRefreshFeed");
       		evt.fire();
            this.hideSpinner(component);
         	
        });
            
        $A.run(function() {
            $A.enqueueAction(action); 
        });
        
     

        jQuery('#filename').empty();

        
    } ,
        
        showSpinner : function (component) {
        var spinner = component.find('publisherSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    hideSpinner : function (component) {
        var spinner = component.find('publisherSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    }
    
})