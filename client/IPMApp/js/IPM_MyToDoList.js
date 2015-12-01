/***********************************************************************************
 *@Description:This script is used to develop My To Do List page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
***********************************************************************************/
var jq = jQuery.noConflict();
jq(document).ready(function() {
    /* Below code is for the accordion functionality */
    var accordion = jq(".ipmAccordion").find(".pHead span.expico");
    accordion.removeClass("fa-plus");
    accordion.addClass("fa-minus");
    jq(".ipmAcrdnExpand").show();
    /* Below code is for the drop down functionality */
    jq(document).on('hide.bs.dropdown', '.phaseFilter, .completedFilter, .projectFilter, .brandFilter, .categoryFilter', function() {
        var $this = jq(this);
        $this.find('.dropdown-toggle .icoButton').removeClass('filter-selected');
        $this.find('.dropdown-toggle .icoButton').addClass('filter');
    });
    jq(document).on('click', '.dropdown-menu input[type="checkbox"], .dropdown-menu li', function(e) {
        e.stopPropagation();
    });
    /* Below code is to add class to selected check boxes*/
    jq(document).on('click', '.ipmCheckbox input[type="checkbox"]', function() {
        var $this = jq(this);
        if ($this.is(':checked')) {
            $this.next('label').addClass('selected');
            $this.closest("tr").addClass("selected");
        } else {
            $this.next('label').removeClass('selected');
            $this.closest("tr").removeClass("selected");
        }
    });
});
function completedFilter() {
    jq('.mytoProSearch').clearSearch();
    /* Below code is for the sorting functionality */
    jq(document).on('click', '#sortPhases', function() {
        toggleSortPhases();
    });
    jq(document).on('click', '#sortTasks', function() {
        toggleSortTasks();
    });
    jq(document).on('click', '#sortSections', function() {
        toggleSortSections();
    });
    jq(document).on('click', '#sortDueDate', function() {
        jq('.ipmTable td.dueDateCol').css('background', '#DDEEF5');
        toggleDueDate();
    });
    jq('#srchTxt').keypress(function(e) {
        if (e.which == 13) {
            sProjects(srchTxt.value);
            return false;
        }
    });
    /* Below code is for the completed filter drop down */
    jq(document).on('show.bs.dropdown', '.completedFilter', function() {
        var selectedValues = IPMAppTD.isCompleteTasks;
        var selectedValuesArr = selectedValues.split(',');
        jq('.completedFilter .dropdown-toggle .icoButton').removeClass('filter');
        jq('.completedFilter .dropdown-toggle .icoButton').addClass('filter-selected');
        jq('.completedFilter .dropdown-menu input[type="checkbox"]').each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
        if (selectedValuesArr != '' && selectedValuesArr.length != 0) {
            jq('.completedFilter .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                    jq(this).next().addClass('selected');
                } else {
                    jq(this).prop('checked', false);
                }
            });
        } else {
            jq('.completedFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
        }
    });
    /* Below code is to show or hide the project filter drop down */
    jq(document).on('hide.bs.dropdown', '.projectFilter', function() {
        jq('input[id*=srchTxt]').val('');
        jq('.projectFilter .dropdown-toggle .icoButton').removeClass('filter-selected');
        filteredProjectReset('');
    });
    jq(document).on('show.bs.dropdown', '.projectFilter', function() {
        setProjectFilter(true);
    });
    /* Below code is to show the brand filter drop down */
    jq(document).on('show.bs.dropdown', '.brandFilter', function() {
        var selectedValues = IPMAppTD.brandName;
        var selectedValuesArr = selectedValues.split(',');
        jq('.brandFilter .dropdown-toggle .icoButton').removeClass('filter');
        jq('.brandFilter .dropdown-toggle .icoButton').addClass('filter-selected');
        jq('.brandFilter .dropdown-menu input[type="checkbox"]').each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
        if (selectedValuesArr != '' && selectedValuesArr.length != 0) {
            jq('.brandFilter .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                    jq(this).next().addClass('selected');
                } else {
                    jq(this).prop('checked', false);
                }
            });
        } else {
            jq('.brandFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
        }
    });
    /* Below code is to show the category filter drop down */
    jq(document).on('show.bs.dropdown', '.categoryFilter', function() {
        var selectedValues = IPMAppTD.categoryName;
        var selectedValuesArr = selectedValues.split(',');
        jq('.categoryFilter .dropdown-toggle .icoButton').removeClass('filter');
        jq('.categoryFilter .dropdown-toggle .icoButton').addClass('filter-selected');
        jq('.categoryFilter .dropdown-menu input[type="checkbox"]').each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
        if (selectedValuesArr != '' && selectedValuesArr.length != 0) {
            jq('.categoryFilter .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                    jq(this).next().addClass('selected');
                } else {
                    jq(this).prop('checked', false);
                }
            });
        } else {
            jq('.categoryFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
        }
    });
    /* Below code is to show the phase filter drop down */
    jq(document).on('show.bs.dropdown', '.phaseFilter', function() {
        var selectedValues = IPMAppTD.phase;
        var selectedValuesArr = selectedValues.split(',');
        jq('.phaseFilter .dropdown-toggle .icoButton').removeClass('filter');
        jq('.phaseFilter .dropdown-toggle .icoButton').addClass('filter-selected');
        jq('.phaseFilter .dropdown-menu input[type="checkbox"]').each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
        if (selectedValuesArr != '' && selectedValuesArr.length != 0) {
            jq('.phaseFilter .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) != -1) {
                    jq(this).prop('checked', true);
                    jq(this).next().addClass('selected');
                } else {
                    jq(this).prop('checked', false);
                }
            });
        } else {
            jq('.phaseFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
        }
    });
}
/* Below code is for the reset functionality */
function fProjectReset() {
    filterResetCheckbox('.project input:checkbox');
}
function fProjectReset() {
    jq('#srchTxt').val('');
}
function fBrandReset() {
    filterResetCheckbox('.brand input:checkbox');
}
function fPhaseReset() {
    filterResetCheckbox('.phase input:checkbox');
}
function fCompleteReset() {
    filterResetCheckbox('.complete input:checkbox');
}
function fCategoryReset() {
    filterResetCheckbox('.category input:checkbox');
}
function filterResetCheckbox(elmClass) {
    jq(elmClass).each(function() {
        jq(elmClass).prop('checked', false);
        jq(elmClass).next('label').removeClass('selected');
    });
}
function fProjectreset() {
    jq(".project input:checkbox").each(function() {
        jq(this).prop('checked', false);
        jq(this).next('label').removeClass('selected');
    });
    jq('input[id*=srchTxt]').val('');
    filteredProjectReset('');
}
/* Below code is to push the selected values */
function fProject() {
    var project = [];
    jq(".project input:checkbox:checked").each(function() {
        project.push(jq(this).val());
    });
    var pStr = project.toString();
    filteredProject(pStr);
}
function myAssignedTasks(taskId, isChecked) {
    if (isChecked != 'true') {
        jq('.taskCheck input[type=checkbox]#' + taskId).closest("tr").removeClass("selected");
    } else {
        jq('.taskCheck input[type=checkbox]#' + taskId).closest("tr").addClass("selected");
        jq('.taskCheck input[type=checkbox]#' + taskId).next().addClass("selected");
    }
    markComplete(taskId, isChecked);
}
function fBrand() {
    var brand = [];
    jq(".brand input:checkbox:checked").each(function() {
        brand.push(jq(this).val());
    });
    var pStr = brand.toString();
    filteredBrand(pStr);
}
function fCategory() {
    var category = [];
    jq(".category input:checkbox:checked").each(function() {
        category.push(jq(this).val());
    });
    var pStr = category.toString();
    filteredCategory(pStr);
}
function fPhase() {
    var phase = [];
    jq(".phase input:checkbox:checked").each(function() {
        phase.push(jq(this).val());
    });
    var pStr = phase.toString();
    filteredPhase(pStr);
}
function fComplete() {
    var complete = [];
    jq(".complete input:checkbox:checked").each(function() {
        complete.push(jq(this).val());
    });
    var pStr = complete.toString();
    filterComplete(pStr);
}
function fcompletereset() {
    jq(".complete input:checkbox").each(function() {
        jq(this).prop('checked', false);
        jq(this).next('label').removeClass('selected');
    });
    filterCompleteReset('');
}
function searchProjects() {
    var searchValue = document.getElementById("srchTxt").value;
    sProjects(searchValue);
}
/* Below code is to check the check boxes based on the selected values */
function setProjectFilter(bSearchTextBlank) {
    var selectedValues = IPMAppTD.projectName;
    var selectedValuesArr = selectedValues.split(',');
    jq('.projectFilter .dropdown-toggle .icoButton').removeClass('filter');
    jq('.projectFilter .dropdown-toggle .icoButton').addClass('filter-selected');
    if (selectedValuesArr != '' && selectedValuesArr.length != 0) {
        jq('.projectFilter .dropdown-menu input[type="checkbox"]').each(function() {
            var val = jq(this).attr('value');
            if (jq.inArray(val, selectedValuesArr) != -1) {
                jq(this).prop('checked', true);
                jq(this).next().addClass('selected');
            } else {
                jq(this).prop('checked', false);
            }
        });
    } else {
        if (bSearchTextBlank)
            jq('input[id*=srchTxt]').val('');
        jq('.projectFilter .dropdown-menu input[type="checkbox"]').each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
    }
}