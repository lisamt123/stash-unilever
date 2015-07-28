<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CEC_Set_Case_Status_New</fullName>
        <description>CEC Set the Case Status to New in order for case to be highlighted to an advisor</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>CEC Set Case Status New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CEC Capture email responses</fullName>
        <actions>
            <name>CEC_Set_Case_Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>CEC : Capture email responses so Case can be highlighted to an advisor</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <send>
        <fullName>EmailAsDraft</fullName>
        <action>Send</action>
        <label>EmailAsDraft</label>
        <language>en_US</language>
        <protected>false</protected>
    </send>
</Workflow>
