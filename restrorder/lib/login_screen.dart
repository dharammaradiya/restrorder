// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restrorder/Cash%20Counter/dashboadr_screen.dart';
import 'package:restrorder/Kitchen/dashboard_screen.dart';
import 'package:restrorder/Waiter/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    void login() async {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const WaiterDashboardScreen(),
      //   ),
      // );
      // await FirebaseAuth.instance.signInWithEmailAndPassword(
      //     email: email.text, password: password.text);

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        final user = FirebaseAuth.instance.currentUser?.uid;
        if (user == 'RanOq51R8aNmi8mIbQwYS8puqqW2') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const CashCounterDashboardScreen(),
          ));
          Fluttertoast.showToast(
            msg: "Login Success!",
            backgroundColor: const Color.fromARGB(255, 234, 234, 249),
            fontSize: 16,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (user == '97dpNnS4rnWVajRParsw3l7Cy0S2') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const KitchenDashboardScreen(),
          ));
          Fluttertoast.showToast(
            msg: "Login Success!",
            backgroundColor: const Color.fromARGB(255, 234, 234, 249),
            fontSize: 16,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (user == 'WzFn0MF7bpMwT4QdpYXrJKl0aBh1') {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const WaiterDashboardScreen(),
          ));
          Fluttertoast.showToast(
            msg: "Login Success!",
            backgroundColor: const Color.fromARGB(255, 234, 234, 249),
            fontSize: 16,
            gravity: ToastGravity.BOTTOM,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Navigator.of(context).pop();
          Fluttertoast.showToast(
            msg: "Please Enter Valid Login Credential",
            backgroundColor: const Color.fromARGB(255, 234, 234, 249),
            fontSize: 16,
            gravity: ToastGravity.CENTER,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Login Failed!!",
          backgroundColor: const Color.fromARGB(255, 234, 234, 249),
          fontSize: 16,
          gravity: ToastGravity.BOTTOM,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_LONG,
        );
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const SizedBox(
                    height: 200,
                    child: Image(
                      image: AssetImage('Assets/Images/logoblack.png'),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 150, right: 150),
                  child: TextField(
                    controller: email,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Icon(
                          Icons.mail,
                          color: Color.fromARGB(255, 0, 0, 2),
                        ),
                      ),
                      fillColor: const Color.fromARGB(255, 242, 242, 242),
                      filled: true,
                      hintText: "Enter your email",
                      hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                          color: Color.fromARGB(255, 21, 41, 74),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                          color: Color.fromARGB(255, 21, 41, 74),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 2,
                          style: BorderStyle.solid,
                          color: Color.fromARGB(255, 21, 41, 74),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 150, right: 150),
                  child: TextField(
                    controller: password,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(12),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10.0),
                          child: Icon(
                            FontAwesomeIcons.key,
                            color: Color.fromARGB(255, 0, 0, 2),
                          ),
                        ),
                        fillColor: const Color.fromARGB(255, 242, 242, 242),
                        filled: true,
                        hintText: "Enter password",
                        hintStyle: const TextStyle(fontWeight: FontWeight.w600),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                style: BorderStyle.solid,
                                color: Color.fromARGB(255, 21, 41, 74)),
                            borderRadius: BorderRadius.circular(12)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                style: BorderStyle.solid,
                                color: Color.fromARGB(255, 21, 41, 74)),
                            borderRadius: BorderRadius.circular(12)),
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                style: BorderStyle.solid,
                                color: Color.fromARGB(255, 21, 41, 74)),
                            borderRadius: BorderRadius.circular(12))),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 28.0, right: 150, left: 150),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Color.fromARGB(255, 255, 81, 0),
                    ),
                    onPressed: () {
                      login();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Login ",
                            style: GoogleFonts.roboto(
                                textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900)),
                          ),
                          const Icon(
                            FontAwesomeIcons.arrowRight,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
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
