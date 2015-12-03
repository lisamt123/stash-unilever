function resizePageContent(){
	Sfdc.canvas.publisher.resize( {width : "750px", height :
	'1000px'});
}

function scrollbackground() {
	window.onscroll = function() {
		var speed = 2.0;
		document.body.style.backgroundPosition = (-100+ (-window.pageYOffset / speed)) + "px 0px";
	}
}