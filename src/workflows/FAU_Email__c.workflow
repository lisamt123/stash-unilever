<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>FAU_Send_Email_Update</fullName>
        <field>FAU_Send_Email__c</field>
        <literalValue>1</literalValue>
        <name>Send Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FAU_Update_Send_Email</fullName>
        <field>FAU_Send_Email__c</field>
        <literalValue>1</literalValue>
        <name>Update Send Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FAU UL2020_Send Email</fullName>
        <active>true</active>
        <description>EMAIL: Send E-mail to participant</description>
        <formula>FAU_Email_Start_Date__c  =  TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>FAU_Update_Send_Email</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
