<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>IPM_BOSSCARD_Archival_Mail_Alert</fullName>
        <description>IPM BOSSCARD Archival Mail Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/IPM_BOSSCARD_Archival_Mail_Alert</template>
    </alerts>
    <fieldUpdates>
        <fullName>IPM_BOSSCARD_Archival_Update</fullName>
        <field>IPM_Is_Archived__c</field>
        <literalValue>1</literalValue>
        <name>IPM BOSSCARD Archival Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Update_Bosscard_Approval_Date</fullName>
        <field>IPM_Bosscord_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Bosscard Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IPM_Bosscard_Name</fullName>
        <field>Name</field>
        <formula>IPM_BosscardName__c</formula>
        <name>Update IPM Bosscard Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Bosscard Approval Date</fullName>
        <actions>
            <name>IPM_Update_Bosscard_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Bosscard__c.IPM_Is_Accepted__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IPM BOSSCARD Archival On Inactive</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IPM_Bosscard__c.IPM_Is_Archived__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>IPM_Bosscard__c.IPM_Bosscard_Last_Modified_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Archive a Bosscard if Inactive for More than 4 Weeks.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_BOSSCARD_Archival_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Bosscard__c.LastModifiedDate</offsetFromField>
            <timeLength>28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_BOSSCARD_Archival_Mail_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IPM_Bosscard__c.LastModifiedDate</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>IPM Bosscard Name Updation</fullName>
        <actions>
            <name>Update_IPM_Bosscard_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IPM_Bosscard__c.IPM_BosscardName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
