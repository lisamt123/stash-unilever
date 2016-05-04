<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CEC_First_Response_Email_Field_Update</fullName>
        <field>First_Response_Date__c</field>
        <formula>NOW()</formula>
        <name>CEC First Response Email Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
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
    <rules>
        <fullName>CEC First Response Email</fullName>
        <actions>
            <name>CEC_First_Response_Email_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.First_Response_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>CEC: Stamping A &quot;First Response&quot; Field When An Email Goes Out On A Case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <send>
        <fullName>EmailAsDraft</fullName>
        <action>Send</action>
        <label>EmailAsDraft</label>
        <language>en_US</language>
        <protected>false</protected>
    </send>
</Workflow>
