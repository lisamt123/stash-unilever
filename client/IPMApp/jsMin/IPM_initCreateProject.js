var jq=jQuery.noConflict();jq(document).ready(function(){jq(document).on("click",".radioButton input[type=radio]",function(){var $this=jq(this);var radioId=jq(this).attr("id");var radioIcon=jq(".radioIcon");radioIcon.removeClass("projectbutton-blue");radioIcon.removeClass("bosscardbutton-blue");radioIcon.css("border-color","#999999");radioIcon.addClass("bosscardbutton-gray");radioIcon.addClass("projectbutton-gray");jq(".radioButton").find(".rlabel").css("font-weight","normal");jq(".radioButton").find("label").removeClass("selected");if($this.is(":checked")){$this.parent().prev().addClass(radioId+"-blue");$this.parent().prev(".radioIcon").css("border-color","#007CBA");$this.next("label").addClass("selected");$this.parent().next(".rlabel").css("font-weight","bold")}else{$this.parent().prev().removeClass(radioId+"-blue");$this.next("label").removeClass("selected");$this.next("label").next(".rlabel").css("font-weight","normal")}})});function closeModal(){jq(document).on("click",".cancelButton",function(){var frame=parent.document.getElementById("ipmModal");jq(frame).find(".close").trigger("click")})}function createPro(){if(jq("input[type='radio'].rbutton").is(":checked")){card_type=jq("input[type='radio'].rbutton:checked").val();if(card_type.indexOf("IPM_ProjectSetup")>0){Visualforce.remoting.Manager.invokeAction(IPMApp.RemoteActionCreatePro,function(result,event){if(event.status){if(event.result!==null){window.top.location.href=IPMApp.projectsrc+"?Pid="+event.result}else{alert(IPMApp.systemMsg)}}})}else{Visualforce.remoting.Manager.invokeAction(IPMApp.RemoteActionCreateBoss,function(result,event){if(event.status){if(event.result!==null){window.top.location.href=IPMApp.bosscardsrc+"?id="+event.result}else{alert(IPMApp.systemMsg)}}})}}}