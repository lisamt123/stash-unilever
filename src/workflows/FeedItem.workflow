<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>ICB_Send_Request_To_MuleSoft</fullName>
        <apiVersion>36.0</apiVersion>
        <description>Testing the outbound message to upload file on chatter.</description>
        <endpointUrl>https://importschedulevisits-dev.cloudhub.io/createEvents</endpointUrl>
        <fields>Id</fields>
        <fields>Title</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ronaldo.c.garcia@accenture.com</integrationUser>
        <name>ICB_Send_Request_To_MuleSoft</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ICB Chatter Post</fullName>
        <actions>
            <name>ICB_Send_Request_To_MuleSoft</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <description>Call outbound message to start the service to process the file posted on chatter.</description>
        <formula>CONTAINS(CreatedBy:User.Username , $Label.ICB_ROADNET_CREATED_BY_NAME)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
