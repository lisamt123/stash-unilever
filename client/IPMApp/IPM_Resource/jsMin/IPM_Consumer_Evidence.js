var jq=jQuery.noConflict();function imageloadstatus(){jq(".uploadImage").hover(function(){jq(this).find(".updateDeletimg").toggle("slide",{direction:"left"},100)})}function delCountry(country,secId){deleteSelCountry(country,secId)}function addCon(country,secId){addNew(country,secId)}function delConceptImage(secConId,country){deleteImg(secConId,country)}function delConcept(country,secId,secConId,priority){deleteSelConcept(country,secId,secConId,priority)}function fchannelM(){var conName;var channelM;channelM=[];jq(".channelList").hide();jq(".channelList input:checkbox:checked").each(function(){channelM.push(jq(this).val())});conName=channelM.toString();createConcepts(conName)}function fchannelReset(e){jq(".channelList").hide();jq(".channelList input:checkbox").each(function(){jq(this).prop("checked",false);jq(this).next("label").removeClass("selected")});createConcepts("")}function deleteconcept(str1,str2,str3,str4){jq("#ipmConceptModalDelete").modal({show:true,keyboard:false,backdrop:"static"});var title=jq(".deleteConcept").attr("title");jq("#ipmConceptModalDelete .modal-title").html(title);jq("#ipmConceptModalDelete .confirmConcept").attr("data-result1",str1);jq("#ipmConceptModalDelete .confirmConcept").attr("data-result2",str2);jq("#ipmConceptModalDelete .confirmConcept").attr("data-result3",str3);jq("#ipmConceptModalDelete .confirmConcept").attr("data-result4",str4);jq("#ipmConceptModalDelete .modal-dialog").width("600px");jq("#ipmConceptModalDelete .modal-dialog").height("170px");jq("#ipmConceptModalDelete .modal-dialog").css({"margin-top":"10%","z-index":"999"});jq(".confirmConcept").addClass("removeConcept")}function deleteCountry(str1,str2){jq("#ipmCountryModalDelete").modal({show:true,keyboard:false,backdrop:"static"});var title=jq(".deleteCountry").attr("title");jq("#ipmCountryModalDelete .modal-title").html(title);jq("#ipmCountryModalDelete .confirmCountry").attr("data-result1",str1);jq("#ipmCountryModalDelete .confirmCountry").attr("data-result2",str2);jq("#ipmCountryModalDelete .modal-dialog").width("600px");jq("#ipmCountryModalDelete .modal-dialog").height("170px");jq("#ipmCountryModalDelete .modal-dialog").css({"margin-top":"10%","z-index":"999"});jq(".confirmCountry").addClass("removeCountry")}function selectCheckboxScript(elem1,elem2){imageloadstatus();jq(document).on("show.bs.dropdown",".consumerDropdown",function(){jq(".channelList").show();var selectedValues=IPMAppCE.countryName;var selectedValuesArr=selectedValues.split(",");if(selectedValuesArr.length!==0){jq('.consumerDropdown .dropdown-menu input[type="checkbox"]').each(function(){var val=jq(this).attr("value");if(jq.inArray(val,selectedValuesArr)!==-1){jq(this).prop("checked",true);jq(this).prop("disabled",true);jq(this).next("label").addClass("selected")}else{jq(this).prop("checked",false);jq(this).next("label").removeClass("selected");jq(this).prop("disabled",false)}})}});jq(document).on("click","#ipmCountryModalDelete .removeCountry",function(){var questionId1=jq(this).attr("data-result1");var questionId2=jq(this).attr("data-result2");delCountry(questionId1,questionId2);jq("#ipmCountryModalDelete").modal("hide")});jq("#customerChannels input[type=checkbox]").each(function(){var val=jq(this).attr("value");if(val==="true"){jq(this).prop("checked",true)}else{jq(this).prop("checked",false)}});if(elem2!=="addNew"&&elem2!=="delImage"&&elem2!=="delConcept"||elem2==="blank"){jq(".ipmAcrdnExpand").hide();jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(":empty").show();jq(document).on("click",".evidenceHead span.expico, .evidenceHead span.expico-square",function(){if(jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").is(":visible")&&jq(elem).closest(".cevidenceborder").find(".ipmAcrdnExpand").not(":empty")){jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideUp("fast")}else{jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideDown("fast")}});jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-minus");jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-plus");jq(".ipmAccordion").find(".evidenceHead:first span.expico").removeClass("fa-plus");jq(".ipmAccordion").find(".evidenceHead:first span.expico").addClass("fa-minus")}else{jq(document).on("click",".evidenceHead span.expico, .evidenceHead span.expico-square",function(){if(jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").is(":visible")&&jq(elem).closest(".cevidenceborder").find(".ipmAcrdnExpand").not(":empty")){jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideUp("fast")}else{jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideDown("fast")}});jq(".ipmAcrdnExpand").each(function(){if(jq(this).hasClass(elem1)){jq(this).show()}});jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-minus");jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-plus");jq(".cevidenceborder").each(function(){if(jq(this).find(".evidenceHead").hasClass(elem1)){jq(this).find(".evidenceHead span.expico").removeClass("fa-plus");jq(this).find(".evidenceHead span.expico").addClass("fa-minus")}})}}function getParameterByName(name,url){if(!url){url=window.location.href;name=name.replace(/[\[\]]/g,"\\$&");var regex=new RegExp("[?&]"+name+"(=([^&#]*)|&|#|$)"),results=regex.exec(url)}if(!results){return null}if(!results[2]){return""}return decodeURIComponent(results[2].replace(/\+/g," "))}jq(document).on("click",".filterActionscc .ipmDropresetcc",function(e){e.stopPropagation();var selectedValues=IPMAppCE.countryName;jq(".channelList input:checkbox").each(function(){if(selectedValues.indexOf(jq(this).val())===-1){jq(this).prop("checked",false);jq(this).next("label").removeClass("selected")}else{jq(this).prop("checked",true);jq(this).next("label").addClass("selected")}})});jq(document).on("click","#ipmConceptModalDelete .removeConcept",function(){var questionId1=jq(this).attr("data-result1");var questionId2=jq(this).attr("data-result2");var questionId3=jq(this).attr("data-result3");var questionId4=jq(this).attr("data-result4");delConcept(questionId1,questionId2,questionId3,questionId4);jq("#ipmConceptModalDelete").modal("hide")});jq(document).ready(function(){selectCheckboxScript();jq(document).on("click",'.ccChannelList input[type="checkbox"], .ccChannelList li,.filterActionscc',function(e){e.stopPropagation()});jq(document).on("click",".evidenceHead span.expico, .evidenceHead span.expico-square",function(){if(jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").is(":visible")&&jq(elem).closest(".cevidenceborder").find(".ipmAcrdnExpand").not(":empty")){jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideUp("fast")}else{jq(this).closest(".cevidenceborder").find(".ipmAcrdnExpand").slideDown("fast")}});var cntrys=getParameterByName("urlCountry");jq(".ipmAcrdnExpand").hide();var i=0;jq(".ipmAcrdnExpand").each(function(){if(jq(this).hasClass(cntrys)){jq(this).show();i=1}});if(i===0){jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(":empty").show()}jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-minus");jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-plus");j=0;jq(".cevidenceborder").each(function(){if(jq(this).find(".evidenceHead").hasClass(cntrys)){jq(this).find(".evidenceHead span.expico").removeClass("fa-plus");jq(this).find(".evidenceHead span.expico").addClass("fa-minus");j=1}});if(j===0){jq(".ipmAccordion").find(".evidenceHead span.expico").removeClass("fa-minus");jq(".ipmAccordion").find(".evidenceHead span.expico").addClass("fa-plus");jq(".ipmAccordion").find(".evidenceHead:first span.expico").removeClass("fa-plus");jq(".ipmAccordion").find(".evidenceHead:first span.expico").addClass("fa-minus")}jq(document).click(function(e){if(e.target.className!=="cecList"){jq(".channelList").hide()}})});