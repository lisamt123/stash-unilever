<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CR_Ownership_Reassignment_Notification</fullName>
        <description>CR Ownership Reassignment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_CR_Query_Reassigned</template>
    </alerts>
    <alerts>
        <fullName>CR_Query_Notification</fullName>
        <description>CR Query Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_CR_query_Submitted</template>
    </alerts>
    <alerts>
        <fullName>HLE_Request_Query_Notification</fullName>
        <description>HLE Request Query Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_HLE_REquest_query_Submitted</template>
    </alerts>
    <alerts>
        <fullName>LOI_Query_Notification</fullName>
        <description>LOI Query Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_query_Submitted</template>
    </alerts>
    <alerts>
        <fullName>LOI_Query_Ownership_Reassignment</fullName>
        <description>LOI Query Ownership Reassignment</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_Query_Reassigned</template>
    </alerts>
    <alerts>
        <fullName>PWORF_Ownership_Reassignment</fullName>
        <description>PWORF Ownership Reassignment</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_Query_Reassigned</template>
    </alerts>
    <alerts>
        <fullName>PWORF_Query_Submit_Notification</fullName>
        <description>PWORF Query Submit Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_query_Submitted</template>
    </alerts>
    <alerts>
        <fullName>PWO_Query_Notification</fullName>
        <description>PWO Query Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWO_query_Submitted</template>
    </alerts>
    <alerts>
        <fullName>PWO_Query_Reassignment</fullName>
        <description>PWO Query Reassignment</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWO_Query_Reassigned</template>
    </alerts>
    <rules>
        <fullName>CPA CR Query Notification</fullName>
        <actions>
            <name>CR_Query_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_Queries__c.CR_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA CR Query Reassignment Notification</fullName>
        <actions>
            <name>CR_Ownership_Reassignment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(   CR_ID__c    &lt;&gt; null) &amp;&amp;  ISCHANGED(  Assigned_to__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA HLE Request Query Notification</fullName>
        <actions>
            <name>HLE_Request_Query_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_Queries__c.HLE_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Query Notification</fullName>
        <actions>
            <name>LOI_Query_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_Queries__c.LOI_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Query Reassignment Notification</fullName>
        <actions>
            <name>LOI_Query_Ownership_Reassignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(   LOI_ID__c    &lt;&gt; null) &amp;&amp;  ISCHANGED(  Assigned_to__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Query Notification</fullName>
        <actions>
            <name>PWO_Query_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_Queries__c.PWO_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Query Reassignment Notification</fullName>
        <actions>
            <name>PWO_Query_Reassignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>( PWO_ID__c  &lt;&gt; null) &amp;&amp;  ISCHANGED(  Assigned_to__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Query Notification</fullName>
        <actions>
            <name>PWORF_Query_Submit_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_Queries__c.Pworf_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Query Reassignment Notification</fullName>
        <actions>
            <name>PWORF_Ownership_Reassignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(  Pworf_ID__c   &lt;&gt; null) &amp;&amp;  ISCHANGED(  Assigned_to__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
