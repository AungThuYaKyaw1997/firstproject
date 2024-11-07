import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/profile.dart';
import 'package:untitled/profile_edit.dart';
import 'package:untitled/provider.dart';
import 'package:untitled/register.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PersonDetailProvider()),
        // ChangeNotifierProvider(create: (_) => DeleteDetailProvider()),
      ],
      child: MaterialApp(
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (context) => LoginScreen(),
          Register.routeName: (context) => Register(),
          UserProfile.routeName: (context) => UserProfile(),
          EditProfile.routeName: (context) => EditProfile(),

        },
      ),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  static const String routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _username= TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final personProvider = Provider.of<PersonDetailProvider>(context);
    if (personProvider.status == "data") {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        personProvider.resetStatus();
        Navigator.pushNamed(context, UserProfile.routeName);
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                // Email TextField
                TextField(
                  controller: _username,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                TextField(
                  controller: _password,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Password',
                    // border: UnderlineInputBorder(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    personProvider.loginPersonListFromAPI(
                      _username.text,
                      _password.text,
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Use backgroundColor instead of primary
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                // Forgot Password Link
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Register.routeName);
                  },
                  child: Text(
                    'Account Register?',
                    style: TextStyle(color: Colors.blue),
                  ),
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
                Spacer(),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
