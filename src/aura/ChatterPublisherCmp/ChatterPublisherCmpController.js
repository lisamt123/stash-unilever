({
	sharePost : function(component, event, helper) {
		helper.sharePost(component); 
        jQuery(".attachmentContainer").hide();
	},
    
    chooseFile : function(component, event, helper) {
		jQuery(".ModalDialogPlaceholderFileUpload").addClass("slds-hide");
        component.find("attachNewFileB").getElement().disabled = false;
        var variable = jQuery('.slds-pill__label').text();
        if(variable != ''){
            jQuery(".attachmentContainer").show();
            if(component.find("file").getElement().files[0]) {
                // input new file
                component.find("attachNewFileB").getElement().disabled = true;
                jQuery('#filename').empty();
                jQuery('#filename').append(''+variable); 
            } else {
                // choose existing file
                jQuery('#filename').empty();
                jQuery('#filename').append(''+variable); 
                var lookupPill = component.find("lookup-pill");
                $A.util.addClass(lookupPill, 'slds-hide');
                component.find("attachNewFileB").getElement().disabled = true;        
            } 
            
              jQuery('.closePreviewFile').click(function(){
              jQuery('#filename').empty();
              jQuery(".attachmentContainer").hide();
              component.find("attachNewFileB").getElement().disabled = false;
               var evt = $A.get("e.c:ClearLookup");
               evt.fire();
          });
        }
        jQuery(".lookup-input").focus();
	},
    
    mention : function(component, event, helper) {
        var txt = component.get("v.textToPost");
        if(txt == undefined) {
            txt = '';
        }
		component.set("v.textToPost", txt + ' @');
        jQuery(".lookup-input").focus();
	},
    
     uploadFile : function(component, event, helper) {
        helper.uploadFile(component); 
        //jQuery(".ModalDialogPlaceholderFileUpload").addClass("slds-hide");
    },
    
    
    afterLoaded:  function(component, event, helper) {
        
        //Added by AES
        jQuery(".attachmentContainer").hide();
        $j = jQuery.noConflict();            
       //END AES
  
        
       function getCaretPosition (elem) {
    
      // Initialize
      var iCaretPos = 0;
    
      // IE Support
      if (document.selection) {
    
        // Set focus on the element
        elem.focus ();
    
        // To get cursor position, get empty selection range
        var oSel = document.selection.createRange ();
    
        // Move selection start to 0 position
        oSel.moveStart ('character', -elem.value.length);
    
        // The caret position is selection length
        iCaretPos = oSel.text.length;
      }
      // Firefox support
      else if (elem.selectionStart || elem.selectionStart == '0')
        iCaretPos = elem.selectionStart;
    
      // Return results
      return (iCaretPos);
    }
    
    function setCaretPosition(elem, caretPos) {
        if(elem != null) {
            if(elem.createTextRange) {
                var range = elem.createTextRange();
                range.move('character', caretPos);
                range.select();
            }
            else {
                if(elem.selectionStart) {
                    elem.focus();
                    elem.setSelectionRange(caretPos, caretPos);
                }
                else
                    elem.focus();
            }
        }
    }
    
    function getTags(term, callback) {
       
		var spinner = component.find('publisherSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();     
        var action = component.get("c.getMentionCompletions");
        var subjectId  = component.get("v.subjectId");
        action.setParams({
            "q" :  term,
            "contextId": subjectId
             });	
        //Set up the callback
        
        action.setCallback(this, function(actionResult) {
          var mentionsString = actionResult.getReturnValue(); 
          var data = eval("(" + mentionsString + ")");
          callback(data);
          var spinner = component.find('publisherSpinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();
        });
    
        $A.run(function() {
              $A.enqueueAction(action); 
         });
      
    } 
            
           
        jQuery(document).ready(function() {
        jQuery(".lookup-input").autocomplete({
            source: function(request, response) {
                var term = request.term;
                var pos = getCaretPosition(this.element.get(0));
                var substr = term.substring(0, pos);
                var lastIndex = substr.lastIndexOf('@');
                if (lastIndex >= 0){
                    var username = substr.substr(lastIndex + 1);
                    if (username.length && (/^\w+$/g).test(username)){
                        getTags(username, function(data) {
                            response(jQuery.map(data.tags, function(el) {
                                return {
                                    value: el.name
                                }
                            }));
                        });
                        return;
                    }
                }
                
                response({}); 
            },
            focus: function() {
                // prevent value inserted on focus
                return false;
            },
            select: function(event, ui) {
                var pos = getCaretPosition(this);
                var substr = this.value.substring(0, pos);
                var lastIndex = substr.lastIndexOf('@');
                if (lastIndex >= 0){
                    var prependStr = this.value.substring(0, lastIndex);
                    this.value = prependStr + '@[' + ui.item.value + this.value.substr(pos) + '] ';
                    component.set("v.textToPost",this.value);
                    setCaretPosition(this, prependStr.length + ui.item.value.length + 4);
                } 
                return false;
            }
        }).data("ui-autocomplete")._renderItem = function(ul, item) {
            return jQuery("<li>")
                .data("ui-autocomplete-item", item)
                .append("<a>" + item.label + "</a>")
                .appendTo(ul);
        };
        });  
            
            jQuery(".ui-autocomplete").css("z-index",1);
        	jQuery(".ui-autocomplete").css("background-color","white");
        
            
        
        
        
        
    },
    
    showPopUp : function(component, event, helper) {
        helper.showPopUp(component);
    },
    
     doInit : function(component, event, helper) {
        helper.doInit(component);
        
        //jQuery('.ui-autocomplete').css("background-color","#FFFFFF");
    },
    
    handlePublisherStyling : function(cmp, event) {
		if (jQuery('slds-publisher--discussion').hasClass("slds-is-active")) {
		  jQuery(".slds-publisher--discussion").removeClass("slds-is-active");
		}else{
		  jQuery(".slds-publisher--discussion").addClass("slds-is-active");
		}  
        
        //slds-attachments
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
    },
    
    
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