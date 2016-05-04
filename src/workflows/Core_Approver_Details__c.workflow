<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Core_CA_ActionDate_Field_Update</fullName>
        <field>Action_Date__c</field>
        <formula>LastModifiedDate</formula>
        <name>Core CA ActionDate Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
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
        <fullName>Core_CA_IP_Clarity_OutboundMessage</fullName>
        <apiVersion>36.0</apiVersion>
        <endpointUrl>https://sbi.clarity.cloudhub.unileverservices.com:8082/ClaritySalesforceResponseService</endpointUrl>
        <fields>Comments__c</fields>
        <fields>CurrentDateTime__c</fields>
        <fields>Employee_No__c</fields>
        <fields>Header_ExternalId__c</fields>
        <fields>Id</fields>
        <fields>Interested_Party_Email__c</fields>
        <fields>Role__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>clarity.system@unilever.com.prod</integrationUser>
        <name>Core CA IP Clarity OutboundMessage</name>
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
    <outboundMessages>
        <fullName>Core_CA_IP_Invoice_OutboundMessage</fullName>
        <apiVersion>36.0</apiVersion>
        <endpointUrl>http://52.19.177.104:8081/DciwSalesforceResponseService</endpointUrl>
        <fields>Comments__c</fields>
        <fields>CurrentDateTime__c</fields>
        <fields>Header_ExternalId__c</fields>
        <fields>Id</fields>
        <fields>Interested_Party_Email__c</fields>
        <fields>Status__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>invoice.system@unilever.com</integrationUser>
        <name>Core CA IP Invoice OutboundMessage</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Core CA ActionDate WF Rule</fullName>
        <actions>
            <name>Core_CA_ActionDate_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1) AND ((2) OR (3) OR (4))</booleanFilter>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Query With Vendor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Return to AP</value>
        </criteriaItems>
        <description>It will update action date to last modify if source system is Invoice.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Core CA Clarity Notifications WF Rule</fullName>
        <actions>
            <name>Core_CA_IP_Clarity_OutboundMessage</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Clarity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Rework</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
    <rules>
        <fullName>Core CA Invoice Notifications WF Rule</fullName>
        <actions>
            <name>Core_CA_IP_Invoice_OutboundMessage</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 )</booleanFilter>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Return to AP</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Core CA Invoice QWV Notifications WF Rule</fullName>
        <actions>
            <name>Core_CA_IP_Invoice_OutboundMessage</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Core_Approver_Details__c.Source_System__c</field>
            <operation>equals</operation>
            <value>Invoice</value>
        </criteriaItems>
        <criteriaItems>
            <field>Core_Approver_Details__c.Status__c</field>
            <operation>equals</operation>
            <value>Query With Vendor</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
