/*  
***********************************************************************************
*@Description:This script is used for Section Gate check list in IPM Gate Document page
*@Author: Cognizant
*@Created Date: 07/01/2015 
***********************************************************************************
*/ 

var jq = jQuery.noConflict();
var ansIndex = 0;
 /* Below script calls a function 'initSliderSecGk' on page load. */
jq(document).ready(function() {
    var sliderObjs = jq(".sliderGk");
    
    var sliderIndex = 0;
    jq(sliderObjs).each(function() {
        divId = "legendSldGK" + sliderIndex;
        sliderValArray = getAllOptions(divId);
        sliderValArray.shift();
        initSliderSecGk(this, sliderValArray);
        /* Slider Label Init */
        initSliderSecLabelGk(this, divId, sliderValArray);
        sliderIndex++;
    });
    
    setSliderValBgcolor();
});

/* Below function calls another function 'callupdateSecGateKeeperList' which updates the Section Gate keeper list */
function updateSecGateKeeperList(id, ans, comment, cmnts) {
    callupdateSecGateKeeperList(id, ans, comment, cmnts);
}

/* Below function calls another function 'callupdateGKList' which updates the Gate keeper list */
function updateGKList(id, ans, comment, cmnts) {
    callupdateGKList(id, ans, comment, cmnts);
}

/* Below function contains the script for the slider functionality in Section Gate keeper list. It contains the complete functionality code when user clicks on the options the pointer ball moves to the clicked option. Also it highlights the selected option with a different color on page load. Also it saves the selected option when clicked on it. */
function initSliderSecGk(sliderObj, valArray) {
    valArray.unshift("Select");
    var itemsSecGK =  valArray;
    var score;
    var PointerT = 100 / (itemsSecGK.length - 1 );

    var answerSecGK = jq(sliderObj).find("input[name=secGkans]").val(); 
    ansIndex = valArray.indexOf(answerSecGK);
    
    
    jq(sliderObj).slider({
        min: 1,
        max: itemsSecGK.length,
        animate: 'slow',
        value:itemsSecGK.indexOf(answerSecGK)+1,
        stop: function(event, ui) {
            var pointer = ui.value - 1;
            jq('#s' + itemsSecGK.indexOf(answerSecGK)+1).prop('checked', true);
            score = itemsSecGK[pointer];
        },
        slide: function( event, ui ) {
            jq(this).find(".legendSld.gateKeeperSlider label").css({color: "#555", fontWeight: "normal"}).eq(ui.value -1).css({color: "#E98824", fontWeight: "bold"});
            jq(this).find(".legendSld.gateKeeperSlider label").eq(ui.value -1).click();         
        }
    });
    
   
/* Below works on click event. It highlights the selected option with a different color and different font style.*/
jq(".legendSld label").on("click", function() {
    var lpos = jq(".legendSld label").offset().left;
    jq(this).parent().find('label').css({
        'color': '#555555',
        'font-weight': 'normal'
    });
    jq(this).css({
        'color': '#e98824',
        'font-weight': 'bold'
    });
});
jq("input[type=radio][id^='s']").hide();
}

/* Below function returns values of an array. The values will total number of options present for each GK slider question. */
function getAllOptions(divElement){
    divElement1 = '#' + divElement;
    var OptionsDiv = jq(divElement1);
    var optionsArray = [];
        
    OptionsDiv.find('.info tbody tr td').each(function (i, el) {
        optionsArray.push(jq(this).find('input').val());
    });     
    return optionsArray;
}

function initSliderSecLabelGk(sliderObj, divId, valArray) {
    var labelItem = valArray;
    LeftMovePercentage = 100 / (labelItem.length - 1);
    LeftMovePercentage = LeftMovePercentage;
    divId = "#" + divId;
    
    sliderTableObj = jq(divId).find("table");
    
    /* TO DO - Replace with add class */
    sliderTableObj.css("width", "100%");
    
    /* Applying css to label's except the first one.. */
    index = 0;
    sliderTableObj.find("label").each(function(ind){
        jq(this).css("margin-left", LeftMovePercentage * ind + "%");
        if(ansIndex < 0)
        {
            ansIndex = ansIndex + 1;
        }
        if(index === ansIndex){
            jq(this).css({color: "#E98824", fontWeight: "bold"});
        }
        index ++;
    });
}

function setSliderValBgcolor(){
 var selectedSliderVal = jq(".gkcStatus");
 var sliderValArray = ['Partly', 'No', 'Yes', 'Not Applicable'];
 
for(var i = 0; i < selectedSliderVal.length; i++){
  if(sliderValArray !== undefined){
       var found = jq.inArray(jq(selectedSliderVal[i]).text(), sliderValArray);
    if(found === -1 && jq(selectedSliderVal[i]).text() !== ""){
    jq('.gkcStatus.'+jq(selectedSliderVal[i]).text()).css({background: "#000000"});
    }
  }  
    }

}
