
    function makeFormReadOnly(){
        var customStatus= "{!VPM_PurchasingRequests__c.VPM_Status__c}"; 
         if ((customStatus.indexOf('Rejected') >= 0 ) || (customStatus.indexOf('Aborted') >= 0 ) || (customStatus.indexOf('Request Completed') >= 0 )) 
        { 
            $("input:not(:radio):not(:submit):not(:button),select,textarea").prop("disabled" ,"disabled");
            $('input[value="Save and Return to Menu"],input[value="Save & Exit"]').css('display','none');
        }  
    }
    function removeStyleSheets(){
            $('link[href*="vpmadvancedformcss"]').remove();
            $('link[href*="vpmstyles"]').remove();
    }
    function domManipulations(){
        var alignErrorMsg = $('span[id*="VPM_UnBlockUndeleteMessage"]');
        if($(alignErrorMsg) && $(alignErrorMsg)!=[]){
                $(alignErrorMsg).closest('tr').css("display","table-row").append('<br>');
                $(alignErrorMsg).closest('td').append('<br>');
        }
    }
    function openAttachment(page){
    var self = this;
        self.window.open('/apex/VPM_AttachmentSectionPopUp','Table','toolbar=yes, scrollbars=no, toolbar=no, menubar=no, height=500,width=1230, top=70, left=70');
        return false;
    }
    function showAttachments(id){
        var self = this;
        self.window.open('/apex/VPM_AttachFiles?id='+id,'Table','toolbar=yes, scrollbars=no, toolbar=no, menubar=no, height=500,width=1230, top=70, left=70'); 
    } 