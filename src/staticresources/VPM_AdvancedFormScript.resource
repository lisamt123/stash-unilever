$(document).ready(function() {
	 makeFormReadOnly();
        Visualforce.remoting.Manager.invokeAction('VPM_PurchaseRequestsControllerExtension.checkForBusinessReqUser',
            function(results, event){
                if(results.userRole=="FLS" && criteria1=="FLS Review") {
                    $("#detailPage").show();
                    alert(approvRejectLabel);
                 }
                else if(flsInCountry=="true" && results.brUser=="true" && criteria1=="Draft Request"){
                   if(document.URL.indexOf("back=true")==-1){
                     flag = confirm(bypassFrontlineTeamLabel);
                     if(flag){
                         $("#advForm").show();
                         }
                    else{
                        $("#detailPage2").show();
                        }
                    }
                    else{
                     $("#advForm").show();
                    }
                }
                else if (!Islock){
                    alert(recordInApprovalLabel);
                }
                    else{ 
                    $("#advForm").show();                
                }
            });  
     });

     function func(){
      alert(relevantBlocksLabel); 
    }
    
    function openAdvanceform(){ 
        window.top.location='https://'+localhost+'/apex/VPM_AdvancedForm_V1?id='+criteriaId;
    }
	
	 function openAttachment(page){
        self.window.open('/apex/VPM_AttachmentSectionPopUp','Table','toolbar=yes, scrollbars=no, toolbar=no, menubar=no, height=500,width=1230, top=70, left=70');
        return false;
    }
    function showAttachments(id){
        self.window.open('/apex/VPM_AttachFiles?id='+id,'Table','toolbar=yes, scrollbars=no, toolbar=no, menubar=no, height=500,width=1230, top=70, left=70'); 
    }
	 function makeFormReadOnly(){
         if ((criteria1.indexOf('Rejected') >= 0 ) || (criteria1.indexOf('Aborted') >= 0 ) || (criteria1.indexOf('Request Completed') >= 0 ) || (criteria1.indexOf('BPM Record Submitted') >= 0 )) 
        { 
            $("input:not(:radio):not(:submit):not(:button),select,textarea").prop("disabled" ,"disabled");
            $('input[value="Save and Return to Menu"],input[value="Save & Exit"]').css('display','none');
        }  
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
        self.window.open('/apex/VPM_AttachmentSectionPopUp','Table','toolbar=yes, scrollbars=1,resizable=1, toolbar=no, menubar=no, height=500,width=1230, top=70, left=70');
        return false;
    }
    function showAttachments(id){
        var self = this;
        self.window.open('/apex/VPM_AttachFiles?id='+id,'Table','toolbar=yes, scrollbars=1,resizable=1, toolbar=no, menubar=no, height=500,width=1230, top=70, left=70'); 
    } 