import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/profile_edit.dart';
import 'package:untitled/provider.dart';
import 'main.dart';

class UserProfile extends StatefulWidget {
  static const String routeName = '/UserProfile';

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final personProvider = Provider.of<PersonDetailProvider>(context, listen: false);

    if (personProvider.personList != "") {
      _usernameController.text = personProvider.personList.FullName;
      _emailController.text = personProvider.personList.Usergemail;
      _passwordController.text = personProvider.personList.Password;
    }
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonDetailProvider>(context);

    // if (personProvider.status == "data") {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     personProvider.resetStatus();
    //     Navigator.pushNamed(context, LoginScreen.routeName);
    //   });
    // }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text('User Profile')),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.blueAccent,
                  size: 28,
                ),
                tooltip: 'Edit Profile',
                onPressed: () {
                  Navigator.pushNamed(context, EditProfile.routeName);
                },
                splashRadius: 24,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Center(
                child: CircleAvatar(
                  radius: 80,
                  child: Icon(Icons.person, size: 80, color: Colors.grey[400]),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm Deletion'),
                      content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            personProvider.deletePersonListFromAPI(
                              _usernameController.text,
                              _emailController.text,
                              _passwordController.text,
                            ).then((result) {
                              Navigator.of(context).pop();
                              if (result) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Center(child: Text('Account deleted successfully.'))),
                                );
                                personProvider.resetStatus();
                                Navigator.pushNamed(context, LoginScreen.routeName);
                                // Navigator.pushNamed(context, LoginScreen.routeName);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to delete account.')),
                                );
                              }
                            });
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Delete'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  personProvider.resetStatus();
                  Navigator.pushNamed(context, LoginScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('Log Out'),
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

