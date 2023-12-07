// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:task_management_app_onlyonclick/constants.dart';
import 'package:task_management_app_onlyonclick/models/user.dart';
import 'package:task_management_app_onlyonclick/utils/firebase_helper.dart';
import 'package:task_management_app_onlyonclick/widgets/my_alert_dialog.dart';
import 'package:task_management_app_onlyonclick/widgets/rectangular_button.dart';

class SignUp extends StatefulWidget {
  static const String id = 'signup_screen';

  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String name = '';
  String email = '';
  String password = '';
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final confirmPassController = TextEditingController();

  UserType? type;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPassController.dispose();
  }

  clearText() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPassController.clear();
    type = null;
    setState(() {});
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: SingleChildScrollView(
              child: AutofillGroup(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        'Task Management App',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: kPrimaryColor, fontSize: 30),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: nameController,
                        onChanged: (value) {
                          name = value;
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter your name";
                          }

                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: IconTheme(
                            data: IconThemeData(color: kPrimaryColor),
                            child: Icon(Icons.person),
                          ),
                          hintText: 'Name',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Your role',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey.shade700),
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<UserType>(
                              hint: const Text('select'),
                              value: type,
                              onChanged: (chosenType) {
                                setState(() {
                                  type = chosenType;
                                });
                              },
                              elevation: 5,
                              borderRadius: BorderRadius.circular(5),
                              items: UserType.values
                                  .map<DropdownMenuItem<UserType>>((userType) {
                                return DropdownMenuItem<UserType>(
                                  value: userType,
                                  child: Text(
                                    userType.name,
                                    style:
                                        const TextStyle(color: kPrimaryColor),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
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
                          hintText: 'Email address',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
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
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: confirmPassController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return "Enter confirm password";
                          }
                          if (val.length < 6) {
                            return "password length can't be less than 6";
                          }
                          if (val != password) {
                            return "password & confirm password do not match";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: IconTheme(
                              data: IconThemeData(color: kPrimaryColor),
                              child: Icon(CupertinoIcons.lock_fill)),
                          hintText: 'Confirm Password',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      RectengularRoundedButton(
                        buttonName: 'Sign Up',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (type == null) {
                              showMyAlertDialog(context, 'Validation Error!',
                                  'Please select your role.',
                                  disposeAfterMillis: 2000);

                              return;
                            }
                            toggleLoading();
                            final userFound = await FirebaseHelper.instance
                                .getUserWithEmail(email.toLowerCase());
                            if (userFound != null) {
                              showMyAlertDialog(context, 'SignUp Error!',
                                  'This email is already in use.',
                                  disposeAfterMillis: 2000);
                              toggleLoading();
                              return;
                            }

                            final user = User(
                                type: type!,
                                name: name,
                                email: email.toLowerCase(),
                                password: password);
                            final accountCreated =
                                await FirebaseHelper.instance.saveUser(user);
                            if (accountCreated != null && accountCreated) {
                              toggleLoading();
                              await showMyAlertDialog(context, 'Info.',
                                  "Account created successfully.",
                                  isError: false);
                              Navigator.pop(context);
                            } else {
                              await showMyAlertDialog(context, 'SignUp error!',
                                  "Some error occurred.");
                            }
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
