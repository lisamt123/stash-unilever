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
</Workflow>
