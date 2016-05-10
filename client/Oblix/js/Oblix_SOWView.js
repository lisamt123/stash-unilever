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
	
	function confirmDelete(){
        $(function() {
            $( "#dialog-confirm" ).dialog({
                resizable: false,
                modal: true,
                buttons: {
                    "Delete all items": function() {
                        blockme();
                        deleteSOW();
                        $( this ).dialog( "close" );
                    },
                    Cancel: function() {
                        $( this ).dialog( "close" );
                    }
                }
            });
        });
    }
	function getCategoryBrand(val){
            console.log('onchange triggered');
    }
	function preparePH(){
            $(".cmplex").find("input").attr("placeholder", "Agency Contact");
            $(".complex").find("input").attr("placeholder", "Unilever Contact");
			$(".complex").find("input").attr("styleClass", "cmplex input_init");
            $(".complex").find("select").hide();
            $(".cmplex").find("select").hide();
    }
     var turnOnValidation = function (isTurned){
        'use strict';
        var el = $('.column3').find('textarea');
        if(isTurned){
            el.on('change', function (event) {
                var saveButton = null;
                var errorMsg = $('.column3').find('.warning');
                $('.column5').find('input').each(function() {
                    if($(this).val() === 'Save'){
                        saveButton = $(this);
                    }
                });
                if($(this).val().length > 255){
                    saveButton.attr('disabled', 'disabled');
                    errorMsg.addClass('show').text('Note is too long.');
                } else {
                    saveButton.removeAttr('disabled');
                    errorMsg.removeClass('show').text('');
                }
            });    
        } else {
            el.off('change');
        }
        
     }
	  function Popup(){
             $("#dialog").dialog({
             width: 1000,
             modal:true,
             close: function(event,ui){
                 $("pop").dialog('destroy');          
                    }
             }); 
            
     }
	 $(function() {
        $( "#tabs-centre" ).tabs();
     });
   	blockme();
    Highcharts.setOptions({
        colors:['green']
     });
	  function openAtt(){
            $('#xdialogAddAtt').slideDown( "slow", function() {
                                // Animation complete.
                               });
        
        }
         function closeAtt(){
            $('#xdialogAddAtt').slideUp( "slow", function() {
                                return false;
                               });
        
        }
      
		function getCategoryBrand(val){
          	console.log('onchange triggered');
		}
	 