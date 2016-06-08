/***************************************************************************************
 *@Description:This script used to create IPM_AddMilestone page specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
****************************************************************************************/
/* Below script is to validate and display error message */
var jq = jQuery.noConflict();
jq("#errorMsg").hide();
function validate() {
    if (jq("#dueDate").val() == null) {
        $("#errorMsg").show();
    }
}
/* Below script will redirect page to Tasklist page */
function pageclose() {
    window.top.location.href = IPMAppComp.pageRef + '?id=' + IPMAppComp.projectId;
}
/* Below script will redirect page to Project setup page or Tasklist page */
function pagecloseProSetUp() {
    if (IPMAppComp.ProjectWizard != '' || IPMAppComp.ProjectWizard != null) {
        window.top.location.href = IPMAppComp.pageRefProSetupView + '?Pid=' + IPMAppComp.projectId + '&Milestoneid=milestones';
    } else {
        window.top.location.href = IPMAppComp.pageRefTask + '?id=' + IPMAppComp.projectId;
    }
}
/* Below script if for the Tab functionality in Add milestone Modal */
jq(document).ready(function() {
    jq('#ipmAddMilestoneTab .ipmMilestoneContent').hide();
    jq('#ipmAddMilestoneTab .ipmMilestoneTabs li:first').addClass('active');
    jq('#ipmAddMilestoneTab .ipmMilestoneContent:first').show();
    jq('#ipmAddMilestoneTab .ipmMilestoneTabs li').on('click', function(e) {
        e.preventDefault();
        jq('#ipmAddMilestoneTab .ipmMilestoneTabs li').removeClass('active');
        var $this = jq(this);
        var getClass = $this.attr('class').split(' ');
        var getId = getClass[0];
        jq('#ipmAddMilestoneTab .ipmMilestoneContent').hide();
        $this.addClass('active');
        jq('#' + getId).fadeIn("fast");
    });
    jq(document).find(".additionalMstone input[type=checkbox]:checked").closest("tr").addClass("selected");
    jq(document).on("click", ".additionalMstone input[type=checkbox]", function() {
        var $this = jq(this);
        if ($this.is(":checked")) {
            $this.next('label').addClass("selected");
            $this.closest("tr").addClass("selected");
        } else {
            $this.next('label').removeClass("selected");
            $this.closest("tr").removeClass("selected");
        }
    });
    jq('input[type=checkbox]').each(function() {
        var $this = jq(this);
        var val = $this.attr('value');
        if (val === 'true') {
            $this.prop('checked', true);
            $this.next('label').addClass('selected');
        } else {
            $this.prop('checked', false);
        }
    });
});