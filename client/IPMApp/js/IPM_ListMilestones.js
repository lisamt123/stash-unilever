/********************************************************************************
 *@Description:This script used to create list milestone specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
********************************************************************************/
var jq = jQuery.noConflict();
function jsLoadM() {
    /* Below code is to show the phase filter drop down */
    jq(document).on('show.bs.dropdown', '.phaseMFilter', function() {
        var icoButton = jq('.phaseMFilter .dropdown-toggle .icoButton');
        if (jq('.phaseMFilter ul.phaseM').length == 0) {
            var dropDownList = jq('#phaseMFilterDiv').html();
            jq(this).append(dropDownList);
        }
        var selectedValues = IPMAppLM.phaseM;
        var selectedValuesArr = selectedValues.split(',');
        icoButton.removeClass('filter');
        icoButton.addClass('filter-selected');
        if (selectedValuesArr.length != 0) {
            jq('.phaseMFilter .dropdown-menu input[type="checkbox"]').each(function() {
                $this = jq(this);
                var val = $this.attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    $this.prop('checked', true);
                    $this.next('label').addClass('selected');
                } else {
                    $this.prop('checked', false);
                    $this.next('label').removeClass('selected');
                }
            });
        }
    });
    /* Below code is to remove selected class from the checkbox */
    jq(document).on('hide.bs.modal', '#ipmModalEdit', function() {
        jq('.ipmCheckbox input[type="checkbox"]:not(:checked)').closest("tr").removeClass("selected");
    });
    jq(document).on('click', '.dropdown-menu input[type="checkbox"], .dropdown-menu li', function(e) {
        e.stopPropagation();
    });
    /* Below code is to remove a class and add a class for the completed filter drop down */
    jq(document).on('hide.bs.dropdown', '.completedFilterM', function() {
        var icoButton = jq('.completedFilterM .dropdown-toggle .icoButton');
        icoButton.removeClass('filter-selected');
        icoButton.addClass('filter');
    });
    /* Below code is to remove a class and add a class for the phase filter drop down */
    jq(document).on('hide.bs.dropdown', '.phaseMFilter', function() {
        var icoButton = jq('.phaseMFilter .dropdown-toggle .icoButton');
        icoButton.removeClass('filter-selected');
        icoButton.addClass('filter');
    });
    /* Below code is related to completed filter drop down */
    jq(document).on('show.bs.dropdown', '.completedFilterM', function() {
        var icoButton = jq('.completedFilterM .dropdown-toggle .icoButton');
        var selectedValues = IPMAppLM.isCompleteMilestones;
        var selectedValuesArr = selectedValues.split(',');
        icoButton.removeClass('filter');
        icoButton.addClass('filter-selected');
        if (selectedValuesArr.length != 0) {
            jq('.completedFilterM .dropdown-menu input[type="checkbox"]').each(function() {
                $this = jq(this);
                var val = $this.attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    $this.prop('checked', true);
                } else {
                    $this.prop('checked', false);
                }
            });
        }
    });
    jq(".dueDate,.comDate").each(function() {
        jq(this).text(jq(this).text().replace('00:00:00 GMT', ''));
    });
    /* Below code is related to time line view */
    jq(".timeLineView").hide();
    jq(".toggleContainer .timelineIcon").on("click", function() {
        var icoButtonTL = jq('.timelineIcon .icoButton');
        var icoButtonLV = jq('.listViewIcon .icoButton');
        jq("#milestoneList").hide();
        jq(".toggleContainer .listViewIcon").removeClass('selectedView1');
        icoButtonTL.removeClass('timeline');
        icoButtonTL.addClass('timeline-selected');
        icoButtonLV.removeClass('list-selected');
        icoButtonLV.addClass('list');
        jq(".timeLineView").fadeIn("fast");
        jq(this).addClass('selectedView');
    });
    jq(".toggleContainer .listViewIcon").on("click", function() {
        var icoButtonTL = jq('.timelineIcon .icoButton');
        var icoButtonLV = jq('.listViewIcon .icoButton');
        jq(".timeLineView").hide();
        jq(".toggleContainer .timelineIcon").removeClass('selectedView');
        jq("#milestoneList").fadeIn("fast");
        jq(this).addClass('selectedView1');
        icoButtonTL.removeClass('timeline-selected');
        icoButtonTL.addClass('timeline');
        icoButtonLV.removeClass('list');
        icoButtonLV.addClass('list-selected');
    });
    jq(".dueDate,.comDate").each(function() {
        jq(this).text(jq(this).text().replace('00:00:00 GMT', ''));
    });
    function markCompl(mId, isChecked) {
        markCompleteM(mId, isChecked);
        if (isChecked != 'true') {
            jq('.taskCheck input[type=checkbox]#' + mId).closest("tr").removeClass("selected");
        } else {
            jq('.taskCheck input[type=checkbox]#' + mId).closest("tr").addClass("selected");
        }
        timelineSetup();
    }
    /* Below code is for the sorting functionality */
    jq('#sortDueDate1').on('click', function() {
        toggleDueDate1();
    });
    jq('#sortMilestones').on('click', function() {
        toggleSortMilestones();
    });
    jq('#sortPhases1').on('click', function() {
        toggleSortPhases1();
    });
    jq('#sortCompletion1').on('click', function() {
        toggleSortCompletion1();
    });
    jq('#sortCompletedOn').on('click', function() {
        toggleSortCompletedOn();
    });
}
/* Below code is for the time line view functionality */
jsLoadM();
var step = 1;
var current = 0;
var maximum = 0;
var visible = 1;
var speed = 500;
var liSize = 250;
var carousel_height = 210;
jq('#next').click(function() {
    jq('#pre').removeAttr("style");
    if (current + step < 0 || current + step > maximum - visible) {
        return;
    } else {
        current = current + step;
        jq('#ipmTimeLine ul').animate({
            left: -(liSize * current)
        }, speed, null);
    }
    return false;
});
jq('#pre').click(function() {
    if (current - step < 0 || current - step > maximum - visible) {
        return;
    } else {
        current = current - step;
        jq('#ipmTimeLine ul').animate({
            left: -(liSize * current)
        }, speed, null);
    }
    return false;
});
timelineSetup();
function timelineSetup() {
    var blockQuote = jq('blockquote.taskProgress');
    if (blockQuote.length > 0) {
        var contents = blockQuote.html();
        blockQuote.remove();
        var ulTag = '<ul class="taskProgress">' + contents + '</ul>';
        jq('#ipmTimeLine .cInner').append(ulTag);
    }
    jq("#ipmTimeLine").find(".taskProgress span").contents().unwrap();
    maximum = jq('#ipmTimeLine .taskProgress li').size();
    var ulSize = liSize * maximum;
    var divSize = liSize * visible;
    jq('#ipmTimeLine .taskProgress').css("width", ulSize + "px").css("left", -(current * liSize)).css("position", "absolute");
    jq('#pre').css("color", "#ddd");
}
/* Below code is to hide the delete modal */
jq(document).on('click', '#ipmDeleteModal .removeMilestone', function() {
    var milestoneId = jq(this).attr('value');
    deleteMilestone(milestoneId);
    jq("#ipmDeleteModal").modal('hide');
});
/* Below code is to show the delete modal */
function delMilestone(str) {
    var ipmDeleteModal = jq('#ipmDeleteModal');
    ipmDeleteModal.find('.modal-title').html(IPMAppLM.removeMilestone);
    ipmDeleteModal.find('.modal-body').css({
        "height": "120px",
        "margin-right": "15px"
    });
    ipmDeleteModal.find('.confirmMsg').html(IPMAppLM.msgDelMilestone);
    ipmDeleteModal.find('.confirmAction').attr('value', str);
    jq(".confirmAction").addClass("removeMilestone");
}
/* Below code is to push the phase filter selected values */
function fphaseM() {
    var phaseM = [];
    var pStrM;
    jq(".phaseM input:checkbox:checked").each(function() {
        phaseM.push(jq(this).val());
    });
    pStrM = phaseM.toString();
    filteredPhaseM(pStrM);
}
/* Below code is to push the completed filter selected values */
function fCompleteM() {
    var completeM = [];
    var cStrM;
    jq(".completeM input:checkbox:checked").each(function() {
        completeM.push(jq(this).val());
    });
    cStrM = completeM.toString();
    filterCompleteM(cStrM);
}
/* Below code is for the reset functionality */
function fPhaseMReset() {
    jq(".phaseM input:checkbox").each(function() {
        jq(this).prop('checked', false).next('label').removeClass('selected');
    });
    filteredPhaseM('');
}
function fCompleteResetM() {
    jq(".completeM input:checkbox").each(function() {
        jq(this).prop('checked', false);
    });
    filterCompleteM('');
}