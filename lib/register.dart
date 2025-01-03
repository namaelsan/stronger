import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:stronger/mainMenu.dart';
import 'mylib.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Handle registration
  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      // Show error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    // Check if the user folder already exists
    final userExists = await _checkUserExists(username);
    if (userExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Username already exists. Please choose another.")),
      );
      return;
    }

    // Create the user foldera
    final userFolder = await _createUserFolder(username);

    // Save the username, email, and password in a text file
    await _saveUserInfo(userFolder, username, email, password);

    // Save the current user in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUser', username);

    // Navigate to the main menu
    Navigator.pop(context);
  }

  // Check if the user folder already exists
  Future<bool> _checkUserExists(String username) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final userFolder = Directory('${directory.path}/$username');
      return await userFolder.exists();
    } catch (e) {
      print("Error checking user existence: $e");
      return false;
    }
  }

  // Create a folder for the user
  Future<Directory> _createUserFolder(String username) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final userFolder = Directory('${directory.path}/$username');
      await userFolder.create(recursive: true);
      print("User folder created at: ${userFolder.path}");
      return userFolder;
    } catch (e) {
      print("Error creating user folder: $e");
      rethrow;
    }
  }

  // Save the username, email, and password in a text file
  Future<void> _saveUserInfo(Directory userFolder, String username, String email, String password) async {
    try {
      final userInfoFile = File('${userFolder.path}/user_info.txt');
      final userInfo = 'Username: $username\nEmail: $email\nPassword: $password';
      await userInfoFile.writeAsString(userInfo);
      print("User info saved at: ${userInfoFile.path}");
    } catch (e) {
      print("Error saving user info: $e");
      rethrow;
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: screenSize.height * 0.1,
                  child: Stack(
                    children: [
                      Text(
                        "REGISTER",
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 7
                            ..color = AppTheme.colorDark1,
                        ),
                        textScaler: TextScaler.linear(1.25),
                      ),
                      Text(
                        "REGISTER",
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
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
                            onPressed: _register,
                            child: Text(
                              "REGISTER",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
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
      ),
    );
  }
}