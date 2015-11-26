/*************************************************************************
 *@Description:This script is used for BOSSCARD status specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015
*************************************************************************/
var jq = jQuery.noConflict();
/* Below script is for the Tab Functionality */
jq(document).ready(function() {
    var statusTab = jq('#ipmUpdateStatusTab');
    statusTab.parent().find('.ipmGetStartedContent').hide();
    jq('#ipmUpdateStatusTab .ipmStatusTabs li:first').addClass('active');
    statusTab.parent().find('.ipmGetStartedContent:first').show();
    jq('#ipmUpdateStatusTab .ipmStatusTabs li:first').find('input:radio').prop("checked", "true");
    jq('#ipmUpdateStatusTab .ipmStatusTabs li').on('click', function(e) {
        e.preventDefault();
        var $this = jq(this);
        jq('#ipmUpdateStatusTab .ipmStatusTabs li').removeClass('active');
        jq('#ipmUpdateStatusTab .ipmStatusTabs li').removeClass('highlightRed');
        var getId = $this.attr('class');
        if (getId == 'status_discard') {
            $this.addClass('highlightRed');
            $this.addClass('active').find('input:radio').prop("checked", "true");
            statusTab.parent().find('.ipmGetStartedContent').hide();
            jq('#' + getId).show();
            jq('#status_discard .sContainer').addClass('highlightBgred');
        } else {
            $this.addClass('active').find('input:radio').prop("checked", "true");
            statusTab.parent().find('.ipmGetStartedContent').hide();
            jq('#' + getId).show();
        }
    });
});
/* Below script is for the Cancel Functionality */
function cancel() {
    window.top.location.href = IPMApp.bossurl + '?id=' + IPMApp.bosscardId;
}
/* Below script is to check the BOSSCARD status and navigate to respective pages */
function goToBosscardParentPage() {
    if (IPMApp.status == 'In Progress' || IPMApp.status == 'Not Approved') {
        window.top.location.href = IPMApp.bossurl + '?id=' + IPMApp.bosscardId;
    } else if (IPMApp.status == 'Approved') {
        if (IPMApp.CurrentPage == 'true') {
            window.top.location.href = IPMApp.projecturl + '?Pid=' + IPMApp.projectId;
        } else {
            window.top.location.href = IPMApp.homeurl;
        }
    } else if (IPMApp.status == 'In Progress' || IPMApp.status == 'Discard') {
        window.top.location.href = IPMApp.homeurl;
    }
}
/* Below script is to update the BOSSCARD status */
function changeBosscardStatus(status) {
    updateBosscardStatus(status);
}
/* Below script is for the Search functionality */
jq('.searchLeader').keypress(function(e) {
    if (e.which == 13) {
        callsearch(jq('.searchLeader').val());
        return false;
    }
});