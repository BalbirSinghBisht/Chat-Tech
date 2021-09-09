import 'package:chattech/CountryCode/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'otpPage.dart';

class Phone extends StatefulWidget {
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final _contactEditingController = TextEditingController();
  var _dialCode = '';
  int charLength=0;
  _onChange(String value){
    setState(() {
      charLength=value.length;
    });
  }
  //Login click with contact number validation
  Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, 'Contact number can\'t be empty.');
    } else {
      final responseMessage =
      await showModalBottomSheet(context: context,
          builder: (context) => Otp(),
        backgroundColor: Colors.transparent,
        routeSettings: RouteSettings(arguments: '$_dialCode${_contactEditingController.text}')
      );
      if (responseMessage != null) {
        showErrorDialog(context, responseMessage as String);
      }
    }
  }

  //callback function of country picker
  void _callBackFunction(String name, String dialCode) {
    _dialCode = dialCode;
  }

  //Alert dialogue to show error and response
  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Card(
        color: Colors.deepOrangeAccent[100],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
        ),
        child: SingleChildScrollView(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 15,right: 10,bottom: 20),
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Icon(
                      CupertinoIcons.clear_circled_solid,
                      color: Colors.blue,
                      size: 30,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                'Enter Mobile Number', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black
                            )),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(15),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Container(
                                      child: CountryPicker(
                                        callBackFunction: _callBackFunction,
                                        headerText: 'Select Country Code',
                                        headerTextColor: Colors.black,
                                        headerBackgroundColor: Colors.deepOrangeAccent.shade100,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      maxLength: 10,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        hintText: 'Enter moblie number',
                                        counterText: '',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                      onChanged: _onChange,
                                      controller: _contactEditingController,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                clickOnLogin(context);
                              },
                              child: Container(
                                margin: EdgeInsets.all(15),
                                padding: EdgeInsets.all(10),
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  boxShadow: [BoxShadow(blurRadius: 2.0, color: Colors.white)],
                                  color: charLength==10?Colors.blue:Colors.grey,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white, fontSize: 20,
                                        decoration: TextDecoration.underline)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(text: 'By creating an account or logging in you agree to YorLook ',
                          style: TextStyle(color: Colors.black,fontSize: 15)),
                      TextSpan(
                          text: 'Terms of Use',
                          style: TextStyle(color: Colors.pink,fontSize: 15),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Terms of Use"');
                            }),
                      TextSpan(text: ' and ',
                        style: TextStyle(color: Colors.black,fontSize: 15),),
                      TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(color: Colors.pink,fontSize: 15),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('Privacy Policy"');
                            }),
                      TextSpan(text: ' and consent to the collection and use of your',
                        style: TextStyle(color: Colors.black,fontSize: 15),),
                      TextSpan(text: ' personal information/sensitive personal data or information.',
                          style: TextStyle(color: Colors.black,fontSize: 15)),
                    ],
                  ),
                  )
                )
              ],
            ),
        ),
        ),
      )
    );
  }
}