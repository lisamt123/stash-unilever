var jq=jQuery.noConflict();function ipmModal(el,title,width,height,margintop,zindex,cscls){var mTitle=jq("#ipmModal .modal-title");var domEl=jq("#ipmModal .modal-dialog");jq(document).on("click",el,function(e){e.preventDefault?e.preventDefault():e.returnValue=false;var url=jq(this).attr("value");openModal(url);mTitle.html(title);domEl.width(width);domEl.height(height);domEl.css({"margin-top":margintop,"z-index":zindex});domEl.addClass(cscls)});jq(document).on("keydown",el,function(){var keyCode=event.keyCode?event.keyCode:event.which;if(keyCode===13){jq(el).trigger("click")}})}function openModal(url){jq(document).find("#ipmModal").find(".modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "'+url+'"></iframe>')}function closeModal(){jq(document).on("click",".cancelButton",function(){var frame=parent.document.getElementById("ipmModal");jq(frame).find(".close").trigger("click")})}function openDeleteTaskModal(str,deleteMsg){jq("#ipmDeleteModal .modal-title").html("Remove To-do");jq("#ipmDeleteModal .confirmMsg").html(deleteMsg);jq("#ipmDeleteModal .confirmAction").attr("value",str);jq(".confirmAction").addClass("removeTask")}function deleteTaskJs(element){var taskId=jq(element).attr("value");DeleteTask(taskId);jq("#ipmDeleteModal").modal("hide")}jq.fn.preload=function(){this.each(function(){jq("<img/>")[0].src=this})};jq(document).ready(function(){jq(document).on("click",'.ipmCheckbox input[type="checkbox"]:not(:disabled)',function(){var chkInput=jq(this);if(chkInput.is(":checked")){chkInput.next("label").addClass("selected");chkInput.closest("tr").addClass("selected")}else{chkInput.next("label").removeClass("selected");chkInput.closest("tr").removeClass("selected")}})});