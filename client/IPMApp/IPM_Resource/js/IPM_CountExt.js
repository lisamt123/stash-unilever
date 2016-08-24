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
    var countSpacesAsChars = false;
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
        if(strFrameParent !== null && strFrameParent !== undefined){
            if (strFrameParent.indexOf(strTextAreaID) >= 0) {
                // RTF On Key Event Handler
                // ckeditor key for keyup is "key"
                CKEDITOR.instances[strFrameParent].on("key", function(event) {
                    event = event || window.event;
                    objTextArea = this.document.$.body;
                    if(event.data.domEvent.$.keyCode !==17 && event.data.domEvent.$.keyCode !== 86){
                        return editorCount(objTextArea, event);
                    }
                });
                CKEDITOR.instances[strFrameParent].on("paste", function(event) {
                        var strText;
                        event = event || window.event;
                        if (strBrowser === "IE") {
                            strText = window.clipboardData.getData('Text');
                            if (!countSpacesAsChars) {
                                var normalizedText = strText.replace(/\s/g, "").replace(/&nbsp;/g, "");
                            }
                            strText = normalizedText.replace(/(\r\n|\n|\r)/gm, "").replace(/&nbsp;/gi, " ");         
                            //Strip Html tags
                            strText = normalizedText.replace(/(<([^>]+)>)/ig,"").replace(/^([\t\r\n]*)$/, "");
                        } else if (strBrowser === "CHROME") {
                            var selectedText;                  
                            if (document.getSelection){ // all modern browsers and IE9+
                                selectedText = document.getSelection().toString();
                                var selCount = selectedText.length;
                            }
                            if (!countSpacesAsChars) {
                                normalizedText = selectedText.replace(/\s/g, "").replace(/&nbsp;/g, "");
                            }
                            strText = normalizedText.replace(/(\r\n|\n|\r)/gm, "").replace(/&nbsp;/gi, " ");         
                            //Strip Html tags
                            strText = normalizedText.replace(/(<([^>]+)>)/ig,"").replace(/^([\t\r\n]*)$/, "");
                        }
                        var strText1;
                        var element = this.document.$.body;
                        var objTextareaText = element.innerText;
                        if (!countSpacesAsChars) {
                            var normalizedText1 = objTextareaText.replace(/\s/g, "").replace(/&nbsp;/g, "");
                        }
                        strText1 = normalizedText1.replace(/(\r\n|\n|\r)/gm, "").replace(/&nbsp;/gi, " ");         
                        //Strip Html tags
                        strText1 = normalizedText1.replace(/(<([^>]+)>)/ig,"").replace(/^([\t\r\n]*)$/, "");       
                        strFullText = strText1.length;
                        var elCount2 = strText.length;
                        strFullText = strFullText + elCount2;
                        if (strFullText >= MaxLength) {
                            if (strBrowser === "IE") {                               
                                jq('#ipmDeleteModal').modal();
                                jq('#ipmDeleteModal').find('.modal-title').html(IPMAppSE.CountTitle);
                                jq('#ipmDeleteModal').find('.confirmMsg').html(IPMAppSE.CountMessage);
                                jq('#ipmDeleteModal').find('.delTaskGatebtn').html("Ok");
                                jq('#ipmDeleteModal').find('.green').hide();
                                jq('#ipmDeleteModal .modal-body').css({
                                    "height": "120px",
                                    "margin-right": "15px"
                                });
                                window.clipboardData.clearData("Text");
                                 event.preventDefault();
                            } else if (strBrowser === "CHROME") {
                                jq('#ipmDeleteModal').modal();
                                jq('#ipmDeleteModal').find('.modal-title').html(IPMAppSE.CountTitle);
                                jq('#ipmDeleteModal').find('.confirmMsg').html(IPMAppSE.CountMessage);
                                jq('#ipmDeleteModal').find('.delTaskGatebtn').html("Ok");
                                jq('#ipmDeleteModal').find('.green').hide();
                                jq('#ipmDeleteModal .modal-body').css({
                                    "height": "120px",
                                    "margin-right": "15px"
                                });
                                 event.preventDefault();
                            }
                        }
                    setTimeout(function() {
                        showCharacterCount();
                    }, 100);
                });                
                var editorCount = function(objTextArea, e){
                    var objTextareaText = objTextArea.innerText;
                    var normalizedText = objTextareaText;
                    if (!countSpacesAsChars) {
                        normalizedText = objTextareaText.replace(/\s/g, "").replace(/&nbsp;/g, "");
                    }
                    strText = normalizedText.replace(/(\r\n|\n|\r)/gm, "").replace(/&nbsp;/gi, " ");         
                    //Strip Html tags
                    strText = normalizedText.replace(/(<([^>]+)>)/ig,"").replace(/^([\t\r\n]*)$/, "");
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
                    // Reaches Max Length - Shows error MAX_VALUE Reached Error Msg.
                    if (strText.length >= MaxLength) {
                        showCharacterCount();
                        e.cancelBubble = true;
                        e.returnValue = false;
                        e.cancel();
                        e.stop();
                        return false;
                    } else {
                        showCharacterCount(strText);
                        e.cancelBubble = false;
                        e.returnValue = true;
                        return true;
                    }
                }                
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
                });       
            }
        }
    }
    var walk_the_DOM = function (node, func) {
        func(node);
        node = node.firstChild;
        while (node) {
            walk_the_DOM(node, func);
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
            // New set of code start
            var objTextareaText = objTextArea.innerText;
            var normalizedText = objTextareaText;
            if (!countSpacesAsChars) {
                normalizedText = objTextareaText.replace(/\s/g, "").replace(/&nbsp;/g, "");
            }
            normalizedText = normalizedText.replace(/(\r\n|\n|\r)/gm, "").replace(/&nbsp;/gi, " ");         
            //Strip Html tags
            normalizedText = normalizedText.replace(/(<([^>]+)>)/ig,"").replace(/^([\t\r\n]*)$/, "");
            // New set of code end
            strTextArea = normalizedText;  
            var rem = MaxLength - parseInt(strTextArea.length);
            if (rem > 0) {
                jq("#" + strLabelName).show().text(rem.toString()).prev("span").text(IPMAppSE.charRemaining);
            } else {
                jq("#" + strLabelName).hide().prev("span").text(IPMAppSE.exLimitBtmMsg);
            }
        }
    }
});
function storeCount(e){
    if(e === 'true'){
        var chkCount = jq('.charCountRemaining').text();    
    }
    else{
        var chkCount = jq('#lblCharCountGate2').text();    
    }
    refreshpage('Gate',chkCount);
}
function storeCountoutcomesave(){
    var chkCount = jq('.charCountRemaining').text();
    refreshoutcomesave('',chkCount);
}
function storeCountoutcomesavenotify(e){
    if(e === 'true'){
        var chkCount = jq('.charCountRemaining').text();    
    }
    else{
        var chkCount = jq('#lblCharCountGate2').text();    
    }
    refreshoutcomesavenotify('','Checked',chkCount);
}