/**********************************************************************
 *@Description:This script is used in Product & Source Plan page
 *@Author: Cognizant
 *@Created Date: 29/09/2016 
**********************************************************************/
jq(document).ready(function() {
    firstsrcplan();
    scndsrcplan();
    thirdsrcplan();
});
function checkDuplicateRow(){
    if(IPMSRCPLAN.duplicate){
        jq('#duplicateBox').modal({
            show: true,
            keyboard: false,
            backdrop: 'static'
        });
        jq('#duplicateBox .modal-dialog').width('600px');
        jq('#duplicateBox .modal-dialog').height('200px');
        jq('#duplicateBox .modal-dialog').css({
            'margin-top': '10%',
            'z-index': '999'
        });
    }
}
function displayCapabilitySection(param,eve){                
    if(jq('select').val() === 'Select Sourcing Unit')
    {
        jq('#iddivCapability').hide();
    }
    else{
        jq('#iddivCapability').show();
    }
}
function firstsrcplan(){
    jq('.numberBox').spinner();
    jq('.sizeNumberbox').spinner();
    jq(".goldenCheck").each(function() {
        if(jq(this).val() === 'true' || jq(this).is(':checked'))
        {
            jq(this).attr('checked','checked');
            jq(this).next('label').addClass('goldbox');
            jq(this).next('label').text('Golden');
        }
    }); 
    jq(".greenBoxCheck").each(function() {
        if(jq(this).val() === 'true' || jq(this).is(':checked'))
        {
            jq(this).attr('checked','checked');
            jq(this).next('label').addClass('greenBox');
            jq(this).next('label').text('Yes');
        }
    });        
    jq(document).on('click', '.goldenCheckcontainer input[type="checkbox"]:not(:disabled)', function() {
        var chkInput1 = jq(this);
        if (chkInput1.is(':checked')) {
            chkInput1.val('true');
            chkInput1.next('label').addClass('goldbox');
            chkInput1.next('label').text('Golden');
        } else {
            chkInput1.val('false');
            chkInput1.next('label').removeClass('goldbox');
            chkInput1.next('label').text('');
        }
    });
    jq(document).on('click', '.approvalCheckcontainer input[type="checkbox"]:not(:disabled)', function() {
        var chkInput1 = jq(this);
        if (chkInput1.is(':checked')) {
            chkInput1.val('true');
            chkInput1.next('label').addClass('greenBox');
            chkInput1.next('label').text('Yes');
        } else {
            chkInput1.val('false');
            chkInput1.next('label').removeClass('greenBox');
            chkInput1.next('label').text('Not yet');
        }
    });
    jq('.srcUnitBox').clearSearch();
    jq(document).on("focus click", ".srcUnitBox", function(e) {
        jq(this).parent().next('.srcList').show();
    });
    jq('.srcList div').on("click", "div", function(e) {
        var srcplanValue = jq(this).text();
        jq(this).parents().prev('div').find('.srcUnitBox').val(srcplanValue);
        jq(this).parents().prev('div').find('.srcUnitBox').focus();
    });
    jq(document).on("keyup", ".srcUnitBox", function(e) {
        jq(this).parent().next('.srcList').show();
    });
    jq(document).click(function(e) {
        if( jq(e.target).hasClass('srcUnitBox')){
              //Don't Hide the listbox 
        }else{
            jq(".srcList").hide(); 
        }            
    });
    jq(document).on('click', '.pdlCheckbox input[type="checkbox"]:not(:disabled)', function() {
        var chkInput = jq(this);
        if (chkInput.is(':checked')) {
            chkInput.next('label').addClass('selected');
        } else {
            chkInput.next('label').removeClass('selected');
        }
    });
    jq(document).on("click", ".deleteClaim", function(e) {
        e.preventDefault ? e.preventDefault() : e.returnValue = false;
        jq("#removeClaim .modal-dialog").width("600px");
        jq("#removeClaim .modal-dialog").height("180px");
        jq("#removeClaim .modal-dialog").css({
            "margin-top": "10%",
            "z-index": "999"
        })
    });
}

