import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isHidden = true;
  bool isHidden2 = true;
  bool isHidden3 = true;
  String username = "John Doe";
  String email = "johndoe@example.com";

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
                  "https://placeimg.com/640/480/people",
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  mini: true, // Set mini for a smaller button
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return
                          SimpleDialog(
                            title: Text('Choose an option'),
                            children: <Widget>[
                              SimpleDialogOption(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final pickedFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  // Handle the selected image file
                                  if (pickedFile != null) {
                                    print(
                                        'Selected image from gallery: ${pickedFile.path}');
                                  }
                                },
                                child: Text('Open device files'),
                              ),
                              SimpleDialogOption(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  if (await Permission.camera
                                      .request()
                                      .isGranted) {
                                    final pickedFile = await ImagePicker()
                                        .pickImage(source: ImageSource.camera);
                                    if (pickedFile != null) {
                                      print(
                                          'Captured image from camera: ${pickedFile.path}');
                                    }
                                  } else {
                                    // Handle the case when permission is not granted
                                    print(
                                        'Permission to access camera is denied');
                                  }
                                },
                                child: Text('Open camera app'),
                              ),
                            ],
                          );
                        });
                  },
                  child: const Icon(
                      Icons.camera_alt_outlined), // Change avatar icon
                ),
              ),
            ],
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