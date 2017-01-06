<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
