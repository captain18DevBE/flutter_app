import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isHidden1 = true;
  bool isHidden2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('SIGN UP',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
            elevation: 5,
        backgroundColor: Colors.blue[700],
        centerTitle: true,
        shadowColor: Colors.black,
      ),
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: <Color>[
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
              Color(0xFF90CAF9),
              Colors.white
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Align(alignment: Alignment.center, child: Container(
                constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: signUpForm(context)))))),
    );
  }

  Form signUpForm(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 15,),
          premadeTextField(Icon(Icons.person_outline, color: Colors.grey[700]),'Username'),
          const SizedBox(height: 5),
          premadeTextField(
              Icon(Icons.mail_outline, color: Colors.grey[700]), 'Email'),
          const SizedBox(height: 5),
          premadePasswordField1(
              Icon(Icons.lock_outline, color: Colors.grey[700]), 'Password'),
          const SizedBox(height: 5),
          premadePasswordField2(
              Icon(Icons.lock_outline, color: Colors.grey[700]),
              'Repeat Password'),
              const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //LOGIN VALIDATION
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
              ),
              child: const Text('Sign up'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                  child: const Text('Sign in'))
            ],
          ),
        ],
      ),
    );
  }

  TextFormField premadePasswordField1(Icon icon, String text) {
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
                isHidden1
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[700]),
            onPressed: () {
              setState(() {
                isHidden1 = !isHidden1;
              });
            },
          )),
      obscureText: isHidden1,
    );
  }

  TextFormField premadePasswordField2(Icon icon, String text) {
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

  TextFormField premadeTextField(Icon icon, String text) {
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
      ),
      obscureText: false,
    );
  }
}
