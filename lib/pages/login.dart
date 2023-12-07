// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app_onlyonclick/constants.dart';
import 'package:task_management_app_onlyonclick/pages/home.dart';
import 'package:task_management_app_onlyonclick/pages/signup.dart';
import 'package:task_management_app_onlyonclick/utils/firebase_helper.dart';
import 'package:task_management_app_onlyonclick/widgets/my_alert_dialog.dart';
import 'package:task_management_app_onlyonclick/widgets/rectangular_button.dart';

class Login extends StatefulWidget {
  static const String id = 'login_screen';
  static const String isLoggedIn = 'isLoggedIn';
  static const String email = 'email';

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  bool rememberMe = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  clearText() {
    emailController.clear();
    passwordController.clear();
    setState(() {});
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      progressIndicator: SpinKitDoubleBounce(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.blue : Colors.white,
            ),
          );
        },
      ),
      isLoading: isLoading,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: SingleChildScrollView(
              child: AutofillGroup(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.width * 0.2),
                      const Text(
                        'Task Management App',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kPrimaryColor, fontSize: 30),
                      ),
                      const SizedBox(
                        height: 64,
                      ),
                      TextFormField(
                        autofillHints: [AutofillHints.email],
                        controller: emailController,
                        onChanged: (value) {
                          email = value.trim();
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter your email";
                          }
                          if (!EmailValidator.validate(val.trim())) {
                            return "Enter a valid email address";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: IconTheme(
                              data: IconThemeData(color: kPrimaryColor),
                              child: Icon(Icons.email)),
                          hintText: 'Username or email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        autofillHints: [AutofillHints.password],
                        controller: passwordController,
                        onChanged: (value) {
                          password = value;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter your password";
                          }
                          if (val.length < 6) {
                            return "password length can't be less than 6";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: IconTheme(
                              data: IconThemeData(color: kPrimaryColor),
                              child: Icon(CupertinoIcons.lock_fill)),
                          hintText: 'Password',
                        ),
                        obscureText: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              checkColor: Colors.white,
                              contentPadding: const EdgeInsets.all(0),
                              activeColor: kPrimaryColor,
                              side: const BorderSide(color: Colors.black54),
                              title: const Text(
                                'Remember me',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              value: rememberMe,
                              onChanged: (bool? value) {
                                setState(() {
                                  rememberMe = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RectengularRoundedButton(
                        buttonName: 'Login',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            toggleLoading();
                            final userFound = await FirebaseHelper.instance
                                .getUserWithEmail(email.toLowerCase());
                            if (userFound == null) {
                              showMyAlertDialog(context, 'Login Error!',
                                  'User Not Registered.',
                                  disposeAfterMillis: 1000);
                              toggleLoading();
                              return;
                            }
                            if (userFound.password != password) {
                              showMyAlertDialog(context, 'Login Error!',
                                  'Incorrect password.');
                              toggleLoading();
                              return;
                            }
                            await showMyAlertDialog(
                                context, 'Info', 'Login Successful.',
                                disposeAfterMillis: 300, isError: false);
                            if (rememberMe) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool(Login.isLoggedIn, true);
                              await prefs.setString(
                                  Login.email, userFound.email);
                            }
                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Home(user: userFound)));
                          }
                          if (mounted) {
                            if (isLoading) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'New here?',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextButton(
                            onPressed: () {
                              clearText();
                              Navigator.pushNamed(context, SignUp.id);
                            },
                            child: const Text(
                              'Create an Account',
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void toggleLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }
}
