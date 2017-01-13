<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>In_Progress_Campaign</fullName>
        <description>Telesales - Sets the Campaign as In Progress</description>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>In Progress Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEL_Activate_Campaign</fullName>
        <description>Telesales - Activates the Campaign</description>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>Activate Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEL_Campaign_Completed</fullName>
        <description>Telesales - Sets Campaign status as Completed</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Campaign Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEL_Deactivate_Campaign</fullName>
        <description>Telesales - Sets field Active as False</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Deactivate Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>TEL_Activate_Deactivate_Campaign</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Telesales Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.IsActive</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Telesales - Automatically activates  the campaign on the Start Date and deactivates on the End Date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TEL_Campaign_Completed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>TEL_Deactivate_Campaign</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>In_Progress_Campaign</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>TEL_Activate_Campaign</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.StartDate</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
