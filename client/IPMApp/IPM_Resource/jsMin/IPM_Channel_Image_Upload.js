var jq=jQuery.noConflict();var unsaved=false;jq(document).ready(function(){var uploadImg=IPMAppCHIMG.imgLoad;if(uploadImg==="true"){var frame=parent.document.getElementById("ipmModal");jq(frame).find(".close").trigger("click");parent.location.assign(IPMAppCHIMG.SectionEditorPageRef+"?Id="+IPMAppCHIMG.projId+"&projDocSecId="+IPMAppCHIMG.proDocSecid)}});jq(function(){jq(".imgBrowse").change(function(){unsaved=true});var frame=parent.document.getElementById("ipmModal");jq(frame).find(".upimgModal .close").click(function(){if(unsaved){jq(this).removeAttr("data-dismiss");unloadImgIframe()}else{jq(this).attr("data-dismiss","modal")}})});function unloadPagebs(){if(unsaved){return IPMAppCHIMG.wmessage}}window.onbeforeunload=unloadPagebs;function unloadImgIframe(){parent.location.assign(IPMAppCHIMG.SectionEditorPageRef+"?Id="+IPMAppCHIMG.projId+"&projDocSecId="+IPMAppCHIMG.proDocSecid)}function skipVal(){unsaved=false}