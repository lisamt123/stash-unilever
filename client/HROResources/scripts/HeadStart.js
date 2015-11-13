/*
function resizePageContent(){
	Sfdc.canvas.publisher.resize( {width : "750px", height :
	$('#pageContent').height()+'px'});
}
*/

function scrollbackground() {
	window.onscroll = function() {
		var speed = 2.0;
		document.body.style.backgroundPosition = (-100+ (-window.pageYOffset / speed)) + "px 0px";
	}
}
/**
 * { function_description }
 *
 * @method     markCompleted
 * @param      {string}  thisId  { description }
 * @param      {<type>}  obj     { description }
 */

function markCompleted(thisId,obj){
	thisId = thisId.replace('UncompletedTask','');
	
	HRO_HeadStart_CX.markComplete(thisId, function(result, event){
			if(event.status) {
				$('#'+'UncompletedTask'+thisId).removeClass('ion-android-checkbox-outline-blank');
				$('#'+'UncompletedTask'+thisId).addClass('ion-android-checkbox-outline');
				$('#'+'UncompletedTask'+thisId).parent().parent().addClass('animated rotateIn');
				//$('#'+'UncompletedTask'+thisId).css( "color", "#81C241" );
			}else {}
	});
   
}

function unselectAllPhases(){
	$( "#phasesPlaceholder g .mainLogo").css('stroke', '#000000').css('stroke-width', '0px');
}

function markButtonPhaseSelected(){
	unselectAllPhases();
	try{
		var btnId=$('[id$=selectedPhaseButton]').val();
		$('[id$='+btnId+']').css('stroke-width', '7px');
	}catch(ex){}
}

function bindClickOnPhasesBtns(){
	var isTouchSupported = 'ontouchstart' in window;
	var eventName        = isTouchSupported ? 'touchstart' : 'click';

	$( "#phasesPlaceholder g .mainLogo").each(function(){

  		this.addEventListener('touchstart', function(event) {
			if(event.preventDefault) 
				event.preventDefault();
			unselectAllPhases();
			$(this).css('stroke-width', '7px');
			switchToPhase($(this).attr('id'));
		});

		$(this).on('click', function (){
		    unselectAllPhases();
		    $(this).css('stroke-width', '7px');
		    switchToPhase($(this).attr('id'));
		});
	});

	$('g[parent]').each(function(){

	 	$(this).children().each(function(){
		    this.addEventListener(eventName, function(event) {
		       if(event.preventDefault) event.preventDefault();
		       $('#' + $(this).parent().attr('parent')).click();
		    });
	 	});
 	});
}

function bindControls(){
	/*
	$( ".inoIcon" ).on('click', function () {
		var thisId = $( this ).attr('id');
		HRO_HeadStart_CX.markComplete(thisId, function(result, event){
			if(event.status) {
				$('#'+thisId).parent().parent().addClass('animated rotateIn');
				$('#'+thisId).css( "color", "#81C241" );
			}else {}
		});
	});
    */
	$( "#networkLink" ).on('click', function () {
		if( (typeof sforce != 'undefined') && (sforce != null) ) {
		  // Salesforce1 navigation
		  sforce.one.navigateToURL(myUrl);
		} else {
		  // Set the window's URL
			window.open(HRONetworkLink,'_blank');
		}
		
	});

	$( "#cultureLink" ).on('click', function () {
		if( (typeof sforce != 'undefined') && (sforce != null) ) {
		  // Salesforce1 navigation
		  sforce.one.navigateToURL(myUrl);
		} else {
		  // Set the window's URL
			window.open(HROCultureLink,'_blank');
		}
		
	});

	$( "#ownershipLink" ).on('click', function () {
		if( (typeof sforce != 'undefined') && (sforce != null) ) {
		  // Salesforce1 navigation
		  sforce.one.navigateToURL(myUrl);
		} else {
			 // Set the window's URL
			window.open(HROOwnershipLink,'_blank');
		}
		
	});

	$( "#capabilityLink" ).on('click', function () {
		if( (typeof sforce != 'undefined') && (sforce != null) ) {
		  // Salesforce1 navigation
		  sforce.one.navigateToURL(myUrl);
		} else {
			  // Set the window's URL
			 window.open(HROCapabilityLink,'_blank');   
		}
		
	});

}

/**
 * { function_description }
 *
 * @method     redirectToRecord
 * @param      {string}  recordId  { Onboarding Task Id }
 * @param      {string}  pageURL   { Task Attachment page }
 */

function redirectToRecord(recordId,pageURL){
	//alert(pageURL);
	if(pageURL != null && pageURL != 'undefined' && pageURL != ''){
		if( (typeof sforce != 'undefined') && (sforce != null) ) {
			// Salesforce1 navigation
			sforce.one.navigateToURL(pageURL);
		} else {
			// Set the window's URL
			//var encodedUrl = encodeURI(pageURL);
			window.open(
			  pageURL,
			  '_blank'
			);
		}
	}
	
}