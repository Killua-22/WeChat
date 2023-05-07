import 'package:chat_app/Authenticate/CreateAccount.dart';
import 'package:chat_app/Screens/HomeScreen.dart';
import 'package:chat_app/Authenticate/Methods.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF1B202D),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 10,
                ),
                Container(
                  width: size.width / 1.1,
                  child: Text(
                    "WeChat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: size.height / 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          color: Color(0xFF292F3F),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          )),
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: size.height / 10,
                            ),
                            Container(
                              width: size.width,
                              alignment: Alignment.center,
                              child: field(
                                  size, "email", Icons.account_box, _email),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Container(
                                width: size.width,
                                alignment: Alignment.center,
                                child: field(
                                    size, "password", Icons.lock, _password),
                              ),
                            ),
                            SizedBox(
                              height: size.height / 10,
                            ),
                            customButton(size),
                            SizedBox(
                              height: size.height / 55,
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => CreateAccount())),
                              child: Text(
                                "                            Create Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height / 9,
                            )
                          ]),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              print("Login Sucessfull");
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else {
              print("Login Failed");
              setState(() {
                isLoading = false;
              });
            }
          });
        } else {
          print("Please fill form correctly");
        }
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(206),
            color: Color(0xFF225EE4),
          ),
          alignment: Alignment.center,
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  Widget field(
      Size size, String hintText, IconData icon, TextEditingController cont) {
    return Container(
      height: size.height / 14,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFF373E4E),
          prefixIcon: Icon(icon),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(206),
          ),
        ),
      ),
    );
  }
}
