<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Publisher_Quote_Field_Update_null</fullName>
        <description>Publisher Quote Field Update to null when run cost applicable is no</description>
        <field>txt_Run_Cost_Publisher__c</field>
        <formula>null</formula>
        <name>SAM Publisher Quote Field Update null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Publisher_Quote_Field_Update</fullName>
        <field>txt_Run_Cost_Publisher__c</field>
        <formula>txt_Publisher__c</formula>
        <name>SAM Publisher Quote Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Quote_Record_type_update_to_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Quote_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Quote Record type update to RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Quote_Record_type_update_to_RW</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Quote_RW</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Quote Record type update to RW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Quote_Record_type_update_to_RW_RO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>SAM_Quote_RW_RO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>SAM Quote Record type update to RW/RO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Software_Name_Field_Update</fullName>
        <field>txt_Software_Name__c</field>
        <formula>Name</formula>
        <name>SAM Software Name Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Software_Name_Field_Update_null</fullName>
        <description>Software name field update to null when run cost is no</description>
        <field>txt_Software_Name__c</field>
        <formula>null</formula>
        <name>SAM Software Name Field Update null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAM_Update_Quotation_Number</fullName>
        <field>num_Quotation_Number__c</field>
        <formula>md_Request__r.Quotation_Record_Count__c + 1</formula>
        <name>Update Quotation Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assign Quotation Number</fullName>
        <actions>
            <name>SAM_Update_Quotation_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAM Publisher Quote Field Update</fullName>
        <actions>
            <name>SAM_Publisher_Quote_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update publisher if run cost applicable is yes</description>
        <formula>AND(( ISPICKVAL( pkl_Run_Cost_Applicable__c , &apos;Yes&apos;) ), OR(ISCHANGED( txt_Publisher__c ) ,ISCHANGED( pkl_Run_Cost_Applicable__c ), ISNEW() ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAM Publisher SW Name Quote Field Update null</fullName>
        <actions>
            <name>Publisher_Quote_Field_Update_null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAM_Software_Name_Field_Update_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Run_Cost_Applicable__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>Publisher and software name Quote Field Update to null when run cost applicable is no</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Quotation Record type update to Quote RO</fullName>
        <actions>
            <name>SAM_Quote_Record_type_update_to_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Quote Provided</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Awaiting Charge</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Charging In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>On Hold</value>
        </criteriaItems>
        <description>SAM Quotation Record type update to Quote RO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Quotation Record type update to Quote RO%2FRW</fullName>
        <actions>
            <name>SAM_Quote_Record_type_update_to_RW_RO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8</booleanFilter>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Quote Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Awaiting CC details (Pending with ULEMP)</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>CC details provided (By ULEMP)</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Charging Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Details Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Details Provided</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Charging Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Awaiting CC details (Pending with ULSMT)</value>
        </criteriaItems>
        <description>SAM Quotation Record type update to Quote RO/RW</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Quotation Record type update to Quote RW</fullName>
        <actions>
            <name>SAM_Quote_Record_type_update_to_RW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6</booleanFilter>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Draft Quote Provided</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Quote Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>SAM_Quote_Line_Item__c.pkl_Request_status__c</field>
            <operation>equals</operation>
            <value>Information Provided</value>
        </criteriaItems>
        <description>SAM Quotation Record type update to Quote RW</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAM Software Name Field Update</fullName>
        <actions>
            <name>SAM_Software_Name_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update software name if run cost applicable is yes</description>
        <formula>AND(( ISPICKVAL( pkl_Run_Cost_Applicable__c , &apos;Yes&apos;) ), OR(ISCHANGED( Name ) ,ISCHANGED( pkl_Run_Cost_Applicable__c ), ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
