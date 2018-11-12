import 'package:flutter/material.dart';
import 'package:nutrition_tracker/fooditem.dart';
import 'package:nutrition_tracker/database/custom_list.dart';


class CustomFoodItemPage extends StatelessWidget {

  Future<bool> _back(BuildContext context) async{
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WillPopScope(
      onWillPop: () => _back(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Page'),
        ),
        body: CustomFoodItemForm(),
      ),
    );
  }
}

class CustomFoodItemForm extends StatefulWidget {
 @override
  CustomFoodState createState() => new CustomFoodState();
}


class CustomFoodState extends State<CustomFoodItemForm>{
  final _formKey = GlobalKey<FormState>();
  final _nameControl = TextEditingController();
  final _calControl = TextEditingController();
  final _carbControl = TextEditingController();
  final _fatControl = TextEditingController();
  final _proControl = TextEditingController();

  void _submit(BuildContext context){
    if(_formKey.currentState.validate()){
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
      FoodItem foodItem = new FoodItem(_nameControl.text,
          int.parse(_calControl.text),
          int.parse(_carbControl.text),
          int.parse(_fatControl.text),
          int.parse(_proControl.text));
      var customList = CustomList();
      customList.addCustomFoodItem(foodItem);
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(customList.nextFoodID().toString())));
    }
  }

  String numberValidator(String value) {
    if(value == null) {
      return null;
    }
    try{
      final num = int.parse(value);
    }catch (e){
      return '"$value" is not a valid number';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if(value.isEmpty){
                return 'Please enter some text';
              }
            },
            decoration: InputDecoration(
              hintText: 'Enter Name of Food Item'
            ),
            controller: _nameControl,

          ),
          TextFormField(
            validator: (value) {
              if(value.isEmpty){
                return 'Please enter some text';
              }
              try{
                final num = int.parse(value);
              }catch (e){
                return '"$value" is not a valid number';
              }

              return null;
            },
            decoration: InputDecoration(
                hintText: 'Enter Calories of Food Item'
            ),
            controller: _calControl,
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            validator: numberValidator,
            decoration: InputDecoration(
                hintText: 'Enter Carbohydrates of Food Item'
            ),
            controller: _carbControl,
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            validator: numberValidator,
            decoration: InputDecoration(
                hintText: 'Enter Fats of Food Item'
            ),
            controller: _fatControl,
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            validator: numberValidator,
            decoration: InputDecoration(
                hintText: 'Enter Proteins of Food Item'
            ),
            controller: _proControl,
            keyboardType: TextInputType.number,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
                onPressed: () => _submit(context),
              child: Text('Submit'),
            ),
          )
        ],
      ),
    );
  }
}