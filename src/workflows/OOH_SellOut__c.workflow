<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>GSV_LOST_Flag_To_True</fullName>
        <field>GSV_Lost_Flag__c</field>
        <literalValue>1</literalValue>
        <name>GSV LOST Flag To True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GSV_LOST_Flag_to_false</fullName>
        <field>GSV_Lost_Flag__c</field>
        <literalValue>0</literalValue>
        <name>GSV LOST Flag to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GSV_LOST_flag</fullName>
        <field>OOH_GSVLostFlag__c</field>
        <literalValue>1</literalValue>
        <name>GSV LOST flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OOH_PointOFSaleOutlet__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lost_GSV_flag</fullName>
        <field>OOH_GSVLostFlag__c</field>
        <literalValue>0</literalValue>
        <name>Lost GSV flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OOH_PointOFSaleOutlet__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OOH_GSV_LOST</fullName>
        <field>OOH_GSVLostValue__c</field>
        <formula>OOH_GSV__c</formula>
        <name>GSV LOST</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OOH_PointOFSaleOutlet__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OOH_GSV_Lost_Flag</fullName>
        <field>OOH_GSVLostFlag__c</field>
        <literalValue>1</literalValue>
        <name>GSV LOST Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OOH_PointOFSaleOutlet__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OOH_Lost_Flag</fullName>
        <field>OOH_GSVLostFlag__c</field>
        <literalValue>0</literalValue>
        <name>Lost Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OOH_PointOFSaleOutlet__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OOH_Update_New_Flag</fullName>
        <field>OOH_Is_New__c</field>
        <literalValue>1</literalValue>
        <name>Update New Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OOH_PointOFSaleOutlet__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Activation</fullName>
        <field>OOH_Activition_Date__c</field>
        <formula>OOH_SellOutDate__c</formula>
        <name>Update Activation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OOH_PointOFSaleOutlet__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>OOH GSV lost flag for FALSE</fullName>
        <actions>
            <name>OOH_Lost_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(OR(and( OOH_GSV__c &gt;0,  YEAR( OOH_SellOutDate__c ) =YEAR(TODAY())),and( OOH_GSV__c &gt;0,  YEAR( OOH_SellOutDate__c ) =(YEAR(TODAY())-1)),and( OOH_GSV__c =0,  YEAR( OOH_SellOutDate__c ) =(YEAR(TODAY())-1))),TRUE,FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OOH GSV lost flag for TRUE</fullName>
        <actions>
            <name>OOH_GSV_Lost_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(and( YEAR( OOH_SellOutDate__c ) ==YEAR(TODAY()), OOH_GSV__c =0),TRUE,FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OOH Update New Flag</fullName>
        <actions>
            <name>OOH_Update_New_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule is used to update new flag on POS out let if GSV value for previous year is more than zero</description>
        <formula>IF(AND((OOH_GSV__c &gt; 0), (YEAR(OOH_SellOutDate__c) + 1) ==  YEAR( TODAY())), false, true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OOHCalculate GSV Lost value</fullName>
        <actions>
            <name>OOH_GSV_LOST</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>this is the rule to show the GSV lost value</description>
        <formula>if((YEAR(OOH_SellOutDate__c) = (YEAR(TODAY()) - 1 )),AND( OOH_PointOFSaleOutlet__r.OOH_GSVLostFlag__c = false ,YEAR(OOH_SellOutDate__c) = (YEAR(TODAY()) - 1)),False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OOH_Activation</fullName>
        <actions>
            <name>Update_Activation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(AND(YEAR(OOH_PointOFSaleOutlet__r.OOH_Activition_Date__c) = YEAR(OOH_SellOutDate__c),    ISBLANK(OOH_PointOFSaleOutlet__r.OOH_Activition_Date__c) = false,ISNULL(OOH_PointOFSaleOutlet__r.OOH_Activition_Date__c) = false, OOH_SellOutDate__c &lt;  OOH_PointOFSaleOutlet__r.OOH_Activition_Date__c ),  true, IF(OR(ISNULL(OOH_PointOFSaleOutlet__r.OOH_Activition_Date__c), ISBLANK(OOH_PointOFSaleOutlet__r.OOH_Activition_Date__c)), true, false) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OOH_UL ProductCount</fullName>
        <active>false</active>
        <formula>year( OOH_SellOutDate__c )  = YEAR( TODAY() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
