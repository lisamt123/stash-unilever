  <!-- Created by Asmae ESSBAI For the SOW view page -->
  
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
   
  function PopupAddAttachmnt(){
       
         $(function() {
                $( "#PopupAddAttachmnt" ).dialog({
                  width: 600,
                  modal: true, 
                  zIndex: 9,
                  buttons: {
                     Save : function() {                            
                            SaveAttachments();         
                            $( this ).dialog( "close");   
                        },                                       
                    Close : function() {
                      $( this ).dialog( "close" );
                    }                 
                  }
                });
              });           
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
        Oblix_Ctrl06SOWView_CC.removeAttachments(attachmentsIds, function (data, status){
            deferred.resolve({data: data, status: status});
        });
        return deferred.promise();
    }
    var acceptRemoveAttachment = function (){
        $('#dialog').dialog('close');
        removeAttachmentsBack();
    }
	
	  $(document).ready(function() {
            $(".cmplex").find("select").hide();           
            $(".complex").find("select").hide();
		    $('#example').dataTable({});
		    $('.Oblix_large_btn,.Oblix_btn').tooltip({delay: { "show": 500},
                    position:  {
                        using: function( position, feedback ) {
                        $( this ).css( position );
                        $( "<div>" )
                            .addClass( "arrow" )
                            .addClass( feedback.vertical )
                            .addClass( feedback.horizontal )
                            .appendTo( this );
                        }
                      }});
                  
    });
	
	
  