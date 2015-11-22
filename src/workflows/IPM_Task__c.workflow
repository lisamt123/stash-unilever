<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_milestone_Due_Date_to_task_due_date</fullName>
        <field>IPM_Due_Date1__c</field>
        <formula>IPM_Due_Date__c</formula>
        <name>Set milestone Due Date to task due date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Task_Name</fullName>
        <field>Name</field>
        <formula>LEFT(IPM_Project__r.IPM_Project_Name__c + &apos;-&apos; +  IPM_Task_Name__c, 78)</formula>
        <name>Update Task Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Rename Task Name</fullName>
        <actions>
            <name>Update_Task_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Due Date for task</fullName>
        <actions>
            <name>Set_milestone_Due_Date_to_task_due_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update the due date for task corresponding to milestone due date.</description>
        <formula>IF(OR(ISBLANK(IPM_Due_Date1__c),       ISNULL(IPM_Due_Date1__c),       ISCHANGED(IPM_Due_Date__c )       ),true,false )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
