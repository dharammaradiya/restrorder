// ignore: file_names
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restrorder/Waiter/dashboardScreen.dart';
import 'package:restrorder/Waiter/waiterData.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(Consts.concatMap);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    void login() async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WaiterDashboardScreen(),
        ),
      );
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
                  onTap: () {
                    print(Consts.concatMap);
                  },
                  child: const Image(
                    image: AssetImage('Assets/Images/logoblack.png'),
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
                      hintText: "Your Email",
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
                        hintText: "Your Password",
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
                        backgroundColor: const Color.fromARGB(255, 21, 41, 74)),
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
                            "Get Started  ",
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
