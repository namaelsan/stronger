import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'mylib.dart';
import 'login.dart'; // Import the login page for navigation after logout

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Handle logout
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUser'); // Remove the current user from SharedPreferences

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Show a popup to change user credentials
  void _navigateToChangeCredentials(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUsername = prefs.getString('currentUser');

    if (currentUsername == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user is currently logged in")),
      );
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final userFolder = Directory('${directory.path}/$currentUsername');
    final userInfoFile = File('${userFolder.path}/user_info.txt');

    if (!await userInfoFile.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User data not found")),
      );
      return;
    }

    // Read the current user info
    final contents = await userInfoFile.readAsString();
    final lines = contents.split('\n');

    String currentEmail = '';
    for (var line in lines) {
      if (line.startsWith('Email:')) {
        currentEmail = line.split(':')[1].trim();
        break;
      }
    }

    // Controllers for the text fields
    final newUsernameController = TextEditingController(text: currentUsername);
    final newEmailController = TextEditingController(text: currentEmail);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          title: Text("Change User Credentials",style: AppTheme.myTheme.textTheme.headlineSmall?.copyWith(color: Colors.black),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: newUsernameController,
                decoration: InputDecoration(
                  labelText: "New Username",
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: newEmailController,
                decoration: InputDecoration(
                  labelText: "New Email",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final newUsername = newUsernameController.text.trim();
                final newEmail = newEmailController.text.trim();

                if (newUsername.isEmpty || newEmail.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill in all fields")),
                  );
                  return;
                }

                // Check if the new username already exists
                final newUserFolder = Directory('${directory.path}/$newUsername');
                if (await newUserFolder.exists() && newUsername != currentUsername) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Username already exists")),
                  );
                  return;
                }

                // Update the user info file
                final newUserInfo = 'Username: $newUsername\nEmail: $newEmail\nPassword: ${lines[2].split(':')[1].trim()}';
                await userInfoFile.writeAsString(newUserInfo);

                // Rename the user folder if the username has changed
                if (newUsername != currentUsername) {
                  await userFolder.rename(newUserFolder.path);
                  await prefs.setString('currentUser', newUsername);
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Credentials updated successfully")),
                );
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReusableWidgets.myBackgroundGradient(
        ListView(
          padding: const EdgeInsets.all(16.0),
          children: [Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Change User Credentials Button
              ElevatedButton(
                onPressed: () => _navigateToChangeCredentials(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colorLight2,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Change User Credentials",
                  style: AppTheme.myTheme.textTheme.labelMedium?.copyWith(color: Colors.black)
                ),
              ),
              SizedBox(height: 20), // Spacing between buttons
              // Logout Button
              ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.colorLight2,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Logout",
                  style: AppTheme.myTheme.textTheme.labelMedium?.copyWith(color: Colors.black)
                ),
              ),
            ],
          )],
        ),
      ),
    );
  }
}