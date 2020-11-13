import 'dart:convert';
import 'dart:io';
import 'dart:async';



import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/main.dart';
import 'package:path_provider/path_provider.dart';


// Handles route for quiz cards

class GetData extends StatelessWidget{
  @override
  Widget build (BuildContext context){
    return FutureBuilder(
      // load quiz data from json
      future: DefaultAssetBundle.of(context).loadString("assests/data.json"),
      builder: (context, snapshot){
        List mydata=jsonDecode(snapshot.data.toString());
        if(mydata==null){
          return Scaffold(
            body:Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        }else{
          return QuizPage( mydata : mydata , storage : Storage());
        }
      },
    );
  }
}


// ignore: must_be_immutable
class QuizPage extends StatefulWidget{
  final mydata;
  final storage;
  QuizPage({
    Key key,
    @required this.mydata,@required this.storage,
  }) : super (key:key);
  @override
  QuizpageState createState() => QuizpageState(mydata,storage);
}


class Storage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/db.txt');
  }

  Future <String> readData() async {
    final file=await _localFile;
    String body=await file.readAsString();
    return body;
  }
  Future <File> writeData(String data) async {
    final file= await _localFile;
    return file.writeAsString("$data");
  }

}



class QuizpageState extends State<QuizPage>{
  var mydata;
  Storage storage;
  TextEditingController controller=TextEditingController();
  String state;
  QuizpageState(this.mydata,this.storage);

  bool isEnabled = false ;

  enableButton(){

    setState(() {
      isEnabled = true;
    });
  }



  disableButton(){

    setState(() {
      isEnabled = false;
    });
  }

// function used reload the state with updated arguments
  sampleFunction() async {
    int temp=currentQuestion;

    setState(() {
      if (currentQuestion < 4){
        currentQuestion = currentQuestion + 1;
      marks = current + marks;
      current = 0;
      isEnabled = false;
      btncolor.forEach((k, v) {
        btncolor[k] = Colors.indigo;
      });
    }
    });
    if(temp == 4){
      marks = current + marks;
      // used to store data in file
      storage.writeData(marks.toString());
      Navigator.pushReplacement(context , MaterialPageRoute
        (builder: (context) => MyApp()
      ),);
      //print(await storage.readData());
    }
    //storage.writeData(marks.toString());
    // print(await storage.readData());
    // print('Clicked');
    // print(current);
    // print(marks);
  }

  int marks=0;

  int current=0;

  Color yellow=Colors.orange;

  int currentQuestion=1;

  Map<String , Color > btncolor ={
    "a": Colors.indigo,
    "b": Colors.indigo,
    "c": Colors.indigo,
    "d": Colors.indigo,
  };

  void checkanswer(String cdata){
    if(mydata[2][currentQuestion.toString()]==mydata[1][currentQuestion.toString()][cdata]){
        current= current +1 ;
    }else{
      current=0;
    }
    var colordisplay=yellow;
    setState(() {
      btncolor.forEach((k,v){
        if(k!=cdata){
          btncolor[k]=Colors.indigo;
        }
      });
      btncolor[cdata]=colordisplay;
    });
  }
  Widget selectionbutton(String choicedata){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: (){
          setState(() {
            checkanswer(choicedata);
            enableButton();
          });
        },
        child: Text(
          mydata[1][currentQuestion.toString()][choicedata],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Alike",
            fontSize: 16.0,
          ),
        ),
        color: btncolor[choicedata],
        splashColor: Colors.indigoAccent,
        minWidth: 200.0,
        height: 45.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return showDialog(
        context: context,
        builder:(context)=>AlertDialog(
          title: Text ("Quiz Card",),
          content: Text("You cant exit during quiz"),
          actions:<Widget> [
            FlatButton(onPressed: (){
              Navigator.of(context).pop();
              },
                child :Text('OK',) )
          ],
        ));
      },
      child: Scaffold(
        body: Column (
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.bottomLeft,
                child: Text(
                  mydata[0][currentQuestion.toString()],
                  style:TextStyle(
                    fontSize: 20.0,
                    fontFamily: "Quando",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    selectionbutton('a'),
                    selectionbutton('b'),
                    selectionbutton('c'),
                    selectionbutton('d'),
                  ],
                ),

              ),
            ),
        Expanded(
          flex: 2,
          child: MaterialButton(
            minWidth: 250.0,
            height: 65.0,
            //alignment: Alignment.bottomRight,
            onPressed: () {  },
            child: isEnabled ?  RaisedButton(
              onPressed:isEnabled ?()  => sampleFunction() : null,
              color: Colors.green,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),

              child:  (currentQuestion>=4) ? Text('End') : Text('Next'),
            ): Container(),
          ),
        ),
        ],
      )
      ),
    );
  }
}