$(document).ready(function() {
    $.unblockUI();
});
function validateFormEntries(){
	var validationFail = false;
	var sowName = $("input[id$=sowName]").val();
	var agencyEntry = $("input[id$=agencyField]").val();
	var brandEntry = $("input[id$=oblixBrand]").val();
	var bdbb = $("[id$=bdbb] option:selected").val();
	var financialYear = $("[id$=financialYear] option:selected").val();
    var bigC = $("input[id$=bigC]").val();
    var smallC = $("input[id$=smallC]").val();

	if(sowName.length == 0){
        $('#SOWName').addClass('mandatory_form_info_missing');
        validationFail = true;
    }else{
        $('#SOWName').removeClass('mandatory_form_info_missing');
    }   
    if(agencyEntry.length == 0){
        $('#agency').addClass('mandatory_form_info_missing');
        validationFail = true;
    }else{
        $('#agency').removeClass('mandatory_form_info_missing');
    } 
    if(brandEntry.length == 0){
        $('#Brand').addClass('mandatory_form_info_missing');
        validationFail = true;
    }else{
        $('#Brand').removeClass('mandatory_form_info_missing');
    }
    if(financialYear.length == 0){
        $('#FinancialYear').addClass('mandatory_form_info_missing');
        validationFail = true;
    }else{
        $('#FinancialYear').removeClass('mandatory_form_info_missing');
    }
    if(bdbb.length == 0){
        $('#inlineRadioBD').addClass('mandatory_form_info_missing');
        validationFail = true;
    }else{
        $('#inlineRadioBD').removeClass('mandatory_form_info_missing');
    }
    if(bigC.length == 0){
        $('#BigCategory').addClass('mandatory_form_info_missing');
        validationFail = true;
    }else{
        $('#BigCategory').removeClass('mandatory_form_info_missing');
    }
    if(smallC.length == 0){
        $('#SmallCategory').addClass('mandatory_form_info_missing');
        validationFail = true;
    }else{
        $('#SmallCategory').removeClass('mandatory_form_info_missing');
    }
    if(validationFail){
    	return false;
    }else{
    	checkFileSize();
    	return true;
    }
}
function getIEFileSize(file) {
    var myFSO = new ActiveXObject("Scripting.FileSystemObject"),
        filepath = file.value,
        thefile = myFSO.getFile(filepath);
    return thefile.size;
}

function checkFileSize() {
    console.log('Checkfilesize called');
    var goodSize = true;
    $('input[type=file]').each(function() {
        if (typeof this.files[0] !== 'undefined') {
            var file = this.files[0],
                size = typeof ActiveXObject !== 'undefined' ?
                getIEFileSize(file) :
                file.fileSize || file.size;

            goodSize = 25000000 > size;
            if (!goodSize) {
                alert(this.files[0].name + ' is too large - please choose a file that is 25Mb or less');
            } else {
                if (2000000 < size) {
                    goodSize = confirm('The file size is ' + humanFileSize(size,true) +
                        ' bytes - this may take some time. Are you sure you wish to continue');
                }
            }

            return goodSize;
        }
    });
    return goodSize;
}
function humanFileSize(bytes, si) {
    var thresh = si ? 1000 : 1024;
    if (Math.abs(bytes) < thresh) {
        return bytes + ' B';
    }
    var units = si ? ['kB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'] : ['KiB', 'MiB', 'GiB', 'TiB', 'PiB', 'EiB', 'ZiB', 'YiB'];
    var u = -1;
    do {
        bytes /= thresh;
        ++u;
    } while (Math.abs(bytes) >= thresh && u < units.length - 1);
    return bytes.toFixed(1) + ' ' + units[u];
}
