import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/registerclass.dart';
import 'dart:convert';

class PersonDetailProvider extends ChangeNotifier {
  String status = "idle"; // idle | loading | data | error
  String errorMessage = "";

  List<Person> personLists = [];

  Person personList = Person(FullName: "John Doe", Usergemail: "john.doe@example.com", Password: "password123");

  void resetStatus() {
    status = "";
    errorMessage = "";
    notifyListeners();
  }


  Future<bool> getPersonListFromAPI(String fullName, String userEmail, String password) async {
    status = "loading";
    errorMessage = "";
    notifyListeners();
    Dio client = Dio();
    String endPoint = "http://zaw533150-001-site1.ltempurl.com/login/mobile";

    try {
      Map<String, dynamic> jsonData = {
        'FullName': fullName,
        'Usergemail': userEmail,
        'Password': password,
      };


      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('11202118:60-dayfreetrial'));

      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': basicAuth,
        },
      );

      Response response = await client.post(endPoint, data: jsonData, options: options);

      if (response.statusCode == 200) {
        print("Registration successful: ${response.data}");

        // Person newPerson = Person(
        //   FullName: fullName,
        //   Usergemail: userEmail,
        //   Password: password,
        // );
        //
        // personList.add(newPerson);
        personList.FullName = fullName;
        personList.Usergemail = userEmail;
        personList.Password = password;
        print(personList);
        status = "data";
        notifyListeners();
        return true;
      } else {
        print("Failed to register. Status: ${response.statusCode}");
        status = "error";
        errorMessage = "Failed to register with status: ${response.statusCode}";
        notifyListeners();
        return false;
      }
    } catch (exp, stackTrace) {
      print("PersonDetailProvider->API exception");
      print(exp);
      print(stackTrace);
      status = "error";
      errorMessage = exp.toString();
      notifyListeners();
      return false;
    }
  }



  Future<bool> loginPersonListFromAPI(String userEmail, String password) async {
    status = "loading";
    errorMessage = "";
    notifyListeners();

    Dio client = Dio();
    String endPoint = "http://zaw533150-001-site1.ltempurl.com/login/user";

    try {
      Map<String, dynamic> jsonData = {
        'Usergemail': userEmail,
        'Password': password,
      };

      String basicAuth = 'Basic ' + base64Encode(utf8.encode('11202118:60-dayfreetrial'));

      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': basicAuth,
        },
      );

      Response response = await client.post(endPoint, data: jsonData, options: options);

      if (response.statusCode == 200) {
        print("Response Data: ${response.data}");
        if (response.data != null) {
          var person = Person.fromJson(response.data);
          // print("Full Name: ${person.FullName}, Email: ${person.Usergemail}, Password: ${person.Password}");
          // personList.add(person);
          personList.FullName = person.FullName;
          personList.Usergemail = person.Usergemail;
          personList.Password = person.Password;

          status = "data";
          notifyListeners();
          return true;
        } else {
          errorMessage = "Email and Password Incorrect!";
        }
      } else {
        print("Failed to register. Status: ${response.statusCode}");
        status = "error";
        errorMessage = "Failed to register with status: ${response.statusCode}";
      }

    } catch (exp, stackTrace) {
      print("PersonDetailProvider->API exception");
      print(exp);
      print(stackTrace);
      status = "error";
      errorMessage = exp.toString();
      notifyListeners();
      return false;
    }


    return false;
  }



  Future<bool> deletePersonListFromAPI(String fullName, String userEmail, String password) async {
    status = "loading";
    errorMessage = "";
    notifyListeners();
    Dio client = Dio();
    String endPoint = "http://zaw533150-001-site1.ltempurl.com/delete/person";

    try {
      Map<String, dynamic> jsonData = {
        'FullName': fullName,
        'Usergemail': userEmail,
        'Password': password,
      };

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('11202118:60-dayfreetrial'));

      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': basicAuth,
        },
      );

      Response response = await client.delete(endPoint, data: jsonData, options: options);

      if (response.statusCode == 200) {
        status = "data";
        notifyListeners();
        return true;
      } else {
        print("Failed to register. Status: ${response.statusCode}");
        status = "error";
        errorMessage = "Failed to register with status: ${response.statusCode}";
        notifyListeners();
        return false;
      }
    } catch (exp, stackTrace) {
      print("PersonDetailProvider->API exception");
      print(exp);
      print(stackTrace);
      status = "error";
      errorMessage = exp.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updatePersonListFromAPI(String fullName, String userEmail, String password) async {
    status = "loading";
    errorMessage = "";

    notifyListeners();
    Dio client = Dio();
    String endPoint = "http://zaw533150-001-site1.ltempurl.com/update/person";

    try {
      Map<String, dynamic> jsonData = {
        'FullName': fullName,
        'Usergemail': userEmail,
        'Password': password,
        'OldFullName':personList.FullName,
        'OldUsergemail':personList.Usergemail,
        'OldPassword':personList.Password,
      };
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('11202118:60-dayfreetrial'));

      Options options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': basicAuth,
        },
      );

      Response response = await client.put(endPoint, data: jsonData, options: options);

      if (response.statusCode == 200) {
        // personList.clear();
        // Person newPerson = Person(
        //   FullName: fullName,
        //   Usergemail: userEmail,
        //   Password: password,
        // );
        // personList.add(newPerson);
        personList.FullName = fullName;
        personList.Usergemail = userEmail;
        personList.Password = password;

        status = "data";
        notifyListeners();
        return true;
      } else {
        print("Failed to register. Status: ${response.statusCode}");
        status = "error";
        errorMessage = "Failed to register with status: ${response.statusCode}";
        notifyListeners();
        return false;
      }
    } catch (exp, stackTrace) {
      print("PersonDetailProvider->API exception");
      print(exp);
      print(stackTrace);
      status = "error";
      errorMessage = exp.toString();
      notifyListeners();
      return false;
    }
  }
}
