<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>ICB_Create_Event</fullName>
        <apiVersion>37.0</apiVersion>
        <endpointUrl>https://importschedulevisits-qa.eu.cloudhub.io/createEvents</endpointUrl>
        <fields>Id</fields>
        <fields>Title</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>ronaldo.c.garcia@accenture.com</integrationUser>
        <name>ICB Create Event</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ICB Create Event</fullName>
        <actions>
            <name>ICB_Create_Event</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>FeedItem.CreatedById</field>
            <operation>contains</operation>
            <value>Ronaldo</value>
        </criteriaItems>
        <criteriaItems>
            <field>FeedItem.CreatedById</field>
            <operation>contains</operation>
            <value>Thiago</value>
        </criteriaItems>
        <criteriaItems>
            <field>FeedItem.CreatedById</field>
            <operation>contains</operation>
            <value>Antonio</value>
        </criteriaItems>
        <criteriaItems>
            <field>FeedItem.CreatedById</field>
            <operation>contains</operation>
            <value>Jessica</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
