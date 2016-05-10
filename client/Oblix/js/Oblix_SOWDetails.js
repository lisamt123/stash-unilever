<!-- Created by Asmae ESSBAI For the ViewProject page -->
 
  function blockme() { 
           $.blockUI({ css: {  
                border: 'none', 
                padding: '15px', 
                backgroundColor: '#000', 
                '-webkit-border-radius': '10px', 
                '-moz-border-radius': '10px', 
                opacity: .5, 
                color: '#fff' 
            } }); 
        } 
		
function openAtt(){
		$('#xdialogAddAtt').slideDown( "slow", function() {
							// Animation complete.
						   });
	
	}
	 function closeAtt(){
		$('#xdialogAddAtt').slideUp( "slow", function() {
							// Animation complete.
						   });
	
	}		

 function Popup(){
	// lstAttachementsView();
	 $("#dialog").dialog({width: 1000,modal:true,
		 close: function(event,ui){
			 $("pop").dialog('destroy');          
				}
		 });           
	}
		 
		 
<!-- Attachment part -->

 var redirectToAttachment = function (attachmentId){
        'use strict';
        window.open('/servlet/servlet.FileDownload?file=' + attachmentId);
    }

    var removeAttachments = function (attachmentsId){
        'use strict';
        var attachmentsId = [];
        $('#dialog').find('table > tbody').children().children().find('input:checkbox:checked').each(function (){
            attachmentsId.push($(this).attr('data-attachment-id'));
        })
        if(attachmentsId.length !== 0){
            $('#dialog').dialog('close');
            removeService(attachmentsId).then(function (){
                acceptRemoveAttachment();
            }, function (err){
                console.log(err);
            });
        }
    }
    var removeService = function (attachmentsIds){
        'use strict';
        var deferred = $.Deferred();
        Visualforce.remoting.Manager.invokeAction('Oblix_Ctrl05SOWDetails_CC.removeAttachments', attachmentsIds, function (data, status){
            deferred.resolve({data: data, status: status});
        });
        return deferred.promise();
    }
    var acceptRemoveAttachment = function (){
        $('#dialog').dialog('close');
        removeAttachmentsBack();
    }
	    