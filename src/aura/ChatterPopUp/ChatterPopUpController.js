({
      doInit : function(component, event, helper) {
       
    },
    afterLoaded:  function(component, event, helper) {
        //Added by AES
        jQuery(".file").change(function(){
          jQuery(".ModalDialogPlaceholderFileUpload").addClass("slds-hide");
       });
        var dropZoneId = "drop-zone";
        var buttonId = "clickHere";
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

    if (buttonId != "") {
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
    }

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
        if(fileNum > 1){
            fileNames = 'Files selected...';}
        else{
            fileNames = this.files[0].name + '&nbsp;';}
        
        jQuery('#filename').append('<span class="fa-stack fa-lg"><i class="fa fa-file fa-stack-1x"></i><strong class="fa-stack-1x" style="color:#FFF; font-size:12px; margin-top:2px;">'+ fileNum + '</strong></span><span">' + fileNames + '</span>&nbsp;<span class="fa fa-times-circle fa-lg closeBtn" title="remove"></span><br>');
        
        // add remove event
      jQuery('#filename').find('.closeBtn').click(function(){
          jQuery('#filename').empty();
          inputFile.val('');
      });
      ///End change 
    });
	
   //END AES
    },
	defaultCloseAction1 : function(component, event, helper) {
        //component.destroy();
        jQuery(".ModalDialogPlaceholderFileUpload").addClass("slds-hide");
    },
        
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    handleAccountIdUpdate : function(cmp, event, helper) {
        // Get the Id from the Event
        var accountId = event.getParam("sObjectId");
 
        // Set the Id bound to the View
        cmp.set('v.recordId', accountId);
    },
 
    /**
     * Handler for receiving the clearLookupIdEvent event
     */
    handleAccountIdClear : function(cmp, event, helper) {
        // Clear the Id bound to the View
        cmp.set('v.recordId', null);
    }
    
   
})