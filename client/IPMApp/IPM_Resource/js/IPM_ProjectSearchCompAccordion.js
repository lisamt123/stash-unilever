function rerenderAccordion(){
        /*accordion All checkbox Checked Geography*/
		jq('.geographyFilters input:checkbox').attr('checked', 'checked');
        /*blockquote tag to ul tag Geography*/
        jq('blockquote').each(function() { jq(this).replaceWith("<ul>"+jq(this).html()+"</ul>") });
        jq( "div.projectContainer.gfirstLevel ul" ).addClass( "docFilter accordionFilters clusterListUl" );
    
        jq(document).on('click', 'li.clusterCheckLi', function(){
         jq('blockquote').each(function() { jq(this).replaceWith("<ul>"+jq(this).html()+"</ul>") });
         jq( "div.projectContainer.gfirstLevel ul" ).addClass( "docFilter accordionFilters clusterListUl" );
       });
		jq('.geographyFilters input:checkbox, .projectContainer input:checkbox, ul.docFilter.typeLabel input:checkbox').each(function(){
            var mvalue = jq(this).attr('id');
            var cvalue = mvalue.replace('amp;','&');
            jq(this).attr('id',cvalue);
        });  
    jq(document).ready(function() {
        /*accordion Geography*/
		var ipmAccordion = jq(".ipmAccordion");
	    /* Below script calls a function accordion on click event */
		jq(document).on("click", ".ipmAccordion .pHead span.expico, .ipmAccordion .pHead span.expico-square", function() {
			accordion(this);
    });
    
/* Below script expands all the tabs in accordion when clicked on the Expand all button and replaces '+' with '-' sign */
    jq(document).on("click", ".expandTool .expandAll", function() {
        jq('blockquote').each(function() { jq(this).replaceWith("<ul>"+jq(this).html()+"</ul>") });
        jq( "div.projectContainer.gfirstLevel ul" ).addClass( "docFilter accordionFilters clusterListUl" );
        ipmAccordion.find(".ipmAcrdnExpand").not(':empty').slideDown("fast");
        ipmAccordion.find(".pHead .expico").removeClass("fa-plus");
        ipmAccordion.find(".pHead .expico").addClass("fa-minus");
        ipmAccordion.find(".pHead .expico-square").removeClass("fa-plus");
        ipmAccordion.find(".pHead .expico-square").addClass("fa-minus");
    });
    
/* Below script collapses all the tabs in accordion when clicked on the Collapse all button and replaces '-' with '+' sign */
    jq(document).on("click", ".expandTool .collapseAll", function() {
        ipmAccordion.find(".ipmAcrdnExpand ").slideUp("fast");
        ipmAccordion.find(".pHead .expico").addClass("fa-plus");
        ipmAccordion.find(".pHead .expico").removeClass("fa-minus");
        ipmAccordion.find(".pHead .expico-square").addClass("fa-plus");
        ipmAccordion.find(".pHead .expico-square").removeClass("fa-minus");
    });  
/* Below script works on page load. First it hides all the tabs. Then it opens only the first tab. It also adds the + mark for the collapsed one's and adds - for the expanded one */
    jq(".ipmAcrdnExpand").show();
    //jq(".ipmAcrdnExpand:first, .ipmAcrdnExpand:first .ipmAcrdnExpand").not(':empty').show();
    jq(".projectContainer.geographyFilters .ipmAcrdnExpand .projectContainer.gfirstLevel .ipmAcrdnExpand").hide();
    ipmAccordion.find(".pHead .expico-square").addClass("fa-plus");
    ipmAccordion.find(".pHead .expico-square").removeClass("fa-minus");
    ipmAccordion.find(".pHead span.expico").removeClass("fa-plus");
    ipmAccordion.find(".pHead span.expico").addClass("fa-minus");

    ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").removeClass("fa-minus");
    ipmAccordion.find(".ipmAcrdnExpand:first .pHead span.expico").addClass("fa-plus");
    ipmAccordion.find(".pHead .recCount").removeClass("expanded");
    ipmAccordion.find(".pHead .recCount").addClass("collapsed");

});
/* Below function is called above upon click event where it expands the tab and replaces '+' with '-' or collapses a opened tab and replaces '-' with '+' */
function accordion(elem) {
    if (jq(elem).closest(".pHead").next(".ipmAcrdnExpand").is(":visible")) {
        jq(elem).closest(".pHead").next(".ipmAcrdnExpand").slideUp("fast");
        jq(elem).removeClass("fa-minus");
        jq(elem).addClass("fa-plus");
        jq(elem).next('.recCount').removeClass('expanded');
        jq(elem).next('.recCount').addClass('collapsed');
    } else {
        jq(elem).closest(".pHead").next(".ipmAcrdnExpand").slideDown("fast");
        jq(elem).removeClass("fa-plus");
        jq(elem).addClass("fa-minus");
        jq(elem).next('.recCount').removeClass('collapsed');
        jq(elem).next('.recCount').addClass('expanded');
    }
}
        
	  Delaygeography();
	  checboxSelect();
    }
	
function sortProjectsJsFunc(){
jq("#sortProjects").on("click",function(){toggleSortProjects()}),
jq("#sortPhases").on("click",function(){toggleSortPhases()}),
jq("#sortPLs").on("click",function(){toggleSortPLs()}),
jq("#sortGKs").on("click",function(){toggleSortGKs()}),
jq("#sortITOs").on("click",function(){toggleSortITOs()}),
jq("#sortTLDs").on("click",function(){toggleSortTLDs()})
}

function projectTypeCheck(){
jq('.docFilter.accordionFilters input:checkbox').attr('checked', 'checked');
jq('ul.docFilter.typeLabel input:checkbox').attr('checked', 'checked');
}
function Delaygeography(){
/*Delay Geography*/
      jq("ul.docFilter.accordionFilters.geographyAllUl").hide().delay(200).queue(function (next) {
        jq(this).show();
        next();
     });
}
function checboxSelect(){
 function unCheckChildren(str) {
        jq('.' + str).each(function() {
            if (jq(this).val() !== 'all') {
                jq(this).attr("checked", false);
            }
        });
    }
    /* Below function performs checking of children checkboxes. */
    function checkChildren(str) {
        jq('.' + str).each(function() {
            jq(this).attr("checked", true);
        });
    }
    /* Below function performs unchecking of parent checkboxes when the condition is true. */
    function unCheckParent(str) {
        jq('.' + str).each(function() {
            if (jq(this).val() === 'all') {
                jq(this).attr("checked", false);
            }
        });
    } 
}
