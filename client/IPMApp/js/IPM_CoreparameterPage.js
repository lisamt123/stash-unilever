/*********************************************************************************
 *@Description:This script is used for project parameters page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*********************************************************************************/
var jq = jQuery.noConflict();
/* Below code is to open the Modal in edit core parameters */
jq(document).ready(function() {
	jq(".cust-overlay").hide();
    var ipmEditProjectMD = jq('#ipmEditProject .modal-dialog');
    var ipmEditCoreparametersMD = jq('#ipmEditCoreparameters .modal-dialog');
    var ipmEditAdditionalParametersMD = jq('#ipmEditAdditionalParameters .modal-dialog');
    jq('.ipmFinancialTable td').find('img[src$="spacer.gif"]').css('display', 'none');
    jq(document).on('click', '.editProject', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        jq("#ipmEditProject .modal-body").html('<iframe id="editPro" frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
        ipmEditProjectMD.addClass('editprorevamp');
        ipmEditProjectMD.width('95%');
        ipmEditProjectMD.height('95%');
    });
    jq(document).on('click', '.editcoreparam', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        jq("#ipmEditCoreparameters .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
        ipmEditCoreparametersMD.addClass('editcorerevamp');
        ipmEditCoreparametersMD.width('95%');
        ipmEditCoreparametersMD.height('95%');
    });
	if(window.location.href.indexOf("BETOptions") > -1){
            document.getElementById("editAddtnlParam").click();
    }
});
/* Below code is to switch the CP questions based on the project type */
jq(window).load(function() {
	//jq(".cust-overlay").show().delay(1000).fadeOut();
    if (IPMProAppCP.tpluser == 'true' && IPMProAppCP.addtnlParameter == 'false') {
        jq('#myCarousel').carousel(2);
        var $this = jq("#slideBar3 label:not('.fstchild'):");
        var labelWidth = $this.innerWidth() / 2;
        jq(".hlPointer").remove();
        jq(".helpContent").append("<div class='hlPointer'></div>");
        var posPointer = $this.position().left;
        jq(".helpContent").find(".hlPointer").css("left", posPointer + labelWidth - 14 + "px");
    }
    setTimeout(function() {
        setSlider(1);
    }, 500);
});
jq(window).load(function() {
    if (window.location.href.indexOf("qone") > -1) {
        jq('#myCarousel').carousel(0);
        setTimeout(function() {
            setSlider(1);
        }, 500);
    } else if (window.location.href.indexOf("qtwo") > -1) {
        jq('#myCarousel').carousel(1);
        setTimeout(function() {
            setSlider(2);
        }, 500);
    } else if (window.location.href.indexOf("qthree") > -1) {
        jq('#myCarousel').carousel(2);
        setTimeout(function() {
            setSlider(3);
        }, 500);
    }
});