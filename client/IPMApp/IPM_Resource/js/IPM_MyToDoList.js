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

        jq(document).on('click', '.dropdown-menu input[type="checkbox"], .dropdown-menu li', function(e) {
            e.stopPropagation();
        });
        
        /* Below script works on click event. If the checkboxes are checked a css class will be added to the checkbox and to the table row. */
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
        /* Below script works on click event. It sorts the phases. */
        jq(document).on('click', '#sortPhases', function() {
            toggleSortPhases();
        });
        
        /* Below script works on click event. It sorts the tasks. */
        jq(document).on('click', '#sortTasks', function() {
            toggleSortTasks();
        });
        
        /* Below script works on click event. It sorts the sections. */
        jq(document).on('click', '#sortSections', function() {
            toggleSortSections();
        });
        
        /* Below script works on click event. It sorts the due date. */
        jq(document).on('click', '#sortDueDate', function() {
            jq('.ipmTable td.dueDateCol').css('background', '#DDEEF5');
            toggleDueDate();
        });
        
        /* Below script works on keypress. When user presses enter key a search function is called */
        jq('#srchTxt').keypress(function(e) {
            if (e.which === 13) {
                sProjects(srchTxt.value);
                return false;
            }
        });
        completedFilterdrpdown();
        hideCompletedfilter();
        projectFilterdrpdown();
        brandFilterdrpdown();
        hideBrandfilter();
        categoryFilterdrpdown();
        hideCategoryfilter();
        phaseFilterdrpdown();
        hidePhasefilter();
        /* Below script works on click event for project filter. It calls another function 'setProjectFilter'. */
        jq(document).on('show.bs.dropdown', '.projectFilter', function() {
            setProjectFilter(true);
        });
    }
    function hidePhasefilter(){
        /* Below script works on click event for phase filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
        jq(document).on('hide.bs.dropdown', '.phaseFilter', function() {
            var icoButton = jq('.phaseFilter .dropdown-toggle .icoButton');
            var selectedValues = IPMAppTD.phase.trim();
            var selectedValuesArr = selectedValues.split(',');
            if (selectedValues === ''  || selectedValuesArr === '') 
            {
                icoButton.removeClass('filter-selected');
                icoButton.addClass('filter');
            }
        });
    }
    function completedFilterdrpdown(){
        /* Below script works on click event for completed filter. If the condition is true the checkboxes will be checked based on the back end values. */
        jq(document).on('show.bs.dropdown', '.completedFilter', function() {
            var selectedValues = IPMAppTD.isCompleteTasks;
            var selectedValuesArr = selectedValues.split(',');
            jq('.completedFilter .dropdown-toggle .icoButton').removeClass('filter');
            jq('.completedFilter .dropdown-toggle .icoButton').addClass('filter-selected');
            jq('.completedFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
            if (selectedValuesArr !== '' && selectedValuesArr.length !== 0) {
                jq('.completedFilter .dropdown-menu input[type="checkbox"]').each(function() {
                    var val = jq(this).attr('value');
                    if (jq.inArray(val, selectedValuesArr) !== -1) {
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
    }
    
    function hideCompletedfilter(){
        /* Below script works on click event for completed filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
        jq(document).on('hide.bs.dropdown', '.completedFilter', function() {
            var icoButton = jq('.completedFilter .dropdown-toggle .icoButton');
            var selectedValues = IPMAppTD.isCompleteTasks.trim();
            var selectedValuesArr = selectedValues.split(',');
            if (selectedValues === ''  || selectedValuesArr === '') 
            {
                icoButton.removeClass('filter-selected');
                icoButton.addClass('filter');
            }
        });
    }
    function projectFilterdrpdown(){
        /* Below script works on click event for project filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
        jq(document).on('hide.bs.dropdown', '.projectFilter', function() {
            jq('input[id*=srchTxt]').val('');
            
            var icoButton = jq('.projectFilter .dropdown-toggle .icoButton');
            var selectedValues = IPMAppTD.projectName.trim();
            var selectedValuesArr = selectedValues.split(',');
            if (selectedValues === ''  || selectedValuesArr === '') 
            {
                icoButton.removeClass('filter-selected');
                icoButton.addClass('filter');
            }
            filteredProjectReset('');
        });
    }
    function brandFilterdrpdown(){
        /* Below script works on click event for brand filter. If the condition is true the checkboxes will be checked based on the back end values. */
        jq(document).on('show.bs.dropdown', '.brandFilter', function() {
            var selectedValues = IPMAppTD.brandName;
            var selectedValuesArr = selectedValues.split(',');
            jq('.brandFilter .dropdown-toggle .icoButton').removeClass('filter');
            jq('.brandFilter .dropdown-toggle .icoButton').addClass('filter-selected');
            jq('.brandFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
            if (selectedValuesArr !== '' && selectedValuesArr.length !== 0) {
                jq('.brandFilter .dropdown-menu input[type="checkbox"]').each(function() {
                    var val = jq(this).attr('value');
                    if (jq.inArray(val, selectedValuesArr) !== -1) {
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
    }
    function hideBrandfilter(){
        /* Below script works on click event for brand filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
        jq(document).on('hide.bs.dropdown', '.brandFilter', function() {
            var icoButton = jq('.brandFilter .dropdown-toggle .icoButton');
            var selectedValues = IPMAppTD.brandName.trim();
            var selectedValuesArr = selectedValues.split(',');
            if (selectedValues === ''  || selectedValuesArr === '') 
            {
                icoButton.removeClass('filter-selected');
                icoButton.addClass('filter');
            }
        });
    }
    function categoryFilterdrpdown(){
        /* Below script works on click event for category filter. If the condition is true the checkboxes will be checked based on the back end values. */
        jq(document).on('show.bs.dropdown', '.categoryFilter', function() {
            var selectedValues = IPMAppTD.categoryName;
            var selectedValuesArr = selectedValues.split(',');
            jq('.categoryFilter .dropdown-toggle .icoButton').removeClass('filter');
            jq('.categoryFilter .dropdown-toggle .icoButton').addClass('filter-selected');
            jq('.categoryFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
            if (selectedValuesArr !== '' && selectedValuesArr.length !== 0) {
                jq('.categoryFilter .dropdown-menu input[type="checkbox"]').each(function() {
                    var val = jq(this).attr('value');
                    if (jq.inArray(val, selectedValuesArr) !== -1) {
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
    }
    function hideCategoryfilter(){
        /* Below script works on click event for category filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
        jq(document).on('hide.bs.dropdown', '.categoryFilter', function() {
            var icoButton = jq('.categoryFilter .dropdown-toggle .icoButton');
            var selectedValues = IPMAppTD.categoryName.trim();
            var selectedValuesArr = selectedValues.split(',');
            if (selectedValues === ''  || selectedValuesArr === '') 
            {
                icoButton.removeClass('filter-selected');
                icoButton.addClass('filter');
            }
        });
    }
    function phaseFilterdrpdown(){
        /* Below script works on click event for phase filter. If the condition is true the checkboxes will be checked based on the back end values. */
        jq(document).on('show.bs.dropdown', '.phaseFilter', function() {
            var selectedValues = IPMAppTD.phase;
            var selectedValuesArr = selectedValues.split(',');
            jq('.phaseFilter .dropdown-toggle .icoButton').removeClass('filter');
            jq('.phaseFilter .dropdown-toggle .icoButton').addClass('filter-selected');
            jq('.phaseFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
            if (selectedValuesArr !== '' && selectedValuesArr.length !== 0) {
                jq('.phaseFilter .dropdown-menu input[type="checkbox"]').each(function() {
                    var val = jq(this).attr('value');
                    if (jq.inArray(val, selectedValuesArr) !== -1) {
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
    /* Below function performs the reset functionality for project by calling another function. */
    function fProjectReset() {
        filterResetCheckbox('.project input:checkbox');
    }
    function fProjectReset() {
        jq('#srchTxt').val('');
    }
    
    /* Below function performs the reset functionality for brand by calling another function. */
    function fBrandReset() {
        filterResetCheckbox('.brand input:checkbox');
    }
    
    /* Below function performs the reset functionality for phase by calling another function. */
    function fPhaseReset() {
        filterResetCheckbox('.phase input:checkbox');
    }
    
    /* Below function performs the reset functionality for completed by calling another function. */
    function fCompleteReset() {
        filterResetCheckbox('.complete input:checkbox');
    }
    
    /* Below function performs the reset functionality for category by calling another function. */
    function fCategoryReset() {
        filterResetCheckbox('.category input:checkbox');
    }
    
    /* Below function performs the reset functionality for phase. The recent changes made to the checkboxes will be reverted back. */
    function filterResetCheckbox(elmClass) {
        jq(elmClass).each(function() {
            jq(elmClass).prop('checked', false);
            jq(elmClass).next('label').removeClass('selected');
        });
    }
    
    /* Below function performs the reset functionality for phase. The recent changes made to the checkboxes will be reverted back. */
    function fProjectreset() {
        jq(".project input:checkbox").each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
        jq('input[id*=srchTxt]').val('');
        filteredProjectReset('');
    }
    /* Below function checks the checked checkboxes and pushes the value to a function. It is for completed filtering. */
    function fProject() {
        var project = [];
        jq(".project input:checkbox:checked").each(function() {
            project.push(jq(this).val());
        });
        var pStr = project.toString();
        filteredProject(pStr);
    }
    
    /* Below function checks for a condition. If the condition is true it highlights the row by adding a different css class which adds a color. */
    function myAssignedTasks(taskId, isChecked) {
        if (isChecked !== 'true') {
            jq('.taskCheck input[type=checkbox]#' + taskId).closest("tr").removeClass("selected");
        } else {
            jq('.taskCheck input[type=checkbox]#' + taskId).closest("tr").addClass("selected");
            jq('.taskCheck input[type=checkbox]#' + taskId).next().addClass("selected");
        }
        markComplete(taskId, isChecked);
    }
    
    /* Below function checks the checked checkboxes and pushes the value to a function. It is for brand filtering. */
    function fBrand() {
        var brand = [];
        jq(".brand input:checkbox:checked").each(function() {
            brand.push(jq(this).val());
        });
        var pStr = brand.toString();
        filteredBrand(pStr);
    }
    
    /* Below function checks the checked checkboxes and pushes the value to a function. It is for category filtering. */
    function fCategory() {
        var category = [];
        jq(".category input:checkbox:checked").each(function() {
            category.push(jq(this).val());
        });
        var pStr = category.toString();
        filteredCategory(pStr);
    }
    /* Below function checks the checked checkboxes and pushes the value to a function. It is for phase filtering. */
    function fPhase() {
        var phase = [];
        jq(".phase input:checkbox:checked").each(function() {
            phase.push(jq(this).val());
        });
        var pStr = phase.toString();
        filteredPhase(pStr);
    }
    /* Below function checks the checked checkboxes and pushes the value to a function. It is for completed filtering. */
    function fComplete() {
        var complete = [];
        jq(".complete input:checkbox:checked").each(function() {
            complete.push(jq(this).val());
        });
        var pStr = complete.toString();
        filterComplete(pStr);
    }
    /* Below function performs the reset functionality for complete. The recent changes made to the checkboxes will be reverted back. */
    function fcompletereset() {
        jq(".complete input:checkbox").each(function() {
            jq(this).prop('checked', false);
            jq(this).next('label').removeClass('selected');
        });
        filterCompleteReset('');
    }
    /* Below function pushes the value to a function. It is for searching projects. */
    function searchProjects() {
        var searchValue = document.getElementById("srchTxt").value;
        sProjects(searchValue);
    }
     /* Below function checks for the checkbox value. If the condition is true the checkboxes will be checked based on the back end values. */
    function setProjectFilter(bSearchTextBlank) {
        var selectedValues = IPMAppTD.projectName;
        var selectedValuesArr = selectedValues.split(',');
        jq('.projectFilter .dropdown-toggle .icoButton').removeClass('filter');
        jq('.projectFilter .dropdown-toggle .icoButton').addClass('filter-selected');
        if (selectedValuesArr !== '' && selectedValuesArr.length !== 0) {
            jq('.projectFilter .dropdown-menu input[type="checkbox"]').each(function() {
                var val = jq(this).attr('value');
                if (jq.inArray(val, selectedValuesArr) !== -1) {
                    jq(this).prop('checked', true);
                    jq(this).next().addClass('selected');
                } else {
                    jq(this).prop('checked', false);
                }
            });
        } else {
            if (bSearchTextBlank){
                jq('input[id*=srchTxt]').val('');
            }
            jq('.projectFilter .dropdown-menu input[type="checkbox"]').each(function() {
                jq(this).prop('checked', false);
                jq(this).next('label').removeClass('selected');
            });
        }
    }