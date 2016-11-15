<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FAU_Update_webinar_status_to_Completed</fullName>
        <field>FAU_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>FAU Update webinar status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Webinar_Date_update</fullName>
        <field>FAU_Start_Time__c</field>
        <formula>DATETIMEVALUE( FAU_Program_Wave__r.FAU_Start_Date__c -84)</formula>
        <name>Webinar Date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FAU Webinar Completed on End Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>FAU_Webinar__c.FAU_Status__c</field>
            <operation>equals</operation>
            <value>Invited</value>
        </criteriaItems>
        <description>Sets the webinar staus to Completed when end date is reached</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Update_webinar_status_to_Completed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>FAU_Webinar__c.FAU_End_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>FAU Webinar Dates</fullName>
        <actions>
            <name>Webinar_Date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>FAU_Program__c.FAU_Category__c</field>
            <operation>equals</operation>
            <value>Core</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Program__c.FAU_Category__c</field>
            <operation>equals</operation>
            <value>Franchise</value>
        </criteriaItems>
        <description>This sets the Webinar Dates of Program to 12 weeks before the program start date for HP2 and HP3 programs</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
