/****************************************************************************
 *@Description:This script is used for IPM Task List page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
*****************************************************************************/
var jq = jQuery.noConflict();
/* Below code is related to delete task modal */
/* As per the sonar comments script has been split to separate function phaseMfilter */
function callbackLoadAction() {
    jq(document).on('click', '#ipmDeleteModal .removeTask', function() {
        var taskId = '';
        if (taskId != jq(this).attr('value')) {
            taskId = jq(this).attr('value');
            deleteTask(taskId);
            jq("#ipmDeleteModal").modal('hide');
        }
    });
    phaseMfilter();
    /* Below code is for the user filter drop down functionality*/
    jq(document).on('show.bs.dropdown', '.userFilter', function() {
        if (jq('.userFilter ul.user').length == 0) {
            var dropDownList = jq('#userFilterDiv').html();
            jq(this).append(dropDownList);
        }
        jq('.userFilter .dropdown-toggle .icoButton').removeClass('filter');
        jq('.userFilter .dropdown-toggle .icoButton').addClass('filter-selected');
        var selectedValues = IPMAppComp.assignee;
        var selectedValuesArr = selectedValues.split(',');
        if (selectedValuesArr.length != 0) {
            jq('.userFilter .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                } else {
                    jq(this).prop('checked', false);
                }
            });
        }
    });
    jq(document).on('click', '.dropdown-menu input[type="checkbox"], .dropdown-menu label', function(e) {
        e.stopPropagation();
    });
    /* Below code is to hide the drop down filters */
    jq(document).on('hide.bs.dropdown', '.completedFilterT', function() {
        jq('.completedFilterT .dropdown-toggle .icoButton').removeClass('filter-selected');
        jq('.completedFilterT .dropdown-toggle .icoButton').addClass('filter');
    });
    jq(document).on('hide.bs.dropdown', '.userFilter', function() {
        jq('.userFilter .dropdown-toggle .icoButton').removeClass('filter-selected');
        jq('.userFilter .dropdown-toggle .icoButton').addClass('filter');
    });
    jq(document).on('hide.bs.dropdown', '.phaseFilter', function() {
        jq('.phaseFilter .dropdown-toggle .icoButton').removeClass('filter-selected');
        jq('.phaseFilter .dropdown-toggle .icoButton').addClass('filter');
    });
    /* Below code is for the completed filter drop down functionality*/
    jq(document).on('show.bs.dropdown', '.completedFilterT', function() {
        var selectedValues = IPMAppComp.isCompleteTasks;
        var selectedValuesArr = selectedValues.split(',');
        jq('.completedFilterT .dropdown-toggle .icoButton').removeClass('filter');
        jq('.completedFilterT .dropdown-toggle .icoButton').addClass('filter-selected');
        if (selectedValuesArr.length != 0) {
            jq('.completedFilterT .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                } else {
                    jq(this).prop('checked', false);
                }
            });
        }
    });
    /* Below code is for sorting functionality */
    jq('#sortDueDate').on('click', function() {
        toggleDueDate();
    });
    jq('#sortTasks').on('click', function() {
        toggleSortTasks();
    });
    jq('#sortSections').on('click', function() {
        toggleSortSections();
    });
    jq('#sortPhases').on('click', function() {
        toggleSortPhases();
    });
    jq('#sortCompletion').on('click', function() {
        toggleSortCompletion();
    });
    jq('#sortAssignees').on('click', function() {
        toggleSortAssignees();
    });
}
function phaseMfilter(){
/* Below code is for the phase filter drop down functionality*/
    jq(document).on('show.bs.dropdown', '.phaseFilter', function() {
        if (jq('.phaseFilter ul.phase').length == 0) {
            var dropDownList = jq('#phaseFilterDiv').html();
            jq(this).append(dropDownList);
        }
        var selectedValues = IPMAppComp.selectedValues;
        var selectedValuesArr = selectedValues.split(',');
        jq('.phaseFilter .dropdown-toggle .icoButton').removeClass('filter');
        jq('.phaseFilter .dropdown-toggle .icoButton').addClass('filter-selected');
        if (selectedValuesArr.length != 0) {
            jq('.phaseFilter .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                } else {
                    jq(this).prop('checked', false);
                }
            });
        }
    });
}
callbackLoadAction();
/* Below code is to push the selected values from filters */
function fPhase() {
    var phase = [];
    jq(".phase input:checkbox:checked").each(function() {
        phase.push(jq(this).val());
    });
    var pStr = phase.toString();
    filteredPhase(pStr);
}
function fUser() {
    var user = [];
    jq(".user input:checkbox:checked").each(function() {
        user.push(jq(this).val());
    });
    var uStr = user.toString();
    filterAssignee(uStr);
}
function fComplete() {
    var complete = [];
    jq(".complete input:checkbox:checked").each(function() {
        complete.push(jq(this).val());
    });
    var cStr = complete.toString();
    filterComplete(cStr);
}
function fPhaseReset() {
    jq(".phase input:checkbox").each(function() {
        jq(this).prop('checked', false);
        jq(this).next('label').removeClass('selected');
    });
    filteredPhase('');
}
function fUserReset() {
    jq(".user input:checkbox").each(function() {
        jq(this).prop('checked', false);
        jq(this).next('label').removeClass('selected');
    });
    filterAssignee('');
}
function fCompleteReset() {
    jq(".complete input:checkbox").each(function() {
        jq(this).prop('checked', false);
    });
    filterComplete('');
}
/* Below code is to check the check boxes based on the selected values  */
function selectCheckBox(element, filterName, arr) {
    jq('.' + filterName + ' .dropdown-menu input[type="checkbox"]').each(function() {
        var val = jq(this).attr('value');
        if (jq.inArray(val, arr) != -1) {
            jq(element).prop('checked', true);
            jq(element).next('label').addClass('selected');
        } else {
            jq(element).prop('checked', false);
        }
    });
}
/* Below code is for to open the delete modal */
function myFunc(str, isLst, gateName, secName) {
    var errMsg = ''
    if (isLst == 'true') {
        errMsg = 'All To-do\'s correlating to the ' + gateName + ' Section ' + secName + '  have been removed. Would you like to remove this section from the ' + gateName + ' Document?';
    } else {
        errMsg = IPMAppComp.errMsg;
    }
    jq('#ipmDeleteModal .modal-title').html(IPMAppComp.removeToDo);
    jq('#ipmDeleteModal .confirmMsg').html(errMsg);
    jq('#ipmDeleteModal .modal-body').css({
        "height": "120px",
        "margin-right": "15px"
    });
    jq('#ipmDeleteModal .confirmAction').attr('value', str);
    jq(".confirmAction").addClass("removeTask");
}
/* Below code is to check the check boxes based on the selected values  */
function myAssignedTasks(taskId, isChecked) {
    if (isChecked != 'true') {
        jq('.taskCheck input[type=checkbox]#' + taskId).closest("tr").removeClass("selected");
    } else {
        jq('.taskCheck input[type=checkbox]#' + taskId).closest("tr").addClass("selected");
    }
    var len = (jq('.taskCheck input[type=checkbox]#' + taskId)).length;
    markComplete(taskId, isChecked);
}
jq(document).ready(function() {
    jq('.sortIcon').addClass('fa-angle-down');
});