function func()
{
	alert('Only relevant for Manual Blocks/Unblocks/Deletes/Undeletes'); 
}
function openAdvanceform()
{
	var localhost = document.domain;
	window.top.location='https://'+localhost+'/apex/VPM_AdvancedForm_V1?id='+purId;
}
function PageReload()
{
	window.top.location='https://'+localhost+'/'+purId;
	return false;
}

function redirectToListView()
{
	window.top.location='https://'+localhost+'/apex/VPM_VendorRequestsHome';
	return false;
}
function openProcureAtAGlance(){
	window.top.location='https://'+localhost+'/apex/VPM_UserSpecificFields?id='+purId;
}
window.onload = function(){
	twistSection(document.getElementById('{!$Component.block1.section1}').getElementsByTagName('img')[0]) 
}