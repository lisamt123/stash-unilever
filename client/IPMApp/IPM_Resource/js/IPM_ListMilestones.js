/********************************************************************************
 *@Description:This script used to create list milestone specific utility methods.
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
********************************************************************************/ 
var jq = jQuery.noConflict();
        function jsLoadM() {
            phaseFilterdrpdown();
            hidePhasefilter();
            completedFilter();
            hidecompletedFilter();
            /* Below script works on click. It is to hide the modal. Also it removes selected class from the checkbox */
            jq(document).on('hide.bs.modal', '#ipmModal', function() {
                jq('.ipmCheckbox input[type="checkbox"]:not(:checked)').closest("tr").removeClass("selected");
            });
            jq(document).on('click', '.dropdown-menu input[type="checkbox"], .dropdown-menu li', function(e) {
                e.stopPropagation();
            });
            
            /* Below script replace a text with a specific time format. */
            jq(".dueDate,.comDate").each(function() {
                jq(this).text(jq(this).text().replace('00:00:00 GMT', ''));
            });
             
            /* Below script hides the time line view */
            jq(".timeLineView").hide();
            
            /* Below script works on click event. It toggles between the timeline view and list view. Below will display as a timeline view. */
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
            
            /* Below script works on click event. It toggles between the timeline view and list view. Below will display as a list view. */
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
           
           /* Below function checks for a condition. If the condition is true it highlights the row by adding a different css class which adds a color. */
            function markCompl(mId, isChecked) {
                markCompleteM(mId, isChecked);
                if (isChecked !== 'true') {
                    jq('.taskCheck input[type=checkbox]#' + mId).closest("tr").removeClass("selected");
                } else {
                    jq('.taskCheck input[type=checkbox]#' + mId).closest("tr").addClass("selected");
                }
                timelineSetup();
            }
             /* Below script works on click event. It sorts the due date. */
            jq('#sortDueDate1').on('click', function() {
                toggleDueDate1();
            });
            
            /* Below script works on click event. It sorts the milestones. */
            jq('#sortMilestones').on('click', function() {
                toggleSortMilestones();
            });
            
            /* Below script works on click event. It sorts the phases. */
            jq('#sortPhases1').on('click', function() {
                toggleSortPhases1();
            });
            
            /* Below script works on click event. It sorts the completion. */
            jq('#sortCompletion1').on('click', function() {
                toggleSortCompletion1();
            });
            
            /* Below script works on click event. It sorts the completed on. */
            jq('#sortCompletedOn').on('click', function() {
                toggleSortCompletedOn();
            });
        }
        
        jsLoadM();
        var step = 1;
        var current = 0;
        var maximum = 0;
        var visible = 1;
        var speed = 500;
        var liSize = 250;
        var carousel_height = 210;
        
        /* Below script works on click event. This moves the carousel further and shows the next part of the time line view. */
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
        
        /* Below script works on click event. This moves the carousel backwards and shows the previous part of the time line view. */
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
        
        function phaseFilterdrpdown(){
            /* Below script works on click event for the phase filter. If the condition is true the options for the drop down list will be appended. */
            jq(document).on('show.bs.dropdown', '.phaseMFilter', function() {
                var icoButton = jq('.phaseMFilter .dropdown-toggle .icoButton');
                if (jq('.phaseMFilter ul.phaseM').length === 0) {
                    var dropDownList = jq('#phaseMFilterDiv').html();
                    jq(this).append(dropDownList);
                }
                var selectedValues = IPMAppLM.phaseM;
                var selectedValuesArr = selectedValues.split(',');
                icoButton.removeClass('filter');
                icoButton.addClass('filter-selected');
                /* Below script checks a condition for the phase filter. If the condition is true the checkbox will be checked. */
                if (selectedValuesArr.length !== 0) {
                    jq('.phaseMFilter .dropdown-menu input[type="checkbox"]').each(function() {
                        $this = jq(this);
                        var val = $this.attr('value');
                        if (jq.inArray(val, selectedValuesArr) !== -1) {
                            $this.prop('checked', true);
                            $this.next('label').addClass('selected');
                        } else {
                            $this.prop('checked', false);
                            $this.next('label').removeClass('selected');
                        }
                    });
                }
            });
        }
        
        function hidePhasefilter(){
           /* Below script works on click event for phase filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
            jq(document).on('hide.bs.dropdown', '.phaseMFilter', function() {
                var icoButton = jq('.phaseMFilter .dropdown-toggle .icoButton');
                var selectedValues = IPMAppLM.phaseM.trim();
                var selectedValuesArr = selectedValues.split(',');
                if (selectedValues.length === 0  || selectedValuesArr.length === 0) 
                {
                    icoButton.removeClass('filter-selected');
                    icoButton.addClass('filter');
                }
            });
        }
        
        function hidecompletedFilter(){
            /* Below script works on click event for completed filter. This is to hide the dropdown. If the condition is true css class is removed and another css class is added. */
            jq(document).on('hide.bs.dropdown', '.completedFilterM', function() {
                var icoButton = jq('.completedFilterM .dropdown-toggle .icoButton');
                var selectedValues = IPMAppLM.isCompleteMilestones.trim();
                var selectedValuesArr = selectedValues.split(',');
                if (selectedValues.length === 0 ||  selectedValuesArr.length === 0) {
                    icoButton.removeClass('filter-selected');
                    icoButton.addClass('filter');
                }
            });
        }
        
        function completedFilter(){
            /* Below script works on click event for completed filter. If the condition is true the checkboxes will be checked based on the back end values. */
            jq(document).on('show.bs.dropdown', '.completedFilterM', function() {
                var icoButton = jq('.completedFilterM .dropdown-toggle .icoButton');
                var selectedValues = IPMAppLM.isCompleteMilestones;
                var selectedValuesArr = selectedValues.split(',');
                icoButton.removeClass('filter');
                icoButton.addClass('filter-selected');
                if (selectedValuesArr.length !== 0) {
                    jq('.completedFilterM .dropdown-menu input[type="checkbox"]').each(function() {
                        $this = jq(this);
                        var val = $this.attr('value');
                        if (jq.inArray(val, selectedValuesArr) !== -1) {
                            $this.prop('checked', true);
                            $this.next('label').addClass('selected');
                        } else {
                            $this.prop('checked', false);
                            $this.next('label').removeClass('selected');
                        }
                    });
                }
            });
        }
        
        /* Below function performs a condition check. If the condition is true it appends a ul tag to an element. */
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
        /* Below function performs delete operation. When clicked on remove button it calls a function 'deleteMilestone' and hides the delete modal. */
        jq(document).on('click', '#ipmDeleteModal .removeMilestone', function() {
            var milestoneId = jq(this).attr('value');
            deleteMilestone(milestoneId);
            jq("#ipmDeleteModal").modal('hide');
        });
        /* Below function performs changes the modal title, modal body's content as per the condition. */
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
        /* Below function checks the checked checkboxes and pushes the value to a function. It is for phase filtering. */
        function fphaseM() {
            var phaseM = [];
            var pStrM;
            jq(".phaseM input:checkbox:checked").each(function() {
                phaseM.push(jq(this).val());
            });
            pStrM = phaseM.toString();
            filteredPhaseM(pStrM);
        }
        /* Below function checks the checked checkboxes and pushes the value to a function. It is for completed filtering. */
        function fCompleteM() {
            var completeM = [];
            var cStrM;
            jq(".completeM input:checkbox:checked").each(function() {
                completeM.push(jq(this).val());
            });
            cStrM = completeM.toString();
            filterCompleteM(cStrM);
        }
        /* Below function performs the reset functionality for phase. The recent changes made to the checkboxes will be reverted back. */
        function fPhaseMReset() {
            jq(".phaseM input:checkbox").each(function() {
                jq(this).prop('checked', false).next('label').removeClass('selected');
            });
            filteredPhaseM('');
        }
        /* Below function performs the reset functionality for completed. The recent changes made to the checkboxes will be reverted back. */
        function fCompleteResetM() {
            jq(".completeM input:checkbox").each(function() {
                jq(this).prop('checked', false);
            });
            filterCompleteM('');
        }