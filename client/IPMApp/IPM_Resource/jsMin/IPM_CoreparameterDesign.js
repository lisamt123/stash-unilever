var jq=jQuery.noConflict();jq(document).ready(function(){if(IPMProAppCP.addtnlParameter==="true"){jq("#myCarousel").carousel(4)}if(window.location.search.indexOf("coreId=coreparameters")>-1){sliderCP(".slide-bar")}});function updateAdditional(){if(window.parent.location.href.indexOf("&BETOptions=1")>-1){window.parent.location.href=window.parent.location+"&BETOptions=1"}else{window.parent.location.href=window.parent.location}}function resetqone(){window.location.href=IPMProAppCP.projectUrl+"?Pid="+IPMProAppCP.projectName+"&question=qone&EditCoreParameter=edit"}function resetqtwo(){window.location.href=IPMProAppCP.projectUrl+"?Pid="+IPMProAppCP.projectName+"&question=qtwo&EditCoreParameter=edit"}function resetqthree(){window.location.href=IPMProAppCP.projectUrl+"?Pid="+IPMProAppCP.projectName+"&question=qthree&EditCoreParameter=edit"}function checkCoreParam(){if(IPMProAppCP.coreParameter==="true"){if(window.parent.location.href.indexOf("&BETOptions=1")>-1){window.parent.location.href=window.parent.location+"&BETOptions=1"}else{window.parent.location.href=window.parent.location}}}function checkTooltip(){jq(".info").tooltip({position:{my:"center top",at:"center bottom+10"}})}function sliderCP(el){jq(".selText").hide();var elm=jq("#myCarousel").find(".active").find(el);var str=elm.attr("id");if(jq("label").hasClass("fstchild active")){jq(".helpDesc").prepend('<div class="selText">'+IPMProAppCP.select+"</div>")}var s=str.match(/\d+$/)[0];var totalwidth=elm.width();var lblCount=elm.find("label").length;var lblWidth=totalwidth/lblCount;elm.find("label").css("width",lblWidth);setSlider(s)}function cpredirect(){window.parent.location.reload(true);jq(".info").tooltip({position:{my:"center top",at:"center bottom+10"}})}function invalidChar(key){var keycode=key.which?key.which:key.keyCode;if(keycode==95){return false}else{return true}}var unsaved=false;var OldBosscardNameVal="";var NewBosscardNameVal="";var oldInputval="";var newInputval="";jq(function(){OldBosscardNameVal=jq(".BosscardNameInputBox ").val();jq(":input").change(function(){unsaved=true})});function changeAlertBosscardName(){CurrentBosscardNameVal=jq(".BosscardNameInputBox ").val();jq(":input").change(function(){unsaved=true});if(OldBosscardNameVal!==CurrentBosscardNameVal){unsaved=true}else if(unsaved){unloadPage()}else{unsaved=false;OldBosscardNameVal=CurrentBosscardNameVal}}function changeAlert(){unsaved=true}function unloadPage(){if(unsaved){return IPMAppPS.wmessage}}if(window.parent.location.href.indexOf("Milestoneid")>-1){}else{window.onbeforeunload=unloadPage}function skipValidation(){unsaved=false}