import 'package:flutter/material.dart';


final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _textEditingController = TextEditingController();
 
Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
       builder: (context) {
        bool isChecked = false;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
           content: Form(
             key: _formKey,
              child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                TextFormField(
             controller: _textEditingController,
             validator: (value) {
            return value!.isNotEmpty ? null : "Enter any text";},
         decoration:InputDecoration(hintText: "Please Enter Text")
            ,),
            Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
                    Text("Choice Box"),
                    Checkbox(
                    value: isChecked,
                    onChanged: (checked) {
                  setState(() {
                  isChecked = checked!;
                   });
                   })
                   ],
                   )
                    ],
                  )),
              title: Text('Stateful Dialog'),
              actions: <Widget>[
                InkWell(
                 child: Text('OK   '),
                 onTap: () {
                 if (_formKey.currentState!.validate()) {
               // Do something like updating SharedPreferences or User Settings etc.
                 Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }