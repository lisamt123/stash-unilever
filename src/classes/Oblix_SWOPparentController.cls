/*****************************************************************************************
* @author       Shahin Movahedi
* @date         2016-01-14
* @description  This class contains common methods used by subclasses throughout 
*               SWOP application
*
*    --------------------------------------------------------------------------
*    Developer                  Date                Description
*    ----------------------------------------s----------------------------------
*   
*    Shahin Movahedi            2016-01-14          Created

******************************************************************************************/
public with sharing virtual class Oblix_SWOPparentController {

    public Marketing_SOW__c selected_sow {get; set;}
    public Oblix_SOW_Projects__c selected_project {get;set;}
    public Oblix_CampaignStageLogic stage_identifier {get;set;}

    public Oblix_SWOPparentController() {
        
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  top link on the page exists SWOP appp
    ********************************************************************************/
    public Pagereference exitSwop(){
        return Oblix_Utils.exitSwop();
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  top link on the page goes to ReportsHome
    ********************************************************************************/
    public Pagereference goToReportsHome(){
        return Oblix_Utils.goToReportsHome();
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  depending on the sow Id in scope and the required fields
    				populate the selected sow in scope - used by sub-classes
    ********************************************************************************/
    public Marketing_SOW__c getSOW(Id sow_id, List<String> fields_to_query, String related_query_string){

    	Marketing_SOW__c sow = new Marketing_SOW__c();
    	
    	if (String.isNotBlank(sow_id) && !fields_to_query.isEmpty()){

            // build SOQL for querying campaign fields
            String s_query_string = buildSOQLquery(fields_to_query, 'Marketing_SOW__c', related_query_string, 'Id = ' + '\'' + sow_id + '\'',null,null );
            sow = Database.query(s_query_string);
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid sow id was passed in to the page'));
        }

        return sow;
    }

    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  depending on the campaign Id in scope and the required fields
    				populate the selected campaign in scope - used by sub-classes
    ********************************************************************************/
    public Oblix_SOW_Projects__c getCampaign(Id campaign_id, List<String> fields_to_query, String related_query_string){

    	Oblix_SOW_Projects__c sow_project = new Oblix_SOW_Projects__c();
    	
    	if (String.isNotBlank(campaign_id) && !fields_to_query.isEmpty()){

            // build SOQL for querying campaign fields
            String s_query_string = buildSOQLquery(fields_to_query, 'Oblix_SOW_Projects__c', related_query_string, 'Id = ' + '\'' + campaign_id + '\'',null,null );
            sow_project = Database.query(s_query_string);
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Invalid project id was passed in to the page'));
        }

        return sow_project;
    }


    /*******************************************************************************
    * @author       Shahin Movahedi
    * @date         2016-01-17
    * @description  Using the params passed in, build a SOQL query to retrieve records
                    from a given staging table - also pass in the related object soql query if required
    ********************************************************************************/
    protected String buildSOQLquery(List<String> fields_to_query, String object_to_query, String related_object_query, String where_clause, String order_by, String limit_rows){


            // build SOQL for querying different objects and given different criteria. 
            // Select records from Staging table 
            // according to the jobComponent attributes.
            String query_string = 'SELECT ';
            query_string += String.join(fields_to_query,',');
            
            // add the related object query if the string passed in is not empty
            query_string += String.isNotBlank(related_object_query) 
                ? related_object_query
                : '';

            query_string += ' FROM ' + object_to_query;
            
            // add in the where clause
            query_string += String.isNotBlank(where_clause)
                ? ' WHERE ' + where_clause
                : '';
         
            query_string += String.isNotBlank(order_by)
                ? ' ORDER BY ' + order_by
                : '';

            query_string += String.isNotBlank(limit_rows)
                ? ' LIMIT ' + limit_rows
                : '';

            system.debug('## SOQL query is: ' + query_string);

            return query_string;
    }    



}