function scndsrcplan(){
    jq(document).on('show.bs.dropdown', '.sourcedcntryContainer', function(){
        jq(this).find('.srcedcntrymainlist').show(); 
    });
    jq(document).click(function(e) {
        if( e.target.id !== 'srcedcntryullist') {
            jq(".srcedcntrymainlist").hide();    
        }   
    });
    jq(".srcedfilterActionscc .ipmDropbuttonscc").each(function(e){
        jq(this).click(function(e) {
            var srcedcntryvalue = '';
            var key = jq(this).attr('data-key');
            var mid = jq(this).attr('data-mid');
            jq(this).parents('.getHdnVal').prev().find('input[type=checkbox]').each(function(e){
                if(jq(this).prop('checked') === true){
                    if(srcedcntryvalue.length > 0)
                    {
                        srcedcntryvalue = srcedcntryvalue +';'+jq(this).val();
                    }
                    else
                    {
                        srcedcntryvalue = jq(this).val();
                    }
                }
                if(srcedcntryvalue === ''){
                   jq(this).closest('.srcedcntrymainlist').prev().find('.srcedcntryValues').text('Select Countries');
                }
                else{
                   jq(this).closest('.srcedcntrymainlist').prev().find('.srcedcntryValues').text(srcedcntryvalue+';');
                }
                jq(".srcedcntrymainlist").hide();
                jq(this).closest('.srcedcntrylist').prev('.srcedhiddencntry').val(srcedcntryvalue+';'); 
            }); 
        getNotAssignedC(srcedcntryvalue);
        });
    });
    jq(".srcedfilterActionscc .ipmDropbuttonscc").each(function(e){
        jq(document).on('click', '.srcedfilterActionscc .ipmDropresetcc', function(e){
            e.stopPropagation();
            jq(".srcedcntrymainlist input:checkbox").each(function() {
                 jq(this).prop('checked', false);
               jq(this).next('label').removeClass('selected');
                jq('.srcedcntryValues').text(IPMAppPS.selectLabel);
            });
        });
    });
    jq(".srcedhiddencntry").each(function(e){
        if( jq(this) !== null && jQuery.type(jq(this)) !== 'undefined') 
        {
            var srcedcntrylist = jq(this).val();
            if(jQuery.type(srcedcntrylist) !== "undefined" && srcedcntrylist.length > 0 )
            {
                jq(this).closest('.srcedcntrymainlist').prev().find('.srcedcntryValues').text(srcedcntrylist);
                var brandArray = srcedcntrylist.split(';');  
                jq(this).next().find("input[type=checkbox]").each(function(e){
                    var checkboxObj = jq(this);
                    jq.each( brandArray, function( i, savedBrandPosition ){
                        if(checkboxObj.val() === savedBrandPosition)
                            {
                             checkboxObj.prop('checked',true);
                                return false;
                            }
                    }); 
                });
            }
        }
    }); 
    jq(".hovertip").tooltip({ position: { my: 'center top', at: 'center bottom+10'},tooltipClass:'srcunitTip'}); 
    jq(".info").tooltip({ position: { my: 'center top', at: 'center bottom+10'},tooltipClass:'srcunitTip'});
    jq(".approvalTip").tooltip({ position: {  my: 'center bottom', at: 'center top'},tooltipClass:'apprUnitTip'});
    jq(".mainsrcUnitTip").tooltip({ position: {  my: 'right center', at: 'left+20 center'},tooltipClass:'mainsrcHoverTip'});
    jq(".srcedintoTip").tooltip({ position: { my: 'center bottom', at: 'center top'},tooltipClass:'apprUnitTip'}); 
}

function thirdsrcplan(){
    jq(document).on('click', '.cntrymainlist input[type="checkbox"], .cntrymainlist ul li', function(e) {
            e.stopPropagation();
    });
    jq(document).on('show.bs.dropdown', '.productcntrylistcontainer', function(){
        jq(this).find('.cntrymainlist').show(); 
    });
    jq(document).click(function(e) {
        if( e.target.id !== 'cntryullist') {
            jq(".cntrymainlist").hide();    
        }   
    });
    jq('.filterActionscc .ipmDropbuttonscc').click(function(e) {
        var procntryvalue = '';
        jq(".cntrymainlist input[type=checkbox]").each(function(e){
            if(jq(this).prop('checked') === true){
                if(procntryvalue.length > 0)
                {
                    procntryvalue = procntryvalue +';'+jq(this).val();
                }
                else
                {
                    procntryvalue = jq(this).val();
                }   
            }
        });
        getsourceinto(procntryvalue+';');
        jq('.hiddencntry').val(procntryvalue+';');
        if(procntryvalue === ''){
            jq('.cntryValues').text(IPMAppPS.selectLabel);
        }
        else{
            jq('.cntryValues').text(procntryvalue+';');
        }
        jq(".cntrymainlist").hide(); 
    });
    jq(document).on('click', '.filterActionscc .ipmDropresetcc', function(e){
        e.stopPropagation();
        jq(".cntrymainlist input:checkbox").each(function() {
             jq(this).prop('checked', false);
           jq(this).next('label').removeClass('selected');
            jq('.cntryValues').text(IPMAppPS.selectLabel);
        });
    });   
    if( jq('.hiddencntry') !== null && jQuery.type(jq('.hiddencntry')) !== 'undefined') 
    {
        var maincntrylist = jq('.hiddencntry').val();   
        if(jQuery.type(maincntrylist) !== "undefined" && maincntrylist.length > 0 )
        {
            jq('.cntryValues').text(maincntrylist);
            var brandArray = maincntrylist.split(';');  
            jq(".cntrymainlist  input[type=checkbox]").each(function(e){
                var checkboxObj = jq(this);
                jq.each( brandArray, function( i, savedBrandPosition ){
                    if(checkboxObj.val() === savedBrandPosition)
                        {
                         checkboxObj.prop('checked',true);
                            return false;
                        }
                }); 
            });
        }
    }
    jq(document).on('click', '.srcedcntrymainlist input[type="checkbox"], .srcedcntrymainlist ul li', function(e) {
        e.stopPropagation();
    });
    jq(".srcingGreyCheck").each(function() {
        if(jq(this).val() === 'true' || jq(this).is(':checked'))
        {
            jq(this).attr('checked','checked');
            jq(this).next('label').addClass('greenBox');
            jq(this).next('label').text('Yes');
        }
    });
    jq(document).on('click', '.hdnCheckboxDiv input[type="checkbox"]:not(:disabled)', function() {
        var chkInput1 = jq(this);
        if (chkInput1.is(':checked')) {
            chkInput1.val('true');
            chkInput1.next('label').addClass('greenBox');
            chkInput1.next('label').text('Yes');
        } else {
            chkInput1.val('false');
            chkInput1.next('label').removeClass('greenBox');
            chkInput1.next('label').text('Not yet');
        }
    });
}