<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IPM_Email_TO_PL</fullName>
        <description>IPM_Email_TO_PL</description>
        <protected>false</protected>
        <recipients>
            <field>IPM_Project_L_eader_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IPM_Emails/IPM_PL_Email2</template>
    </alerts>
    <fieldUpdates>
        <fullName>IPM_Field_Update_Negotiable</fullName>
        <field>IPM_Negotiable__c</field>
        <literalValue>0</literalValue>
        <name>IPM Field Update Negotiable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Notify_Update</fullName>
        <field>IPM_Notify_Team__c</field>
        <literalValue>0</literalValue>
        <name>IPM_Notify_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Update</fullName>
        <description>To store the composite key of Project Document External Id +Section Sequence+ Document Suffix</description>
        <field>Project_Doc_Section_Ext_Id__c</field>
        <formula>IPM_Project_Document__r.External_Id__c  &amp; &apos;_&apos; &amp;  IPM_Section_Sequence__c  &amp; &apos;_&apos; &amp;  IPM_Section__r.IPM_DocSecSuffix__c</formula>
        <name>IPM Update Project Doc Sec External Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Update_Notify_PL</fullName>
        <field>IPM_Notify_Team__c</field>
        <literalValue>0</literalValue>
        <name>IPM_Update_Notify_PL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_update_notify</fullName>
        <field>IPM_Notify_Team__c</field>
        <literalValue>0</literalValue>
        <name>IPM update notify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PD_Section_Name</fullName>
        <field>Name</field>
        <formula>LEFT(IPM_Project_Document__r.IPM_Project__r.IPM_Project_Name__c  + &apos;-&apos; +TEXT(IPM_Project_Document__r.IPM_GateDocuments__c) + &apos;-&apos; +   IPM_Section_Sequence_Number__c, 78)</formula>
        <name>Update PD Section Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IPM External Id DocSufix</fullName>
        <actions>
            <name>IPM_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To support Data migration a composite field needs to be updated</description>
        <formula>NOT( ISNULL(IPM_Project_Document__r.External_Id__c) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IPM Make Default Section Mandatory</fullName>
        <actions>
            <name>IPM_Field_Update_Negotiable</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project_Document_Section__c.IPM_Default_Section__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM Notify PL</fullName>
        <actions>
            <name>IPM_update_notify</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project_Document_Section__c.IPM_Notify_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>IPM_Notify_TO_PL</fullName>
        <actions>
            <name>IPM_Email_TO_PL</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>IPM_Notify_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IPM_Notify_Team__c=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM_Send_Mail_PL</fullName>
        <actions>
            <name>IPM_Update_Notify_PL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Project_Document_Section__c.IPM_Notify_Team__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rename Project Document Section</fullName>
        <actions>
            <name>Update_PD_Section_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
