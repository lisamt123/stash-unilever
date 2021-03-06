/************************************************************************************
 *@Description:This script is used for IPM Milestone & Tasks page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
************************************************************************************/

var jq = jQuery.noConflict();
jq(document).ready(function() {
    /* Below script works on double click. If the condition is true it calls openEditModal function. */
    jq(document).on('dblclick', '.editMilestone', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var isDisabled = jq('.editMilestoneBtn').find('input[type=checkbox]').attr('isDisabled');
        if (isDisabled === 'false') {
            openEditModal(this);
        }
    });
    
    /* Below script works on double click. If the condition is true it opens up the edit to-do's modal. */
    jq(document).on('dblclick', '.editTask', function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        jq("#ipmModalEdit .modal-body").html('<iframe id="tskiFrm" frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
        jq('#ipmModalEdit').modal({
            show: true,
            keyboard: false,
            backdrop: true
        });
        jq('#ipmModalEdit .modal-title').html('Edit To-do\'s');
        jq('#ipmModalEdit .modal-dialog').width('30%');
        jq('#ipmModalEdit .modal-dialog').height('80%');
        jq('#ipmModalEdit .modal-dialog').css('margin-top', '2%');
    });
  /* Below script is to add a class to table row based on the selected check boxes  */
    jq(".ipmCheckbox").find("input[type=checkbox]:checked").closest("tr").addClass("selected");
    jq(".ipmCheckbox").on("click", "input[type=checkbox]", function() {
        var $this = jq(this);
        if ($this.prop("value") === "true") {
            $this.closest("tr").addClass("selected");
        } else {
            $this.closest("tr").removeClass("selected");
        }
    });
    if (IPMApp.pmApproachMessage === "true") {
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
    if (isDisabled === 'true') {
        jq('.transBox .ipmRadioButton input[type=radio]').prop('disabled', true);
    }
    if (complexity === full) {
        jq('#full').prop('checked', true);
        $lite.hide();
        $full.show();
    } else {
        jq('#lite').prop('checked', true);
        $full.hide();
        $lite.show();
    }
    if (manageToDo === "Internal") {
        displayTasksChkBox.prop('checked', true);
        displayTasksChkBox.next().addClass('selected');
    } else {
        displayTasksChkBox.prop('checked', false);
        displayTasksChkBox.next().removeClass('selected');
    }
     hilightTaskScript();

});
/* Below function performs the toggling of time line view and list view. */
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
/* Below function opens up the edit milestone modal. */
function openEditModal(elem) {
    var url = jq(elem).attr('value');
    var mBody = jq("#ipmModalEdit .modal-body");
    var mDialog = jq('#ipmModalEdit .modal-dialog');
    jq('#ipmModalEdit').modal({
        show: true,
        keyboard: false,
        backdrop: true
    });
    mBody.html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
    mBody.height('100%');
    mDialog.css('margin-top', '2%');
    jq('#ipmModalEdit .modal-title').html('Edit Milestone');
    mDialog.width('30%');
    mDialog.height('64%');
}
checkBoxScript();

/* Below function contains the script which has the tooltip functionality. This function is called when the rerendering happens and the script will run again */
function hilightTaskScript(){
   /* jq(".info").tooltip({ 
    position: { my: 'center top', at: 'center bottom+10' },
    hide: {
    effect: "",
    delay: 2600
  }
    });*/
    jq(".deleteChannel").tooltip({ position: { my: 'center top', at: 'center bottom+10' }});    
    jq(".arrow-left").tooltip({ position: { my: 'left top', at: 'center bottom+10' },tooltipClass:'ui-lefttip'}); 
    jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}
    ipmModal('#addMilestone', 'Add Milestone', '60%', '80%', '2%');
    ipmModal('#addTask', 'Add To-do', '38%', '560px', '2%');
    ipmModal('#editMilestone', 'Edit Milestone', '30%', '72%', '2%');
    ipmModal('#editTask', 'Edit To-do\'s', '38%', '580px', '2%');
/*jq('#ipmMilestoneTabList .ipmMilestonetodosContent').hide();
    jq('#ipmMilestoneTabList .ipmMilestonetodosTabs li:first').addClass('active');
    jq('#ipmMilestoneTabList .ipmMilestonetodosContent:first').show();*/
    jq(window).load(function(){
        jq('#ipmMilestoneTabList .ipmMilestonetodosContent').hide();
    if (window.location.search.indexOf('&name=newMstone') > -1) {
        jq('#ipmMilestoneTabList .ipmMilestonetodosTabs li.newMstone').addClass('active');
        jq('#ipmMilestoneTabList .ipmMilestonetodosContent#newMstone').show();
    }else if (window.location.search.indexOf('&name=todolistcontent') > -1) { 
        jq('#ipmMilestoneTabList .ipmMilestonetodosTabs li.todolistcontent').addClass('active'); 
        jq('#ipmMilestoneTabList .ipmMilestonetodosContent#todolistcontent').show(); 
    }else{
        jq('#ipmMilestoneTabList .ipmMilestonetodosTabs li:first').addClass('active');
        jq('#ipmMilestoneTabList .ipmMilestonetodosContent:first').show();
    }
}); 
/* Below script is for the Tab functionality on click event. Based on the clicked li the tab is highlighted and the content related the clicked tab is displayed. Also it hides the previous opened content */
    jq('#ipmMilestoneTabList .ipmMilestonetodosTabs li').on('click', function(e) {
        e.preventDefault();
        jq('#ipmMilestoneTabList .ipmMilestonetodosTabs li').removeClass('active');
        var $this = jq(this);
        var getClass = $this.attr('class').split(' ');
        var getId = getClass[0];
        jq('#ipmMilestoneTabList .ipmMilestonetodosContent').hide();
        $this.addClass('active');
        jq('#' + getId).fadeIn("fast");
    });
jq(function () {
    jq('.info').tooltip({
            position: {
                my: "center bottom-13",
                at: "center top",
                using: function( position, feedback ) {
                    jq( this ).css( position );
                    jq( this )
                        .addClass( feedback.vertical );
                }
        },
			tooltipClass: "info_tooltips",
        show: null, 
        close: function (event, ui) {
            ui.tooltip.hover(
            function () {
                jq(this).stop(true).fadeTo(400, 1);
            },
            function () {
                jq(this).fadeOut("400", function () {
                    jq(this).remove();
                })
            });
        }
    });
});