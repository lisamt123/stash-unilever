public class IPM_CustomerChannelContorller {
    public Id projectId {
        get{
            return projectId ;
        }
        set{
            projectId = value;
        }} 
    public Id projDocSecId {
        get{
            return projDocSecId;
        }
        set{
            projDocSecId= value;
            showSectionContent();
        }}
    public Id secConId{get; set;}
    public Boolean edit{get; set;}
    public string status{get; set;}
    public string arrow{get; set;}
    public Integer priorityNumber{get; set;}
    public IPM_Project_Document_Section__c pds{get; set;}
    public List<IPM_Project_Document_Section_Content__c> secConList{get; set;}
    public IPM_Project_Document_Section_Content__c secCon{get; set;}
    public Boolean show{get; set;}
    public String[] conName;
    public String channelName{get; set;}
    public String content{get; set;}
    public String type{get; set;}
    public List<String> Names{get; set;}
    public Boolean isEditable{get;set;}
    public Integer count{get; set;}
    public string channelInfo{get;set;}
    //constructor 
    public IPM_CustomerChannelContorller()
    {
        Names=new List<String>();
        Schema.DescribeFieldResult fieldResult = IPM_Project_Document_Section_Content__c.IPM_Customer_Channels__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            Names.add(f.getValue());
        }    
        System.debug(Names);
    }   
    public void showSectionContent()
    {
        count=[Select Count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId]; 
        if(count>0)
        {
            secConList=[Select Id,IPM_Preposition__c,IPM_Customer_Channel_Priority__c,IPM_Customer_Channel_Priority_Order__c,IPM_Promotion__c,IPM_Pack__c,IPM_Place__c,IPM_Price__c,IPM_Product__c,IPM_Customer_Channels__c,IPM_Project_Document_Section__c,IPM_Section_type__c,IPM_Preposition_Image_1_Id__c,IPM_Preposition_Image_2_Id__c,IPM_Promotion_Image_1_Id__c,IPM_Promotion_Image_2_Id__c,IPM_Product_Image_1_Id__c,IPM_Product_Image_2_Id__c,IPM_Pack_Image_1_Id__c,IPM_Pack_Image_2_Id__c,IPM_Price_Image_1_Id__c,IPM_Price_Image_2_Id__c,IPM_Place_Image_1_Id__c,IPM_Place_Image_2_Id__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId order by IPM_Customer_Channel_Priority__c asc];
            show=true;
        }
        pds=[Select Id,IPM_Selected_Channel_Name__c,IPM_Customer_Channel_Info__c from IPM_Project_Document_Section__c where Id=:projDocSecId];    
        channelName=pds.IPM_Selected_Channel_Name__c;
        channelInfo=pds.IPM_Customer_Channel_Info__c;
    }
    public void deleteSectionContent()
    {
        if(secConId!=null)
        {
            String newChannels;
            secCon=[Select Id,IPM_Preposition__c,IPM_Customer_Channel_Priority__c,IPM_Promotion__c,IPM_Pack__c,IPM_Place__c,IPM_Price__c,IPM_Product__c,IPM_Customer_Channels__c,IPM_Project_Document_Section__c,IPM_Section_type__c from IPM_Project_Document_Section_Content__c where Id=:secConId];
            pds=[Select Id,IPM_Selected_Channel_Name__c,IPM_Customer_Channel_Info__c from IPM_Project_Document_Section__c where Id=:secCon.IPM_Project_Document_Section__c];    
            if(pds.IPM_Selected_Channel_Name__c.contains(','+secCon.IPM_Customer_Channels__c)){
            pds.IPM_Selected_Channel_Name__c=pds.IPM_Selected_Channel_Name__c.replaceAll(','+secCon.IPM_Customer_Channels__c,'');
            }
            else if(pds.IPM_Selected_Channel_Name__c.contains(secCon.IPM_Customer_Channels__c+','))
            {
            pds.IPM_Selected_Channel_Name__c=pds.IPM_Selected_Channel_Name__c.replace(secCon.IPM_Customer_Channels__c+',','');
            }
            else
            pds.IPM_Selected_Channel_Name__c=pds.IPM_Selected_Channel_Name__c.replace(secCon.IPM_Customer_Channels__c,'');
            update pds;
            delete secCon;
            channelName=pds.IPM_Selected_Channel_Name__c;        }
        secConList=[Select Id,IPM_Preposition__c,IPM_Customer_Channel_Priority__c,IPM_Customer_Channel_Priority_Order__c,IPM_Promotion__c,IPM_Pack__c,IPM_Place__c,IPM_Price__c,IPM_Product__c,IPM_Customer_Channels__c,IPM_Project_Document_Section__c,IPM_Section_type__c,IPM_Preposition_Image_1_Id__c,IPM_Preposition_Image_2_Id__c,IPM_Promotion_Image_1_Id__c,IPM_Promotion_Image_2_Id__c,IPM_Product_Image_1_Id__c,IPM_Product_Image_2_Id__c,IPM_Pack_Image_1_Id__c,IPM_Pack_Image_2_Id__c,IPM_Price_Image_1_Id__c,IPM_Price_Image_2_Id__c,IPM_Place_Image_1_Id__c,IPM_Place_Image_2_Id__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId order by IPM_Customer_Channel_Priority__c asc];
        if(secConList.size()>0)
        updatePriority();
    }
    
    public void updateSectionContent()
    {
        if(secConId!=null)
        {
            secCon=[Select Id,IPM_Preposition__c,IPM_Customer_Channel_Priority__c,IPM_Promotion__c,IPM_Pack__c,IPM_Place__c,IPM_Price__c,IPM_Product__c,IPM_Customer_Channels__c,IPM_Project_Document_Section__c,IPM_Section_type__c from IPM_Project_Document_Section_Content__c where Id=:secConId];
            if(type=='prepos')
            secCon.IPM_Preposition__c=content;
            else if(type=='promo')
            secCon.IPM_Promotion__c=content;
            else if(type=='pack')
            secCon.IPM_Pack__c=content;
            else if(type=='place')
            secCon.IPM_Place__c=content;
            else if(type=='price')
            secCon.IPM_Price__c=content;
            else if(type=='product')
            secCon.IPM_Product__c=content;
            update secCon;
        }
        /*projectID=ApexPages.currentPage().getParameters().get('Id'); 
        
        for(IPM_Project_Document_Section_Content__c pdsc : secConList)
        {
        
        }*/
        
        
        
    }
    public void createChannel()
    {
        List<IPM_Project_Document_Section_Content__c> conList=new List<IPM_Project_Document_Section_Content__c>();
        List<IPM_Project_Document_Section_Content__c> availConList=new List<IPM_Project_Document_Section_Content__c>();
        Set<String> availableChannel=new Set<String>();
        Set<String> newChannel=new Set<String>();
        count=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
        if(count>0)
        availConList=[Select Id,IPM_Customer_Channels__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
        Map<String,IPM_Customer_Channel_Priority_Order__c> channelPriority=IPM_Customer_Channel_Priority_Order__c.getAll();
        pds.IPM_Selected_Channel_Name__c=channelName;
        update pds;
        conName=channelName.split(',');
        System.debug(availConList.size()+'availConList.size()');
        if(availConList.size()>0)
        {
            for(IPM_Project_Document_Section_Content__c c:availConList)
            {
                availableChannel.add(c.IPM_Customer_Channels__c);
            }
            for(Integer i=0;i<conName.size();i++)
            {
                newChannel.add(conName[i]);
            }
            System.debug(newChannel+'newChannel');
            for(string s : newChannel)
            {
                if(!availableChannel.contains(s))
                {
                    IPM_Project_Document_Section_Content__c con=new IPM_Project_Document_Section_Content__c();
                    con.IPM_Customer_Channels__c=s;
                    con.IPM_Project_Document_Section__c=projDocSecId;
                    con.IPM_Customer_Channel_Priority_Order__c=Integer.valueOf(channelPriority.get(con.IPM_Customer_Channels__c).Priority_Order_Value__c);
                    conList.add(con);
                }
            }
            insert conList;
            List<IPM_Project_Document_Section_Content__c> delChannel=new List<IPM_Project_Document_Section_Content__c>();
            delChannel=[Select Id,IPM_Customer_Channels__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId and IPM_Customer_Channels__c Not In: newChannel];
            if(delChannel.size()>0)
            {
                delete delChannel;
            }
        }
        else
        {
            for(Integer i=0;i<conName.size();i++)
            {
                IPM_Project_Document_Section_Content__c con=new IPM_Project_Document_Section_Content__c();
                con.IPM_Customer_Channels__c=conName[i];
                con.IPM_Project_Document_Section__c=projDocSecId;
                con.IPM_Customer_Channel_Priority_Order__c=Integer.valueOf(channelPriority.get(con.IPM_Customer_Channels__c).Priority_Order_Value__c);
                conList.add(con);
            }
            insert conList;
        }
        updatePriority();
    }
    public void updatePriority()
    {
        List<IPM_Project_Document_Section_Content__c> prioritiseContentList=new List<IPM_Project_Document_Section_Content__c>();
        prioritiseContentList=[Select Id,IPM_Customer_Channels__c,IPM_Customer_Channel_Priority_Order__c,IPM_Customer_Channel_Priority__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId order by IPM_Customer_Channel_Priority_Order__c asc];
        Integer i=1;
        for(IPM_Project_Document_Section_Content__c p:prioritiseContentList)
        {
            p.IPM_Customer_Channel_Priority__c=i++;
        }
        update prioritiseContentList;
        secConList=[Select Id,IPM_Preposition__c,IPM_Customer_Channel_Priority__c,IPM_Customer_Channel_Priority_Order__c,IPM_Promotion__c,IPM_Pack__c,IPM_Place__c,IPM_Price__c,IPM_Product__c,IPM_Customer_Channels__c,IPM_Project_Document_Section__c,IPM_Section_type__c,IPM_Preposition_Image_1_Id__c,IPM_Preposition_Image_2_Id__c,IPM_Promotion_Image_1_Id__c,IPM_Promotion_Image_2_Id__c,IPM_Product_Image_1_Id__c,IPM_Product_Image_2_Id__c,IPM_Pack_Image_1_Id__c,IPM_Pack_Image_2_Id__c,IPM_Price_Image_1_Id__c,IPM_Price_Image_2_Id__c,IPM_Place_Image_1_Id__c,IPM_Place_Image_2_Id__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId order by IPM_Customer_Channel_Priority__c asc];
        count=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
    }
    public void changePriority()
    {
        System.debug(priorityNumber+'priorityNumber');
        IPM_Project_Document_Section_Content__c newPriority=new IPM_Project_Document_Section_Content__c();
        IPM_Project_Document_Section_Content__c oldPriority=new IPM_Project_Document_Section_Content__c();
        newPriority=[Select Id,IPM_Customer_Channel_Priority_Order__c,IPM_Customer_Channel_Priority__c from IPM_Project_Document_Section_Content__c where Id=:secConId];
        oldPriority=[Select Id,IPM_Customer_Channel_Priority_Order__c,IPM_Customer_Channel_Priority__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId and IPM_Customer_Channel_Priority__c=:priorityNumber];
        if(newPriority.IPM_Customer_Channel_Priority__c==1 && arrow=='down')
        newPriority.IPM_Customer_Channel_Priority__c=2;
        else if(newPriority.IPM_Customer_Channel_Priority__c==2 && arrow=='down')
        newPriority.IPM_Customer_Channel_Priority__c=3;
        else if(newPriority.IPM_Customer_Channel_Priority__c==2 && arrow=='up')
        newPriority.IPM_Customer_Channel_Priority__c=1;   
        else if(newPriority.IPM_Customer_Channel_Priority__c==3 && arrow=='up')
        newPriority.IPM_Customer_Channel_Priority__c=2;
        update newPriority;
        if(arrow=='down')
        oldPriority.IPM_Customer_Channel_Priority__c=priorityNumber-1;
        if(arrow=='up')
        oldPriority.IPM_Customer_Channel_Priority__c=priorityNumber+1;
        update oldPriority; 
        secConList=[Select Id,IPM_Preposition__c,IPM_Customer_Channel_Priority__c,IPM_Customer_Channel_Priority_Order__c,IPM_Promotion__c,IPM_Pack__c,IPM_Place__c,IPM_Price__c,IPM_Product__c,IPM_Customer_Channels__c,IPM_Project_Document_Section__c,IPM_Section_type__c,IPM_Preposition_Image_1_Id__c,IPM_Preposition_Image_2_Id__c,IPM_Promotion_Image_1_Id__c,IPM_Promotion_Image_2_Id__c,IPM_Product_Image_1_Id__c,IPM_Product_Image_2_Id__c,IPM_Pack_Image_1_Id__c,IPM_Pack_Image_2_Id__c,IPM_Price_Image_1_Id__c,IPM_Price_Image_2_Id__c,IPM_Place_Image_1_Id__c,IPM_Place_Image_2_Id__c from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId order by IPM_Customer_Channel_Priority__c asc];
        count=[Select count() from IPM_Project_Document_Section_Content__c where IPM_Project_Document_Section__c=:projDocSecId];
    }
    public void updateInfo()
    {
        pds.IPM_Customer_Channel_Info__c=channelInfo;
        update pds;
    }
}