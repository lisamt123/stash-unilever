window.onload = new function () {        
        window.focus();
        var ele = document.getElementById('{!$Component.form.block.section.query}');
        if (ele) {
            ele.focus();
        } 
      }
    function getCookie(c_name)
    {
        var c_value = document.cookie;
        var c_start = c_value.indexOf(" " + c_name + "=");
        if (c_start == -1)
        {
            c_start = c_value.indexOf(c_name + "=");
        }
        if (c_start == -1)
        {
            c_value = null;
        }
        else
        {
            c_start = c_value.indexOf("=", c_start) + 1;
            var c_end = c_value.indexOf(";", c_start);
            if (c_end == -1)
            {
                c_end = c_value.length;
            }
            c_value = unescape(c_value.substring(c_start,c_end));
        }
        return c_value;
    }   
    var myids = new Array();
    var mynames = new Array();
    var ids;  
    var names;
    function selectthis(th,id,name)
    {
        var selectedCount = 0;  
        var ArrayIndex = myids.indexOf(id) 
        if(ArrayIndex==-1)
        {
            myids[myids.length]  = id ;
            mynames[mynames.length]  =name;
            ids =myids.join();
            names=mynames.join();
        }  
    }     
    function getURLParameter(name) {
        return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null
    }
    function CloseWindow(ids) {        
        var winMain = window.opener;
        if (null == winMain) {
            winMain = window.parent.opener;
        } else {
            winMain = window.parent.opener;
        }   
        winMain.closeLookupPopup();
    }
    var inputText1;
    function eleInFocus(ele) {
        inputText1 = ele;
    }
    function noEnter(ev) {
        if (window.event && window.event.keyCode == 13 || ev.which == 13) {
            doSearchAF();
            return false;
        } else {
            return true;
        }
    }
    function bringFocus() {
        inputText1.focus();
    }
    function Sub()
    {
        document.getElementById('{!$Component.pg.frm.pb.btnGo}').click();
        return false;
    }