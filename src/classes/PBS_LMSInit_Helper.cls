/*
Copyright (c) 2014, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
    may be used to endorse or promote products derived from this software
    without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
*/

public class PBS_LMSInit_Helper{

  public static List<Object> getObjectList(Map<String,Object> o, String key){
        if(o != null && o.get(key) != null){
            return (List<Object>)o.get(key);
        }else{
            return new List<Object>();
        }
    }
      public static String getStringValue(Object o, String defaultValue){
        return o!=null?(String)o:defaultValue;
    }

    public static Date getDateValue(Object o, Date defaultValue){
        Date dateValue = defaultValue;
        if(o != null){
            String dateString = (String)o;
            List<String> dComp = dateString.split('-');
            if(dComp.size() == 3){
                dateValue = Date.newInstance(Integer.valueOf(dComp[0]), Integer.valueOf(dComp[1]), Integer.valueOf(dComp[2]));
            }
        }
        return dateValue;
    }

    public static Boolean getBooleanValue(Object o, Boolean defaultValue){
        return o!=null?(Boolean)o:defaultValue;
    }

    public static Integer getIntegerValue(Object o, Integer defaultValue){
        return o!=null?(Integer)o:defaultValue;
    }

    public static Double getDoubleValue(Object o, Double defaultValue){
        return o!=null?(Double)o:defaultValue;
    }

    public static String getTimeStamp(){
        DateTime dtimenow = DateTime.now();
        String ts = dtimenow.second()+''+dtimenow.millisecond();
        return ts;
    }

}