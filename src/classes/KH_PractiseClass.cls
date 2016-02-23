//This is practise class
public with sharing class KH_PractiseClass{

//This method is to get all the themes.

public static List<RecordType> getthemes2(){
List<RecordType> lstRecordType =  new List<RecordType>();
string objNamee=EA_Constants.SOBJECT_NAME;
lstRecordType = [SELECT RecordType.Name FROM RecordType WHERE IsActive = true AND SObjectType =: objNamee ORDER BY RecordType.Name ASC];

return lstRecordType;

}
}