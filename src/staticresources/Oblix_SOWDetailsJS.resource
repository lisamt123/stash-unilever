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
function Popup(){
	// lstAttachementsView();
	 $("#dialog").dialog({
		 
		 width: 600,
		 modal:true,
		 close: function(event,ui){
			 $("pop").dialog('destroy');          
				}
		 });           
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
$(document).ready(function(){     
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
 