({
    MAX_FILE_SIZE: 750 000, /* 1 000 000 * 3/4 to account for base64 */

    save : function(component,type) {
        alert('save image helper'+type);
        var fileInput;
        if(type == "Cam")
        fileInput = component.find("fileCam").getElement();    
                
        if(type =="File")
        fileInput = component.find("fileImg").getElement();
                var file = fileInput.files[0];
                               
        if (file.size > this.MAX_FILE_SIZE) { alert('save image helper error'); 
            alert('File size cannot exceed ' + this.MAX_FILE_SIZE + ' bytes.\n' +
                                  'Selected file size: ' + file.size);
                    return;
        }
         
        var fr = new FileReader();
        alert('save image helper not error'+fr);
                var self = this;
                fr.onload = function() { alert('save image helper');  
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
        alert('byes');
        action.setCallback(this, function(a) {
            attachId = a.getReturnValue();
            alert(attachId);
            
            console.log(attachId);
        });
        alert('byes');   
        $A.run(function() {
            $A.enqueueAction(action); 


        });
    },
    scrollToLocation : function(component, location) {
        var scroller = this.getScroller(component),
            payload = {
                time: 300,
            };
        
        if(typeof location === "string") {
            payload.destination = location;
        } else if(location instanceof HTMLElement) {
            payload.destination = "custom";
                payload.xcoord = location.offsetLeft;
                payload.ycoord = -location.offsetTop;
        }
        
                    scroller.getEvent("scrollTo").setParams(payload).fire();
                },
    
    //THIS IS AN ABSOLUTE HACK AND MOST LIKELY WILL BREAK IN SUMMER16!
    getScroller : function(component) {
        var elem = component.getElement(),
            scroller;
        
        while(elem && !elem.classList.contains("centerUiScroller")) {
            elem = elem.parentElement;
        }        
        
        scroller = $A.componentService.getRenderingComponentForElement(elem);        
        scroller = scroller && scroller.getComponentValueProvider();

        $A.assert(scroller && scroller.isInstanceOf("ui:scroller"), 
                  "SCROLLER NOT FOUND. If this is broken, it's because this was a temporary workaround for something that will be fixed in 202.");
        
        return scroller;
    },
       
        checkMobileBrowser : function(component){

            if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
				return true;	
            }else{
                return false;
            }
        },
 
        
})