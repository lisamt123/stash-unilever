	function changeValue(input, textid){
        document.getElementById(textid).value = input.value;        
    }
    function RefreshPrimaryTab(isTransferSuccess) {
        if (isTransferSuccess) {
            if(window.location.search.indexOf('&') != -1){                 
                sforce.console.getEnclosingPrimaryTabId(callCloseTab);   
            }else{
                window.opener.location.href="/{!JSENCODE($CurrentPage.parameters.id)}";
                window.close();
            }  
        }  
    }
    function resetHiddenVal(inputElement) {
        document.getElementById(inputElement).value = null;
    }     
    function getCurrentTabToClose () {
        sforce.console.getEnclosingTabId(callCloseTab);
    }    
    function callCloseTab(result) {
        sforce.console.closeTab(result.id);
    }    
    function noenter(ev)  {
        if (window.event && window.event.keyCode == 13 || ev.which == 13) {
            searchMktFunc();
            return false;
        } else {
            return true;
        }
    }