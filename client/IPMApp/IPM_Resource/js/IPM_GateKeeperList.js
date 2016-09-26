/*********************************************************************************
*@Description:This component is used for displaying Gatekeeper Checklist Questions 
  in Project Document Section Editor page and user can change the answer 
  through the slider bar.
*@Author: Cognizant
*@Created Date: 06/01/2015  
*********************************************************************************/
var jq = jQuery.noConflict();
jq.browser = {};
/* Below script calls a function 'initSliderGk' on page load. */
jq(document).ready(function() {
    initSliderGk();
});

/* Below function calls another function 'callupdateGKList' which updates the gate keeper list */
function updateGKList(id, ans, comment, cmnts) {
    callupdateGKList(id, ans, comment, cmnts);
}
/* Below function contains the script for the slider functionality in gate keeper list. It contains the complete functionality code when user clicks on the options the pointer ball moves to the clicked option. Also it highlights the selected option with a different color on page load. Also it saves the selected option when clicked on it. */
function initSliderGk() {
    var itemsGK = [IPMAppGKC.select, IPMAppGKC.yes, IPMAppGKC.partly, IPMAppGKC.no, IPMAppGKC.na];
    var s = jq(".sliderGk");
    var score;
    var PointerT = 100 / (itemsGK.length - 1);
    jq(s).each(function() {
        var answerGK = jq(this).find("input[name=answer]").val();
        jq(this).slider({
            min: 1,
            max: itemsGK.length,
            animate: 'slow',
            value: itemsGK.indexOf(answerGK) + 1,
            stop: function(event, ui) {
                var pointer = ui.value - 1;
                jq('#s' + itemsGK.indexOf(answerGK) + 1).prop('checked', true);
                score = itemsGK[pointer];
            },
            slide: function( event, ui ) {
                jq(this).find(".legendSld.gateKeeperSlider label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
                jq(this).find(".legendSld.gateKeeperSlider label").eq(ui.value -1).click();
            }
        });
        if (answerGK === IPMAppGKC.yes) {
            jq(this).find("label[for=s1]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        }
        else if (answerGK === IPMAppGKC.partly) {
            jq(this).find("label[for=s2]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        }
        else if (answerGK === IPMAppGKC.no) {
            jq(this).find("label[for=s3]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        }
        else if (answerGK === IPMAppGKC.na) {
            jq(this).find("label[for=s4]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });
        }
        else {
            jq(this).find("label[for=s0]").css({
                'color': '#e98824',
                'font-weight': 'bold'
            });     
        }

    });
    
/* Below works on click event. It highlights the selected option with a different color and different font style. Also it moves the help text pointer to selected option. */
    jq(".legendSld label").on("click", function() {
        var lpos = jq(".legendSld label").offset().left;
        jq(".legendSld label").css({
            'color': '#222222',
            'font-weight': 'normal'
        });
        jq(this).css({
            'color': '#e98824',
            'font-weight': 'bold'
        });
        jq("toolTipMsg:before").css("left", lpos + "px");
    });
    jq("input[type=radio][id^='s']").hide();
}