var loExtProductMock = {
    read: function (promotionId) {
        /*  if (this.data){
         return this.data;
         }*/
        var result = {
            '__Model': 'LOExtProduct',
            '__Status': true,
            'data': [
                {
                    'Category': 'Snacks',
                    'Container_Size_Unit': null,
                    'Container_Size': null,
                    'Container_Type': null,
                    'Criterion_3_Product_Code': 'a1D36000001z7Rc',
                    'Criterion_3_Product_Description': 'Brand 1',
                    'Description_1': '*Crispy Diet Cream Wafer',
                    'Id': 'a0d6100000ff0OEAXAA4',
                    'Name': 'a0d61000000OEAX',
                    'Pack_Size_Unit': 'pk',
                    'Pack_Size': 6,
                    'Short_Description': 'Diet Cream Wafer',
                    'ProductGroupId': 'a0d61000000OEEkAAO',
                    'ProductGroupDescription': 'Upples Crispy',
                    'Tactics': [
                        {
                            'tacticId': 'a1W36000000qHpkEAE',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        },
                        {
                            'tacticId': 'a1W36000000qHplEAE',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        },
                        {
                            'tacticId': 'a1W36000000qHrXEAU',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        }
                    ]
                },
                {
                    'Category': 'Snacks',
                    'Container_Size_Unit': null,
                    'Container_Size': null,
                    'Container_Type': null,
                    'Criterion_3_Product_Code': 'a1D36000001z7Rc',
                    'Criterion_3_Product_Description': 'Brand 1',
                    'Description_1': '*Crispy Diet Cream Wafer2',
                    'Id': 'a0d61000000ddOEAXBA4',
                    'Name': 'a0d61000000OEAX',
                    'Pack_Size_Unit': null,
                    'Pack_Size': null,
                    'Short_Description': 'Diet Cream Wafer2',
                    'ProductGroupId': 'a1D36000002ZJVuEAO',
                    'ProductGroupDescription': 'Other product Group',
                    'Tactics': [
                        {
                            'tacticId': 'a1W36000000qHpkEAE',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        },
                        {
                            'tacticId': 'a1W36000000qHplEAE',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        },
                        {
                            'tacticId': 'a1W36000000qHrXEAU',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        }
                    ]
                },
                {
                    'Category': 'Snacks',
                    'Container_Size_Unit': null,
                    'Container_Size': null,
                    'Container_Type': null,
                    'Criterion_3_Product_Code': 'a1D36000001z7Rc',
                    'Criterion_3_Product_Description': 'Brand 1',
                    'Description_1': '*Crispy Diet Cream Wafer3',
                    'Id': 'a0d6100ss0000OEAXAA4',
                    'Name': 'a0d61000000OEAX',
                    'Pack_Size_Unit': null,
                    'Pack_Size': null,
                    'Short_Description': 'Diet Cream Wafer3',
                    'ProductGroupId': 'a0d61000000OEEkCAO',
                    'ProductGroupDescription': 'Upples Crispy',
                    'Tactics': [
                        {
                            'tacticId': 'a1W36000000qHpkEAE',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        },
                        {
                            'tacticId': 'a1W36000000qHplEAE',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        },
                        {
                            'tacticId': 'a1W36000000qHrXEAU',
                            'relationship': 'INCLUDED' //Possible values 'INCLUDED','EXCLUDED','MATCH'
                        }
                    ]
                }]
        };

        for (var i = 0; i < 30; i++) {
            var rnd = (Math.random() * 100);
            //relationship
            var rel = 'INCLUDED';
            if (rnd > 6 && rnd <= 12) rel = 'EXCLUDED';
            if (rnd > 12) rel = 'MATCH';

            //product Group
            var pgId = 'a0d61000000OEEkAAO';
            var pgDesc = 'Upples Crispy';
            if (rnd > 20 && rnd <= 50) {
                pgId = 'a0d61000000OEEkAA1';
                pgDesc = 'Snacks';
            }
            if (rnd > 50 && rnd <= 75) {
                pgId = 'a0d61000000OEEkAA2';
                pgDesc = 'Drinks';
            }
            if (rnd > 75) {
                pgId = 'a0d61000000OEEkAA3';
                pgDesc = 'Spirits';
            }
            var tacticIds = ['a1W36000000qHpkEAE', 'a1W36000000qHplEAN', 'a1W360000010GJhEAM']
            var tacticId = tacticIds[i % 3];

            var prod = {
                Category: "Snacks",
                Container_Size_Unit: 'ml',
                Container_Size: 250,
                Container_Type: 'bottle',
                Criterion_3_Product_Code: 'a1D36000001z7Rc',
                Criterion_3_Product_Description: 'Brand 1',
                Description_1: "*Crispy Diet Cream Wafer " + i,
                Id: "a0d61000000OEAXAA4" + i,
                Name: "a0d61000000OEAX",
                Pack_Size_Unit: 'pk',
                Pack_Size: 6,
                Short_Description: "Diet Cream Wafer3",
                ProductGroupId: pgId,
                ProductGroupDescription: pgDesc,
                Tactics: [
                    {
                        tacticId: tacticId,
                        relationship: rel//Possible values 'INCLUDED','EXCLUDED','MATCH'
                    }
                ]
            };
            result.data.push(prod);

        }
        this.data = result;

        return result;
    }
};

module.exports = loExtProductMock;
