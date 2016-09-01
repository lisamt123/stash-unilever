/*  
 *************************************************************************
 *@Description:This script is used for project search page specific interaction
 *@Author: Cognizant
 *@Created Date: 28/05/2015 
 *************************************************************************
 */
/* Since we are using global variables we will not be able to create multiple functions. 
If we split the script to multiple functions the functionality will break. 
Also variables have to be kept global to make the functionality work. */
    var geoAll;
    var clusters = [];
    var mcos = [];
    var countries = [];
    var unAssigned = 'false';
    var iTORange1 = -1;
    var brandPositionsnew = [];
    var iTORange2 = -1;
jq(document).ready(function() {
    /* Below function calls the filter function. Filter works based on the value passed to the function. */
    function filterTLDs() {
        filterTLD(jq('#tldFrom').val(), jq('#tldTo').val());
    }
    /* Below function loads the projects based on the value passed to the function. */
    function searchProjects() {
        loadProjects(jq('#srchTxt').val());
    }
    wrapGeography();
    /* Below works on click event. It calls another function. */
    jq("#applyFilter").on("click", function() {
        applyFilter();
    });
	dropDownFilter();
    chkAll();
    chkSub();
   
});

function chkAll() {
    /* Below script works on click event. When the check all is checked all the child checkboxes will be checked. */
    jq(".docFilter").on("click", ".checkAll", function() {
        if (jq(this).is(":checked")) {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]:not('[disabled]')").prop("checked", true);
            jq(this).closest("ul").find("input[type=checkbox]:not('[disabled]')").next().addClass("selected");
        } else {
            jq(this).closest("ul.docFilter").find("input[type=checkbox]:not('[disabled]')").prop("checked", false);
            jq(this).closest("ul").find("input[type=checkbox]:not('[disabled]')").next().removeClass("selected");
        }
    });

    /* Below script replace a text with a specific time format. */
    jq(".dueDate,.comDate").each(function() {
        jq(this).text(jq(this).text().replace('00:00:00 GMT', ''));
    });
    jq('tr:nth-child(4n),tr:nth-child(4n-1)').addClass('greyColr').removeClass('noBackground');
    jq('tr:nth-child(4n)').addClass('genRowOdd');

    /* Below script works on keypress. When user presses enter key a search function is called */
    jq('#srchTxt').keypress(function(e) {
        if (e.which === 13) {
            loadProjects(jq('#srchTxt').val());
            return false;
        }
    });

    /* Below script works on keypress. When user presses enter key a search function is called */
    jq('#srchBrand').keypress(function(e) {
        if (e.which === 13) {
            loadProjects(jq('#srchBrand').val());
            return false;
        }
    });
}

function chkSub() {
    /* Below script works on click event. It reloads the current page. */
    jq(document).on('click', '#resetFilterBtnNew', function() {
        window.location.href = window.location.href;
    });
    /* Below script works on click event. Based on condition it checks for a specific class in below conditions.
Also if the checkbox is checked it will check its own related child checkboxes. */
    jq(".docFilter").on("click", ".checkSub", function() {
        var checkSub = jq(this).closest("ul").find(".checkSub:checked").closest("li").length;
        var checkNot = jq(this).closest("ul").find(".checkSub").closest("li").length;
        if (jq(this).hasClass('countryCheck')) {
            if (jq(this).is(':checked')) {
                jq(this).closest("ul").find("li input.checkAll").prop("checked", true);
                jq(this).closest("ul").find("li input.checkAll").next("label").addClass("selected");
            } else {
                checkSub = jq(this).closest("ul").find(".checkSub:checked:not('.mcoCheck')").closest("li").length;
                if (checkSub === 0) {
                    jq(this).closest("ul").find("li input.checkAll").prop("checked", false);
                    jq(this).closest("ul").find("li input.checkAll").next("label").removeClass("selected");
                }
            }
        } else if (jq(this).hasClass('mcoCheck')) {
            if (jq(this).is(':checked')) {
                jq(this).closest("li.subCheck").closest('ul').find('li.clusterCheckLi').find('input.clusterCheck').prop("checked", true);
                jq(this).closest("li.subCheck").closest('ul').find('li.clusterCheckLi').find('input.clusterCheck').next("label").addClass("selected");

                jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find('li.clusterCheckLi').find('input.clusterCheck').prop("checked", true);
                jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find('li.clusterCheckLi').find('input.clusterCheck').next("label").addClass("selected");
            } else {
                checkSub = jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find(".mcoCheck.checkSub:checked").length;

                if (checkSub === 0) {
                    jq(this).closest("li.subCheck").closest('ul').find('li.clusterCheckLi').find('input.clusterCheck').prop("checked", false);
                    jq(this).closest("li.subCheck").closest('ul').find('li.clusterCheckLi').find('input.clusterCheck').next("label").removeClass("selected");

                    jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find('li.clusterCheckLi').find('input.clusterCheck').prop("checked", false);
                    jq(this).closest("li.subCheckLi").closest('ul.clusterListUl').find('li.clusterCheckLi').find('input.clusterCheck').next("label").removeClass("selected");
                }
            }
        } else if (jq(this).hasClass('clusterCheck')) {
            checkSub = jq(this).closest("ul").closest('ul.geographyAllUl').find('.clusterCheckLi').find(".clusterCheck.checkSub:checked").length;
            checkNot = jq(this).closest("ul").closest('ul.geographyAllUl').find('.clusterCheckLi').find(".clusterCheck.checkSub").length;
            if (checkNot !== checkSub) {
                jq('input.geographyAllLevel1').prop("checked", false);
                jq('input.geographyAllLevel1').next("label").removeClass('selected');
            }
            if (checkNot === checkSub) {
                jq('input.geographyAllLevel1').prop("checked", true);
                jq('input.geographyAllLevel1').next("label").addClass('selected');
            }
        } else {
            if (checkNot !== checkSub) {
                if (jq(this).hasClass('clusterCheck')) {
                    jq('input.geographyAllLevel1').prop("checked", false);
                    jq('input.geographyAllLevel1').next("label").removeClass('selected');
                }
                jq(this).closest("ul").find("li input.checkAll").prop("checked", false);
                jq(this).closest("ul").find("li input.checkAll").next("label").removeClass("selected");
            }
            if (checkNot === checkSub) {
                if (jq(this).hasClass('clusterCheck')) {
                    jq('input.geographyAllLevel1').prop("checked", true);
                    jq('input.geographyAllLevel1').next("label").addClass('selected');
                }
                jq(this).closest("ul").find("li input.checkAll").prop("checked", true);
                jq(this).closest("ul").find("li input.checkAll").next("label").addClass("selected");
            }
        }
    });
}
/* Below function performs unchecking of children checkboxes when the condition is true. */
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




