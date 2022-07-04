import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import 'otp.dart';

class MobileLogin extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<MobileLogin> {
  TextEditingController _controller = TextEditingController();

  dynamic countryCode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Auth'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              Container(
                margin: EdgeInsets.only(top: 60),
                child: Center(
                  child: Text(
                    'Phone Authentication',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40, right: 10, left: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    counterText: "",
                    prefix: Padding(
                      padding: EdgeInsets.all(4),
                      child: CountryCodePicker(
                        onChanged: (value) {
                          print("---${countryCode}");
                          setState(() {
                            countryCode = value;
                          });
                        },

                        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                        initialSelection: 'IN',
                        //favorite: ['+91', ''],
                        // optional. Shows only country name and flag
                        showCountryOnly: true,
                        // optional. Shows only country name and flag when popup is closed.
                        showOnlyCountryWhenClosed: false,
                        // optional. aligns the flag and the Text left
                        alignLeft: false,
                      ),
                    ),
                  ),
                  maxLength: 10,
                  autofocus: true,
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.number,
                  controller: _controller,
                ),
              )
            ]),
            Container(
              margin: EdgeInsets.all(10),
              width: double.infinity,
              child: FlatButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OTPScreen(
                        _controller.text,
                        countryCode.toString(),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
