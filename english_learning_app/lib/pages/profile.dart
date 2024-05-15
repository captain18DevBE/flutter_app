import 'package:english_learning_app/controllers/UserAuthController.dart';
import 'package:english_learning_app/controllers/UserController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserAuthController _userAuthController = new UserAuthController();
  UserController _userController = new UserController();
  User? _currentUser;
  String? _urlAvatarImg;

  bool isHidden = true;
  bool isHidden2 = true;
  bool isHidden3 = true;
  String username = "John Doe";
  String email = "johndoe@example.com";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _currentUser = _userAuthController.getCurrentUser();
    _urlAvatarImg = _currentUser?.photoURL;

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('UPDATE PROFILE',
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
              child: Align(
                  alignment: Alignment.center,
                  child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 500, maxWidth: 400),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: updateProfileForm(context)))))),
    );
  }

  Form updateProfileForm(BuildContext context) {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(height: 15),
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  _urlAvatarImg ?? "assets/demo.jpg"
                  ), //AVATAR
              ),
              Positioned(
                bottom: -14,
                right: -10,
                child: IconButton(
                  icon: Icon(Icons.camera_alt, color: Colors.grey,),
                  onPressed: () async {
                    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if (file == null) {
                      return;
                    }
                    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
                    String urlDownload = await _userController.upUserAvatar(fileName, file.path);
                    setState(() {
                      _urlAvatarImg = urlDownload;
                    });
                  },
                  )
              )
            ]
          ),
          const SizedBox(height: 5),
          premadeTextField(
              Icon(Icons.person_outline, color: Colors.grey[700]), 'Username'),
          premadeTextField(
              Icon(Icons.mail_outline, color: Colors.grey[700]), 'Email'),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) =>
                        StatefulBuilder(builder: ((context, setState) {
                          TextFormField premadePasswordField(
                              Icon icon, String text) {
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
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  floatingLabelStyle:
                                      const TextStyle(color: Colors.blue),
                                  prefixIcon: icon,
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide:
                                          const BorderSide(color: Colors.blue)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      borderSide:
                                          const BorderSide(color: Colors.blue)),
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

                          return AlertDialog(
                            surfaceTintColor: Colors.transparent,
                            title: const Text(
                              'Enter current password',
                              style: TextStyle(fontSize: 25),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                premadePasswordField(
                                    Icon(
                                      Icons.lock_outline,
                                      color: Colors.grey[700],
                                    ),
                                    'Password'),
                              ],
                            ),
                            actions: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    recoverDialogPassword();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text('Confirm'),
                                ),
                              ),
                            ],
                          );
                        })));
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Change password')),
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
      ),
    );
  }

  TextFormField premadePasswordField(Icon icon, String text) {
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

  void recoverDialogPassword() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
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
              title: const Text('Make a new password',
                  style: TextStyle(fontSize: 25)),
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
}

//add change avatar