function wrapGeography() {
        geoAll = jq('#geographyAll').is(":checked");
        clusters = [];
        mcos = [];
        countries = [];
        /* Below script pushes the value if the condition is true. */
        jq('.clusterCheck').each(function() {
            if (jq(this).is(":checked") === true && jq(this).val() !== 'Unassigned') {
                clusters.push(jq(this).val());
            }
            if (jq(this).is(":checked") === true && jq(this).val() === 'Unassigned') {
                unAssigned = 'true';
            }
        });
        /* Below script pushes the value if the condition is true. */
        jq('.mcoCheck').each(function() {
            if (jq(this).is(":checked") === true) {
                mcos.push(jq(this).val());
            }
        });
        /* Below script pushes the value if the condition is true. */
        jq('.countryCheck').each(function() {
            if (jq(this).is(":checked") === true) {
                countries.push(jq(this).val());
            }
        });
    }
	
function applyFilter() {
        var checkedPhases = [];
        var checkedProjectTypes = [];
        jq('.phase').each(function() {
            /* Below script pushes the value if the condition is true. */
            if (jq(this).is(":checked")) {
                checkedPhases.push(jq(this).val());
            }
        });
        /* Below script pushes the value if the condition is true. */
        jq('.projectType').each(function() {
            if (jq(this).is(":checked")) {
                checkedProjectTypes.push(jq(this).val());
            }
        });
        wrapGeography();
        if (jq('.iTORange1').val() !== '') {
            iTORange1 = jq('.iTORange1').val();
        }
        if (jq('.iTORange2').val() !== '') {
            iTORange2 = jq('.iTORange2').val();
        }
        applyFltr(checkedPhases.toString(), jq('.tldFrom').val(), jq('.tldTo').val(), jq('.my').is(":checked"), jq('.aPro').is(":checked"), geoAll, clusters, mcos, countries.toString(), iTORange1, iTORange2, brandPositionsnew.toString(), checkedProjectTypes.toString(), jq('#ActiveProjects').is(':checked'), jq('#StoppedProjects').is(':checked'), unAssigned);
    }
	
function dropDownFilter(){
jq("div.brandSearchResultsClass").on("click", "div", function(event) {
        brandsVal = jq(this).text();
        jq('.filterBrand').val(brandsVal);
        jq('.brandSearchResultsClass').hide();
        jq("#brandSearchResults div").remove();
        jq('<li class="brndFilter"></li>').append('<div class="selectedBrand">' + brandsVal + '</div>').appendTo(jq('ul.filterBrandList'));
        var seen = {};
        var i = 0;
        jq('div.selectedBrand').each(function() {
            var txt = jq(this).text();
            if (seen[txt]){
                jq(this).parent().remove();
            }else {
                seen[txt] = true;
                brandPositionsnew[i] = txt;
                ++i;
            }
        });
    });

    jq(document).click(function(e) {
        if (e.target.id != 'brandSearchResults') {
            jq("#brandSearchResults").hide();
        }
    });

    jq('.filterBrand').on('keyup', function() {
        var txtCount = jq(this).val().length;
        if (txtCount >= 2) {
            jq('.brandSearchResultsClass').show();
        } else {
            jq('.brandSearchResultsClass').hide();
        }
    });
	
	 /* Below works on click event. It removes the list when clicked on it */
    jq(".filterBrandList").on("click", ".brndFilter", function() {
        brandPositionsnew.splice(jq.inArray(jq(this).text(), brandPositionsnew), 1);
        jq(this).remove();
    });
}