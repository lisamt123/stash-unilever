var jq=jQuery.noConflict();jq(document).on("click",".uploadImage",function(e){e.preventDefault?e.preventDefault():e.returnValue=false;var url=jq(this).attr("value");jq("#ipmUploadImage .modal-title").html("Upload Image");jq("#ipmUploadImage .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "'+url+'"></iframe>');jq("#ipmUploadImage .modal-dialog").addClass("uploadImages")});jq(".imageBorder").hover(function(){jq(".imgHoverContainer").stop();jq(".imgHoverContainer").show(200)},function(){jq(".imgHoverContainer").stop();jq(".imgHoverContainer").hide(100)});jq(document).on("click",".imgDelButton",function(e){e.preventDefault?e.preventDefault():e.returnValue=false;jq("#deleteImgPop .modal-dialog").width("600px");jq("#deleteImgPop .modal-dialog").height("170px");jq("#deleteImgPop .modal-dialog").css({"margin-top":"10%","z-index":"999"})});function closeimagepopup(){window.location.reload(true)}function pagerefresh(){window.location.reload(true)}IPMAppEP.Closepopup=new function(){if(IPMAppEP.isSave===true){window.top.location.href=IPMAppEP.corePage+"?id="+IPMAppEP.projectId}};jq(document).ready(function(){var remaining=jq("#charCountRemaining");var total=jq("#charCountTotal");jq(".limitdesc").limiter(70,remaining,total)});jq(document).on("show.bs.dropdown",".brandposListContainer",function(){jq(this).find(".brandposList").show()});jq(document).click(function(e){if(e.target.id!=="brandposListUL"){jq(".brandposList").hide()}});jq(document).on("click",'.brandposList input[type="checkbox"], .brandposList li',function(e){e.stopPropagation()});jq(document).on("click",".filterActionscc .ipmDropresetcc",function(e){e.stopPropagation();jq(".brandposList input:checkbox").each(function(){jq(this).prop("checked",false);jq(this).next("label").removeClass("selected");jq(".brandSelValues").text(IPMAppEP.proSelectlabel)})});jq(".ipmDropbuttonscc").click(function(e){var brandPositionValue="";jq(".brandposList  input[type=checkbox]").each(function(e){if(jq(this).prop("checked")===true){if(brandPositionValue.length>0){brandPositionValue=brandPositionValue+","+jq(this).val()}else{brandPositionValue=jq(this).val()}}});jq(".hiddenBrand").val(brandPositionValue);if(brandPositionValue===""){jq(".brandSelValues").text(IPMAppEP.proSelectlabel)}else{jq(".brandSelValues").text(brandPositionValue)}jq(".brandposList").hide()});function invalidChar(key){var keycode=key.which?key.which:key.keyCode;if(keycode==95){return false}else{return true}}function closepopup(){if(IPMAppEP.prosuccess){window.top.location.href=IPMAppEP.corePage+"?id="+IPMAppEP.projectId}}jq(".ccCheck").change(function(e){if(jq(".brandposList input[type=checkbox]:checked").length>20){jq(this).prop("checked",false);jq(this).next("label").removeClass("selected")}});jq(".brandautocomplete").autocomplete({source:apexAccountList,select:function(event,ui){selectedObj=ui.item},minLength:1});jq(".gateKeepingModel input[type=radio]").each(function(e){jq(this).click(function(){var selectedGKModel=jq(this).attr("value");jq(".gateKModel").hide();jq(".gateKeepingModel").parents(".oprtnRadioContainer").children(".gateKModel").each(function(e){if(jq(this).attr("selectedValue")===selectedGKModel){jq(this).show()}})})});if(jq(".hiddenBrand")!==null&&jQuery.type(jq(".hiddenBrand"))!=="undefined"){var brandPicklist=jq(".hiddenBrand").val();if(jQuery.type(brandPicklist)!=="undefined"&&brandPicklist.length>0){jq(".brandSelValues").text(brandPicklist);var brandArray=brandPicklist.split(",");jq(".brandposList  input[type=checkbox]").each(function(e){var checkboxObj=jq(this);jq.each(brandArray,function(i,savedBrandPosition){if(checkboxObj.val()===savedBrandPosition){checkboxObj.prop("checked",true);return false}})})}}jq(".gateKeepingModel input[type=radio]").each(function(){var selectedGKModel=jq(".gateKeepingModel input[type=radio]:checked").attr("value");jq(".gateKeepingModel").parents(".oprtnRadioContainer").children(".gateKModel").each(function(e){if(jq(this).attr("selectedValue")===selectedGKModel){jq(this).show()}})});jq(".gcltquestions  input[type=radio]").each(function(e){jq(this).click(function(){var selectedSubProjectType=jq(this).attr("value");jq(".charterTipMsg").hide();jq(".gcltquestions").parents(".oprtnRadioContainer").children(".charterTipMsg").each(function(e){if(jq(this).attr("selectedValue")===selectedSubProjectType){jq(this).show()}})})});jq(".gcltquestions input[type=radio]").each(function(){var selectedSubProjectType=jq(".gcltquestions input[type=radio]:checked").attr("value");jq(".gcltquestions").parents(".oprtnRadioContainer").children(".charterTipMsg").each(function(e){if(jq(this).attr("selectedValue")===selectedSubProjectType){jq(this).show()}})});function checkTLDDate(){var newTLDValue=jq(".dateInputBox").val();if(newTLDValue!==tldOrignalValue){jq("#tldWarningDialog").modal("show");return false}return true}function revertTLDValue(){jq(".dateInputBox").val(tldOrignalValue)}function hideTldWarningDialog(){jq("#tldWarningDialog").modal("hide")}const tldOrignalValue=jq(".dateInputBox").prop("defaultValue");