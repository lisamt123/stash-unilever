/*  
*************************************************************************
*@Description:This script used to create application specific utility methods e.g. modal, custom form elements etc.
*@Author: Cognizant
*@Created Date: 28/05/2015 
*************************************************************************
*/
// To prevent conflict with prototype.js
var jq = jQuery.noConflict();

/* Below code is related to the modal */
function ipmModal(el, title, width, height, margintop, zindex) {
    var mTitle = jq('#ipmModal .modal-title');
    var domEl = jq('#ipmModal .modal-dialog');
    jq(document).on('click', el, function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        var url = jq(this).attr('value');
        openModal(url);
        mTitle.html(title);
        domEl.width(width);
        domEl.height(height);
        domEl.css({
            'margin-top': margintop,
            'z-index': zindex
        });
    });
    jq(document).on('keydown', el, function() {
        var keyCode = (event.keyCode ? event.keyCode : event.which);
        if (keyCode == 13) {
            jq(el).trigger('click');
        }
    });
}
/* Below code is related to open the modal */
function openModal(url) {
    jq(document).find('#ipmModal').find('.modal-body').html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
}

/* Below code is related to close the modal */
function closeModal() {
    jq(document).on('click', '.cancelButton', function() {
        var frame = parent.document.getElementById("ipmModal");
        jq(frame).find('.close').trigger('click');
    });
}

/* Below code is related to delete task modal */
function openDeleteTaskModal(str, deleteMsg) {
    jq('#ipmDeleteModal .modal-title').html("Remove To-do");
    jq('#ipmDeleteModal .confirmMsg').html(deleteMsg);
    jq('#ipmDeleteModal .confirmAction').attr('value', str);
    jq(".confirmAction").addClass("removeTask");
}

function deleteTaskJs(element) {
    var taskId = jq(element).attr('value');
    DeleteTask(taskId);
    jq("#ipmDeleteModal").modal('hide');
}

/* Below code is related jQuery plug-in created for Pre-load Image  */ 
jq.fn.preload = function() {
    this.each(function() {
        jq('<img/>')[0].src = this;
    });
};

/* Below code is used to select Table Row on click of checkbox.  */
jq(document).ready(function(){
	jq(document).on('click', '.ipmCheckbox input[type="checkbox"]:not(:disabled)', function() {
		var chkInput = jq(this);
		if (chkInput.is(':checked')) {
			chkInput.next('label').addClass('selected');
			chkInput.closest("tr").addClass("selected");
		} else {
			chkInput.next('label').removeClass('selected');
			chkInput.closest("tr").removeClass("selected");
		}
	});
});