<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>BEN Category Detail Created</fullName>
        <actions>
            <name>BEN_In_Approval_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BEN_Mark_for_Deletion_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BEN_Record_Type_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BEN_Status_Saved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>BEN_Category_Details__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>To update new category detail record when cloned</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>BEN Category detail submission</fullName>
        <actions>
            <name>BEN_Submitted_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>to calculate the date of submission</description>
        <formula>AND(ISCHANGED( pkl_Status__c ), ISPICKVAL( pkl_Status__c , &apos;Submitted&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
