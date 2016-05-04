<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WINatPOS_Email_Notification_for_Scheduled_Asset_Deletion</fullName>
        <description>WINatPOS Email Notification for Scheduled Asset Deletion</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Additional_Owner_1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Additional_Owner_2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WINatPOS_Scheduled_Asset_Delete_Notification_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>WINatPOS_Clear_Asset_Delete_Date</fullName>
        <field>Scheduled_Delete_Date__c</field>
        <name>WINatPOS Clear Asset Delete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WINatPOS_Set_Asset_Delete_Date</fullName>
        <field>Scheduled_Delete_Date__c</field>
        <formula>TODAY() + 5</formula>
        <name>WINatPOS Set Asset Delete Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_Set_AssetType_Keyword_Search</fullName>
        <field>POS_Asset_Type_for_KeyWord_Search__c</field>
        <formula>TEXT(POS_Asset_Type__c)</formula>
        <name>WinatPOS Set AssetType Keyword Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_Set_BrandName_KeyWord_Search</fullName>
        <field>Brand_Name_For_KeyWord_Search__c</field>
        <formula>Brand__r.Name</formula>
        <name>WinatPOS Set BrandName KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_Set_Cat_Name_KeyWord_Search</fullName>
        <field>Category_Name_for_KeyWord_Search__c</field>
        <formula>Category__r.Name</formula>
        <name>WinatPOS Set Cat Name KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_Set_Cluster_for_KeyWord_Search</fullName>
        <field>Market_Cluster_for_KeyWord_Search__c</field>
        <formula>TEXT(Market_Cluster__c)</formula>
        <name>WinatPOS Set Cluster for KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_Set_Country_for_KeyWord_Search</fullName>
        <field>Country_for_KeyWord_Search__c</field>
        <formula>TEXT(Country__c)</formula>
        <name>WinatPOS Set Country for KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WinatPOS_Set_Touchpoint_KeyWord_Search</fullName>
        <field>Touchpoint_for_KeyWord_Search__c</field>
        <formula>TEXT( Touchpoint__c)</formula>
        <name>WinatPOS Set Touchpoint KeyWord Search</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>WINatPOS Asset Dont_Delete</fullName>
        <actions>
            <name>WINatPOS_Clear_Asset_Delete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset__c.Status__c</field>
            <operation>notEqual</operation>
            <value>ToDelete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WINatPOS Scheduled Asset Delete Notification</fullName>
        <actions>
            <name>WINatPOS_Email_Notification_for_Scheduled_Asset_Deletion</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>WINatPOS_Set_Asset_Delete_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Asset__c.Status__c</field>
            <operation>equals</operation>
            <value>ToDelete</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS Asset Type for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_Set_AssetType_Keyword_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS Brand Name for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_Set_BrandName_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS Category Name for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_Set_Cat_Name_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS Cluster for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_Set_Cluster_for_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS Country for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_Set_Country_for_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WinatPOS Touchpoint for KeyWord Search</fullName>
        <actions>
            <name>WinatPOS_Set_Touchpoint_KeyWord_Search</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
