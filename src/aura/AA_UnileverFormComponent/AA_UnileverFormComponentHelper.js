({ 
    MAX_FILE_SIZE: 750 000, /* 1 000 000 * 3/4 to account for base64 */

    save : function(component,type) {
        var fileInput;
        if(type == "Cam")
        fileInput = component.find("fileCam").getElement();    
                
        if(type =="File")
        fileInput = component.find("fileImg").getElement();
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
            console.log(fileContents);
            component.set("v.cafeteriaMenuDetail","data:image/png;base64,"+encodeURIComponent(fileContents));                
      
                    self.upload(component, file, fileContents);
        };

        fr.readAsDataURL(file);
   },
        
    upload: function(component, file, fileContents) {
        var action = component.get("c.saveTheFile"); 
        alert('byes');
        action.setParams({
            parentId: '0012800000IrwVT',
            fileName: file.name,
            base64Data: encodeURIComponent(fileContents), 
            contentType: file.type
        });

        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            alert(attachId);
            
            console.log(attachId);
        });
            
        $A.run(function() {
            //$A.enqueueAction(action); 


        });
    },

})