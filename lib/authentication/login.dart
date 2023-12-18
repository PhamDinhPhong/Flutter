import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/authentication/register.dart';
import 'package:demo/global/global.dart';
import 'package:demo/mainScreen/home_screen.dart';
import 'package:demo/models/users.dart';
import 'package:demo/provider/form_state.dart';
import 'package:demo/splashScreen/splash_sreen.dart';
import 'package:demo/widgets/custom_text_field.dart';
import 'package:demo/widgets/error_dialog.dart';
import 'package:demo/widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please write email & password",
            );
          });
    }
  }


  // Future<void> launch(String url, {bool isNewTab = true}) async {
  //   await launchUrl(
  //     Uri.parse(url),
  //     webOnlyWindowName: isNewTab ? '_blank' : '_self',
  //   );
  // }



  _handleGoogleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await firebaseAuth.signInWithCredential(credential);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Checking Credentials",
          );
        }
    );

    User? currentUser;
    print(currentUser);
    @override
    Future<void> initState() async {
      super.initState();
      _auth.authStateChanges().listen((event) {
        setState(() {
          currentUser = event;
        });
      });
    }

    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      readDataAndSetLocally(currentUser!);
    }
  }

  Future readDataAndSetLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        if (snapshot.data()!["status"] == "approved") {
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!
              .setString("email", snapshot.data()!["email"]);
          await sharedPreferences!.setString("uid", snapshot.data()!["name"]);
          await sharedPreferences!.setString("photoUrl", snapshot.data()!["photoUrl"]);

          List<String> userCartList =
              snapshot.data()!["userCart"].cast<String>();

          await sharedPreferences!.setStringList("userCart", userCartList);

          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => HomeScreen()));
        } else {
          firebaseAuth.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Admin has blocked your account");
        }
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => SplashSreen()));
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "No record found",
              );
            }
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Login Screen",
          style: TextStyle(
            fontSize: 20,
            color: foodbloodcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Consumer<LoginFormData>(
                builder: (context, loginFormData, _) => TextButton(
                    onPressed: loginFormData.isButtonEnabled()
                        ? () {
                            formValidation();
                          }
                        : null,
                    child: Text("Continue",
                        style: TextStyle(
                          color: loginFormData.isButtonEnabled()
                              ? foodbloodcolor
                              : Colors.grey,
                        )
                    )
                )
            ),
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(
                        Icons.message_outlined,
                        color: foodbloodcolor,
                        size: 100,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "Info",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    GestureDetector(
                      onTap: () {
                        _handleGoogleSignIn();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Sign in with Google",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      "We'll check if you have an account",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        CustomTextField(
                          data: Icons.email,
                          controller: emailController,
                          hintText: "Email",
                          isObsecre: false,
                          onChanged: (value) {
                            Provider.of<LoginFormData>(context, listen: false)
                                .email = value;
                          },
                        ),
                        CustomTextField(
                          data: Icons.lock,
                          controller: passwordController,
                          hintText: "Password",
                          isObsecre: true,
                          onChanged: (value) {
                            Provider.of<LoginFormData>(context, listen: false)
                                .password = value;
                          },
                        )
                      ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Doesn't have an account",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => RegisterScreen()));
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: foodbloodcolor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}



