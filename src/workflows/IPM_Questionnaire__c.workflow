<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IPM_PopulateQuestionnaireExtId</fullName>
        <description>This populates External_Id__c field of IPM_Questionnaire__c.</description>
        <field>External_Id__c</field>
        <formula>IF(OR(ISBLANK(IPM_Project__r.Project_External_ID__c),ISNULL(IPM_Project__r.Project_External_ID__c)) , IPM_Project__r.Name, IPM_Project__r.Project_External_ID__c) +
 TEXT(IPM_RQS_Gate_Type__c) +   SUBSTITUTE( RecordType.Name, &apos; &apos;, &apos;_&apos;)  + TEXT(IPM_Sequence_Number__c)</formula>
        <name>IPM_PopulateQuestionnaireExtId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM_PopulateQuestionnaireExtId</fullName>
        <actions>
            <name>IPM_PopulateQuestionnaireExtId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Questionnaire__c.Is_Master__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This  populates External_Id__c field  of  IPM_Questionnaire__c.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
