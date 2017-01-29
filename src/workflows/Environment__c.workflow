<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>countnoextended</fullName>
        <field>Number_of_times_extended__c</field>
        <formula>BLANKVALUE(0, Number_of_times_extended__c +1 )</formula>
        <name>countnoextended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SAJ_Notify_AllocationEndDate</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Environment__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>send out emails when Allocation end date is less than 15 days away</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Environment__c.Updated_Allocation_End_date__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <offsetFromField>Environment__c.Initial_Allocation_End_Date__c</offsetFromField>
            <timeLength>-15</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SAJ_Notify_RefreshDate_old</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Environment__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>notification for refresh date reminder if refresh date is more than a month in the past</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Environment__c.Last_Refresh__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SAJ_countnoextensions</fullName>
        <actions>
            <name>countnoextended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Updated_Allocation_End_date__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
