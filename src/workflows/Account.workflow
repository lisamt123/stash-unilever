<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CEC_Account_Email_Notification</fullName>
        <ccEmails>ulcecsupport.in@capgemini.com</ccEmails>
        <description>CEC Account Email Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>CEC_Unilever/CEC_Account_Email_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>CEC_NoSpecialChar_Phone_Update</fullName>
        <description>CEC : Remove the special &amp; whitespace character from the standard &apos;Phone&apos; field and update the custom field.</description>
        <field>Phone_No_Special_Char__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(Phone, &quot; &quot;, &quot;&quot;), &quot;-&quot;, &quot;&quot;), &quot;.&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;), &quot;(&quot;, &quot;&quot;), &quot;)&quot;, &quot;&quot;)</formula>
        <name>CEC_NoSpecialChar Phone Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
	<fieldUpdates>
        <fullName>CEC_Capitalise_the_consumers_First_name</fullName>
        <field>FirstName</field>
        <formula>IF (
  FIND(&quot; &quot;, FirstName ,1)=0,
  UPPER(LEFT(FirstName ,1))&amp;LOWER(MID(FirstName,2,LEN(FirstName)-1)),
  IF(
    FIND(&quot; &quot;,MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,LEN(FirstName)-FIND(&quot; &quot;,FirstName,1)))=0,
	    UPPER(LEFT(FirstName ,1))&amp;
	    LOWER(MID(FirstName ,2,FIND(&quot; &quot;,FirstName ,1)-1))&amp;
	    UPPER(MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,1))&amp;
	    LOWER(MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+2,LEN(FirstName)-1)),

	    UPPER(LEFT(FirstName ,1))&amp;
	    LOWER(MID(FirstName ,2,FIND(&quot; &quot;,FirstName ,1)-1))&amp;
	    UPPER(MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,1))&amp;
	    LOWER(MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+2,FIND(&quot; &quot;,MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot; &quot;,FirstName ,1)))-1))&amp;
	    UPPER(MID(FirstName ,FIND(&quot; &quot;,MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot; &quot;,FirstName ,1)))+FIND(&quot; &quot;,FirstName ,1)+1,1))&amp;
	    LOWER(MID(FirstName ,FIND(&quot; &quot;,MID(FirstName ,FIND(&quot; &quot;,FirstName ,1)+1,LEN(FirstName )-FIND(&quot; &quot;,FirstName ,1)))+FIND(&quot; &quot;,FirstName ,1)+2,LEN(FirstName)-1))
  )
)</formula>
        <name>CEC Capitalise the consumers First name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEC_Capitalise_the_consumers_Last_name</fullName>
        <field>LastName</field>
        <formula>IF (
  FIND(&quot; &quot;, LastName ,1)=0,
  UPPER(LEFT(LastName ,1))&amp;LOWER(MID(LastName,2,LEN(LastName)-1)),
  IF(
    FIND(&quot; &quot;,MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,LEN(LastName)-FIND(&quot; &quot;,LastName,1)))=0,
	    UPPER(LEFT(LastName ,1))&amp;
	    LOWER(MID(LastName ,2,FIND(&quot; &quot;,LastName ,1)-1))&amp;
	    UPPER(MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,1))&amp;
	    LOWER(MID(LastName ,FIND(&quot; &quot;,LastName ,1)+2,LEN(LastName)-1)),

	    UPPER(LEFT(LastName ,1))&amp;
	    LOWER(MID(LastName ,2,FIND(&quot; &quot;,LastName ,1)-1))&amp;
	    UPPER(MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,1))&amp;
	    LOWER(MID(LastName ,FIND(&quot; &quot;,LastName ,1)+2,FIND(&quot; &quot;,MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot; &quot;,LastName ,1)))-1))&amp;
	    UPPER(MID(LastName ,FIND(&quot; &quot;,MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot; &quot;,LastName ,1)))+FIND(&quot; &quot;,LastName ,1)+1,1))&amp;
	    LOWER(MID(LastName ,FIND(&quot; &quot;,MID(LastName ,FIND(&quot; &quot;,LastName ,1)+1,LEN(LastName )-FIND(&quot; &quot;,LastName ,1)))+FIND(&quot; &quot;,LastName ,1)+2,LEN(LastName)-1))
  )
)</formula>
        <name>CEC Capitalise the consumers Last name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEC Account Email Notification</fullName>
        <actions>
            <name>CEC_Account_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow is to send the email notification when account is created with mulesoft user owner id</description>
        <formula>IF(OwnerId == $Setup.cec_Org_Settings__c.Mulesoft_User_Id__c, TRUE, FALSE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CEC_PhoneRemoveSpecialChar</fullName>
        <actions>
            <name>CEC_NoSpecialChar_Phone_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>CEC : To remove special &amp; whitespace characters in the standard &apos;Phone&apos; field and copy to a custom field.</description>
        <formula>/* ----------------------------------------------------  1. Used RecordType.Name =&apos;Person Account&apos; instead of &apos;IsPersonAccount&apos; in the formula.  The CEC app uses only RecordType which has both label and name &apos;Person Account&apos;. The &apos;IsPersonAccount&apos; returns more than 1 recordtype accounts ex., &apos;Pitch Expert&apos; which is not required.  2. !ISBLANK(Phone) conditions are added for backward compatibility. This will be removed once all the account data has this new custom field populated via the field update --------------------------------------------------------*/   RecordType.Name = &apos;Person Account&apos; &amp;&amp; (ISCHANGED(Phone) || ISNEW() || !ISBLANK(Phone) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
	<rules>
        <fullName>CEC Capitalise the consumers name</fullName>
        <actions>
            <name>CEC_Capitalise_the_consumers_First_name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEC_Capitalise_the_consumers_Last_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.FirstName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Person Account</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
