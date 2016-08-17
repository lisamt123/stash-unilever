<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SAM_Product_IBM_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_IBM_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product IBM RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_IBM_RW</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_IBM_RW</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product IBM RW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_Microsoft_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Microsoft_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product Microsoft RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_Microsoft_RW</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Microsoft_RW</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product Microsoft RW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_Oracle_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Oracle_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product Oracle RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_Oracle_RW</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Oracle_RW</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product Oracle RW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_Other_Product_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Other_Product_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product Other Product RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_Other_Product_RW</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Other_Product_RW</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product Other Product RW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_SAP_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_SAP_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product SAP RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Product_SAP_RW</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_SAP_RW</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Product SAP RW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SAM Product IBM RO</fullName>
        <actions>
            <name>SAM_Product_IBM_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IBM</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Information Provided</value>
        </criteriaItems>
        <description>SAM Product IBM RO when status is Open,Information Provided.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product IBM RW</fullName>
        <actions>
            <name>SAM_Product_IBM_RW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SAM_IBM_RO</value>
        </criteriaItems>
        <description>SAM Product IBM  RW  when status is Awaiting Information.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product Microsoft RO</fullName>
        <actions>
            <name>SAM_Product_Microsoft_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Microsoft</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Information Provided</value>
        </criteriaItems>
        <description>SAM Product Microsoft  RO when status is Open,Information Provided.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product Microsoft RW</fullName>
        <actions>
            <name>SAM_Product_Microsoft_RW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SAM_Microsoft_RO</value>
        </criteriaItems>
        <description>SAM Product Microsoft  RW  when status is Awaiting Information.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product Oracle RO</fullName>
        <actions>
            <name>SAM_Product_Oracle_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Oracle</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Information Provided</value>
        </criteriaItems>
        <description>SAM Product Oracle  RO when status is Open,Information Provided.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product Oracle RW</fullName>
        <actions>
            <name>SAM_Product_Oracle_RW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SAM_Oracle_RO</value>
        </criteriaItems>
        <description>SAM Product Oracle RW  when status is Awaiting Information.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product Other Product RO</fullName>
        <actions>
            <name>SAM_Product_Other_Product_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Other Product</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Information Provided</value>
        </criteriaItems>
        <description>SAM Product Other Product RO when status is Open,Information Provided.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product Other Product RW</fullName>
        <actions>
            <name>SAM_Product_Other_Product_RW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SAM_Other_Product_RO</value>
        </criteriaItems>
        <description>SAM Product Other Product RW  when status is Awaiting Information.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product SAP RO</fullName>
        <actions>
            <name>SAM_Product_SAP_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SAP</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Information Provided</value>
        </criteriaItems>
        <description>SAM Product SAP  RO when status is Open,Information Provided.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Product SAP RW</fullName>
        <actions>
            <name>SAM_Product_SAP_RW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.pkl_Request_Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Request_Line_Item__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SAM_SAP_RO</value>
        </criteriaItems>
        <description>SAM Product SAP RW when status is Awaiting Information.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
