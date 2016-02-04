<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_IRR_Local_From_Global</fullName>
        <field>IRR_Local__c</field>
        <formula>IRR_Global__c</formula>
        <name>Copy IRR Local From Global</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_IRR_Local_From_Regional</fullName>
        <field>IRR_Local__c</field>
        <formula>IRR_Regional__c</formula>
        <name>Copy IRR Local From Regional</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_IRR_Regional_From_Global</fullName>
        <field>IRR_Regional__c</field>
        <formula>IRR_Global__c</formula>
        <name>Copy IRR Regional From Global</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_IRR_Regional_From_Local</fullName>
        <field>IRR_Regional__c</field>
        <formula>IRR_Local__c</formula>
        <name>Copy IRR Regional From Local</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Set_Misaligned_Date</fullName>
        <field>Misaligned_Date__c</field>
        <formula>TODAY()</formula>
        <name>IPM_Set Misaligned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IRR_Charter_Copy_Over</fullName>
        <field>IRR_Charter__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), IRR_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),IRR_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),IRR_Local__c,0)))</formula>
        <name>IRR Charter Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IRR_Contract_Copy_Over</fullName>
        <field>IRR_Contract__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), IRR_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),IRR_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),IRR_Local__c,0)))</formula>
        <name>IRR Contract Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IRR_Market_Deployment_Copy_Over</fullName>
        <field>IRR_MD__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), IRR_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),IRR_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),IRR_Local__c,0)))</formula>
        <name>IRR Market Deployment Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IRR_Market_Ready_Copy_Over</fullName>
        <field>IRR_MR__c</field>
        <formula>IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Global&apos;), IRR_Global__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Regional&apos;),IRR_Regional__c,IF(ISPICKVAL(IPM_Financial_Postfix__c,&apos;Local&apos;),IRR_Local__c,0)))</formula>
        <name>IRR Market Ready Copy Over</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MisalignmentDateTime</fullName>
        <field>MisalignmentDateTime__c</field>
        <formula>now()</formula>
        <name>MisalignmentDateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Financial IRR Global To Local</fullName>
        <actions>
            <name>Copy_IRR_Local_From_Global</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Global_to_Local__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Financial IRR Global To Regional</fullName>
        <actions>
            <name>Copy_IRR_Regional_From_Global</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Global_to_Regional__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Financial IRR Local To Regional</fullName>
        <actions>
            <name>Copy_IRR_Regional_From_Local</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Local_to_Regional__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy Financial IRR Regional To Local</fullName>
        <actions>
            <name>Copy_IRR_Local_From_Regional</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Copy_Regional_to_Local__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Charter Approved</fullName>
        <actions>
            <name>IRR_Charter_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Charter_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Contract Approved</fullName>
        <actions>
            <name>IRR_Contract_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>Contract_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Market Deployment Approved</fullName>
        <actions>
            <name>IRR_Market_Deployment_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>MD_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Financial Market Ready Approved</fullName>
        <actions>
            <name>IRR_Market_Ready_Copy_Over</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Currently doing it using Workflow because of Process Builder known defect of not properly copying over Percentage Fields.</description>
        <formula>MR_Approved__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM_Calculate Misaligned Date</fullName>
        <actions>
            <name>IPM_Set_Misaligned_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MisalignmentDateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(AND( Misaligned__c,  ISCHANGED( Misaligned__c )),  true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
