var IPMRollOutAdd = {
   SelectedMCO: '{!JSENCODE(selectedMCO)}'
};

var jq = jQuery.noConflict();
jq(document).ready(function() {
   jq(".ipmAccordion").find(".pHead:first span.expico-square").removeClass("fa-plus").addClass("fa-minus");

   var selectedCountries = [];
   var unselectedCountries = [];

   jq(document).off('click', '.changeMCOTab').on('click', '.changeMCOTab', function() {
	   var changeMCOTab = jq(this);
	   // passed from front end
	   var previousMcoCode = IPMRollOutAdd.SelectedMCO;
	   var mcoCode = changeMCOTab.attr('id');
	   var keyMCO = jq('#keyMCO').is(":checked");

	   jq('.countryFilter .countryList input:checkbox').each(function() {
		   var cntryInput = jq(this);
		   if (cntryInput.is(":checked")) {
			   selectedCountries.push(cntryInput.attr('id'));
		   } else {
			   unselectedCountries.push(cntryInput.attr('id'));
		   }
	   });
	   changeMCO(selectedCountries.toString(), unselectedCountries.toString(), mcoCode, previousMcoCode, keyMCO);
   });

   jq(document).off('click', '.changeClusterTab').on('click', '.changeClusterTab', function() {
	   var previousMcoCode = IPMRollOutAdd.SelectedMCO;
	   var clusterCode = jq(this).attr('id');
	   var keyMCO = jq('#keyMCO').is(":checked");

	   jq('.countryFilter .countryList input:checkbox').each(function() {
		   var cntryInput = jq(this);
		   if (cntryInput.is(":checked")) {
			   selectedCountries.push(cntryInput.attr('id'));
		   } else {
			   unselectedCountries.push(cntryInput.attr('id'));
		   }
	   });
	   changeCluster(selectedCountries.toString(), unselectedCountries.toString(), clusterCode, previousMcoCode, keyMCO);
   });

   jq(document).off('click', '.generateRolloutBtn').on('click', '.generateRolloutBtn', function() {
	   var previousMcoCode = IPMRollOutAdd.SelectedMCO;
	   var keyMCO = jq('#keyMCO').is(":checked");
	   jq('.countryFilter .countryList input:checkbox').each(function() {
		   var cntryInput = jq(this);
		   if (cntryInput.is(":checked")) {
			   selectedCountries.push(cntryInput.attr('id'));
		   } else {
			   unselectedCountries.push(cntryInput.attr('id'));
		   }
	   });
	   generateRollouts(selectedCountries.toString(), unselectedCountries.toString(), previousMcoCode, keyMCO);
	   var projectId = "{!projectId}";

   });

   jq(document).off('click', '#selectAll').on('click', '#selectAll', function() {
	   var $this = jq(this);
	   var findInput = $this.closest("ul").find("li input[type=checkbox]");
	   var findLabel = $this.closest("ul").find("li label");
	   if ($this.is(":checked")) {
		   findInput.prop("checked", true);
		   findLabel.addClass("selected");
	   } else {
		   findInput.prop("checked", false);
		   findLabel.removeClass("selected");
	   }
   });

   jq(document).off('click', '#selectproLeader').on('click', '#selectproLeader', function(e) {

	   e.preventDefault ? e.preventDefault() : e.returnValue = false;
	   var url = jq(this).attr('value');
	   var mtitle = jq(this).attr('html-text');
	   jq("#ipmAddMemberModal .modal-body").html('<iframe frameborder="0" height="100%" width="100%" marginheight="0" marginwidth="0" allowtransparency="true" src= "' + url + '"></iframe>');
	   jq('#ipmAddMemberModal .modal-dialog').width('700px');
	   jq('#ipmAddMemberModal .modal-dialog').height('610px');
	   jq('#ipmAddMemberModal .modal-dialog').css({
		   'margin-top': '2%',
		   'z-index': '999'
	   });
	   jq('#ipmAddMemberModal .modal-title').html(mtitle);
   });
   scriptPanelLoad();

   hilightTaskScript();

});

function setFocusOnLoad() {}

function scriptPanelLoad() {
   var keyMCO = jq('#keyMCO');
   var srchTxt = jq('#srchTxt');
   jq('.placeholder').clearSearch();
   jq('.countrybg input:checkbox').each(function() {
	   var $this = jq(this);
	   if ($this.hasClass('selected')) {
		   $this.prop('checked', 'true');
	   }

	   if ($this.hasClass('disabled')) {
		   $this.prop('disabled', 'true');
	   }
   });

   if (keyMCO.hasClass('selected')) {
	   keyMCO.prop('checked', 'true');
   }
   srchTxt.addClass('placeholder');
   srchTxt.val(srchTxt.attr('placeholder'));
   jq(".placeholder").on("keypress", function(event) {
	   if (event.which == 13) {
		   unsaved = false;
		   callsearch();
		   return false;
	   }
   });
}

function setRedirect() {
   if ({!isCompleted
	   }) {
	   window.top.location = '{!URLFOR($Page.IPM_RolloutPlans)}?Id={!projectId}&EditMode=false';
   }
}

function hilightTaskScript() {
   jq(".info").tooltip({
	   position: {
		   my: 'center top',
		   at: 'center bottom+10'
	   }
   });
   jq(".deleteChannel").tooltip({
	   position: {
		   my: 'center top',
		   at: 'center bottom+10'
	   }
   });
   jq(".arrow-left").tooltip({
	   position: {
		   my: 'left top',
		   at: 'center bottom+10'
	   },
	   tooltipClass: 'ui-lefttip'
   });
   jq(".aTabs").find("input[type=checkbox]:checked").closest(".aTabs").addClass("active");
}