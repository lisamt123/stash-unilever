public virtual with sharing class AR_SObjectHolder {
    public SObject obj {get;set;}
        private Map<String,Attachment> files {get;set;}
        private Map<String,Boolean> filesInsert = new Map<String,Boolean>();
        private Boolean IsPrefilled = false;
        private boolean isDeleted = false;
        
        public AR_SObjectHolder() {
            this.files = new Map<String,Attachment>();
            fillmap();
        }
        
        public Boolean getPrefilled()
        {
            return IsPrefilled;
        }
        public void setPrefilled(Boolean tmp_bool)
        {
            IsPrefilled = tmp_bool;
        }
        public AR_SObjectHolder(Sobject obj) {
            this.obj = obj;
            this.files = new Map<String,Attachment>();  
            fillmap();
        }
        public void fillmap()
        {
            if(!files.containsKey('one'))
            {
                files.put('one',new Attachment());
            }
            if(!files.containsKey('two'))
            {
                files.put('two',new Attachment());
            }
            if(!files.containsKey('three'))
            {
                files.put('three',new Attachment());
            }
            if(!files.containsKey('four'))
            {
                files.put('four',new Attachment());
            }
            if(!files.containsKey('five'))
            {
                files.put('five',new Attachment());
            }
            
            if(!filesInsert.containsKey('one'))
            {
                filesInsert.put('one',false);
            }
            
            if(!filesInsert.containsKey('two'))
            {
                filesInsert.put('two',false);
            }
            
            if(!filesInsert.containsKey('three'))
            {
                filesInsert.put('three',false);
            }
            
            if(!filesInsert.containsKey('four'))
            {
                filesInsert.put('four',false);
            }
            
            if(!filesInsert.containsKey('five'))
            {
                filesInsert.put('five',false);
            }
            
            
        }
        public virtual Map<String,Attachment> getFiles() {
            system.debug('####fillmap ' + this.files);
            fillmap();
            return this.files;
        }
        
        public void SetFiletoInsert(String tmp_file)
        {
            filesInsert.put(tmp_file,true);
        }
        
        public virtual List<Attachment> getFilesasList()
        {
            List<Attachment> tmp_returnList = new List<Attachment>();
            for(String key:files.keyset())
            { 
                if(filesInsert.get(key)){
                    if(!files.get(key).Name.contains(key + '_'))
                    {
                        files.get(key).Name = key + '_' + files.get(key).Name;
                    }
                    tmp_returnList.add(files.get(key));
                }
            }
            return tmp_returnList;
        }
        
        public void setFiles(List<Attachment> files) {
            for(Attachment a : files)
                if(a.parentId == getId())
                    if(a.name.contains('_'))
                    {
                        this.files.put(a.name.split('_').get(0), a);
                    }
                    else
                    {
                        this.files.put('NotValid', a);
                    }
        }
        
        public void setAllFilesParentIds() {
            for(Attachment a: files.values())
                if(a != null && a.parentId == null){
                a.parentId = (Id)obj.get('Id');
                }
        }
        
        public void SetAllBodystoNull()
        {
            for(Attachment a: files.values())
            {
                a.Body = null;
            }
            for(String b:filesInsert.keyset())
            {
                filesInsert.put(b ,false);
            }
            
        }
        
        // quantity of uploaded files
        public Integer getFilesCount() {
            Integer quantity = 0;
            for(Attachment a : this.files.values()) {
                if(a != null && a.bodyLength > 0)
                    quantity++;
            }
            system.debug(logginglevel.info, '>>> Files Quantity: ' + quantity);
            return quantity;
        }
        
        public Id getId() {
            return obj.id;
        }
        
        public void setId(Id objId) {
            if(this.obj != null)
                this.obj.id = objId;
        }
        
        public void remove() {
            this.isDeleted = true;
        }
        
        public boolean getIsDeleted() {
            return this.isDeleted;
        }
}