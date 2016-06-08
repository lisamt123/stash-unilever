<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CPA_UDA_isdocusigned_true</fullName>
        <field>chk_isDocusignedRecord__c</field>
        <literalValue>1</literalValue>
        <name>CPA UDA isdocusigned true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CPA UDA isdocusigned true</fullName>
        <actions>
            <name>CPA_UDA_isdocusigned_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_User_Defined_Attribute__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LOI docusign,CR docusign,PWO docusign</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
