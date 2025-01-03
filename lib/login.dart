import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronger/mainMenu.dart';
import 'package:stronger/register.dart';
import 'mylib.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Check if the user folder exists and validate username and password
  Future<bool> _validateLogin(String username, String password) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final userFolder = Directory('${directory.path}/$username');

      if (await userFolder.exists()) {
        final userInfoFile = File('${userFolder.path}/user_info.txt');

        if (await userInfoFile.exists()) {
          final contents = await userInfoFile.readAsString();
          final lines = contents.split('\n');

          String storedUsername = '';
          String storedPassword = '';

          for (var line in lines) {
            if (line.startsWith('Username:')) {
              storedUsername = line.split(':')[1].trim();
            } else if (line.startsWith('Password:')) {
              storedPassword = line.split(':')[1].trim();
            }
          }

          if (storedUsername == username && storedPassword == password) {
            // Save the username in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('currentUser', username);
            return true; // Login successful
          }
        }
      }
    } catch (e) {
      print("Error validating login: $e");
    }
    return false; // Login failed
  }

  // Handle login button press
  Future<void> _handleLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      // Show error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your username and password")),
      );
      return;
    }

    // Validate the login
    final isValid = await _validateLogin(username, password);

    if (isValid) {
      // Navigate to the main menu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenu()),
      );
    } else {
      // Show error if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid username or password")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stronger",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: ReusableWidgets.myBackgroundGradient(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: screenSize.height * 0.1,
                child: Stack(
                  children: [
                    Text(
                      "LOGIN",
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 7
                                  ..color = AppTheme.colorDark1,
                              ),
                      textScaler: TextScaler.linear(1.25),
                    ),
                    Text(
                      "LOGIN",
                      style: Theme.of(context).textTheme.headlineLarge,
                      textScaler: TextScaler.linear(1.25),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.colorLight2,
                ),
                width: screenSize.width * 0.6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 35, 20, 35),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          alignLabelWithHint: true,
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          alignLabelWithHint: true,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        height: screenSize.height * 0.05,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          child: Text(
                            "LOGIN",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterPage(),
                            ),
                          );
                        },
                        child: Text(
                          textAlign: TextAlign.center,
                          "Don't have an account? Register here",
                          style: AppTheme.myTheme.textTheme.displaySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
