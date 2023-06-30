import 'package:allamvizsga/models/login_request_model.dart';
import 'package:allamvizsga/services/api_service.dart';
import 'package:allamvizsga/utils/colors.dart';
import 'package:allamvizsga/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAPIcallProcess = false;
  bool hidePassword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  String? password;
  @override
  Widget build(BuildContext context) {  
    return SafeArea(
        child: Scaffold(
            backgroundColor: BACKGROUND_COLOR,
            body: ProgressHUD(
              child: Form(
                key: globalFormKey, 
                child: _loginUI(context),
                ),
              inAsyncCall: isAPIcallProcess,
              opacity: 0.3,
              key: UniqueKey(),
            )));
  }

  Widget _loginUI(BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin:Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white,
                    Colors.white
                  ]),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100)
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "images/gorilla.png",
                      width: 250,
                      fit:BoxFit.contain
                    )
                  )
                ]),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left:20,
                bottom:30,
                top: 20
              ),
              child:  CustomText(
                shadows: [
                  BoxShadow(
                    color: Colors.blue,
                    spreadRadius: 5,
                    blurRadius: 15
                  )
                ], 
                text: "Login", 
                fontSize: 35),
            ),
            FormHelper.inputFieldWidget(
              context,
              "username",
              "UserName",
              (onValidateVal){
                if(onValidateVal.isEmpty){
                  return "Username cant be empty";
                }

                return null;
              },
              (onSaveVal){
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
            Padding(
              padding: const EdgeInsets.only(
                top:10
              ),
              child: FormHelper.inputFieldWidget(
                context,
                "password",
                "Password",
                (onValidateVal){
                  if(onValidateVal.isEmpty){
                    return "Password cant be empty";
                  }

                  return null;
                },
                (onSaveVal){
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
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility
                  ))
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  top:18.0),
                child: RichText(
                  text:  TextSpan(
                    style: const TextStyle(
                      color:Colors.grey,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Forget Password?',
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.underline
                        ),
                        recognizer: TapGestureRecognizer()
                        ..onTap = (){
                          print("Forget Password");
                        },
                      )
                    ]
                  ) ,),
              )
            ),
            const SizedBox(height: 20,),
            Center(
              child: FormHelper.submitButton(
                "Login",
                (){
                  if(validateAndSave()){
                    setState(() {
                      isAPIcallProcess = true;
                    });

                    LoginRequestModel model = LoginRequestModel(
                      email:username,
                      password: password);
                    APIService.login(model).then((response) {
                      setState(() {
                      isAPIcallProcess = false;
                    });
                        if(response){
                          Navigator.pushNamedAndRemoveUntil(
                            context, 
                            '/home',
                            (route) =>false);
                        }else{
                          FormHelper.showSimpleAlertDialog(
                            context, 
                            Config.appName, 
                            "Invalid Username/password !", 
                            "OK", 
                            (){
                              Navigator.pop(context);
                            });
                        }
                    });  
                  }
                },
                btnColor: BACKGROUND_COLOR,
                borderColor: Colors.white,
                txtColor:Colors.white),
            ),
            const SizedBox(height: 20,),
            const Center(child: CustomText(shadows: [BoxShadow(color: Colors.blue,spreadRadius: 5,blurRadius: 15)], text: "OR", fontSize: 25)),
            const SizedBox(height: 20,),
            Align(
              alignment: Alignment.bottomCenter,
              child: RichText(
                text:  TextSpan(
                  text: "Dont have an account? ",
                  style: const TextStyle(
                    color:Colors.grey,
                    fontSize: 14,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Sign up?',
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline
                      ),
                      recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        Navigator.pushNamed(context, "/register");
                      },
                    )
                  ]
                ) ,)
            ),
            

          ]),
      );
  }

  bool validateAndSave(){
    final form = globalFormKey.currentState;
    if(form!.validate()){
        form.save();
        return true;
    }else{
      return false;
    }
  }

}
