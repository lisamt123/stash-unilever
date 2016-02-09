/******************************************************************
 *@Description:This script used to manage and display the financials
 *@Author: Cognizant
 *@Created Date: 13/05/2015 
 *******************************************************************/
var jq = jQuery.noConflict();
function finScriptCallBack() {
	jq('[data-toggle="tooltip"]').tooltip();
    jq(".initAccordian").on("click", function() {
        var $this = jq(this);
        if ($this.parent().nextUntil(".leftsidemenu").is(":hidden")) {
            $this.parent().nextUntil(".leftsidemenu").show();
            $this.removeClass("fa-plus-square");
            $this.addClass("fa-minus-square");
        } else {
            $this.parent().nextUntil(".leftsidemenu").hide();
            $this.removeClass("fa-minus-square");
            $this.addClass("fa-plus-square");
        }
    });
    function loadCurrencyPage() {
        window.location = '/apex/IPM_Financial_Currency?id=' + IPMFINAPP.projectid;
    }
    jq(document).on('click', '#ipmDeleteModal .confirmAction.refreshFromLocal', function() {
        jq('#ipmDeleteModal').modal('hide');
        refreshFromLocal();
    });
    jq(document).on('click', '#ipmDeleteModal .confirmAction.refreshFromRegional', function() {
        jq('#ipmDeleteModal').modal('hide');
        refreshFromRegional();
    });
}
function defKeyPrev() {
    if ((event.keyCode < 48 && event.keyCode != 46) || (event.keyCode > 57 && event.keyCode != 190 && event.keyCode != 110)) {
        return false;
    }
}
jq(document).ready(function() {
    jq('[data-toggle="tooltip"]').tooltip();
    jq('.ipmFinancetable > tbody > tr').each(function() {
        var $this = jq(this);
        $this.find('td.iPLBorderGay:first').addClass('finTabletr');
    });
    jq(document).on('click', '.finArrow', function() {
        var $this = jq(this);
        var finFilter = jq('.finFilter');
        var finTable = jq('.finTableData');
        if ($this.children().hasClass('fa-angle-left')) {
            finFilter.hide();
            finTable.removeClass('col-sm-10');
            finTable.addClass('col-sm-12');
            $this.children().removeClass('fa-angle-left');
            $this.children().addClass('fa-angle-right');
        } else {
            finTable.removeClass('col-sm-12');
            finTable.addClass('col-sm-10');
            finFilter.show();
            $this.children().removeClass('fa-angle-right');
            $this.children().addClass('fa-angle-left');
        }
    });
    finScriptCallBack();
});
function refreshFromLocalJs(title, confirmMsg) {
    modalFunc(title, confirmMsg);
    var delModal = jq('#ipmDeleteModal .confirmAction');
    delModal.removeClass('refreshFromRegional');
    delModal.addClass('refreshFromLocal');
    finScriptCallBack();
}
function refreshFromRegionalJs(title, confirmMsg) {
    modalFunc(title, confirmMsg);
    var delModal = jq('#ipmDeleteModal .confirmAction');
    delModal.removeClass('refreshFromLocal');
    delModal.addClass('refreshFromRegional');
    finScriptCallBack();
}
function modalFunc(title, confirmMsg) {
    jq('#ipmDeleteModal .modal-title').html(title);
    jq('#ipmDeleteModal .confirmMsg').html(confirmMsg);
}
function updateCheckbox(Country, check) {
    ActionUpdate(Country, check);
}
var dots;
function progressDots() {
    var currSel = document.getElementById(IPMApp.compSlst).options[document.getElementById(IPMApp.compSlst).selectedIndex].text;
    document.getElementById(IPMApp.compOtl).textContent = 'Currency: ' + currSel + ': exchange rate is being applied..';
    dots = window.setInterval(function() {
        var wait = document.getElementById("wait");
        if (wait.innerHTML.length > 3){
            wait.innerHTML = "";
			}
        else{
            wait.innerHTML += ".";
			}
    }, 500);
}
function stopDots() {
    window.clearInterval(dots);
    document.getElementById("wait").innerHTML = '';
}
jq('#button').on('click', function() {
    var div = jq('#newpost');
    if (div.style.display !== 'none') {
        div.style.display = 'none';
        return false;
    } else {
        div.style.display = 'block';
        return false;
    }
});