/**********************************************************************
Name: OV_DeviceType
Copyright © 2015 Unilever.

============================================================================
============================================================================
Purpose: OV_DeviceType
============================================================================

============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Dan Harfleet            24/06/2015      INITIAL DEVELOPMENT
**********************************************************************/
public class OV_DeviceType {
	public static Integer MOBILE = 1;
	public static Integer TABLET = 2;
	public static Integer DESKTOP = 4;

	public static String descriptionForType(Integer deviceType) {
        String result = 'unknown';
        if(deviceType == OV_DeviceType.DESKTOP){
            result = 'Desktop';
        }else if(deviceType == OV_DeviceType.TABLET){
            result = 'Tablet';
        }else if(deviceType == OV_DeviceType.MOBILE){
            result = 'Mobile';
        }
        return result;  
	}

	public static Integer typeForParameter(String parameter) {
        Integer result = OV_DeviceType.DESKTOP;  
        if(parameter == 'D'){
            result = OV_DeviceType.DESKTOP;
        }else if(parameter == 'T'){
            result= OV_DeviceType.TABLET;
        }else if(parameter == 'M'){
            result = OV_DeviceType.MOBILE;
        }
        return result;
	}
}