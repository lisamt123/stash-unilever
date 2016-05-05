/*  
**********************************************************************************
*@Description:This script is used for project eco design section
*@Author: Cognizant
*@Created Date: 14/09/2015 
**********************************************************************************
*/
  var jq = jQuery.noConflict();
  jq(document).ready(function(){
         jq(".getED").on("click", function(e){
         e.preventDefault();
         if(window.clipboardData){         
                 var data = window.clipboardData.getData("Text");                            
                 var clipArray = data.split(/\s{2,}/);                
                 var phArray = []; 
                 jq(".ipmAcrdnExpand").find("label").each(function(){
                 phArray.push(jq(this).text());
                 });                
                 var unqArray = [];
                 var unqArray = data.split(",");
                 
                 if(unqArray[0]=="true"){
                 jq(".ipmAcrdnExpand input.skuType").attr("value", "Comparison SKU"); 
                 }else{
                 jq(".ipmAcrdnExpand input.skuType").attr("value", "Category Average"); 
                 }
                 //var loopedArray = unqArray.splice(1,2);
                 //var unqArray =  clipArray.filter(function(el) { return jq.inArray(el, phArray) === -1;}); 
                 jq(".ipmAcrdnExpand input.getEdVal").each(function(i){              
                 jq(this).attr("value", unqArray[i+2]);              
                 });
                 if(unqArray.length<18){
                 jq(".ipmAcrdnExpand input.getEdVal:last").attr("value", "");
                 }
                }
                else
                {
                alert("Your browser does not support Clipboard event!");
                }                                
         }); 
        
        /*--Accordian--*/
    /*    
    jq(".secEcoDesign .ipmAcrdnExpand").hide();
    jq(".secEcoDesign .ipmAcrdnExpand:first, .secEcoDesign .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();                          
    jq(document).on("click", ".secEcoDesign .ipmAccordian .expico", function(){                
        
        if(jq(this).closest(".aHead").next(".ipmAcrdnExpand").is(":visible") && jq(this).closest(".aHead").next(".ipmAcrdnExpand").not(':empty')){
            jq(this).closest(".aHead").next(".ipmAcrdnExpand").slideUp("fast");
            jq(this).removeClass("fa-minus");
            jq(this).addClass("fa-plus");
        }else{
            jq(this).closest(".aHead").next(".ipmAcrdnExpand").slideDown("fast");
            jq(this).removeClass("fa-plus");
            jq(this).addClass("fa-minus");
        }
    });
    */
    /* Select Countries Dropdown */
  /* var channelStr ='';
    jq('#customerChannels input[type=checkbox]').each(function () {
        var val = jq(this).attr('value');
        if(val === 'true'){
            jq(this).prop('checked', true); 
        }else{jq(this).prop('checked', false);}
    });
    jq(document).on('click', '.dropdown-menu input[type="checkbox"], .dropdown-menu li', function(e){
        e.stopPropagation();
    });
    function addTest(){
    var channelList = [];
    jq(".channelList input:checkbox:checked").each(function() {
        channelList.push(jq(this).val());
    });
    channelStr = channelList.toString();
    selectTest(channelStr);
}*/
});