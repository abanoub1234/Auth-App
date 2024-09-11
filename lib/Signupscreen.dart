import 'dart:io';
import 'package:auth_flutter/Loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'OTPScreen.dart';

class Signupscreen extends StatefulWidget {
  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  File? imagefile;
  TextEditingController emailValue = TextEditingController();
  TextEditingController userValue = TextEditingController();
  TextEditingController phoneValue = TextEditingController();
  TextEditingController passwordValue = TextEditingController();
  final _auth = FirebaseAuth.instance;

  void _verifyPhoneNumber() async {
    String phoneNumber = phoneValue.text.trim();

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('Verification failed: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(verificationId: verificationId),),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
      },
    );
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagefile = File(file!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    child: ClipOval(
                      child: imagefile == null
                          ? Image.asset('assets/images/user.png', width: 100, height: 100, fit: BoxFit.fill,)
                          : Image.file(imagefile!, width: 100, height: 100, fit: BoxFit.fill,),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: userValue,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: phoneValue,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailValue,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordValue,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _auth.createUserWithEmailAndPassword(
                        email: emailValue.text,
                        password: passwordValue.text,
                      );
                      _verifyPhoneNumber();
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign up failed: ${e.toString()}')),
                      );
                    }
                  },
                  child: Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                ),

              SizedBox(height: 40),
              ElevatedButton(
                onPressed: ()
                {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginscreen()),);
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
