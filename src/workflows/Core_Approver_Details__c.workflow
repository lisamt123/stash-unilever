<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Core_CA_IP_Ariba_OutboundMessage</fullName>
        <apiVersion>33.0</apiVersion>
        <description>Outbound Call for Ariba Approve/Reject Notifications</description>
        <endpointUrl>https://sbi.ariba.cloudhub.unileverservices.com:8082/PurchaseResponse</endpointUrl>
        <fields>Comments__c</fields>
        <fields>CurrentDateTime__c</fields>
        <fields>Header_ExternalId__c</fields>
        <fields>Id</fields>
        <fields>Interested_Party_Email__c</fields>
        <fields>Status__c</fields>
        <fields>Visible_to_Supplier__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ariba.system@unilever.com</integrationUser>
        <name>Core CA IP Ariba OutboundMessage</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Core_CA_IP_GTES_Approve_OutboundMessage</fullName>
        <apiVersion>33.0</apiVersion>
        <description>Outbound Call for GTES Approve Notifications.</description>
        <endpointUrl>https://sbi.gtes.cloudhub.unileverservices.com:8081/SendGTESFormApprove</endpointUrl>
        <fields>Header_ExternalId__c</fields>
        <fields>Id</fields>
        <fields>Interested_Party_Email__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>gtes.system@unilever.com</integrationUser>
        <name>Core CA IP GTES Approve OutboundMessage</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Core_CA_IP_GTES_Reject_OutboundMessage</fullName>
        <apiVersion>33.0</apiVersion>
        <description>Outbound Call for GTES Reject Notifications.</description>
        <endpointUrl>https://sbi.gtes.cloudhub.unileverservices.com:8081/SendGTESFormReturn</endpointUrl>
        <fields>Comments__c</fields>
        <fields>Header_ExternalId__c</fields>
        <fields>Id</fields>
        <fields>Interested_Party_Email__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>gtes.system@unilever.com</integrationUser>
        <name>Core CA IP GTES Reject OutboundMessage</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Core CA GTES Approve Notifications WF Rule</fullName>
        <actions>
            <name>Core_CA_IP_GTES_Approve_OutboundMessage</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>GTES</value>
        </criteriaItems>
        <description>GTES Approve Notifications</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Core CA GTES Reject Notifications WF Rule</fullName>
        <actions>
            <name>Core_CA_IP_GTES_Reject_OutboundMessage</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>GTES</value>
        </criteriaItems>
        <description>GTES Reject Notifications</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Core CA IP Ariba Approve WF Rule</fullName>
        <actions>
            <name>Core_CA_IP_Ariba_OutboundMessage</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Ariba</value>
        </criteriaItems>
        <description>Ariba Approve Notifications</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Core CA IP Ariba Reject WF Rule</fullName>
        <actions>
            <name>Core_CA_IP_Ariba_OutboundMessage</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Ariba</value>
        </criteriaItems>
        <description>Ariba Reject Notifications</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
