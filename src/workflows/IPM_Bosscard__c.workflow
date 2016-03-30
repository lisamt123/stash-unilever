<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Bosscard_deleted</fullName>
        <description>Bosscard deleted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_BOSSCARD_Deletion_Alert</template>
    </alerts>
    <alerts>
        <fullName>IPM_BOSSCARD_Archival_Mail_Alert</fullName>
        <description>IPM BOSSCARD Archival Mail Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_BOSSCARD_Archival_Mail_Alert</template>
    </alerts>
    <alerts>
        <fullName>IPM_Email_to_Notify_Auto_Deletion_of_Bosscard_after_6_months_of_inactivity</fullName>
        <description>IPM Email to Notify Auto-Deletion of Bosscard after 6 months of inactivity</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IPM_Emails/IPM_template_to_Notify_Auto_Deletion_of_Bosscard_after_6_months_of_inactivity2</template>
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
        <fullName>IPM_Bosscard_Post_Chatter_after_175days</fullName>
        <field>Used_By_Workflow_175_days__c</field>
        <formula>&apos;Post to Chatter 175 days&apos;</formula>
        <name>IPM Bosscard Post Chatter after 175days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IPM_Bosscard_Post_Chatter_after_30_days</fullName>
        <field>Used_By_Workflow_30_days__c</field>
        <formula>IF( Used_By_Workflow_30_days__c  = &apos;Date Changed&apos;, &apos;&apos;, &apos;Date Changed&apos;)</formula>
        <name>IPM Bosscard Post Chatter after 30 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
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
        <fullName>Auto Deletion Bosscard</fullName>
        <active>true</active>
        <description>AUto delete a bosscard after 6 months of no activity</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Bosscard_deleted</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IPM_Bosscard__c.IPM_Bosscard_Last_Modified_Date_Time__c</offsetFromField>
            <timeLength>183</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
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
            <offsetFromField>IPM_Bosscard__c.CreatedDate</offsetFromField>
            <timeLength>28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_BOSSCARD_Archival_Mail_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IPM_Bosscard__c.CreatedDate</offsetFromField>
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
    <rules>
        <fullName>IPM Notify Auto-Deletion of Bosscard after 175 days of Inactivity</fullName>
        <active>true</active>
        <formula>NOT( ISNULL ( LastModifiedDate ))  &amp;&amp;  ISBLANK(Used_By_Workflow_175_days__c) &amp;&amp;   ISPICKVAL(IPM_Bosscard_Status__c  , &apos;In Progress&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_Email_to_Notify_Auto_Deletion_of_Bosscard_after_6_months_of_inactivity</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>IPM_Bosscard_Post_Chatter_after_175days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Bosscard__c.LastModifiedDate</offsetFromField>
            <timeLength>175</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>IPM Notify Auto-Deletion of Bosscard after 30 days of Inactivity</fullName>
        <active>true</active>
        <formula>ISPICKVAL(IPM_Bosscard_Status__c  , &apos;In Progress&apos;) &amp;&amp; ( Used_By_Workflow_30_days__c  = &apos;Date Changed&apos; ||  Used_By_Workflow_30_days__c = &apos;&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IPM_Bosscard_Post_Chatter_after_30_days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IPM_Bosscard__c.LastModifiedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
