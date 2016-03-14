/*******************************************************************
 *@Description:This script is used for gate document character limit
 *@Author: Cognizant
 *@Created Date: 17/09/2015
******************************************************************/
/* Below script helps to display the remaining characters of the RTF field. */
jq(document).ready(function() {
    jq('[id$=form]').areYouSure({
        'silent': true
    });
    var strBrowser = "";
    var arrTextArea = [];
    var strTextAreaID = "";
    var strLabelName = "";
    var MaxLength = 0;
    if (jq("#dummyCount").length > 0) {
        strTextAreaID = "gate";
        strLabelName = "charCountRemaining";
        MaxLength = parseInt(jq("#dummyCount").text());
    } else if (jq("#secEditCount").length > 0) {
        strTextAreaID = "gate2";
        strLabelName = "lblCharCountGate2";
        MaxLength = parseInt(jq("#secEditCount").text());
    }
    var strFullText = "";
    var objTA;
    var objTextArea;
    if (navigator.userAgent.indexOf("Chrome") > -1) {
        strBrowser = "CHROME";
    }
    if (navigator.userAgent.indexOf("Trident") > -1) {
        strBrowser = "IE";
    }
	/* The below if's cannot be merged as it may break functionality. Also if we try to merge it with the nested one, there will be contradiction with the other sonar issue 'Reduce the number of conditional operators' */
    if (window.CKEDITOR) {
        var strFrameParent = jq(document).find('.secEditSummary').find("textarea").attr('name');
		if(strFrameParent != null){
			if (strFrameParent.indexOf(strTextAreaID) >= 0) {
				CKEDITOR.instances[strFrameParent].on("key", function(e) {
					var objTextArea = this.document.$.body;
					var strText = objTextArea.textContent.replace(/ *\<[^>]*\> */g, "");
					
					/* If we reduce the number of conditional operators it will contradict with the other sonar issue 'Merge this if statement with the nested one' */
					if ((e.data.domEvent.$.keyCode === 8) || (e.data.domEvent.$.keyCode === 46) || ((e.data.domEvent.$.shiftKey) 
						&& (e.data.domEvent.$.keyCode === 36)) || ((e.data.domEvent.$.shiftKey) && (e.data.domEvent.$.keyCode === 35)) 
					    || (e.data.domEvent.$.keyCode === 35) || (e.data.domEvent.$.keyCode === 36) || (e.data.domEvent.$.keyCode === 37) 
						|| (e.data.domEvent.$.keyCode === 38) || (e.data.domEvent.$.keyCode === 39) || (e.data.domEvent.$.keyCode === 40)) {
						showCharacterCount();
						e.cancelBubble = false;
						e.returnValue = true;
						return true;
					}
					if (strText.length === MaxLength) {
						e.cancelBubble = true;
						e.returnValue = false;
						e.cancel();
						e.stop();
						return false;
					} else {
						showCharacterCount();
						e.cancelBubble = false;
						e.returnValue = true;
						return true;
					}
				});
				CKEDITOR.instances[strFrameParent].on("instanceReady", function(ev) {
					// Set keyup event  
					jq("div.cke_inner").find("span.cke_toolbar").find("a").click(function() {
						var objTA = jq(document.activeElement).contents().find("html").find("body")[0];
					});
					this.document.on("keyup", function(event) {
						if (event.data.$.keyCode === 37 || event.data.$.keyCode === 39 || event.data.$.keyCode === 13) {
							return false;
						}
						if (event.data.$.keyCode === 8 || event.data.$.keyCode === 46) {
							showCharacterCount();
							return true;
						}
						showCharacterCount();
					});
					//paste event
					this.document.on("paste", function(event) {
						var strText;
						if (strBrowser === "IE") {
							strText = window.clipboardData.getData('Text');
						} else if (strBrowser === "CHROME") {
							strText = event.data.$.clipboardData.getData("text/plain");
						}
						var element = (this).$.body;					
						var strFullText = strText.length;
						if (strFullText > MaxLength) {
							if (strBrowser === "IE") {
								event.preventDefault ? event.preventDefault() : event.returnValue = false;
								window.clipboardData.clearData("Text");
								jq('#ipmDeleteModal').modal();
								jq('#ipmDeleteModal').find('.modal-title').html(IPMAppSE.CountTitle);
								jq('#ipmDeleteModal').find('.confirmMsg').html(IPMAppSE.CountMessage);
								jq('#ipmDeleteModal').find('.delTaskGatebtn').html("Ok");
								jq('#ipmDeleteModal').find('.green').hide();
								jq('#ipmDeleteModal .modal-body').css({
									"height": "120px",
									"margin-right": "15px"
								});
							} else if (strBrowser === "CHROME") {
								event.data.preventDefault();
								event.data.$.clipboardData.clearData();
								jq('#ipmDeleteModal').modal();
								jq('#ipmDeleteModal').find('.modal-title').html(IPMAppSE.CountTitle);
								jq('#ipmDeleteModal').find('.confirmMsg').html(IPMAppSE.CountMessage);
								jq('#ipmDeleteModal').find('.delTaskGatebtn').html("Ok");
								jq('#ipmDeleteModal').find('.green').hide();
								jq('#ipmDeleteModal .modal-body').css({
									"height": "120px",
									"margin-right": "15px"
								});
							}
						}
						setTimeout(function() {
							var text = element.innerHTML;
							var wrapper = document.createElement('div');
							wrapper.innerHTML = text;
							walk_the_DOM(wrapper, function(el) {
								if (el.removeAttribute) {
									el.removeAttribute('id');
									el.removeAttribute('class');
								}
							});
							element.innerHTML = wrapper.innerHTML;
							strText = wrapper.textContent || wrapper.innerText;
							showCharacterCount(strText);
						}, 100);
					});
				});           
			}
		}
    }
    var walk_the_DOM = function walk(node, func) {
        func(node);
        node = node.firstChild;
        while (node) {
            walk(node, func);
            node = node.nextSibling;
        }
    };
    /* Below function helps to display the characters remaining. If it exceeds the character limit it displays an error message. */
    function showCharacterCount(strText) {
        // below condition for copy paste and undo redo
        if (arguments.length > 0) {
            var rem = MaxLength - parseInt(strText.length);
            if (rem > 0) {
                jq("#" + strLabelName).text(rem.toString());
            } else {
                jq("#" + strLabelName).text("Maximum Limit of " + MaxLength.toString() + " reached.");
            }
            return true;
        }
        var strFrame = jq(document).find('.secEditSummary').find("textarea").attr('id');
        if (strFrame.indexOf(strTextAreaID) >= 0) {
            NewLineCount = 0;
            var objTextArea = jq(jq(document).find(".secEditSummary").find("iframe.cke_wysiwyg_frame")).contents().find("html").find("body")[0];
            strTextArea = objTextArea.textContent || objTextArea.innerText;
            var rem = MaxLength - parseInt(strTextArea.length);

            if (rem > 0) {
                jq("#" + strLabelName).show().text(rem.toString()).prev("span").text(IPMAppSE.charRemaining);
            } else {
                jq("#" + strLabelName).hide().prev("span").text(IPMAppSE.exLimitBtmMsg);
            }
        }
    }
});