({
	MAX_FILE_SIZE: 750 000, /* 1 000 000 * 3/4 to account for base64 */
    submitIdeaHelper: function(component,selectedCampaignId,selectedCategory) {
    	var fileInput = component.find("file").getElement();
    	var file = fileInput.files[0];   
        if (file.size > this.MAX_FILE_SIZE) {
            component.set("v.showspinner",false);
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' + 'Selected file size: ' + file.size);
    	    return;
        }        
		var self = this;
        var fr = new FileReader();  
       	fr.onload = function() {
            var fileContents = fr.result;
    	    var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);     
            self.submitIdea(component,selectedCampaignId,selectedCategory,file,fileContents);
        };
        fr.readAsDataURL(file);     	
	},
    submitIdea: function(component,selectedCampaignId,selectedCategory,file,fileContents) {     
        var fileName='';
        var fileContentType='';
		console.log('-------------11---------------'+fileContents);
        if(file.name!=''){             
            fileName = file.name;
            fileContentType = file.type;
        }                        
        var action = component.get("c.postSubmitAnIdea");
		action.setParams({
            "IdeaCampaignId":selectedCampaignId,
            "IdeaTitle":component.get("v.ideaTitle"),
            "IdeaDescription":component.get("v.ideaDescription"),
            "IdeaCategories":selectedCategory,
            "AttachmentName":fileName,
            "AttachmentBody":fileContents, 
            "AttachmentContentType":fileContentType
        });
        //base64Data: encodeURIComponent(fileContents), 
		console.log('-------------1---------------'+fileName);
		console.log('-------------3---------------'+fileContentType);   
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('-------------6---------------'+response.getState());
            if (state === "SUCCESS") {                    
                component.set("v.showspinner",false);
                if(response.getReturnValue()!=false){
                	component.set("v.displaySucessNotification",true);  
                }                    
            } else {
                component.set("v.showspinner",false);
                component.set("v.displayErrorMessage",true);    
            }     	                   
        });
            
        $A.run(function() {
            $A.enqueueAction(action); 
        });
    },
})