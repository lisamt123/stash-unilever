<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CPA_PWO_Query_Response_Notification</fullName>
        <description>CPA PWO Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Query_Creator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWO_query_Responded</template>
    </alerts>
    <alerts>
        <fullName>CPA_Query_Response_Notification</fullName>
        <description>CPA Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Query_Creator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWORF_query_Responded</template>
    </alerts>
    <alerts>
        <fullName>CR_Query_Response_Notification</fullName>
        <description>CR Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Query_Creator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_CR_query_Responded</template>
    </alerts>
    <alerts>
        <fullName>HLE_Request_Query_Response_Notification</fullName>
        <description>HLE Request Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Query_Creator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_HLE_REquestquery_Responded</template>
    </alerts>
    <alerts>
        <fullName>LOI_Query_Response_Notification</fullName>
        <description>LOI Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Query_Creator__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_LOI_query_Responded</template>
    </alerts>
    <alerts>
        <fullName>PWO_Query_Response_Notification</fullName>
        <description>PWO Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWO_query_Responded</template>
    </alerts>
    <alerts>
        <fullName>Query_Response_Notification</fullName>
        <description>Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>eml_SMT_group_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWO_query_Responded</template>
    </alerts>
    <fieldUpdates>
        <fullName>CPA_Query_response_SMT_group_email</fullName>
        <field>eml_SMT_group_email__c</field>
        <formula>&quot;Vivek.Kalidoss@unilever.com&quot;</formula>
        <name>CPA Query response SMT group email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPA_Query_response_VDM_group_email</fullName>
        <field>eml_VDM_group_email__c</field>
        <formula>&quot;Sameer.Vaidya@unilever.com&quot;</formula>
        <name>CPA Query response VDM group email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CPA CR Query Response Notification</fullName>
        <actions>
            <name>CR_Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.CR_ID__c  &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA HLE Request Query Response Notification</fullName>
        <actions>
            <name>HLE_Request_Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.HLE_ID__c     &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA LOI Query Response Notification</fullName>
        <actions>
            <name>LOI_Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.LOI_ID__c &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWO Query Response Notification</fullName>
        <actions>
            <name>CPA_PWO_Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.PWO_ID__c &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Query Response Notification</fullName>
        <actions>
            <name>CPA_Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.Pworf_ID__c  &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA Query Response clone%2Fnew</fullName>
        <actions>
            <name>CPA_Query_response_SMT_group_email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CPA_Query_response_VDM_group_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CPA_Query_comment__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
