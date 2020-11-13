import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  //This widget is for first form displaying
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Quiz App"),
        ),
        body: Container(
          margin: const EdgeInsets.all(10.0),

          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                   PersonalInformationForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class PersonalInformationForm extends StatefulWidget {
  @override
  PersonalInformationFormState createState() {
    return PersonalInformationFormState();
  }
}

class PersonalInformationFormState extends State<PersonalInformationForm> {

  bool isEnabled=false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController;
  TextEditingController lastNameController;
  TextEditingController nickNameController;
  TextEditingController ageController;

  String scoreText='';
  String firstName;
  String familyName;
  String nickName;
  String age;

//Get values from stored data
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    print("my path is " + path);
    File _localFile = File('$path/db.txt');
    String scoreFromFile='';
    bool tempvar=false;


    try {
      scoreFromFile = await _localFile.readAsString();
      if (scoreFromFile != null) {
        tempvar=true;
        print(scoreFromFile);
        print("File found. Reading the score from the file");
      }
    } catch (e) {
      print("No file found, User haven't attempted any quiz yet.");
    }
    setState(() {
      // set or store values on done
      scoreText=scoreFromFile;
      firstNameController = TextEditingController(text: prefs.getString('FirstName') ?? '');
      lastNameController = TextEditingController(text: prefs.getString('FamilyName') ?? '');
      nickNameController = TextEditingController(text: prefs.getString('NickName') ?? '');
      ageController = TextEditingController(text: prefs.getString('Age') ?? '');
      isEnabled=tempvar;

    });
  }

  @override
  void initState() {
    super.initState();
    // used to get stored data
    getSharedPrefs();
  }

  //individual widgets for each field first , familyname, nick anme , age


  Widget firstNameWidget(){
    return Expanded(
        child: TextFormField (
          controller: firstNameController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter first name';
            }
            return null;
          },
          onSaved: (value) {
            setState(() {
              firstName = firstNameController.text;
            });
          },
          decoration: InputDecoration(
            labelText: 'First Name',
            labelStyle: TextStyle(
              fontSize: 22,
            ),
            border: OutlineInputBorder(),
          ),
        )
    );
  }

  Widget lastNameWidget(){
    return
      Expanded(
          child: TextFormField (
            controller: lastNameController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter last name';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                familyName = lastNameController.text;
              });
            },
            decoration: InputDecoration(
              labelText: 'Family Name',
              labelStyle: TextStyle(
                fontSize: 22,
              ),
              border: OutlineInputBorder(),
            ),
          )
      );
  }

  Widget nickNameWidget(){
    return
    Expanded(
        child: TextFormField (
          controller: nickNameController,
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter your nickname';
            }
            return null;
          },
          onSaved: (value) {
            setState(() {
              nickName = nickNameController.text;
            });
          },
          decoration: InputDecoration(
            labelText: 'Nick Name',
            labelStyle: TextStyle(
              fontSize: 22,
            ),
            border: OutlineInputBorder(),
          ),
        )
    );
  }

  Widget ageWidget(){
    return
      Expanded(
          child: TextFormField (
            controller: ageController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter your age';
              }
              if(int.tryParse(value) <= 0) {
                return 'Invalid age';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                age = ageController.text;
              });
            },
            decoration: InputDecoration(
              labelText: 'Age',
              labelStyle: TextStyle(
                fontSize: 22,
              ),
              border: OutlineInputBorder(),
            ),
          )
      );

  }

  // on submit storage of values

  Widget submitWidget(){
    return Container(
        height: 50,
        width: 150,
        child: RaisedButton(
          child:Text('Done'),
          onPressed: () async {
            // Validate returns true if the form is valid, or false
            // otherwise.
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              final prefs = await SharedPreferences.getInstance();
              prefs.setString('FirstName', firstName);
              prefs.setString('FamilyName', familyName);
              prefs.setString('NickName', nickName);
              prefs.setString('Age', age);
              Navigator.push(context , MaterialPageRoute
                (builder: (context) => GetData()
              ),);


            }
          },
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Personal Info",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 17,
            ),
            Row(
              children: <Widget>[
                firstNameWidget(),
              ],
            ),
            Container(
              height: 17,
            ),
            Row(
              children: <Widget>[
                lastNameWidget(),
              ],
            ),
            Container(
              height: 17,
            ),
            Row(
              children: <Widget>[
                nickNameWidget()
              ],
            ),
            Container(
              height: 17,
            ),
            Row(
              children: <Widget>[
                ageWidget(),
              ],
            ),
            Container(
              height: 20,
            ),

            Row(
                children: <Widget>[
                Expanded(
                  // shown only when score is present in file 
                  child : isEnabled ? Center(
                  child : Text ("Latest Quiz Score is $scoreText",
                  style: TextStyle(
                    //color: Colors.Black,
                    fontFamily: "Alike",
                    fontSize: 25.0,
                  ),)
                ) : Container())]),
           // Text(scoreText),
            Container(
              height: 15,
            ),
            submitWidget(),

          ]
      ),
    );
  }
}