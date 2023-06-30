import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../config.dart';
import '../models/register_request_model.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  
  String? _selectedEducation = 'Altalanos iskola';
  String? _selectedGender = 'Male';
  String? firstname;
  String? lastname;
  String? username;
  String? password;
  String? gender;
  String? email;
  String? birthdate;
  String? education;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: BACKGROUND_COLOR,
            body: ProgressHUD(
              child: Form(
                key: globalFormKey,
                child: _registerUI(context),
              ),
              inAsyncCall: isAPIcallProcess,
              opacity: 0.3,
              key: UniqueKey(),
            )));
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 5,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, BACKGROUND_COLOR]),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset("images/gorilla.png",
                            width: 200, fit: BoxFit.contain))
                  ]),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 30, top: 20),
              child: CustomText(shadows: [
                BoxShadow(color: Colors.blue, spreadRadius: 5, blurRadius: 15)
              ], text: "Register", fontSize: 35),
            ),
            FormHelper.inputFieldWidget(
              context,
              "firstname",
              "FirstName",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Firstname cant be empty";
                }

                return null;
              },
              (onSaveVal) {
                firstname = onSaveVal;
              },
              borderFocusColor: Colors.white,
              prefixIcon: const Icon(Icons.person),
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.7),
              showPrefixIcon: true,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "lastname",
                "LastName",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return "Lastname cant be empty";
                  }

                  return null;
                },
                (onSaveVal) {
                  lastname = onSaveVal;
                },
                borderFocusColor: Colors.white,
                prefixIcon: const Icon(Icons.person),
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                showPrefixIcon: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "username",
                "UserName",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return "Username cant be empty";
                  }

                  return null;
                },
                (onSaveVal) {
                  username = onSaveVal;
                },
                borderFocusColor: Colors.white,
                prefixIcon: const Icon(Icons.person),
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                showPrefixIcon: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                  context, "password", "Password", (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return "Password cant be empty";
                }

                return null;
              }, (onSaveVal) {
                password = onSaveVal;
              },
                  borderFocusColor: Colors.white,
                  prefixIcon: const Icon(Icons.person),
                  prefixIconColor: Colors.white,
                  borderColor: Colors.white,
                  textColor: Colors.white,
                  hintColor: Colors.white.withOpacity(0.7),
                  showPrefixIcon: true,
                  obscureText: hidePassword,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      color: Colors.white.withOpacity(0.7),
                      icon: Icon(hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "email",
                "Email",
                (onValidateVal) {
                  if (onValidateVal.isEmpty) {
                    return "Email cant be empty";
                  }

                  return null;
                },
                (onSaveVal) {
                  email = onSaveVal;
                },
                borderFocusColor: Colors.white,
                prefixIcon: const Icon(Icons.email),
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                showPrefixIcon: true,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: FormHelper.dropDownWidget(
                  context,
                  "Gender",
                  _selectedGender,
                  [
                    {'id':1,'name':'Male'},
                    {'id':2,'name':'Female'}
                  ],
                  (String? value) {
                    setState(() {
                      _selectedGender = value;
                      gender = value;
                    });
                  },
                  (onValidateVal) {
                    if (onValidateVal == null) {
                      return "Birthdate cant be empty";
                    }
                    return null;
                  },
                  borderFocusColor: Colors.white,
                  prefixIcon: const Icon(Icons.male),
                  prefixIconColor: Colors.white,
                  borderColor: Colors.white,
                  textColor: Colors.white,
                  hintColor: Colors.white.withOpacity(0.7),
                  showPrefixIcon: true,
                )),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: FormHelper.dropDownWidget(
                  context,
                  "Vegzetseg",
                  _selectedEducation,
                  [
                    {'id': 1, 'name': 'Altalanos Iskola'},
                    {'id': 2, 'name': 'Liceum'},
                    {'id': 3, 'name': 'Egyetem'},
                  ],
                  (String? value) {
                    setState(() {
                      _selectedEducation = value;
                      education = value;
                      print("Value:"+value!);
                    });
                  },
                  (onValidateVal) {
                    if (onValidateVal == null) {
                      return "Education cant be empty";
                    }
                    return null;
                  },
                  borderFocusColor: Colors.white,
                  prefixIcon: const Icon(Icons.male),
                  prefixIconColor: Colors.white,
                  borderColor: Colors.white,
                  textColor: Colors.white,
                  hintColor: Colors.white.withOpacity(0.7),
                  showPrefixIcon: true,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: FormHelper.inputFieldWidget(
                context,
                "birthdate",
                "Birth of date",
                (onValidateVal) {
                  RegExp datePattern = RegExp(r'^\d{4}\/\d{2}\/\d{2}$');
                  if (onValidateVal.isEmpty) {
                    return "Birthdate cant be empty";
                  }
                  if (datePattern.hasMatch(onValidateVal) == false) {
                    return "Please enter your birth date in the following format: yyyy/mm/dd";
                  }
                  return null;
                },
                (onSaveVal) {
                  birthdate = onSaveVal;
                },
                borderFocusColor: Colors.white,
                prefixIcon: const Icon(Icons.cake),
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.7),
                showPrefixIcon: true,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FormHelper.submitButton("Register", () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });

                  RegisterRequestModel model = RegisterRequestModel(
                      firstName: firstname,
                      lastName: lastname,
                      userName: username,
                      email: email,
                      password: password,
                      gender: gender,
                      education: education,
                      birthdate: birthdate,
                      status: 0);
                  APIService.register(model).then((response) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    if (response.data != null) {
                      FormHelper.showSimpleAlertDialog(context, Config.appName,
                          "Succesfull register! Please log in", "OK", () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/', (route) => false);
                      });
                    } else {
                      print("response" + response.data.toString());
                      FormHelper.showSimpleAlertDialog(
                          context, Config.appName, response.toString(), "OK",
                          () {
                        Navigator.pop(context);
                      });
                    }
                  });
                }
              },
                  btnColor: BACKGROUND_COLOR,
                  borderColor: Colors.white,
                  txtColor: Colors.white),
            ),
          ]),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
