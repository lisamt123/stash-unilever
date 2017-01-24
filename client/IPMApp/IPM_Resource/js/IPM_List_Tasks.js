/****************************************************************************
                 *@Description:This script is used for IPM Task List page specific interaction
                 *@Author: Cognizant
                 *@Created Date: 28/05/2015 
                *****************************************************************************/
                var jq = jQuery.noConflict();
                
                function callbackLoadAction() {
                    removeTaskmodal();
                    phaseFilterdrpdown();
                    userFilterdrpdown();
                    hideCompletedfilter();
                    hideUserfilter();
                    hidePhasefilter();
                    completedFilterdrpdown();
                    jq(document).on('click', '.dropdown-menu input[type="checkbox"], .dropdown-menu label', function(e) {
                        e.stopPropagation();
                    });
                                        
                    /* Below script works on click event. It sorts the due date. */
                    jq('#sortDueDate').on('click', function() {
                        toggleDueDate();
                    });
                    
                     /* Below script works on click event. It sorts the tasks. */
                    jq('#sortTasks').on('click', function() {
                        toggleSortTasks();
                    });
                    
                     /* Below script works on click event. It sorts the sections. */
                    jq('#sortSections').on('click', function() {
                        toggleSortSections();
                    });
                    
                     /* Below script works on click event. It sorts the phases. */
                    jq('#sortPhases').on('click', function() {
                        toggleSortPhases();
                    });
                    
                     /* Below script works on click event. It sorts the completion date. */
                    jq('#sortCompletion').on('click', function() {
                        toggleSortCompletion();
                    });
                    
                     /* Below script works on click event. It sorts the assignee. */
                    jq('#sortAssignees').on('click', function() {
                        toggleSortAssignees();
                    });
                }
                
                function removeTaskmodal(){
                    /* Below function performs delete operation. When clicked on remove button, it checks for a condition. If the condition is true
                    it calls a function 'deleteTask' and hides the delete modal. */
                    jq(document).on('click', '#ipmDeleteModal .removeTask', function() {
                        var taskId = '';
                        if (taskId !== jq(this).attr('value')) {
                            taskId = jq(this).attr('value');
                            deleteTask(taskId);
                            jq("#ipmDeleteModal").modal('hide');
                        }
                    });
                }
                function phaseFilterdrpdown(){
                    /* Below script works on click event for the phase filter. If the condition is true the options for the drop down list will be appended. */
                    jq(document).on('show.bs.dropdown', '.phaseFilter', function() {
                        if (jq('.phaseFilter ul.phase').length === 0) {
                            var dropDownList = jq('#phaseFilterDiv').html();
                            jq(this).append(dropDownList);
                        }
                        var selectedValues = IPMAppComp.selectedValues;
                        var selectedValuesArr = selectedValues.split(',');
                        jq('.phaseFilter .dropdown-toggle .icoButton').removeClass('filter');
                        jq('.phaseFilter .dropdown-toggle .icoButton').addClass('filter-selected');
                        
                    /* Below script checks a condition for the phase filter. If the condition is true the checkbox will be checked. */
                        if (selectedValuesArr.length !== 0) {
                            jq('.phaseFilter .dropdown-menu input[type="checkbox"]').each(function() {
                                var val = jq(this).attr('value');
                                if (jq.inArray(val, selectedValuesArr) !== -1) {
                                    jq(this).prop('checked', true);
                                    jq(this).next('label').addClass('selected');
                                } else {
                                    jq(this).prop('checked', false);
                                    jq(this).next('label').removeClass('selected');
                                }
                            });
                        }
                    });
                }
                function userFilterdrpdown(){
                    /* Below script works on click event for user filter. If the condition is true the options for the drop down list will be appended. */
                    jq(document).on('show.bs.dropdown', '.userFilter', function() {
                        if (jq('.userFilter ul.user').length === 0) {
                            var dropDownList = jq('#userFilterDiv').html();
                            jq(this).append(dropDownList);
                        }
                        jq('.userFilter .dropdown-toggle .icoButton').removeClass('filter');
                        jq('.userFilter .dropdown-toggle .icoButton').addClass('filter-selected');
                        var selectedValues = IPMAppComp.assignee;
                        var selectedValuesArr = selectedValues.split(',');
                        
                    /* Below script checks a condition for the user filter. If the condition is true the checkbox will be checked. */
                        if (selectedValuesArr.length !== 0) {
                            jq('.userFilter .dropdown-menu input[type="checkbox"]').each(function() {
                                var val = jq(this).attr('value');
                                if (jq.inArray(val, selectedValuesArr) !== -1) {
                                    jq(this).prop('checked', true);
                                    jq(this).next('label').addClass('selected');
                                } else {
                                    jq(this).prop('checked', false);
                                    jq(this).next('label').removeClass('selected');
                                }
                            });
                        }
                    });
                }
                function hideCompletedfilter(){
                    /* Below script works on click event for completed filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
                    jq(document).on('hide.bs.dropdown', '.completedFilterT', function() {
                        var icoButton = jq('.completedFilterT .dropdown-toggle .icoButton');
                        var selectedValues = IPMAppComp.isCompleteTasks.trim();
                        var selectedValuesArr = selectedValues.split(',');
                        if (selectedValues.length === 0  || selectedValuesArr.length === 0) 
                        {
                            icoButton.removeClass('filter-selected');
                            icoButton.addClass('filter');
                        }
                        
                    });
                }
                function hideUserfilter(){
                    /* Below script works on click event for user filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
                    jq(document).on('hide.bs.dropdown', '.userFilter', function() {
                        var icoButton = jq('.userFilter .dropdown-toggle .icoButton');
                        var selectedValues = IPMAppComp.assignee.trim();
                        var selectedValuesArr = selectedValues.split(',');
                        if (selectedValues.length === 0  || selectedValuesArr.length === 0) 
                        {
                            icoButton.removeClass('filter-selected');
                            icoButton.addClass('filter');
                        }
                    });
                }
                function hidePhasefilter(){
                    /* Below script works on click event for phase filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
                    jq(document).on('hide.bs.dropdown', '.phaseFilter', function() {
                        var icoButton = jq('.phaseFilter .dropdown-toggle .icoButton');
                        var selectedValues = IPMAppComp.selectedValues.trim();
                        var selectedValuesArr = selectedValues.split(',');
                        if (selectedValues.length === 0  || selectedValuesArr.length === 0) 
                        {
                            icoButton.removeClass('filter-selected');
                            icoButton.addClass('filter');
                        }
                    });
                }
                function completedFilterdrpdown(){
                    /* Below script works on click event for completed filter. If the condition is true the checkboxes will be checked based on the back end values. */
                    jq(document).on('show.bs.dropdown', '.completedFilterT', function() {
                        var selectedValues = IPMAppComp.isCompleteTasks;
                        var selectedValuesArr = selectedValues.split(',');
                        jq('.completedFilterT .dropdown-toggle .icoButton').removeClass('filter');
                        jq('.completedFilterT .dropdown-toggle .icoButton').addClass('filter-selected');
                        if (selectedValuesArr.length !== 0) {
                            jq('.completedFilterT .dropdown-menu input[type="checkbox"]').each(function() {
                                var val = jq(this).attr('value');
                                if (jq.inArray(val, selectedValuesArr) !== -1) {
                                    jq(this).prop('checked', true);
                                    jq(this).next('label').addClass('selected');
                                } else {
                                    jq(this).prop('checked', false);
                                    jq(this).next('label').removeClass('selected');
                                }
                            });
                        }
                    });
                }
                callbackLoadAction();
                /* Below function checks the checked checkboxes and pushes the value to a function. It is for phase filtering. */
                function fPhase() {
                    var phase = [];
                    jq(".phase input:checkbox:checked").each(function() {
                        phase.push(jq(this).val());
                    });
                    var pStr = phase.toString();
                    filteredPhase(pStr);
                }
                
                /* Below function checks the checked checkboxes and pushes the value to a function. It is for user filtering. */
                function fUser() {
                    var user = [];
                    jq(".user input:checkbox:checked").each(function() {
                        user.push(jq(this).val());
                    });
                    var uStr = user.toString();
                    filterAssignee(uStr);
                }
                
                /* Below function checks the checked checkboxes and pushes the value to a function. It is for completed filtering. */
                function fComplete() {
                    var complete = [];
                    jq(".complete input:checkbox:checked").each(function() {
                        complete.push(jq(this).val());
                    });
                    var cStr = complete.toString();
                    filterComplete(cStr);
                }
                
                /* Below function performs the reset functionality for phase. The recent changes made to the checkboxes will be reverted back. */
                function fPhaseReset() {
                    jq(".phase input:checkbox").each(function() {
                        jq(this).prop('checked', false);
                        jq(this).next('label').removeClass('selected');
                    });
                    filteredPhase('');
                }
                
                /* Below function performs the reset functionality for user. The recent changes made to the checkboxes will be reverted back. */
                function fUserReset() {
                    jq(".user input:checkbox").each(function() {
                        jq(this).prop('checked', false);
                        jq(this).next('label').removeClass('selected');
                    });
                    filterAssignee('');
                }
                
                /* Below function performs the reset functionality for completed. The recent changes made to the checkboxes will be reverted back. */
                function fCompleteReset() {
                    jq(".complete input:checkbox").each(function() {
                        jq(this).prop('checked', false);
                    });
                    filterComplete('');
                }
                /* Below function check the checkboxes value. If the condition is true the checkboxes will be checked based on the back end values. */
                function selectCheckBox(element, filterName, arr) {
                    jq('.' + filterName + ' .dropdown-menu input[type="checkbox"]').each(function() {
                        var val = jq(this).attr('value');
                        if (jq.inArray(val, arr) !== -1) {
                            jq(element).prop('checked', true);
                            jq(element).next('label').addClass('selected');
                        } else {
                            jq(element).prop('checked', false);
                        }
                    });
                }
                /* Below function performs a validation to display the error message inside the modal based on the condition. It also changes 
                    the modal title, modal body's content as per the condition. */
                function myFunc(str, isLst, gateName, secName) {
                    var errMsg = ''
                    if (isLst === 'true') {
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
                /* Below function checks for a condition. If the condition is true it highlights the row by adding a different css class which adds a color. */
                function myAssignedTasks(taskId, isChecked) {
                    if (isChecked !== 'true') {
                        jq('.taskCheck input[type=checkbox]#' + taskId).closest("tr").removeClass("selected");
                    } else {
                        jq('.taskCheck input[type=checkbox]#' + taskId).closest("tr").addClass("selected");
                    }
                    var len = (jq('.taskCheck input[type=checkbox]#' + taskId)).length;
                    markComplete(taskId, isChecked);
                }
                jq(document).ready(function() {
                    jq('.sortIcon').addClass('fa-angle-down');
                    jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10' }}); 
                });