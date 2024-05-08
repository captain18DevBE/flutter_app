import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/pages/home.dart';
import 'package:english_learning_app/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final UserAuthController _userAuthController = new UserAuthController();

  bool isHidden = true;
  bool isHidden2 = true;
  bool isHidden3 = true;

  TextEditingController _emailSigInController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    _emailSigInController.dispose();
    _passwordController.dispose();

    super.dispose();

  }

  void _signIn() async {
    String email = _emailSigInController.text; 
    String password = _passwordController.text;

    User? user = await _userAuthController.signInWithEmailPassword(email, password);

    if(user != null) {
      print("Login is successful!");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      print("Login is false");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
            Color(0xFF90CAF9),
            Colors.white
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: loginLogo(),
            ),
            SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.transparent),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: loginForm(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Form loginForm(BuildContext context) {
    return Form(
      child: Column(
        children: <Widget>[
          premadeTextField(
              Icon(Icons.mail_outline, color: Colors.grey[700]), 'Email'),
          const SizedBox(height: 10),
          premadePasswordField(
              Icon(Icons.lock_outline, color: Colors.grey[700]), 'Password'),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {


                recoverDialogEmail();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _signIn,
              
              // () {
              //   String emailSignIn = _emailSigInController.text; 
              //   String password = _passwordController.text;
              //   cxc
              //   Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              // }
              
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Login'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Don\'t have an account?'),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()));
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: const Text('Sign up'))
            ],
          ),
        ],
      ),
    );
  }

  TextFormField premadeTextField(Icon icon, String text) {
    return TextFormField(
      controller: _emailSigInController,

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      cursorColor: Colors.blue,
      decoration: InputDecoration(
        labelText: text,
        labelStyle: const TextStyle(color: Colors.grey),
        floatingLabelStyle: const TextStyle(color: Colors.blue),
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.blue)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.blue)),
        filled: true,
        fillColor: Colors.white70,
      ),
      obscureText: false,
    );
  }

  TextFormField premadePasswordField(Icon icon, String text) {
    return TextFormField(
      controller: _passwordController,

      cursorColor: Colors.blue,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: text,
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Colors.blue),
          prefixIcon: icon,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.blue)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: const BorderSide(color: Colors.blue)),
          filled: true,
          fillColor: Colors.white70,
          suffixIcon: IconButton(
            icon: Icon(
                isHidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[700]),
            onPressed: () {
              setState(() {
                isHidden = !isHidden;
              });
            },
          )),
      obscureText: isHidden,
    );
  }

  Column loginLogo() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'ENGLISH LEARNING APP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'built with Flutter',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5),
            FlutterLogo(size: 20.0),
          ],
        )
      ],
    );
  }

  void recoverDialogEmail() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Enter your email',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),
          content: TextFormField(
            cursorColor: Colors.blue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.grey),
              floatingLabelStyle: const TextStyle(color: Colors.blue),
              prefixIcon: Icon(Icons.mail_outline, color: Colors.grey[700]),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.blue)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: Colors.blue)),
              filled: true,
              fillColor: Colors.white70,
            ),
            obscureText: false,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  recoverDialogOtp();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      );

  void recoverDialogOtp() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            surfaceTintColor: Colors.transparent,
            title: const Text('Enter the 4 digits code sent to your email',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 25)),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  optNumField(context, true, true),
                  optNumField(context, false, true),
                  optNumField(context, false, true),
                  optNumField(context, false, false),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Want to change email?'),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        recoverDialogEmail();
                      },
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                      child: const Text('Go back'))
                ],
              ),
            ]),
            actions: [
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    //RESEND OPT CODE
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text(
                    'Resend Code',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    recoverDialogPassword();
                    setState(() {
                      isHidden2 = true;
                      isHidden3 = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Submit',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ));

  void recoverDialogPassword() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState) {

            TextFormField premadePasswordField2(Icon icon, String text) {
              return TextFormField(
                cursorColor: Colors.blue,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: text,
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    prefixIcon: icon,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.blue)),
                    filled: true,
                    fillColor: Colors.white70,
                    suffixIcon: IconButton(
                      icon: Icon(
                          isHidden2
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[700]),
                      onPressed: () {
                        setState(() {
                          isHidden2 = !isHidden2;
                        });
                      },
                    )),
                obscureText: isHidden2,
              );
            }

            TextFormField premadePasswordField3(Icon icon, String text) {
              return TextFormField(
                cursorColor: Colors.blue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: text,
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    prefixIcon: icon,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.blue)),
                    filled: true,
                    fillColor: Colors.white70,
                    suffixIcon: IconButton(
                      icon: Icon(
                          isHidden3
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Colors.grey[700]),
                      onPressed: () {
                        setState(() {
                          isHidden3 = !isHidden3;
                        });
                      },
                    )),
                obscureText: isHidden3,
              );
            }

            return AlertDialog(
              surfaceTintColor: Colors.transparent,
              title:
                  const Text('Make a new password', style: TextStyle(fontSize: 25)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  premadePasswordField2(
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey[700],
                      ),
                      'Password'),
                  const SizedBox(height: 10),
                  premadePasswordField3(
                      Icon(
                        Icons.lock_outline,
                        color: Colors.grey[700],
                      ),
                      'Repeat Password'),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            );
          }));

  SizedBox optNumField(BuildContext context, bool isFocused, bool jumpToNext) {
    return SizedBox(
      height: 50,
      width: 40,
      child: TextFormField(
        cursorColor: Colors.blue,
        autofocus: isFocused,
        onChanged: (value) {
          if (value.length == 1 && jumpToNext) {
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && !isFocused) {
            FocusScope.of(context).previousFocus();
          }
        },
        keyboardType: TextInputType.number,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.blue)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Colors.blue)),
          filled: true,
          fillColor: Colors.white70,
        ),
      ),
    );
  }
}
