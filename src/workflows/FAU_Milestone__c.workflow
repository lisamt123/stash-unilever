<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Due_date</fullName>
        <field>FAU_Due_Date__c</field>
        <formula>Case( Name , 
&quot;IDP-Meeting with LM&quot;,  FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -56,
&quot;Impact Map-Pre-read&quot;, FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -14,
&quot;Business Simulation Pre-read&quot;, FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -14,
&quot;Review IDP &amp; Impact Map with LM&quot;,  FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +7,
&quot;Submit IDP&quot;, FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +28,
&quot;Coaching with CiaB&quot;, FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +168,
&quot;Implement 70/20/10&quot;, 
FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +168,
&quot;Talent Completion&quot;, 
FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +175,
&quot;360 Benchmark&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -28,
&quot;Influence Style Indicator&quot;,
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -28,
&quot;Debrief call with CCL coach&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -14,
&quot;Feedback that works&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -14,
&quot;Complete 5 Career Questions&quot;,
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -7,
&quot;LM 90 minutes meeting&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3,
&quot;Draft IDP&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3,
&quot;On the Job Experience (70)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -42,
&quot;Coaching and Mentoring (20)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -42,
&quot;Meeting with LM&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -28,
&quot;Formal Learning (10)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -14,
&quot;Pre-work before Module 2&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -14,
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -14)</formula>
        <name>Due date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_Reminder_date</fullName>
        <field>FAU_1st_Reminder__c</field>
        <formula>Case( Name , 
&quot;IDP-Meeting with LM&quot;,  FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -28,
&quot;Impact Map-Pre-read&quot;, FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -7,
&quot;Business Simulation Pre-read&quot;, FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -7,
&quot;Review IDP &amp; Impact Map with LM&quot;,  FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +3,
&quot;Submit IDP&quot;, FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +14,
&quot;Coaching with CiaB&quot;, FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +175,
&quot;Implement 70/20/10&quot;, 
FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +175,
&quot;Talent Completion&quot;, 
FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +178,
&quot;360 Benchmark&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -14,
&quot;Influence Style Indicator&quot;,
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -21,
&quot;Debrief call with CCL coach&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -7,
&quot;Feedback that works&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -7,
&quot;Complete 5 Career Questions&quot;,
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3,
&quot;LM 90 minutes meeting&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3,
&quot;Draft IDP&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3,
&quot;On the Job Experience (70)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -35,
&quot;Coaching and Mentoring (20)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -35,
&quot;Meeting with LM&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -14,
&quot;Formal Learning (10)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -7,
&quot;Pre-work before Module 2&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -7,
NULL)</formula>
        <name>First-Reminder date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Second_Reminder_Date</fullName>
        <description>This field update is to set the 2nd Reminder date of Milestone for HP2 and HP3 Programs</description>
        <field>FAU_2nd_Reminder__c</field>
        <formula>Case( Name , 
&quot;IDP-Meeting with LM&quot;, FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -14, 
&quot;Impact Map-Pre-read&quot;, FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3, 
&quot;Business Simulation Pre-read&quot;, FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3, 
&quot;Review IDP &amp; Impact Map with LM&quot;, FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +2, 
&quot;Submit IDP&quot;, FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +7, 
&quot;Coaching with CiaB&quot;, FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +182, 
&quot;Implement 70/20/10&quot;, 
FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +182, 
&quot;Talent Completion&quot;, 
FAU_Program_Wave__r.FAU_End_Date_of_Module_1__c +182, 
&quot;360 Benchmark&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -7, 
&quot;Influence Style Indicator&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -14, 
&quot;Debrief call with CCL coach&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3, 
&quot;Feedback that works&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -3, 
&quot;Complete 5 Career Questions&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -2, 
&quot;LM 90 minutes meeting&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -2, 
&quot;Draft IDP&quot;, 
FAU_Program_Wave__r.FAU_Start_Date_of_Module_1__c -2, 
&quot;On the Job Experience (70)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -28, 
&quot;Coaching and Mentoring (20)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -28, 
&quot;Meeting with LM&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -7, 
&quot;Formal Learning (10)&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -3, 
&quot;Pre-work before Module 2&quot;, 
FAU_Program_Wave__r.Start_Date_of_Module_2__c -3, 
NULL)</formula>
        <name>Second Reminder Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FAU Milestone Dates</fullName>
        <actions>
            <name>Due_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>First_Reminder_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Second_Reminder_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>FAU_Milestone__c.Name</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Program__c.FAU_Program_Type__c</field>
            <operation>equals</operation>
            <value>HP2</value>
        </criteriaItems>
        <criteriaItems>
            <field>FAU_Program__c.FAU_Program_Type__c</field>
            <operation>equals</operation>
            <value>HP3</value>
        </criteriaItems>
        <description>This workflow sets the dates for Milestones as required for HP2 and HP3 Program types</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
