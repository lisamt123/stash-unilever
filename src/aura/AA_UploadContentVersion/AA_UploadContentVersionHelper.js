({
    MAX_FILE_SIZE: 100000000, /* 1 000 000 * 3/4 to account for base64 */
     
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
})