import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/profile.dart';
import 'package:untitled/provider.dart';

import 'main.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = '/EditProfile';

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final personProvider = Provider.of<PersonDetailProvider>(context, listen: false);
    if (personProvider.personList  != "") {
      _usernameController.text = personProvider.personList.FullName;
      _emailController.text = personProvider.personList.Usergemail;
      _passwordController.text = personProvider.personList.Password;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonDetailProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 80,
                  child: Icon(Icons.person, size: 80, color: Colors.grey[400]),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                // obscureText: true, // Hide password input
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm Changes'),
                      content: Text('Are you sure you want to save your changes?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog without saving
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Call the update function
                            personProvider.updatePersonListFromAPI(
                              _usernameController.text,
                              _emailController.text,
                              _passwordController.text,
                            ).then((result) {
                              // Navigator.of(context).pop();
                              if (result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Center(child: Text('Profile updated successfully.'))),
                                );
                                personProvider.resetStatus();
                                Navigator.pushNamed(context, UserProfile.routeName);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to update profile.')),
                                );
                              }
                            }).catchError((error) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error occurred: $error')),
                              );
                            });
                          },

                          child: Text('Update'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: Text('Save Changes'),
              ),
              if (personProvider.status == "loading")
                Center(child: CircularProgressIndicator())
              else if (personProvider.status == "error")
                Center(
                  child: Text(
                    personProvider.errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
