/*******************************************************************************
 *@Description:This script is used for core parameters page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*******************************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {
    var skipSlide23 = false;
    var skipSlide3 = false;
    var ptype = IPMProAppCP.prosubtype;
    var hlPointer = jq(".hlPointer");
    /* Below code is to display the help text pointer */
    jq('#slideBar1 label:not(".fstchild")').click(function() {
        var $this = jq(this);
        var labelWidth = $this.innerWidth() / 2;
        jq(".hlPointer").remove();
        jq(".helpContent").append("<div class='hlPointer'></div>");
        var posPointer = $this.position().left;
        jq(".helpContent").find(".hlPointer").css("left", posPointer + labelWidth - 14 + "px");
        jq('.qnumone .fstchild').addClass('greyOut');
    });
    jq(document).on("click", "#slideBar2 label:not('.fstchild')", function() {
        var $this = jq(this);
        var labelWidth = $this.innerWidth() / 2;
        jq(".hlPointer").remove();
        jq(".helpContent").append("<div class='hlPointer'></div>");
        var posPointer = $this.position().left;
        jq(".helpContent").find(".hlPointer").css("left", posPointer + labelWidth - 14 + "px");
        jq('.qnumtwo .fstchild').addClass('greyOut');
    });
    jq(document).on("click", "#slideBar3 label:not('.fstchild')", function() {
        var $this = jq(this);
        var labelWidth = $this.innerWidth() / 2;
        jq(".hlPointer").remove();
        jq(".helpContent").append("<div class='hlPointer'></div>");
        var posPointer = $this.position().left;
        jq(".helpContent").find(".hlPointer").css("left", posPointer + labelWidth - 14 + "px");
        jq('.qnumthree .fstchild').addClass('greyOut');
    });
    var slide = getParameterByName('slide');
    var selectedRadioBtn = getselectedRadioBtnBtn(1);
    if (slide === 'ProjectSpan') {
        jq('#myCarousel').carousel(4);
        setCarousel();
    } else {
        checkRadioBtn(1);
        setSlider(1);
        displayHelpText(1);
    }
    /* Below code is to select the option based on the selected label */
    jq(document).on('click', '#slideBar1 label:not(".fstchild")', function() {
        var $this = jq(this);
        var answerOne = $this.next('input[type=radio]').val();
        selectOption(this, 1);
    });
    jq(document).on('click', '#slideBar2 label:not(".fstchild")', function() {
        selectOption(this, 2);
    });
    jq(document).on('click', '#slideBar3 label:not(".fstchild")', function() {
        selectOption(this, 3);
    });
    jq(document).on('slid.bs.carousel', '#myCarousel', function() {
        setCarousel();
    });
    /* Below code is to navigate to the next CP question */
    jq(document).on('click', '#nextControl', function() {
        var currentIndex = jq('.item.active').index();
        var nextIndex = jq('#slideStrategicIntent').index();

        var ptype = IPMProAppCP.prosubtype;
        if (currentIndex == 1 && ptype == IPMProAppCP.oprtnLabel) {
            jq('#myCarousel').carousel(2);
        }
        if (currentIndex == 1 && ptype == IPMProAppCP.blgLabel) {
            jq('#myCarousel').carousel(1);
        }
        if (currentIndex == 2 && ptype == IPMProAppCP.blgLabel) {
            jq('#myCarousel').carousel(3);
        }
        if (currentIndex == 1) {
            jq(".hlPointer").remove();
            jq("#helpTextDiv2 .helpContent").append("<div class='hlPointer'></div>");
            setTimeout(function() {
                setSlider(2);
            }, 500);
        }
        var radioChecked2 = jq("#slideBar2 .sliderTrack input[type=radio]:checked").length;
        var radioChecked3 = jq("#slideBar3 .sliderTrack span input[type=radio]:checked").length;
        if (radioChecked2 == 0) {
            jq("#helpTextDiv2 .hlPointer").remove();
        }
        if (radioChecked3 == 0) {
            jq("#helpTextDiv3 .hlPointer").remove();
        }
    });
    /* Below code is to set the slider while navigating from About project tab to Core parameter */
    jq(".coreparameters").click(function() {
        setTimeout(function() {
            setSlider(1);
        }, 500);
    });
    jq(document).on('click', '#prevControl', function() {
        setPointer();
    });
    jq(document).on('resize', '.modal-content', function() {
        setSlider();
    });
    setPointer();
    /* Below code is to set the carousel */
    function setCarousel() {
        jq('#myCarousel').children('.carousel-control').show();
        if (jq('.carousel-inner .item:first').hasClass('active')) {
            jq('#myCarousel').children('.left.carousel-control').hide();
        } else if (jq('.carousel-inner .item:last').hasClass('active')) {
            jq('#myCarousel').children('.right.carousel-control').hide();
        }
        jq('.mainMenu').removeClass('active')
        jq('.subMenuLabel').removeClass('selected');
        var currentIndex = jq('.item.active').index() + 1;
        if (currentIndex == 4 || currentIndex == 5) {
            jq('#subMenu1').hide();
        } else {
            jq('#item1').addClass('active');
            jq('#subMenu1').show();
        }
        if (currentIndex == 1) {
            jq('#subMenuLabel1').addClass('selected');
            displayHelpText(currentIndex);
        }
        if (currentIndex == 2) {
            jq('#subMenuLabel2').addClass('selected');
            displayHelpText(currentIndex);
        }
        if (currentIndex == 3) {
            jq('#subMenuLabel3').addClass('selected');
            displayHelpText(currentIndex);
        }
        if (currentIndex == 4) {
            jq('#item4').addClass('active');
            jq('.description').hide();
        }
        if (currentIndex == 5) {
            jq('#item5').addClass('active');
            jq('.description').hide();
        }
        checkRadioBtn(currentIndex);
        setSlider(currentIndex);
    }
    /* Below code is to set the pointer */
    function setPointer() {
        var currentIndex = jq('.item.active').index() + 1;
        var ptype = IPMProAppCP.prosubtype;
        if (currentIndex == 4 && ptype == IPMProAppCP.blgLabel) {
            jq('#myCarousel').carousel(1);
        } else if (currentIndex == 4 && ptype == IPMProAppCP.oprtnLabel) {
            jq('#myCarousel').carousel(2);
        } else if (currentIndex == 2 && ptype == IPMProAppCP.oprtnLabel) {
            jq('#myCarousel').carousel(0);
        } else if (currentIndex == 5) {
            jq('#myCarousel').carousel('prev');
        } else if (currentIndex == 2) {
            jq('#myCarousel').carousel(1);
        } else {
            jq('#myCarousel').carousel('prev');
        }
    }
    /* Below code is for the Option selected based on the clicked function */
    function selectOption(labelClicked, slideNum) {
        jq('input[name=Question' + slideNum + '][title=checked]', '.item.active').attr('title', 'unchecked');
        var name = jq(labelClicked).next('input[type=radio]').attr('name');
        var val = jq(labelClicked).next('input[type=radio]').val();
        jq(labelClicked).next('input[type=radio]').attr('title', 'checked');
        jq('#slideBar' + slideNum + ' label').removeClass('active');
        var labelWidth = jq(labelClicked).innerWidth() / 2;
        jq(labelClicked).addClass('active');
        if (slideNum == 1) {
            Ans_parameter1(val, name);
            var pos = jq(labelClicked).position().left;
        } else if (slideNum == 2) {
            Ans_parameter2(val, name);
            var pos = jq(labelClicked).position().left;
        } else if (slideNum == 3) {
            Ans_parameter3(val, name);
            var pos = jq(labelClicked).position().left;
        }
        jq("#slideIcon" + slideNum).animate({
            left: pos + labelWidth - 14 + "px"
        }, 700);
    }
    /* Below code is to check the selected radio button */
    function checkRadioBtn(currentIndex) {
        var selectedRadioBtn = getselectedRadioBtnBtn(currentIndex);
        selectedRadioBtn.prop('checked', 'checked');
    }
    /* Below code is to get the parameter name */
    function getParameterByName(name) {
        name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
        var regex = new RegExp("[\\?&]" + name + "=([^&#]*)");
        var results = regex.exec(location.search);
        return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
    }
    /* Below code is to display help text based on the selected value */
    function displayHelpText(currentIndex) {
        jq('.helpTextDiv').hide();
        jq('#helpTextDiv' + currentIndex).show();
        jq('.description').show();
    }
    if (window.location.href.indexOf("BEToptions") > -1) {
        document.getElementById("ipmEditAdditionalParameters").click();
    }
});
/* Below code is to switch to 2.2 when the project type is BLG */
jq(window).load(function() {
    var currentIndex = jq('.item.active').index();
    var ptype = IPMProAppCP.prosubtype;
    if (currentIndex == 0 && ptype == IPMProAppCP.blgLabel) {
        jq("#nextControl").trigger('click');
    }
});
/* Below code is to set the slider */
function setSlider(currentIndex) {
    var selectedRadioBtn = getselectedRadioBtnBtn(currentIndex);
    var selectedVal = selectedRadioBtn.val();
    if (selectedVal != '' && selectedVal != undefined) {
        var element = selectedRadioBtn.prev();
        var pos = element.position().left;
        var ewidth = selectedRadioBtn.prev().innerWidth() / 2;
        if (currentIndex == 1) {
            if (pos > '1') {
                jq('.qnumone .fstchild').addClass('greyOut');
            }
            jq('#slideBar1 label').removeClass('active');
        }
        if (currentIndex == 2) {
            if (pos > '1') {
                jq('.qnumtwo .fstchild').addClass('greyOut');
            }
            jq('#slideBar2 label').removeClass('active');
        }
        if (currentIndex == 3) {
            if (pos > '1') {
                jq('.qnumthree .fstchild').addClass('greyOut');
            }
            jq('#slideBar3 label').removeClass('active');
        }
        jq(".helpContent").append("<div class='hlPointer'></div>");
        jq("#slideIcon" + currentIndex).animate({
            left: pos + ewidth - 14 + "px"
        }, 2);
        jq(".helpContent .hlPointer").css({
            left: pos + ewidth - 14 + "px"
        });
        selectedRadioBtn.prev().addClass('active');
    }
}
/* Below code is to get the selected radio button */
function getselectedRadioBtnBtn(currentIndex) {
    if (currentIndex == 1) {
        selectedRadioBtn = jq('input[name=Question1][title=checked]', '.item');
    } else if (currentIndex == 2) {
        selectedRadioBtn = jq('input[name=Question2][title=checked]', '.item');
    } else if (currentIndex == 3) {
        selectedRadioBtn = jq('input[name=Question3][title=checked]', '.item');
    }
    return selectedRadioBtn;
}
/* Below code is for the skip for now button functionality */
function skipTab(selem) {
    jq('#ipmGetStartedTab .ipmStartedTabs li').removeClass('active');
    var getClass = jq(selem).attr('class').split(' ');
    var getId = getClass[0];
    jq('#ipmGetStartedTab').parent().find('.ipmGetStartedContent').hide();
    jq("#ipmGetStartedTab .ipmStartedTabs li." + getId).addClass('active');
    jq('#' + getId).fadeIn("fast");
}
/* Below code is to go to the team members tab from core parameters */
function selectTeam() {
    window.top.location.href = '' + IPMProAppCP.setupurl + '?Pid=' + IPMProAppCP.projectName + '&TeamMemid=teammembers';
}
jq(window).on('resize', function() {
    setSlider(1);
});