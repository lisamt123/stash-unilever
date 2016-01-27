<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CNF_Query_Response_Notification</fullName>
        <description>CNF Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_CNFquery_Responded</template>
    </alerts>
    <alerts>
        <fullName>CR_Query_Response_Notification</fullName>
        <description>CR Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
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
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
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
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
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
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
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
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_PWO_query_Responded</template>
    </alerts>
    <alerts>
        <fullName>TNF_Query_Response_Notification</fullName>
        <description>TNF Query Response Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>CAP_SMT_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CPA_Email_Template/CPA_TNF_query_Responded</template>
    </alerts>
    <rules>
        <fullName>CPA CNF Query Response Notification</fullName>
        <actions>
            <name>CNF_Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.CNF_ID__c   &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
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
            <name>PWO_Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.PWO_ID__c &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA PWORF Query Response Notification</fullName>
        <actions>
            <name>Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.Pworf_ID__c  &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPA TNF Query Response Notification</fullName>
        <actions>
            <name>TNF_Query_Response_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>LookupCPA_Queries__r.TNF_ID__c    &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
