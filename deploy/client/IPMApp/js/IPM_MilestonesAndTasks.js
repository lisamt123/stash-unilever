/************************************************************************************
 *@Description:This script is used for IPM Milestone & Tasks page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
************************************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {
    ipmModal('#addMilestone', 'Add Milestone', '60%', '80%', '2%');
    ipmModal('#addTask', 'Add To-do', '320px', '600px', '2%');
    /* Below code is related to edit milestone and edit task on click functionality */
    jq(document).on('dblclick', '.editMilestone, .editTask', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var isDisabled = jq('.editMilestoneBtn').find('input[type=checkbox]').attr('isDisabled');
        if (isDisabled == 'false') {
            openEditModal(this);
        }
        var isDisabled = jq('.editTaskBtn').find('input[type=checkbox]').attr('isDisabled');
        if (isDisabled == 'false') {
            openEditModal(this);
        }
    });
    jq(document).on('click', '.editMilestoneBtn, .editTaskBtn', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        openEditModal(this);
    });
    /* Below code is to open the edit task modal */
    jq(document).on('click', '#editTask', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        jq("#ipmModalEdit .modal-body").html('<iframe id="tskiFrm" frameborder="0" height="84%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
        var iContent = jq('#tskiFrm').contents().find("body").html();
        jq("#ipmModalEdit .modal-body #tskiFrm .container-fluid").clone().prependTo("#div_comp");
        jq("#div_comp").dialog({
            modal: true,
            draggable: false,
            resizable: false,
            position: ['center', 'top'],
            width: 400,
            height: 200
        });
        jq('#ipmModal .modal-title').html('Edit To-Dos');
        jq('#ipmModal .modal-dialog').width('30%');
        jq('#ipmModal .modal-dialog').height('90%');
        jq('#ipmModal .modal-dialog').css('margin-top', '3%');
    });
    /* Below code is to add a class to the selected check boxes  */
    jq(".ipmCheckbox").find("input[type=checkbox]:checked").closest("tr").addClass("selected");
    jq(".ipmCheckbox").on("click", "input[type=checkbox]", function() {
        var $this = jq(this);
        if ($this.prop("value") == "true") {
            $this.closest("tr").addClass("selected");
        } else {
            $this.closest("tr").removeClass("selected");
        }
    });
    if (IPMApp.pmApproachMessage == "true") {
        jq('.ipmStatistics').hide();
        jq('#addTask').hide();
        jq('#tasksAssignedToMeFilter').hide();
    }
    jq('.proRoute input[type=radio]').each(function(e) {
        jq(this).click(function() {
            var redData1 = jq(this).attr("value").split(" ");
            var actData1 = redData1[0];
            jq(".routeTip").hide();
            jq('.proRoute ').parent('.transBox').find("#" + actData1).show();
        });
    });
    var complexity = jq('.transBox .ipmRadioButton input[type=radio]').attr('ischecked');
    var isDisabled = jq('.transBox .ipmRadioButton input[type=radio]').attr('isDisabled');
    var manageToDo = jq('.askManageTodos .ipmCheckbox input[type=checkbox]').attr('ischecked');
    var displayTasksChkBox = jq('#displayTasksChkBox');
    var full = "Full";
    var $full = jq('#Full');
    var $lite = jq('#Lite');
    if (isDisabled == 'true') {
        jq('.transBox .ipmRadioButton input[type=radio]').prop('disabled', true);
    }
    if (complexity == full) {
        jq('#full').prop('checked', true);
        $lite.hide();
        $full.show();
    } else {
        jq('#lite').prop('checked', true);
        $full.hide();
        $lite.show();
    }
    if (manageToDo == "Internal") {
        displayTasksChkBox.prop('checked', true);
        displayTasksChkBox.next().addClass('selected');
    } else {
        displayTasksChkBox.prop('checked', false);
        displayTasksChkBox.next().removeClass('selected');
    }

});
/* Below code is related to the time line view functionality */
function checkBoxScript() {
    jq(".timeLineView").hide();
    jq(".toggleContainer .icoButton.document").on("click", function() {
        if (jq(".ipmTaskRow").is(":visible")) {
            jq(".ipmTaskRow").hide();
            jq(".timeLineView").fadeIn("fast");
        } else {
            jq(".ipmTaskRow").hide();
            jq(".ipmTaskRow").fadeIn("fast");
        }
    });
    jq(window).scroll(function() {
        pageScrollTop = jq(window).scrollTop();
    });
}
/* Below code is to open the edit modal */
function openEditModal(elem) {
    var url = jq(elem).attr('value');
    var top = jq(elem).closest('tr').offset().top - pageScrollTop;
    var mBody = jq("#ipmModalEdit .modal-body");
    var mDialog = jq('#ipmModalEdit .modal-dialog');
    jq('#ipmModalEdit').modal({
        show: true,
        keyboard: false,
        backdrop: true
    });
    mBody.html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
    mBody.height('100%');
    mDialog.css('margin-top', top);
    jq('#ipmModalEdit .modal-title').html('Edit Milestone');
    mDialog.width('92.3%');
    mDialog.height('200px');
    mDialog.css('margin-left', '2%');
    mDialog.css('margin-right', '8%');
}
checkBoxScript();