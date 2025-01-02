import 'package:flutter/material.dart';
import 'package:stronger/mainMenu.dart';
import 'mylib.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Text(
        "Stronger",
        style: Theme.of(context).textTheme.headlineMedium,
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: screenSize.height * 0.1,
              child: Stack(children: [
                Text("LOGIN",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 7
                            ..color = AppTheme.colorDark1,
                        ),
                    textScaler: TextScaler.linear(1.25)),
                Text("LOGIN",
                    style: Theme.of(context).textTheme.headlineLarge,
                    textScaler: TextScaler.linear(1.25)),
              ]),
            ),
            Container(
              padding: EdgeInsets.all(15),
              color: AppTheme.colorLight2,
              height: screenSize.height * 0.35,
              width: screenSize.width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Email",
                      alignLabelWithHint: true,
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      alignLabelWithHint: true,
                    ),
                  ),
                  Container(
                    height: screenSize.height * 0.05,
                    child: ElevatedButton(
                      onPressed: () {
                        // Replace the login page with the main menu
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainMenu()),
                        );
                      },
                      child: Text(
                        "LOGIN",
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      style: ButtonStyle(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
