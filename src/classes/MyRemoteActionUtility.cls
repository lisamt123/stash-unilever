/**
  * Name          : MyRemoteActionUtility
  * Description   : Promotion UI BO Controller Helper class
  */

public with sharing class MyRemoteActionUtility
{
    public static Map<String,Object> CheckObjectInJsonContent (String JsonContent, String findObject )
  {
    //LoggerUtility.log('CheckValidDeserializeUntyped is called! Transcation Id:'+JsonContent,findObject);
  Map<String, Object> deserPrmContent = (Map<String, Object>)JSON.deserializeUntyped(JsonContent);
  Map<String, Object> mapObject=null;
    if(deserPrmContent!=null || deserPrmContent.size() > 0)
    {
      mapObject = (Map<String, Object>)deserPrmContent.get(findObject);
    if(mapObject==null)
    {
    throw new UL_CustomException('Not found'+' '+ findObject+ ' in JsonContent');
      }
    }
  return mapObject;
  }
  
  public static List<String> getFieldsOfObject(String txId, String sObjectType)
    {
  Schema.DescribeSObjectResult objectMetaData = Schema.getGlobalDescribe().get(sObjectType).getDescribe();

  List<String> fieldNames = new List<String>();
  for (String fieldName:objectMetaData.fields.getMap().keySet())
  {
    Schema.DisplayType fieldType=objectMetaData.fields.getMap().get(fieldName).getDescribe().getType();
    if(fieldType!= Schema.DisplayType.LOCATION && fieldType!= Schema.DisplayType.ADDRESS)
      {
        fieldNames.add(fieldName);
  }
    }

  return fieldNames;
    }

}