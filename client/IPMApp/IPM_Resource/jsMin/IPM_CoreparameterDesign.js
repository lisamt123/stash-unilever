var jq=jQuery.noConflict();jq(document).ready(function(){if(IPMProAppCP.addtnlParameter==="true"){jq("#myCarousel").carousel(4)}if(window.location.search.indexOf("coreId=coreparameters")>-1){sliderCP(".slide-bar")}});function updateAdditional(){if(window.parent.location.href.indexOf("&BETOptions=1")>-1){window.parent.location.reload()}else{window.parent.location.reload()}}function mpaskip(){window.parent.location.reload()}function resetqone(){window.location.href=IPMProAppCP.projectUrl+"?Pid="+IPMProAppCP.projectName+"&question=qone&EditCoreParameter=edit"}function resetqtwo(){window.location.href=IPMProAppCP.projectUrl+"?Pid="+IPMProAppCP.projectName+"&question=qtwo&EditCoreParameter=edit"}function resetqthree(){window.location.href=IPMProAppCP.projectUrl+"?Pid="+IPMProAppCP.projectName+"&question=qthree&EditCoreParameter=edit"}function checkCoreParam(){if(IPMProAppCP.coreParameter==="true"){if(window.parent.location.href.indexOf("&BETOptions=1")>-1){window.parent.location.reload()}else{window.parent.location.reload()}}}function checkTooltip(){jq(".info").tooltip({position:{my:"center top",at:"center bottom+10"}})}function sliderCP(el){jq(".selText").hide();var elm=jq("#myCarousel").find(".active").find(el);var str=elm.attr("id");if(jq("label").hasClass("fstchild active")){jq(".helpDesc").prepend('<div class="selText">'+IPMProAppCP.select+"</div>")}var s=str.match(/\d+$/)[0];var totalwidth=elm.width();var lblCount=elm.find("label").length;var lblWidth=totalwidth/lblCount;elm.find("label").css("width",lblWidth);setSlider(s)}function cpredirect(){window.parent.location.reload(true);jq(".info").tooltip({position:{my:"center top",at:"center bottom+10"}})}function invalidChar(key){var keycode=key.which?key.which:key.keyCode;if(keycode===95){return false}else{return true}}var cppageunsaved=false;var OldBosscardNameVal="";var NewBosscardNameVal="";var oldInputval="";var newInputval="";jq(function(){OldBosscardNameVal=jq(".BosscardNameInputBox ").val();jq(":input").change(function(){if(jq(this).attr("id")==="full"||jq(this).attr("id")==="lite"||jq(this).attr("id")==="displayTasksChkBox"){cppageunsaved=false}else{cppageunsaved=true}})});function changeAlertBosscardName(){CurrentBosscardNameVal=jq(".BosscardNameInputBox ").val();jq(":input").change(function(){cppageunsaved=true});if(OldBosscardNameVal!==CurrentBosscardNameVal){cppageunsaved=true}else if(cppageunsaved){unloadPage()}else{cppageunsaved=false;OldBosscardNameVal=CurrentBosscardNameVal}}function changeAlert(){cppageunsaved=true}function unloadPage(){if(cppageunsaved){return IPMAppPS.wmessage}}if(window.parent.location.href.indexOf("Milestoneid")===-1){window.onbeforeunload=unloadPage}function skipValidation(){cppageunsaved=false}